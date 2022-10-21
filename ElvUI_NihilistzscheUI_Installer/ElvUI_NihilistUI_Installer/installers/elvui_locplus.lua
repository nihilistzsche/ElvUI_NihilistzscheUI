local NUI, E = _G.unpack(_G.ElvUI_NihilistUI)
local NI = NUI.Installer
local COMP = NUI.Compatibility

function NI:LocPlusSetup()
	self:EDB().datatexts.panels.LocPlusLeftDT = {
		[1] = COMP.SLE and "S&L Friends" or "Friends"
	}
	self:EDB().datatexts.panels.LocPlusRightDT = {
		[1] = COMP.SLE and "S&L Guild" or "Guild"
	}

	self.SaveMoverPosition("LocationMover", "TOP", E.UIParent, "TOP", 0, -30)
end

NI:RegisterAddOnInstaller("ElvUI_LocPlus", NI.LocPlusSetup, true)
