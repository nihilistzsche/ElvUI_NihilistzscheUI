---@class NUI
local NUI = _G.unpack((select(2, ...)))
local RCD = NUI.RaidCDs

RCD.categories.interrupts = {
    [47528] = {
        -- Mind Freeze
        class = "DEATHKNIGHT",
        cd = 15,
    },
    [183752] = {
        -- Disrupt
        class = "DEMONHUNTER",
        cd = 15,
    },
    [202137] = {
        -- Sigil of Silence
        class = "DEMONHUNTER",
        spec = 2,
        cd = {
            base = 60,
            talent = {
                id = 209281,
                modifierPct = 20,
            },
            pvp_talent = {
                id = 211489,
                modifierPct = 25,
            },
        },
    },
    [78675] = {
        -- Solar Beam
        class = "DRUID",
        spec = 1,
        cd = {
            base = 60,
            pvp_talent = {
                id = 200928,
                modifier = 20,
            },
        },
    },
    [106839] = {
        -- Skull Bash
        class = "DRUID",
        spec = { 2, 3 },
        cd = 15,
    },
    [147362] = {
        -- Counter Shot
        class = "HUNTER",
        spec = { 1, 2 },
        cd = 24,
    },
    [187707] = {
        -- Muzzle
        class = "HUNTER",
        spec = 3,
        cd = 15,
    },
    [2139] = {
        -- Counterspell
        class = "MAGE",
        cd = 24,
    },
    [116705] = {
        -- Spear Hand Strike
        class = "MONK",
        spec = { 1, 3 },
        cd = 15,
    },
    [96231] = {
        -- Rebuke
        class = "PALADIN",
        spec = { 2, 3 },
        cd = 15,
    },
    [15487] = {
        -- Silence
        class = "PRIEST",
        spec = 3,
        cd = {
            base = 45,
            talent = {
                id = 263716,
                modifier = 15,
            },
        },
    },
    [1766] = {
        -- Kick
        class = "ROGUE",
        cd = 15,
    },
    [57994] = {
        -- Wind Shear
        class = "SHAMAN",
        cd = 12,
    },
    [19647] = {
        -- Spell Lock
        class = "WARLOCK",
        cd = 24,
        required_pet = 417,
    },
    [212619] = {
        -- Call Felhunter
        class = "WARLOCK",
        cd = 24,
        is_pvp_talent = true,
        required_pet = -417,
    },
    [6552] = {
        -- Pummel
        class = "WARRIOR",
        cd = 15,
    },
}
