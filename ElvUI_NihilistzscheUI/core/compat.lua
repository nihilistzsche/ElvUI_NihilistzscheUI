local NUI, E = _G.unpack(select(2, ...))
local COMP = NUI.Compatibility

local GetAddOnEnableState = _G.GetAddOnEnableState
local hooksecurefunc = _G.hooksecurefunc

local function Disable(tbl, key)
    key = key or "enable"
    if (tbl[key]) then
        tbl[key] = false
        return true
    end
    return false
end

function COMP.IsAddOnEnabled(addon) -- Credit: Azilroka
    return GetAddOnEnableState(E.myname, addon) == 2
end

COMP.BUI = COMP.IsAddOnEnabled("ElvUI_BenikUI")
COMP.MERS = COMP.IsAddOnEnabled("ElvUI_MerathilisUI")
COMP.SLE = COMP.IsAddOnEnabled("ElvUI_SLE")
COMP.LCP = COMP.IsAddOnEnabled("ElvUI_LocPlus")
COMP.WQT = COMP.IsAddOnEnabled("WorldQuestTracker")
COMP.PA = COMP.IsAddOnEnabled("ProjectAzilroka")
COMP.LST = COMP.IsAddOnEnabled("ls_Toasts")
COMP.AS = COMP.IsAddOnEnabled("AddOnSkins")
COMP.QG = COMP.IsAddOnEnabled("QuestGuru")
COMP.CQL = COMP.IsAddOnEnabled("Classic Quest Log")
COMP.ZP = COMP.IsAddOnEnabled("zPets")
COMP.DTL = COMP.IsAddOnEnabled("Details")
COMP.IF = COMP.IsAddOnEnabled("InFlight")
COMP.KT = COMP.IsAddOnEnabled("!KalielsTracker")
COMP.DEV = COMP.IsAddOnEnabled("ElvUI_CPU")
COMP.NAB = COMP.IsAddOnEnabled("ElvUI_NutsAndBolts")
COMP.TOU = COMP.IsAddOnEnabled("Touhin")
COMP.LH = COMP.IsAddOnEnabled("Lightheaded")
COMP.EA = COMP.IsAddOnEnabled("Executive_Assistant")
COMP.BAGGINS = COMP.IsAddOnEnabled("Baggins")
COMP.WP = COMP.IsAddOnEnabled("WoWPro")
COMP.FCT = COMP.IsAddOnEnabled("ElvUI_FCT")
COMP.TT = COMP.IsAddOnEnabled("ElvUI_TinkerToolbox")
COMP.DSI = COMP.IsAddOnEnabled("ElvUI_DynamicStatusIcons")

function COMP.Print(addon, feature)
    if
        (E.private.nihilistzscheui.comp and E.private.nihilistzscheui.comp[addon] and
            E.private.nihilistzscheui.comp[addon][feature])
     then
        return
    end
    print(NUI.Title .. " has |cffff2020disabled|r " .. feature .. " from " .. addon .. " due to incompatiblities.")
    E.private.nihilistzscheui.comp = E.private.nihilistzscheui.comp or {}
    E.private.nihilistzscheui.comp[addon] = E.private.nihilistzscheui.comp[addon] or {}
    E.private.nihilistzscheui.comp[addon][feature] = true
end

function COMP:SLECompatibility()
    local SLE = _G.ElvUI_SLE[1]
    if (Disable(E.private.sle.module.shadows)) then
        self.Print(SLE.Title, "shadows")
    end
end

function COMP:BenikUICompatibility()
    local BUI = _G.ElvUI_BenikUI[1]

    local changedDatabar = false
    if (Disable(E.db.benikui.databars.experience)) then
        changedDatabar = true
    end
    if (Disable(E.db.benikui.databars.reputation)) then
        changedDatabar = true
    end
    if (Disable(E.db.benikui.databars.azerite)) then
        changedDatabar = true
    end
    if (Disable(E.db.benikui.databars.honor)) then
        changedDatabar = true
    end
    if (changedDatabar) then
        self.Print(BUI.Title, "Databars")
    end
end

function COMP:MerathilisUICompatibility()
    local MER = _G.ElvUI_MerathilisUI[1]

    if (Disable(E.db.mui.actionbars.specBar)) then
        self.Print(MER.Title, "SpecBar")
    end

    if (Disable(E.db.mui.actionbars.equipBar)) then
        self.Print(MER.Title, "EquipBar")
    end

    if (E.db.mui.cooldowns and Disable(E.db.mui.cooldowns.raid)) then
        self.Print(MER.Title, "RaidCDs")
    end

    --[[if (Disable(E.db.mui['NameplateAuras'])) then
		self.Print(MER.Title, "Nameplate Auras");
	end]]
    if (E.db.mui.talents and Disable(E.db.mui.talents.talentManager)) then
        self.Print(MER.Title, "TalentManager")
    end
end

COMP.CompatibilityFunctions = {}

function COMP:RegisterCompatibilityFunction(addonName, compatFunc)
    self.CompatibilityFunctions[addonName] = compatFunc
end

COMP:RegisterCompatibilityFunction("SLE", "SLECompatibility")
COMP:RegisterCompatibilityFunction("BUI", "BenikUICompatibility")
COMP:RegisterCompatibilityFunction("MERS", "MerathilisUICompatibility")

function COMP:RunCompatibilityFunctions()
    for key, compatFunc in pairs(COMP.CompatibilityFunctions) do
        if (COMP[key]) then
            self[compatFunc](self)
        end
    end
end

hooksecurefunc(
    E,
    "CheckIncompatible",
    function()
        COMP:RunCompatibilityFunctions()
    end
)

function COMP.Initialize()
end

NUI:RegisterModule(COMP:GetName())
