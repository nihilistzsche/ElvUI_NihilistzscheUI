local NUI = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames

local CreateFrame = _G.CreateFrame

function VUF:ConstructRaidIcon(frame)
    self:AddElement(frame, "raidicon")
    local f = CreateFrame("Frame", nil, frame)
    f:SetFrameLevel(frame.Health:GetFrameLevel() + 20)

    local tex = f:CreateTexture(nil, "OVERLAY")
    tex:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])

    return tex
end

function VUF:RaidIconOptions(unit)
    return self:GenerateElementOptionsTable(unit, "raidicon", 800, "Raid Icon", true, true, false, false, false)
end
