local NUI, E, _, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer
local COMP = NUI.Compatibility

local tFilter = _G.tFilter

NI.ClassMountFavorites = {
    PRIEST = {
        [256] = {
            favFlyer = 861,
            favGround = 861
        },
        [257] = {
            favFlyer = 861,
            favGround = 861
        },
        [258] = {
            favFlyer = 861,
            favGround = 861
        }
    },
    WARLOCK = {
        [266] = {
            favFlyer = 898,
            favGround = 898
        },
        [267] = {
            favFlyer = 930,
            favGround = 930
        },
        [265] = {
            favFlyer = 931,
            favGround = 931
        }
    }
}

function NI:GlobalNameplateSetup()
    local classes = {}
    _G.FillLocalizedClassList(classes, false)
    E.global.nameplates.filters.Active_BattlePet_PBN = {
        actions = {
            scale = 1.1,
            alpha = 100,
            show = true
        },
        triggers = {
            instanceType = {
                petBattle = true
            },
            isActiveBattlePetPBN = true,
            priority = 90,
            isBattlePetPBN = true
        }
    }
    E.global.nameplates.filters.Inactive_BattlePet_PBN = {
        actions = {
            scale = 0.8,
            alpha = 50,
            show = true
        },
        triggers = {
            instanceType = {
                petBattle = true
            },
            isBattlePetPBN = true,
            isNotActiveBattlePetPBN = true,
            priority = 91
        }
    }
    classes = tFilter(classes, function(k,_) return k ~= "Adventurer" end)
    for c, filterClassName in pairs(classes) do
        self.classColor = E:ClassColor(c, true)
        E.global.nameplates.filters["Ally_BattlePet_PBN_" .. filterClassName] = {
            actions = {
                color = {
                    healthColor = self:Color(),
                    health = true
                }
            },
            triggers = {
                instanceType = {
                    petBattle = true
                },
                class = {
                    [c] = {
                        enabled = true
                    }
                },
                isBattlePetPBN = true,
                isAllyBattlePetPBN = true,
                priority = 92
            }
        }
        E.global.nameplates.filters["Enemy_BattlePet_PBN_" .. filterClassName] = {
            actions = {
                color = {
                    healthColor = self:ModColor(
                        function(x)
                            return math.max(1 - x, 0.15)
                        end
                    ),
                    health = true
                }
            },
            triggers = {
                instanceType = {
                    petBattle = true
                },
                class = {
                    [c] = {
                        enabled = true
                    }
                },
                isBattlePetPBN = true,
                isEnemyPattlePetPBN = true,
                priority = 93
            }
        }
    end
    E.global.nameplates.filters.Neutral_NonTarget_PBN = {
        actions = {
            hide = true
        },
        triggers = {
            instanceType = {
                petBattle = true
            },
            nameplateType = {
                enemyNPC = true,
                enable = true,
                friendlyNPC = true
            },
            isNotBattlePetPBN = true,
            priority = 94
        }
    }
    E.global.nameplates.filters.Hide_PlayerNP_DuringPetBattle = {
        actions = {
            hide = true
        },
        triggers = {
            nameplateType = {
                player = true,
                enable = true
            },
            priority = 95,
            instanceType = {
                petBattle = true
            }
        }
    }
    if COMP.PA then
        E.global.nameplates.filters.BattlePet_PBN_PA = {
            actions = {
                tags = {
                    name = "[pbuf:qualitycolor][pbuf:name]",
                    level = "[pbuf:qualitycolor][pbuf:level]",
                    title = "[pbuf:breed]",
                    health = "[pbuf:health:percent]",
                    power = "[pbuf:xp:current-max-percent]"
                }
            },
            triggers = {
                instanceType = {
                    petBattle = true
                },
                isBattlePetPBN = true,
                priority = 99
            }
        }
    end
end

NI:RegisterGlobalAddOnInstaller("ElvUI_NihilistzscheUI", NI.GlobalNameplateSetup)

function NI:NihilistzscheUISetup(isSpec)
    local filterClassName = self.currentLocalizedClass
    self:EDB().nameplates.filters.Active_BattlePet_PBN = {
        triggers = {
            enable = true
        }
    }
    self:EDB().nameplates.filters.Inactive_BattlePet_PBN = {
        triggers = {
            enable = true
        }
    }
    self:EDB().nameplates.filters["Ally_BattlePet_PBN_" .. filterClassName] = {
        triggers = {
            enable = true
        }
    }
    self:EDB().nameplates.filters["Enemy_BattlePet_PBN_" .. filterClassName] = {
        triggers = {
            enable = true
        }
    }
    self:EDB().nameplates.filters.Neutral_NonTarget_PBN = {
        triggers = {
            enable = true
        }
    }
    self:EDB().nameplates.filters.Hide_PlayerNP_DuringPetBattle = {
        triggers = {
            enable = true
        }
    }
    if COMP.PA then
        self:EDB().nameplates.filters.BattlePet_PBN_PA = {
            triggers = {
                enable = true
            }
        }
    end
    self:EDB().nihilistzscheui = {}
    self:EDB().nihilistzscheui.autolog = {
        enabled = true
    }
    self:EDB().nihilistzscheui.nihilistzschechat = {
        windows = {
            font = self.db.font
        }
    }
    self:EDB().nihilistzscheui.cooldownBar = {
        autohide = true
    }
    self:EDB().nihilistzscheui.enhancedshadows = {
        shadowcolor = self:Color()
    }
    self:EDB().nihilistzscheui.enhancednameplateauras = {
        ccDebuffCasterInfo = {
            font = self.db.font,
            fontOutline = "THINOUTLINE"
        }
    }
    self:EDB().nihilistzscheui.hiddenArtifactTracker = {
        enabled = false,
        font = self.db.font
    }
    self:EDB().nihilistzscheui.petbattleautostart = {
        autoQuestAccept = true,
        autoQuestComplete = true,
        autoStartBattle = true
    }
    self:EDB().nihilistzscheui.pxp = {
        texture = self.db.texture,
        font = self.db.font
    }
    self:EDB().nihilistzscheui.utilitybars = {
        hideincombat = true,
        baitBar = {
            mouseover = not NUI.Lulupeep
        },
        equipmentManagerBar = {
            mouseover = not NUI.Lulupeep
        },
        engineertoybar = {
            mouseover = not NUI.Lulupeep,
            toys = {
                [60854] = false
            }
        },
        portalBar = {
            enabled = true,
            mouseover = not NUI.Lulupeep
        },
        professionBar = {
            mouseover = not NUI.Lulupeep
        },
        raidPrPBNar = {
            enabled = true,
            mouseover = not NUI.Lulupeep
        },
        specSwitchBar = {
            enabled = true,
            mouseover = not NUI.Lulupeep
        },
        toybar = {
            mouseover = not NUI.Lulupeep,
            buttonsPerRow = 6
        },
        toolsOfTheTradeBar = {
            mouseover = not NUI.Lulupeep
        },
        farmBar = {
            notify = not COMP.LST
        },
        trackerbar = {
            notify = not COMP.LST
        }
    }
    self:EDB().nihilistzscheui.raidCDs = {
        texture = self.db.texture,
        font = self.db.font,
        solo = true
    }
    local castbars = {
        size = {
            horizontal = {
                halfBar = true
            }
        }
    }
    local aurabars = {
        size = {
            halfBar = true
        }
    }

    self:EDB().nihilistzscheui.vuf = {
        hideOOC = not NUI.Lulupeep,
        units = {
            pettarget = {enabled = false},
            player = {
                castbar = castbars,
                aurabars = aurabars
            },
            target = {castbar = castbars, aurabars = aurabars},
            pet = {aurabars = aurabars}
        }
    }
    if self.currentClass == "WARLOCK" then
        self:EDB().nihilistzscheui.warlockdemons = {
            font = self.db.font,
            texture = self.db.texture,
            attachToNamePlate = true
        }
    end

    for unit, tbl in pairs(P.nihilistzscheui.vuf.units) do
        for element, etbl in pairs(tbl) do
            if (etbl and type(etbl) == "table" and etbl.value and etbl.value.tag) then
                self:EDB().nihilistzscheui.vuf.units[unit] = self:EDB().nihilistzscheui.vuf.units[unit] or {}
                self:EDB().nihilistzscheui.vuf.units[unit][element] =
                    self:EDB().nihilistzscheui.vuf.units[unit][element] or {}
                self:EDB().nihilistzscheui.vuf.units[unit][element].value =
                    self:EDB().nihilistzscheui.vuf.units[unit][element].value or {}
                self:EDB().nihilistzscheui.vuf.units[unit][element].value.tag = "" .. etbl.value.tag
            end
        end
    end
    if not NUI.Lulupeep and COMP.CT then
        self:EDB().nihilistzscheui.vuf.units.player.health = {
            value = {tag = "[healthcolor][health:current-percent][nui-absorbs]"}
        }
    end
    if not isSpec then
        self:EPRV().nihilistzscheui = self:EPRV().nihilistzscheui or {}
        if self.ClassMountFavorites[self.currentClass] then
            self:EPRV().nihilistzscheui.mounts = {specFavs = {}}
            E:CopyTable(self:EPRV().nihilistzscheui.mounts.specFavs, self.ClassMountFavorites[self.currentClass])
        else
            self:EPRV().nihilistzscheui.mounts = self:EPRV().nihilistzscheui.mounts or {}
        end
        self:EPRV().nihilistzscheui.mounts.favAlt = 460
    end
    self.SaveMoverPosition("NihilistzscheUI_SpecSwitchBarMover", "BOTTOMRIGHT", _G.RightChatPanel, "BOTTOMLEFT", -4, 0)
    if COMP.IsAddOnEnabled("OldGodWhispers") then
        self.SaveMoverPosition("OldGodWhispersDragFrameMover", "BOTTOM", "NihilistzscheUI_SpecSwitchBar", "TOP", 0, 4)
    end

    if self.currentClass == "WARLOCK" then
        self.SaveMoverPosition("WarlockDemonsMover", "TOP", E.UIParent, "TOPRIGHT", -460, -50)
    end
    self.SaveMoverPosition("NihilistzscheUI_PartyXPHolderMover", "TOP", E.UIParent, "TOP", 0, -167)
    self.SaveMoverPosition("ArtifactHiddenAppearanceTrackerMover", "BOTTOM", "AzeriteBarMover", "TOP", 0, 4)
    self.SaveMoverPosition("NihilistzscheChatDockMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -530, -30)
    self.SaveMoverPosition("NihilistzscheUI_EquipmentManagerMover", "BOTTOMLEFT", _G.LeftChatPanel, "BOTTOMRIGHT", 4, 0)
    self.SaveMoverPosition("CooldownBarMover", "BOTTOM", "ElvAB_1", "TOP", 0, 2)
    self.SaveMoverPosition("NihilistzscheUI_ToyBarMover", "BOTTOM", E.UIParent, "BOTTOM", 307, 95)
    self.SaveMoverPosition("NihilistzscheUI_TrackerBarMover", "TOPLEFT", E.UIParent, "TOPLEFT", 0, -30)
    self.SaveMoverPosition("NihilistzscheUI_PortalBarMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -180, -30)
    self.SaveMoverPosition(
        "NihilistzscheUI_ProfessionBarMover",
        "TOPRIGHT",
        "NihilistzscheUI_PortalBar",
        "BOTTOMRIGHT",
        0,
        -4
    )
    self.SaveMoverPosition(
        "NihilistzscheUI_EngineerToyBarMover",
        "TOPRIGHT",
        "NihilistzscheUI_ProfessionBar",
        "BOTTOMRIGHT",
        0,
        -4
    )
    self.SaveMoverPosition("NihilistzscheUF_Player AuraBar Mover", "BOTTOM", E.UIParent, "BOTTOM", -310, 424)
    self.SaveMoverPosition("NihilistzscheUF_Target AuraBar Mover", "BOTTOM", E.UIParent, "BOTTOM", 310, 424)
    self.SaveMoverPosition("NihilistzscheUF_Player Castbar Mover", "BOTTOM", E.UIParent, "BOTTOM", 0, 371)
    self.SaveMoverPosition("NihilistzscheUF_Target Castbar Mover", "BOTTOM", E.UIParent, "BOTTOM", 0, 346)
    self.SaveMoverPosition("AoE CCMover", "TOPLEFT", E.UIParent, "TOPLEFT", 0, -30)
end
