local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local TOYB = NUI.UtilityBars.ToyBar

function TOYB:GenerateUtilityBarOptions()
    local options = {
        type = "group",
        name = L["Toy Bar"],
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["NihilistzscheUI ToyBar by Nihilistzsche"],
            },
            description = {
                order = 2,
                type = "description",
                name = L["NihilistzscheUI ToyBar provides an automatically updated bar populated with your favorite toys."],
            },
            general = {
                order = 3,
                type = "group",
                name = L.General,
                guiInline = true,
                get = function(info) return E.db.nihilistzscheui.utilitybars.toybar[info[#info]] end,
                set = function(info, value)
                    E.db.nihilistzscheui.utilitybars.toybar[info[#info]] = value
                    self:UpdateBar(self.bar)
                end,
                args = {
                    enabled = {
                        type = "toggle",
                        order = 1,
                        name = L.Enable,
                        desc = L["Enable the toy bar"],
                    },
                    resetsettings = {
                        type = "execute",
                        order = 2,
                        name = L["Reset Settings"],
                        desc = L["Reset the settings of this addon to their defaults."],
                        func = function()
                            E:CopyTable(E.db.nihilistzscheui.utilitybars.toybar, P.nihilistzscheui.utilitybars.toybar)
                            self:UpdateBar(self.bar)
                        end,
                    },
                    mouseover = {
                        type = "toggle",
                        order = 3,
                        name = L.Mouseover,
                        desc = L["Only show the toy bar when you mouseover it"],
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

    return options
end
