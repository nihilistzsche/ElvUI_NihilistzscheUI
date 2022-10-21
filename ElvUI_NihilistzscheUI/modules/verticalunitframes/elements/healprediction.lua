local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames

function VUF:ConstructHealthPrediction(frame)
    self:AddElement(frame, "healPrediction")
    local mhpb = self:ConstructStatusBar(frame, "healPrediction", frame, "mybar", true)
    mhpb:SetStatusBarTexture(E.media.blankTex)
    mhpb:SetFrameLevel(frame.Health:GetFrameLevel() + 1)
    mhpb:SetOrientation("VERTICAL")

    local ohpb = self:ConstructStatusBar(frame, "healPrediction", frame, "otherbar", true)
    ohpb:SetStatusBarTexture(E.media.blankTex)
    ohpb:SetFrameLevel(mhpb:GetFrameLevel())
    ohpb:SetOrientation("VERTICAL")

    local absorbBar = self:ConstructStatusBar(frame, "healPrediction", frame, "absorbbar", true)
    absorbBar:SetStatusBarTexture(E.media.blankTex)
    absorbBar:SetFrameLevel(mhpb:GetFrameLevel())
    absorbBar:SetOrientation("VERTICAL")

    local healAbsorbBar = self:ConstructStatusBar(frame, "healPrediction", frame, "healabsorbbar", true)
    healAbsorbBar:SetStatusBarTexture(E.media.blankTex)
    healAbsorbBar:SetFrameLevel(mhpb:GetFrameLevel())
    healAbsorbBar:SetOrientation("VERTICAL")

    local health = frame.Health
    local parent = health.ClipFrame
    return {
        myBar = mhpb,
        otherBar = ohpb,
        absorbBar = absorbBar,
        healAbsorbBar = healAbsorbBar,
        maxOverflow = 1,
        PostUpdate = UF.UpdateHealComm,
        anchor = "BOTTOM",
        anchor1 = "BOTTOM",
        anchor2 = "TOP",
        health = health,
        parent = parent,
        frame = frame
    }
end

function VUF:HealthPredictionOptions(unit)
    return self:GenerateElementOptionsTable(
        unit,
        "healPrediction",
        1200,
        "Heal Prediction",
        false,
        false,
        false,
        false,
        false
    )
end
