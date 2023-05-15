local NUI, E = _G.unpack((select(2, ...)))

local DBN = NUI.DataBarNotifier
local COMP = NUI.Compatibility

local UnitHonor = _G.UnitHonor
local UnitHonorMax = _G.UnitHonorMax
local UnitHonorLevel = _G.UnitHonorLevel

DBN.colors.alliance = E:RGBToHex(0.29, 0.33, 0.91)
DBN.colors.horde = E:RGBToHex(0.90, 0.05, 0.07)

local HN =
    DBN:NewNotifier("Honor", "Honor", "honor", nil, NUI.CPW(UnitHonor), NUI.CPW(UnitHonorMax), NUI.CPW(UnitHonorLevel))

function HN:Initialize()
    if COMP.SLE then
        local Icon = [[Interface\AddOns\ElvUI_SLE\media\textures\factionlogo\blizzard\]] .. E.myfaction
        self.textureMarkup = "|T" .. Icon .. ":12|t"
    end
    self:ScanValues()
    self:GetParent():RegisterNotifierEvent(self, "HONOR_XP_UPDATE")
    self.color = E.myfaction == "Alliance" and self:GetParent().colors.alliance or self:GetParent().colors.horde
end

DBN:RegisterNotifier(HN)
