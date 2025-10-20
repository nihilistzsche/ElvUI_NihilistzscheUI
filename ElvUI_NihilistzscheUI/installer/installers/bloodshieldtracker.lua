---@class NUI
local NUI, E = _G.unpack((select(2, ...)))

local NI = NUI.Installer

function NI:BloodShieldTrackerSetup()
    if self.currentClass ~= "DEATHKNIGHT" then return end
    self:SetProfile(_G.BloodShieldTrackerDB, {
        font_face = self.db.font,
        bars = {
            ["**"] = {
                texture = self.db.texture,
            },
        },
    })
end

NI:RegisterAddOnInstaller("BloodShieldTracker", NI.BloodShieldTrackerSetup)
