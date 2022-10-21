local NUI, E = _G.unpack(_G.ElvUI_NihilistUI)
local COMP = NUI.Compatibility
local NI = NUI.Installer

-- luacheck: push no self
function NI:ElvUICustomTagsSetup()
	-- luacheck: push no max line length
	E.global.CustomTags = E.global.CustomTags or {}
	E.global.CuvstomVars = E.global.CustomVars or {}
	E.global.CustomVars.utf8sub = "string.utf8sub"
	E.global.CustomVars.utf8len = "string.utf8len"
	E.global.CustomTags["name:health:classcolors"] = {
		vars = "",
		description = "",
		category = "",
		func = 'function(unit)\n    local c = RAID_CLASS_COLORS[select(2,UnitClass(unit))]\n    if not c then return "" end\n    local n = function(z) return math.max(0.15, 1-z) end\n    return _TAGS["name:health"](unit, _, string.format("%s:%s",c.colorStr:sub(3),_VARS.E:RGBToHex(n(c.r),n(c.g),n(c.b))))\nend',
		events = "UNIT_HEALTH UNIT_MAXHEALTH PLAYER_FLAGS_CHANGED"
	}
	E.global.CustomTags["name:title:health:colors"] = {
		vars = "",
		description = "",
		category = "",
		func = 'function(unit, _, args)\n    local _V = _VARS\n    local utf8len, utf8sub, TF = _V.utf8len, _V.utf8sub, _V.TF\n    \n    local name = _TAGS["name:title"](unit)\n    if not name or name == "" then return end\n    local min, max, bco, fco = UnitHealth(unit), UnitHealthMax(unit), strsplit(":", args or "")\n    \n    local to = ceil(utf8len(name)*(min/max))\n    \n    local fill = TF.NameHealthColor(_TAGS, fco, unit, "|cffff3333")\n    local base = TF.NameHealthColor(_TAGS, bco, unit, "|cffffffff")\n    \n    return to > 0 and (base..utf8sub(name, 0, to)..fill..utf8sub(name, to+1,-1)) or fill..name \nend',
		events = "UNIT_HEALTH UNIT_MAXHEALTH PLAYER_FLAGS_CHANGED"
	}
	E.global.CustomTags["name:title:health:classcolors"] = {
		vars = "",
		description = "",
		category = "",
		func = 'function(unit)\n    local c = RAID_CLASS_COLORS[select(2,UnitClass(unit))]\n    if not c then return "" end\n    local n = function(z) return math.max(0.15,1-z) end\n    local a = ("%s:%s"):format(c.colorStr:sub(3), _VARS.E:RGBToHex(n(c.r),n(c.g),n(c.b)):sub(5))\n    return _TAGS["name:title:health:colors"](unit, _, a)\nend',
		events = "UNIT_HEALTH UNIT_MAXHEALTH PLAYER_FLAGS_CHANGED"
	}
	E.global.CustomTags["nui-absorbs"] = {
		vars = "",
		description = "",
		category = "",
		func = 'function(unit)\n    local tex = _TAGS.absorbs(unit)\n    if tex and tex ~= "" then\n        return ("(+%s)"):format(tex)\n    else\n        return nil\n    end\nend',
		events = "UNIT_ABSORB_AMOUNT_CHANGED"
	}
	if COMP.IsAddOnEnabled("TotalRP3") and COMP.IsAddOnEnabled("RP_Tags") then
		E.global.CustomTags["rp:title:name:colors"] = {
			vars = "",
			description = "",
			func = 'function(unit, _, args)\n    local _V = _VARS\n    local utf8len, utf8sub, TF = _V.utf8len, _V.utf8sub, _V.TF\n    \n    local name = _TAGS["rp:title"](unit) .. " ".._TAGS["rp:name"](unit) \n    local min, max, bco, fco = UnitHealth(unit), UnitHealthMax(unit), strsplit(":", args or "")\n    \n    local to = ceil(utf8len(name)*(min/max))\n    \n    local fill = TF.NameHealthColor(_TAGS, fco, unit, "|cffff3333")\n    local base = TF.NameHealthColor(_TAGS, bco, unit, "|cffffffff")\n    \n    return to > 0 and (base..utf8sub(name, 0, to)..fill..utf8sub(name, to+1,-1)) or fill..name \nend',
			events = "UNIT_HEALTH UNIT_MAXHEALTH PLAYER_FLAGS_CHANGED"
		}
		E.global.CustomTags["rp:title:name:classcolors"] = {
			vars = "",
			description = "",
			category = "",
			func = 'function(unit)\n    local c = RAID_CLASS_COLORS[select(2,UnitClass(unit))]\n    if not c then return "" end\n    local n = function(z) return math.max(0.15,1-z) end\n    local a = ("%s:%s"):format(c.colorStr:sub(3), _VARS.E:RGBToHex(n(c.r),n(c.g),n(c.b)):sub(5))\n    return _TAGS["rp:title:name:colors"](unit, _, a)\nend',
			events = "UNIT_HEALTH UNIT_MAXHEALTH PLAYER_FLAGS_CHANGED"
		}
	end
	-- luacheck: pop
end
-- luacheck: pop
NI:RegisterGlobalAddOnInstaller("ElvUI_CustomTags", NI.ElvUICustomTagsSetup)
