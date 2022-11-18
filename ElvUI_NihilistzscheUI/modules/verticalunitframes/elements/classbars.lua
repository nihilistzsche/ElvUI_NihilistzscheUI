local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local COMP = NUI.Compatibility

local UnitPower = _G.UnitPower
local UnitPowerMax = _G.UnitPowerMax
local Enum_PowerType_Chi = _G.Enum.PowerType.Chi
local Enum_PowerType_ComboPoints = _G.Enum.PowerType.ComboPoints
local Enum_PowerType_HolyPower = _G.Enum.PowerType.HolyPower
local Enum_PowerType_SoulShards = _G.Enum.PowerType.SoulShards
local Enum_PowerType_Essence = _G.Enum.PowerType.Essence

local GetSpecialization = _G.GetSpecialization
local SPEC_PALADIN_RETRIBUTION = _G.SPEC_PALADIN_RETRIBUTION

function VUF:ConstructStagger(frame)
    self:AddElement(frame, "stagger")

    local staggerBar = self:ConstructStatusBar(frame, "stagger", frame, "staggerbar")
    staggerBar:SetFrameStrata("MEDIUM")
    staggerBar:SetTemplate("Transparent")
    if COMP.MERS then staggerBar:Styling() end
    staggerBar:SetFrameLevel(8)
    staggerBar:SetBackdropBorderColor(0, 0, 0, 0)
    staggerBar.PostUpdateVisibility = VUF.PostUpdateStaggerBar

    return staggerBar
end

function VUF:ConstructSubBars(frame, element, name, num)
    self:AddElement(frame, element)

    local bars = self:CreateFrame(frame, element)
    bars:SetFrameLevel(frame:GetFrameLevel() + 30)
    bars:SetTemplate("Transparent")
    if COMP.MERS then bars:Styling() end
    bars:SetBackdropBorderColor(0, 0, 0, 0)

    if element == "classbars" then
        bars.UpdateTexture = function() return end --We don't use textures but statusbars, so prevent errors
    end

    for i = 1, num do
        bars[i] = self:ConstructStatusBar(frame, element, frame, name .. i)
        bars[i]:SetFrameStrata("MEDIUM")
        bars[i]:SetFrameLevel(frame:GetFrameLevel() + 35)
        bars[i]:SetHeight(math.floor(E.db.nihilistzscheui.vuf.units[frame.unit].health.size.height / num))

        if i == 1 then
            bars[i]:SetPoint("BOTTOM", bars, "BOTTOM", 0, 0)
        else
            bars[i]:SetPoint("BOTTOM", bars[i - 1], "TOP", 0, E:Scale(1))
        end

        bars[i]:SetOrientation("VERTICAL")
    end

    if element == "classbars" then
        bars.value = self:ConstructFontString(frame, element, frame)
        bars.value:Hide()
    end

    return bars
end

-- Warlock spec bars
function VUF:ConstructShardBar(frame)
    local bars = self:ConstructSubBars(frame, "classbars", "shardbar", 5)

    bars._PostUpdate = VUF.PostUpdateSoulShards

    return bars
end

-- Construct holy power for paladins
function VUF:ConstructHolyPower(frame)
    local bars = self:ConstructSubBars(frame, "classbars", "holypower", 5)

    bars._PostUpdate = VUF.PostUpdateHolyPower

    return bars
end

-- Runes for death knights
function VUF:ConstructRunes(frame)
    local bars = self:ConstructSubBars(frame, "classbars", "rune", 6)

    if frame.db then frame.db.classbar = UF.db.units[frame.unit].classbar end

    bars.sortOrder = (frame.db.classbar.sortDirection ~= "NONE") and frame.db.classbar.sortDirection
    bars.colorSpec = true

    return bars
end

-- Construct harmony bar for monks
function VUF:ConstructHarmony(frame) return self:ConstructSubBars(frame, "classbars", "harmony", 6) end

-- Construct arcane bar for mages
function VUF:ConstructArcaneBar(frame)
    local bars = self:ConstructSubBars(frame, "classbars", "arcanecharge", 4)

    bars._PostUpdate = VUF.PostUpdateArcaneChargeBar

    return bars
end

-- Combo points for rogues and druids
function VUF:ConstructComboPoints(frame)
    local bars = self:ConstructSubBars(frame, "classbars", "combopoint", E.myclass == "ROGUE" and 10 or 5)

    bars._PostUpdate = VUF.PostUpdateComboPoints

    return bars
end

-- Essence for evokers
function VUF:ConstructEssence(frame) return self:ConstructSubBars(frame, "classbars", "essence", 6) end


-- This function is only responsible for updating bar sizes for class bar children
-- textures work normally as does parent size
function VUF:UpdateClassBar(frame, element)
    local ElvUF = _G.ElvUF
    local unit = frame.unit
    if unit == "vehicle" then unit = "player" end
    if not self.db.units[unit] then
        self:ScheduleTimer("UpdateClassBar", 1, frame, element)
        return
    end
    local config = self.db.units[unit][element]
    if not config then
        self:ScheduleTimer("UpdateClassBar", 1, frame, element)
        return
    end
    local size = config.size
    local numPoints, maxPoints, curPoints
    local spaced = config.spaced

    if element == "classbars" then
        if E.myclass == "WARLOCK" then
            curPoints = UnitPower("player", Enum_PowerType_SoulShards)
            numPoints = UnitPowerMax("player", Enum_PowerType_SoulShards)
            maxPoints = 5
        end

        if E.myclass == "PALADIN" then
            curPoints = UnitPower("player", Enum_PowerType_HolyPower)
            numPoints = UnitPowerMax("player", Enum_PowerType_HolyPower)
            maxPoints = 5
        end

        if E.myclass == "DEATHKNIGHT" then
            curPoints = 6
            numPoints = 6
            maxPoints = 6
        end

        if E.myclass == "SHAMAN" then
            curPoints = 4
            numPoints = 4
            maxPoints = 4
        end

        if E.myclass == "ROGUE" or E.myclass == "DRUID" then
            curPoints = UnitPower("player", Enum_PowerType_ComboPoints)
            numPoints = UnitPowerMax("player", Enum_PowerType_ComboPoints)
            maxPoints = E.myclass == "ROGUE" and 10 or 5
        end

        if E.myclass == "MONK" then
            curPoints = UnitPower("player", Enum_PowerType_Chi)
            numPoints = UnitPowerMax("player", Enum_PowerType_Chi)
            maxPoints = 6
        end

        if E.myclass == "MAGE" then
            curPoints = 4
            numPoints = 4
            maxPoints = 4
        end

        if E.myclass == "EVOKER" then
            curPoints = UnitPower('player', Enum_PowerType_Essence)
            numPoints = UnitPowerMax('player', Enum_PowerType_Essence)
            maxPoints = 6
        end
    end

    local totalspacing = (config.spacesettings.offset * 2) + (config.spacesettings.spacing * numPoints) - numPoints
    local e = self:GetElement(element)
    if not frame[e] then
        self:ScheduleTimer("UpdateClassBar", 1, frame, element)
        return
    end
    if not frame[e].PostUpdate then
        frame[e].PostUpdate = function(_self, ...) self.PostUpdateClassBar(_self, frame, element, { ... }) end
    end

    if spaced then
        frame[e]:SetAlpha(0)
    else
        frame[e]:SetAlpha(1)
    end
    if not maxPoints then maxPoints = numPoints end
    if not curPoints then curPoints = 0 end
    if numPoints == 0 then return end

    local height = (size.height - (spaced and totalspacing or 2)) / numPoints
    local chargedIndex
    if E.myclass == "ROGUE" then
        local chargedPoints = GetUnitChargedPowerPoints(frame.unit)
        if chargedPoints then chargedIndex = chargedPoints[1] end
    end
    for i = 1, maxPoints do
        frame[e][i]:Size(size.width, height)
        if not frame[e][i].SetAlpha_ then
            frame[e][i].SetAlpha_ = frame[e][i].SetAlpha
            frame[e][i].SetAlpha = function(_self, alpha) _self:SetAlpha_(_self.enabled and alpha or _self.alpha) end
        end
        if
            E.myclass ~= "PALADIN"
            and E.myclass ~= "MAGE"
            and E.myclass ~= "MONK"
            and E.myclass ~= "WARLOCK"
            and E.myclass ~= "DRUID"
            and E.myclass ~= "DEATHKNIGHT"
            and E.myclass ~= "ROGUE"
            and E.myclass ~= "EVOKER"
        then
            frame[e][i]:SetStatusBarColor(unpack(ElvUF.colors[frame.ClassBar]))

            if frame[e][i].bg then frame[e][i].bg:SetTexture(unpack(ElvUF.colors[frame.ClassBar])) end
        else
            if E.myclass == "MONK" then
                frame[e][i]:SetStatusBarColor(unpack(ElvUF.colors.ClassBars[E.myclass][i]))
            elseif E.myclass == "PALADIN" or E.myclass == "MAGE" or E.myclass == "WARLOCK" then
                frame[e][i]:SetStatusBarColor(unpack(ElvUF.colors.ClassBars[E.myclass]))
            elseif E.myclass == "ROGUE" or E.myclass == "DRUID" then
                local r1, g1, b1 = unpack(ElvUF.colors.ComboPoints[1])
                local r2, g2, b2 = unpack(ElvUF.colors.ComboPoints[2])
                local r3, g3, b3 = unpack(ElvUF.colors.ComboPoints[3])
                local r, g, b = ElvUF.ColorGradient(i, maxPoints > 5 and 6 or 5, r1, g1, b1, r2, g2, b2, r3, g3, b3)
                if E.myclass == "ROGUE" and chargedIndex and chargedIndex == i then
                    r, g, b = unpack(ElvUF.colors.chargedComboPoint)
                end
            elseif E.myclass == "EVOKER" then
                frame[e][i]:SetStatusBarColor(unpack(ElvUF.colors.ClassBars[E.myclass][i]))
            elseif E.myclass ~= "DEATHKNIGHT" then
                frame[e][i]:SetStatusBarColor(unpack(ElvUF.colors[frame.ClassBar]))
            end
        end
        if config.enabled and i <= numPoints then
            frame[e][i].enabled = true
            frame[e][i].alpha = 1
            frame[e][i]:SetAlpha(i <= curPoints and 1 or 0.2)
            if spaced then
                frame[e][i]:SetAlpha(i <= curPoints and 1 or 0.2)
                if frame[e][i].backdrop then frame[e][i].backdrop:Show() end
            else
                if frame[e][i].backdrop then frame[e][i].backdrop:Hide() end
            end
        else
            frame[e][i].enabled = false
            if frame[e][i].backdrop then frame[e][i].backdrop:Hide() end
            frame[e][i].alpha = 0
            frame[e][i]:SetAlpha(0)
        end
    end
end

function VUF:UpdateClassBarAnchors(frame, element)
    local config = self.db.units[frame.unit][element]
    if not config then
        VUF:ScheduleTimer("UpdateClassBar", 1, frame, element)
        return
    end

    local spaced = config.spaced
    local spacing = config.spacesettings.spacing
    if not spaced then spacing = 1 end

    if element == "classbars" then
        local classIcons = frame.ClassBar
        for i, icon in ipairs(classIcons) do
            icon:ClearAllPoints()
            if i == 1 then
                icon:Point("BOTTOM", classIcons)
            else
                icon:Point("BOTTOM", classIcons[i - 1], "TOP", 0, spacing)
            end
        end
    end
end

function VUF:PostUpdateClassBar(frame, element, args)
    local unit = frame.unit
    local e = VUF:GetElement(element)
    if unit == "vehicle" and element == "classbars" then
        frame:DisableElement(e)
        return
    else
        frame:EnableElement(e)
    end
    local config = VUF.db.units[unit][element]
    if config and config.enabled then
        VUF:UpdateClassBar(frame, element)
        if self._PostUpdate then self:_PostUpdate(unpack(args)) end
    else
        self:Hide()
    end
end

function VUF:PostUpdateStaggerBar(_, _, isShown)
    if isShown then
        self:Show()
    else
        self:Hide()
    end
end

function VUF:PostUpdateArcaneChargeBar()
    local talentSpecialization = GetSpecialization()

    local alpha
    if talentSpecialization ~= 1 then
        alpha = 0
    else
        alpha = 1
    end
    for i = 1, 4 do
        self[i]:SetAlpha(alpha)
    end
end

function VUF:PostUpdateWildMushrooms()
    local spec = GetSpecialization()

    local alpha
    if spec == 1 or spec == 4 then
        alpha = 1
    else
        alpha = 0
    end

    for i = 1, 3 do
        self[i]:SetAlpha(alpha)
    end
end

function VUF:PostUpdateHolyPower()
    local unit = "player"

    local spec = GetSpecialization()

    local enabled
    local curPoints

    if spec == SPEC_PALADIN_RETRIBUTION then
        enabled = true
        curPoints = UnitPower(unit, Enum_PowerType_HolyPower)
    else
        enabled = false
    end

    for i = 1, 5 do
        local alpha = enabled and (i <= curPoints and 1 or 0.2) or 0
        self[i]:SetAlpha(alpha)
        self[i]:SetShown(enabled)
    end
end

function VUF:PostUpdateSoulShards()
    local unit = "player"

    local num = UnitPower(unit, Enum_PowerType_SoulShards)

    for i = 1, 5 do
        if i <= num then
            self[i]:Show()
            self[i]:SetAlpha(1)
        else
            self[i]:Show()
            self[i]:SetAlpha(0.2)
        end
    end
end

function VUF:PostUpdateComboPoints()
    local cp = UnitPower("player", Enum_PowerType_ComboPoints)
    local max = UnitPowerMax("player", Enum_PowerType_ComboPoints)

    local enabled

    if E.myclass == "ROGUE" or (E.myclass == "DRUID" and GetSpecialization() == 2) then
        enabled = true
    else
        enabled = false
    end

    for i = 1, max do
        if enabled then
            if i <= cp then
                self[i]:Show()
                self[i]:SetAlpha(1)
            else
                self[i]:Show()
                self[i]:SetAlpha(0.15)
            end
        else
            self[i]:Hide()
        end
    end
end

function VUF:ClassBarOptions(unit)
    return self:GenerateElementOptionsTable(unit, "classbars", 500, "Class Bars", true, true, true, true, true)
end

function VUF:StaggerOptions(unit)
    return self:GenerateElementOptionsTable(unit, "stagger", 650, "Stagger Bar", true, true, false, false, true)
end
