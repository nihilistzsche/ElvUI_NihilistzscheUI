local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer

function NI:CursorTrailSetup()
    _G.CursorTrail_Config = _G.CursorTrail_Config or {}
    _G.CursorTrail_Config.Profiles = _G.CursorTrail_Config.Profiles or {}
    local color = self:Color()
    _G.CursorTrail_Config.Profiles[string.lower(self.profileKey)] = {
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
        ["FadeOut"] = false,
    }
end

NI:RegisterAddOnInstaller("CursorTrail", NI.CursorTrailSetup)
