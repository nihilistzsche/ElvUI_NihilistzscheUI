local NUI, E, L, _, P, _ = _G.unpack(_G.ElvUI_NihilistzscheUI) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames
if not VUF then
    return
end
local UF = E.UnitFrames

local NONE = _G.NONE
local gsub = _G.gsub

local positionValues = {
    TOPLEFT = "TOPLEFT",
    LEFT = "LEFT",
    BOTTOMLEFT = "BOTTOMLEFT",
    RIGHT = "RIGHT",
    TOPRIGHT = "TOPRIGHT",
    BOTTOMRIGHT = "BOTTOMRIGHT",
    CENTER = "CENTER",
    TOP = "TOP",
    BOTTOM = "BOTTOM"
}

local growthValues = {
    UP = L.Up,
    DOWN = L.Down
}

function VUF:GenerateValidAnchors(unit, element, value)
    local anchors = {self = "self", ui = "ui"}

    for e, _ in pairs(self.units[unit]) do
        if value or e ~= element then
            if self:GetElement(e) then
                anchors[e] = e
            end
        end
    end
    for u, _ in pairs(self.units) do
        if u ~= unit then
            anchors[u] = u
            for e, _ in pairs(self.units[u]) do
                if self:GetElement(e) then
                    local anchor = string.format("%s:%s", u, e)
                    anchors[anchor] = anchor
                end
            end
        end
    end

    return anchors
end

function VUF:GenerateElementOptionsTable(
    unit,
    element,
    order,
    name,
    hasAnchor,
    hasSize,
    hasValue,
    hasTag,
    hasSpacing,
    hasTicks)
    local ACD = E.Libs.AceConfigDialog
    local options = {
        order = order,
        type = "group",
        name = L[name],
        get = function(info)
            return E.db.nihilistzscheui.vuf.units[unit][element][info[#info]]
        end,
        set = function(info, value)
            E.db.nihilistzscheui.vuf.units[unit][element][info[#info]] = value
            VUF:UpdateAllFrames()
        end,
        args = {
            enabled = {
                type = "toggle",
                order = 1,
                name = L.Enable
            }
        }
    }
    if element == "cutaway" then
        options.args.enabled = nil
    end
    if hasAnchor then
        options.args.anchor = {
            order = 2,
            type = "group",
            name = L.Anchor,
            guiInline = true,
            get = function(info)
                return E.db.nihilistzscheui.vuf.units[unit][element].anchor[info[#info]]
            end,
            set = function(info, value)
                E.db.nihilistzscheui.vuf.units[unit][element].anchor[info[#info]] = value
                VUF:UpdateAllFrames()
            end,
            args = {
                pointTo = {
                    type = "select",
                    name = L["Point To"],
                    order = 1,
                    values = positionValues
                },
                attachTo = {
                    type = "select",
                    name = L["Attach To"],
                    desc = L["What to attach this element to."],
                    order = 2,
                    values = self:GenerateValidAnchors(unit, element)
                },
                pointFrom = {
                    type = "select",
                    name = L["Point From"],
                    order = 3,
                    values = positionValues
                },
                xOffset = {
                    order = 4,
                    name = L["X Offset"],
                    type = "range",
                    min = -1000,
                    max = 1000,
                    step = 1
                },
                yOffset = {
                    order = 5,
                    name = L["Y Offset"],
                    type = "range",
                    min = -1000,
                    max = 1000,
                    step = 1
                }
            }
        }
    end
    if hasSize then
        if not ((unit == "player" or unit == "target") and element == "castbar") then
            if element ~= "aurabars" then
                options.args.size = {
                    order = 3,
                    type = "group",
                    name = L.Size,
                    guiInline = true,
                    get = function(info)
                        return E.db.nihilistzscheui.vuf.units[unit][element].size[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.nihilistzscheui.vuf.units[unit][element].size[info[#info]] = value
                        VUF:UpdateAllFrames()
                    end,
                    args = {
                        width = {
                            order = 4,
                            name = L.Width,
                            type = "range",
                            min = 7,
                            max = 50,
                            step = 1
                        },
                        height = {
                            order = 5,
                            name = L.Height,
                            type = "range",
                            min = 20,
                            max = 600,
                            step = 1
                        }
                    }
                }
            else
                options.args.size = {
                    order = 3,
                    type = "group",
                    name = L.Size,
                    guiInline = true,
                    get = function(info)
                        return E.db.nihilistzscheui.vuf.units[unit][element].size[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.nihilistzscheui.vuf.units[unit][element].size[info[#info]] = value
                        VUF:UpdateAllFrames()
                    end,
                    args = {
                        width = {
                            order = 4,
                            name = L.Width,
                            type = "range",
                            min = 100,
                            max = 500,
                            step = 1
                        },
                        height = {
                            order = 5,
                            name = L.Height,
                            type = "range",
                            min = 20,
                            max = 80,
                            step = 1
                        },
                        halfBar = {
                            order = 6,
                            name = L["Half-Bar"],
                            type = "toggle"
                        }
                    }
                }
            end
        else
            options.args.size = {
                order = 3,
                type = "group",
                name = L.Size,
                guiInline = true,
                get = function(info)
                    return E.db.nihilistzscheui.vuf.units[unit][element].size[info[#info]]
                end,
                set = function(info, value)
                    E.db.nihilistzscheui.vuf.units[unit][element].size[info[#info]] = value
                    VUF:UpdateAllFrames()
                end,
                args = {
                    horizontal = {
                        order = 3,
                        type = "group",
                        name = L.Horizontal,
                        guiInline = true,
                        get = function(info)
                            return E.db.nihilistzscheui.vuf.units[unit][element].size.horizontal[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.nihilistzscheui.vuf.units[unit][element].size.horizontal[info[#info]] = value
                            VUF:UpdateAllFrames()
                        end,
                        args = {
                            width = {
                                order = 4,
                                name = L.Width,
                                type = "range",
                                min = 7,
                                max = 500,
                                step = 1
                            },
                            height = {
                                order = 5,
                                name = L.Height,
                                type = "range",
                                min = 20,
                                max = 600,
                                step = 1
                            },
                            halfBar = {
                                order = 6,
                                name = L["Half-Bar"],
                                type = "toggle"
                            }
                        }
                    },
                    vertical = {
                        order = 3,
                        type = "group",
                        name = L.Vertical,
                        guiInline = true,
                        get = function(info)
                            return E.db.nihilistzscheui.vuf.units[unit][element].size.vertical[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.nihilistzscheui.vuf.units[unit][element].size.vertical[info[#info]] = value
                            VUF:UpdateAllFrames()
                        end,
                        args = {
                            width = {
                                order = 4,
                                name = L.Width,
                                type = "range",
                                min = 7,
                                max = 50,
                                step = 1
                            },
                            height = {
                                order = 5,
                                name = L.Height,
                                type = "range",
                                min = 20,
                                max = 600,
                                step = 1
                            }
                        }
                    }
                }
            }
        end
    end

    if hasValue then
        options.args.value = {
            order = 10,
            type = "group",
            name = L.Value,
            guiInline = true,
            get = function(info)
                return E.db.nihilistzscheui.vuf.units[unit][element].value[info[#info]]
            end,
            set = function(info, value)
                E.db.nihilistzscheui.vuf.units[unit][element].value[info[#info]] = value
                VUF:UpdateAllFrames()
            end,
            args = {
                enabled = {
                    type = "toggle",
                    order = 1,
                    name = L.Enable
                },
                anchor = {
                    order = 2,
                    type = "group",
                    name = L.Anchor,
                    guiInline = true,
                    get = function(info)
                        return E.db.nihilistzscheui.vuf.units[unit][element].value.anchor[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.nihilistzscheui.vuf.units[unit][element].value.anchor[info[#info]] = value
                        VUF:UpdateAllFrames()
                    end,
                    args = {
                        attachTo = {
                            type = "select",
                            name = L["Attach To"],
                            desc = L["What to attach this element to."],
                            order = 3,
                            values = self:GenerateValidAnchors(unit, element, true)
                        },
                        xOffset = {
                            order = 5,
                            name = L["X Offset"],
                            type = "range",
                            min = -1000,
                            max = 1000,
                            step = 1
                        },
                        yOffset = {
                            order = 6,
                            name = L["Y Offset"],
                            type = "range",
                            min = -1000,
                            max = 1000,
                            step = 1
                        }
                    }
                }
            }
        }
    end

    if hasTag then
        if hasValue then
            options.args.value.args.tag = {
                type = "input",
                width = "full",
                name = L["Text Format"],
                desc = L.TEXT_FORMAT_DESC,
                order = 3
            }
        else
            options.args.tag = {
                type = "input",
                width = "full",
                name = L["Text Format"],
                desc = L.TEXT_FORMAT_DESC,
                order = 3
            }
        end
    end

    if hasSpacing then
        options.args.spacing = {
            order = 11,
            type = "group",
            name = L.Spacing,
            guiInline = true,
            args = {
                spaced = {
                    type = "toggle",
                    order = 1,
                    name = L.Spaced
                },
                spacesettings = {
                    order = 2,
                    type = "group",
                    name = L.Anchor,
                    guiInline = true,
                    get = function(info)
                        return E.db.nihilistzscheui.vuf.units[unit][element].spacesettings[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.nihilistzscheui.vuf.units[unit][element].spacesettings[info[#info]] = value
                        VUF:UpdateAllFrames()
                    end,
                    args = {
                        offset = {
                            order = 5,
                            name = L.Offset,
                            type = "range",
                            min = -200,
                            max = 200,
                            step = 1
                        },
                        spacing = {
                            order = 6,
                            name = L.Spacing,
                            type = "range",
                            min = 1,
                            max = 100,
                            step = 1
                        }
                    }
                }
            }
        }
    end

    if element == "aurabars" then
        options.args.growthDirection = {
            type = "select",
            order = 2,
            name = L["Growth Direction"],
            values = growthValues
        }
    end

    if element == "portrait" then
        options.args.enabled.set = function(info, value)
            E.db.nihilistzscheui.vuf.units[unit][element][info[#info]] = value
            E:StaticPopup_Show("CONFIG_RL")
        end
        options.args.rotation = {
            type = "range",
            name = L["Model Rotation"],
            order = 4,
            min = 0,
            max = 360,
            step = 1
        }
        options.args.camDistanceScale = {
            type = "range",
            name = L["Camera Distance Scale"],
            desc = L["How far away the portrait is from the camera."],
            order = 5,
            min = 0.01,
            max = 4,
            step = 0.01
        }
        options.args.xOffset = {
            order = 6,
            type = "range",
            name = L.xOffset,
            desc = L["Position the Model horizontally."],
            min = -1,
            max = 1,
            step = 0.01
        }
        options.args.yOffset = {
            order = 7,
            type = "range",
            name = L.yOffset,
            desc = L["Position the Model vertically."],
            min = -1,
            max = 1,
            step = 0.01
        }
    end

    if element == "phaseindicator" then
        options.args.scale = {
            order = 3,
            type = "range",
            name = L.Scale,
            isPercent = true,
            min = 0.5,
            max = 1.5,
            step = 0.01
        }
    end

    if element == "castbar" then
        options.args.format = {
            order = 12,
            type = "select",
            name = L.Format,
            values = {
                CURRENTMAX = L["Current / Max"],
                CURRENT = L.Current,
                REMAINING = L.Remaining
            }
        }
        if hasTicks then
            options.args.ticks = {
                order = 13,
                type = "toggle",
                name = L.Ticks,
                -- luacheck: push no max line length
                desc = L[
                    "Display tick marks on the castbar for channelled spells. This will adjust automatically for spells like Drain Soul and add additional ticks based on haste."
                ]
                -- luacheck: pop
            }
            options.args.displayTarget = {
                order = 14,
                type = "toggle",
                name = L["Display Target"],
                desc = L["Display the target of your current cast. Useful for mouseover casts."]
            }
            options.args.tickcolor = {
                order = 15,
                type = "color",
                name = L["Tick Color"],
                get = function(info)
                    local t = E.db.nihilistzscheui.vuf.units[unit][element][info[#info]]
                    return t.r, t.g, t.b, t.a
                end,
                set = function(info, r, g, b)
                    local t = E.db.nihilistzscheui.vuf.units[unit][element][info[#info]]
                    t.r, t.g, t.b = r, g, b
                    VUF:UpdateAllFrames()
                end
            }
        end
    end

    if element == "healPrediction" then
        local getFunc = function(info)
            return E.db.unitframe.units[unit].healPrediction[info[#info]]
        end
        local setFunc = function(info, value)
            E.db.unitframe.units[unit].healPrediction[info[#info]] = value
            VUF:UpdateAllFrames()
        end
        options.args.height = {
            type = "range",
            order = 2,
            name = L.Height,
            get = getFunc,
            set = setFunc,
            min = -1,
            max = 500,
            step = 1
        }
        options.args.colorsButton = {
            order = 3,
            type = "execute",
            name = L.COLORS,
            func = function()
                ACD:SelectGroup("ElvUI", "unitframe", "generalOptionsGroup", "allColorsGroup", "healPrediction")
            end,
            disabled = function()
                return not E.UnitFrames.Initialized
            end
        }
        options.args.anchorPoint = {
            order = 5,
            type = "select",
            name = L["Anchor Point"],
            get = getFunc,
            set = setFunc,
            values = {
                TOP = "TOP",
                BOTTOM = "BOTTOM",
                CENTER = "CENTER"
            }
        }
        options.args.absorbStyle = {
            order = 6,
            type = "select",
            name = L["Absorb Style"],
            get = getFunc,
            set = setFunc,
            values = {
                NONE = L.NONE,
                NORMAL = L.Normal,
                REVERSED = L.Reversed,
                WRAPPED = L.Wrapped,
                OVERFLOW = L.Overflow
            }
        }
        options.args.overflowButton = {
            order = 7,
            type = "execute",
            name = L["Max Overflow"],
            func = function()
                ACD:SelectGroup("ElvUI", "unitframe", "generalOptionsGroup", "allColorsGroup", "healPrediction")
            end,
            disabled = function()
                return not E.UnitFrames.Initialized
            end
        }
        options.args.warning =
            E.Libs.ACH:Description(
            function()
                if E.db.unitframe.colors.healPrediction.maxOverflow == 0 then
                    local text =
                        L[
                        "Max Overflow is set to zero. Absorb Overflows will be hidden when using Overflow style.\nIf used together Max Overflow at zero and Overflow mode will act like Normal mode without the ending sliver of overflow."
                    ]
                    return text ..
                        (E.db.unitframe.units[unit].healPrediction.absorbStyle == "OVERFLOW" and
                            " |cffFF9933You are using Overflow with Max Overflow at zero.|r " or
                            "")
                end
            end,
            50,
            "medium",
            nil,
            nil,
            nil,
            nil,
            "full"
        )
    end

    if element == "cutaway" then
        options.args.health = {
            order = 1,
            type = "group",
            guiInline = true,
            name = L.Health,
            get = function(info)
                return E.db.nihilistzscheui.vuf.units[unit].cutaway.health[info[#info]]
            end,
            set = function(info, value)
                E.db.nihilistzscheui.vuf.units[unit].cutaway.health[info[#info]] = value
                VUF:UpdateAllFrames()
            end,
            args = {
                enabled = {
                    type = "toggle",
                    order = 1,
                    name = L.Enable
                },
                lengthBeforeFade = {
                    type = "range",
                    order = 2,
                    name = L["Fade Out Delay"],
                    desc = L["How much time before the cutaway health starts to fade."],
                    min = 0.1,
                    max = 1,
                    step = 0.1,
                    disabled = function()
                        return not E.db.nihilistzscheui.vuf.units[unit].cutaway.health.enabled
                    end
                },
                fadeOutTime = {
                    type = "range",
                    order = 3,
                    name = L["Fade Out"],
                    desc = L["How long the cutaway health will take to fade out."],
                    min = 0.1,
                    max = 1,
                    step = 0.1,
                    disabled = function()
                        return not E.db.nihilistzscheui.vuf.units[unit].cutaway.health.enabled
                    end
                }
            }
        }
        options.args.power = {
            order = 2,
            type = "group",
            name = L.Power,
            guiInline = true,
            get = function(info)
                return E.db.nihilistzscheui.vuf.units[unit].cutaway.power[info[#info]]
            end,
            set = function(info, value)
                E.db.nihilistzscheui.vuf.units[unit].cutaway.power[info[#info]] = value
                VUF:UpdateAllFrames()
            end,
            args = {
                enabled = {
                    type = "toggle",
                    order = 1,
                    name = L.Enable
                },
                lengthBeforeFade = {
                    type = "range",
                    order = 2,
                    name = L["Fade Out Delay"],
                    desc = L["How much time before the cutaway power starts to fade."],
                    min = 0.1,
                    max = 1,
                    step = 0.1,
                    disabled = function()
                        return not E.db.nameplates.cutaway.power.enabled
                    end
                },
                fadeOutTime = {
                    type = "range",
                    order = 3,
                    name = L["Fade Out"],
                    desc = L["How long the cutaway power will take to fade out."],
                    min = 0.1,
                    max = 1,
                    step = 0.1,
                    disabled = function()
                        return not E.db.nameplates.cutaway.power.enabled
                    end
                }
            }
        }
    end
    if unit == "player" and E.myclass == "DEATHKNIGHT" then
        options.args.sortDirection = {
            name = L["Sort Direction"],
            desc = L["Defines the sort order of the selected sort method."],
            type = "select",
            order = 17,
            values = {
                asc = L.Ascending,
                desc = L.Descending,
                NONE = NONE
            },
            get = function(info)
                return E.db.unitframe.units.playe.classbar[info[#info]]
            end,
            set = function(info, value)
                E.db.unitframe.units.playe.classbar[info[#info]] = value
                VUF:UpdateAllFrames()
            end
        }
    end

    return options
end
--VUF:GenerateElementOptionTable(unit,element,order,name,hasAnchor,hasSize,hasValue,hasTag,hasSpacing,hasTicks)

local elementOptions = {
    health = "Health",
    power = "Power",
    castbar = "Castbar",
    name = "Name",
    classbars = "ClassBar",
    additionalpower = "AdditionalPower",
    aurabars = "AuraBar",
    raidicon = "RaidIcon",
    restingindicator = "RestingIndicator",
    combatindicator = "CombatIndicator",
    pvptext = "PvPText",
    healPrediction = "HealthPrediction",
    powerPrediction = "PowerPrediction",
    stagger = "Stagger",
    gcd = "GCD",
    buffs = "Buff",
    debuffs = "Debuff",
    portrait = "Portrait",
    resurrectindicator = "ResurrectIndicator",
    phaseindicator = "PhaseIndicator",
    cutaway = "Cutaway"
}

local nameMap = {
    playeraurabar = {
        mover = "Player Vertical Unit Frame AuraBar Header"
    },
    targetaurabar = {
        mover = "Target Vertical Unit Frame AuraBar Header"
    },
    playercastbar = {
        mover = "Player Vertical Unit Frame Castbar"
    },
    targetcastbar = {
        mover = "Target Vertical Unit Frame Castbar"
    }
}

function VUF:GenerateUnitOptionTable(unit, name, order, mover, elements)
    local options = {
        name = L[name],
        type = "group",
        order = order,
        childGroups = "select",
        get = function(info)
            return E.db.nihilistzscheui.vuf.units[unit][info[#info]]
        end,
        set = function(info, value)
            E.db.nihilistzscheui.vuf.units[unit][info[#info]] = value
            VUF:UpdateAllFrames()
        end,
        args = {
            enabled = {
                type = "toggle",
                order = 1,
                name = L.Enable
            },
            resetSettings = {
                type = "execute",
                order = 2,
                name = L["Restore Defaults"],
                func = function()
                    VUF:ResetUnitSettings(unit)
                    E:ResetMovers(mover)
                    if unit == "player" or unit == "target" then
                        local aurabarMover = nameMap[unit .. "aurabar"].mover
                        local castbarMover = nameMap[unit .. "castbar"].mover
                        E:ResetMovers(aurabarMover)
                        E:ResetMovers(castbarMover)
                    end
                end
            },
            customText = {
                order = 50,
                name = L["Custom Texts"],
                type = "input",
                width = "full",
                desc = L[
                    "Create a custom fontstring. Once you enter a name you will be able to select it from the elements dropdown list."
                ],
                get = function()
                    return ""
                end,
                set = function(_, textName)
                    for object, _ in pairs(E.db.nihilistzscheui.vuf.units[unit]) do
                        if object:lower() == textName:lower() then
                            E:Print(L["The name you have selected is already in use by another element."])
                            return
                        end
                    end

                    VUF:AddCustomText(unit, textName)
                end
            }
        }
    }
    if unit == "player" or unit == "target" then
        options.args.horizCastbar = {
            type = "toggle",
            order = 20,
            name = L["Horizontal Castbar"],
            desc = L["Use a horizontal castbar"],
            get = function(info)
                return E.db.nihilistzscheui.vuf.units[unit][info[#info]]
            end,
            set = function(info, value)
                E.db.nihilistzscheui.vuf.units[unit][info[#info]] = value
                VUF:UpdateAllFrames()
            end
        }
    end
    for element, _ in pairs(elements) do
        if self:GetElement(element) then
            options.args[element] = self[elementOptions[element] .. "Options"](self, unit)
        end
    end

    return options
end

function VUF:GenerateOptionTables(options)
    local order = 200
    local step = 200
    local count = 0
    for _, _ in pairs(self.units) do
        count = count + 1
    end
    local optionUnits = {
        "player",
        "target",
        "pet",
        "target",
        "targettarget",
        "focus",
        "focustarget",
        "pettarget",
        "targettargettarget"
    }
    for _, unit in ipairs(optionUnits) do
        local optionName = E:StringTitle(unit)
        optionName = gsub(optionName, "target", " Target")
        options.args[unit] =
            self:GenerateUnitOptionTable(unit, optionName, order, optionName, self.units[unit].elements)
        self:SetUpCustomTexts(self.units[unit], options)
        order = order + step
    end
end

function VUF:GenerateOptions()
    E.Options.args.unitframe.args.generalOptionsGroup.args.allColorsGroup.order = 7
    E.Options.args.unitframe.args.generalOptionsGroup.args.generalGroup.args.barGroup.args.statusbar.set = function(
        info,
        value)
        E.db.unitframe[info[#info]] = value
        UF:Update_StatusBars()
        self:UpdateAllFrames()
    end
    -- luacheck: push no max line length
    E.Options.args.unitframe.args.generalOptionsGroup.args.generalGroup.args.fontGroup.args.font.set = function(
        info,
        value)
        E.db.unitframe[info[#info]] = value
        UF:Update_FontStrings()
        self:UpdateAllFrames()
    end
    -- luacheck: pop
    E.Options.args.unitframe.args.generalOptionsGroup.args.generalGroup.args.fontGroup.args.fontSize.set = function(
        info,
        value)
        E.db.unitframe[info[#info]] = value
        UF:Update_FontStrings()
        self:UpdateAllFrames()
    end
    E.Options.args.unitframe.args.generalOptionsGroup.args.generalGroup.args.fontGroup.args.fontOutline.set = function(
        info,
        value)
        E.db.unitframe[info[#info]] = value
        UF:Update_FontStrings()
        self:UpdateAllFrames()
    end

    local options = {
        order = 2150,
        type = "group",
        name = L["Vertical Unit Frames"],
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["NihilistzscheUI VerticalUnitFrames by Nihilistzsche"]
            },
            description = {
                order = 2,
                type = "description",
                name = L[
                    "NihilistzscheUI VerticalUnitFrames provides a configurable centered, vertical unit frame option for use with ElvUI.\n"
                ]
            },
            credits = {
                order = 10000,
                type = "group",
                name = L.Credits,
                guiInline = false,
                args = {
                    creditheader = {
                        order = 1,
                        type = "header",
                        name = L.Credits
                    },
                    credits = {
                        order = 2,
                        type = "description",
                        name = L.NihilistzscheUI_VerticalUnitFrames_CREDITS
                    }
                }
            }
        }
    }
    options.args.vufgen = {
        order = 4,
        type = "group",
        name = L["Vertical Unit Frames"] .. " " .. L.General,
        guiInline = true,
        args = {
            enabled = {
                type = "toggle",
                order = 1,
                name = L.Enable,
                desc = L["Enable the Vertical Unit Frames."],
                get = function(info)
                    return E.db.nihilistzscheui.vuf[info[#info]]
                end,
                set = function(info, value)
                    E.db.nihilistzscheui.vuf[info[#info]] = value
                    self:Enable()
                end
            },
            resetsettings = {
                type = "execute",
                order = 2,
                name = L["Reset Settings"],
                desc = L["Reset the settings of this addon to their defaults."],
                func = function()
                    E:CopyTable(E.db.nihilistzscheui.vuf, P.nihilistzscheui.vuf)
                    self:Enable()
                    self.ResetFramePositions()
                    self:UpdateHideSetting()
                    self:UpdateAllFrames()
                    self:UpdateMouseSetting()
                end
            },
            oldDefault = {
                type = "execute",
                order = 3,
                name = L["Old Default"],
                desc = L["Use the old default settings from version 4.17 or under"],
                func = function()
                    self:OldDefault()
                    self:Enable()
                    self:UpdateHideSetting()
                    self:UpdateAllFrames()
                    self:UpdateMouseSetting()
                end
            },
            simpleLayout = {
                type = "execute",
                order = 4,
                name = L["Simple Layout"],
                desc = L["Use the simple layout from 2.0"],
                func = function()
                    self:SimpleLayout()
                    self:Enable()
                    self:UpdateHideSetting()
                    self:UpdateAllFrames()
                    self:UpdateMouseSetting()
                end
            },
            comboLayout = {
                type = "execute",
                order = 5,
                name = L["Combo Layout"],
                desc = L["Use a layout designed to work with ElvUI unitframes"],
                func = function()
                    self:ComboLayout()
                    self:Enable()
                    self:UpdateHideSetting()
                    self:UpdateAllFrames()
                    self:UpdateMouseSetting()
                end
            }
        }
    }
    options.args.vufOptions = {
        order = 5,
        type = "group",
        name = L["Vertical Unit Frame Options"],
        get = function(info)
            return E.db.nihilistzscheui.vuf[info[#info]]
        end,
        set = function(info, value)
            E.db.nihilistzscheui.vuf[info[#info]] = value
        end,
        args = {
            hideElv = {
                type = "toggle",
                order = 8,
                name = L["Hide ElvUI Unitframes"],
                desc = L["Hide the ElvUI Unitframes when the Vertical Unit Frame is enabled"],
                get = function(info)
                    return E.db.nihilistzscheui.vuf[info[#info]]
                end,
                set = function(info, value)
                    E.db.nihilistzscheui.vuf[info[#info]] = value
                    self:UpdateElvUFSetting()
                end
            },
            flash = {
                type = "toggle",
                order = 15,
                name = L.Flash,
                desc = L["Flash health/power when the low threshold is reached"]
            },
            screenflash = {
                type = "toggle",
                order = 16,
                name = L["Screen Flash"],
                desc = L["Flash the screen border red when the low threshold is reached"]
            },
            warningText = {
                type = "toggle",
                order = 16,
                name = L["Text Warning"],
                desc = L["Show a Text Warning when the low threshold is reached"]
            },
            hideOOC = {
                type = "toggle",
                order = 17,
                name = L["Hide Out of Combat"],
                desc = L["Hide the Vertical Unit Frame when out of Combat"],
                get = function(info)
                    return E.db.nihilistzscheui.vuf[info[#info]]
                end,
                set = function(info, value)
                    E.db.nihilistzscheui.vuf[info[#info]] = value
                    self:UpdateHideSetting()
                end
            },
            enableMouse = {
                type = "toggle",
                order = 19,
                name = L["Enable Mouse"],
                desc = L[
                    -- luacheck: push no max line length
                    "Enable the mouse to interface with the vertical unit frame (this option has no effect if ElvUI Unitframes are hidden)"
                    -- luacheck: pop
                ],
                get = function(info)
                    return E.db.nihilistzscheui.vuf[info[#info]]
                end,
                set = function(info, value)
                    E.db.nihilistzscheui.vuf[info[#info]] = value
                    self:UpdateMouseSetting()
                end,
                disabled = function()
                    return E.db.nihilistzscheui.vuf.hideElv
                end
            },
            alpha = {
                type = "range",
                order = 20,
                name = L.Alpha,
                desc = L["Set the Alpha of the Vertical Unit Frame when in combat"],
                min = 0,
                max = 1,
                step = .05
            },
            alphaOOC = {
                type = "range",
                order = 21,
                name = L["Out of Combat Alpha"],
                desc = L["Set the Alpha of the Vertical Unit Frame when out of combat"],
                min = 0,
                max = 1,
                step = 0.05
            },
            lowThreshold = {
                type = "range",
                order = 22,
                name = L["Low Threshold"],
                desc = L["Start flashing health/power under this percentage"],
                min = 0,
                max = 100,
                step = 1
            }
        }
    }
    self:GenerateOptionTables(options)
    return options
end
