local NUI = _G.unpack(_G.ElvUI_NihilistUI)
local NI = NUI.Installer

function NI:AltoholicCountHiderSetup()
	self:SetProfile(
		_G.Altoholic_CountHiderDB,
		{
			ignoreAllEquipped = true
		}
	)
end

NI:RegisterAddOnInstaller("Altoholic_CountHider", NI.AltoholicCountHiderSetup)
