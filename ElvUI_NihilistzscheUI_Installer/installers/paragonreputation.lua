local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer

function NI:ParagonReputationSetup()
    _G.ParagonReputationDB = {
        value = { 0.9, 0.8, 0.6 },
    }
end

NI:RegisterGlobalAddOnInstaller("ParagonReputation", NI.ParagonReputationSetup)
