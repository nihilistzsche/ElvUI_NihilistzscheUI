local NUI, E = _G.unpack(_G.ElvUI_NihilistUI)
local NI = NUI.Installer

function NI:CustomStyleFiltersSetup()
	E.global = E.global or {}
	E.global.customStyleFilters = E.global.customStyleFilters or {}
	E.global.customStyleFilters.customTriggers = E.global.customStyleFilters.customTriggers or {}

	E.global.customStyleFilters.customTriggers.isPlayerNP = {
		func = "function(frame)\n    return frame:GetName() == \"ElvNP_Player\"\nend",
		description = "",
		isNegated = false,
	}
	E.global.customStyleFilters.customTriggers.HealthTextNotVisible = {
		description = "",
		isNegated = false,
		func = "function(frame)\n    return not frame.Health.Text:IsVisible()\nend",
	}

	E.global.customStyleFilters.customActions = E.global.customStyleFilters.customActions or {}
	E.global.customStyleFilters.customActions.MakeHealthTextVisible = {
		description = "Make the health text visible again, clear is empty bec5ause this is a bug fix",
		applyFunc = "function(frame)\n    CSFNP = CSFNP or ElvUI[1].NamePlates\n    local db = CSFNP:PlateDB(frame)\n    if db and db.health and db.health.text and db.health.text.enable and not frame.StyleFilterChanges.NameOnly then\n        frame.Health.Text:Show()\n        frame:Tag(frame.Health.Text, db.health.text.format)\n    end\nend",
		clearFunc = "function(frame)\nend",
	}
end

NI:RegisterGlobalAddOnInstaller("ElvUI_CustomStyleFilters", NI.CustomStyleFiltersSetup)
