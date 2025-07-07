local addon, engine = ...
local _G = _G
local E, L, V, P, G = _G.unpack(_G.ElvUI)
local CH = E.Chat
local DB = E.DataBars
local CallbackHandler = _G.LibStub("CallbackHandler-1.0")

engine.oUF = _G.ElvUF

---@class NUI : AceAddon-3.0, AceEvent-3.0, AceHook-3.0, CallbackHandler-1.0
local NUI = E.Libs.AceAddon:NewAddon(addon, "AceEvent-3.0", "AceHook-3.0")
NUI.callbacks = NUI.callbacks or CallbackHandler:New(NUI)

local LibStub = _G.LibStub
local GetAddOnMetadata = (_G.C_AddOns or _G).GetAddOnMetadata

NUI.Libs = {
    NT = LibStub("LibNihilistzscheUITags-1.0"),
    GI = LibStub("LibGroupInSpecT-1.1"),
    CandyBar = LibStub("LibCandyBar-3.0"),
    PT = LibStub("LibPeriodicTable-3.1"),
    FL = LibStub("LibFishing-1.0-NUI"),
}

engine[1] = NUI
engine[2] = E
engine[3] = L
engine[4] = V
engine[5] = P
engine[6] = G
_G[addon] = engine

NUI.Version = GetAddOnMetadata("ElvUI_NihilistzscheUI", "Version")
NUI.Title = "|cffff2020NihilistzscheUI|r"
NUI.ShortTitle = "|cffff2020NihiUI|r"

NUI.AnimatedDataBars = NUI:NewModule("AnimatedDataBars")
NUI.AutoLog = NUI:NewModule("AutoLog", "AceEvent-3.0")
NUI.BagEquipmentSetIcon = NUI:NewModule("BagEquipmentSetIcon")
NUI.ButtonStyle = NUI:NewModule("ButtonStyle")
NUI.Compatibility = NUI:NewModule("Compatibility")
NUI.CooldownBar = NUI:NewModule("CooldownBar", "AceTimer-3.0", "AceEvent-3.0")
NUI.CustomDataBar = NUI:NewModule("CustomDataBar", "AceTimer-3.0", "AceEvent-3.0")
NUI.DataBarNotifier = NUI:NewModule("DataBarNotifier", "AceTimer-3.0", "AceEvent-3.0")
NUI.EnhancedNameplateAuras = NUI:NewModule("EnhancedNameplateAuras", "AceEvent-3.0")
NUI.EnhancedShadows = NUI:NewModule("EnhancedShadows", "AceEvent-3.0")
NUI.InvertedShadows = NUI:NewModule("InvertedShadows")

NUI.Migration = NUI:NewModule("Migration")
NUI.Misc = NUI:NewModule("Misc")
NUI.Misc.AddMountIDToTooltip = NUI:NewModule("AddMountIDToTooltip")
NUI.Misc.BetterReputationColors = NUI:NewModule("BetterReputationColors")
NUI.Misc.CardinalPoints = NUI:NewModule("CardinalPoints")
NUI.Misc.ChatItemLevelGems = NUI:NewModule("ChatItemLevelGems")
NUI.Misc.DifficultyTooltipFix = NUI:NewModule("DifficultyTooltipFix")
NUI.Misc.FlightMode = NUI:NewModule("FlightMode")
NUI.Misc.QuestNpcIcons = NUI:NewModule("QuestNPCIcons", "AceEvent-3.0")
NUI.Misc.Threat = NUI:NewModule("Threat")
NUI.Misc.UltimateMouseCursorHealthCircleClassColor = NUI:NewModule("UltimateMouseCursorHealthCircleClassColor")
NUI.NihilistzscheChat = NUI:NewModule("NihilistzscheChat", "AceEvent-3.0")
NUI.NihilistzscheUIAddOnSkinExtension = NUI:NewModule("NihilistzscheUIAddOnSkinExtension")
NUI.NihilistzscheUIMedia = NUI:NewModule("NihilistzscheUIMedia")
NUI.PartyXP = NUI:NewModule("PartyXP", "AceTimer-3.0", "AceEvent-3.0")
NUI.DataTexts = {}
NUI.DataTexts.ImprovedSystemDataText = NUI:NewModule("ImprovedSystemDataText")
NUI.DataTexts.ProfessionsDataText = NUI:NewModule("ProfessionsDataText")
NUI.DataTexts.TitlesDT = NUI:NewModule("TitlesDT")
NUI.DataTexts.PetBattleChallengeDataText = NUI:NewModule("PetBattleChallengeDataText")
NUI.DataTexts.HeirloomUpgradeDataText = NUI:NewModule("HeirloomUpgradeDataText")
NUI.DataTexts.HeritageArmorTrackerDataText = NUI:NewModule("HeritageArmorTrackerDataText")
NUI.RematchExpandedScriptFilter = NUI:NewModule("RematchExpandedScriptFilter", "AceEvent-3.0")
NUI.RPStyleFilter = NUI:NewModule("RPStyleFilter")
NUI.SLEEquipManagerExtension = NUI:NewModule("SLEEquipManagerExtension", "AceEvent-3.0")
NUI.UtilityBars = NUI:NewModule("UtilityBars", "AceEvent-3.0")
NUI.UtilityBars.FarmBar = NUI:NewModule("FarmBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
NUI.UtilityBars.TrackerBar = NUI:NewModule("TrackerBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
NUI.UtilityBars.PortalBar = NUI:NewModule("PortalBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
NUI.UtilityBars.ProfessionBar = NUI:NewModule("ProfessionBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
NUI.UtilityBars.RaidPrepBar = NUI:NewModule("RaidPrepBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
NUI.VerticalUnitFrames = NUI:NewModule("VerticalUnitFrames", "AceTimer-3.0", "AceEvent-3.0")

if E.Retail or E.Wrath then
    NUI.SetTransfer = NUI:NewModule("SetTransfer", "AceHook-3.0", "AceEvent-3.0")
    NUI.UtilityBars.EquipmentManagerBar =
        NUI:NewModule("EquipmentManagerBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
end

if E.Retail then
    NUI.HiddenArtifactTracker = NUI:NewModule("HiddenArtifactTracker", "AceEvent-3.0")
    NUI.PetBattleAutoStart = NUI:NewModule("PetBattleAutoStart", "AceEvent-3.0")
    NUI.PetBattleNameplates = NUI:NewModule("PetBattleNameplates", "AceEvent-3.0")
    NUI.PetBattleVerticalUnitFrames = NUI:NewModule("PetBattleVerticalUnitFrames", "AceHook-3.0", "AceEvent-3.0")
    NUI.RaidCDs = NUI:NewModule("RaidCDs", "AceEvent-3.0")
    NUI.UtilityBars.BaitBar = NUI:NewModule("BaitBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
    NUI.UtilityBars.BobberBar = NUI:NewModule("BobberBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
    NUI.UtilityBars.EngineerToyBar = NUI:NewModule("EngineerToyBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
    NUI.UtilityBars.ToolsOfTheTradeBar =
        NUI:NewModule("ToolsOfTheTradeBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
    NUI.UtilityBars.ToyBar = NUI:NewModule("ToyBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
    NUI.UtilityBars.SpecSwitchBar = NUI:NewModule("SpecSwitchBar", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
    NUI.WarlockDemons = NUI:NewModule("WarlockDemons", "AceEvent-3.0")
end
local pairs = pairs

_G.BINDING_HEADER_NIHILISTZSCHEUI = "|cffff2020NihilistzscheUI|r"

-- GLOBALS: ElvDB, LibStub

NUI.RegisteredModules = {}
NUI.DelayedRegisteredModules = {}

function NUI:RegisterModule(name, delayed)
    if self.initialized then
        local module = self:GetModule(name)
        if module and module.Initialize then module:Initialize() end
    end
    self.RegisteredModules[#self.RegisteredModules + 1] = name
    if not self.initialized and delayed then
        self.DelayedRegisteredModules[#self.DelayedRegisteredModules + 1] = name
    end
end

function NUI:GetRegisteredModules() return self.RegisteredModules end

function NUI:DebugPrint(...)
    if self.Debug then print(...) end
end

do
    function NUI:InitializeModules()
        for _, moduleName in ipairs(self.RegisteredModules) do
            local module = self:GetModule(moduleName)

            if module.Initialize and not tContains(self.DelayedRegisteredModules, moduleName) then
                module:Initialize()
            end
        end
    end

    function NUI:DelayedInitialize()
        for _, moduleName in ipairs(self.DelayedRegisteredModules) do
            local module = self:GetModule(moduleName)

            -- Whgy would a module say it was delayed without Initialize, but just to be safe
            if module.Initialize then module:Initialize() end
        end
    end
end

function NUI:Initialize()
    self.initialized = true

    if NUI.Debug then _G.NUI = NUI end

    --self:BuildGameMenu()
    self.FixPetJournal()

    self.currentQuestXP = 0

    DB:RegisterCustomQuestXPWatcher("ElvUI_NihilistzscheUI", NUI.CustomQuestXPWatcher)
    CH:AddPluginIcons(self.GetChatIcon)

    self:AddMoverCategories()
    self:SetupProfileCallbacks()
    self:InitializeModules()
    if self.Installer then
        self.Installer:Initialize()
    end

    C_Timer.After(3, function() NUI:DelayedInitialize() end)
end

E.Libs.EP:HookInitialize(NUI, NUI.Initialize)
