local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer
local EP = E.Libs.EP

function NI:PDBCSetup()
    self:EDB().EPDBC = {
        experienceBar = {},
    }
    self:EDB().EPDBC.experienceBar.xpColor = self:Color()
    self:EDB().EPDBC.experienceBar.restColor = self:ModColor(function(x) return math.max(1 - x, 0.15) end)
    self:EDB().EPDBC.experienceBar.restColor.a = 0.20
    self:EDB().EPDBC.install_version = tonumber(GetAddOnMetadata("ElvUI_PDBC", "Version"))
end

local EPDBC = E:GetModule("EPDBC", true)
if EPDBC then
    function EPDBC:Initialize()
        -- Insert our options table when ElvUI config is loaded
        EP:RegisterPlugin("ElvUI_PDBC", EPDBC.InsertOptions)

        if E.db.EPDBC.enabled then EPDBC:StartUp() end
    end
end
NI:RegisterAddOnInstaller("ElvUI_PDBC", NI.PDBCSetup, true)
