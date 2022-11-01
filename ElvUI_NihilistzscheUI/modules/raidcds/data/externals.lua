local NUI = _G.unpack(select(2, ...))
local RCD = NUI.RaidCDs

local INVSLOT_HAND = _G.INVSLOT_HAND

RCD.categories.externals = {
    [116849] = {
        -- Life Cocoon
        class = "MONK",
        spec = 2,
        cd = {
            base = 120,
            pvp_talent = {
                id = 202424,
                modifier = 30,
            },
        },
    },
    [6940] = {
        -- Blessing of Sacrifice
        class = "PALADIN",
        spec = { 1, 2 },
        cd = 120,
    },
    [1022] = {
        -- Blessing of Protection
        class = "PALADIN",
        cd = {
            base = 300,
            pvp_talent = {
                id = 216853,
                spec = 2,
                modifierPct = 33,
            },
        },
    },
    [204018] = {
        -- Blessing of Spellwarding
        class = "PALADIN",
        spec = 2,
        is_talent = true,
        cd = {
            base = 300,
            pvp_talent = {
                id = 216853,
                spec = 2,
                modifierPct = 33,
            },
        },
    },
    [633] = {
        -- Lay on Hands
        class = "PALADIN",
        cd = {
            base = 600,
            legendary = {
                id = 137059,
                slot = INVSLOT_HAND,
                modifierPct = 70,
            },
            talent = {
                id = 114154,
                modifierPct = 30,
            },
        },
    },
    [47788] = {
        -- Guardian Spirit
        class = "PRIEST",
        spec = 2,
        cd = {
            base = 180,
            pvp_talent = {
                id = 196602,
                modifier = 60,
            },
        },
    },
    [33206] = {
        -- Pain Suppression
        class = "PRIEST",
        spec = 1,
        cd = {
            base = 180,
            pvp_talent = {
                id = 236771,
                modifier = 120,
            },
        },
    },
}
