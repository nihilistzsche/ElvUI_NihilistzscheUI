local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructPhaseIndicator(frame)
    self:AddElement(frame, "phaseindicator")
    local phaseIndicator = frame:CreateTexture(nil, "ARTWORK", nil, 1)
    phaseIndicator:SetSize(30, 30)
    phaseIndicator:SetPoint("CENTER", frame.Health, "CENTER")
    phaseIndicator:SetDrawLayer("OVERLAY", 7)

    phaseIndicator.PostUpdate = self.PhaseIndicatorUpdate

    return phaseIndicator
end

function VUF:PhaseIndicatorUpdate()
    local db = E.db.nihilistzscheui.vuf.units[self.__owner.unit]

    if not db then return end

    local phaseindicator = db.phaseindicator

    local scale = phaseindicator.scale
    self:Size(30 * scale)
end

function VUF:PhaseIndicatorOptions(unit)
    return self:GenerateElementOptionsTable(
        unit,
        "phaseindicator",
        1150,
        "Phase Indicator",
        true,
        false,
        false,
        false,
        false
    )
end
