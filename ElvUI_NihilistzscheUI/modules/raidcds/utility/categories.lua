---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
if not E.Retail then return end
local RCD = NUI.RaidCDs

local UnitExists = _G.UnitExists
local UnitGUID = _G.UnitGUID
local strsplit = _G.strsplit
local tContains = _G.tContains
local CopyTable = _G.CopyTable

RCD.categories = {}

RCD.category_labels = {
    aoeCC = "AoE CC",
    externals = "Externals",
    raidCDs = "Raid CDs",
    utilityCDs = "Utility CDs",
    immunities = "Immunities",
    interrupts = "Interrupts",
    battleRes = "Battle Res",
}

function RCD:GetSpellsForCategory(category, guid)
    if not self.cached_players[guid] then return {} end
    local unitInfo = self.cached_players[guid].unitInfo
    local spells = {}
    for k, tbl in pairs(self.categories[category]) do
        local failed = false
        if self.db and self.db.cooldowns[category][k] == false then failed = true end
        if not failed and tbl.class then
            if tbl.class ~= unitInfo.class then failed = true end
            if tbl.class == "WARLOCK" and tbl.required_pet then
                failed = true
                if UnitExists(self.cached_players[guid].unit .. "pet") then
                    local petGUID = UnitGUID(self.cached_players[guid].unit .. "pet")
                    local petID = select(6, strsplit("-", petGUID))
                    if tbl.required_pet < 0 then
                        failed = tonumber(petID) == math.abs(tbl.required_pet)
                    else
                        failed = tbl.required_pet ~= tonumber(petID)
                    end
                end
            end
        end
        if not failed and tbl.race then
            if tbl.race ~= unitInfo.race then failed = true end
        end
        if not failed and tbl.spec then
            if type(tbl.spec) == "table" then
                failed = not tContains(tbl.spec, unitInfo.spec_index)
            else
                failed = tbl.spec ~= unitInfo.spec_index
            end
        end
        if not failed and tbl.is_talent then failed = unitInfo.talents[k] ~= nil end
        if not failed and tbl.is_pvp_talent then
            failed = true
            if unitInfo.pvpTalents then
                for _, talentID in pairs(unitInfo.pvpTalents) do
                    if talentID == k then
                        failed = false
                        break
                    end
                end
            end
        end
        if not failed then
            spells[k] = CopyTable(tbl)
            spells[k].guid = guid
        end
    end
    return spells
end
