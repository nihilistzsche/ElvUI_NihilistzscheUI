local NUI, E = _G.unpack(_G.ElvUI_NihilistUI)

local NI = NUI.Installer

function NI:BloodShieldTrackerSetup()
	if self.currentClass ~= "DEATHKNIGHT" then return end
	self:SetProfile(
		_G.BloodShieldTrackerDB,
		{
			font_face = self.db.font,
			bars = {
				["**"] = {
					texture = self.db.texture,
				}
			}
		}
	)
end

NI:RegisterAddOnInstaller("BloodShieldTracker", NI.BloodShieldTrackerSetup)
