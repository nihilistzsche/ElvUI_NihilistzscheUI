local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

function NI:ActionBarCombatStateSetup()
    self:EDB().actionbar.combatstate = {
        ["bar1"] = {
            enable = true,
        },
        ["bar2"] = {
            enable = true,
        },
        ["bar3"] = {
            enable = true,
        },
        ["bar5"] = {
            enable = true,
        },
        ["bar6"] = {
            enable = true,
        },
        ["bar7"] = {
            enable = true,
        },
        ["bar8"] = {
            enable = false,
        },
    }
end

NI:RegisterAddOnInstaller("ElvUI_ActionbarCombatState", NI.ActionBarCombatStateSetup, true)
