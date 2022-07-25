local NUI = _G.unpack(_G.ElvUI_NihilistUI)

local NI = NUI.Installer
local COMP = NUI.Compatibility

function NI:AddOnSkinsSetup()
	local AS = _G.AddOnSkins[1]
	self:SetProfile(
		_G.AddOnSkinsDB,
		{
			EmbedOoC = false,
			EmbedLeft = "",
			EmbedLeftWidth = 240,
			DBMFont = self.db.font,
			DBMSkinHalf = true,
			Blizzard_AbilityButton = true,
			Parchment = false,
			EmbedSystemDual = false,
			EmbedRight = "",
			EmbedMain = "",
			EmbedIsHidden = true,
			BarrelsOEasy = true,
			SkinDebug = AS.Nihilist and true or false,
			MerathilisUIStyling = COMP.MERS and true or nil
		}
	)
end

NI:RegisterAddOnInstaller("AddOnSkins", NI.AddOnSkinsSetup)
