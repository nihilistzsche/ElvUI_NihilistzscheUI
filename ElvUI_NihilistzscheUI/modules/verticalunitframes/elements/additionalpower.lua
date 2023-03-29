local NUI = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames

-- Power for units it is enabled on
function VUF:ConstructAdditionalPower(frame)
    self:AddElement(frame, "additionalpower")

    local power = self:ConstructStatusBar(frame, "additionalpower")
    power:SetOrientation("VERTICAL")
    power:SetFrameLevel(frame:GetFrameLevel() + 20)

    power.value = self:ConstructFontString(frame, "additionalpower", power)

    -- Update the Power bar Frequently
    power.frequentUpdates = true

    power.colorTapping = true
    power.colorPower = true
    power.colorReaction = true
    power.colorDisconnected = true

    return power
end

function VUF:AdditionalPowerOptions(unit)
    return self:GenerateElementOptionsTable(unit, "additionalpower", 600, "Alt Mana", true, true, true, true, true)
end
