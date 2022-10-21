local NUI, _, L = _G.unpack(select(2, ...))
local ADB = NUI.AnimatedDataBars

local UnitXP = _G.UnitXP
local UnitXPMax = _G.UnitXPMax
local UnitLevel = _G.UnitLevel
local GameTooltip = _G.GameTooltip
local format = _G.format

local XP = ADB:NewDataBar(NUI.CPW(UnitXP), NUI.CPW(UnitXPMax), NUI.CPW(UnitLevel))

function XP:Initialize()
    self:GetParent():CreateAnimatedBar(self, "Experience")
end

ADB:RegisterDataBar(XP)
