local _, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E.DataTexts

local Item = _G.Item
local BAG_ITEM_QUALITY_COLORS = _G.BAG_ITEM_QUALITY_COLORS
local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local GetSpellInfo = _G.GetSpellInfo
local GREEN_FONT_COLOR_CODE = _G.GREEN_FONT_COLOR_CODE
local HIGHLIGHT_FONT_COLOR_CODE = _G.HIGHLIGHT_FONT_COLOR_CODE
local NORMAL_FONT_COLOR = _G.NORMAL_FONT_COLOR
local DISABLED_FONT_COLOR_CODE = _G.DISABLED_FONT_COLOR_CODE
local C_AzeriteEmpoweredItem_GetAllTierInfo = _G.C_AzeriteEmpoweredItem.GetAllTierInfo
local C_AzeriteEmpoweredItem_GetPowerInfo = _G.C_AzeriteEmpoweredItem.GetPowerInfo
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem = _G.C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem
local C_AzeriteEmpoweredItem_IsPowerSelected = _G.C_AzeriteEmpoweredItem.IsPowerSelected
local C_AzeriteItem_FindActiveAzeriteItem = _G.C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetPowerLevel = _G.C_AzeriteItem.GetPowerLevel
local UnitLevel = _G.UnitLevel

local displayString = ""

local HEAD = 1
local SHOULDER = 3
local CHEST = 5

local slots = {HEAD, SHOULDER, CHEST}

local function addItemString(slot)
	local item = Item:CreateFromEquipmentSlot(slot)
	local icon = item:GetItemIcon()
	local name = item:GetItemName()
	local qual = item:GetItemQuality()
	local qualColor = BAG_ITEM_QUALITY_COLORS[qual]
	if (not qualColor) then
		return
	end
	local qualColorCode = E:RGBToHex(qualColor.r, qualColor.g, qualColor.b)

	local iconStr = "|T" .. icon .. ":15:15:0:0:64:64:4:56:4:56|t"

	DT.tooltip:AddLine(("%s %s%s|r"):format(iconStr, qualColorCode, name))
end

local __scanningTooltip = CreateFrame("GameTooltip", "NUIAPDTST", nil, "GameTooltipTemplate")
__scanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function addPowerSpellString(item, tierLevel, powerID)
	local powerInfo = C_AzeriteEmpoweredItem_GetPowerInfo(powerID)
	if (powerID) then
		local spellID = powerInfo.spellID
		local name, _, icon = GetSpellInfo(spellID)
		local itemID = item:GetItemID()
		local itemLevel = item:GetCurrentItemLevel()
		local itemLink = item:GetItemLink()
		__scanningTooltip:SetAzeritePower(itemID, itemLevel, powerID, itemLink)
		__scanningTooltip:Show()
		local desc = _G[__scanningTooltip:GetName() .. "TextLeft3"]:GetText()
		if (name and icon and desc) then
			local iconStr = "|T" .. icon .. ":15:15:0:0:64:64:4:56:4:56|t"

			DT.tooltip:AddLine(
				("%sLevel %d|r %s[%s %s]|r"):format(GREEN_FONT_COLOR_CODE, tierLevel, HIGHLIGHT_FONT_COLOR_CODE, iconStr, name)
			)
			DT.tooltip:AddLine(desc, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		end
	end
	return ""
end

local function addAzeriteArmorPowers(slot)
	local item = Item:CreateFromEquipmentSlot(slot)
	local str = ""
	local level = 0
	local azeriteLocation = C_AzeriteItem_FindActiveAzeriteItem()
	if azeriteLocation and azeriteLocation:IsEquipmentSlot() then
		level = C_AzeriteItem_GetPowerLevel(azeriteLocation)
	end
	if level == 0 then
		return
	end
	local itemLocation = item:GetItemLocation()
	if C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItem(itemLocation) then
		addItemString(slot)
		local allTierInfo = C_AzeriteEmpoweredItem_GetAllTierInfo(itemLocation)
		for i = 1, 5 do
			local tierInfo = allTierInfo[i]
			if (not tierInfo) then
				break
			end
			if (level < tierInfo.unlockLevel) then
				DT.tooltip:AddLine(("%sLevel %d|r"):format(DISABLED_FONT_COLOR_CODE, tierInfo.unlockLevel))
			else
				for _, powerID in ipairs(tierInfo.azeritePowerIDs) do
					if C_AzeriteEmpoweredItem_IsPowerSelected(item:GetItemLocation(), powerID) then
						addPowerSpellString(item, tierInfo.unlockLevel, powerID)
						break
					end
				end
			end
		end
	end
	return str
end

local _hex

local function ValueColorUpdate(hex)
	_hex = hex
	local azeriteLocation = C_AzeriteItem_FindActiveAzeriteItem()
	if not azeriteLocation then
		displayString = "|cffff2020No Data|r"
	else
		displayString = hex .. "Azerite Powers|r"
	end
end

local function OnEnter(self)
	self:GetParent().anchor = "ANCHOR_BOTTOM"
	DT:SetupTooltip(self)
	local azeriteLocation = C_AzeriteItem_FindActiveAzeriteItem()
	if (not azeriteLocation) then
		DT.tooltip:AddLine("No equipped azerite item")
		DT.tooltip:Show()
		return
	end

	for _, slot in ipairs(slots) do
		addAzeriteArmorPowers(slot)
	end

	DT.tooltip:Show()
end

local function UpdateDisplay(self)
	self.text:SetText(displayString)
end

local function OnEvent(self)
	if UnitLevel("player") < 40 then
		displayString = DISABLED_FONT_COLOR_CODE .. "Low Level|r"
	else
		local azeriteLocation = C_AzeriteItem_FindActiveAzeriteItem()
		if not azeriteLocation then
			displayString = "|cffff2020Azerite Missing|r"
		else
			displayString = (_hex or GREEN_FONT_COLOR_CODE) .. "Azerite Powers|r"
		end
	end
	UpdateDisplay(self)
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("NihilistUI Azerite Powers", 'NihilistUI', {"PLAYER_ENTERING_WORLD", "PLAYER_EQUIPMENT_CHANGED"}, UpdateDisplay, OnEvent, nil, OnEnter)
