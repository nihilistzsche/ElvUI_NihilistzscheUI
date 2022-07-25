local NUI, E, L = _G.unpack(_G.ElvUI_NihilistUI)
local CP = NUI.Misc.CardinalPoints


function CP:GenerateOptions()
	local options = {
		type = "group",
		name = L.CardinalPoints,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L.CardinalPoints
			},
			description = {
				order = 2,
				type = "description",
				name = L["Places cardinal points on your minimap (N, S, E, W)"]
			},
			general = {
				order = 3,
				type = "group",
				name = "General",
				guiInline = true,
				get = function(info)
					return E.db.nihilistui.cardinalpoints[info[#info]]
				end,
				set = function(info, value)
					E.db.nihilistui.cardinalpoints[info[#info]] = value
					self:Update()
				end,
				args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = L.Enable,
						desc = L["Enable the minimap points"]
					}
				}
			}
		}
	}

	return options
end
