---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames

local CreateFrame = _G.CreateFrame

-- Health for all units
function VUF:ConstructHealth(frame)
    self:AddElement(frame, "health")

    -- Health Bar
    local health = self:ConstructStatusBar(frame, "health")
    health:SetFrameStrata("LOW")
    health:SetOrientation("VERTICAL")
    health:SetFrameLevel(frame:GetFrameLevel() + 5)
    health:SetSize(1, 1)
    health.value = self:ConstructFontString(frame, "health", health)
    health.PostUpdate = VUF.PostUpdateHealth
    health.PostUpdateColor = UF.PostUpdateHealthColor
    health.frequentUpdates = true

    health.bg = health:CreateTexture(nil, "BORDER")
    health.bg:SetAllPoints()
    health.bg:SetTexture(E.media.blankTex)
    health.bg.multiplier = 0.35

    health.colorSmooth = nil
    health.colorHealth = nil
    health.colorClass = nil
    health.colorReaction = nil
    if UF.db.colors.healthclass ~= true then
        if UF.db.colors.colorhealthbyvalue == true then
            health.colorSmooth = true
        else
            health.colorHealth = true
        end
    else
        if frame.unit == "pet" and frame.db.colorPetByUnitClass then
            health.colorPetByUnitClass = true
        else
            health.colorClass = true
        end
        health.colorReaction = true
    end

    local clipFrame = CreateFrame("Frame", nil, health)
    clipFrame:SetScript("OnUpdate", UF.HealthClipFrame_OnUpdate)
    clipFrame:SetClipsChildren(true)
    clipFrame:SetAllPoints()
    clipFrame.__frame = frame
    health.ClipFrame = clipFrame

    return health
end

local warningTextShown = false
function VUF:PostUpdateHealth(unit, min, max)
    -- luacheck: no max line length
    if unit == "vehicle" then unit = "player" end
    if not E.db.nihilistzscheui.vuf.units[unit] then return end
    local parent = self:GetParent()

    if parent.ResurrectIndicator then parent.ResurrectIndicator:SetAlpha(min == 0 and 1 or 0) end

    -- Flash health below threshold %
    if max == 0 then return end
    if (min / max * 100) < E.db.nihilistzscheui.vuf.lowThreshold then
        E:Flash(parent, 0.6)
        if (not warningTextShown and unit == "player") and E.db.nihilistzscheui.vuf.warningText then
            _G.ElvUIVerticalUnitFramesWarning:AddMessage("|cffff0000LOW HEALTH")
            warningTextShown = true
        else
            _G.ElvUIVerticalUnitFramesWarning:Clear()
            warningTextShown = false
        end
        if unit == "player" and E.db.nihilistzscheui.vuf.screenflash then
            _G.ElvUIVerticalUnitFramesScreenFlash:SetAlpha(1)
            E:Flash(_G.ElvUIVerticalUnitFramesScreenFlash, 0.6)
        end
    else
        E:StopFlash(parent)
        E:StopFlash(_G.ElvUIVerticalUnitFramesScreenFlash)
        _G.ElvUIVerticalUnitFramesScreenFlash:SetAlpha(0)
        warningTextShown = false
    end
end

function VUF:HealthOptions(unit)
    return self:GenerateElementOptionsTable(unit, "health", 100, "Health", false, true, true, true, false)
end
