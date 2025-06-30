---@class NUI
local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
if not E.Retail then return end
local CDB = NUI.CustomDataBar
local NT = NUI.Libs.NT

local C_AzeriteItem_FindActiveAzeriteItem = _G.C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetAzeriteItemXPInfo = _G.C_AzeriteItem.GetAzeriteItemXPInfo
local C_AzeriteItem_GetPowerLevel = _G.C_AzeriteItem.GetPowerLevel
local Item = _G.Item

function CDB.RegisterAzeriteTags()
    NT:RegisterTag("azerite:name", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation)

        return azeriteItem:GetItemName()
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")

    NT:RegisterTag("azerite:current", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local xp, xpForNextPoint = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)

        return CDB:GetFormattedText("CURRENT", xp, xpForNextPoint)
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")

    NT:RegisterTag("azerite:max", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local _, xpForNextPoint = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
        return CDB:GetFormattedText("CURRENT", xpForNextPoint, xpForNextPoint)
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")

    NT:RegisterTag("azerite:percent", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local xp, xpForNextPoint = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
        return CDB:GetFormattedText("PERCENT", xp, xpForNextPoint)
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")

    NT:RegisterTag("azerite:tonext", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local xp, xpForNextPoint = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
        return CDB:GetFormattedText("TONEXT", xp, xpForNextPoint)
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")

    NT:RegisterTag("azerite:current-percent", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local xp, xpForNextPoint = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
        return CDB:GetFormattedText("CURRENT_PERCENT", xp, xpForNextPoint)
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")

    NT:RegisterTag("azerite:current-max", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local xp, xpForNextPoint = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
        return CDB:GetFormattedText("CURRENT_MAX", xp, xpForNextPoint)
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")

    NT:RegisterTag("azerite:current-max-percent", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local xp, xpForNextPoint = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
        return CDB:GetFormattedText("CURRENT_MAX_PERCENT", xp, xpForNextPoint)
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")

    NT:RegisterTag("azerite:level", function()
        local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

        if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return end

        local currentLevel = C_AzeriteItem_GetPowerLevel(azeriteItemLocation)

        return CDB:GetFormattedText("CURRENT", currentLevel)
    end, "AZERITE_ITEM_EXPERIENCE_CHANGED UNIT_INVENTORY_CHANGED")
end
