local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

local COMP = NUI.Compatibility

function NI.MerathilisUIGlobalSetup()
    local baseProfileKey = E.myLocalizedClass .. " - NihilistzscheUI"
    local baseBlacklist = _G.ElvDB.profiles[baseProfileKey].mui.autoButtons.blackList
    for key, tbl in pairs(_G.ElvDB.profiles) do
        if key ~= baseProfileKey then
            if tbl.mui and tbl.mui.autoButtons then tbl.mui.autoButtons.blackList = E:CopyTable({}, baseBlacklist) end
        end
    end

    E.global.mui = E.global.mui or {}
    E.global.mui.core = E.global.mui.core or {}
    E.global.mui.core.fixCVAR = false
end

NI:RegisterGlobalAddOnInstaller("ElvUI_MerathilisUI", NI.MerathilisUIGlobalSetup)

function NI:MerathilisUISetup(isSpec)
    self:EDB().mui = self:EDB().mui or {}
    self:EDB().mui.installed = true
    _G.MERDataPerChar = _G.ElvUI_MerathilisUI[1].Version
    self:EDB().mui.general = {
        splashScreen = false,
        gmotd = false,
    }
    self:EDB().mui.autoButtons = self:EDB().mui.autoButtons or {}
    self:EDB().mui.autoButtons.customList = {
        87216, -- [1]
        144341, -- [2]
    }
    self:EDB().mui.misc = {
        nameHover = false,
        mawThreatBar = {
            font = {
                name = self.db.font,
            },
        },
        lfgInfo = {
            line = {
                tex = self.db.texture,
            },
        },
    }
    self:EDB().mui.raidmarkers = {
        enable = true,
        backdrop = true,
    }
    self:EDB().mui.raidBuffs = {
        enable = true,
        class = true,
    }
    self:EDB().mui.merchant = {
        enable = false,
    }

    self:EDB().mui.bags = {
        Enable = false,
    }
    self:EDB().mui.autoButtons.bar2 = {
        include = "POTIONSL,FLASKSL,UTILITY,CUSTOM",
    }
    self:EDB().mui.autoButtons.bar3 = {
        include = "MAGEFOOD,FOODVENDOR,FOODSL",
    }
    self:EDB().mui.panels = {
        bottomPanel = false,
        topPanel = false,
        panelSize = 600,
        stylePanels = {
            topLeftExtraPanel = false,
            topRightExtraPanel = false,
            bottomLeftExtraPanel = false,
            bottomRightExtraPanel = false,
        },
    }
    self:EDB().mui.microBar = {
        visibility = "show",
    }
    self:EDB().mui.chat = {
        panelHeight = 180,
    }
    self:EDB().mui.datatexts = {
        [2] = { enable = false },
        rightChatTabDatatextPanel = { enable = false },
    }
    self:EDB().mui.tooltip = {
        modelIcon = true,
        progressInfo = {
            raid = {
                Nyalotha = false,
                EternalPalace = false,
            },
        },
    }
    self:EDB().mui.misc = {
        nameHover = false,
        mawThreatBar = {
            font = {
                name = self.db.font,
            },
        },
        lfgInfo = {
            line = {
                tex = self.db.texture,
            },
        },
    }
    self:EDB().mui.smb = {
        enable = false,
    }
    self:EDB().mui.raidmarkers = {
        enable = true,
        backdrop = true,
    }
    self:EDB().mui.raidBuffs = {
        enable = true,
        class = true,
    }
    self:EDB().mui.blizzard = {
        objectiveTracker = {
            info = {
                name = self.db.font,
            },
        },
    }
    if not isSpec then
        self:EPRV().muiSkins = {
            blizzard = {
                merchant = false,
            },
        }
        self:EPRV().mui = self:EPRV().mui or {}
        self:EPRV().mui.skins = {
            embed = {
                enable = false,
            },
        }
    end
    self.SaveMoverPosition("MER_RaidBuffReminderMover", "TOPLEFT", E.UIParent, "TOPLEFT", 238, -141)
    self.SaveMoverPosition("MER_RaidManager", "TOPRIGHT", E.UIParent, "TOPRIGHT", -179, -190)
    self.SaveMoverPosition("Notification Mover", "TOP", E.UIParent, "TOP", 0, -120)
    if NUI.Private then
        self.SaveMoverPosition("mUI_RaidMarkerBarAnchor", "TOPRIGHT", E.UIParent, "TOPRIGHT", -179, -166)
    else
        self.SaveMoverPosition("mUI_RaidMarkerBarAnchor", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -4, 313)
    end
    self.SaveMoverPosition("AutoButtonBar1Mover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -398, 334)
    self.SaveMoverPosition("AutoButtonBar2Mover", "TOP", "AutoButtonBar1Mover", "BOTTOM", 0, -4)
    self.SaveMoverPosition("AutoButtonBar3Mover", "TOP", "AutoButtonBar2Mover", "BOTTOM", 0, -4)
    self.SaveMoverPosition("SpellFeedback", "BOTTOM", UIParent, "BOTTOM", 0, 415)

    if COMP.LCP then
        self:EDB().mui.locPanel = {
            enable = false,
        }
        self.SaveMoverPosition("MicroBarAnchor", "TOP", "LocationPlusPanel", "BOTTOM", 0, -2)
    end
end

if COMP.MERS then NI:SaveInstallTable(_G.ElvUI_MerathilisUI[1]) end

NI:RegisterAddOnInstaller("ElvUI_MerathilisUI", NI.MerathilisUISetup, true)
