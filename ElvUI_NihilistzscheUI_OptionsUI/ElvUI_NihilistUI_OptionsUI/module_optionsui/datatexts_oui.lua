local NUI, E, L = _G.unpack(_G.ElvUI_NihilistUI) --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local ISD = NUI.DataTexts.ImprovedSystemDataText

local PDT = NUI.DataTexts.ProfessionsDataText

local TDT = NUI.DataTexts.TitlesDT

local DT = E.DataTexts

local GetProfessionInfo = _G.GetProfessionInfo
local GetProfessions = _G.GetProfessions
local sort = _G.sort

function ISD.GenerateOptions()
	-- inject our options into elvui's options window
	local options = {
		type = "group",
		name = L["Improved System Datatext"],
		get = function(info)
			return E.db.nihilistui.sysdt[info[#info]]
		end,
		set = function(info, value)
			E.db.nihilistui.sysdt[info[#info]] = value
			DT:LoadDataTexts()
		end,
		args = {
			maxAddons = {
				type = "range",
				order = 1,
				name = L["Max Addons"],
				desc = L["Maximum number of addons to show in the tooltip."],
				min = 1,
				max = 50,
				step = 1
			},
			announceFreed = {
				type = "toggle",
				order = 2,
				name = L["Announce Freed"],
				desc = L["Announce how much memory was freed by the garbage collection."]
			},
			showFPS = {
				type = "toggle",
				order = 3,
				name = L["Show FPS"],
				desc = L["Show FPS on the datatext."]
			},
			showMemory = {
				type = "toggle",
				order = 4,
				name = L["Show Memory"],
				desc = L["Show total addon memory on the datatext."]
			},
			showMS = {
				type = "toggle",
				order = 5,
				name = L["Show Latency"],
				desc = L["Show latency on the datatext."]
			},
			latency = {
				type = "select",
				order = 6,
				name = L["Latency Type"],
				desc = L[
					"Display world or home latency on the datatext.  Home latency refers to your realm server.  World latency refers to the current world server."
				],
				disabled = function()
					return not E.db.nihilistui.sysdt.showMS
				end,
				values = {
					home = L.Home,
					world = L.World
				}
			}
		}
	}

	return options
end

local function GetProfessionName(index)
	local name, _, _, _, _, _, _, _ = GetProfessionInfo(index)
	return name
end

function PDT.GenerateOptions()
	local options = {
		type = "group",
		name = L["Professions Datatext"],
		get = function(info)
			return E.db.nihilistui.profdt[info[#info]]
		end,
		set = function(info, value)
			E.db.nihilistui.profdt[info[#info]] = value
			DT:LoadDataTexts()
		end,
		args = {
			prof = {
				type = "select",
				order = 1,
				name = L.Professions,
				desc = L["Select which profession to display."],
				values = function()
					local prof1, prof2, archy, fishing, cooking = GetProfessions()
					local profValues = {}
					if prof1 ~= nil then
						profValues.prof1 = GetProfessionName(prof1)
					end
					if prof2 ~= nil then
						profValues.prof2 = GetProfessionName(prof2)
					end
					if archy ~= nil then
						profValues.archy = GetProfessionName(archy)
					end
					if fishing ~= nil then
						profValues.fishing = GetProfessionName(fishing)
					end
					if cooking ~= nil then
						profValues.cooking = GetProfessionName(cooking)
					end
					sort(profValues)
					return profValues
				end
			},
			hint = {
				type = "toggle",
				order = 2,
				name = L["Show Hint"],
				desc = L["Show the hint in the tooltip."]
			}
		}
	}

	return options
end

function TDT.GenerateOptions()
	local options = {
		type = "group",
		name = L["Titles Datatext"],
		get = function(info)
			return E.db.nihilistui.titlesdt[info[#info]]
		end,
		set = function(info, value)
			E.db.nihilistui.titlesdt[info[#info]] = value
			DT:LoadDataTexts()
		end,
		args = {
			useName = {
				type = "toggle",
				order = 4,
				name = L["Use Character Name"],
				desc = L["Use your character's class color and name in the tooltip."]
			}
		}
	}

	return options
end
