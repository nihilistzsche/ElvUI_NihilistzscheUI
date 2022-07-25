local NUI = _G.unpack(_G.ElvUI_NihilistUI)

local NI = NUI.Installer

function NI:PDBCSetup()
	self:EDB().EPDBC = {
		experienceBar = {}
	}
	self:EDB().EPDBC.experienceBar.xpColor = self:Color()
	self:EDB().EPDBC.experienceBar.restColor = self:ModColor(
		function(x)
			return math.max(1 - x, 0.15)
		end
	)
	self:EDB().EPDBC.experienceBar.restColor.a = .20
end

NI:RegisterAddOnInstaller("ElvUI_PDBC", NI.PDBCSetup, true)