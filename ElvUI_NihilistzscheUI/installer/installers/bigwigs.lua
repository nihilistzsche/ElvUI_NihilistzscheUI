local NUI = unpack((select(2, ...)))
local NI = NUI.Installer

function NI:BigWigsSetup()
    _G.BigWigs3DB.namespaces.BigWigs_Plugins_Bars.profiles.Default = {
        barStyle = "AddOnSkins Half-Bar",
        fontName = self.db.font,
        outline = "THICKOUTLINE",
        texture = self.db.texture,
        expPosition = { "CENTER", "CENTER", -25, 164, "UIParent" },
        normalPosition = { "CENTER", "CENTER", 450, 200, "UIParent" },
    }
end

NI:RegisterGlobalAddOnInstaller("BigWigs", NI.BigWigsSetup)
