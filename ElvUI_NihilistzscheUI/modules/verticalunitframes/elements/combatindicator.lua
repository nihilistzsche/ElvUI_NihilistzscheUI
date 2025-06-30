---@class NUI
local NUI = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructCombatIndicator(frame)
    self:AddElement(frame, "combatindicator")
    local combat = frame:CreateTexture(nil, "OVERLAY")
    combat:Size(13)
    combat:SetVertexColor(0.69, 0.31, 0.31)

    return combat
end

function VUF:CombatIndicatorOptions(unit)
    return self:GenerateElementOptionsTable(
        unit,
        "combatindicator",
        1000,
        "Combat Indicator",
        true,
        false,
        false,
        false,
        false
    )
end
