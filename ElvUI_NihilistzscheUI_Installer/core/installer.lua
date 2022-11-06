local NUI, E, L = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = E.Libs.AceAddon:NewAddon("NinihilistzscheUI_Installer")
NUI.Installer = NI

-- luacheck: globals NUIIDB ElvDB
local _G = _G

local RAID_CLASS_COLORS, pairs, unpack, format, ReloadUI, print =
    _G.RAID_CLASS_COLORS, _G.pairs, _G.unpack, _G.format, _G.ReloadUI, _G.print
local tinsert = _G.tinsert
local C_Timer_After = _G.C_Timer.After
local wipe = _G.wipe

NUIIDB = {}

NI.DiscordURL = "https://discord.gg/cUcr3Dt"
function NI:CacheMovers(new)
    self.db = self.db or {}
    self.db.movers = self.db.movers or {}
    if not new then
        self.db.movers.old = E:CopyTable(E.db.movers)
    else
        self.db.movers.new = E:CopyTable(E.db.movers)
    end
end

-- DB, key, value
NI.ProfileKeysToSet = {}
NI.AddOnDBs = {}

function NI:AddAddOnDB(db) self.AddOnDBs[db] = true end

function NI:AddProfileKey(db, key, val) tinsert(self.ProfileKeysToSet, { db, key, val }) end

function NI:SetProfileKeys()
    for _, kp in ipairs(self.ProfileKeysToSet) do
        local db, key, val = _G.unpack(kp)
        db.profileKeys[key] = val
    end
end

function NI:InstallForClass(class)
    local role = type(self.ClassSpecProfiles[class]) == "table" and self.ClassSpecProfiles[class][1]
        or self.ClassSpecProfiles[class]
    self.currentRole = role
    if NUI.Lulupeep then
        self:ElvUILuluSetup()
    else
        self:ElvUISetup(role)
    end
    self:NameplateSetup()
    self:NihilistzscheUISetup()
    self:RunAddOnInstallers()
    local NM = NUI.Migration
    NM:CheckMigrations()
end

function NI:SetupForCharacters()
    if _G.ElvDB.namespaces and _G.ElvDB.namespaces["LibDualSpec-1.0"] then
        wipe(_G.ElvDB.namespaces["LibDualSpec-1.0"])
    end
    for s, l in pairs(_G.ElvDB.class) do
        for n, c in pairs(l) do
            self.currentClass = c
            self.classColor = E:ClassColor(c, true)
            self:UpdateProfileKey()
            self:InitBaseProfile(n, s)
            self:InstallForClass(c)
            self:CharacterSpecificSetup(s, n)
            for db in pairs(self.AddOnDBs) do
                self:AddProfileKey(db, self.baseProfile, self.profileKey)
            end
            self:RunCharacterSpecificAddOnInstallers()
            if not NUI.Lulupeep then self:SetupSpecProfiles() end
        end
    end
end

function NI:Run()
    self:AddAddOnDB(_G.ElvDB)
    self:AddAddOnDB(_G.ElvPrivateDB)
    self:SetupForCharacters()
    self:SetProfileKeys()
    self:RunGlobalAddOnInstallers()
    self:SaveInstallerVersion()
    self:SaveInstallerDetails()
    NUIIDB.installInfo.installedAddons = self:GetInstalledAddOnSet()
end

function NI:PrintMoverDiscrepancies()
    for k, v in pairs(self.db.movers.old) do
        if not self.db.movers.new[k] then
            print("The following mover was not found that existed previously: ", k)
            local p, par, rp, x, y = _G.unpack(v)
            print("With the following anchor: ", p, par:GetName(), rp, x, y)
        end
    end
end

_G.SLASH_NUIMOVERDISC1 = "/nuimd"
_G.SlashCmdList.NUIMOVERDISC = function() NI:PrintMoverDiscrepancies() end

NI.installTable = {
    Name = NUI.Title,
    Title = NUI.Title .. " Installation",
    tutorialImage = [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\elvui_nihilistzscheui_logo.tga]],
    Pages = {
        [1] = function()
            local PluginInstallFrame = _G.PluginInstallFrame
            -- luacheck: no max line length
            PluginInstallFrame.SubTitle:SetText(format(L["Welcome to %s version %s!"], NUI.Title, NUI.Version))
            PluginInstallFrame.Desc1:SetText(
                L["This will take you through a quick install process to setup NihilistzscheUI.\nIf you choose to not setup any options through this config, click Skip to finsh the installation."]
            )
            PluginInstallFrame.Desc2:SetText("")

            PluginInstallFrame.Option1:Show()
            PluginInstallFrame.Option1:SetScript("OnClick", function()
                NI:SaveInstallerVersion(true)
                ReloadUI()
            end)
            PluginInstallFrame.Option1:SetText("Skip")
        end,
        [2] = function()
            local PluginInstallFrame = _G.PluginInstallFrame
            -- luacheck: no max line length
            PluginInstallFrame.SubTitle:SetText("Use Authors Defaults")
            PluginInstallFrame.Desc1:SetText(
                "Choose your class if you would like to setup NihilistzscheUI to match the authors defaults for your role.\nChoose finish if you would like to keep your current setup."
            )
            PluginInstallFrame.Desc2:SetText("")

            E:CheckRole()
            PluginInstallFrame.Option1:Show()
            PluginInstallFrame.Option1:SetText(E.myLocalizedClass)
            PluginInstallFrame.Option1:SetScript("OnClick", function()
                NI:Run()
                ReloadUI()
            end)

            PluginInstallFrame.Option2:Show()
            PluginInstallFrame.Option2:SetText("Finish")
            PluginInstallFrame.Option2:SetScript("OnClick", function()
                NI:SaveInstallerVersion(true)
                ReloadUI()
            end)

            PluginInstallFrame.Option3:Show()
            PluginInstallFrame.Option3:SetText("Discord")
            PluginInstallFrame.Option3:SetScript(
                "OnClick",
                function() E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, NI.DiscordURL) end
            )
        end,
    },
    StepTitles = {
        [1] = _G.START,
        [2] = "Use Authors Defaults",
    },
    StepTitlesColorSelected = E.myclass == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[E.myclass],
    StepTitleWidth = 200,
    StepTitleButtonWidth = 200,
    StepTitleTextJustification = "CENTER",
}
local tryInstall
tryInstall = function()
    if not _G.PluginInstallFrame then
        C_Timer_After(1, tryInstall)
        return
    end
    if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
    E.private.install_complete = E.version
    local PI = E.PluginInstaller
    PI:Queue(NI.installTable)
    PI:RunInstall()
end

function NI.Install() tryInstall() end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
    C_Timer_After(5, function() NI:BaseElvUISetup() end)
    f:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

function NI:Initialize()
    self.initialized = true
    self.db = E.global.nihilistzscheui.installer

    self:InitBaseProfile()
    if self:ShouldInstall() then
        self.Install()
    else
        self:RestoreSavedInstallers()
    end
end

E.Libs.EP:HookInitialize(NI, NI.Initialize)
