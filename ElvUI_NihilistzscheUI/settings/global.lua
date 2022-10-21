local _, _, _, _, G = _G.unpack(_G.ElvUI)

G.nihilistzscheui = {
    installer = {
        font = "PT Sans Narrow",
        texture = "Minimalist"
    }
}
G.nameplates.spellListDefault = {
    visibility = 3,
    width = 32,
    height = 20,
    lockaspect = true,
    stackSize = 8,
    text = 9,
    flashTime = 3,
    firstLoad = true,
    defaultSpellList = {
        --Death Knight
        [47476] = {
            --Strangulate
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [108194] = {
            --Asphyxiate UH
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [221562] = {
            --Asphyxiate Blood
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [207171] = {
            --Winter is Coming
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [206961] = {
            --Tremble Before Me
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [207167] = {
            --Blinding Sleet
            lockAspect = true,
            flashTime = 3,
            height = 40,
            text = 12,
            stackSize = 8,
            visibility = 1,
            width = 40
        },
        [212540] = {
            --Flesh Hook (Pet)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [91807] = {
            --Shambling Rush (Pet)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [204085] = {
            --Deathchill
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [233395] = {
            --Frozen Center
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [212332] = {
            --Smash (Pet)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [212337] = {
            --Powerful Smash (Pet)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [91800] = {
            --Gnaw (Pet)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [91797] = {
            --Monstrous Blow (Pet)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [210141] = {
            --Zombie Explosion
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Demon Hunter
        [207685] = {
            --Sigil of Misery
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [217832] = {
            --Imprison
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [221527] = {
            --Imprison (Banished version)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [204490] = {
            --Sigil of Silence
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [179057] = {
            --Chaos Nova
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [211881] = {
            --Fel Eruption
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [205630] = {
            --Illidan's Grasp
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [208618] = {
            --Illidan's Grasp (Afterward)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [213491] = {
            --Demonic Trample (it's this one or the other)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [208645] = {
            --Demonic Trample
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [200166] = {
            --Metamorphosis
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Druid
        [81261] = {
            --Solar Beam
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [5211] = {
            --Mighty Bash
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [163405] = {
            --Rake
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [203123] = {
            --Maim
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [202244] = {
            --Overrun
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [99] = {
            --Incapacitating Roar
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [33786] = {
            --Cyclone
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [209753] = {
            --Cyclone Balance
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [45334] = {
            --Immobilized
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [102359] = {
            --Mass Entanglement
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [339] = {
            --Entangling Roots
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Hunter
        [202933] = {
            --Spider Sting (it's this one or the other)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [233022] = {
            --Spider Sting
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [224729] = {
            --Bursting Shot
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [213691] = {
            --Scatter Shot
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [19386] = {
            --Wyvern Sting
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [3355] = {
            --Freezing Trap
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [203337] = {
            --Freezing Trap (Survival PvPT)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [209790] = {
            --Freezing Arrow
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [24394] = {
            --Intimidation
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [117526] = {
            --Binding Shot
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [190927] = {
            --Harpoon
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [201158] = {
            --Super Sticky Tar
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [162480] = {
            --Steel Trap
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [212638] = {
            --Tracker's Net
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [200108] = {
            --Ranger's Net
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Mage
        [61721] = {
            --Rabbit (Poly)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [61305] = {
            --Black Cat (Poly)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [28272] = {
            --Pig (Poly)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [28271] = {
            --Turtle (Poly)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [126819] = {
            --Porcupine (Poly)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [161354] = {
            --Monkey (Poly)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [161353] = {
            --Polar bear (Poly)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [118] = {
            --Polymorph
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [82691] = {
            --Ring of Frost
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [31661] = {
            --Dragon's Breath
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [122] = {
            --Frost Nova
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [33395] = {
            --Freeze
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [157997] = {
            --Ice Nova
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [228600] = {
            --Glacial Spike
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [198121] = {
            --Forstbite
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [45438] = {
            --Iceblock
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Monk
        [119381] = {
            --Leg Sweep
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [202346] = {
            --Double Barrel
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [114078] = {
            --Paralysis
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [198909] = {
            --Song of Chi-Ji
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [202274] = {
            --Incendiary Brew
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [233759] = {
            --Grapple Weapon
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [123407] = {
            --Spinning Fire Blossom
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [116706] = {
            --Disable
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [232055] = {
            --Fists of Fury
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Paladin
        [853] = {
            --Hammer of Justice
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [20066] = {
            --Repentance
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [105421] = {
            --Blinding Light
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [31935] = {
            --Avenger's Shield
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [217824] = {
            --Shield of Virtue
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [205290] = {
            --Wake of Ashes
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Priest
        [9484] = {
            --Shackle Undead
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [200196] = {
            --Holy Word: Chastise
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [200200] = {
            --Holy Word: Chastise
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [226943] = {
            --Mind Bomb
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [605] = {
            --Mind Control
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [8122] = {
            --Psychic Scream
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [15487] = {
            --Silence
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [199683] = {
            --Last Word
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Rogue
        [2094] = {
            --Blind
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [6770] = {
            --Sap
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [1776] = {
            --Gouge
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [199743] = {
            --Parley
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [1330] = {
            --Garrote - Silence
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [207777] = {
            --Dismantle
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [199804] = {
            --Between the Eyes
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [408] = {
            --Kidney Shot
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [1833] = {
            --Cheap Shot
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [207736] = {
            --Shadowy Duel (Smoke effect)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [212182] = {
            --Smoke Bomb
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Shaman
        [51514] = {
            --Hex
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [211015] = {
            --Hex (Cockroach)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [211010] = {
            --Hex (Snake)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [211004] = {
            --Hex (Spider)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [210873] = {
            --Hex (Compy)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [196942] = {
            --Hex (Voodoo Totem)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [118905] = {
            --Static Charge
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [77405] = {
            --Earthquake (Knocking down)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [118345] = {
            --Pulverize (Pet)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [204399] = {
            --Earthfury
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [204437] = {
            --Lightning Lasso
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [157375] = {
            --Gale Force
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [64695] = {
            --Earthgrab
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Warlock
        [710] = {
            --Banish
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [6789] = {
            --Mortal Coil
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [118699] = {
            --Fear
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [5484] = {
            --Howl of Terror
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [6358] = {
            --Seduction (Succub)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [171017] = {
            --Meteor Strike (Infernal)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [22703] = {
            --Infernal Awakening (Infernal CD)
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [30283] = {
            --Shadowfury
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [89766] = {
            --Axe Toss
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [233582] = {
            --Entrenched in Flame
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Warrior
        [5246] = {
            --Intimidating Shout
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [7922] = {
            --Warbringer
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [132169] = {
            --Storm Bolt
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [132168] = {
            --Shockwave
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [199085] = {
            --Warpath
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [105771] = {
            --Charge
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [199042] = {
            --Thunderstruck
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        --Racial
        [155145] = {
            --Arcane Torrent
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [20549] = {
            --War Stomp
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        },
        [107079] = {
            --Quaking Palm
            lockAspect = true,
            flashTime = 3,
            height = 40,
            stackSize = 8,
            text = 12,
            visibility = 1,
            width = 40
        }
    }
}

G.nameplates.spellList = {}
