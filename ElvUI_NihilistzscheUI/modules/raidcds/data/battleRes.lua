---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
if not E.Retail then return end
local RCD = NUI.RaidCDs

RCD.categories.battleRes = {
    [61999] = {
        -- Raise Ally
        class = "DEATHKNIGHT",
        cd = 600,
        raid_battle_res = true,
    },
    [20484] = {
        -- Rebirth
        class = "DRUID",
        cd = 600,
        raid_battle_res = true,
    },
    [20608] = {
        -- Reincarnation
        class = "SHAMAN",
        cd = 1800,
    },
    [20707] = {
        -- Soulstone
        class = "WARLOCK",
        cd = 600,
        raid_battle_res = true,
    },
}
