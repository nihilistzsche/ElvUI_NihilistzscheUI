local NUI, E, _, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer
local COMP = NUI.Compatibility

local tContains = _G.tContains
local SetCVar = _G.SetCVar
local wipe = _G.wipe
local tFilter = _G.tFilter

function NI:ElvUINonHealerSetup()
    self:EDB().unitframe.units.raid40 = {
        visibility = "[@raid31,noexists] hide;show",
        portrait = {
            overlay = true,
            enable = true,
            fullOverlay = true,
        },
    }
    self:EDB().unitframe.units.raid = {
        raidWideSorting = false,
        numGroups = 6,
        visibility = "[@raid6,noexists][@raid31,exists] hide;show",
        portrait = {
            overlay = true,
            enable = true,
            fullOverlay = true,
        },
    }
    self:EDB().unitframe.units.party = {
        roleIcon = {
            yOffset = -4,
            attachTo = "Frame",
            position = "TOP",
        },
        portrait = {
            overlay = true,
            enable = true,
            fullOverlay = true,
        },
    }

    self.SaveMoverPosition("ElvUF_Raid1Mover", "BOTTOMLEFT", "DTPanelDTB2_NihilistzscheUITMover", "TOPLEFT", 0, 4)
    self.SaveMoverPosition("ElvUF_Raid2Mover", "BOTTOMLEFT", "DTPanelDTB2_NihilistzscheUITMover", "TOPLEFT", 0, 4)
    self.SaveMoverPosition("ElvUF_Raid3Mover", "BOTTOMLEFT", "DTPanelDTB2_NihilistzscheUITMover", "TOPLEFT", 0, 4)
    self.SaveMoverPosition("ElvUF_RaidpetMover", "BOTTOMLEFT", "ElvUF_RaidMover", "BOTTOMRIGHT", 4, 0)
    self.SaveMoverPosition("ElvUF_PartyMover", "BOTTOMLEFT", "DTPanelDTB2_NihilistzscheUITMover", "TOPLEFT", 0, 4)
    self.SaveMoverPosition("ElvUF_TankMover", "BOTTOMLEFT", "ElvUF_RaidMover", "TOPLEFT", 50, 80)
    self.SaveMoverPosition("ElvUF_AssistMover", "TOP", "ElvUF_TankMover", "BOTTOM", 0, -4)
end

function NI:ElvUIHealerSetup()
    self:EDB().unitframe.units.party = {
        horizontalSpacing = 9,
        debuffs = {
            sizeOverride = 16,
            yOffset = -7,
            anchorPoint = "TOPRIGHT",
            xOffset = -4,
        },
        health = {
            frequentUpdates = true,
            position = "BOTTOM",
            text_format = "[healthcolor][health:deficit]",
        },
        growthDirection = "LEFT_UP",
        power = {
            text_format = "",
        },
        verticalSpacing = 9,
        roleIcon = {
            position = "BOTTOMRIGHT",
        },
        GPSArrow = {
            size = 40,
        },
        healPrediction = {
            enable = true,
        },
        width = 80,
        name = {
            text_format = "[namecolor][name:short]",
            position = "TOP",
        },
        height = 45,
        buffs = {
            xOffset = 50,
            yOffset = -6,
            clickThrough = true,
            useBlacklist = false,
            noDuration = false,
            playerOnly = false,
            perrow = 1,
            useFilter = "TurtleBuffs",
            noConsolidated = false,
            sizeOverride = 22,
            enable = true,
        },
        portrait = {
            overlay = true,
            enable = true,
            fullOverlay = true,
        },
    }
    self:EDB().unitframe.units.raid40 = {
        growthDirection = "LEFT_UP",
        healPrediction = {
            enable = true,
        },
        health = {
            frequentUpdates = true,
        },
        height = 30,
        portrait = {
            overlay = true,
            enable = true,
            fullOverlay = true,
        },
    }
    self:EDB().unitframe.units.raidpet = { enabled = true, colorPetByUnitClass = true }
    self:EDB().unitframe.units.raid = {
        horizontalSpacing = 9,
        debuffs = {
            sizeOverride = 16,
            xOffset = -4,
            yOffset = -7,
            anchorPoint = "TOPRIGHT",
            enable = true,
        },
        growthDirection = "LEFT_UP",
        verticalSpacing = 9,
        rdebuffs = {
            enable = false,
        },
        raidWideSorting = false,
        healPrediction = {
            enable = true,
        },
        health = {
            frequentUpdates = true,
        },
        height = 45,
        buffs = {
            xOffset = 50,
            yOffset = -6,
            clickThrough = true,
            useBlacklist = false,
            noDuration = false,
            playerOnly = false,
            perrow = 1,
            useFilter = "TurtleBuffs",
            noConsolidated = false,
            sizeOverride = 22,
            enable = true,
        },
        portrait = {
            overlay = true,
            enable = true,
            fullOverlay = true,
        },
    }

    self.SaveMoverPosition("ElvUF_Raid1Mover", "BOTTOMRIGHT", E.UIParent, "BOTTOMLEFT", 465, 343)
    self.SaveMoverPosition("ElvUF_Raid2Mover", "BOTTOMRIGHT", E.UIParent, "BOTTOMLEFT", 465, 343)
    self.SaveMoverPosition("ElvUF_Raid3Mover", "BOTTOMRIGHT", E.UIParent, "BOTTOMLEFT", 442, 343)
    self.SaveMoverPosition("ElvUF_RaidpetMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 208, 341)
    self.SaveMoverPosition("ElvUF_PartyMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMLEFT", 466, 559)
    self.SaveMoverPosition("ElvUF_TankMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 141, 669)
    self.SaveMoverPosition("ElvUF_AssistMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 138, 341)
end

function NI:NameplateSetup()
    local needsPetFilterClasses = { "DEATHKNIGHT", "MAGE", "HUNTER", "WARLOCK" }
    local filterClassName = self.currentLocalizedClass
    local nameFormat = "[namecolor][name]"
    if not NUI.Lulupeep and COMP.TT then
        nameFormat = "[name:title:health:classcolors]"
        if NUI.Private then nameFormat = "[pvp:icon]" .. nameFormat end
    end
    self:EDB()["v11NamePlateReset"] = true
    self:EDB().nameplates = {
        healthBar = {
            text = {
                enable = true,
                format = "CURRENT_PERCENT",
            },
        },
        colors = {
            glowColor = self:Color(),
            selection = {
                [5] = self:Color(),
            },
        },
        filters = {
            Friendly_NameHealth_NonTarget = {
                triggers = {
                    enable = not NUI.Lulupeep,
                },
            },
            Enemy_Player = {
                triggers = {
                    enable = true,
                },
            },
            ["My_Minions_" .. filterClassName] = {
                triggers = {
                    enable = true,
                },
            },
            Player_NameHealth_NonTarget = {
                triggers = {
                    enable = not NUI.Lulupeep,
                },
            },
        },
        visibility = {
            friendly = {
                pets = true,
                guardians = true,
                minions = true,
            },
        },
        units = {
            PLAYER = {
                enable = true,
                castbar = {
                    font = self.db.font,
                },
                pvpindicator = {
                    enable = true,
                },
                name = {
                    enable = true,
                    font = self.db.font,
                    format = nameFormat,
                },
                power = {
                    enable = false,
                    text = {
                        enable = true,
                    },
                },
                health = {
                    text = {
                        enable = true,
                        font = self.db.font,
                    },
                },
                visibility = {
                    showAlways = true,
                },
                title = {
                    enable = true,
                    yOffset = -12,
                    font = self.db.font,
                    position = "CENTER",
                },
            },
            ["TARGET"] = {
                ["arrowScale"] = 0.5,
                ["arrow"] = "Arrow57",
                ["glowStyle"] = "style8",
            },
            ENEMY_NPC = {
                debuffs = {
                    filters = {
                        priority = "Blacklist,Dispellable,blockNoDuration,Personal,Boss,CCDebuffs",
                    },
                    countFont = self.db.font,
                },
                portrait = {
                    position = "LEFT",
                },
                level = {
                    font = self.db.font,
                    fontOutline = "THICKOUTLINE",
                    format = "[difficultycolor][level]",
                },
                castbar = {
                    font = self.db.font,
                },
                pvpindicator = {
                    enable = true,
                },
                eliteIcon = {
                    enable = true,
                },
                health = {
                    text = {
                        font = self.db.font,
                    },
                    healprediction = true,
                },
                power = {
                    displayAltPower = false,
                },
                buffs = {
                    filters = {
                        priority = "Blacklist,blockNoDuration,Personal,TurtleBuffs",
                    },
                    countFont = self.db.font,
                },
                name = {
                    font = self.db.font,
                    fontOutline = "THICKOUTLINE",
                },
                title = {
                    fontSize = 8,
                    enable = true,
                    yOffset = 25,
                    font = self.db.font,
                    position = "CENTER",
                    format = "|cffffff00[quest:info]|r",
                    fontOutline = "THICKOUTLINE",
                },
            },
            FRIENDLY_NPC = {
                debuffs = {
                    countFont = self.db.font,
                },
                level = {
                    font = self.db.font,
                    fontOutline = "THICKOUTLINE",
                },
                pvpindicator = {
                    enable = true,
                },
                health = {
                    text = {
                        font = self.db.font,
                    },
                },
                castbar = {
                    font = self.db.font,
                },
                buffs = {
                    countFont = self.db.font,
                },
                name = {
                    font = self.db.font,
                    fontOutline = "THICKOUTLINE",
                    format = "[namecolor][name]",
                },
                title = {
                    enable = true,
                    yOffset = -14,
                    font = self.db.font,
                    position = "CENTER",
                },
                nameOnly = false,
            },
            ENEMY_PLAYER = {
                debuffs = {
                    filters = {
                        priority = "Blacklist,Dispellable,blockNoDuration,Personal,Boss,CCDebuffs",
                    },
                    countFont = self.db.font,
                },
                portrait = {
                    classicon = true,
                    position = "LEFT",
                },
                level = {
                    font = self.db.font,
                    fontOutline = "THICKOUTLINE",
                },
                pvpindicator = {
                    showBadge = false,
                    enable = true,
                },
                name = {
                    font = self.db.font,
                    fontOutline = "THICKOUTLINE",
                    format = nameFormat,
                },
                castbar = {
                    font = self.db.font,
                },
                buffs = {
                    filters = {
                        maxDuration = 0,
                        priority = "Blacklist,blockNoDuration,Personal,TurtleBuffs",
                    },
                    countFont = self.db.font,
                },
                health = {
                    text = {
                        font = self.db.font,
                    },
                    healprediction = true,
                },
            },
            FRIENDLY_PLAYER = {
                debuffs = {
                    countFont = self.db.font,
                },
                portrait = {
                    position = "LEFT",
                },
                level = {
                    font = self.db.font,
                    fontOutline = "THICKOUTLINE",
                },
                pvpindicator = {
                    enable = true,
                },
                health = {
                    text = {
                        font = self.db.font,
                    },
                },
                castbar = {
                    font = self.db.font,
                },
                buffs = {
                    countFont = self.db.font,
                },
                title = {
                    enable = true,
                    yOffset = -12,
                    font = self.db.font,
                    position = "CENTER",
                },
                name = {
                    font = self.db.font,
                    fontOutline = "THICKOUTLINE",
                    format = nameFormat,
                },
            },
        },
        preciseTimer = true,
        auraAnchor = 0,
        threat = {
            badScale = 1.2,
        },
        glowColor = self:Color(),
        cutaway = {
            health = {
                enabled = true,
                forceBlankTexture = false,
            },
            power = {
                enabled = true,
                forceBlankTexture = false,
            },
        },
        fontSize = 10,
        statusbar = self.db.texture,
        font = self.db.font,
        healthFont = self.db.font,
        stackFont = self.db.font,
        durationFont = self.db.font,
        clampToScreen = true,
        displayStyle = "BLIZZARD",
        loadDistance = 100,
    }
    if needsPetFilterClasses[E.myclass] then
        self:EDB().nameplates.filters["My_Pet_" .. filterClassName] = {
            triggers = {
                enable = true,
            },
        }
    end
    if self.currentClass == "WARLOCK" then
        self:EDB().nameplates.filters.Demonology_Warlock_Demon_AboutToExpire = {
            triggers = {
                enable = true,
            },
        }
    end
    if COMP.IsAddOnEnabled("TotalRP3") and COMP.IsAddOnEnabled("RP_Tags") then
        self:EDB().nameplates.filters.PlayerHasRPProfile = {
            triggers = {
                enable = true,
            },
        }
    end
end

function NI:GlobalNameplateSetup()
    local needsPetFilterClasses = { "DEATHKNIGHT", "MAGE", "HUNTER", "WARLOCK" }
    wipe(E.global.nameplates.filters or {})
    local classes = {}
    _G.FillLocalizedClassList(classes, false)
    classes = tFilter(classes, function(k, _) return k ~= "Adventurer" end)
    for c, filterClassName in pairs(classes) do
        self.classColor = E:ClassColor(c, true)
        if needsPetFilterClasses[E.myclass] then
            E.global.nameplates.filters["My_Pet_" .. filterClassName] = {
                actions = {
                    color = {
                        healthColor = self:Color(),
                        health = true,
                    },
                    tags = {
                        title = " ",
                    },
                },
                triggers = {
                    class = {
                        [c] = {
                            enabled = true,
                        },
                    },
                    isPet = true,
                },
            }
        end
        if self.currentClass == "WARLOCK" then
            E.global.nameplates.filters.Demonology_Warlock_Demon_AboutToExpire = {
                actions = {
                    flash = {
                        enable = true,
                        speed = 6,
                    },
                    scale = 1.25,
                },
                triggers = {
                    isOwnedByPlayer = true,
                    isDemonologyWarlockDemonNUI = true,
                    demonologyWarlockDemonAboutToExpireNUI = true,
                },
            }
        end
        E.global.nameplates.filters["My_Minions_" .. filterClassName] = {
            actions = {
                tags = {
                    title = " ",
                },
                color = {
                    healthColor = self:Color(),
                    health = true,
                },
                scale = 0.85,
            },
            triggers = {
                triggers = {
                    class = {
                        [c] = {
                            enabled = true,
                        },
                    },
                },
                isNotPet = true,
                isPlayerControlled = true,
            },
        }
    end

    if not NUI.Lulupeep then
        E.global.nameplates.filters.Player_NameHealth_NonTarget = {
            actions = {
                nameOnly = true,
            },
            triggers = {
                notTarget = true,
                nameplateType = {
                    player = true,
                    enable = true,
                },
                priority = 6,
            },
        }
        E.global.nameplates.filters.Friendly_NameHealth_NonTarget = {
            actions = {
                nameOnly = true,
            },
            triggers = {
                priority = 6,
                notTarget = true,
                isNotOwnedByPlayer = true,
                nameplateType = {
                    enable = true,
                    friendlyPlayer = true,
                    friendlyNPC = true,
                },
            },
        }
    end
    if COMP.TT and COMP.IsAddOnEnabled("TotalRP3") and COMP.IsAddOnEnabled("RP_Tags") then
        E.global.nameplates.filters.PlayerHasRPProfile = {
            actions = {
                tags = {
                    name = "[pvp:icon][rp:statuscolor][rp:status][rp:icon][rp:title:name:classcolors]",
                },
            },
            triggers = {
                hasRPProfile = true,
                isCurrentlyInCharacter = true,
                nameplateType = {
                    player = true,
                    enable = true,
                    friendlyPlayer = true,
                    enemyPlayer = true,
                },
                priority = 3,
            },
        }
    end
end

function NI.NihilistzscheDatatextPanelSetup()
    local db = E.global.datatexts.customPanels

    local function copy(newKey) db["DTB2_" .. newKey] = E:CopyTable({}, E.global.datatexts.newPanelInfo) end
    copy("NihilistzscheUILL")
    copy("NihilistzscheUILR")
    copy("NihilistzscheUIUR")
    db.DTB2_NihilistzscheUIUR.numPoints = 1
    if NUI.Private then
        copy("NihilistzscheUIUL")
        db.DTB2_NihilistzscheUIUL.numPoints = 1
    end
end

local template = {
    [1] = { point = "TOPLEFT", x = 0, numSlots = 3 },
    [2] = { point = "TOP", x = -((E.eyefinity or E.screenWidth) / 5), numSlots = 3 },
    [3] = { point = "TOP", x = 0, numSlots = 1 },
    [4] = { point = "TOP", x = ((E.eyefinity or E.screenWidth) / 5), numSlots = 3 },
    [5] = { point = "TOPRIGHT", x = 0, numSlots = 3 },
    [6] = { point = "BOTTOM", x = -((E.eyefinity or E.screenWidth) / 6 - 15), numSlots = 3 },
    [7] = { point = "BOTTOM", x = 0, numSlots = 1 },
    [8] = { point = "BOTTOM", x = ((E.eyefinity or E.screenWidth) / 6 - 15), numSlots = 3 },
}

local width = {
    [1] = (E.eyefinity or E.screenWidth) / 5,
    [2] = (E.eyefinity or E.screenWidth) / 5,
    [3] = (E.eyefinity or E.screenWidth) / 5 - 4,
    [4] = (E.eyefinity or E.screenWidth) / 5,
    [5] = (E.eyefinity or E.screenWidth) / 5,
    [6] = (E.eyefinity or E.screenWidth) / 4 - 60,
    [7] = (E.eyefinity or E.screenWidth) / 10 - 4,
    [8] = (E.eyefinity or E.screenWidth) / 4 - 60,
}

function NI:DatatextPanelSetup()
    E.global.datatexts = E.global.datatexts or {}
    E.global.datatexts.currentCurrencies = E.global.customCurrencies or {}
    E.global.datatexts.customCurrencies[1889] = {
        DISPLAY_STYLE = "ICON_TEXT",
        NAME = "Adventure Campaign Progress",
        USE_TOOLTIP = true,
        ID = 1889,
        DISPLAY_IN_MAIN_TOOLTIP = true,
        ICON = "|T255347:16:16:0:0:64:64:4:60:4:60|t",
        SHOW_MAX = false,
    }
    E.global.datatexts.customPanels = E.global.datatexts.customPanels or {}
    E.global.datatexts.newPanelInfo = {
        growth = "HORIZONTAL",
        width = 414,
        height = 22,
        frameStrata = "LOW",
        numPoints = 3,
        frameLevel = 1,
        backdrop = true,
        panelTransparency = false,
        mouseover = false,
        border = true,
        textJustify = "CENTER",
        visibility = "show",
        tooltipAnchor = "ANCHOR_TOPLEFT",
        tooltipXOffset = -17,
        tooltipYOffset = 4,
        fonts = {
            enable = true,
            font = self.db.font,
            fontSize = 12,
            fontOutline = "OUTLINE",
        },
    }
    local db = E.global.datatexts.customPanels

    wipe(db)

    for i = 1, 8 do
        local key = "NUI_DataPanel_" .. i
        db[key] = E:CopyTable({}, E.global.datatexts.newPanelInfo)
        db[key].width = width[i]
        db[key].numPoints = template[i].numSlots
        db[key].visibility = "[petbattle] hide; show"
    end
end

function NI:ElvUISetup(role, isSpec)
    self:EDB().general = {
        interruptAnnounce = "SAY",
        autoAcceptInvite = true,
        autoRepair = "GUILD",
        cropIcon = 1,
        backdropfadecolor = {
            r = 0.054,
            g = 0.054,
            b = 0.054,
        },
        valuecolor = self:Color(true),
        vendorGrays = true,
        minimap = {
            icons = {
                classHall = {
                    position = "BOTTOMLEFT",
                },
            },
            locationFont = self.db.font,
        },
        altPowerBar = {
            statusBar = self.db.texture,
            font = self.db.font,
        },
        topPanel = false,
        bottomPanel = false,
        autoTrackReputation = true,
    }
    self:EDB().databars = {
        experience = {
            enable = true,
            orientation = "HORIZONTAL",
            height = 24,
            width = 410,
            fontSize = 10,
            fontOutline = "MONOCHROMEOUTLINE",
            font = self.db.font,
            questCurrentZoneOnly = true,
            questCompletedOnly = true,
            -- luacheck: push no max line length
            tag = "[name] Lvl [xp:level] XP: [xp:current]/[xp:max] ([xp:percent]) [xp:rested] Rested ([xp:quest] Quest) [xp:levelup?]",
            -- luacheck: pop
        },
        reputation = {
            enable = true,
            orientation = "HORIZONTAL",
            height = 24,
            width = 410,
            fontSize = 10,
            fontOutline = "MONOCHROMEOUTLINE",
            font = self.db.font,
            tag = "[rep:name]: [rep:standing] ([rep:current-max-percent])",
        },
        azerite = {
            enable = true,
            orientation = "HORIZONTAL",
            height = 24,
            width = 410,
            fontSize = 10,
            fontOutline = "MONOCHROMEOUTLINE",
            font = self.db.font,
            tag = "[azerite:name] Level: [azerite:level] (XP: [azerite:current] / [azerite:max], [azerite:percent])",
        },
        honor = {
            enable = true,
            orientation = "HORIZONTAL",
            height = 24,
            width = 410,
            fontSize = 10,
            fontOutline = "MONOCHROMEOUTLINE",
            font = self.db.font,
            tag = "[name] Honor Level [honor:level] XP: [honor:current]/[honor:max] ([honor:percent])",
            hideBelowMaxLevel = true,
        },
        threat = {
            font = self.db.font,
        },
        colors = {
            useCustomFactionColors = true,
            factionColors = {
                [1] = { r = 0.63, g = 0, b = 0 },
                [2] = { r = 0.63, g = 0, b = 0 },
                [3] = { r = 0.63, g = 0, b = 0 },
                [4] = { r = 0.82, g = 0.67, b = 0 },
                [5] = { r = 0.32, g = 0.67, b = 0 },
                [6] = { r = 0.32, g = 0.67, b = 0 },
                [7] = { r = 0.32, g = 0.67, b = 0 },
                [8] = { r = 0, g = 0.75, b = 0.44 },
                [9] = {
                    r = 186 / 255,
                    g = 183 / 255,
                    b = 107 / 255,
                },
            },
        },
    }

    self:EDB().hideTutorial = 1
    self:EDB().auras = {
        timeYOffset = -4,
        font = self.db.font,
        buffs = { growthDirection = "RIGHT_DOWN" },
        debuffs = { growthDirection = "RIGHT_DOWN" },
        barShow = true,
        barColor = self:Color(),
    }

    self:EDB().bagsOffsetFixed = true
    self:EDB().bags = {
        junkIcon = true,
        strata = "DIALOG",
        itemLevelFont = self.db.font,
        clearSearchOnClose = true,
        useTooltipScanCIng = true,
        itemInfoFont = self.db.font,
        colorBackdrop = true,
        itemLevelFontSize = 12,
        countFontSize = 12,
        scrapIcon = true,
        showBindType = true,
        countFont = self.db.font,
        vendorGrays = {
            details = true,
            enable = true,
        },
    }

    self:EDB().minimap = {
        instance = {
            font = self.db.font,
        },
        mapicons = {
            iconmouseover = true,
            iconsize = 24,
        },
    }

    self:EDB().gridSize = 128
    self:EDB().currentTutorial = 1

    self:EDB().unitframe = {
        colors = {
            castClassColor = true,
            auraBarBuff = self:Color(),
            healthclass = true,
            colorhealthbyvalue = true,
            healPrediction = {
                maxOverflow = 0.2,
            },
            powerPrediction = {
                enable = true,
            },
        },
        statusbar = self.db.texture,
        font = self.db.font,
        units = {
            pet = {
                enable = true,
                colorPetByUnitClass = true,
            },
            targettarget = {
                enable = false,
            },
            player = {
                enable = false,
                castbar = {
                    height = 28,
                    width = 401.666666666667,
                },
            },
            focus = {
                enable = false,
                castbar = {
                    height = 0,
                    width = 0,
                },
            },
            target = {
                debuffs = {
                    enable = false,
                },
                smartAuraDisplay = "SHOW_DEBUFFS_ON_FRIENDLIES",
                enable = false,
                buffs = {
                    playerOnly = {
                        friendly = true,
                    },
                },
                castbar = {
                    height = 0,
                    width = 0,
                },
                aurabar = {
                    attachTo = "BUFFS",
                },
            },
            arena = {
                castbar = {
                    height = 6.66664361953735,
                    width = 192.500137329102,
                },
                portrait = {
                    overlay = true,
                    enable = true,
                    fullOverlay = true,
                },
            },
            boss = {
                growthDirection = "RIGHT",
                width = 190,
                castbar = {
                    width = 190,
                    height = 5,
                },
                portrait = {
                    overlay = true,
                    enable = true,
                    fullOverlay = true,
                },
            },
        },
    }
    local LeftMiniPanelDT = "Time"
    if COMP.MERS then LeftMiniPanelDT = "LDB_Altoholic" end

    self:EDB().datatexts = {
        font = self.db.font,
        ["time24"] = true,
        ["actionbar3"] = true,
        ["actionbar1"] = true,
        ["actionbar5"] = true,
        panels = {
            LeftChatDataPanel = {
                backdrop = false,
                "Crit",
                "Mastery",
                "Haste",
            },
            RightChatDataPanel = {
                backdrop = false,
                "Bags",
                "Currencies",
                "Gold",
            },
            MinimapPanel = {
                backdrop = false,
                LeftMiniPanelDT,
                "Mounts",
            },
        },
    }
    self:EDB().datatexts.panels.DTB2_NihilistzscheUILL = {
        enable = true,
        "LDB_MythicDungeonTools",
        "QuickJoin",
        "Improved System",
    }
    self:EDB().datatexts.panels.DTB2_NihilistzscheUILR = {
        enable = true,
        "LDB_FamilyFamiliarHelper",
        "LDB_Rematch",
        "LDB_tdBattlePetScript",
    }
    self:EDB().datatexts.panels.DTB2_NihilistzscheUIUL = {
        enable = true,
        "LDB_Rarity",
    }
    local NUI_DataPanel_6_LeftDT = "Quick Join"
    if NUI.Private then NUI_DataPanel_6_LeftDT = "NihilistzscheUI Dungeon/Raid Difficulty" end
    self:EDB().datatexts.panels.NUI_DataPanel_1 = {
        enable = true,
        "NihilistzscheUI Account Item Level",
        NUI.Private and "NihilistzscheUI Heirloom Upgrade Cost" or "LDB_WarMode",
        "LDB_Broker_TimeToExecute_kill",
    }
    self:EDB().datatexts.panels.NUI_DataPanel_2 = {
        enable = true,
        "LDB_Locked Out",
        "LDB_LegionInvasionTimer",
        "LDB_BFAInvasionTimer",
    }
    self:EDB().datatexts.panels.NUI_DataPanel_3 = {
        enable = true,
        "NihilistzscheUI Version",
    }
    self:EDB().datatexts.panels.NUI_DataPanel_4 = {
        enable = true,
        "Missions",
        "Mail",
        "S&L Item Level",
    }
    self:EDB().datatexts.panels.NUI_DataPanel_5 = {
        enable = true,
        NUI.Private and "NihilistzscheUI Heritage Armor Tracker" or "NihilistzscheUI Azerite Powers",
        "LDB_DungeonHelper",
        "LDB_LDB-WoWToken",
    }
    self:EDB().datatexts.panels.NUI_DataPanel_6 = {
        enable = true,
        "CallToArms",
        NUI_DataPanel_6_LeftDT,
        "Chat Tweaks",
    }
    self:EDB().datatexts.panels.NUI_DataPanel_7 = {
        enable = true,
        "Cecile Meter Overlay",
    }
    self:EDB().datatexts.panels.NUI_DataPanel_8 = {
        enable = true,
        self.DataTextsByRole[role],
        "LDB_BtWQuests",
        "ClassTactics Talent Manager",
    }
    if NUI.Private then
        self:EDB().datatexts.panels.DTB2_NihilistzscheUIUR = {
            enable = true,
            [1] = "NihilistzscheUI Pet Challenge Tracker",
        }
    end
    local bar7enabled = true
    if self.currentClass == "DRUID" or self.currentClass == "ROGUE" or self.currentClass == "EVOKER" then
        bar7enabled = false
    end
    self:EDB().actionbar = {
        font = self.db.font,
        ["bar1"] = {
            mouseover = true,
        },
        ["bar2"] = {
            enabled = true,
            mouseover = true,
            buttons = 6,
        },
        ["bar3"] = {
            mouseover = true,
            buttonsPerRow = 12,
        },
        ["bar4"] = {
            mouseover = true,
        },
        ["bar5"] = {
            mouseover = true,
            buttonsPerRow = 12,
        },
        ["bar6"] = {
            enabled = true,
            mouseover = true,
            buttons = 6,
        },
        ["bar7"] = {
            buttonspacing = 2,
            backdropSpacing = 2,
            enabled = bar7enabled,
            buttons = 6,
            backdrop = false,
            mouseover = true,
            buttonsize = 32,
        },
        ["bar8"] = {
            buttonspacing = 2,
            backdropSpacing = 2,
            enabled = false,
            buttons = 6,
            backdrop = false,
            mouseover = true,
            buttonsize = 32,
        },
        barPet = {
            mouseover = true,
        },
        stanceBar = {
            mouseover = true,
            point = "BOTTOM",
        },
        equippedItem = true,
        useRangeColorText = true,
        desaturateOnCooldown = true,
        chargeCooldown = true,
        useDrawSwipeOnCharges = true,
    }

    self:EDB().epa = {
        poh = {
            enable = false,
        },
    }
    self:EDB().chat = {
        font = self.db.font,
        tabFont = self.db.font,
        copyChatLines = true,
        socialQueueMessages = true,
    }
    self:EDB().tooltip = {
        font = self.db.font,
        healthBar = {
            font = self.db.font,
        },
    }

    if not isSpec then
        self:EPRV().general = {
            glossTex = self.db.texture,
            normTex = self.db.texture,
            dmgFont = self.db.font,
            nameFont = self.db.font,
            chatBubbleFont = self.db.font,
            nameplateLargeFont = self.db.font,
            nameplateFont = self.db.font,
        }

        self:EPRV().skins = self:EPRV().skins or {}
        self:EPRV().skins.parchmentRemoverEnable = true
        self:EPRV().skins.blizzard = {
            questChoice = true,
            alertframes = true,
            objectiveTracker = false,
        }
        self:EPRV().auras = {
            masque = {
                buffs = false,
                debuffs = false,
            },
        }
        self:EPRV().actionbar = {
            masque = {
                actionbars = false,
                petBar = false,
                stanceBar = false,
            },
        }

        self:EPRV().bags = {
            enable = not COMP.ADIBAGS and not COMP.BAGGINS,
        }

        SetCVar("autoLootDefault", "1")
        SetCVar("movieSubtitle", "1")
        SetCVar("violenceLevel", "5")

        self:EPRV().install_complete = E.version
    end

    NI:EDB().movers = NI:EDB().movers or {}
    wipe(NI:EDB().movers)

    self.SaveMoverPosition("DTPanelDTB2_NihilistzscheUILLMover", "BOTTOM", _G.LeftChatPanel, "TOP", 0, 4)
    self.SaveMoverPosition("DTPanelDTB2_NihilistzscheUILRMover", "BOTTOM", _G.RightChatPanel, "TOP", 0, 4)
    self.SaveMoverPosition("DTPanelDTB2_NihilistzscheUIULMover", "BOTTOM", _G.LeftChatPanel, "TOP", 0, 30)
    if NUI.Private then
        self.SaveMoverPosition("DTPanelDTB2_NihilistzscheUIURMover", "BOTTOM", _G.RightChatPanel, "TOP", 0, 30)
    end
    for i = 1, 8 do
        self.SaveMoverPosition(
            "DTPanelNUI_DataPanel_" .. i .. "Mover",
            template[i].point,
            E.UIParent,
            template[i].point,
            template[i].x,
            0
        )
    end

    -- Action Bars
    self.SaveMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", 0, 26)
    self.SaveMoverPosition("ElvAB_2", "RIGHT", "ElvAB_1", "LEFT", -2, 0)
    self.SaveMoverPosition("ElvAB_3", "BOTTOM", "ElvAB_2", "TOP", 0, 2)
    self.SaveMoverPosition("ElvAB_5", "LEFT", "ElvAB_1", "RIGHT", 2, 0)
    self.SaveMoverPosition("ElvAB_6", "BOTTOM", "ElvAB_5", "TOP", 0, 2)
    self.SaveMoverPosition("ElvAB_7", "BOTTOM", "ElvAB_3", "TOP", 0, 2)
    self.SaveMoverPosition("ShiftAB", "BOTTOM", bar7enabled and "ElvAB_7" or "ElvAB_3", "TOP", 0, 2)
    self.SaveMoverPosition("TotemBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 415, 0)
    self.SaveMoverPosition("BossButton", "BOTTOM", E.UIParent, "BOTTOM", 0, 227)

    -- Unit Frames
    self.SaveMoverPosition("ElvUF_PlayerMover", "BOTTOM", E.UIParent, "BOTTOM", -278, 110)
    self.SaveMoverPosition("ElvUF_TargetTargetMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 110)
    self.SaveMoverPosition("ElvUF_TargetMover", "BOTTOM", E.UIParent, "BOTTOM", 278, 110)
    self.SaveMoverPosition("ElvUF_PetMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 150)
    self.SaveMoverPosition("ElvUF_BodyGuardMover", "TOP", E.UIParent, "TOP", -331, -332)
    self.SaveMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 42)
    self.SaveMoverPosition("BossHeaderMover", "TOP", E.UIParent, "TOP", 0, -220)
    self.SaveMoverPosition("ArenaHeaderMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -413, 375)
    self.SaveMoverPosition("BNETMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -4, 226)
    self.SaveMoverPosition("DurabilityFrameMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -372, -310)
    self.SaveMoverPosition("LeftChatMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 4, 0)
    self.SaveMoverPosition("GMMover", "TOPLEFT", E.UIParent, "TOPLEFT", 4, -341)
    self.SaveMoverPosition("BuffsMover", "TOP", E.UIParent, "TOP", -317, -303)
    self.SaveMoverPosition("DebuffsMover", "TOP", E.UIParent, "TOP", -317, -399)
    self.SaveMoverPosition("BossButton", "BOTTOM", E.UIParent, "BOTTOM", 0, 195)
    self.SaveMoverPosition("FlareMover", "TOP", E.UIParent, "TOP", 0, -511)
    self.SaveMoverPosition("MicrobarMover", "TOPLEFT", E.UIParent, "TOPLEFT", 0, -30)
    self.SaveMoverPosition("VehicleSeatMover", "TOPLEFT", E.UIParent, "TOPLEFT", 490, -45)
    self.SaveMoverPosition("MinimapMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", 0, -30)

    self.SaveMoverPosition("ExperienceBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 97)
    self.SaveMoverPosition("HonorBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 97)
    self.SaveMoverPosition("ReputationBarMover", "BOTTOM", "ExperienceBarMover", "TOP", 0, 4)
    self.SaveMoverPosition("AzeriteBarMover", "BOTTOM", "ReputationBarMover", "TOP", 0, 4)

    self.SaveMoverPosition("ZoneAbility", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -453, 194)
    self.SaveMoverPosition("RightChatMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -4, 0)
    self.SaveMoverPosition("Dashboard", "TOPLEFT", E.UIParent, "TOPLEFT", 0, -22)
    self.SaveMoverPosition("FarmToolAnchor", "TOPLEFT", E.UIParent, "TOPLEFT", 41, -512)
    self.SaveMoverPosition("MinimapButtonAnchor", "TOPRIGHT", E.UIParent, "TOPRIGHT", -4, -227)
    self.SaveMoverPosition("AltPowerBarMover", "TOP", E.UIParent, "TOP", 0, -196)

    self.SaveMoverPosition("UIBFrameMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -417, 0)
    self.SaveMoverPosition("RaidUtility_Mover", "TOP", E.UIParent, "TOP", -158, -47)

    self.SaveMoverPosition("PvPMover", "TOP", E.UIParent, "TOP", 0, -93)

    self.SaveMoverPosition("AlertFrameMover", "TOP", E.UIParent, "TOP", 0, -281)
    self.SaveMoverPosition("RaidMarkerBarAnchor", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -650, 27)
    self.SaveMoverPosition("TalkingHeadFrameMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 263)
    self.SaveMoverPosition("TopCenterContainerMover", "TOP", E.UIParent, "TOP", 0, -170)
    self.SaveMoverPosition("MirrorTimer1Mover", "TOP", E.UIParent, "TOP", 0, -110)
    self.SaveMoverPosition("PowerBarContainerMover", "TOP", E.UIParent, "TOP", 0, -110)

    self.SaveMoverPosition("VOICECHAT", "TOPRIGHT", E.UIParent, "TOPRIGHT", -504, -68)

    local function c() return "ElvUI" .. (role == "Healer" and "Healer" or "NonHealer") .. "Setup" end

    self[c()](self)

    for k in pairs(P.unitframe.units) do
        self:EDB().unitframe.units[k] = self:EDB().unitframe.units[k] or {}
        self:EDB().unitframe.units[k].cutaway = {
            health = { enabled = true },
        }
        if P.unitframe.units[k].cutaway.power then self:EDB().unitframe.units[k].cutaway.power = { enabled = true } end
    end
end

function NI:ElvUILuluSetup()
    self:EDB().databars = {
        artifact = {
            orientation = "HORIZONTAL",
            height = 30,
            textSize = 14,
            width = 415,
        },
        reputation = {
            enable = true,
            height = 28,
            orientation = "HORIZONTAL",
            textSize = 15,
            width = 415,
        },
        experience = {
            orientation = "HORIZONTAL",
            height = 28,
            textSize = 13,
            width = 415,
        },
        honor = {
            maxleveltag = "[mouseover][honor:maxlevel]",
            height = 35,
            orientation = "HORIZONTAL",
            textSize = 14,
            width = 415,
        },
    }
    self:EDB().general = {
        stickyFrames = false,
        font = self.db.font,
        bottomPanel = false,
        backdropfadecolor = {
            r = 0.054,
            g = 0.054,
            b = 0.054,
        },
        valuecolor = {
            r = 0.09,
            g = 0.513,
            b = 0.819,
        },
        vendorGrays = true,
        interruptAnnounce = "SAY",
        autoAcceptInvite = true,
    }
    self:EDB().auras = {
        fontSize = 12,
        timeYOffset = -4,
        font = self.db.font,
    }
    self:EDB().epa = {
        poh = {
            enable = true,
        },
    }
    self:EDB().tooltip = {
        alwaysCompareItems = true,
        RaidProg = {
            enable = true,
        },
        showFaction = true,
    }
    self:EDB().garrison = {
        autoBorder = true,
    }
    self:EDB().datatexts = self:EDB().datatexts or {}
    self:EDB().datatexts.panels = self:EDB().datatexts.panels or {}
    for i = 1, 8 do
        self.SaveMoverPosition(
            "DTPanelNUI_DataPanel_" .. i .. "Mover",
            template[i].point,
            E.UIParent,
            template[i].point,
            template[i].x,
            0
        )
    end
    self.SaveMoverPosition("RaidMarkerBarAnchor", "TOPLEFT", E.UIParent, "TOPLEFT", 513, -51)
    self.SaveMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 3, 880)
    self.SaveMoverPosition("LeftChatMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 0, 22)
    self.SaveMoverPosition("GMMover", "TOPLEFT", E.UIParent, "TOPLEFT", 242, -27)
    self.SaveMoverPosition("BuffsMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -182, -23)
    self.SaveMoverPosition("GhostFrameMover", "TOP", E.UIParent, "TOP", -11, -251)
    self.SaveMoverPosition("LocationMover", "TOP", E.UIParent, "TOP", 3, -25)
    self.SaveMoverPosition("BossButton", "BOTTOM", E.UIParent, "BOTTOM", -73, 208)
    self.SaveMoverPosition("MirrorTimer3Mover", "TOP", E.UIParent, "TOP", -2, -237)
    self.SaveMoverPosition("ElvUF_RaidpetMover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 415, 335)
    self.SaveMoverPosition("RightChatMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -5, 24)
    self.SaveMoverPosition("CooldownBarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -5, 207)
    self.SaveMoverPosition("ElvUF_PetMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 150)
    self.SaveMoverPosition("MicrobarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 0, 203)
    self.SaveMoverPosition("UIErrorsFrameMover", "TOP", E.UIParent, "TOP", 7, -304)
    self.SaveMoverPosition("ElvUF_TargetMover", "BOTTOM", E.UIParent, "BOTTOM", 346, 299)
    self.SaveMoverPosition("EnemyBattlePetMover", "BOTTOM", E.UIParent, "BOTTOM", 348, 141)
    self.SaveMoverPosition("AltPowerBarMover", "BOTTOM", E.UIParent, "BOTTOM", 8, 130)
    self.SaveMoverPosition("ElvUF_Raid40Mover", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 5, 859)
    self.SaveMoverPosition("MirrorTimer1Mover", "TOP", E.UIParent, "TOP", -2, -209)
    self.SaveMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", 5, 93)
    self.SaveMoverPosition("ElvAB_2", "BOTTOM", E.UIParent, "BOTTOM", 5, 52)
    self.SaveMoverPosition("RaidUtility_Mover", "TOPLEFT", E.UIParent, "TOPLEFT", 550, -28)
    self.SaveMoverPosition("TalkingHeadFrameMover", "BOTTOM", E.UIParent, "BOTTOM", 48, 405)
    self.SaveMoverPosition("ReputationBarMover", "BOTTOM", "ExperienceBarMover", "TOP", 0, 4)
    self.SaveMoverPosition("BattlePetMover", "BOTTOM", E.UIParent, "BOTTOM", -327, 138)
    self.SaveMoverPosition("ElvAB_3", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 435, 466)
    self.SaveMoverPosition("ElvAB_5", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 430, 418)
    self.SaveMoverPosition("ArtifactBarMover", "BOTTOM", "ReputationBarMover", "TOP", 0, 4)
    self.SaveMoverPosition("ShiftAB", "TOPLEFT", E.UIParent, "BOTTOMLEFT", 4, 1196)
    self.SaveMoverPosition("MirrorTimer2Mover", "TOP", E.UIParent, "TOP", -3, -228)
    self.SaveMoverPosition("HonorBarMover", "TOP", E.UIParent, "TOP", -6, -127)
    self.SaveMoverPosition("ElvAB_6", "BOTTOM", E.UIParent, "BOTTOM", 4, 13)
    self.SaveMoverPosition("TooltipMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -433, 218)
    self.SaveMoverPosition("ElvUF_TargetTargetMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 110)
    self.SaveMoverPosition("ElvUF_PlayerMover", "TOPLEFT", E.UIParent, "TOPLEFT", 673, -457)
    self.SaveMoverPosition("TotemBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 548, 140)
    self.SaveMoverPosition("ElvUF_PartyMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 0, 607)
    self.SaveMoverPosition("AlertFrameMover", "BOTTOM", E.UIParent, "BOTTOM", 12, 377)
    self.SaveMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 42)
    self.SaveMoverPosition("MinimapMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", 0, -21)
    self:EDB().gridSize = 128
    self:EDB().tooltip = {
        fontSize = 12,
        healthBar = {
            font = self.db.font,
        },
        font = self.db.font,
    }
    self:EDB().unitframe = {
        fontSize = 12,
        units = {
            pet = {
                enable = false,
                castbar = {
                    height = 5.00000095367432,
                    width = 128.333419799805,
                },
            },
            boss = {
                castbar = {
                    height = 5.00000095367432,
                    width = 214.166656494141,
                },
            },
            party = {
                rdebuffs = {
                    font = self.db.font,
                },
            },
            player = {
                debuffs = {
                    attachTo = "BUFFS",
                },
                portrait = {
                    enable = true,
                },
                castbar = {
                    enable = false,
                    insideInfoPanel = false,
                    height = 8.33332252502441,
                    width = 52.4999542236328,
                },
                enable = false,
                width = 54,
                orientation = "MIDDLE",
                buffs = {
                    enable = true,
                    noDuration = false,
                    attachTo = "FRAME",
                },
                height = 250,
                aurabar = {
                    enable = false,
                },
            },
            ["raid40"] = {
                rdebuffs = {
                    font = self.db.font,
                },
            },
            focus = {
                enable = false,
                castbar = {
                    height = 5.00000095367432,
                    width = 188.333282470703,
                },
            },
            target = {
                portrait = {
                    enable = true,
                },
                smartAuraDisplay = "DISABLED",
                enable = false,
                orientation = "MIDDLE",
                castbar = {
                    enable = false,
                    height = 8.33334064483643,
                    width = 268.333312988281,
                },
                aurabar = {
                    enable = false,
                },
            },
            arena = {
                castbar = {
                    height = 4.99996471405029,
                    width = 197.499862670898,
                },
            },
            raid = {
                rdebuffs = {
                    font = self.db.font,
                },
                raidWideSorting = false,
            },
            targettarget = {
                enable = false,
            },
        },
        smoothbars = true,
        colors = {
            castColor = {
                r = 0.1,
                g = 0.1,
                b = 0.1,
            },
            auraBarBuff = {
                r = 0.1,
                g = 0.1,
                b = 0.1,
            },
            health = {
                r = 0.1,
                g = 0.1,
                b = 0.1,
            },
            classResources = {
                WARLOCK = {
                    [3] = {
                        b = 0.305882352941177,
                        g = 0.901960784313726,
                        r = 0.529411764705882,
                    },
                },
            },
        },
        fontOutline = "",
        font = self.db.font,
        statusbar = self.db.texture,
        hud = {
            copied = true,
            hideOOC = true,
        },
    }
    self:EDB().actionbar = {
        ["bar3"] = {
            enabled = false,
            backdrop = true,
        },
        ["bar6"] = {
            enabled = true,
        },
        ["bar2"] = {
            enabled = true,
            backdrop = true,
        },
        ["bar5"] = {
            enabled = false,
        },
        font = self.db.font,
        fontOutline = "",
        ["bar4"] = {
            enabled = false,
        },
        microbar = {
            enabled = true,
        },
        backdropSpacingConverted = true,
    }
    self:EDB().CBPO = {
        player = {
            overlay = false,
        },
    }
    self:EDB().bags = {
        countFontSize = 12,
        countFont = self.db.font,
        itemLevelFont = self.db.font,
        itemLevelFontOutline = "",
        itemLevelFontSize = 12,
        ignoreItems = "",
        strata = "DIALOG",
    }
    self:EDB().chat = {
        chatHistory = false,
        font = self.db.font,
        tabFont = self.db.font,
        tapFontSize = 12,
        fontSize = 12,
    }
end

function NI:ElvUIGlobalSetup()
    self:DatatextPanelSetup()
    self:GlobalNameplateSetup()
    if not NUI.Lulupeep then self:NihilistzscheDatatextPanelSetup() end
end

NI:RegisterGlobalAddOnInstaller("ElvUI", NI.ElvUIGlobalSetup)
