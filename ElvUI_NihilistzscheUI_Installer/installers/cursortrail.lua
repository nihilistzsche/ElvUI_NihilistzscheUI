local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer

function NI:CursorTrailSetup()
    local profileDB = _G.CursorTrail.OptionsFrame_GetProfilesDB()
    local color = self:Color()
    profileDB:set(string.lower(self.profileKey), {
        ["Strata"] = "BACKGROUND",
        ["UserOfsY"] = 0,
        ["ShapeColorG"] = color.g,
        ["ShapeColorB"] = color.b,
        ["ModelID"] = 166498,
        ["UserShowOnlyInCombat"] = false,
        ["UserAlpha"] = 1,
        ["UserOfsX"] = 0,
        ["UserScale"] = 1,
        ["UserShadowAlpha"] = 0,
        ["ShapeColorR"] = color.r,
        ["FadeOut"] = true,
    })
end

NI:RegisterAddOnInstaller("CursorTrail", NI.CursorTrailSetup)
