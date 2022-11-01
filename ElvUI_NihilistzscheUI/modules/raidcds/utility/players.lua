local NUI, E = _G.unpack(select(2, ...))
local RCD = NUI.RaidCDs

local GI = NUI.Libs.GI

local C_SpecializationInfo_GetPvpTalentSlotInfo = _G.C_SpecializationInfo.GetPvpTalentSlotInfo
local C_SpecializationInfo_GetInspectSelectedPvpTalent = _G.C_SpecializationInfo.GetInspectSelectedPvpTalent
local wipe = _G.wipe
local GetPvpTalentInfoByID = _G.GetPvpTalentInfoByID
local INVSLOT_HEAD = _G.INVSLOT_HEAD
local INVSLOT_RANGED = _G.INVSLOT_RANGED
local GetInventoryItemID = _G.GetInventoryItemID
local UnitLevel = _G.UnitLevel
local UnitIsPVP = _G.UnitIsPVP

function RCD:UpdatePlayer(_, guid, unit, info)
    self.cached_players[guid] = self.cached_players[guid] or {}
    self.cached_players[guid].unitInfo = info
    self.cached_players[guid].unit = unit
    local spells = {}
    for k in pairs(RCD.categories) do
        spells[k] = RCD:GetSpellsForCategory(k, guid)
    end
    self.cached_players[guid].spells = spells
    if unit == "player" then self:InspectPlayer("GroupInSpecT_InspectReady", guid, "player") end
    self:UpdateCDs()
end

function RCD:RemovePlayer(_, guid)
    self.cached_players[guid] = nil
    self:UpdateCDs()
end

function RCD:FillOutPvPTalentInfo(guid, unit)
    if not self.cached_players[guid] then return end

    local function GetPvpTalentSlotInfo(_unit, slot)
        if _unit == "player" then
            local slotInfo = C_SpecializationInfo_GetPvpTalentSlotInfo(slot)
            if slotInfo then return slotInfo.selectedTalentID end
        else
            return C_SpecializationInfo_GetInspectSelectedPvpTalent(unit, slot)
        end
    end

    local info = self.cached_players[guid].unitInfo
    info.pvpTalents = info.pvpTalents or {}
    wipe(info.pvpTalents)
    if UnitIsPVP(unit) then
        for slot = 1, 4 do
            local selectedTalentID = GetPvpTalentSlotInfo(unit, slot)
            if not selectedTalentID then break end
            info.pvpTalents[slot] = select(6, GetPvpTalentInfoByID(selectedTalentID))
        end
    end
end

function RCD:InspectPlayer(_, guid, unit)
    if not self.cached_players[guid] then return end

    local items = {}
    for i = INVSLOT_HEAD, INVSLOT_RANGED do
        items[i] = GetInventoryItemID(unit, i)
    end
    self.cached_players[guid].items = items
    self.cached_players[guid].level = UnitLevel(unit)
    self:FillOutPvPTalentInfo(guid, unit)

    self:UpdateCDs()
end

GI.RegisterCallback(RCD, "GroupInSpecT_Update", "UpdatePlayer")
GI.RegisterCallback(RCD, "GroupInSpecT_Remove", "RemovePlayer")
GI.RegisterCallback(RCD, "GroupInSpecT_InspectReady", "InspectPlayer")
