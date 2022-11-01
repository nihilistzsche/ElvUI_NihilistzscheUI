local NUI, E = _G.unpack(select(2, ...))
local CP = NUI.Misc.CardinalPoints

function CP:CreateFrame()
    local frame = _G.CreateFrame("FRAME", "MMD_Frame", _G.Minimap)
    frame:SetAllPoints()

    local n = frame:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
    local e = frame:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
    local s = frame:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
    local w = frame:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")

    n:SetText("N")
    e:SetText("E")
    s:SetText("S")
    w:SetText("W")

    n:SetPoint("CENTER", frame, "TOP")
    e:SetPoint("CENTER", frame, "RIGHT")
    s:SetPoint("CENTER", frame, "BOTTOM")
    w:SetPoint("CENTER", frame, "LEFT")

    self.frame = frame
end

function CP:Update() self.frame:SetShown(E.db.nihilistzscheui.cardinalpoints.enabled) end

function CP:Initialize()
    self:CreateFrame()

    self:Update()
end

NUI:RegisterModule(CP:GetName())
