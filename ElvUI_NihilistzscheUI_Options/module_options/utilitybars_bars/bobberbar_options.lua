local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local BOBB = NUI.UtilityBars.BobberBar
local C_ToyBox_GetToyInfo = _G.C_ToyBox.GetToyInfo
local tinsert = _G.tinsert
local PlayerHasToy = _G.PlayerHasToy
function BOBB:GenerateUtilityBarOptions(onlyBobbers)
    local bobbers = {
        type = "group",
        guiInline = true,
        name = "Bobbers",
        args = {},
    }

    local bobberIDs = {}
    for k in next, self.Bobbers do
        tinsert(bobberIDs, k)
    end
    table.sort(bobberIDs)
    local textureMarkup = [[|T%d:12:12:0:0:64:64:4:56:4:56|t]]
    for i, k in ipairs(bobberIDs) do
        local _, bobberName, texture = C_ToyBox_GetToyInfo(k)
        bobbers.args[tostring(k)] = {
            name = textureMarkup:format(texture) .. (bobberName or ""),
            type = "toggle",
            desc = "Enable the button for " .. (bobberName or ""),
            order = i,
            get = function() return E.db.nihilistzscheui.utilitybars.bobberbar.bobbers[tonumber(k)].enable end,
            set = function(_, value)
                E.db.nihilistzscheui.utilitybars.bobberbar.bobbers[tonumber(k)].enable = value
                self:UpdateBar(self.bar)
            end,
            disabled = function() return not PlayerHasToy(k) end,
        }
    end
    if onlyBobbers then return bobbers end
    local options = {
        type = "group",
        name = L["Bobber Bar"],
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["NihilistzscheUI BobberBar by Nihilistzsche"],
            },
            description = {
                order = 2,
                type = "description",
                name = L["NihilistzscheUI BobberBar provides an automatically updated bar populated with Crates of Bobber toys."],
            },
            general = {
                order = 3,
                type = "group",
                name = L.General,
                guiInline = true,
                get = function(info) return E.db.nihilistzscheui.utilitybars.bobberbar[info[#info]] end,
                set = function(info, value)
                    E.db.nihilistzscheui.utilitybars.bobberbar[info[#info]] = value
                    self:UpdateBar(self.bar)
                end,
                args = {
                    enabled = {
                        type = "toggle",
                        order = 1,
                        name = L.Enable,
                        desc = L["Enable the bobber bar"],
                    },
                    resetsettings = {
                        type = "execute",
                        order = 2,
                        name = L["Reset Settings"],
                        desc = L["Reset the settings of this addon to their defaults."],
                        func = function()
                            E:CopyTable(
                                E.db.nihilistzscheui.utilitybars.bobberbar,
                                P.nihilistzscheui.utilitybars.bobberbar
                            )
                            self:UpdateBar(self.bar)
                        end,
                    },
                    mouseover = {
                        type = "toggle",
                        order = 3,
                        name = L.Mouseover,
                        desc = L["Only show the bobber bar when you mouseover it"],
                    },
                    buttonsize = {
                        type = "range",
                        order = 4,
                        name = L.Size,
                        desc = L["Button Size"],
                        min = 12,
                        max = 40,
                        step = 1,
                    },
                    spacing = {
                        type = "range",
                        order = 5,
                        name = L.Spacing,
                        desc = L["Spacing between buttons"],
                        min = 1,
                        max = 10,
                        step = 1,
                    },
                    alpha = {
                        type = "range",
                        order = 6,
                        name = L.Alpha,
                        desc = L["Alpha of the bar"],
                        min = 0.2,
                        max = 1,
                        step = 0.1,
                    },
                    buttonsPerRow = {
                        type = "range",
                        order = 8,
                        name = L["Buttons Per Row"],
                        desc = L["Number of buttons on each row"],
                        min = 1,
                        max = 12,
                        step = 1,
                    },
                },
            },
        },
    }

    options.args.bobbers = bobbers

    return options
end
