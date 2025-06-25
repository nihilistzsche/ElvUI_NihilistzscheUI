local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local RCD = NUI.RaidCDs

local C_Spell_GetSpellName = _G.C_Spell.GetSpellName

function RCD:GenerateOptions()
    local options = {
        type = "group",
        name = L["Raid CDs"],
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["Raid CDs"],
            },
            description = {
                order = 2,
                type = "description",
                name = L["NihilistzscheUI Raid CDs provides a list of raid cds separated by category.\n"],
            },
            general = {
                order = 3,
                type = "group",
                name = L.General,
                guiInline = true,
                args = {
                    enabled = {
                        type = "toggle",
                        order = 1,
                        name = L.Enable,
                        desc = L["Enable the raid cds."],
                        get = function(info) return self.db[info[#info]] end,
                        set = function(info, value)
                            self.db[info[#info]] = value
                            self:UpdateEnableState()
                        end,
                    },
                    resetsettings = {
                        type = "execute",
                        order = 2,
                        name = L["Reset Settings"],
                        desc = L["Reset the settings of this addon to their defaults."],
                        func = function()
                            E:CopyTable(E.db.nihilistzscheui.raidcds, P.nihilistzscheui.raidcds)
                            self:UpdateEnableState()
                            self:UpdateMedia()
                            RCD:GROUP_ROSTER_UPDATE()
                        end,
                    },
                },
            },
            raidCDOptions = {
                order = 4,
                type = "group",
                name = L["Raid CD Options"],
                guiInline = true,
                get = function(info) return self.db[info[#info]] end,
                set = function(info, value) self.db[info[#info]] = value end,
                args = {
                    font = {
                        type = "select",
                        dialogControl = "LSM30_Font",
                        order = 1,
                        name = L["Default Font"],
                        desc = L["The font that the text on the cd bars will use."],
                        values = _G.AceGUIWidgetLSMlists.font,
                        get = function(info) return self.db[info[#info]] end,
                        set = function(info, value)
                            self.db[info[#info]] = value
                            self:UpdateMedia()
                        end,
                    },
                    fontSize = {
                        type = "range",
                        order = 2,
                        name = L["Font Size"],
                        desc = L["Set the size of the Text Font"],
                        min = 10,
                        max = 18,
                        step = 1,
                        get = function(info) return self.db[info[#info]] end,
                        set = function(info, value)
                            self.db[info[#info]] = value
                            self:UpdateMedia()
                        end,
                    },
                    texture = {
                        type = "select",
                        dialogControl = "LSM30_Statusbar",
                        order = 3,
                        name = L["Primary Texture"],
                        desc = L["The texture that will be used for the experience bars."],
                        values = _G.AceGUIWidgetLSMlists.statusbar,
                        get = function(info) return self.db[info[#info]] end,
                        set = function(info, value)
                            self.db[info[#info]] = value
                            self:UpdateMedia()
                        end,
                    },
                    width = {
                        type = "range",
                        order = 4,
                        name = L.Width,
                        desc = L["Width of the raid cd bar"],
                        min = 5,
                        max = 800,
                        step = 1,
                        get = function(info) return self.db[info[#info]] end,
                        set = function(info, value)
                            self.db[info[#info]] = value
                            self:UpdateCDs()
                        end,
                    },
                    height = {
                        type = "range",
                        order = 5,
                        name = L.Height,
                        desc = L["Height of the raid cd bar"],
                        min = 5,
                        max = 800,
                        step = 1,
                        get = function(info) return self.db[info[#info]] end,
                        set = function(info, value)
                            self.db[info[#info]] = value
                            self:UpdateCDs()
                        end,
                    },
                },
            },
            visibilityStates = {
                order = 5,
                type = "group",
                name = L.Visibility,
                guiInline = true,
                get = function(info) return self.db[info[#info]] end,
                set = function(info, value)
                    self.db[info[#info]] = value
                    self:GROUP_ROSTER_UPDATE()
                end,
                args = {
                    solo = {
                        type = "toggle",
                        order = 1,
                        name = L.Solo,
                        desc = L["Show when solo"],
                    },
                    party = {
                        type = "toggle",
                        order = 2,
                        name = L["In Party"],
                        desc = L["Show when only in a party"],
                    },
                    raid = {
                        type = "toggle",
                        order = 3,
                        name = L["In Raid"],
                        desc = L["Show when in a raid group"],
                    },
                    onlyInCombat = {
                        type = "toggle",
                        order = 4,
                        name = L["Only in Combat"],
                        desc = L["Show only when in combat"],
                        set = function(info, value)
                            self.db[info[#info]] = value
                            self:CheckCombatState()
                        end,
                    },
                },
            },
            cooldowns = {
                order = 6,
                type = "group",
                childGroups = "select",
                name = "Cooldowns",
                desc = "Disable cooldowns to stop tracking them",
                args = {},
            },
        },
    }

    local function AddOptionsForCategory(category, order)
        local categoryOptions = {
            name = category,
            type = "group",
            get = function(info) return self.db.cooldowns[category][tonumber(info[#info])] end,
            set = function(info, value)
                self.db.cooldowns[category][tonumber(info[#info])] = value
                RCD:GROUP_ROSTER_UPDATE()
            end,
            order = order,
            args = {},
        }

        local o = 1
        for k, _ in pairs(self.categories[category]) do
            categoryOptions.args[tostring(k)] = {
                name = C_Spell_GetSpellName(k),
                type = "toggle",
                desc = "Uncheck to disable tracking",
                order = o,
            }
            o = o + 1
        end

        options.args.cooldowns.args[category] = categoryOptions
    end

    local co = 1
    local categories = { "aoeCC", "externals", "raidCDs", "utilityCDs", "immunities", "interrupts", "battleRes" }
    for _, category in ipairs(categories) do
        AddOptionsForCategory(category, co)
        co = co + 1
    end

    return options
end
