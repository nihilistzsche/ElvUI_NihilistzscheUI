local addon, engine = ...
local _G = _G
local E, L, V, P, G = _G.unpack(_G.ElvUI)
local CH = E.Chat
local DB = E.DataBars

engine.oUF = _G.ElvUF

local NUI = E.Libs.AceAddon:NewAddon(addon, "AceEvent-3.0", "AceHook-3.0")

local LibStub = _G.LibStub
local GetAddOnMetadata = _G.GetAddOnMetadata
local ElvUI_CPU = _G.ElvUI_CPU
local hooksecurefunc = _G.hooksecurefunc
local geterrorhandler = _G.geterrorhandler

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

_G.NUI = NUI

NUI.Version = GetAddOnMetadata("ElvUI_NihilistzscheUI", "Version")
NUI.Title = "|cffff2020NihilistzscheUI|r"
NUI.ShortTitle = "|cffff2020NihiUI|r"

NUI.AnimatedDataBars = NUI:NewModule("AnimatedDataBars")
NUI.AutoLog = NUI:NewModule("AutoLog", "AceEvent-3.0")
NUI.ButtonStyle = NUI:NewModule("ButtonStyle")
NUI.Compatibility = NUI:NewModule("Compatibility")
NUI.CooldownBar = NUI:NewModule("CooldownBar", "AceTimer-3.0", "AceEvent-3.0")
NUI.CustomDataBar = NUI:NewModule("CustomDataBar", "AceTimer-3.0", "AceEvent-3.0")
NUI.DataBarNotifier = NUI:NewModule("DataBarNotifier", "AceTimer-3.0", "AceEvent-3.0")
NUI.EnhancedNameplateAuras = NUI:NewModule("EnhancedNameplateAuras", "AceEvent-3.0")
NUI.EnhancedShadows = NUI:NewModule("EnhancedShadows", "AceEvent-3.0")
NUI.InvertedShadows = NUI:NewModule("InvertedShadows")
NUI.KalielsTrackerMover = NUI:NewModule("KalielsTrackerMover")
NUI.Migration = NUI:NewModule("Migration")
NUI.Misc = NUI:NewModule("Misc")
NUI.Misc.BetterReputationColors = NUI:NewModule("BetterReputationColors")
NUI.Misc.CardinalPoints = NUI:NewModule("CardinalPoints")
NUI.Misc.FlightMode = NUI:NewModule("FlightMode")
NUI.Misc.QuestNpcIcons = NUI:NewModule("QuestNPCIcons", "AceEvent-3.0")
NUI.Misc.Threat = NUI:NewModule("Threat")
NUI.NihilistzscheChat = NUI:NewModule("NihilistzscheChat", "AceEvent-3.0")
NUI.NihilistzscheUIAddOnSkinExtension = NUI:NewModule("NihilistzscheUIAddOnSkinExtension")
NUI.NihilistzscheUIMedia = NUI:NewModule("NihilistzscheUIMedia")
NUI.PartyXP = NUI:NewModule("PartyXP", "AceTimer-3.0", "AceEvent-3.0")
NUI.DataTexts = {}
NUI.DataTexts.ImprovedSystemDataText = NUI:NewModule("ImprovedSystemDataText")
NUI.DataTexts.ProfessionsDataText = NUI:NewModule("ProfessionsDataText")
NUI.DataTexts.TitlesDT = NUI:NewModule("TitlesDT")
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
local pairs, IsAddOnLoaded = pairs, _G.IsAddOnLoaded

_G.BINDING_HEADER_NIHILISTZSCHEUI = "|cffff2020NihilistzscheUI|r"

-- GLOBALS: ElvDB, LibStub

NUI.RegisteredModules = {}
function NUI:RegisterModule(name)
    if self.initialized then
        local module = self:GetModule(name)
        if module and module.Initialize then
            xpcall(function() module:Initialize() end, geterrorhandler())
            if ElvUI_CPU then ElvUI_CPU:RegisterPluginModule("ElvUI_NihilistzschetUI", name, module) end
        end
    end
    self.RegisteredModules[#self.RegisteredModules + 1] = name
end

function NUI:GetRegisteredModules() return self.RegisteredModules end

function NUI:ADDON_LOADED(addonName)
    if addonName == "ElvUI_CPU" then
        ElvUI_CPU:RegisterPlugin(addon)
        for _, moduleName in pairs(self.RegisteredModules) do
            ElvUI_CPU:RegisterPluginModule(addon, moduleName, NUI:GetModule(moduleName))
        end
    end
end

function NUI:DebugPrint(...)
    if self.Debug then print(...) end
end

function NUI:InitializeModules()
    for _, moduleName in next, self.RegisteredModules do
        local module = self:GetModule(moduleName)
        if module.Initialize then xpcall(function() module:Initialize() end, geterrorhandler()) end
    end
end

function NUI:Initialize()
    self.initialized = true

    self:BuildGameMenu()
    self.FixPetJournal()

    self.currentQuestXP = 0

    DB:RegisterCustomQuestXPWatcher("ElvUI_NihilistzscheUI", NUI.CustomQuestXPWatcher)
    CH:AddPluginIcons(self.GetChatIcon)

    self:AddMoverCategories()
    self:SetupProfileCallbacks()
    self:InitializeModules()
    NUI.Installer:Initialize()
    if self.Compatibility.DEV then self:RegisterEvent("ADDON_LOADED") end
end

E.Libs.EP:HookInitialize(NUI, NUI.Initialize)
