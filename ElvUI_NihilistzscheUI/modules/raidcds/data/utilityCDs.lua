local NUI = _G.unpack(select(2, ...))
local RCD = NUI.RaidCDs

RCD.categories.utilityCDs = {
    [29166] = {
        -- Innervate
        class = "DRUID",
        spec = { 1, 4 },
        cd = 180,
    },
    [205636] = {
        -- Force of Nature
        class = "DRUID",
        spec = 1,
        cd = 60,
    },
    [106898] = {
        -- Stampeding Roar
        class = "DRUID",
        spec = { 2, 3 },
        cd = {
            base = 120,
            pvp_talent = {
                id = 236148,
                modifier = 60,
            },
        },
    },
    [34477] = {
        -- Misdirect
        class = "HUNTER",
        cd = 30,
    },
    [1022] = {
        -- Blessing of Protection
        class = "PALADIN",
        cd = 300,
    },
    [73325] = {
        -- Leap of Faith
        class = "PRIEST",
        cd = {
            base = 90,
            pvp_talent = {
                id = 196611,
                modifier = 45,
            },
        },
    },
    [64901] = {
        -- Symbol of Hope
        class = "PRIEST",
        spec = 2,
        cd = 300,
    },
    [57934] = {
        -- Tricks of the Trade
        class = "ROGUE",
        cd = 30,
    },
    [114018] = {
        -- Shroud of Concealment
        class = "ROGUE",
        cd = 360,
    },
    [192077] = {
        -- Wind Rush Totem
        class = "SHAMAN",
        cd = 120,
        is_talent = true,
    },
}
