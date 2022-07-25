local NUI, E, L = _G.unpack(_G.ElvUI_NihilistUI)
local CDB = NUI.CustomDataBar


function CDB:GenerateOptions()
	E.Options.args.databars.args.experience.args.textFormat = nil
	E.Options.args.databars.args.experience.args.tag = {
		type = "input",
		width = "full",
		name = L["Text Format"],
		desc = L.TEXT_FORMAT_DESC,
		order = 4,
		get = function()
			return E.db.databars.experience.tag
		end,
		set = function(_, value)
			E.db.databars.experience.tag = value
			self:UpdateTag("xp")
		end
	}

	E.Options.args.databars.args.reputation.args.textFormat = nil
	E.Options.args.databars.args.reputation.args.tag = {
		type = "input",
		width = "full",
		name = L["Text Format"],
		desc = L.TEXT_FORMAT_DESC,
		order = 4,
		get = function()
			return E.db.databars.reputation.tag
		end,
		set = function(_, value)
			E.db.databars.reputation.tag = value
			self:UpdateTag("rep")
		end
	}

	E.Options.args.databars.args.azerite.args.textFormat = nil
	E.Options.args.databars.args.azerite.args.tag = {
		type = "input",
		width = "full",
		name = L["Text Format"],
		desc = L.TEXT_FORMAT_DESC,
		order = 4,
		get = function()
			return E.db.databars.azerite.tag
		end,
		set = function(_, value)
			E.db.databars.azerite.tag = value
			self:UpdateTag("azerite")
		end
	}

	E.Options.args.databars.args.honor.args.textFormat = nil
	E.Options.args.databars.args.honor.args.tag = {
		type = "input",
		width = "full",
		name = L["Text Format"],
		desc = L.TEXT_FORMAT_DESC,
		order = 6,
		get = function()
			return E.db.databars.honor.tag
		end,
		set = function(_, value)
			E.db.databars.honor.tag = value
			self:UpdateTag("honor")
		end
	}
end
