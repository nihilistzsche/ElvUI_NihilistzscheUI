local NUI = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames

local CreateFrame = _G.CreateFrame

function VUF:ConstructRaisedElementParent(frame)
    local RaisedElementParent = CreateFrame("Frame", nil, frame)
    RaisedElementParent.TextureParent = CreateFrame("Frame", nil, frame.RaisedElementParent)
    RaisedElementParent:SetFrameLevel(frame:GetFrameLevel() + 100)
    return RaisedElementParent
end
