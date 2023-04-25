local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer

function NI:PDBCSetup(isSpec)
    self:EDB().EPDBC = {
        experienceBar = {},
    }
    self:EDB().EPDBC.experienceBar.xpColor = self:Color()
    self:EDB().EPDBC.experienceBar.restColor = self:ModColor(function(x) return math.max(1 - x, 0.15) end)
    self:EDB().EPDBC.experienceBar.restColor.a = 0.20
    if not isSpec then
        self:EPRV().EPDBC = self:EPRV().EPDBC or {}
        self:EPRV().EPDBC.install_complete = true
    end
end

local EPDBC = E:GetModule("EPDBC", true)
if EPDBC then NI:SaveInstallTable(EPDBC) end

NI:RegisterAddOnInstaller("ElvUI_PDBC", NI.PDBCSetup, true)
