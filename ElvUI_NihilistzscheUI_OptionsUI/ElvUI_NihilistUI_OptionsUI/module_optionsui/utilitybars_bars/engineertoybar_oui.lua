local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistUI)
local ETOYB = NUI.UtilityBars.EngineerToyBar

local C_ToyBox_GetToyInfo = _G.C_ToyBox.GetToyInfo

function ETOYB:GenerateUtilityBarOptions()
	if not self:IsEngineer() then
		return
	end
	local options = {
		type = "group",
		name = L["Engineer Toy Bar"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["NihilistUI EngineerToyBar by Nihilistzsche"]
			},
			description = {
				order = 2,
				type = "description",
				name = L["NihilistUI EngineerToyBar provides an automatically updated bar populated with your engineering toys."]
			},
			general = {
				order = 3,
				type = "group",
				name = L.General,
				guiInline = true,
				get = function(info)
					return E.db.nihilistui.utilitybars.engineertoybar[info[#info]]
				end,
				set = function(info, value)
					E.db.nihilistui.utilitybars.engineertoybar[info[#info]] = value
					self:UpdateBar(self.bar)
				end,
				args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = L.Enable,
						desc = L["Enable the engineer toy bar"]
					},
					resetsettings = {
						type = "execute",
						order = 2,
						name = L["Reset Settings"],
						desc = L["Reset the settings of this addon to their defaults."],
						func = function()
							E:CopyTable(E.db.nihilistui.utilitybars.engineertoybar, P.nihilistui.utilitybars.engineertoybar)
							self:UpdateBar(self.bar)
						end
					},
					mouseover = {
						type = "toggle",
						order = 3,
						name = L.Mouseover,
						desc = L["Only show the toy bar when you mouseover it"]
					},
					buttonsize = {
						type = "range",
						order = 4,
						name = L.Size,
						desc = L["Button Size"],
						min = 12,
						max = 40,
						step = 1
					},
					spacing = {
						type = "range",
						order = 5,
						name = L.Spacing,
						desc = L["Spacing between buttons"],
						min = 1,
						max = 10,
						step = 1
					},
					alpha = {
						type = "range",
						order = 6,
						name = L.Alpha,
						desc = L["Alpha of the bar"],
						min = 0.2,
						max = 1,
						step = .1
					},
					buttonsPerRow = {
						type = "range",
						order = 8,
						name = L["Buttons Per Row"],
						desc = L["Number of buttons on each row"],
						min = 1,
						max = 12,
						step = 1
					}
				}
			},
			itemToggles = {
				order = 4,
				type = "group",
				name = L["Item Toggling"],
				guiInline = true,
				get = function(info)
					local toyID = tonumber(info[#info])
					local val = E.db.nihilistui.utilitybars.engineertoybar.toys[toyID]
					if val ~= nil then
						return val
					else
						return true
					end
				end,
				set = function(info, value)
					local toyID= tonumber(info[#info])
					E.db.nihilistui.utilitybars.engineertoybar.toys[toyID] = value
					self:UpdateBar(self.bar)
				end,
				args = {}
			}
		}
	}

	local itemToggles = options.args.itemToggles

	local o = 1;
	for _, toyID in ipairs(self.EngineerToys) do
		local _, name, icon = C_ToyBox_GetToyInfo(toyID)
		if name and icon then
			local str = "|T"..icon..":12|t "..name
			itemToggles.args[tostring(toyID)] = {
				type = "toggle",
				order = o,
				desc = "Show the "..str.." on the bar.",
				name = str
			}
			o = o + 1
		end
	end

	return options
end
