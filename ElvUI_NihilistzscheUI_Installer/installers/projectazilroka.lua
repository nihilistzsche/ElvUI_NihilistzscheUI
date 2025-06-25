local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer

function NI:ProjectAzilrokaSetup(isSpec)
    if not isSpec then
        local function Disable() return { Enable = false } end

        local classWhitelist = {
            PRIEST = {
                [194384] = true,
            },
            WARLOCK = {
                [205146] = true,
                [264173] = true,
                [267218] = true,
                [387437] = true,
                [394776] = true,
            },
        }
        local classReminder = {
            WARLOCK = {
                ["Inquisitor's Gaze"] = {
                    ["strictFilter"] = true,
                    ["combat"] = true,
                    ["enable"] = true,
                    ["filterType"] = "SPELL",
                    ["negateGroup"] = {},
                    ["spellGroup"] = {
                        [388068] = true,
                    },
                    ["personal"] = true,
                    ["size"] = 50,
                },
            },
        }
        local whitelist = classWhitelist[self.currentClass] or {}
        local reminder = {
            ["Enable"] = false,
        }
        if classReminder[self.currentClass] then
            reminder["Enable"] = true
            reminder["Filters"] = {}
            reminder["Filters"][self.currentClass] = classReminder[self.currentClass]
        end
        self:SetProfile(_G.ProjectAzilrokaDB, {
            cooldown = {
                fonts = {
                    font = self.db.font,
                },
            },
            SunsongRanchFarmer = {
                Enable = true,
            },
            DragonOverlay = {
                Enable = true,
                FlipDragon = true,
                rare = "HeavenlyJade",
                elite = "HeavenlyOnyx",
                rareelite = "HeavenlyCrimson",
                worldboss = "HeavenlyGolden",
                ClassIcon = true,
                ClassIconPoints = {
                    yOffset = 40,
                },
                DragonPoints = {
                    yOffset = 40,
                },
            },
            EnhancedFriendsList = {
                Enable = true,
                Hero = "Launcher",
                App = "Launcher",
                Pro = "Launcher",
                Neutral = "Launcher",
                ["DST2"] = "Launcher",
                BSAp = "BlizzardChat",
                Alliance = "Flat",
                ["D3"] = "Launcher",
                Horde = "Flat",
                ["S1"] = "Launcher",
                WTCG = "Launcher",
                ["S2"] = "Launcher",
                VIPR = "Launcher",
                NameFont = self.db.font,
                InfoFont = self.db.font,
                StatusIconPack = "Square",
            },
            EnhancedPetBattleUI = {
                Enable = true,
                HideBlizzard = true,
                StatusBarTexture = self.db.texture,
                Font = self.db.font,
            },
            FasterLoot = {
                Enable = true,
            },
            EnhancedShadows = Disable(),
            ItemCooldowns = Disable(),
            MouseoverAuras = Disable(),
            AuraReminder = reminder,
            iFilger = {
                Enable = true,
                Enhancements = Disable(),
                Procs = {
                    Size = 48,
                    Direction = "LEFT",
                    StackCountFont = self.db.font,
                    StatusBar = false,
                    StatusBarFont = self.db.font,
                    StatusBarTexture = self.db.texture,
                    StatusBarTextureColor = self:Color(),
                    FilterByList = "Whitelist",
                    Whitelist = whitelist,
                },
                Cooldowns = Disable(),
                Buffs = Disable(),
                Debuffs = Disable(),
                FocusBuffs = Disable(),
                PvPTargetBuffs = Disable(),
                TargetDebuffs = Disable(),
            },
            SquareMinimapButtons = {
                Enable = true,
                BarMouseOver = true,
                MoveQueue = false,
            },
            LootConfirm = Disable(),
            MovableFrames = Disable(),
            OzCooldowns = {
                StackFont = self.db.font,
                StatusBarTexture = self.db.texture,
                Masque = false,
                StatusBarTextureColor = self:Color(),
            },
            QuestSounds = {
                Enable = true,
                UseSoundID = false,
            },
            TorghastBuffs = {
                growthDirection = "RIGHT_DOWN",
                wrapAfter = 9,
            },
        })
    end

    self:SaveMoverPosition("BattlePetMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 400, 350)
    self:SaveMoverPosition("EnemyBattlePetMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -400, 350)
    self:SaveMoverPosition("SquareMinimapButtonBarMover", "TOPRIGHT", "MinimapPanel", "BOTTOMRIGHT", 0, -4)
    self:SaveMoverPosition("OzCooldownsMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 250)
    self:SaveMoverPosition("iFilger Enhancements", "TOP", E.UIParent, "TOP", 307, -217)
    self:SaveMoverPosition("iFilger Procs", "BOTTOM", E.UIParent, "BOTTOM", 0, 436)
    self:SaveMoverPosition("iFilger Cooldowns", "BOTTOM", E.UIParent, "BOTTOM", 0, 340)
    self:SaveMoverPosition("iFilger Buffs", "TOP", E.UIParent, "TOP", 306, -68)
    self:SaveMoverPosition("Ifilger Debuffs", "TOPRIGHT", E.UIParent, "TOPRIGHT", -489, -479)
    self:SaveMoverPosition("TorghastBuffsMover", "TOPLEFT", E.UIParent, "TOPLEFT", 0, -160)
    self:SaveMoverPosition("SunsongRanchFarmerFarmBar", "TOPLEFT", E.UIParent, "TOPLEFT", 41, -459)
    self:SaveMoverPosition("SunsongRanchFarmerSeedBarMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 4, 423)
end

NI:RegisterAddOnInstaller("ProjectAzilroka", NI.ProjectAzilrokaSetup, true)
