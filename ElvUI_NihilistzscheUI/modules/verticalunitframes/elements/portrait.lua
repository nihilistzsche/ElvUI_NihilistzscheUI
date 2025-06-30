---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local hooksecurefunc = _G.hooksecurefunc

local CreateFrame = _G.CreateFrame

function VUF:ConstructPortrait(frame)
    self:AddElement(frame, "portrait")
    local portrait = CreateFrame("PlayerModel", nil, frame)
    portrait:SetFrameStrata("LOW")

    portrait.PostUpdate = self.PortraitUpdate

    -- https://github.com/Stanzilla/WoWUIBugs/issues/295
    -- since this seems to be forced on models because of a bug
    portrait:SetIgnoreParentAlpha(true) -- lets handle it ourselves
    hooksecurefunc(frame, "SetAlpha", UF.ModelAlphaFix)
    return portrait
end

function VUF:PortraitUpdate(unit, event, shouldUpdate)
    if unit == "vehicle" then unit = "player" end
    local db = E.db.nihilistzscheui.vuf.units[unit]

    if not db then return end

    if shouldUpdate or (event == "ElvUI_UpdateAllElements" and self:IsObjectType("Model")) then
        local portrait = db.portrait

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
