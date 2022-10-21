local NUI, E = _G.unpack(select(2, ...))

local SSB = NUI.UtilityBars.SpecSwitchBar
local NUB = NUI.UtilityBars

local GetNumSpecializations = _G.GetNumSpecializations
local GetSpecialization = _G.GetSpecialization
local GetSpecializationInfo = _G.GetSpecializationInfo
local GetSpecializationInfoByID = _G.GetSpecializationInfoByID
local GameTooltip = _G.GameTooltip
local format = _G.format
local GetLootSpecialization = _G.GetLootSpecialization
local SetLootSpecialization = _G.SetLootSpecialization
local SetSpecialization = _G.SetSpecialization
local C_Timer_After = _G.C_Timer.After
local CreateFrame = _G.CreateFrame

function SSB:CreateBar()
	local bar =
		NUB:CreateBar("NihilistUI_SpecSwitchBar", "specSwitchBar", {"CENTER", E.UIParent, "CENTER", 0, 0}, "SpecSwitchBar")
	NUB.RegisterCreateButtonHook(
		bar,
		function(button)
			self:CreateButtonHook(button)
		end
	)
	NUB.RegisterUpdateButtonHook(
		bar,
		function(button)
			self.UpdateButtonHook(button)
		end
	)
	bar:Size(32, 32)

	NUB.CreateButtons(bar, GetNumSpecializations() + 1)

	return bar
end

function SSB:CreateButtonHook(button)
	button:RegisterForClicks("AnyDown")
	button.SetTooltip = function(_self)
		local specID, name, description, texture = GetSpecializationInfo(_self.data)
		local icon = format("|T%s:14:14:0:0:64:64:4:60:4:60|t", texture)
		GameTooltip:SetOwner(_self, "ANCHOR_RIGHT")
		GameTooltip:SetText(format("%s %s", icon, name), 1, 1, 1)
		GameTooltip:AddLine(description, nil, nil, nil, true)
		if (GetSpecialization() ~= _self.data) then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Click to change specialization")
		end
		if (GetLootSpecialization() ~= specID) then
			local lootSpec = GetLootSpecialization()
			local str = "Right-click to set the loot specialization to %s.|nCurrently %s."
			local lootStr
			if (lootSpec == 0) then
				lootStr = ("Default (%s)"):format(select(2, GetSpecializationInfo(GetSpecialization())))
			else
				lootStr = select(2, GetSpecializationInfoByID(lootSpec))
			end
			GameTooltip:AddLine(str:format(name, lootStr))
			GameTooltip:AddLine()
		end
		GameTooltip:Show()
		return false
	end
	button:SetScript(
		"OnClick",
		function(_self, _button)
			if (_button == "LeftButton" and _self.data ~= GetSpecialization()) then
				SetSpecialization(_self.data)
			end
			if (_button == "RightButton" and _self.data ~= GetLootSpecialization()) then
				SetLootSpecialization(GetSpecializationInfo(_self.data))
			end
		end
	)
end

function SSB.UpdateButtonHook(button)
	if (button.data == 0) then
		button.SetTooltip = function(self)
			local lootSpec = GetLootSpecialization()
			local str = "Set the loot specialization to Default.|nCurrently %s."
			local lootStr
			if (lootSpec == 0) then
				lootStr = ("Default (%s)"):format(select(2, GetSpecializationInfo(GetSpecialization())))
			else
				lootStr = select(2, GetSpecializationInfoByID(lootSpec))
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(str:format(lootStr))
			GameTooltip:Show()
			return false
		end
		button:SetScript(
			"OnClick",
			function()
				SetLootSpecialization(0)
			end
		)
		if (GetLootSpecialization() == 0) then
			button:SetBackdropBorderColor(1, 1, 0)
		else
			button:SetTemplate("Transparent")
		end
	else
		if (GetSpecialization() == button.data) then
			button:SetBackdropBorderColor(0, 1, 0)
		elseif (GetLootSpecialization() == GetSpecializationInfo(button.data)) then
			button:SetBackdropBorderColor(1, 1, 0)
		else
			button:SetTemplate("Transparent")
		end
	end
end

local function UpdateBarClosure()
	SSB:UpdateBar(SSB.bar)
end

function SSB:UpdateBar(bar)
	if (GetNumSpecializations() == 0) then
		C_Timer_After(1, UpdateBarClosure)
		return
	end
	for i = 1, GetNumSpecializations() + 1 do
		local button = bar.buttons[i]
		if (i <= GetNumSpecializations()) then
			button.data = i
			NUB.UpdateButtonAsCustom(bar, button, select(4, GetSpecializationInfo(i)))
		else
			button.data = 0
			NUB.UpdateButtonAsCustom(bar, button, "Interface\\Icons\\inv_misc_lockbox_1")
		end
	end

	NUB.UpdateBar(self, bar, "ELVUIBAR29BINDBUTTON")
end

function SSB:Initialize()
	NUB:InjectScripts(self)

	local frame = CreateFrame("Frame", "NihilistUI_SpecSwitchBarController")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
	frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	frame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
	frame:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	NUB:RegisterEventHandler(self, frame)

	local bar = self:CreateBar()

	self.bar = bar
	self.hooks = {}
	self.sbhooks = {}

	self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(SSB)
