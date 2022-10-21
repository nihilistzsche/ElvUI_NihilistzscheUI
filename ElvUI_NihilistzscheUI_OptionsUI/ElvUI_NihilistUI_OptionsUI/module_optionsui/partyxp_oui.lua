local NUI, E, L, _, P, _ = _G.unpack(_G.ElvUI_NihilistUI)
local PXP = NUI.PartyXP


function PXP:GenerateOptions()
	local options = {
		type = "group",
		name = L.PartyXP,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["NihilistUI PartyXP by Nihilistzsche"]
			},
			description = {
				order = 2,
				type = "description",
				name = L["NihilistUI PartyXP provides a configurable set of party experience bars for use with ElvUI.\n"]
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
						desc = L["Enable the party experience bars."],
						get = function(info)
							return self.db[info[#info]]
						end,
						set = function(info, value)
							self.db[info[#info]] = value
							self:Enable()
						end
					},
					resetsettings = {
						type = "execute",
						order = 2,
						name = L["Reset Settings"],
						desc = L["Reset the settings of this addon to their defaults."],
						func = function()
							E:CopyTable(self.db, P.nihilistui.pxp)
							self:Enable()
							self:Update()
							self:UpdateMedia()
							self:UpdateColorSetting()
						end
					}
				}
			},
			partyXpOptions = {
				order = 4,
				type = "group",
				name = L["PartyXP Options"],
				guiInline = true,
				get = function(info)
					return self.db[info[#info]]
				end,
				set = function(info, value)
					self.db[info[#info]] = value
				end,
				args = {
					font = {
						type = "select",
						dialogControl = "LSM30_Font",
						order = 1,
						name = L["Default Font"],
						desc = L["The font that the text on the experience bars will use."],
						values = _G.AceGUIWidgetLSMlists.font,
						get = function(info)
							return self.db[info[#info]]
						end,
						set = function(info, value)
							self.db[info[#info]] = value
							self:UpdateMedia()
						end
					},
					fontsize = {
						type = "range",
						order = 2,
						name = L["Font Size"],
						desc = L["Set the Width of the Text Font"],
						min = 10,
						max = 18,
						step = 1,
						get = function(info)
							return self.db[info[#info]]
						end,
						set = function(info, value)
							self.db[info[#info]] = value
							self:UpdateMedia()
						end
					},
					texture = {
						type = "select",
						dialogControl = "LSM30_Statusbar",
						order = 4,
						name = L["Primary Texture"],
						desc = L["The texture that will be used for the experience bars."],
						values = _G.AceGUIWidgetLSMlists.statusbar,
						get = function(info)
							return self.db[info[#info]]
						end,
						set = function(info, value)
							self.db[info[#info]] = value
							self:UpdateMedia()
						end
					},
					classColor = {
						type = "toggle",
						order = 5,
						name = L["Class Colors"],
						desc = L["Use class colors for the experience bars"],
						get = function(info)
							return self.db[info[#info]]
						end,
						set = function(info, value)
							self.db[info[#info]] = value
							self:UpdateColorSetting()
						end
					},
					color = {
						type = "color",
						order = 6,
						name = "Bar Color",
						hasAlpha = false,
						disabled = function()
							return not self.db.classColor
						end,
						get = function(info)
							local t = self.db[info[#info]]
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b)
							local t = {}
							t.r, t.g, t.b = r, g, b
							self.db[info[#info]] = t
							self:Update()
						end
					},
					width = {
						type = "range",
						order = 7,
						name = L.Width,
						desc = L["Vertical offset from parent frame"],
						min = 5,
						max = 800,
						step = 1,
						get = function(info)
							return self.db[info[#info]]
						end,
						set = function(info, value)
							self.db[info[#info]] = value
							self:UpdateMedia()
							for i = 1, 4 do
								self:UpdateBar(i)
							end
						end
					},
					height = {
						type = "range",
						order = 8,
						name = L.Height,
						desc = L["Set the Width of the Text Font"],
						min = 5,
						max = 800,
						step = 1,
						get = function(info)
							return self.db[info[#info]]
						end,
						set = function(info, value)
							self.db[info[#info]] = value
							self:UpdateMedia()
							for i = 1, 4 do
								self:UpdateBar(i)
							end
						end
					},
					tag = {
						type = "input",
						width = "full",
						name = L["Text Format"],
						desc = L.TEXT_FORMAT_DESC,
						order = 9,
						get = function()
							return self.db.tag
						end,
						set = function(_, value)
							self.db.tag = value
							self:Update()
						end
					}
				}
			},
			partyXpVariables = {
				order = 5,
				type = "group",
				name = L["Variables and Movers"],
				guiInline = true,
				get = function(info)
					return self.db[info[#info]]
				end,
				set = function(info, value)
					self.db[info[#info]] = value
					self:UpdateMedia()
				end,
				args = {
					offset = {
						type = "range",
						order = 1,
						name = L.Offset,
						desc = L["Vertical offset from parent frame"],
						min = -20,
						max = 20,
						step = 1
					}
				}
			}
		}
	}

	return options
end
