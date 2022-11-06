local NUI, E, _, _, _, G = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer
local COMP = NUI.Compatibility
local NP = E.NamePlates

local LoadAddOn = _G.LoadAddOn
local tinsert = _G.tinsert
local tContains = _G.tContains
local wipe = _G.wipe
local format = _G.format
local UnitSex = _G.UnitSex

NI.DataTextsByRole = {
    Tank = "Armor",
    CasterDPS = "Primary Stat",
    MeleeDPS = "Attack Power",
    Healer = "Primary Stat",
}

function NI.SaveMoverPosition(mover, anchor, parent, point, x, y)
    NI:EDB().movers = NI:EDB().movers or {}
    NI:EDB().movers[mover] =
        format("%s,%s,%s,%d,%d", anchor, type(parent) == "string" and parent or parent:GetName(), point, x, y)
end

function NI:InitBaseProfile(n, r)
    self.baseProfile = (n or E.myname) .. " - " .. (r or E.myrealm)
    if n then self.currentName = n end
    if r then self.currentRealm = r end
    if not n then self.baseProfileKey = E.myLocalizedClass .. " - NihilistzscheUI" end
end

function NI:UpdateProfileKey(overrideKey)
    local isFemale = UnitSex("player") == 3
    local lclass = isFemale and _G.LOCALIZED_CLASS_NAMES_FEMALE[self.currentClass]
        or _G.LOCALIZED_CLASS_NAMES_MALE[self.currentClass]
    self.currentLocalizedClass = lclass
    self.profileKey = lclass .. " - " .. (overrideKey and overrideKey or "NihilistzscheUI")
    if not overrideKey then self.privateProfileKey = lclass .. " - NihilistzscheUI" end
end

function NI:SetProfile(db, tbl, overrideKey)
    db.profiles[overrideKey or self.profileKey] = tbl
    if not overrideKey then
        self:AddAddOnDB(db)
    else
        self:AddProfileKey(db, self.baseProfile, overrideKey)
    end
end

NI.ClassSpecProfiles = {
    DEATHKNIGHT = { "Tank", "MeleeDPS", "MeleeDPS" },
    DEMONHUNTER = { "MeleeDPS", "Tank" },
    DRUID = { "CasterDPS", "MeleeDPS", "Tank", "Healer" },
    HUNTER = "MeleeDPS",
    MAGE = "CasterDPS",
    MONK = { "Tank", "Healer", "MeleeDPS" },
    PALADIN = { "Healer", "Tank", "MeleeDPS" },
    PRIEST = { "Healer", "Healer", "CasterDPS" },
    ROGUE = "MeleeDPS",
    SHAMAN = { "CasterDPS", "MeleeDPS", "Healer" },
    WARLOCK = "CasterDPS",
    WARRIOR = { "MeleeDPS", "MeleeDPS", "Tank" },
    EVOKER = { "CasterDPS", "Healer" }
}

function NI:SetupSpecProfiles()
    local tbl = self.ClassSpecProfiles[self.currentClass]
    if tbl and type(tbl) == "table" then
        local seenRole = {}
        for _, role in ipairs(tbl) do
            if not seenRole[role] then
                self:UpdateProfileKey(role)
                self:ElvUISetup(role, true)
                self:NameplateSetup()
                self:NihilistzscheUISetup(true)
                for addon, func in pairs(self.ElvUIModifiers) do
                    if COMP.IsAddOnEnabled(addon) then func(self, true) end
                end
                seenRole[role] = true
            end
        end
        _G.ElvDB.namespaces["LibDualSpec-1.0"].char[self.baseProfile] = { enabled = true }
        for i, role in ipairs(tbl) do
            _G.ElvDB.namespaces["LibDualSpec-1.0"].char[self.baseProfile][i] = self.currentLocalizedClass
                .. " - "
                .. role
        end
    end
end

function NI:ColorBase(settings)
    if not settings or type(settings) ~= "table" then settings = { mod = E.noop, alpha = false, keyStyle = "key" } end

    local includeAlpha = settings.alpha
    local classColor = self.classColor
    local r, g, b = classColor.r, classColor.g, classColor.b
    if settings.mod and type(settings.mod) == "function" and settings.mod ~= E.noop then
        r, g, b = settings.mod(r), settings.mod(g), settings.mod(b)
    end
    if not settings.keyStyle or settings.keyStyle == "key" then
        local out = { r = r, g = g, b = b }
        if includeAlpha then out.a = 1 end
        return out
    else
        local out = { r, g, b }
        if includeAlpha then tinsert(out, 1) end
        return out
    end
end

function NI:Color(includeAlpha)
    local settings = {
        mod = E.noop,
        alpha = includeAlpha == true,
        keyStyle = "key",
    }
    return self:ColorBase(settings)
end

function NI:ModColor(modFunc, includeAlpha)
    local settings = {
        mod = modFunc,
        alpha = includeAlpha == true,
        keyStyle = "key",
    }
    return self:ColorBase(settings)
end

function NI:IColor(includeAlpha)
    local settings = {
        mod = E.noop,
        alpha = includeAlpha == true,
        keyStyle = "index",
    }
    return self:ColorBase(settings)
end

NI.InstalledAddOnSet = {}
NI.ElvUIModifiers = {}
NI.InstalledAddOnOverrideNames = {}
NI.CharacterSpecificAddOnFunctions = {}
NI.AddOnSetupFunctions = {}
NI.GlobalAddOnSetupFunctions = {}

function NI:RegisterAddOnInstaller(addonName, func, overrideName, characterSpecific)
    if not characterSpecific then
        self.AddOnSetupFunctions[addonName] = func
    else
        self.CharacterSpecificAddOnFunctions[addonName] = func
    end
    self.InstalledAddOnSet[string.lower(addonName)] = addonName
    if overrideName and type(overrideName) == "string" then
        self.InstalledAddOnOverrideNames[string.lower(addonName)] = overrideName
    elseif overrideName and type(overrideName) == "boolean" then
        NI.ElvUIModifiers[addonName] = func
    end
end

function NI:RegisterGlobalAddOnInstaller(addonName, func) self.GlobalAddOnSetupFunctions[addonName] = func end

function NI:RunGlobalAddOnInstallers()
    for addon, setupFunc in pairs(self.GlobalAddOnSetupFunctions) do
        if COMP.IsAddOnEnabled(addon) then
            LoadAddOn(addon)
            setupFunc(self)
        end
    end
end

function NI:RunAddOnInstallers()
    for addon, setupFunc in pairs(self.AddOnSetupFunctions) do
        if COMP.IsAddOnEnabled(addon) then
            LoadAddOn(addon)
            setupFunc(self)
        end
    end
end

function NI:RunCharacterSpecificAddOnInstallers()
    for addon, setupFunc in pairs(self.CharacterSpecificAddOnFunctions) do
        if COMP.IsAddOnEnabled(addon) then
            LoadAddOn(addon)
            setupFunc(self)
        end
    end
end

function NI:CharacterSpecificSetup(realm, name)
    if not NI.HasCharacterSpecificSetup then return end
    if NI.HasCharacterSpecificSetup[realm] then
        if NI.HasCharacterSpecificSetup[realm][name] then self[NI.HasCharacterSpecificSetup[realm][name]](self) end
    end
end

function NI:GetInstalledAddOnSet()
    local addons = {}

    for addon, addonName in pairs(self.InstalledAddOnSet) do
        if COMP.IsAddOnEnabled(addonName) then tinsert(addons, addon) end
    end

    return addons
end

function NI.AreInstalledAddOnsEqual(installedAddOnSetA, installedAddOnSetB)
    for _, installedAddOn in ipairs(installedAddOnSetA) do
        if not tContains(installedAddOnSetB, installedAddOn) then print("Missing ",installedAddOn, " from B set.") return false end
    end

    for _, installedAddOn in ipairs(installedAddOnSetB) do
        if not tContains(installedAddOnSetA, installedAddOn) then print("Missing ", installedAddOn, " from a set.")return false end
    end

    return true
end

function NI:ShouldInstall()
    if _G.NUIIDB and _G.NUIIDB.skipped then return false end

    local tbl = _G.NUIIDB.installInfo

    if not tbl then print("No install info table.") return true end

    local currentInstalledAddOnSet = self:GetInstalledAddOnSet()

    local prevInstalledAddOnSet = tbl.installedAddons or {}

    if tbl.version < NI.GetInstallVersion() or tbl.installerBuild < NI.GetInstallBuild() then return true end

    --if not self.AreInstalledAddOnsEqual(currentInstalledAddOnSet, prevInstalledAddOnSet) then return true end

    if self.db.texture == G.nihilistzscheui.installer.texture and self.db.font == G.nihilistzscheui.installer.font then
        return false
    end

    if not tbl.installerDetails then return true end

    if tbl.installerDetails.texture ~= self.db.texture or tbl.installerDetails.font ~= self.db.font then return true end

    local isSpecProfileClass = type(self.ClassSpecProfiles[E.myclass]) == "table"

    local specProfileTbl
    if
        not NUI.Lulupeep
        and (
            _G.ElvDB.namespaces
            and _G.ElvDB.namespaces["LibDualSpec-1.0"]
            and _G.ElvDB.namespaces["LibDualSpec-1.0"].char
        )
    then
        specProfileTbl = _G.ElvDB.namespaces["LibDualSpec-1.0"].char[self.baseProfile]
    end

    if isSpecProfileClass then
        if not specProfileTbl then return not NUI.Lulupeep end
        if not specProfileTbl.enabled then return true end
        local profileBase = E.myLocalizedClass .. " - "
        for i = 1, #NI.ClassSpecProfiles[E.myclass] do
            if specProfileTbl[i] ~= profileBase .. NI.ClassSpecProfiles[E.myclass][i] then return true end
        end
        return false
    end

    if _G.ElvDB.profileKeys[self.baseProfile] ~= self.baseProfileKey then return true end

    return false
end

function NI:SaveInstallerVersion(skipping)
    wipe(_G.NUIIDB)
    if skipping then
        _G.NUIIDB.skipped = true
    else
        _G.NUIIDB.installInfo = { version = self.GetInstallVersion(), installerBuild = self.GetInstallBuild() }
    end
end

function NI:SaveInstallerDetails()
    _G.NUIIDB.installInfo.installerDetails = { texture = self.db.texture, font = self.db.font }
end

NI.savedPluginTables = {}

function NI:SaveInstallTable(tbl)
    if not self.savedPluginTables[tbl] then
        self.savedPluginTables[tbl] = tbl.installTable
        tbl.installTable = nil
    end
end

function NI:RestoreSavedInstallers()
    for tbl, install in pairs(self.savedPluginTables) do
        tbl.installTable = install
    end
    wipe(self.savedPluginTables)
end

function NI:EDB()
    _G.ElvDB.profiles[self.profileKey] = _G.ElvDB.profiles[self.profileKey] or {}
    return _G.ElvDB.profiles[self.profileKey]
end

function NI:EPRV()
    _G.ElvPrivateDB.profiles[self.privateProfileKey] = _G.ElvPrivateDB.profiles[self.privateProfileKey] or {}
    return _G.ElvPrivateDB.profiles[self.privateProfileKey]
end

-- This function includes the code from ElvUI that corresponds to the options I would select during
-- installation.
function NI.BaseElvUISetup()
    --SetupChat
    FCF_ResetChatWindows() -- Monitor this
    FCF_SetLocked(_G.ChatFrame1, 1)
    FCF_DockFrame(_G.ChatFrame2)
    FCF_SetLocked(_G.ChatFrame2, 1)

    --FCF_OpenNewWindow(LOOT)
    FCF_UnDockFrame(_G.ChatFrame3)
    FCF_SetLocked(_G.ChatFrame3, 1)
    _G.ChatFrame3:Show()

    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G[format("ChatFrame%s", i)]

        -- move general bottom left
        if i == 1 then
            frame:ClearAllPoints()
            frame:Point("BOTTOMLEFT", _G.LeftChatToggleButton, "TOPLEFT", 1, 3)
        elseif i == 3 then
            frame:ClearAllPoints()
            frame:Point("BOTTOMLEFT", _G.RightChatDataPanel, "TOPLEFT", 1, 3)
        end

        FCF_SavePositionAndDimensions(frame)
        FCF_StopDragging(frame)

        -- set default Elvui font size
        local fontSize = NUIIDB.fontSize or (NUI.Lulupeep and 16 or 12)
        FCF_SetChatWindowFontSize(nil, frame, fontSize)
        NUIIDB.fontSize = fontSize
        -- rename windows general because moved to chat #3
        if i == 1 then
            FCF_SetWindowName(frame, GENERAL)
        elseif i == 2 then
            FCF_SetWindowName(frame, GUILD_EVENT_LOG)
        elseif i == 3 then
            FCF_SetWindowName(frame, LOOT .. " / " .. TRADE)
        end
    end

    -- keys taken from `ChatTypeGroup` but doesnt add: 'OPENING', 'TRADESKILLS', 'PET_INFO', 'COMBAT_MISC_INFO', 'COMMUNITIES_CHANNEL', 'PET_BATTLE_COMBAT_LOG', 'PET_BATTLE_INFO', 'TARGETICONS'
    local chatGroup = {
        "SYSTEM",
        "CHANNEL",
        "SAY",
        "EMOTE",
        "YELL",
        "WHISPER",
        "PARTY",
        "PARTY_LEADER",
        "RAID",
        "RAID_LEADER",
        "RAID_WARNING",
        "INSTANCE_CHAT",
        "INSTANCE_CHAT_LEADER",
        "GUILD",
        "OFFICER",
        "MONSTER_SAY",
        "MONSTER_YELL",
        "MONSTER_EMOTE",
        "MONSTER_WHISPER",
        "MONSTER_BOSS_EMOTE",
        "MONSTER_BOSS_WHISPER",
        "ERRORS",
        "AFK",
        "DND",
        "IGNORED",
        "BG_HORDE",
        "BG_ALLIANCE",
        "BG_NEUTRAL",
        "ACHIEVEMENT",
        "GUILD_ACHIEVEMENT",
        "BN_WHISPER",
        "BN_INLINE_TOAST_ALERT",
    }
    ChatFrame_RemoveAllMessageGroups(_G.ChatFrame1)
    for _, v in ipairs(chatGroup) do
        ChatFrame_AddMessageGroup(_G.ChatFrame1, v)
    end

    -- keys taken from `ChatTypeGroup` which weren't added above to ChatFrame1
    chatGroup = { "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "CURRENCY", "MONEY" }
    ChatFrame_RemoveAllMessageGroups(_G.ChatFrame3)
    for _, v in ipairs(chatGroup) do
        ChatFrame_AddMessageGroup(_G.ChatFrame3, v)
    end

    ChatFrame_AddChannel(_G.ChatFrame1, GENERAL)
    ChatFrame_RemoveChannel(_G.ChatFrame1, TRADE)
    ChatFrame_AddChannel(_G.ChatFrame3, TRADE)

    -- set the chat groups names in class color to enabled for all chat groups which players names appear
    chatGroup = {
        "SAY",
        "EMOTE",
        "YELL",
        "WHISPER",
        "PARTY",
        "PARTY_LEADER",
        "RAID",
        "RAID_LEADER",
        "RAID_WARNING",
        "INSTANCE_CHAT",
        "INSTANCE_CHAT_LEADER",
        "GUILD",
        "OFFICER",
        "ACHIEVEMENT",
        "GUILD_ACHIEVEMENT",
        "COMMUNITIES_CHANNEL",
    }
    for i = 1, _G.MAX_WOW_CHAT_CHANNELS do
        tinsert(chatGroup, "CHANNEL" .. i)
    end
    for _, v in ipairs(chatGroup) do
        ToggleChatColorNamesByClassGroup(true, v)
    end

    -- Adjust Chat Colors
    ChangeChatColor("CHANNEL1", 195 / 255, 230 / 255, 232 / 255) -- General
    ChangeChatColor("CHANNEL2", 232 / 255, 158 / 255, 121 / 255) -- Trade
    ChangeChatColor("CHANNEL3", 232 / 255, 228 / 255, 121 / 255) -- Local Defense

    if E.Chat then
        E.Chat:PositionChats()
        if E.db.RightChatPanelFaded then _G.RightChatToggleButton:Click() end

        if E.db.LeftChatPanelFaded then _G.LeftChatToggleButton:Click() end
    end
    -- SetCVars
    SetCVar("statusTextDisplay", "BOTH")
    SetCVar("screenshotQuality", 10)
    SetCVar("chatMouseScroll", 1)
    SetCVar("chatStyle", "classic")
    SetCVar("WholeChatWindowClickable", 0)
    SetCVar("showTutorials", 0)
    SetCVar("UberTooltips", 1)
    SetCVar("threatWarning", 3)
    SetCVar("alwaysShowActionBars", 1)
    SetCVar("lockActionBars", 1)
    SetCVar("SpamFilter", 0)
    SetCVar("cameraDistanceMaxZoomFactor", 2.6)
    SetCVar("showQuestTrackingTooltips", 1)
    SetCVar("fstack_preferParentKeys", 0) --Add back the frame names via fstack!
    SetCVar("minimapTrackingShowAll", 1)
    NP:CVarReset()

    SetCVar("nameplateMaxDistance", 100)

    --_G.InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue("SHIFT")
    --_G.InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()

    E:SetupTheme("class", true)

    if not NUIIDB.uiScaleSet then
        E.global.general.UIScale = 0.64
        NUIIDB.uiScaleSet = true
    end
    E:PixelScaleChanged()

    if
        type(NI.ClassSpecProfiles[E.myclass]) == "table" and not NUIIDB.reloadedThisClass
        or not NUIIDB.reloadedThisClass[E.myclass]
    then
        C_Timer.After(2, function()
            NUIIDB.reloadedThisClass = NUIIDB.reloadedThisClass or {}
            NUIIDB.reloadedThisClass[E.myclass] = true
            ReloadUI()
        end)
    end
end
