local NUI, E, L, V, P, G = _G.unpack(select(2, ...))
local NC = NUI.NihilistChat
local LSM = E.Libs.LSM
local LW = NUI.Libs.LibWho
local COMP = NUI.Compatibility
local ES = NUI.EnhancedShadows

function NC:InitializeChatSystem()
	self.dockedWindows = {}
	self.numLines = 2
	self.activeChat = nil

	self.chats = {}
	self.forcedEdit = false
	self.senderInfo = {}

	local tabFrame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	tabFrame:Point("CENTER", E.UIParent, "CENTER", 300, 300)
	tabFrame:SetScript(
		"OnDragStart",
		function(self)
			self:SetUserPlaced(true)
			self:StartMoving()
		end
	)
	tabFrame:SetScript(
		"OnDragStop",
		function(self)
			self:StopMovingOrSizing()
		end
	)
	tabFrame:CreateBackdrop("Transparent")
	tabFrame:EnableMouse(true)
	tabFrame:SetMovable(true)
	tabFrame:RegisterForDrag("LeftButton")

	tabFrame:CreateShadow()
	ES:RegisterFrameShadows(tabFrame)
	if (COMP.BUI) then
		tabFrame:BuiStyle("Outside")
		local BFM = _G.ElvUI_BenikUI[1].FlightMode
		hooksecurefunc(
			BFM,
			"SetFlightMode",
			function(self, status)
				if (status) then
					tabFrame:SetParent(self.FlightMode)
				else
					tabFrame:SetParent(E.UIParent)
				end
			end
		)
	end
	self.tabFrame = tabFrame
	self.tabs = {}
	self.tabPool = {}
	self.chatPool = {}
end

function NC:AcquireTab(chat)
	if (#self.tabPool > 0) then
		local tab = tremove(self.tabPool)
		self.tabs[chat] = tab
	else
		self:CreateTab(chat)
	end
end

function NC:ReleaseTab(chat)
	local tab = self.tabs[chat]
	if (tab) then
		tab:Hide()
		self.tabs[chat] = nil
		tinsert(self.tabPool, tab)
	end
end

function NC:CreateTab(chat)
	if (self.tabs[chat]) then
		return
	end
	local tab = CreateFrame("Button", nil, self.tabFrame, "BackdropTemplate")
	tab:SetTemplate("Transparent")
	tab:Size(64, 24)
	tab:SetText(chat.tabName)
	tab:Show()
	tab:SetScript(
		"OnClick",
		function(self, button, down)
			NC:ClickTab(self, not self.shown)
		end
	)
	local fs = tab:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate()
	fs:Size(60, 24)
	fs:SetJustifyH("CENTER")
	fs:Point("CENTER")
	fs:SetTextColor(1, 1, 1)
	tab:SetFontString(fs)
	tab.text = fs
	tab.Flash = CreateFrame("Frame")
	tab:CreateShadow()
	ES:RegisterFrameShadows(tab)
	self.tabs[chat] = tab
	self:UpdateTabs()
end

function NC:ShowTab(chat)
	if (not self.tabs[chat]) then
		return
	end
	if (not self.tabs[chat].forceHidden) then
		self.tabs[chat]:Show()
	end
	self:UpdateTabs()
end

function NC:HideTab(chat)
	if (not self.tabs[chat]) then
		return
	end
	self.tabs[chat]:Hide()
	self:UpdateTabs()
end

function NC:ClickTab(btn)
	local chat = tInvert(self.tabs)[btn]
	if (chat) then
		chat:Show()
		chat.active = true
		btn.Flash:SetScript("OnUpdate", nil)
		btn:SetTemplate("Transparent")
		self:StopFlash(btn.Flash)
		for k, v in pairs(self.tabs) do
			if (k ~= chat) then
				k:Hide()
				v:SetTemplate("Transparent")
				k.active = false
			end
		end
	end
end

function NC:UpdateTab(chat, text)
	if (not self.tabs[chat]) then
		return
	end
	self.tabs[chat].text:SetText(text)
end

function NC:UpdateTabs()
	local i = 1
	local shownTabs = false
	local foundActiveTab = false
	local tabs = {}
	local forceHiddenTab
	for chat, tab in pairs(self.tabs) do
		if (tab:IsShown() or (not chat.minimized and tab.forceHidden)) then
			shownTabs = true
			tab:ClearAllPoints()
			if i == 1 then
				tab:SetPoint("TOPLEFT", self.tabFrame, "TOPLEFT", 8, 0)
			else
				tab:SetPoint("LEFT", tabs[i - 1], "RIGHT", 4, 0)
			end
			if chat.active then
				foundActiveTab = true
			end
			if (tab.forceHidden) then
				forceHiddenTab = tab
			end
			tinsert(tabs, tab)
			i = i + 1
		end
	end

	if (shownTabs) then
		if (not foundActiveTab) then
			self:ClickTab(tabs[1])
		end
		local defaultWidth = NC.db.windows.width
		local tabWidth = ((i - 1) * 64) + ((i - 2) * 4) + 8

		local width = tabWidth > defaultWidth and tabWidth + 4 or defaultWidth + 4
		self.tabFrame:Size(width, NC.db.windows.height + 70)
		if (#tabs == 1) then
			local chat = tInvert(self.tabs)[tabs[1]]
			chat:SetPoint("TOPLEFT", self.tabFrame, "TOPLEFT")
			self.tabFrame:Size(defaultWidth, NC.db.windows.height + 46)
			tabs[1]:Hide()
			tabs[1].forceHidden = true
		elseif (forceHiddenTab) then
			forceHiddenTab:Show()
			local chat = tInvert(self.tabs)[forceHiddenTab]
			chat:SetPoint("TOPLEFT", self.tabFrame, "TOPLEFT", 0, -24)
			forceHiddenTab.forceHidden = false
		end
	end
	self.tabFrame:SetShown(shownTabs)
end

function NC:GetDefaultEditBox()
	return FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK).editBox
end

function NC:UpdateDockedWindows()
	for key, chat in ipairs(self.dockedWindows) do
		chat:ClearAllPoints()
		if key == 1 then
			chat:SetPoint("TOPLEFT", NihilistChatDock, "TOPLEFT", 0, 0)
		else
			chat:SetPoint("TOP", self.dockedWindows[key - 1], "BOTTOM", 0, E:Scale(-13))
		end
		chat.DockedName:ClearAllPoints()
		chat.DockedName:SetPoint("TOPLEFT", chat, "TOPLEFT", 0, E:Scale(1))
	end
end

function NC:SetMinimized(chat)
	ChatEdit_DeactivateChat(chat.editBox)
	ChatEdit_ActivateChat(self:GetDefaultEditBox())
	ChatEdit_DeactivateChat(self:GetDefaultEditBox())
	chat.editBox:SetFrameStrata("LOW")
	local point, relativeTo, relativePoint, xOfs, yOfs = chat:GetPoint()
	chat.point = {point, relativeTo, relativePoint, xOfs, yOfs}
	self.forcedEdit = false
	chat:Size(E:Scale(4), E:Scale(1))
	chat.Bottom:Hide()
	chat:SetAlpha(0)
	chat.Text:SetAlpha(0)
	chat.Name:SetAlpha(0)
	chat.DockedName:SetAlpha(1)
	chat.CloseButton:Hide()
	chat.MinimizeButton:Hide()
	chat.InvisibleMaximizeButton:Show()

	chat.minimized = true

	table.insert(self.dockedWindows, chat)

	self:HideTab(chat)
	self:UpdateTabs()

	self:UpdateDockedWindows()
end

function NC:SetMaximized(chat)
	chat.Flash:SetScript("OnUpdate", nil)
	self:StopFlash(chat.DockedName)

	chat:SetAlpha(1)
	chat.Bottom:Show()
	chat.Text:SetAlpha(1)
	chat.CloseButton:Show()
	chat.InvisibleMaximizeButton:Hide()
	chat.MinimizeButton:Show()
	chat.Name:SetAlpha(1)
	chat.DockedName:SetAlpha(0)

	if not self.db.windows.showtitle then
		chat.Name:SetAlpha(0)
	end

	chat.minimized = false

	for i, v in ipairs(self.dockedWindows) do
		if v.target == chat.target then
			table.remove(self.dockedWindows, i)
			break
		end
	end

	self:UpdateDockedWindows()

	if (not self.tabs[chat].forceHidden) then
		self:ShowTab(chat)
	end
	self:UpdateTabs()

	chat:ClearAllPoints()
	if (self.tabs[chat].forceHidden) then
		chat:SetPoint("TOPLEFT", self.tabFrame, "TOPLEFT")
	else
		chat:SetPoint("TOPLEFT", self.tabFrame, "TOPLEFT", 0, -24)
	end
	chat:SetPoint("BOTTOMRIGHT", self.tabFrame, "BOTTOMRIGHT")

	self:ClickTab(self.tabs[chat])

	chat.editBox:SetFrameStrata("DIALOG")
end

function NC:OnMouseWheel(delta) -- Blizzard/Tukui credit
	if delta < 0 then
		if IsShiftKeyDown() then
			self.Text:ScrollToBottom()
		else
			for i = 1, NC.numLines do
				self.Text:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self.Text:ScrollToTop()
		else
			for i = 1, NC.numLines do
				self.Text:ScrollUp()
			end
		end
	end
end

function NC:OnEnterPressed(editBox) -- Add messages to the text
	local message = editBox:GetText()
	local chatType = editBox:GetAttribute("chatType")
	local chatTarget = editBox:GetAttribute("tellTarget")

	editBox:ClearFocus()
	editBox:SetAutoFocus(false)
	editBox.Backdrop:SetBackdropBorderColor(0, 0, 0)
	editBox.Backdrop:Hide()

	if (message == "" or message == " ") then
		ChatEdit_DeactivateChat(editBox)
		ChatEdit_ActivateChat(self:GetDefaultEditBox())
		ChatEdit_DeactivateChat(self:GetDefaultEditBox()) -- Hide it
		NC.forcedEdit = false
		return false
	end

	if (chatType == "BN_WHISPER") then -- BNet
		local id = BNet_GetBNetIDAccount(chatTarget)

		if id then
			BNSendWhisper(id, message)
			editBox:SetText("")
			return true
		end
	else
		SendChatMessage(message, chatType, nil, chatTarget)
		editBox:SetText("")
		if (chatType ~= editBox:GetAttribute("stickType")) then
			editBox:SetAttribute("chatType", editBox:GetAttribute("stickyType"))
		end
		return true
	end
end

function NC:AcquireChat(chatType, chatTarget)
	if (#self.chatPool > 0) then
		local chat = tremove(self.chatPool)
		chat.EditBox.chatType = chatType
		chat.EditBox:SetAttribute("chatType", chatType)
		chat.EditBox:SetAttribute("stickyType", chatType)
		chat.EditBox:SetAttribute("tellTarget", chatTarget)
		ChatFrame_AddPrivateMessageTarget(chat, chatTarget)

		chat.target = chatTarget
		self.chats[chatTarget] = chat
		self:AcquireTab(chat)
		if (InCombatLockdown()) or (self.db.windows.autohide) then -- Auto minimize incoming msg if in combat
			self:SetMinimized(chat)
			chat.Flash:SetScript(
				"OnUpdate",
				function()
					self:StartFlash(chat.DockedName, 0.6)
				end
			)
		else
			self:ShowTab(chat)
			self:UpdateTabs()
			self:ClickTab(self.tabs[chat], true)
		end
		return chat
	else
		return self:InitNewFrame(chatType, chatTarget)
	end
end

function NC:ReleaseChat(chat)
	if (chat) then
		chat:Hide()
		tinsert(self.chatPool, chat)
		chat.Text:Clear()
		ChatFrame_RemovePrivateMessageTarget(chat, chat.target)
		self.chats[chat.target] = nil
		chat.target = nil
	end
end

function NC:FindChat(chatTarget)
	for k, v in pairs(self.chats) do
		if k == chatTarget then
			return v
		end
	end
end

function NC:InitNewFrame(chatType, chatTarget)
	local chat = self:FindChat(chatTarget)
	if chat then
		return chat
	end

	local sendTo = chatTarget
	local chatColor = ChatTypeInfo[chatType]

	local bcolor = self.db.general.backdropcolor
	local rcolor = self.db.general.bordercolor

	chat = CreateFrame("Frame", nil, self.tabFrame, "BackdropTemplate")
	chat:CreateBackdrop("Transparent")
	chat.backdrop:SetAllPoints()
	chat:SetPoint("TOPLEFT", self.tabFrame, "TOPLEFT", 0, -24)
	chat:SetPoint("BOTTOMRIGHT", self.tabFrame, "BOTTOMRIGHT")
	chat.backdrop:SetBackdropColor(bcolor.r, bcolor.g, bcolor.b, self.db.general.alpha)
	chat.backdrop:SetBackdropBorderColor(rcolor.r, rcolor.g, rcolor.b, self.db.general.alpha)
	chat.Background = chat:CreateTexture(nil, "BACKGROUND")
	chat.Background:SetAllPoints()
	chat.Background:SetAlpha(0.65)
	chat:SetFrameStrata("HIGH")
	chat:EnableMouse(true)
	chat:EnableMouseWheel(true)
	chat:SetScript("OnMouseWheel", NC.OnMouseWheel)
	chat:SetScript(
		"OnMouseDown",
		function(self)
			NC.tabFrame:SetUserPlaced(true)
			NC.tabFrame:StartMoving()
		end
	)
	chat:SetScript(
		"OnMouseUp",
		function(self)
			NC.tabFrame:StopMovingOrSizing()
		end
	)

	if (COMP.MERS) then
		chat:Styling()
	end

	chat.Flash = CreateFrame("Frame")

	local top = CreateFrame("Frame", nil, chat, "BackdropTemplate")
	top:CreateBackdrop("Transparent")
	top.backdrop:SetAllPoints()

	if (COMP.MERS) then
		top:Styling()
	end

	top:Size(self.db.windows.width, 23)
	top:Point("TOP", chat, "TOP")
	top.backdrop:SetBackdropColor(bcolor.r, bcolor.g, bcolor.b, self.db.general.alpha)
	top.backdrop:SetBackdropBorderColor(rcolor.r, rcolor.g, rcolor.b, self.db.general.alpha)

	chat.Top = top

	local bottom = CreateFrame("Frame", nil, chat, "BackdropTemplate")
	bottom:CreateBackdrop("Transparent")
	bottom.backdrop:SetAllPoints()

	if (COMP.MERS) then
		bottom:Styling()
	end

	bottom:Size(self.db.windows.width, 23)
	bottom:SetPoint("BOTTOM", chat, "BOTTOM")
	bottom.backdrop:SetBackdropColor(bcolor.r, bcolor.g, bcolor.b, self.db.general.alpha)
	bottom.backdrop:SetBackdropBorderColor(rcolor.r, rcolor.g, rcolor.b, self.db.general.alpha)
	bottom:EnableMouse(true)

	chat.Bottom = bottom

	local name = chat.Top:CreateFontString(nil, "OVERLAY")
	name:SetFont(LSM:Fetch("font", self.db.windows.font), 12)
	name:SetShadowColor(0, 0, 0)
	name:SetShadowOffset(1.25, -1.25)
	name:SetPoint("LEFT", top, E:Scale(6), E:Scale(1))
	--name:SetText(hex..sender.."|r")
	--name:SetText(InfoString)

	chat.Name = name

	local dockedName = UIParent:CreateFontString(nil, "OVERLAY")
	dockedName:SetFont(LSM:Fetch("font", self.db.windows.font), 12)
	dockedName:SetShadowColor(0, 0, 0)
	dockedName:SetShadowOffset(1.25, -1.25)
	dockedName:SetPoint("TOPLEFT", chat)
	dockedName:SetAlpha(0)

	chat.DockedName = dockedName

	local invisibleMaximizeButton = CreateFrame("Button")
	invisibleMaximizeButton:SetAllPoints(dockedName)
	invisibleMaximizeButton:SetScript(
		"OnClick",
		function(self, button, down)
			if chat.minimized then
				NC:SetMaximized(chat)
			end
		end
	)

	chat.InvisibleMaximizeButton = invisibleMaximizeButton

	local text = CreateFrame("ScrollingMessageFrame", nil, chat)
	text:SetFont(LSM:Fetch("font", self.db.windows.font), self.db.windows.fontsize)
	text:SetShadowColor(0, 0, 0)
	text:SetShadowOffset(1.25, -1.25)
	text:SetPoint("TOPLEFT", E:Scale(3), E:Scale(-25))
	text:SetPoint("BOTTOMRIGHT", E:Scale(-3), E:Scale(26))
	text:SetJustifyH("LEFT")
	text:SetFading(false)
	text:SetMaxLines(60)
	text:SetHyperlinksEnabled(true)
	text:SetScript("OnHyperlinkEnter", MessageWindow_Hyperlink_OnEnter)
	text:SetScript("OnHyperlinkLeave", MessageWindow_Hyperlink_OnLeave)
	text:SetScript(
		"OnHyperlinkClick",
		function(self, link, text, button)
			if strsub(link, 1, 3) == "url" then
				NC:URLChatFrame_OnHyperlinkShow(self, link)
			else
				SetItemRef(link, text, button, self)
			end
		end
	)

	chat.Text = text

	chat.copybutton = CreateFrame("Frame", nil, chat)
	chat.copybutton:SetAlpha(0)
	chat.copybutton:Size(20, 22)
	chat.copybutton:SetPoint("TOPRIGHT", chat.Text)

	chat.copybutton.tex = chat.copybutton:CreateTexture(nil, "OVERLAY")
	chat.copybutton.tex:SetInside()
	chat.copybutton.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\copy.tga]])

	chat.copybutton:SetScript(
		"OnMouseUp",
		function(self, btn)
			NC:CopyChat(chat.Text)
		end
	)

	chat.copybutton:SetScript(
		"OnEnter",
		function(self)
			self:SetAlpha(1)
		end
	)
	chat.copybutton:SetScript(
		"OnLeave",
		function(self)
			self:SetAlpha(0)
		end
	)

	local editBox = CreateFrame("EditBox", nil, chat.Bottom)
	editBox:SetFont(LSM:Fetch("font", self.db.windows.font), 12)
	editBox:SetPoint("TOPLEFT", E:Scale(4), E:Scale(-2))
	editBox:SetPoint("BOTTOMRIGHT", E:Scale(-4), E:Scale(2))
	editBox:SetShadowColor(0, 0, 0)
	editBox:SetShadowOffset(1.25, -1.25)
	editBox:SetMaxLetters(200)
	editBox:SetAutoFocus(false)
	editBox:EnableKeyboard(true)
	editBox:EnableMouse(true)
	editBox:SetFrameStrata("DIALOG")
	editBox:SetFrameLevel(20)

	editBox:SetAttribute("chatType", chatType)
	editBox:SetAttribute("stickyType", chatType)
	editBox:SetAttribute("tellTarget", chatTarget)
	editBox.chatType = chatType
	editBox.isNihilistChatFrame = true

	ChatFrame_AddPrivateMessageTarget(chat, chatTarget)

	editBox:SetScript(
		"OnEditFocusGained",
		function(self)
			self.Backdrop:SetBackdropBorderColor(chatColor.r, chatColor.g, chatColor.b)
			self.Backdrop:Show()
			ACTIVE_CHAT_EDIT_BOX = self
		end
	)

	editBox:SetScript(
		"OnChar",
		function(self)
			ChatEdit_ParseText(self, 0)
		end
	)

	editBox:SetScript(
		"OnMouseDown",
		function(self)
			NC.forcedEdit = true
			self:SetAutoFocus(true)
			self.Backdrop:SetBackdropBorderColor(chatColor.r, chatColor.g, chatColor.b)
			self.Backdrop:Show()
			ACTIVE_CHAT_EDIT_BOX = self
			CC_LAST_ACTIVE_CHAT_EDIT_BOX = self -- because we picked it ourselves
		end
	)

	editBox:SetScript(
		"OnEscapePressed",
		function(self)
			self:SetAutoFocus(false)
			self:ClearFocus()
			self.Backdrop:SetBackdropBorderColor(0, 0, 0)
			self.Backdrop:Hide()
			self:SetText("")
			LAST_ACTIVE_CHAT_EDIT_BOX = self
		end
	)

	editBox:SetScript(
		"OnEnterPressed",
		function(self)
			ChatEdit_ParseText(self, 1)
			local set_active = NC:OnEnterPressed(self)
			if set_active then
				LAST_ACTIVE_CHAT_EDIT_BOX = self
			end
		end
	)
	chat.EditBox = editBox
	chat.editBox = editBox

	local editBackdrop = CreateFrame("Frame", nil, bottom, "BackdropTemplate")
	NC:SetStyle(editBackdrop)
	editBackdrop:Size(self.db.windows.width, 23)
	editBackdrop:SetBackdropColor(0.15, 0.15, 0.15, 1)
	editBackdrop:SetAllPoints(bottom)
	editBackdrop:Hide()

	chat.EditBox.Backdrop = editBackdrop

	local lastMessage = chat.Bottom:CreateFontString(nil, "OVERLAY")
	lastMessage:SetFont(LSM:Fetch("font", self.db.windows.font), 12)
	lastMessage:SetShadowColor(0, 0, 0)
	lastMessage:SetShadowOffset(1.25, -1.25)
	lastMessage:SetPoint("Left", E:Scale(6), E:Scale(1))

	chat.LastMessage = lastMessage

	local closeButton = CreateFrame("Frame", nil, chat)
	closeButton:Size(14, 14)
	closeButton:Point("TOPRIGHT", chat.Top, "TOPRIGHT", E:Scale(-4), E:Scale(-4))
	closeButton:EnableMouse(true)
	closeButton:SetFrameStrata("HIGH")
	closeButton:SetScript(
		"OnMouseDown",
		function()
			ChatEdit_ActivateChat(NC:GetDefaultEditBox())
			ChatEdit_DeactivateChat(NC:GetDefaultEditBox())
			NC.forcedEdit = false

			NC:ReleaseTab(chat)
			NC:UpdateTabs()

			NC:ReleaseChat(chat)
		end
	)

	closeButton:SetScript(
		"OnEnter",
		function(self)
			self.Text:SetTextColor(1, 0, 0)
		end
	)
	closeButton:SetScript(
		"OnLeave",
		function(self)
			self.Text:SetTextColor(1, 1, 1)
		end
	)

	chat.CloseButton = closeButton

	local closeButtonText = closeButton:CreateFontString(nil, "OVERLAY")
	closeButtonText:SetFont(LSM:Fetch("font", "ElvUI Pixel"), 12, "MONOCHROMEOUTLINE")
	closeButtonText:SetPoint("CENTER", 0, 0)
	closeButtonText:SetText("X")

	chat.CloseButton.Text = closeButtonText

	local minimizeButton = CreateFrame("Frame", nil, chat)
	minimizeButton:Size(14, 14)
	minimizeButton:SetPoint("RIGHT", chat.CloseButton, "LEFT", E:Scale(-3), 0)
	minimizeButton:EnableMouse(true)
	minimizeButton:SetFrameStrata("DIALOG")
	minimizeButton:SetScript(
		"OnMouseDown",
		function()
			if not chat.minimized then
				self:SetMinimized(chat)
			end
		end
	)

	chat.MinimizeButton = minimizeButton

	minimizeButton:SetScript(
		"OnEnter",
		function(self)
			self.Text:SetTextColor(1, 0, 0)
		end
	)
	minimizeButton:SetScript(
		"OnLeave",
		function(self)
			self.Text:SetTextColor(1, 1, 1)
		end
	)

	local minimizeButtonText = minimizeButton:CreateFontString(nil, "OVERLAY")
	minimizeButtonText:SetFont(LSM:Fetch("font", "ElvUI Pixel"), 12, "MONOCHROMEOUTLINE")
	minimizeButtonText:SetPoint("CENTER", 0, 1)
	minimizeButtonText:SetText("_")

	chat.MinimizeButton.Text = minimizeButtonText

	self:AcquireTab(chat)
	if (InCombatLockdown()) or (self.db.windows.autohide) then -- Auto minimize incoming msg if in combat
		self:SetMinimized(chat)
		chat.Flash:SetScript(
			"OnUpdate",
			function()
				self:StartFlash(chat.DockedName, 0.6)
			end
		)
	else
		self:ShowTab(chat)
		self:UpdateTabs()
		self:ClickTab(self.tabs[chat], true)
	end

	chat.target = chatTarget
	chat.isNihilistChatFrame = true
	self.chats[chatTarget] = chat
	return chat
end
