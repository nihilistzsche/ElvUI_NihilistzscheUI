local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistUI)
local WD = NUI.WarlockDemons
if not WD then
	return
end
local COMP = NUI.Compatibility
if not COMP then
	return
end
local NP = E.NamePlates

function WD:GenerateOptions()
	if E.myclass ~= "WARLOCK" or not COMP.ZP then
		return nil
	end
	local options = {
		type = "group",
		name = L["Warlock Demons"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Demon Count"]
			},
			description = {
				order = 2,
				type = "description",
				name = L["Timer bars and counts for demonology demons"]
			},
			general = {
				order = 3,
				type = "group",
				name = L.General,
				guiInline = true,
				get = function(info)
					return E.db.nihilistui.warlockdemons[info[#info]]
				end,
				set = function(info, value)
					E.db.nihilistui.warlockdemons[info[#info]] = value
					WD:UpdateAll()
				end,
				args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = L.Enable,
						desc = L["Enable the demon count"]
					},
					resetsettings = {
						type = "execute",
						order = 2,
						name = L["Reset Settings"],
						desc = L["Reset the settings of this addon to their defaults."],
						func = function()
							E:CopyTable(E.db.nihilistui.warlockdemons, P.nihilistui.warlockdemons)
							WD:UpdateAll()
						end
					},
					width = {
						type = "range",
						order = 3,
						name = L.Width,
						desc = L["Width of the bars"],
						min = 10,
						max = 500,
						step = 1
					},
					height = {
						type = "range",
						order = 4,
						name = L.Height,
						desc = L["Height of the bars"],
						min = 5,
						max = 100,
						step = 1
					},
					spacing = {
						type = "range",
						order = 5,
						name = L.Spacing,
						desc = L["Spacing between bars"],
						min = 0,
						max = 100,
						step = 1
					},
					texture = {
						type = "select",
						dialogControl = "LSM30_Statusbar",
						order = 6,
						name = L["Statusbar Texture"],
						values = _G.AceGUIWidgetLSMlists.statusbar
					},
					font = {
						type = "select",
						dialogControl = "LSM30_Font",
						order = 7,
						name = L.Font,
						values = _G.AceGUIWidgetLSMlists.font
					},
					fontSize = {
						order = 8,
						name = L["Font Size"],
						type = "range",
						min = 9,
						max = 16,
						step = 1
					},
					attachToNamePlate = {
						order = 9,
						name = "Attach to NamePlate",
						--luacheck: push no max line length
						desc = "If this and Friendly Minion nameplates are enabled, attach the timer bar to the demon's nameplate rather than the header.",
						--luacheck: pop
						type = "toggle",
						disabled = function()
							return not NP.UpdatePlateGUID
						end
					},
					grow = {
						order = 10,
						type = "select",
						name = "Growth Direction",
						values = {
							DOWN = "DOWN",
							UP = "UP"
						}
					},
					color = {
						type = "color",
						order = 11,
						name = L["Static Statusbar Color"],
						desc = L["Choose which color you want your statusbars to use."],
						hasAlpha = false,
						get = function(info)
							local t = E.db.nihilistui.warlockdemons[info[#info]]
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b)
							E.db.nihilistui.warlockdemons[info[#info]] = {}
							local t = E.db.nihilistui.warlockdemons[info[#info]]
							t.r, t.g, t.b = r, g, b
						end
					},
					alpha = {
						type = "range",
						order = 12,
						name = L.Alpha,
						desc = L["Alpha of bars"],
						min = 0,
						max = 1,
						step = 0.1
					}
				}
			}
		}
	}

	local demons = {
		type = "group",
		guiInline = true,
		name = "Demons",
		args = {}
	}

	for k, v in pairs(self.demons) do
		demons.args[k] = {
			name = k,
			type = "toggle",
			desc = "Enable " .. k .. " tracking.",
			order = v.optionOrder,
			get = function()
				return E.db.nihilistui.warlockdemons.demons[k].enable
			end,
			set = function(_, value)
				E.db.nihilistui.warlockdemons.demons[k].enable = value
			end
		}
	end

	if not NP.UpdatePlateGUID then
		options.args.general.args.attachToNamePlate.desc =
			"You must be running a version of ElvUI greater than 11.14 to use this feature."
	end

	if self.styleFilterHooked then
		local oldFunc = E.Options.args.nameplate.args.filters.args.selectFilter.set
		E.Options.args.nameplate.args.filters.args.selectFilter.set = function(info, value)
			oldFunc(info, value)
			-- luacheck: push  no max line length
			if
				not E.Options.args.nameplate.args.filters.args.triggers.args.combat.args.demonologyWarlockDemonAboutToExpireNUI
			 then
				E.Options.args.nameplate.args.filters.args.triggers.args.combat.args.isDemonologyWarlockDemonNUI = {
					name = "Unit Is Demonology Warlock Demon",
					desc = "If enabled then the filter will only activate for units that are demonology warlock demons.  This filter is provided by NihilistUI.",
					type = "toggle",
					order = 50,
					disabled = E.myclass ~= "WARLOCK"
				}
				E.Options.args.nameplate.args.filters.args.triggers.args.combat.args.isNotDemonologyWarlockDemonNUI = {
					name = "Unit Is Not Demonology Warlock Demon",
					desc = "If enabled then the filter will only activate for units that are not demonology warlock demons.  This filter is provided by NihilistUI.",
					type = "toggle",
					order = 51,
					disabled = E.myclass ~= "WARLOCK"
				}
				E.Options.args.nameplate.args.filters.args.triggers.args.combat.args.demonologyWarlockDemonAboutToExpireNUI = {
					name = "Demonology Warlock Demon About to Expire",
					desc = "If enabled then the filter will only activate when the nameplate belongs to a wild imp with less than 3 energy or another demonlogy warlock demon with less than 5 seconds remaining.  This filter is provided by NihilistUI.",
					type = "toggle",
					order = 52,
					disabled = E.myclass ~= "WARLOCK"
				}
			end
			--luacheck: pop
		end
	end

	options.args.demons = demons
	return options
end
