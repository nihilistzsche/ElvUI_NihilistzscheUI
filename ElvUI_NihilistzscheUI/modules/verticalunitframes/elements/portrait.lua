local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames

local CreateFrame = _G.CreateFrame

function VUF:ConstructPortrait(frame)
    self:AddElement(frame, "portrait")
    local portrait = CreateFrame("PlayerModel", nil, frame)
    portrait:SetFrameStrata("LOW")

    portrait.PostUpdate = self.PortraitUpdate

    return portrait
end

function VUF:PortraitUpdate(unit, event, shouldUpdate)
    if unit == "vehicle" then unit = "player" end
    local db = E.db.nihilistzscheui.vuf.units[unit]

    if not db then return end

    local portrait = db.portrait
    if portrait.enabled then
        self:SetAlpha(0)
        self:SetAlpha(0.35)
    end

    if shouldUpdate or (event == "ElvUI_UpdateAllElements" and self:IsObjectType("Model")) then
        local rotation = portrait.rotation or 0
        local camDistanceScale = portrait.camDistanceScale or 1
        local xOffset, yOffset = (portrait.xOffset or 0), (portrait.yOffset or 0)

        if self:GetFacing() ~= (rotation / 60) then self:SetFacing(rotation / 60) end

        self:SetCamDistanceScale(camDistanceScale)
        self:SetPosition(0, xOffset, yOffset)

        --Refresh model to fix incorrect display issues
        self:ClearModel()
        self:SetUnit(unit)
    end
end

function VUF:PortraitOptions(unit)
    return self:GenerateElementOptionsTable(unit, "portrait", 850, "Portrait", false, false, false, false, false)
end
