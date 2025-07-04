---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
if not E.Retail then return end
local RCD = NUI.RaidCDs

local GetTalentInfoByID = _G.GetTalentInfoByID
local tContains = _G.tContains

local IS_MODIFIER_PERCENT = true

RCD.modifierTypes = {}
RCD.modifierTypes.Talent = 1
RCD.modifierTypes.PvPTalent = 2
RCD.modifierTypes.Legendary = 3

function RCD:EvaluateModifier(unitInfo, modifierTbl, modifierType)
    if type(modifierTbl) ~= "table" then return 0 end

    local func = "EvaluatePlayerTalent"
    if modifierType == RCD.modifierTypes.PvPTalent then
        func = "EvaluatePlayerPvPTalent"
    elseif modifierType == RCD.modifierTypes.Legendary then
        func = "EvaluatePlayerLegendary"
    end

    if self[func](unitInfo, modifierTbl) then
        if modifierTbl.modifierPct then
            return modifierTbl.modifierPct, IS_MODIFIER_PERCENT
        else
            return modifierTbl.modifier
        end
    end

    return 0
end

function RCD.EvaluatePlayerTalent(unitInfo, modifierTbl)
    if not unitInfo.talents then return false end
    for _, tbl in pairs(unitInfo.talents) do
        ---@diagnostic disable-next-line: missing-parameter
        if select(6, GetTalentInfoByID(tbl.talent_id)) == modifierTbl.id then return true end
    end
    return false
end

function RCD.EvaluatePlayerPvPTalent(unitInfo, modifierTbl)
    if not unitInfo.pvpTalents then return false end
    if tContains(unitInfo.pvpTalents, modifierTbl.id) then return true end
    return false
end

function RCD.EvaluatePlayerLegendary(unitInfo, modifierTbl)
    if
        not RCD.cached_players[unitInfo.guid]
        or not RCD.cached_players[unitInfo.guid].items
        or not RCD.cached_players[unitInfo.guid].level
    then
        return false
    end
    if RCD.cached_players[unitInfo.guid].level > 115 then return false end
    if RCD.cached_players[unitInfo.guid].items[modifierTbl.slot] == modifierTbl.id then return true end
    return false
end
