local NUI = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructPvPText(frame)
    self:AddElement(frame, "pvptext")
    local pvp = self:ConstructFontString(frame, "pvptext")
    pvp:SetTextColor(0.69, 0.31, 0.31)

    return pvp
end

function VUF:PvPTextOptions(unit)
    return self:GenerateElementOptionsTable(unit, "pvptext", 1100, "PVP Text", true, false, false, true, false)
end
