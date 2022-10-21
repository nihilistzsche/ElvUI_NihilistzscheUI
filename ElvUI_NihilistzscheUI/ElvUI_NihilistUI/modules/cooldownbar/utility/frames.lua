local NUI, E = _G.unpack(select(2, ...))
local CB = NUI.CooldownBar
local COMP = NUI.Compatibility
local LSM = E.Libs.LSM
local ES = NUI.EnhancedShadows

local UnitAffectingCombat = _G.UnitAffectingCombat
local CreateFrame = _G.CreateFrame
local RegisterStateDriver = _G.RegisterStateDriver
local tremove = _G.tremove
local GameTooltip = _G.GameTooltip
local GameTooltip_Hide = _G.GameTooltip_Hide
local GetItemInfo = _G.GetItemInfo
local GetSpellInfo = _G.GetSpellInfo
local tinsert = _G.tinsert

function CB:UpdateFrame(frame)
	local cd, s, d = self:GetCooldown(frame)

	if (not cd) then
		return
	end

	local w = self.bar:GetWidth() - (self.bar:GetHeight() / 2)

	local pos = self:GetPosition(cd) * w

	if (cd > 0) then
		frame.cooldown:SetCooldown(s, d)
		frame.cooldown:Show()
	end

	frame.tex:SetTexture(self:GetTexture(frame))

	frame:ClearAllPoints()
	frame:SetPoint("CENTER", self.bar, "LEFT", pos, 0)
	frame:SetAlpha(1)
	frame:Show()

	self:CheckOverlap(frame)
end

function CB:FindFrame(type, id)
	for _, frame in pairs(self.liveFrames) do
		if (frame.type == type and frame[type .. "ID"] == id) then
			return frame
		end
	end

	return nil
end

function CB:FindIndexForFrame(frame)
	for i, f in pairs(self.liveFrames) do
		if (f == frame) then
			return i
		end
	end

	return 0
end

function CB:Activate()
	if (self.db.autohide) then
		if (self.bar:IsVisible()) then
			E:UIFrameFadeIn(self.bar, 0.2, self.bar:GetAlpha(), self.db.alpha)
		end
	end
	self.bar:SetScript(
		"OnUpdate",
		function(_, e)
			CB:OnFrameUpdate(e)
		end
	)
end

function CB:Deactivate()
	if (#self.liveFrames == 0 or not self.db.enabled) then
		self.bar:SetScript("OnUpdate", nil)

		if (self.db.autohide) then
			if (not (self.bar:IsMouseOver() or (UnitAffectingCombat("player") or UnitAffectingCombat("pet")))) then
				E:UIFrameFadeOut(self.bar, 0.2, self.bar:GetAlpha(), 0)
			end
		end
	end
end

function CB:CreateLabel(value)
	local fs = self.bar:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate(LSM:Fetch("font", E.db.general.font), 12, "THINOUTLINE")
	local str = value
	if (value % 60 == 0) then
		str = (value / 60) .. "m"
	end

	fs:SetText(str)

	local d = self.bar:GetHeight() / 2
	local r = self.bar:GetWidth()
	local l = fs:GetWidth()

	local pos = self:GetPosition(value) * (r - d)

	if (pos + l > r) then
		pos = r - l
	end

	fs:SetPoint("CENTER", self.bar, "LEFT", pos, 0)
	fs:Show()
end

function CB:CreateLabels()
	for _, value in pairs(self.values) do
		self:CreateLabel(value)
	end
end

function CB:CreateBar()
	local bar = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	bar:SetWidth(_G.ElvUI_Bar1:GetWidth())
	bar:SetHeight(_G.ElvUI_Bar1Button1:GetHeight())
	bar:SetPoint("CENTER")
	E:CreateMover(bar, "CooldownBarMover", "Cooldown Bar", nil, nil, nil, "ALL,ACTIONBARS,NIHILISTUI")
	RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")
	bar:SetTemplate("Transparent")
	if (COMP.MERS) then
		bar:Styling()
	end
	bar:SetAlpha(self.db.alpha)
	if ES then
		bar:CreateShadow()
		ES:RegisterFrameShadows(bar)
	end

	self.bar = bar
end

function CB:CreateFrame(type, id)
	local frame = tremove(self.usedFrames)

	if (not frame) then
		frame = CreateFrame("Button", nil, self.bar, "BackdropTemplate")
		frame:Size(32, 32)
		frame:SetTemplate("Transparent")

		local tex = frame:CreateTexture(nil, "ARTWORK")
		tex:SetInside(frame)

		frame.tex = tex

		frame:SetScript(
			"OnEnter",
			function()
				if ((frame.type == "spell" and frame.spellID) or (frame.type == "item" and frame.itemID)) then
					GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
					if (frame.type == "spell" and frame.spellID) then
						GameTooltip:SetSpellByID(frame.spellID)
					else
						GameTooltip:SetItemByID(frame.itemID)
					end
					GameTooltip:Show()
				end
			end
		)

		frame:SetScript("OnLeave", GameTooltip_Hide)

		frame:SetScript(
			"OnClick",
			function(_, button)
				if (button == "RightButton") then
					local message
					if (frame.type == "item") then
						message = "|cffff0000Blacklisted|r the cooldown for |cffffff00item|r" .. GetItemInfo(frame.itemID)
						self.db.blacklist.items[frame.itemID] = true
					else
						message = "|cffff0000Blacklisted|r the cooldown for |cffff00ffspell|r" .. GetSpellInfo(frame.spellID)
						self.db.blacklist.spells[frame.spellID] = true
					end
					print(message)
				end
			end
		)
		frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
		frame.cooldown:SetAllPoints(frame)

		frame.cooldown:SetDrawBling(false)
		frame.cooldown.SetDrawBling = E.noop
		frame.cooldown:SetDrawEdge(false)
		frame.cooldown.SetDrawEdge = E.noop
		frame.cooldown:SetDrawSwipe(false)
		frame.cooldown.SetDrawSwipe = E.noop

		E:RegisterCooldown(frame.cooldown)

		if ES then
			frame:CreateShadow()
			ES:RegisterFrameShadows(frame)
		end
	end

	frame.type = type
	frame[type .. "ID"] = id
	if (type == "spell") then
		frame.tex:SetTexture(select(3, GetSpellInfo(id)))
	else
		frame.tex:SetTexture(select(10, GetItemInfo(id)))
	end
	self.frameLevelSerial = self.frameLevelSerial + 5
	frame.nativeFrameLevel = self.frameLevelSerial
	frame:SetFrameLevel(frame.nativeFrameLevel)
	frame:SetAlpha(1)

	tinsert(self.liveFrames, frame)
	self:UpdateFrame(frame)
end

function CB:OnFrameUpdate(t)
	self.delta = self.delta + t

	if (self.delta < 0.05) then
		return
	end

	self.delta = self.delta - 0.05

	self:Update()
end
