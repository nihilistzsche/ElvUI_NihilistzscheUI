---@class NUI
local NUI = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructRestingIndicator(frame)
    self:AddElement(frame, "restingindicator")
    local resting = frame:CreateTexture(nil, "OVERLAY")
    resting:Size(16)

    return resting
end

function VUF:RestingIndicatorOptions(unit)
    return self:GenerateElementOptionsTable(
        unit,
        "restingindicator",
        900,
        "Rest Icon",
        true,
        false,
        false,
        false,
        false
    )
end
