local NUI, E, L = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer
local NCFG = NUI:NewModule("NihilistzscheUIConfig")
local EP = E.Libs.EP
local COMP = NUI.Compatibility

local format = _G.format
local tinsert = _G.tinsert

function NCFG.GenerateModuleList()
    local list = ""
    for _, m in pairs(NUI:GetRegisteredModules()) do
        list = list .. m .. "\n"
    end
    return list
end

function NCFG.GenerateInstalledAddOnList()
    local list = ""
    local addons = {}
    if not NUIIDB.installInfo or not NUIIDB.installInfo.installedAddons then return list end
    for i = 1, #NUIIDB.installInfo.installedAddons do
        if NI.InstalledAddOnSet[NUIIDB.installInfo.installedAddons[i]] then
            addons[NI.InstalledAddOnOverrideNames[NUIIDB.installInfo.installedAddons[i]] or NI.InstalledAddOnSet[NUIIDB.installInfo.installedAddons[i]]] =
                true
        end
    end

    for addon, _ in NUI.PairsByKeys(addons) do
        list = list .. addon .. "\n"
    end
    return list
end

function NCFG.GenerateOptions()
    local name = NUI.Title
        .. (": |cff99ff33%s|r"):format(NUI.Version)
        .. " (|cfffe7b2cElvUI|r"
        .. format(": |cff99ff33%s|r", E.version)
    if COMP.SLE then
        local SLE = _G["ElvUI_SLE"][1]
        name = name .. ", " .. (SLE.Title or "|cff9482c9Shadow & Light|r") .. format(": |cff99ff33%s|r", SLE.version)
    end
    if COMP.BUI then
        local BUI = _G.ElvUI_BenikUI[1]
        name = name .. ", " .. BUI.Title .. format(": |cff99ff33%s|r", BUI.Version)
    end
    if COMP.MERS then
        local MER = _G.ElvUI_MerathilisUI[1]
        name = name .. ", " .. MER.Title .. format(": |cff99ff33%s|r", MER.Version)
    end
    name = name .. ")"
    E.Options.name = name
    local ACD = E.Libs.AceConfigDialog

    local function CreateButton(number, text, ...)
        local path = {}
        local num = select("#", ...)
        for i = 1, num do
            local _name = select(i, ...)
            tinsert(path, #path + 1, _name)
        end
        local options = {
            order = number,
            type = "execute",
            name = text,
            func = function() ACD:SelectGroup("ElvUI", "NihilistzscheUI", unpack(path)) end,
        }
        return options
    end
    --Main options group
    E.Options.args.NihilistzscheUI = {
        order = 77,
        type = "group",
        name = [[|TInterface\AddOns\ElvUI_NihilistzscheUI\media\textures\nihilistzscheui_logo:12:12|t|cffff2020NihilistzscheUI|r]],
        args = {
            header = {
                order = 1,
                type = "header",
                name = "|cfff02020NihilistzscheUI|r|r" .. format(": |cff99ff33%s|r", NUI.Version),
            },
            logo = {
                type = "description",
                name = [=[|cffff2020NihilistzscheUI|r is an extension for ElvUI. It adds:
- a lot of new and exclusive features.
- more customization options for existing ones.]=],
                order = 2,
                image = function()
                    return "Interface\\AddOns\\ElvUI_NihilistzscheUI\\media\\textures\\elvui_nihilistzscheui_logo",
                        200,
                        100
                end,
            },
            sep1 = {
                type = "description",
                name = " ",
                order = 3,
            },
            Install = {
                order = 4,
                type = "execute",
                name = "Install",
                desc = "Run the installation process.",
                func = function()
                    NI:Install()
                    E:ToggleOptions()
                end,
            },
            InstallerFont = {
                order = 5,
                type = "select",
                dialogControl = "LSM30_Font",
                name = L["Installer Font"],
                values = _G.AceGUIWidgetLSMlists.font,
                get = function() return E.global.nihilistzscheui.installer.font end,
                set = function(_, value) E.global.nihilistzscheui.installer.font = value end,
            },
            InstallerTexture = {
                order = 6,
                type = "select",
                dialogControl = "LSM30_Statusbar",
                name = L["Installer Texture"],
                values = _G.AceGUIWidgetLSMlists.statusbar,
                get = function() return E.global.nihilistzscheui.installer.texture end,
                set = function(_, value) E.global.nihilistzscheui.installer.texture = value end,
            },
            installerFontSize = {
                type = "range",
                order = 7,
                name = L["Font Size"],
                desc = L["Set the Width of the Text Font"],
                min = 10,
                max = 18,
                step = 1,
                get = function(info) return _G.NUIIDB.fontSize end,
                set = function(info, value) _G.NUIIDB.fontSize = value end,
            },
            sep2 = {
                type = "description",
                order = 8,
                name = " ",
            },
            buttons = {
                order = 9,
                type = "group",
                name = "Module Configuration Shortcuts",
                args = {},
            },
            modules = {
                order = 10,
                type = "group",
                name = "Modules",
                desc = "Module Configuration",
                childGroups = "select",
                args = {},
            },
            addons = {
                order = 7000,
                type = "group",
                name = "Installed AddOn Profiles",
                args = {
                    header = {
                        order = 1,
                        type = "header",
                        name = "Installed AddOn Profiles",
                    },
                    description = {
                        order = 2,
                        type = "description",
                        name = NCFG:GenerateInstalledAddOnList(),
                    },
                },
            },
        },
    }

    local mods = {}

    for _, m in pairs(NUI:GetRegisteredModules()) do
        local mod = NUI:GetModule(m)
        if mod ~= NCFG and mod.GenerateOptions then mods[mod:GetName()] = mod end
    end
    local order = 1
    for _, mod in NUI.PairsByKeys(mods) do
        local options = mod:GenerateOptions()
        if options then
            local _name = mod:GetName()
            E.Options.args.NihilistzscheUI.args.modules.args[_name] = options
            E.Options.args.NihilistzscheUI.args.modules.args[_name].order = order
            E.Options.args.NihilistzscheUI.args.buttons.args[_name .. "Button"] =
                CreateButton(order, E.Options.args.NihilistzscheUI.args.modules.args[_name].name, "modules", _name)
            order = order + 1
        end
    end
end

function NCFG:Initialize() EP:RegisterPlugin("ElvUI_NihilistzscheUI", self.GenerateOptions) end

NUI:RegisterModule(NCFG:GetName())
