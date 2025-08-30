---@class NUI
local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer
local COMP = NUI.Compatibility

function NI:ChatTweaksSetup()
    _G.ElvUI_ChatTweaksDB = _G.ElvUI_ChatTweaksDB or {}
    _G.ElvUI_ChatTweaksDB.global = _G.ElvUI_ChatTweaksDB.global or {}

    _G.ElvUI_ChatTweaksDB.global.modules = _G.ElvUI_ChatTweaksDB.global.modules or {}

    _G.ElvUI_ChatTweaksDB.global.modules["XP Left to Level"] = false
    _G.ElvUI_ChatTweaksDB.global.modules["Reputation"] = false
end

NI:RegisterGlobalAddOnInstaller("ElvUI_ChatTweaks", NI.ChatTweaksSetup)
