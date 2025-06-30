---@class NUI
local NUI = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

function NI:TouhinSetup()
    self:SetProfile(_G.TouhinDB, {
        edgeSize = 1,
        scale = 0.9,
        anchor_y = 249.000579833984,
        bgFile = "Duffed",
        showMoney = false,
        font = self.db.font,
        anchor_x = 57.0003356933594,
        edgeFile = "None",
        anchor_point = "LEFT",
        qualitySelfThreshold = 2,
        colorBackground = false,
        insets = 2,
    })
end

NI:RegisterAddOnInstaller("Touhin", NI.TouhinSetup)
