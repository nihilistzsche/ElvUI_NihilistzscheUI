local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames

-- luacheck: no max line length
function VUF:ConstructCutaway(frame)
    self:AddElement(frame, "cutaway")

    local ch = self:ConfigureTexture(frame, "cutaway", frame.Health.ClipFrame, "health")
    ch:SetTexture(E.media.blankTex)
    ch:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
    local cp = self:ConfigureTexture(frame, "cutaway", frame.Power.ClipFrame, "power")
    cp:SetTexture(E.media.blankTex)
    cp:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)

    return {
        Health = ch,
        Power = cp
    }
end

function VUF:CutawayOptions(unit)
    return self:GenerateElementOptionsTable(
        unit,
        "cutaway",
        1600,
        "Cutaway Health/Power",
        false,
        false,
        false,
        false,
        false
    )
end
