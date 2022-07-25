local NUI, E, L = _G.unpack(_G.ElvUI_NihilistUI) --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local NP = E.NamePlates
local ENA = NUI.EnhancedNameplateAuras

local selectedSpellID
local spellLists

local GetSpellInfo = _G.GetSpellInfo

local function deepcopy(object)
	local lookup_table = {}
	local function _copy(obj)
		if type(obj) ~= "table" then
			return obj
		elseif lookup_table[obj] then
			return lookup_table[obj]
		end
		local new_table = {}
		lookup_table[obj] = new_table
		for index, value in pairs(obj) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(obj))
	end
	return _copy(object)
end

local function UpdateSpellGroup()
	if not selectedSpellID or not E.global.nameplate.spellList[selectedSpellID] then
		E.Options.args.NihilistUI.args.modules.args.EnhancedNameplateAuras.args.specificSpells.args.spellGroup = nil
		return
	end

	E.Options.args.NihilistUI.args.modules.args.EnhancedNameplateAuras.args.specificSpells.args.spellGroup = {
		type = "group",
		name = GetSpellInfo(selectedSpellID),
		guiInline = true,
		order = -10,
		get = function(info)
			return E.global.nameplate.spellList[selectedSpellID][info[#info]]
		end,
		set = function(info, value)
			E.global.nameplate.spellList[selectedSpellID][info[#info]] = value
			NP:UpdateAllPlates()
			UpdateSpellGroup()
		end,
		args = {
			visibility = {
				type = "select",
				order = 1,
				name = L.Visibility,
				desc = L["Set when this aura is visble."],
				values = {[1] = "Always", [2] = "Never", [3] = "Only Mine"},
				get = function()
					return E.global.nameplate.spellList[selectedSpellID].visibility
				end,
				set = function(_, value)
					E.global.nameplate.spellList[selectedSpellID].visibility = value
				end
			},
			width = {
				type = "range",
				order = 2,
				name = L["Icon Width"],
				desc = L["Set the width of this spells icon."],
				min = 10,
				max = 100,
				step = 2,
				get = function()
					return E.global.nameplate.spellList[selectedSpellID].width
				end,
				set = function(_, value)
					E.global.nameplate.spellList[selectedSpellID].width = value
					if E.global.nameplate.spellList[selectedSpellID].lockAspect then
						E.global.nameplate.spellList[selectedSpellID].height = value
					end
				end
			},
			height = {
				type = "range",
				order = 3,
				name = L["Icon Height"],
				desc = L["Set the height of this spells icon."],
				disabled = function()
					return E.global.nameplate.spellList[selectedSpellID].lockAspect
				end,
				min = 10,
				max = 100,
				step = 2,
				get = function()
					return E.global.nameplate.spellList[selectedSpellID].height
				end,
				set = function(_, value)
					E.global.nameplate.spellList[selectedSpellID].height = value
				end
			},
			lockAspect = {
				type = "toggle",
				order = 4,
				name = L["Lock Aspect Ratio"],
				desc = L["Set if height and width are locked to the same value."],
				get = function()
					return E.global.nameplate.spellList[selectedSpellID].lockAspect
				end,
				set = function(_, value)
					E.global.nameplate.spellList[selectedSpellID].lockAspect = value
					if value then
						E.global.nameplate.spellList[selectedSpellID].height =
							E.global.nameplate.spellList[selectedSpellID].width
					end
				end
			},
			stackSize = {
				type = "range",
				order = 7,
				name = L["Stack Size"],
				desc = L["Size of the stack text."],
				min = 6,
				max = 24,
				step = 1,
				get = function()
					return E.global.nameplate.spellListDefault.stackSize
				end,
				set = function(_, value)
					E.global.nameplate.spellListDefault.stackSize = value
				end
			},
			text = {
				type = "range",
				order = 8,
				name = L["Text Size"],
				desc = L["Size of the timer text."],
				min = 6,
				max = 24,
				step = 1,
				get = function()
					return E.global.nameplate.spellList[selectedSpellID].text
				end,
				set = function(_, value)
					E.global.nameplate.spellList[selectedSpellID].text = value
				end
			}
		}
	}
end

function ENA.GenerateOptions()
	local options = {
		order = 5,
		type = "group",
		name = "Enhanced Nameplate Auras",
		args = {
			clearSpellList = {
				order = 6,
				type = "execute",
				name = L["Clear Spell List"],
				desc = L["Empties the list of specific spells and their configurations"],
				func = function()
					E.global.nameplate.spellList = {}
					UpdateSpellGroup()
				end
			},
			resetSpellList = {
				order = 7,
				type = "execute",
				name = L["Restore Spell List"],
				desc = L["Restores the default list of specific spells and their configurations"],
				func = function()
					E.global.nameplate.spellList = deepcopy(E.global.nameplate.spellListDefault.defaultSpellList)
					UpdateSpellGroup()
				end
			},
			specificSpells = {
				order = 1,
				type = "group",
				name = L["Specific Auras"],
				args = {
					addSpell = {
						type = "input",
						order = 1,
						name = L["Spell Name"],
						desc = L["Input a spell name or spell ID."],
						get = function()
							return ""
						end,
						set = function(_, value)
							if not tonumber(value) then
								value = tostring(value)
							end

							local spellID = select(7, GetSpellInfo(tonumber(value) or value))
							if spellID then
								if not E.global.nameplate.spellList[spellID] then
									E.global.nameplate.spellList[spellID] = {
										visibility = E.global.nameplate.spellListDefault.visibility,
										width = E.global.nameplate.spellListDefault.width,
										height = E.global.nameplate.spellListDefault.height,
										lockAspect = E.global.nameplate.spellListDefault.lockAspect,
										stackSize = E.global.nameplate.spellListDefault.stackSize,
										text = E.global.nameplate.spellListDefault.text,
										flashTime = E.global.nameplate.spellListDefault.flashTime
									}
								end
								selectedSpellID = spellID
								UpdateSpellGroup()
							else
								E:Print(L["Not valid spell name or spell ID"])
							end
						end
					},
					spellList = {
						order = 2,
						type = "select",
						name = L["Spell List"],
						get = function()
							return selectedSpellID
						end,
						set = function(_, value)
							selectedSpellID = value
							UpdateSpellGroup()
						end,
						values = function()
							spellLists = {}
							for spell in pairs(E.global.nameplate.spellList) do
								local color = "|cffff0000"
								local visibility = E.global.nameplate.spellList[spell].visibility
								if visibility == 1 then
									color = "|cff00ff00"
								elseif visibility == 3 then
									color = "|cff00ffff"
								end
								spellLists[spell] = color .. GetSpellInfo(spell) .. "|r"
							end
							return spellLists
						end
					},
					removeSpell = {
						order = 3,
						type = "execute",
						name = L["Remove Spell"],
						func = function()
							if E.global.nameplate.spellList[selectedSpellID] then
								E.global.nameplate.spellList[selectedSpellID] = nil
								selectedSpellID = ""
								UpdateSpellGroup()
							end
						end
					}
				}
			},
			otherSpells = {
				order = 2,
				type = "group",
				name = L["Other Auras"],
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["These are the settings for all spells not explicitly specified."]
					},
					visibility = {
						type = "select",
						order = 2,
						name = L.Visibility,
						desc = L["Set when this aura is visble."],
						values = {[1] = "Always", [2] = "Never", [3] = "Only Mine"},
						get = function()
							return E.global.nameplate.spellListDefault.visibility
						end,
						set = function(_, value)
							E.global.nameplate.spellListDefault.visibility = value
						end
					},
					width = {
						type = "range",
						order = 3,
						name = L["Icon Width"],
						desc = L["Set the width of this spells icon."],
						min = 10,
						max = 100,
						step = 2,
						get = function()
							return E.global.nameplate.spellListDefault.width
						end,
						set = function(_, value)
							E.global.nameplate.spellListDefault.width = value
							if E.global.nameplate.spellListDefault.lockAspect then
								E.global.nameplate.spellListDefault.height = value
							end
						end
					},
					height = {
						type = "range",
						order = 4,
						name = L["Icon Height"],
						desc = L["Set the height of this spells icon."],
						disabled = function()
							return E.global.nameplate.spellListDefault.lockAspect
						end,
						min = 10,
						max = 100,
						step = 2,
						get = function()
							return E.global.nameplate.spellListDefault.height
						end,
						set = function(_, value)
							E.global.nameplate.spellListDefault.height = value
						end
					},
					lockAspect = {
						type = "toggle",
						order = 5,
						name = L["Lock Aspect Ratio"],
						desc = L["Set if height and width are locked to the same value."],
						get = function()
							return E.global.nameplate.spellListDefault.lockAspect
						end,
						set = function(_, value)
							E.global.nameplate.spellListDefault.lockAspect = value
							if value then
								E.global.nameplate.spellListDefault.height = E.global.nameplate.spellListDefault.width
							end
						end
					},
					stackSize = {
						type = "range",
						order = 7,
						name = L["Stack Size"],
						desc = L["Size of the stack text."],
						min = 6,
						max = 24,
						step = 1,
						get = function()
							return E.global.nameplate.spellListDefault.stackSize
						end,
						set = function(_, value)
							E.global.nameplate.spellListDefault.stackSize = value
						end
					},
					text = {
						type = "range",
						order = 8,
						name = L["Text Size"],
						desc = L["Size of the timer text."],
						min = 6,
						max = 24,
						step = 1,
						get = function()
							return E.global.nameplate.spellListDefault.text
						end,
						set = function(_, value)
							E.global.nameplate.spellListDefault.text = value
						end
					}
				}
			},
			ccDebuffCasterInfo = {
				order = 8,
				type = "group",
				name = "CC Debuff Caster Name",
				get = function(info)
					return E.db.nihilistui.enhancednameplateauras.ccDebuffCasterInfo[info[#info]]
				end,
				set = function(info, value)
					E.db.nihilistui.enhancednameplateauras.ccDebuffCasterInfo[info[#info]] = value
				end,
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L.Enable,
						desc = L["Enable the CC Debuff Caster Info."]
					},
					textColor = {
						type = "color",
						order = 1,
						name = "Text Color",
						hasAlpha = false,
						get = function(info)
							local t = E.db.nihilistui.enhancednameplateauras.ccDebuffCasterInfo[info[#info]]
							return t.r, t.g, t.b, 1.0
						end,
						set = function(info, r, g, b)
							local t = {}
							t.r, t.g, t.b = r, g, b
							E.db.nihilistui.enhancednameplateauras.ccDebuffCasterInfo[info[#info]] = t
						end,
						disabled = function()
							return E.db.nihilistui.enhancednameplateauras.ccDebuffCasterInfo.classColor
						end
					},
					classColor = {
						type = "toggle",
						order = 2,
						name = "Class Color"
					},
					font = {
						type = "select",
						dialogControl = "LSM30_Font",
						order = 3,
						name = L["Default Font"],
						desc = L["The font that the text on the experience bars will use."],
						values = _G.AceGUIWidgetLSMlists.font
					},
					fontSize = {
						type = "range",
						order = 4,
						name = L["Font Size"],
						desc = L["Set the Width of the Text Font"],
						min = 10,
						max = 18,
						step = 1
					},
					fontOutline = {
						type = "select",
						order = 5,
						name = L["Font Flag"],
						desc = L["Flag to apply to the font"],
						values = {NONE = "NONE", OUTLINE = "OUTLINE", THICKOUTLINE = "THICKOUTLINE"}
					}
				}
			}
		}
	}

	return options
end
