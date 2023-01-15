local E, _, _, P = _G.unpack(_G.ElvUI)

P.nihilistzscheui = {}
local NP = P.nihilistzscheui

NP.animateddatabars = {
    ticks = {
        enabled = true,
        width = 3,
        alpha = 0.6,
    },
}
NP.autolog = {
    enabled = false,
    party = true,
    raid = true,
}
NP.bagequipmentseticon = {
    enable = true,
}
NP.buttonStyle = {
    enabled = true,
}
NP.cardinalpoints = {
    enabled = true,
}
NP.cleanDraenorZoneButton = {
    enabled = true,
    mouseover = false,
    buttonsize = 64,
    alpha = 1,
}
NP.cooldownBar = {
    enabled = true,
    autohide = false,
    alpha = 1,
    switchTime = 2,
}
NP.enhancedshadows = {
    enabled = true,
    shadowcolor = { r = 0, g = 0, b = 0 },
    size = 3,
}
NP.enhancednameplateauras = {
    ccDebuffCasterInfo = {
        enable = true,
        font = "PT Sans Narrow",
        fontOutline = "OUTLINE",
        fontSize = 10,
        classColor = true,
        textColor = { r = 1.0, g = 1.0, b = 1.0 },
    },
}
NP.hiddenArtifactTracker = {
    enabled = true,
    width = 410,
    height = 24,
    font = "PT Sans Narrow",
    fontSize = 9,
    fontFlags = "THICKOUTLINE",
    mouseoverText = false,
}
NP.nihilistzschechat = {
    general = {
        enabled = true,
        bordercolor = { r = 0.2, g = 0.2, b = 0.2 },
        backdropcolor = { r = 0.075, g = 0.075, b = 0.075 },
        alpha = 1,
    },
    windows = {
        autofade = false,
        autohide = false,
        showtitle = true,
        timestamp = true,
        width = 300,
        height = 120,
        fontsize = 12,
        texture = E.blankTex,
        font = "PT Sans Narrow",
        timeformat = "12Hour",
        localtime = true,
    },
}
NP.petbattlenameplates = {
    enabled = true,
    showBreedID = true,
}
NP.petbattleautostart = {
    autoQuestAccept = false,
    autoQuestComplete = false,
    autoStartBattle = false,
}
NP.pxp = {
    enabled = true,
    classColor = true,
    tag = "[pxp:name] Lvl [pxp:level] XP: [pxp:current]/[pxp:max] ([pxp:percent]) [pxp:rested] Rested ([pxp:quest] Quest) [pxp:levelup?]",
    font = "PT Sans Narrow",
    texture = "ElvUI Norm",
    fontsize = 10,
    offset = -4,
    width = 450,
    height = 10,
    color = {
        r = 0,
        g = 0.4,
        b = 1,
    },
}
NP.profdt = {
    prof = "prof1",
    hint = true,
}
NP.raidCDs = {
    enabled = true,
    width = 100,
    height = 12,
    font = "PT Sans Narrow",
    texture = "ElvUI Norm",
    fontSize = 10,
    solo = false,
    party = true,
    raid = true,
    onlyInCombat = true,
    cooldowns = {
        aoeCC = {},
        externals = {},
        raidCDs = {},
        utilityCDs = {},
        immunities = {},
        interrupts = {},
        battleRes = {},
    },
}
NP.settransfer = {
    enabled = true,
    notify = true,
}
NP.sysdt = {
    maxAddons = 25,
    showFPS = true,
    showMS = true,
    latency = "home",
    showMemory = false,
    announceFreed = true,
}
NP.talentloadouts = {}
NP.titlesdt = {
    useName = true,
}
NP.utilitybars = {
    hideincombat = false,
    baitBar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        alpha = 1,
        vertical = false,
        buttonsPerRow = 11,
    },
    equipmentManagerBar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        vertical = true,
        alpha = 1,
    },
    farmBar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        alpha = 1,
        notify = true,
        buttonsPerRow = 11,
        vertical = false,
    },
    portalBar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        alpha = 1,
        challengeModePandaria = false,
        challengeModeDraenor = false,
        vertical = false,
    },
    professionBar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        alpha = 1,
        vertical = false,
    },
    raidPrepBar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        alpha = 1,
        buttonsPerRow = 11,
        vertical = false,
    },
    specSwitchBar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        alpha = 1,
        vertical = true,
    },
    toolsOfTheTradeBar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        alpha = 1,
        buttonsPerRow = 11,
        vertical = false,
    },
    trackerbar = {
        enabled = true,
        mouseover = false,
        spacing = 4,
        buttonsize = 32,
        alpha = 1,
        notify = true,
        buttonsPerRow = 11,
        vertical = false,
    },
    engineertoybar = {
        enabled = true,
        mouseover = false,
        spacing = 2,
        buttonsize = 32,
        alpha = 1,
        buttonsPerRow = 11,
        vertical = false,
        toys = {},
    },
    toybar = {
        enabled = true,
        mouseover = false,
        spacing = 2,
        buttonsize = 32,
        alpha = 1,
        buttonsPerRow = 11,
        vertical = false,
    },
}
NP.vuf = {
    enabled = true,
    install_complete = 0,
    hideElv = true,
    unicolor = true,
    flash = true,
    screenflash = true,
    enableMouse = false, -- Turn off the mouse for click through
    warningText = true,
    lowThreshold = 20, -- flash health and mana bars below this %
    colorHealthByValue = true,
    hideOOC = false,
    font = "PT Sans Narrow",
    statusbar = "Minimalist",
    fontSize = 12,
    alpha = 1,
    alphaOOC = 0,
    customtext = {
        enabled = true,
        anchor = {
            pointFrom = "TOPRIGHT",
            attachTo = "health",
            pointTo = "TOPLEFT",
            xOffset = -20,
            yOffset = 20,
        },
        tag = "",
    },
    units = {
        player = {
            enabled = true,
            horizCastbar = true,
            health = {
                enabled = true,
                size = {
                    height = 150,
                    width = 50,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "TOPRIGHT",
                        attachTo = "health",
                        pointTo = "TOPLEFT",
                        xOffset = -20,
                        yOffset = 0,
                    },
                    tag = "[healthcolor][health:current-percent]",
                },
            },
            power = {
                enabled = true,
                anchor = {
                    pointFrom = "LEFT",
                    attachTo = "health",
                    pointTo = "RIGHT",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 150,
                    width = 10,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "TOPLEFT",
                        attachTo = "power",
                        pointTo = "TOPRIGHT",
                        xOffset = 10,
                        yOffset = 0,
                    },
                    tag = "[powercolor][power:current-percent]",
                },
            },
            cutaway = {
                health = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
                power = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
            },
            additionalpower = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOMRIGHT",
                    attachTo = "health",
                    pointTo = "BOTTOMLEFT",
                    xOffset = 2,
                    yOffset = 4,
                },
                spaced = true,
                spacesettings = {
                    offset = 4,
                    spacing = 6,
                },
                size = {
                    height = 142,
                    width = 7,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "BOTTOMRIGHT",
                        attachTo = "additionalpower",
                        pointTo = "BOTTOMLEFT",
                        xOffset = -4,
                        yOffset = 15,
                    },
                    tag = "[mana:current-max]",
                },
            },
            castbar = {
                enabled = true,
                ticks = true,
                tickcolor = { r = 0.4, g = 0.4, b = 0.4 },
                format = "REMAINING",
                displayTarget = false,
                size = {
                    horizontal = {
                        height = 26,
                        width = 220,
                        halfBar = false,
                    },
                    vertical = {
                        height = 150,
                        width = 10,
                    },
                },
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "power",
                    pointTo = "BOTTOM",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            name = {
                enabled = true,
                tag = "[smartlevel] [shortclassification] [namecolor][name:medium]",
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 0,
                    yOffset = 15,
                },
            },
            classbars = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOMRIGHT",
                    attachTo = "health",
                    pointTo = "BOTTOMLEFT",
                    xOffset = 2,
                    yOffset = 2,
                },
                spaced = true,
                spacesettings = {
                    offset = 4,
                    spacing = 6,
                },
                size = {
                    height = 146,
                    width = 7,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "BOTTOMRIGHT",
                        attachTo = "classbars",
                        pointTo = "BOTTOMLEFT",
                        xOffset = -4,
                        yOffset = 15,
                    },
                    tag = "[classpowercolor][classpower:current-max]",
                },
            },
            stagger = {
                enabled = true,
                anchor = {
                    pointFrom = "TOPLEFT",
                    attachTo = "health",
                    pointTo = "BOTTOMLEFT",
                    xOffset = 0,
                    yOffset = -2,
                },
                spaced = true,
                spacesettings = {
                    offset = 4,
                    spacing = 6,
                },
                size = {
                    height = 7,
                    width = 50,
                },
            },
            aurabars = {
                enabled = true,
                size = {
                    height = 20,
                    width = 146,
                    halfBar = false,
                },
                playerOnly = true,
                selfBuffs = true,
                useBlacklist = true,
                useWhitelist = false,
                noDuration = true,
                onlyDispellable = false,
                maxDuration = 120,
                useFilter = "",
                growthDirection = "DOWN",
                friendlyAuraType = "HELPFUL",
                enemyAuraType = "HARMFUL",
                clickThrough = false,
                reverseFill = false,
                abbrevName = false,
            },
            buffs = {
                enabled = false,
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 9,
                    yOffset = 40,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            debuffs = {
                enabled = false,
                anchor = {
                    pointFrom = "TOP",
                    attachTo = "buffs",
                    pointTo = "BOTTOM",
                    xOffset = 9,
                    yOffset = 6,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            raidicon = {
                enabled = true,
                size = {
                    height = 16,
                    width = 16,
                },
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            restingindicator = {
                enabled = true,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "TOPLEFT",
                    xOffset = -6,
                    yOffset = 10,
                },
            },
            combatindicator = {
                enabled = true,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "TOPRIGHT",
                    xOffset = 6,
                    yOffset = 10,
                },
            },
            pvptext = {
                enabled = true,
                anchor = {
                    pointFrom = "TOP",
                    attachTo = "health",
                    pointTo = "BOTTOM",
                    xOffset = 0,
                    yOffset = -6,
                },
                tag = "[pvptimer]",
            },
            healPrediction = {
                enabled = true,
                absorbStyle = "OVERFLOW",
                anchorPoint = "BOTTOM",
                height = -1,
            },
            powerPrediction = {
                enabled = true,
            },
            gcd = {
                enabled = true,
                anchor = {
                    pointFrom = "LEFT",
                    attachTo = "power",
                    pointTo = "RIGHT",
                    xOffset = 4,
                    yOffset = 0,
                },
                size = {
                    height = 150,
                    width = 4,
                },
            },
            portrait = {
                enabled = true,
                camDistanceScale = 1.3,
                rotation = 0,
                xOffset = 0,
                yOffset = 0,
            },
            resurrectindicator = {
                enabled = true,
            },
        },
        target = {
            enabled = true,
            horizCastbar = true,
            health = {
                enabled = true,
                size = {
                    height = 150,
                    width = 50,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "LEFT",
                        attachTo = "health",
                        pointTo = "RIGHT",
                        xOffset = 6,
                        yOffset = 0,
                    },
                    tag = "[healthcolor][health:current-percent]",
                },
            },
            power = {
                enabled = true,
                anchor = {
                    pointFrom = "RIGHT",
                    attachTo = "health",
                    pointTo = "LEFT",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 150,
                    width = 10,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "RIGHT",
                        attachTo = "power",
                        pointTo = "LEFT",
                        xOffset = -4,
                        yOffset = 0,
                    },
                    tag = "[powercolor][power:current-percent]",
                },
            },
            cutaway = {
                health = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
                power = {
                    enabled = false,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
            },
            castbar = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "power",
                    pointTo = "BOTTOM",
                    xOffset = 0,
                    yOffset = 0,
                },
                color = { r = 0.1, g = 0.1, b = 0.1 },
                interruptcolor = { r = 0.78, g = 0.25, b = 0.25 },
                size = {
                    horizontal = {
                        height = 26,
                        width = 220,
                        halfBar = false,
                    },
                    vertical = {
                        height = 150,
                        width = 10,
                    },
                },
                format = "REMAINING",
            },
            name = {
                enabled = true,
                tag = "[namecolor][name:medium] [difficultycolor][smartlevel] [shortclassification]",
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 0,
                    yOffset = 15,
                },
            },
            aurabars = {
                enabled = true,
                size = {
                    height = 20,
                    width = 146,
                    halfBar = false,
                },
                growthDirection = "DOWN",
                playerOnly = { friendly = true, enemy = true },
                useBlacklist = { friendly = true, enemy = true },
                useWhitelist = { friendly = false, enemy = false },
                noDuration = { friendly = true, enemy = true },
                selfBuffs = { friendly = true, enemy = true },
                onlyDispellable = { friendly = false, enemy = false },
                maxDuration = 300,
                useFilter = "",
                friendlyAuraType = "HELPFUL",
                enemyAuraType = "HARMFUL",
                clickThrough = false,
                reverseFill = false,
                abbrevName = false,
            },
            buffs = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 9,
                    yOffset = 40,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            debuffs = {
                enabled = false,
                anchor = {
                    pointFrom = "TOP",
                    attachTo = "buffs",
                    pointTo = "BOTTOM",
                    xOffset = 9,
                    yOffset = 6,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            healPrediction = {
                enabled = true,
                absorbStyle = "OVERFLOW",
                anchorPoint = "BOTTOM",
                height = -1,
            },
            raidicon = {
                enabled = true,
                size = {
                    height = 16,
                    width = 16,
                },
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            portrait = {
                enabled = true,
                camDistanceScale = 1.3,
                rotation = 0,
                xOffset = 0,
                yOffset = 0,
            },
            phaseindicator = {
                enabled = true,
                scale = 0.8,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
        },
        pet = {
            enabled = true,
            health = {
                enabled = true,
                size = {
                    height = 112,
                    width = 37,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "RIGHT",
                        attachTo = "health",
                        pointTo = "LEFT",
                        xOffset = -4,
                        yOffset = 0,
                    },
                    tag = "[healthcolor][health:current-percent]",
                },
            },
            power = {
                enabled = true,
                anchor = {
                    pointFrom = "LEFT",
                    attachTo = "health",
                    pointTo = "RIGHT",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 112,
                    width = 10,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "LEFT",
                        attachTo = "power",
                        pointTo = "RIGHT",
                        xOffset = 4,
                        yOffset = 0,
                    },
                    tag = "[powercolor][power:current-percent]",
                },
            },
            cutaway = {
                health = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
                power = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
            },
            castbar = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "power",
                    pointTo = "BOTTOM",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 112,
                    width = 10,
                },
                format = "REMAINING",
            },
            aurabars = {
                enabled = true,
                size = {
                    height = 20,
                    width = 120,
                    halfBar = false,
                },
                useBlacklist = true,
                useWhitelist = false,
                noDuration = true,
                onlyDispellable = false,
                maxDuration = 120,
                useFilter = "",
                growthDirection = "DOWN",
                friendlyAuraType = "HELPFUL",
                enemyAuraType = "HARMFUL",
                clickThrough = false,
                reverseFill = false,
                abbrevName = false,
            },
            name = {
                enabled = true,
                tag = "[namecolor][name:medium]",
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 0,
                    yOffset = 15,
                },
            },
            raidicon = {
                enabled = true,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            buffs = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 9,
                    yOffset = 40,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            debuffs = {
                enabled = false,
                anchor = {
                    pointFrom = "TOP",
                    attachTo = "buffs",
                    pointTo = "BOTTOM",
                    xOffset = 9,
                    yOffset = 6,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            portrait = {
                enabled = true,
                camDistanceScale = 1.3,
                rotation = 0,
                xOffset = 0,
                yOffset = 0,
            },
            healPrediction = {
                enabled = true,
                absorbStyle = "OVERFLOW",
                anchorPoint = "BOTTOM",
                height = -1,
            },
        },
        targettarget = {
            enabled = true,
            height = 113,
            width = 49,
            health = {
                enabled = true,
                size = {
                    height = 112,
                    width = 37,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "LEFT",
                        attachTo = "health",
                        pointTo = "RIGHT",
                        xOffset = 6,
                        yOffset = 0,
                    },
                    tag = "[healthcolor][health:current-percent]",
                },
            },
            power = {
                enabled = true,
                anchor = {
                    pointFrom = "RIGHT",
                    attachTo = "health",
                    pointTo = "LEFT",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 112,
                    width = 10,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "RIGHT",
                        attachTo = "power",
                        pointTo = "LEFT",
                        xOffset = -4,
                        yOffset = 0,
                    },
                    tag = "[powercolor][power:current-percent]",
                },
            },
            cutaway = {
                health = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
                power = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
            },
            name = {
                enabled = true,
                tag = "[namecolor][name:medium]",
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 0,
                    yOffset = 15,
                },
            },
            raidicon = {
                enabled = true,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            portrait = {
                enabled = true,
                camDistanceScale = 1.3,
                rotation = 0,
                xOffset = 0,
                yOffset = 0,
            },
            healPrediction = {
                enabled = true,
                absorbStyle = "OVERFLOW",
                anchorPoint = "BOTTOM",
                height = -1,
            },
        },
        targettargettarget = {
            enabled = false,
            health = {
                enabled = true,
                size = {
                    height = 112,
                    width = 37,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "LEFT",
                        attachTo = "health",
                        pointTo = "RIGHT",
                        xOffset = 6,
                        yOffset = 0,
                    },
                    tag = "[healthcolor][health:current-percent]",
                },
            },
            power = {
                enabled = true,
                anchor = {
                    pointFrom = "RIGHT",
                    attachTo = "health",
                    pointTo = "LEFT",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 112,
                    width = 10,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "RIGHT",
                        attachTo = "power",
                        pointTo = "LEFT",
                        xOffset = -4,
                        yOffset = 0,
                    },
                    tag = "[powercolor][power:current-percent]",
                },
            },
            cutaway = {
                health = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
                power = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
            },
            name = {
                enabled = true,
                tag = "[namecolor][name:medium]",
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 0,
                    yOffset = 15,
                },
            },
            raidicon = {
                enabled = true,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            portrait = {
                enabled = true,
                camDistanceScale = 1.3,
                rotation = 0,
                xOffset = 0,
                yOffset = 0,
            },
            healPrediction = {
                enabled = true,
                absorbStyle = "OVERFLOW",
                anchorPoint = "BOTTOM",
                height = -1,
            },
        },
        pettarget = {
            enabled = true,
            health = {
                enabled = true,
                size = {
                    height = 112,
                    width = 37,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "RIGHT",
                        attachTo = "health",
                        pointTo = "LEFT",
                        xOffset = -4,
                        yOffset = 0,
                    },
                    tag = "[healthcolor][health:current-percent]",
                },
            },
            power = {
                enabled = true,
                anchor = {
                    pointFrom = "LEFT",
                    attachTo = "health",
                    pointTo = "RIGHT",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 112,
                    width = 10,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "LEFT",
                        attachTo = "power",
                        pointTo = "RIGHT",
                        xOffset = 4,
                        yOffset = 0,
                    },
                    tag = "[powercolor][power:current-percent]",
                },
            },
            cutaway = {
                health = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
                power = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
            },
            buffs = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 9,
                    yOffset = 40,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            debuffs = {
                enabled = false,
                anchor = {
                    pointFrom = "TOP",
                    attachTo = "buffs",
                    pointTo = "BOTTOM",
                    xOffset = 9,
                    yOffset = 6,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            name = {
                enabled = true,
                tag = "[namecolor][name:medium]",
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 0,
                    yOffset = 15,
                },
            },
            raidicon = {
                enabled = true,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            portrait = {
                enabled = true,
                rotation = 0,
                camDistanceScale = 1,
            },
            healPrediction = {
                enabled = true,
                absorbStyle = "OVERFLOW",
                anchorPoint = "BOTTOM",
                height = -1,
            },
        },
        focus = {
            enabled = true,
            health = {
                enabled = true,
                size = {
                    height = 112,
                    width = 37,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "RIGHT",
                        attachTo = "health",
                        pointTo = "LEFT",
                        xOffset = -4,
                        yOffset = 0,
                    },
                    tag = "[healthcolor][health:current-percent]",
                },
            },
            power = {
                enabled = true,
                anchor = {
                    pointFrom = "LEFT",
                    attachTo = "health",
                    pointTo = "RIGHT",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 112,
                    width = 10,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "LEFT",
                        attachTo = "power",
                        pointTo = "RIGHT",
                        xOffset = 4,
                        yOffset = 0,
                    },
                    tag = "[powercolor][power:current-percent]",
                },
            },
            cutaway = {
                health = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
                power = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
            },
            castbar = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "power",
                    pointTo = "BOTTOM",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 112,
                    width = 10,
                },
                format = "REMAINING",
            },
            name = {
                enabled = true,
                tag = "[namecolor][name:medium]",
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 0,
                    yOffset = 15,
                },
            },
            raidicon = {
                enabled = true,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            buffs = {
                enabled = true,
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 9,
                    yOffset = 40,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            debuffs = {
                enabled = false,
                anchor = {
                    pointFrom = "TOP",
                    attachTo = "buffs",
                    pointTo = "BOTTOM",
                    xOffset = 9,
                    yOffset = 6,
                },
                size = {
                    height = 26,
                    width = 252,
                },
            },
            portrait = {
                enabled = true,
                rotation = 0,
                camDistanceScale = 1,
            },
            healPrediction = {
                enabled = true,
                absorbStyle = "OVERFLOW",
                anchorPoint = "BOTTOM",
                height = -1,
            },
        },
        focustarget = {
            enabled = false,
            health = {
                enabled = true,
                size = {
                    height = 112,
                    width = 37,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "LEFT",
                        attachTo = "health",
                        pointTo = "RIGHT",
                        xOffset = 6,
                        yOffset = 0,
                    },
                    tag = "[healthcolor][health:current-percent]",
                },
            },
            power = {
                enabled = true,
                anchor = {
                    pointFrom = "RIGHT",
                    attachTo = "health",
                    pointTo = "LEFT",
                    xOffset = 0,
                    yOffset = 0,
                },
                size = {
                    height = 112,
                    width = 10,
                },
                value = {
                    enabled = true,
                    anchor = {
                        pointFrom = "RIGHT",
                        attachTo = "power",
                        pointTo = "LEFT",
                        xOffset = -4,
                        yOffset = 0,
                    },
                    tag = "[powercolor][power:current-percent]",
                },
            },
            cutaway = {
                health = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
                power = {
                    enabled = true,
                    lengthBeforeFade = 0.3,
                    fadeOutTime = 0.6,
                },
            },
            name = {
                enabled = true,
                tag = "[namecolor][name:medium]",
                anchor = {
                    pointFrom = "BOTTOM",
                    attachTo = "health",
                    pointTo = "TOP",
                    xOffset = 0,
                    yOffset = 15,
                },
            },
            raidicon = {
                enabled = true,
                anchor = {
                    pointFrom = "CENTER",
                    attachTo = "health",
                    pointTo = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                },
            },
            portrait = {
                enabled = true,
                rotation = 0,
                camDistanceScale = 1,
            },
            healPrediction = {
                enabled = true,
                absorbStyle = "OVERFLOW",
                anchorPoint = "BOTTOM",
                height = -1,
            },
        },
    },
}

NP.warlockdemons = {
    enabled = true,
    width = 160,
    height = 16,
    texture = "Minimalist",
    font = "PT Sans Narrow",
    fontSize = 10,
    spacing = 0,
    grow = "DOWN",
    attachToNamePlate = false,
    color = {
        r = 0.58,
        g = 0.51,
        b = 0.79,
    },
    alpha = 1,
    demons = {
        ["Wild Imp"] = { enable = true },
        ["Demonic Tyrant"] = { enable = true },
        Dreadstalker = { enable = true },
        Felguard = { enable = true },
        Bilescourge = { enable = true },
        Vilefiend = { enable = true },
        ["Prince Malchezaar"] = { enable = true },
        ["Illidari Satyr"] = { enable = true },
        ["Vicious Hellhound"] = { enable = true },
        ["Eye of Gul'dan"] = { enable = true },
        ["Void Terror"] = { enable = true },
        Shivarra = { enable = true },
        Wrathguard = { enable = true },
        Darkhound = { enable = true },
        ["Ur'zul"] = { enable = true },
        ["Fel Lord"] = { enable = true },
        Observer = { enable = true },
        ["Pit Lord"] = { enable = true },
    },
}
NP.databarnotifier = {
    enabled = true,
    xpchatframe = "3",
    repchatframe = "3",
    axpchatframe = "3",
    honorchatframe = "3",
}

-- Custom DataBar
P.databars.experience.tag =
    "[name] Lvl [xp:level] XP: [xp:current]/[xp:max] ([xp:percent]) [xp:rested] Rested ([xp:quest] Quest) [xp:levelup?]"
P.databars.reputation.tag = "[rep:name]: [rep:standing] ([rep:current-max-percent])"
P.databars.azerite.tag =
    "[azerite:name] Level: [azerite:level] (XP: [azerite:current] / [azerite:max], [azerite:percent])"
P.databars.honor.tag = "[name] Honor Level [honor:level] XP: [honor:current]/[honor:max] ([honor:percent])"
