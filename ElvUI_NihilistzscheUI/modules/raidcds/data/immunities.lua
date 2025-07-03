---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
if not E.Retail then return end
local RCD = NUI.RaidCDs

RCD.categories.immunities = {
    [196555] = {
        -- Netherwalk
        class = "DEMONHUNTER",
        spec = 1,
        cd = 120,
        is_talent = true,
    },
    [186265] = {
        -- Aspect of the Turtle
        class = "HUNTER",
        cd = {
            base = 180,
            talent = {
                id = 266921,
                modifierPct = 20,
            },
        },
    },
    [45438] = {
        -- Ice Block
        class = "MAGE",
        cd = 240,
    },
    [642] = {
        -- Divine Shield
        class = "PALADIN",
        cd = {
            base = 300,
            talent = {
                id = 114154,
                modifierPct = 30,
            },
        },
    },
    [31224] = {
        -- Cloak of Shadows
        class = "ROGUE",
        cd = 120,
    },
}
