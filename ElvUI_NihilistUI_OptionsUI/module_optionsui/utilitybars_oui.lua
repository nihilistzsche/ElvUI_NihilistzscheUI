local NUI, E, L = _G.unpack(_G.ElvUI_NihilistUI)
local NUB = NUI.UtilityBars

function NUB:GenerateOptions()
	local options = {
		type = "group",
		name = "Utility Bars",
		desc = "Various Utility Bars provided by NihilistUI",
		childGroups = "select",
		args = {
			hideincombat = {
				type = "toggle",
				order = 1,
				name = L["Hide in Combat"],
				desc = L["Hide the utility bars in combat"],
				get = function(info)
					return E.db.nihilistui.utilitybars[info[#info]]
				end,
				set = function(info, value)
					E.db.nihilistui.utilitybars[info[#info]] = value
				end
			}
		}
	}

	local bars = {}

	for _, mod in pairs(self.RegisteredBars) do
		if (mod.GenerateUtilityBarOptions) then
			bars[mod:GetName()] = mod
		end
	end

	local order = 1
	for _, mod in NUI.PairsByKeys(bars) do
		local _options = mod:GenerateUtilityBarOptions()
		if (_options) then
			local name = mod:GetName()
			options.args[name] = _options
			options.args[name].order = order
			order = order + 1
		end
	end

	return options
end
