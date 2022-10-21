local NUI, E = _G.unpack(_G.ElvUI_NihilistUI)
local NI = NUI.Installer
local COMP = NUI.Compatibility

function NI:BenikUISetup(isSpec)
	local BUI = _G.ElvUI_BenikUI[1]

	if not isSpec then
		self:EPRV().benikui = self:EPRV().benikui or {}
		self:EPRV().benikui.install_complete = BUI.Version
	end
	self:EDB().benikui = {installed = true}
	self:EDB().benikui.general = {
		splashScreen = false,
		benikuiStyle = true
	}
	self:EDB().benikuiDatabars ={
		threat = {
			buiStyle = true,
			notifiers = {
				position = "ABOVE",
			},
		},
		experience = {
			enable = false,
		},
		azerite = {
			enable = false,
		},
		reputation = {
			enable = false,
		},
		honor = {
			enable = false,
		},
	}
	self:EDB().benikui.benikuiWidgetbars = {
		mawBar = {
			enable = false,
		},
	}
	self:EDB().benikui.actionbars = {
		style = {
			["bar1"] = true,
			["bar2"] = true,
			["bar3"] = true,
			["bar4"] = true,
			["bar5"] = true,
			["bar6"] = true,
			["bar7"] = true,
			["bar8"] = true,
			["bar9"] = true,
			["bar10"] = true,
			petbar = true,
			stancebar = true
		}
	}
	self:EDB().benikui.datatexts = {
		mail = {toggle = false},
		chat = {enable = false},
		[2] = {enable = false}
	}

	self:EDB().dashboards = {
		dashFont = {
			dbfont = self.db.font
		},
		customBarColor = self:Color(),
		system = {enableSystem = false},
		tokens = {enableTokens = false},
		professions = {
			enableProfessions = not NUI.Lulupeep,
			combat = false,
			width = 414,
			mouseover = not NUI.Lulupeep
		}
	}
	self:EDB().benikui.misc = {
		ilevel = {
			font = self.db.font,
		}
	}
	self.SaveMoverPosition("RequestStopButton", "TOP", E.UIParent, "TOP", 0, -315)
	self.SaveMoverPosition("ProfessionsMover", "BOTTOM", NUI.Private and "DTPanelDTB2_NihilistUILTMover" or "DTPanelDTB2_NihilistUIRMover", "TOP", 0, 4)
end

if (COMP.BUI) then
	NI:SaveInstallTable(_G.ElvUI_BenikUI[1])
end

NI:RegisterAddOnInstaller("ElvUI_BenikUI", NI.BenikUISetup, true)
