---@class NUI
local NUI, E, L = _G.unpack((select(2, ...)))
local DT = E.DataTexts

local COMP = NUI.Compatibility

local displayString = ""
local Eversion = E.version
local format = _G.format
local IsAddOnLoaded = _G.C_AddOns.IsAddOnLoaded
local C_AddOns_LoadAddOn = _G.C_AddOns.LoadAddOn
local GAME_VERSION_LABEL = _G.GAME_VERSION_LABEL

local function OnEvent(self) self.text:SetText(displayString) end

local ACD
local function Click()
    E:ToggleOptions()

    ACD = ACD or E.Libs.AceConfigDialog
    if not ACD then
        if not IsAddOnLoaded("ElvUI_Options") then C_AddOns_LoadAddOn("ElvUI_Options") end
        ACD = E.Libs.AceConfigDialog
    end
    if ACD then ACD:SelectGroup("ElvUI", "NihilistzscheUI") end
end

local function PrintURL(url) -- Credit: Azilroka
    return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

local function OnEnter(self)
    DT:SetupTooltip(self)

    DT.tooltip:AddDoubleLine("ElvUI " .. GAME_VERSION_LABEL .. format(": |cff99ff33%s|r", Eversion))
    DT.tooltip:AddLine(" ")

    if COMP.SLE then
        local SLE = _G["ElvUI_SLE"][1]
        DT.tooltip:AddLine(
            (SLE.Title or L.SLE_AUTHOR_INFO) .. GAME_VERSION_LABEL .. format(": |cff99ff33%s|r", SLE.version)
        )
        DT.tooltip:AddLine(" ")
        DT.tooltip:AddLine(
            SLE.Title
                .. format("v|cff00c0fa%s|r", SLE.version)
                .. L[" is loaded. For any issues or suggestions, please vist "]
                .. PrintURL("https://git.tukui.org/shadow-and-light/shadow-and-light/issues")
        )
        DT.tooltip:AddLine(" ")
    end

    if COMP.BUI then
        local BUI = _G.ElvUI_BenikUI[1]
        DT.tooltip:AddLine(BUI.Title .. GAME_VERSION_LABEL .. format(": |cff99ff33%s|r", BUI.Version))
        DT.tooltip:AddLine(" ")
        DT.tooltip:AddLine(
            BUI.Title
                .. format("v|cff00c0fa%s|r", BUI.Version)
                .. L[" is loaded. For any issues or suggestions, please visit "]
                .. PrintURL("http://git.tukui.org/Benik/ElvUI_BenikUI/issues")
        )
        DT.tooltip:AddLine(" ")
    end

    if COMP.MERS then
        local MER = _G.ElvUI_MerathilisUI[1]
        DT.tooltip:AddLine(MER.Title .. GAME_VERSION_LABEL .. format(": |cff99ff33%s|r", MER.Version))
        DT.tooltip:AddLine(" ")
        DT.tooltip:AddLine(
            MER.Title
                .. format("v|cff00c0fa%s|r", MER.Version)
                .. L[" is loaded. For any issues or suggestions, please visit "]
                .. PrintURL("https://git.tukui.org/Merathilis/ElvUI_MerathilisUI/issues")
        )
        DT.tooltip:AddLine(" ")
    end

    DT.tooltip:AddLine(NUI.Title .. " " .. GAME_VERSION_LABEL .. format(": |cff99ff33%s|r", NUI.Version))
    DT.tooltip:AddLine(" ")
    DT.tooltip:AddLine(
        NUI.Title
            .. " "
            .. format("v|cff00c0fa%s|r", NUI.Version)
            .. L[" is loaded. For any issues or suggestions, please visit "]
            .. PrintURL("https://git.tukui.org/Nihilistzsche/ElvUI_NihilistzscheUI/issues")
    )

    DT.tooltip:Show()
end

local function ValueColorUpdate()
    local name = NUI.ShortTitle
        .. (": |cff99ff33%s|r"):format(NUI.Version)
        .. " (|cfffe7b2cElvUI|r"
        .. format(": |cff99ff33%s|r", E.version)
    if COMP.SLE then
        name = name .. ", |cff9482c9S&L|r"
        name = name .. format(": |cff99ff33%s|r", _G["ElvUI_SLE"][1].version)
    end
    if COMP.BUI then
        local BUI = _G.ElvUI_BenikUI[1]
        name = name .. ", |cff00c0faBUI|r" .. format(": |cff99ff33%s|r", BUI.Version)
    end
    if COMP.MERS then
        local MER = _G.ElvUI_MerathilisUI[1]
        name = name .. ", |cffff7d0aMUI|r"
        name = name .. format(": |cff99ff33%s|r", MER.Version == "development" and "dev" or MER.Version)
    end

    name = name .. ")"
    displayString = name
end

DT:RegisterDatatext(
    "NihilistzscheUI Version",
    "NihilistzscheUI",
    { "PLAYER_ENTERING_WORLD" },
    OnEvent,
    nil,
    Click,
    OnEnter,
    nil,
    nil,
    nil,
    ValueColorUpdate
)
