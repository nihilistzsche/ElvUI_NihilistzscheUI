local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

function NI:ElvUINutsAndBoltsSetup()
    self:EDB().NutsAndBolts = {}
    self:EDB().NutsAndBolts.ObjectiveTracker = {
        enable = false,
    }
    self:EDB().NutsAndBolts.LocationLite = {
        enable = false,
    }
end

NI:RegisterAddOnInstaller("ElvUI_NutsAndBolts", NI.ElvUINutsAndBoltsSetup, true)
