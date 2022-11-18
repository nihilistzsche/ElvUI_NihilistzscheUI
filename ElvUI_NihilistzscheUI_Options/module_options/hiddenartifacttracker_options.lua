local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local HAT = NUI.HiddenArtifactTracker

function HAT:GenerateOptions()
    local options = {
        type = "group",
        name = L["Hidden Artifact Appearance Tracker"],
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["Hidden Artifact Appearance Tracker by Nihilistzsche"],
            },
            description = {
                order = 2,
                type = "description",
                name = L["Hidden Artifact Appearance Tracker helps you track your progress towards unlocking colors for your hidden artifact appearance"],
            },
            general = {
                order = 3,
                type = "group",
                name = L.General,
                guiInline = true,
                get = function(info) return E.db.nihilistzscheui.hiddenArtifactTracker[info[#info]] end,
                set = function(info, value)
                    E.db.nihilistzscheui.hiddenArtifactTracker[info[#info]] = value
                    self:UpdateAll()
                end,
                args = {
                    enabled = {
                        type = "toggle",
                        order = 1,
                        name = L.Enable,
                        desc = L["Enable Hidden Artifact Appearance Tracker."],
                        set = function(info, value)
                            E.db.nihilistzscheui.hiddenArtifactTracker[info[#info]] = value
                            self:UpdateAll()
                        end,
                    },
                    resetsettings = {
                        type = "execute",
                        order = 2,
                        name = L["Reset Settings"],
                        desc = L["Reset the settings of this addon to their defaults."],
                        func = function()
                            local old = E.db.nihilistzscheui.hiddenArtifactTracker.enabled
                            E:CopyTable(
                                E.db.nihilistzscheui.hiddenArtifactTracker,
                                P.nihilistzscheui.hiddenArtifactTracker
                            )
                            if old ~= E.db.nihilistzscheui.hiddenArtifactTracker.enabled then
                                E:StaticPopup_Show("CONFIG_RL")
                            else
                                HAT:UpdateAll()
                            end
                        end,
                    },
                    width = {
                        order = 3,
                        name = L.Width,
                        type = "range",
                        min = 0,
                        max = 600,
                        step = 1,
                    },
                    height = {
                        order = 4,
                        name = L.Height,
                        type = "range",
                        min = 0,
                        max = 100,
                        step = 1,
                    },
                    fontSize = {
                        order = 5,
                        name = L.FontSize,
                        type = "range",
                        min = 9,
                        max = 16,
                        step = 1,
                    },
                    font = {
                        type = "select",
                        dialogControl = "LSM30_Font",
                        order = 6,
                        name = L.Font,
                        values = _G.AceGUIWidgetLSMlists.font,
                    },
                    mouseoverText = {
                        type = "toggle",
                        order = 1,
                        name = L["Mouseover Text"],
                        desc = L["Hide the text unless the moused is over the bar."],
                    },
                },
            },
        },
    }
    return options
end
