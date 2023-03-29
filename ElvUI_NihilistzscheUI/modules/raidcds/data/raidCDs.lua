local NUI = _G.unpack((select(2, ...)))
local RCD = NUI.RaidCDs

RCD.categories.raidCDs = {
    [196718] = {
        -- Darkness
        class = "DEMONHUNTER",
        spec = 2,
        cd = 180,
    },
    [740] = {
        -- Tranquility
        class = "DRUID",
        spec = 4,
        cd = {
            base = 180,
            talent = {
                id = 197073,
                modifier = 60,
            },
        },
    },
    [197721] = {
        -- Flourish
        class = "DRUID",
        spec = 4,
        cd = 90,
        is_talent = true,
    },
    [115310] = {
        -- Revival
        class = "MONK",
        spec = 2,
        cd = 180,
    },
    [31821] = {
        -- Aura Mastery
        class = "PALADIN",
        spec = 1,
        cd = 180,
    },
    [31884] = {
        -- Avenging Wrath
        class = "PALADIN",
        cd = 120,
    },
    [64843] = {
        -- Divine Hymn
        class = "PRIEST",
        spec = 2,
        cd = 180,
    },
    [200183] = {
        -- Apotheosis
        class = "PRIEST",
        spec = 2,
        cd = 120,
        is_talent = true,
    },
    [265202] = {
        -- Holy Word: Salvation
        class = "PRIEST",
        spec = 2,
        cd = 720,
    },
    [62618] = {
        -- Power Word: Barrier
        class = "PRIEST",
        spec = 1,
        cd = {
            base = 180,
            pvp_talent = {
                id = 197590,
                modifier = 60,
            },
        },
    },
    [47536] = {
        -- Rapture
        class = "PRIEST",
        spec = 1,
        cd = 90,
    },
    [15286] = {
        -- Vampiric Embrace
        class = "PRIEST",
        spec = 3,
        cd = 120,
    },
    [108281] = {
        -- Ancestral Guidance
        class = "SHAMAN",
        spec = 1,
        cd = 120,
        is_talent = true,
    },
    [108280] = {
        -- Healing Tide Totem
        class = "SHAMAN",
        spec = 3,
        cd = 180,
    },
    [98008] = {
        -- Spirit Link Totem
        class = "SHAMAN",
        spec = 3,
        cd = 180,
    },
    [114052] = {
        -- Ascendance
        class = "SHAMAN",
        spec = 3,
        cd = 180,
        is_talent = true,
    },
    [207399] = {
        -- Anscestral Protection Totem
        class = "SHAMAN",
        spec = 3,
        cd = 300,
        is_talent = true,
    },
    [97462] = {
        -- Rallying Cry
        class = "WARRIOR",
        cd = {
            base = 180,
            pvp_talent = {
                id = 235941,
                modifier = 120,
            },
        },
    },
}
