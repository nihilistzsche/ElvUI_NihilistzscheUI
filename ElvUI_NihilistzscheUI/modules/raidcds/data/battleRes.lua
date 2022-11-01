local NUI = _G.unpack(select(2, ...))
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
