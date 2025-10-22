local NUI = unpack((select(2, ...)))
local NI = NUI.Installer

function NI:BigWigsSetup()
    _G.BigWigs3DB.namespaces.BigWigs_Plugins_Bars.profiles.Default = {
        barStyle = "AddOnSkins Half-Bar",
        fontName = self.db.font,
        spacing = 13,
        normalHeight = 10,
        texture = self.db.texture,
        expPosition = {
            nil,
            nil,
            -25,
            164,
        },
        expHeight = 11,
    }
end

NI:RegisterGlobalAddOnInstaller("BigWigs", NI.BigWigsSetup)
