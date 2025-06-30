---@class NUI
local NUI = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames

-- Name element
function VUF:ConstructName(frame)
    self:AddElement(frame, "name")
    local name = self:ConstructFontString(frame, "name")
    return name
end

function VUF:NameOptions(unit)
    return self:GenerateElementOptionsTable(unit, "name", 400, "Name", true, false, false, true, false)
end
