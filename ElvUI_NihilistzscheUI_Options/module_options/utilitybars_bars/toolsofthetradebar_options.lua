local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local TOTTB = NUI.UtilityBars.ToolsOfTheTradeBar
if not TOTTB then return end

function TOTTB:GenerateUtilityBarOptions()
    local options = {
        type = "group",
        name = L["Tools of the Trade Bar"],
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["NihilistzscheUI ToolsOfTheTradeBar by Nihilistzsche, based on work by Azilroka"],
            },
            description = {
                order = 2,
                type = "description",
                name = L["NihilistzscheUI ToolsOfTheTradeBar provides a bar to use fishing baits from."],
            },
            general = {
                order = 3,
                type = "group",
                name = "General",
                guiInline = true,
                get = function(info) return E.db.nihilistzscheui.utilitybars.toolsOfTheTradeBar[info[#info]] end,
                set = function(info, value)
                    E.db.nihilistzscheui.utilitybars.toolsOfTheTradeBar[info[#info]] = value
                    self:UpdateBar(self.bar)
                end,
                args = {
                    enabled = {
                        type = "toggle",
                        order = 1,
                        name = L.Enable,
                        desc = L["Enable the bait bar"],
                    },
                    resetsettings = {
                        type = "execute",
                        order = 2,
                        name = L["Reset Settings"],
                        desc = L["Reset the settings of this addon to their defaults."],
                        func = function()
                            E:CopyTable(
                                E.db.nihilistzscheui.utilitybars.toolsOfTheTradeBar,
                                P.nihilistzscheui.utilitybars.toolsOfTheTradeBar
                            )
                            self:UpdateBar(self.bar)
                        end,
                    },
                    mouseover = {
                        type = "toggle",
                        order = 3,
                        name = L.Mouseover,
                        desc = L["Only show the tools of the trade bar when you mouseover it"],
                    },
                    buttonsize = {
                        type = "range",
                        order = 5,
                        name = L.Size,
                        desc = L["Button Size"],
                        min = 12,
                        max = 40,
                        step = 1,
                    },
                    spacing = {
                        type = "range",
                        order = 6,
                        name = L.Spacing,
                        desc = L["Spacing between buttons"],
                        min = 1,
                        max = 10,
                        step = 1,
                    },
                    alpha = {
                        type = "range",
                        order = 7,
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
                        max = 11,
                        step = 1,
                    },
                },
            },
        },
    }
    return options
end
