---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local DT = E.DataTexts
if not E.Retail then return end
local HUDT = NUI.DataTexts.HeirloomUpgradeDataText

local C_Item_GetItemInfo = _G.C_Item.GetItemInfo
local C_Item_GetItemInfoInstant = _G.C_Item.GetItemInfoInstant
local C_Heirloom_PlayerHasHeirloom = _G.C_Heirloom.PlayerHasHeirloom
local C_Heirloom_GetHeirloomItemIDs = _G.C_Heirloom.GetHeirloomItemIDs
local C_Heirloom_GetHeirloomInfo = _G.C_Heirloom.GetHeirloomInfo

HUDT.HeirloomUpgradeCosts = {
    Armor = {
        [1] = 500,
        [2] = 1000,
        [3] = 2000,
        [4] = 5000,
        [5] = 5000,
        [6] = 5000,
    },
    Weapon = {
        [1] = 750,
        [2] = 1500,
        [3] = 3000,
        [4] = 7500,
        [5] = 7500,
        [6] = 7500,
    },
}

HUDT.UpgradeLevelByMaxLevel = {
    [29] = 0,
    [34] = 1,
    [39] = 2,
    [44] = 3,
    [49] = 4,
    [59] = 5,
    [69] = 6,
}

HUDT.UpgradeItemIDs = {
    Armor = {
        122338, -- Ancient Heirloom Armor Casing
        122340, -- Timeworn Heirloom Armor Casing
        151614, -- Weathered Heirloom Armor Casing
        167731, -- Battle-Hardened Heirloom Armor Casing
        187997, -- Eternal Heirloom Armor Casing
        204336, -- Awakened Heirloom Armor Casing
    },
    Weapon = {
        122339, -- Ancient Heirloom Scabbard
        122341, -- Timeworn Heirloom Scabbard
        151615, -- Weathered Heiloom Scabbard
        167732, -- Battle-Hardened Heirloom Scabbard
        187998, -- Eternal Heirloom Scabbard
        204337, -- Awakned Heirloom Scabbard
    },
}

HUDT.UpgradeItems = {
    Armor = {},
    Weapon = {},
}

local MAX_HEIRLOOM_UPGRADE = 6

do
    for _, key in next, { "Armor", "Weapon" } do
        for i = 1, MAX_HEIRLOOM_UPGRADE do
            local itemID = HUDT.UpgradeItemIDs[key][i]
            if C_Item_GetItemInfoInstant(itemID) then
                local item = Item:CreateFromItemID(itemID)
                item:ContinueOnItemLoad(function() HUDT.UpgradeItems[key][i] = item:GetItemLink() end)
            end
        end
    end
end

function HUDT:OnEvent(event, ...)
    -- Retrieve heirloom data
    local heirloomItemIDs = C_Heirloom_GetHeirloomItemIDs()
    E.global.nihilistzscheui.heirloomCache = E.global.nihilistzscheui.heirloomCache or {}
    local cache = E.global.nihilistzscheui.heirloomCache
    -- Reset heirloom data and total cost fields
    if not cache.heirlooms then cache.heirlooms({}) end
    wipe(cache.heirlooms)
    cache.upgradesNeededByLevel = { ["Armor"] = {}, ["Weapon"] = {} }

    local lastUpgradeMaxLevel = tInvert(HUDT.UpgradeLevelByMaxLevel)[MAX_HEIRLOOM_UPGRADE]
    -- Iterate over heirlooms and store relevant information
    for _, heirloomItemID in ipairs(heirloomItemIDs) do
        local name, _, _, _, upgradeLevel, _, _, _, _, maxLevel = C_Heirloom_GetHeirloomInfo(heirloomItemID)
        local known = C_Heirloom_PlayerHasHeirloom(heirloomItemID)
        if name and known and maxLevel ~= lastUpgradeMaxLevel then
            local currentUpgradeLevel = HUDT.UpgradeLevelByMaxLevel[maxLevel]
            local itemType = select(6, C_Item_GetItemInfo(heirloomItemID))

            local cost = 0
            local costKey = itemType == "Weapon" and "Weapon" or "Armor"
            for i = currentUpgradeLevel + 1, MAX_HEIRLOOM_UPGRADE do
                cache.upgradesNeededByLevel[costKey][i] = (cache.upgradesNeededByLevel[costKey][i] or 0) + 1
                cost = cost + HUDT.HeirloomUpgradeCosts[costKey][i]
            end

            local maxDiff = currentUpgradeLevel - upgradeLevel

            -- Add heirloom data to table
            cache.heirlooms[heirloomItemID] = {
                name = name,
                upgradeLevel = upgradeLevel,
                maxUpgradeLevel = MAX_HEIRLOOM_UPGRADE - maxDiff,
                cost = cost,
            }
        end
    end
    HUDT:Update()
end

function HUDT:OnEnter()
    local cache = E.global.nihilistzscheui.heirloomCache
    local color = BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Heirloom]

    -- Display tooltip
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
    GameTooltip:ClearLines()

    local i = 1
    -- Add heirloom data to tooltip
    for _, heirloom in next, cache.heirlooms do
        local line = string.format(
            "%s%s|r (%d/%d) (%d|TInterface\\MoneyFrame\\UI-GoldIcon:0|t)",
            color:GenerateHexColorMarkup(),
            heirloom.name,
            heirloom.upgradeLevel,
            heirloom.maxUpgradeLevel,
            heirloom.cost
        )
        GameTooltip:AddLine(line, 1, 1, 1)
        i = i + 1
    end

    GameTooltip:Show()
end

function HUDT:OnClick()
    local cache = E.global.nihilistzscheui.heirloomCache
    DEFAULT_CHAT_FRAME:AddMessage("Required number of upgrade items by type and level:")
    for _, key in next, { "Armor", "Weapon" } do
        for i = 1, MAX_HEIRLOOM_UPGRADE do
            if cache.upgradesNeededByLevel[key][i] then
                DEFAULT_CHAT_FRAME:AddMessage(
                    "|T"
                        .. select(5, C_Item_GetItemInfoInstant(HUDT.UpgradeItemIDs[key][i]))
                        .. ":12:12|t"
                        .. HUDT.UpgradeItems[key][i]
                        .. ": "
                        .. cache.upgradesNeededByLevel[key][i]
                )
            end
        end
    end
end

function HUDT:Update()
    if not self.text then return end
    local cache = E.global.nihilistzscheui and E.global.nihilistzscheui.heirloomCache
    if not cache then return end
    local totalCost = 0
    for _, heirloom in next, cache.heirlooms do
        totalCost = totalCost + heirloom.cost
    end
    local displayString = totalCost .. "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
    self.text:SetText(displayString)
end

DT:RegisterDatatext(
    "NihilistzscheUI Heirloom Upgrade Cost",
    "NihilistzscheUI",
    { "PLAYER_ENTERING_WORLD", "HEIRLOOMS_UPDATED" },
    HUDT.OnEvent,
    HUDT.Update,
    HUDT.OnClick,
    HUDT.OnEnter,
    nil,
    nil,
    nil,
    function() HUDT:Update() end
)
