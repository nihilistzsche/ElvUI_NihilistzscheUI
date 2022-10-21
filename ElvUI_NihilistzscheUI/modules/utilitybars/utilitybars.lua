local NUI, E, L = _G.unpack(select(2, ...))

local AB = E.ActionBars

local NUB = NUI.UtilityBars
local LAB = E.Libs.LAB
local LSM = E.Libs.LSM
local BS = NUI.ButtonStyle
local COMP = NUI.Compatibility

local CreateFrame,
	GetItemCount,
	GetItemInfo,
	GetSpellInfo,
	InCombatLockdown,
	RegisterStateDriver,
	select,
	unpack,
	tinsert,
	ipairs,
	pairs,
	floor,
	format,
	max =
	_G.CreateFrame,
	_G.GetItemCount,
	_G.GetItemInfo,
	_G.GetSpellInfo,
	_G.InCombatLockdown,
	_G.RegisterStateDriver,
	_G.select,
	_G.unpack,
	_G.tinsert,
	_G.ipairs,
	_G.pairs,
	_G.floor,
	_G.format,
	_G.max

local Item = _G.Item
local Spell = _G.Spell
local GetSpellTexture = _G.GetSpellTexture
local C_ToyBox_GetToyInfo = _G.C_ToyBox.GetToyInfo
local C_CurrencyInfo_GetCurrencyInfo = _G.C_CurrencyInfo.GetCurrencyInfo
local GameTooltip = _G.GameTooltip
local UnitAffectingCombat = _G.UnitAffectingCombat

function NUB.ActivateBar(bar)
	if (bar:IsVisible()) then
		E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), bar.db.alpha)
	end
end

function NUB.DeactivateBar(bar)
	E:UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
end

local function onUpdate(self, elapsed)
	if (self.watcher or 0) + elapsed > 0.5 then
		if not self:IsMouseOver() then
			self:SetScript("OnUpdate", nil)
			NUB.DeactivateBar(self)
		end
		self.watcher = 0
	else
		self.watcher = (self.watcher or 0) + elapsed
	end
end

function NUB:InjectScripts(tbl)
	tbl.Button_OnEnter = function(_, button)
		local bar = button:GetParent()
		bar:SetScript("OnUpdate", onUpdate)
		self.ActivateBar(bar)
	end
end

NUB.RegisteredBars = {}
function NUB:RegisterUtilityBar(tbl)
	self.RegisteredBars[tbl:GetName()] = tbl
	local ForUpdateAll = function(_self)
		_self:UpdateBar(_self.bar)
	end
	tbl.ForUpdateAll = ForUpdateAll
	NUI:RegisterModule(tbl:GetName())
end

local nihilistzscheui_ab_id = 770

NUB.CreatedBars = {}

function NUB:PLAYER_REGEN_DISABLED()
	if (E.db.nihilistzscheui.utilitybars.hideincombat) then
		for bar, _ in pairs(self.CreatedBars) do
			if not bar.doNotHideInCombat then
				RegisterStateDriver(bar, "visibility", "hide")
			end
		end
	end
end

function NUB:PLAYER_REGEN_ENABLED()
	for _, tbl in pairs(self.RegisteredBars) do
		tbl:UpdateBar(tbl.bar)
	end
end

function NUB:CreateBar(name, db, point, moverName)
	local bar = CreateFrame("Frame", name, E.UIParent, "SecureHandlerStateTemplate,BackdropTemplate")

	if (type(db) == "string") then
		NUI:RegisterDB(bar, "utilitybars." .. db)
	else
		bar.db = db
	end
	bar.id = nihilistzscheui_ab_id

	if (not AB.db["bar" .. nihilistzscheui_ab_id]) then
		AB.db["bar" .. nihilistzscheui_ab_id] = {showGrid = false}
	end

	local ES = NUI.EnhancedShadows
	bar:SetFrameLevel(1)
	bar:SetTemplate("Transparent")
	if (COMP.MERS) then
		bar:Styling()
	end
	if ES then
		bar:CreateShadow()
		ES:RegisterFrameShadows(bar)
	end
	bar:SetFrameStrata("MEDIUM")
	bar.buttons = {}

	RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")

	bar:Size(320, 36)
	if (point) then
		bar:Point(unpack(point))
	else
		bar:Point("BOTTOMLEFT", _G.LeftChatPanel, "TOPRIGHT", 0, 15)
	end
	E:CreateMover(bar, name .. "Mover", moverName or name, nil, nil, nil, "ALL,ACTIONBARS,NIHILISTUI")

	self.CreatedBars[bar] = true
	return bar
end

function NUB.RegisterCreateButtonHook(bar, func)
	if (not bar.createButtonHooks) then
		bar.createButtonHooks = {}
	end
	tinsert(bar.createButtonHooks, func)
end

function NUB.RegisterUpdateButtonHook(bar, func)
	if (not bar.updateButtonHooks) then
		bar.updateButtonHooks = {}
	end
	tinsert(bar.updateButtonHooks, func)
end

local function ExecuteHooks(tbl, ...)
	if (not tbl) then
		return
	end

	for _, f in ipairs(tbl) do
		f(...)
	end
end

function NUB.CreateButton(bar)
	local button = LAB:CreateButton(#bar.buttons + 1, format(bar:GetName() .. "Button%d", #bar.buttons + 1), bar, nil)
	button:SetFrameLevel(bar:GetFrameLevel() + 2)
	Mixin(button, BackdropTemplateMixin)
	button:SetTemplate("Transparent")
	button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
	button.cooldown:SetAllPoints(button)
	button.texture = button:CreateTexture(nil, "ARTWORK")
	button.texture:SetInside()
	button.texture:SetTexCoord(unpack(E.TexCoords))
	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:FontTemplate(LSM:Fetch("font", E.db.general.font), 10, "THINOUTLINE")
	button.count:SetWidth(E:Scale(bar.db.buttonsize) - 4)
	button.count:SetHeight(E:Scale(14))
	button.count:SetJustifyH("RIGHT")
	button.count:Point("BOTTOMRIGHT", 0, 0)
	AB:StyleButton(button, nil, nil, true)
	button:SetCheckedTexture("")
	RegisterStateDriver(button, "visibility", "[petbattle] hide; show")

	ExecuteHooks(bar.createButtonHooks, button)

	if (not AB.handledbuttons[button]) then
		E:RegisterCooldown(button.cooldown)

		AB.handledbuttons[button] = true
	end

	return button
end

function NUB.CreateButtons(bar, num)
	for i = 1, num do
		local button = bar.buttons[i]
		if (not button) then
			button = NUB.CreateButton(bar)
			bar.buttons[i] = button
		end

		local size = E:Scale(bar.db.buttonsize)

		button:Size(size)
	end
end

local function GenericButtonUpdate(bar, button, ...)
	local size = E:Scale(bar.db.buttonsize)
	button:Size(size)

	ExecuteHooks(bar.updateButtonHooks, button, ...)
end

local itemClosureData = {}

local itemClosures = {}

local function CreateOrGetItemClosure(id, bar, button, args)
	itemClosureData[id] = {bar, button, args}
	if (itemClosures[id]) then
		return itemClosures[id]
	end
	local func = function()
		if not itemClosureData[id] then
			return
		end
		local _bar, _button, _args = unpack(itemClosureData[id])
		local itemName, _, _, _, _, _, _, _, _, texture = GetItemInfo(id)
		local count = GetItemCount(id)
		button:SetAttribute("type", "item")
		button:SetAttribute("item", itemName)
		button.count:SetText(count)
		button.count:SetShown(count > 1)
		button.texture:SetTexture(texture)
		button.texture:SetDesaturated(count == 0)
		button:SetState(0, "item", id)

		GenericButtonUpdate(_bar, _button, unpack(_args))
	end
	itemClosures[id] = func
	return func
end

function NUB.UpdateButtonAsItem(bar, button, id, ...)
	button.data = id
	local args = {...}
	Item:CreateFromItemID(id):ContinueOnItemLoad(CreateOrGetItemClosure(id, bar, button, args))
end

local spellClosureData = {}

local spellClosures = {}

local function CreateOrGetSpellClosure(id, bar, button, args)
	spellClosureData[id] = {bar, button, args}
	if (spellClosures[id]) then
		return spellClosures[id]
	end
	local func = function()
		if (not spellClosureData[id]) then
			return
		end
		local _bar, _button, _args = unpack(spellClosureData[id])
		local name = GetSpellInfo(id)
		button:SetAttribute("type", "spell")
		button:SetAttribute("spell", name)
		button:SetState(0, "spell", id)
		local spellTexture = GetSpellTexture(id)
		button.texture:SetTexture(spellTexture)
		button.count:Hide()
		button:SetBackdropBorderColor(0, 0, 0, 1)

		GenericButtonUpdate(_bar, _button, unpack(_args))
	end
	spellClosures[id] = func
	return func
end

function NUB.UpdateButtonAsSpell(bar, button, id, ...)
	button.data = id
	local args = {...}
	Spell:CreateFromSpellID(id):ContinueOnSpellLoad(CreateOrGetSpellClosure(id, bar, button, args))
end

function NUB.UpdateButtonAsToy(bar, button, id, ...)
	button.data = id
	local name = select(2, C_ToyBox_GetToyInfo(id))
	button:SetAttribute("type", "toy")
	button:SetAttribute("toy", name)
	button:SetState(0, "toy", id)
	button.texture:SetTexture(select(3, C_ToyBox_GetToyInfo(id)))
	button.count:Hide()
	button:SetBackdropBorderColor(0, 0, 0, 1)

	GenericButtonUpdate(bar, button, ...)
end

function NUB.UpdateButtonAsCustom(bar, button, texture, ...)
	local state = {
		func = function()
			return
		end,
		texture = texture,
		tooltip = nil
	}

	button.texture:SetTexture(texture)
	button.count:Hide()
	button:SetState(0, "custom", state)
	button:SetBackdropBorderColor(0, 0, 0, 1)
	GenericButtonUpdate(bar, button, ...)
end

function NUB.AddAltoholicCurrencyInfo(id)
	if not id then
		return
	end
	local DataStore = _G.DataStore
	local Altoholic = _G.Altoholic
	if not DataStore or not Altoholic then
		return
	end

	local colors = Altoholic.Colors
	local currency = C_CurrencyInfo_GetCurrencyInfo(id)
	if not currency then
		return
	end

	GameTooltip:AddLine(" ", 1, 1, 1)

	local total = 0
	for _, character in pairs(DataStore:GetCharacters()) do
		local _, _, count = DataStore:GetCurrencyInfoByName(character, currency)
		if count and count > 0 then
			GameTooltip:AddDoubleLine(DataStore:GetColoredCharacterName(character), colors.teal .. count)
			total = total + count
		end
	end

	if total > 0 then
		GameTooltip:AddLine(" ", 1, 1, 1)
	end
	GameTooltip:AddLine(format("%s: %s", colors.gold .. L["Total owned"], colors.teal .. total), 1, 1, 1)
	GameTooltip:Show()
end

function NUB.WipeButtons(bar)
	for _, button in ipairs(bar.buttons) do
		button.data = nil
	end
end

function NUB.UpdateBar(tbl, bar, bindButtons)
	if bar.db.vertical then
		NUB.UpdateVertBar(tbl, bar, bindButtons)
	else
		NUB.UpdateHorizBar(tbl, bar, bindButtons)
	end
end

function NUB.UpdateBarMultRow(tbl, bar, bindButtons)
	if bar.db.vertical then
		error("Vertical Multirow Bars are not currently supported.")
	else
		NUB.UpdateHorizBarMultRow(tbl, bar, bindButtons)
	end
end

function NUB.UpdateHorizBar(tbl, bar, bindButtons)
	if (not bar.db.enabled) then
		RegisterStateDriver(bar, "visibility", "hide")
		return
	else
		RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")
	end

	bar.mouseover = bar.db.mouseover

	local spacing, mult = bar.db.spacing or 0, 1
	local size = bar.db.buttonsize
	local buttonsPerRow = bar.db.buttonsPerRow or 12

	local shownButtons, anchorX, anchorY = 0, 0, 0
	for i = 1, #bar.buttons do
		local button = bar.buttons[i]
		if (button.data) then
			RegisterStateDriver(button, "visibility", "[petbattle] hide; show")
			anchorX = anchorX + 1
			shownButtons = shownButtons + 1
			local xOffset, yOffset
			if ((shownButtons - 1) % buttonsPerRow) == 0 then
				anchorX = 1
				anchorY = anchorY + 1
			end

			xOffset = spacing + ((size + spacing) * (anchorX - 1))
			yOffset = -(spacing + ((size + spacing) * (anchorY - 1)))

			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", bar, "TOPLEFT", xOffset, yOffset)
			if bar.db.mouseover == true then
				if not bar:IsMouseOver() then
					bar:SetAlpha(0)
				end

				if not tbl.hooks[button] then
					tbl:HookScript(button, "OnEnter", "Button_OnEnter")
				end
			else
				bar:SetAlpha(bar.db.alpha)

				if tbl.hooks[button] then
					tbl:Unhook(button, "OnEnter")
				end
			end
		else
			RegisterStateDriver(button, "visibility", "hide")
		end
	end
	local numRows
	if (shownButtons <= buttonsPerRow) then
		buttonsPerRow = shownButtons
		numRows = 1
	else
		numRows = floor(shownButtons / buttonsPerRow) + (shownButtons % buttonsPerRow == 0 and 0 or 1)
	end

	local barWidth =
		spacing + ((size * (buttonsPerRow * mult)) + ((spacing * (buttonsPerRow - 1) * mult) + (spacing * mult)))
	local barHeight = size * numRows + spacing * numRows + spacing
	bar:Size(barWidth, barHeight)
	if (shownButtons == 0) then
		RegisterStateDriver(bar, "visibility", "hide")
	else
		RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")
	end

	for i = shownButtons + 1, #bar.buttons do
		RegisterStateDriver(bar.buttons[i], "visibility", "hide")
	end

	NUB:UpdateButtonConfig(bar, bindButtons)
	if BS then
		BS:UpdateButtons()
	end
end

function NUB.UpdateHorizBarMultRow(tbl, bar, bindButtons)
	if (not bar.db.enabled) then
		RegisterStateDriver(bar, "visibility", "hide")
		return
	else
		RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")
	end

	bar.mouseover = bar.db.mouseover

	local spacing, mult = bar.db.spacing, 1
	local size = bar.db.buttonsize

	local shownButtons, anchorX, anchorY = {}, {}

	local totalShown = 0

	local seenButton = false
	for i = 1, #bar.buttons do
		local button = bar.buttons[i]
		if (button.data) then
			local row = button.row
			RegisterStateDriver(button, "visibility", "[petbattle] hide; show")
			if (not anchorX[row]) then
				anchorX[row] = 0
				shownButtons[row] = 0
			end
			anchorX[row] = anchorX[row] + 1
			shownButtons[row] = shownButtons[row] + 1
			totalShown = totalShown + 1

			seenButton = true
			local xOffset, yOffset

			anchorY = 1
			for j = row - 1, 1, -1 do
				if (shownButtons[j] and shownButtons[j] > 0) then
					anchorY = anchorY + 1
				end
			end

			xOffset = spacing + ((size + spacing) * (anchorX[row] - 1))
			yOffset = -(spacing + ((size + spacing) * (anchorY - 1)))

			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", bar, "TOPLEFT", xOffset, yOffset)
			if bar.db.mouseover == true then
				if not bar:IsMouseOver() then
					bar:SetAlpha(0)
				end

				if not tbl.hooks[button] then
					tbl:HookScript(button, "OnEnter", "Button_OnEnter")
				end
			else
				bar:SetAlpha(bar.db.alpha)

				if tbl.hooks[button] then
					tbl:Unhook(button, "OnEnter")
				end
			end
		else
			RegisterStateDriver(button, "visibility", "hide")
		end
	end
	local numRows = 0
	local buttonsPerRow = 0
	for i = 1, #bar.keys do
		if (shownButtons[i] and shownButtons[i] > 0) then
			buttonsPerRow = max(shownButtons[i], buttonsPerRow)
			numRows = numRows + 1
		end
	end

	local barWidth =
		spacing + ((size * (buttonsPerRow * mult)) + ((spacing * (buttonsPerRow - 1) * mult) + (spacing * mult)))
	local barHeight = max((spacing * ((numRows * 2) - 1)), spacing * 2) + (size * numRows)
	bar:Size(barWidth, barHeight)
	if (not seenButton) then
		RegisterStateDriver(bar, "visibility", "hide")
	else
		RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")
	end

	for i = totalShown + 1, #bar.buttons do
		RegisterStateDriver(bar.buttons[i], "visibility", "hide")
	end

	NUB:UpdateButtonConfig(bar, bindButtons)
	if BS then
		BS:UpdateButtons()
	end
end

function NUB.UpdateVertBar(tbl, bar, bindButtons)
	if (not bar.db.enabled) then
		RegisterStateDriver(bar, "visibility", "hide")
		return
	else
		RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")
	end

	bar.mouseover = bar.db.mouseover

	local spacing, mult = bar.db.spacing or 0, 1
	local size = bar.db.buttonsize
	local buttonsPerRow = bar.db.buttonsPerRow or 12

	local shownButtons, anchorX, anchorY = 0, 0, 0
	for i = 1, #bar.buttons do
		local button = bar.buttons[i]
		if (button.data) then
			RegisterStateDriver(button, "visibility", "[petbattle] hide; show")
			anchorY = anchorY + 1
			shownButtons = shownButtons + 1
			local xOffset, yOffset
			if ((shownButtons - 1) % buttonsPerRow) == 0 then
				anchorY = 1
				anchorX = anchorX + 1
			end

			xOffset = spacing + ((size + spacing) * (anchorX - 1))
			yOffset = spacing + ((size + spacing) * (anchorY - 1))

			button:ClearAllPoints()
			button:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", xOffset, yOffset)
			if bar.db.mouseover == true then
				if not bar:IsMouseOver() then
					bar:SetAlpha(0)
				end

				if not tbl.hooks[button] then
					tbl:HookScript(button, "OnEnter", "Button_OnEnter")
				end
			else
				bar:SetAlpha(bar.db.alpha)

				if tbl.hooks[button] then
					tbl:Unhook(button, "OnEnter")
				end
			end
		else
			RegisterStateDriver(button, "visibility", "hide")
		end
	end
	local numRows
	if (shownButtons <= buttonsPerRow) then
		buttonsPerRow = shownButtons
		numRows = 1
	else
		numRows = floor(shownButtons / buttonsPerRow) + (shownButtons % buttonsPerRow == 0 and 0 or 1)
	end

	local barWidth = max((spacing * ((numRows * 2) - 1)), spacing) + (size * numRows)
	local barHeight =
		spacing + ((size * (buttonsPerRow * mult)) + ((spacing * (buttonsPerRow - 1) * mult) + (spacing * mult)))
	bar:Size(barWidth, barHeight)
	if (shownButtons == 0) then
		RegisterStateDriver(bar, "visibility", "hide")
	else
		RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")
	end

	for i = shownButtons + 1, #bar.buttons do
		RegisterStateDriver(bar.buttons[i], "visibility", "hide")
	end

	NUB:UpdateButtonConfig(bar, bindButtons)
	if BS then
		BS:UpdateButtons()
	end
end

function NUB:UpdateButtonConfig(bar, buttonName)
	if InCombatLockdown() then
		AB.NeedsUpdateButtonSettings = true
		AB:RegisterEvent('PLAYER_REGEN_ENABLED')
		return
	end

	local barDB = bar.db

	buttonName = buttonName or bar.bindButtons

	if not bar.buttonConfig then bar.buttonConfig = { hideElements = {}, colors = {} } end

	bar.buttonConfig.hideElements.macro = not barDB.macrotext
	bar.buttonConfig.hideElements.hotkey = not barDB.hotkeytext
	bar.buttonConfig.showGrid = barDB.showGrid
	bar.buttonConfig.clickOnDown = AB.db.keyDown
	bar.buttonConfig.outOfRangeColoring = (AB.db.useRangeColorText and 'hotkey') or 'button'
	bar.buttonConfig.colors.range = E:SetColorTable(bar.buttonConfig.colors.range, AB.db.noRangeColor)
	bar.buttonConfig.colors.mana = E:SetColorTable(bar.buttonConfig.colors.mana, AB.db.noPowerColor)
	bar.buttonConfig.colors.usable = E:SetColorTable(bar.buttonConfig.colors.usable, AB.db.usableColor)
	bar.buttonConfig.colors.notUsable = E:SetColorTable(bar.buttonConfig.colors.notUsable, AB.db.notUsableColor)
	bar.buttonConfig.useDrawBling = not AB.db.hideCooldownBling
	bar.buttonConfig.useDrawSwipeOnCharges = AB.db.useDrawSwipeOnCharges
	bar.buttonConfig.handleOverlay = AB.db.handleOverlay
	SetModifiedClick('PICKUPACTION', AB.db.movementModifier)

	for i, button in ipairs(bar.buttons) do
		AB:ToggleCountDownNumbers(bar, button)

		bar.buttonConfig.keyBoundTarget = format(buttonName..'%d', i)
		button.keyBoundTarget = bar.buttonConfig.keyBoundTarget
		button.postKeybind = AB.FixKeybindText
		button:SetAttribute('buttonlock', AB.db.lockActionBars)
		button:SetAttribute('checkselfcast', true)
		button:SetAttribute('checkfocuscast', true)
		if AB.db.rightClickSelfCast then
			button:SetAttribute('unit2', 'player')
		end

		button:UpdateConfig(bar.buttonConfig)
	end
end

function NUB.HandleEvent(mod, frame, event)
	if (not mod.bar) then
		return
	end

	if (UnitAffectingCombat("player") or InCombatLockdown()) and not mod.ignoreCombatLockdown then
		frame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if (event == "PLAYER_REGEN_ENABLED") then
		frame:UnregisterEvent(event)
	end

	mod:UpdateBar(mod.bar)
end

function NUB:RegisterEventHandler(mod, frame)
	frame:SetScript(
		"OnEvent",
		function(_, event)
			self.HandleEvent(mod, frame, event)
		end
	)
end

function NUB:Initialize()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

NUI:RegisterModule(NUB:GetName())
