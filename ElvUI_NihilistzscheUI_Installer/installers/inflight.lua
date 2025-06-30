---@class NUI
local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer

local default_per_char_set = false
function NI:InFlightSetup()
    if not default_per_char_set then
        InFlight.db.profiles["Default"].perchar = true
        default_per_char_set = true
    end
    self:SetProfile(_G.InFlight.db, {
        outline = false,
        backcolor = {
            a = 0.850000008940697,
            r = 0,
            g = 0,
            b = 0,
        },
        barcolor = self:Color(),
        border = "None",
        outlinetime = false,
        rp = "TOP",
        texture = self.db.texture,
        p = "TOP",
        confirmflight = false,
        dbinit = 35,
        bordercolor = {
            a = 0.800000011920929,
            r = 0.6,
            g = 0.6,
            b = 0.6,
        },
        totext = " ==> ",
        inline = false,
        y = -212,
        x = -10,
        unknowncolor = {
            a = 0.850000008940697,
            r = 0,
            g = 0,
            b = 0,
        },
        width = 230,
        height = 28,
        font = self.db.font,
        fontcolor = {
            a = 1,
            r = 1,
            g = 1,
            b = 1,
        },
        fill = true,
    }, self.baseProfile)
end

NI:RegisterAddOnInstaller("InFlight", NI.InFlightSetup, nil, true)
