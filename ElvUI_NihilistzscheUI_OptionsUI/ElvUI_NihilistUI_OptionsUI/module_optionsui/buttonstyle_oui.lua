local NUI, _, L = _G.unpack(_G.ElvUI_NihilistUI)
local BS = NUI.ButtonStyle
if not BS then
	return
end

function BS:GenerateOptions()
	local options = {
		type = "group",
		name = L.ButtonStyle,
		get = function(info)
			return self.db[info[#info]]
		end,
		set = function(info, value)
			self.db[info[#info]] = value
			self:UpdateButtons()
		end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["NihilisttUI ButtonStyle by Nihilistzsche"]
			},
			description = {
				order = 2,
				type = "description",
				name = L["NihilisttUI ButtonStyle provides a style setting for ElvUI buttons similar to Masque or ButtonFacade\n"]
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
						desc = L["Enable the button style."]
					}
				}
			}
		}
	}

	return options
end
