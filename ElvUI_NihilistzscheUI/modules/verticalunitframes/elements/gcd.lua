local NUI = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructGCD(frame)
    self:AddElement(frame, "gcd")
    local GCD = self:ConstructStatusBar(frame, "gcd")
    GCD:SetStatusBarColor(0.8, 0.8, 0.8, 0)
    GCD:SetAlpha(1)
    GCD:SetOrientation("VERTICAL")
    GCD:SetFrameStrata(frame.Power:GetFrameStrata())
    GCD:SetFrameLevel(frame.Power:GetFrameLevel() + 2)
    GCD:Hide()

    GCD.Spark = GCD:CreateTexture(frame:GetName() .. "_GCDSpark", "OVERLAY")
    GCD.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    GCD.Spark:SetVertexColor(1, 1, 1)
    GCD.Spark:Height(12)
    GCD.Spark:Point("CENTER", GCD:GetStatusBarTexture(), "TOP")
    GCD.Spark:SetBlendMode("ADD")

    return GCD
end

function VUF:GCDOptions(unit)
    return self:GenerateElementOptionsTable(unit, "gcd", 1300, "GCD Spark", true, true, false, false, false)
end
