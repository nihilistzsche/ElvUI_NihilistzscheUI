--
-- Created by IntelliJ IDEA.
-- User: mtindal
-- Date: 8/29/2017
-- Time: 11:30 PM
-- To change this template use File | Settings | File Templates.
--

local NUI, E, L = _G.unpack(_G.ElvUI_NihilistUI)
local AL = NUI.AutoLog
if not AL then
	return
end

function AL:GenerateOptions()
	local options = {
		type = "group",
		name = "AutoLog",
		get = function(info)
			return E.db.nihilistui.autolog[info[#info]]
		end,
		set = function(info, value)
			E.db.nihilistui.autolog[info[#info]] = value
		end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = "Autolog enabler"
			},
			desc = {
				order = 2,
				type = "description",
				name = "Auto enables combatlog based on instance/group"
			},
			enabled = {
				order = 3,
				type = "toggle",
				name = L.Enable,
				set = function(info, value)
					E.db.nihilistui.autolog[info[#info]] = value
					self:UpdateEnabled()
				end
			},
			spacer1 = {
				order = 3,
				type = "description",
				name = ""
			},
			apartylog = {
				order = 4,
				type = "group",
				name = "Config",
				guiInline = true,
				get = function(info)
					return E.db.nihilistui.autolog[info[#info]]
				end,
				set = function(info, value)
					E.db.nihilistui.autolog[info[#info]] = value
				end,
				args = {
					party = {
						order = 1,
						name = "Party",
						desc = "Enable logging whenever you enter a party based instance.",
						type = "toggle"
					},
					raid = {
						order = 2,
						name = "Raid",
						desc = "Enable logging whenever you enter a raid based instance.",
						type = "toggle"
					}
				}
			}
		}
	}

	return options
end
