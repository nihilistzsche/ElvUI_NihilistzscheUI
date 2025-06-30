---@class NUI
local NUI = _G.unpack((select(2, ...)))
local RCD = NUI.RaidCDs

RCD.categories.aoeCC = {
    [20549] = {
        -- War Stomp
        race = "TAUREN",
        cd = 90,
    },
    [255654] = {
        -- Bull Rush
        race = "HIGHMOUNTAINTAUREN",
        cd = 120,
    },
    [108199] = {
        -- Gorefiend's Grasp
        class = "DEATHKNIGHT",
        spec = 1,
        cd = {
            base = 120,
            talent = {
                id = 206970,
                modifier = 30,
            },
        },
    },
    [179057] = {
        -- Chaos Nova
        class = "DEMONHUNTER",
        spec = 1,
        cd = {
            base = 60,
            talent = {
                id = 206477,
                modifier = 20,
            },
        },
    },
    [202138] = {
        -- Sigil of Chains
        class = "DEMONHUNTER",
        spec = 2,
        is_talent = true,
        cd = {
            base = 90,
            pvp_talent = {
                id = 211489,
                modifierPct = 25,
            },
        },
    },
    [102793] = {
        -- Ursol's Vortex
        class = "DRUID",
        spec = 4,
        cd = 60,
    },
    [132469] = {
        -- Typhoon
        class = "DRUID",
        cd = 30,
        is_talent = true,
    },
    [109248] = {
        -- Binding Shot
        class = "HUNTER",
        cd = 45,
        is_talent = true,
    },
    [119381] = {
        -- Leg Sweep
        class = "MONK",
        cd = {
            base = 60,
            talent = {
                id = 264348,
                modifier = 10,
            },
        },
    },
    [116844] = {
        -- Ring of Peace
        class = "MONK",
        cd = 45,
        is_talent = true,
    },
    [204263] = {
        -- Shining Force
        class = "PRIEST",
        spec = { 1, 2 },
        cd = 45,
        is_talent = true,
    },
    [192058] = {
        -- Capacitor Totem
        class = "SHAMAN",
        cd = 60,
    },
    [51490] = {
        -- Thunderstorm
        class = "SHAMAN",
        spec = 2,
        cd = {
            base = 45,
            pvp_talent = {
                id = 204403,
                modifier = 15,
            },
        },
    },
    [30283] = {
        -- Shadowfury
        class = "WARLOCK",
        cd = {
            base = 60,
            talent = {
                id = 264874,
                modifier = 15,
            },
        },
    },
    [212459] = {
        -- Call Fel Lord
        class = "WARLOCK",
        cd = 90,
        is_pvp_talent = true,
    },
    [46968] = {
        -- Shockwave
        class = "WARRIOR",
        spec = 3,
        cd = 40,
    },
}
