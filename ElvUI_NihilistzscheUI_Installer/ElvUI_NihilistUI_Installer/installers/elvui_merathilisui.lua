local NUI, E = _G.unpack(_G.ElvUI_NihilistUI)
local NI = NUI.Installer

local COMP = NUI.Compatibility

function NI.MerathilisUIGlobalSetup()
	local baseProfileKey = E.myLocalizedClass .. " - NihilistUI"
	local baseBlacklist = _G.ElvDB.profiles[baseProfileKey].mui.autoButtons.blackList
	for key, tbl in pairs(_G.ElvDB.profiles) do
		if key ~= baseProfileKey then
			if tbl.mui and tbl.mui.autoButtons then
				tbl.mui.autoButtons.blackList = E:CopyTable({}, baseBlacklist)
			end
		end
	end
end

NI:RegisterGlobalAddOnInstaller("ElvUI_MerathilisUI", NI.MerathilisUIGlobalSetup)

function NI:MerathilisUISetup(isSpec)
	self:EDB().mui = self:EDB().mui or {}
	self:EDB().mui.installed = true
	_G.MERDataPerChar = _G.ElvUI_MerathilisUI[1].Version
	self:EDB().mui.general = {
		splashScreen = false,
		gmotd = false
	}
	self:EDB().mui.autoButtons = self:EDB().mui.autoButtons or {}
	self:EDB().mui.autoButtons.customList = {
		87216, -- [1]
		144341 -- [2]
	}
	self:EDB().mui.autoButtons.bar2 = {
		include = "POTIONSL,FLASKSL,UTILITY,CUSTOM"
	}
	self:EDB().mui.autoButtons.bar3 = {
		include = "MAGEFOOD,FOODVENDOR,FOODSL"
	}
	self:EDB().mui.panels = {
		bottomPanel = false,
		topPanel = false,
		stylePanels = {
			topLeftPanel = false,
			topRightPanel = false,
			bottomRightPanel = false,
			bottomLeftPanel = false
		}
	}
	self:EDB().mui.microBar = {
		visibility = "show"
	}
	self:EDB().mui.chat = {
		panelHeight = 180
	}
	self:EDB().mui.datatexts = {
		[2] = {enable = false},
		rightChatTabDatatextPanel = {enable = false}
	}
	self:EDB().mui.tooltip = {
		modelIcon = true,
		progressInfo = {
			raid = {
				Nyalotha = false,
				EternalPalace = false
			}
		}
	}
	self:EDB().mui.misc = {
		nameHover = false,
		mawThreatBar = {
			font = {
				name = self.db.font
			}
		},
		lfgInfo = {
			line = {
				tex = self.db.texture
			}
		}
	}
	self:EDB().mui.bags = {}
	self:EDB().mui.bags.splitBags = {enable = false}
	self:EDB().mui.raidmarkers = {
		enable = true,
		backdrop = true
	}
	self:EDB().mui.raidBuffs = {
		enable = true,
		class = true
	}

	if not isSpec then
		self:EPRV().muiSkins = {
			blizzard = {
				merchant = false
			}
		}
	end
	self.SaveMoverPosition("MER_RaidBuffReminderMover", "TOPLEFT", E.UIParent, "TOPLEFT", 238, -141)
	self.SaveMoverPosition("MER_RaidManager", "TOPRIGHT", E.UIParent, "TOPRIGHT", -179, -190)
	self.SaveMoverPosition("Notification Mover", "TOP", E.UIParent, "TOP", 0, -120)
	if NUI.Private then
		self.SaveMoverPosition("mUI_RaidMarkerBarAnchor", "TOPRIGHT", E.UIParent, "TOPRIGHT", -179, -166)
	else
		self.SaveMoverPosition("mUI_RaidMarkerBarAnchor", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -4, 313)
	end
	self.SaveMoverPosition("AutoButtonBar1Mover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -398, 334)
	self.SaveMoverPosition("AutoButtonBar2Mover", "TOP", "AutoButtonBar1Mover", "BOTTOM", 0, -4)
	self.SaveMoverPosition("AutoButtonBar3Mover", "TOP", "AutoButtonBar2Mover", "BOTTOM", 0, -4)

	if (COMP.LCP) then
		self:EDB().mui.locPanel = {
			enable = false
		}
		self.SaveMoverPosition("MicroBarAnchor", "TOP", "LocationPlusPanel", "BOTTOM", 0, -2)
	end
end

if (COMP.MERS) then
	NI:SaveInstallTable(_G.ElvUI_MerathilisUI[1])
end

NI:RegisterAddOnInstaller("ElvUI_MerathilisUI", NI.MerathilisUISetup, true)
