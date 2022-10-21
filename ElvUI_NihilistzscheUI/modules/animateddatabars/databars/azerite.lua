local NUI = _G.unpack(select(2, ...))
local ADB = NUI.AnimatedDataBars

local AZ = ADB:NewDataBar(NUI.UnitAzeriteXP, NUI.UnitAzeriteXPMax, NUI.UnitAzeriteLevel)

function AZ:Initialize()
    self:GetParent():CreateAnimatedBar(self, "Azerite")
end

ADB:RegisterDataBar(AZ)
