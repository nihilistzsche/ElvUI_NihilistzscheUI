local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local BS = NUI.ButtonStyle

local CreateFrame = _G.CreateFrame
local InCombatLockdown = _G.InCombatLockdown
local abs = _G.abs
local GetNetStats = _G.GetNetStats
local GetSpellInfo = _G.GetSpellInfo
local strsub = _G.strsub
local floor = _G.floor
local UnitSpellHaste = _G.UnitSpellHaste
local UnitIsPlayer = _G.UnitIsPlayer
local UnitClass = _G.UnitClass
local UnitReaction = _G.UnitReaction
local UnitCanAttack = _G.UnitCanAttack
local AuraUtil_FindAuraByName = _G.AuraUtil_FindAuraByName

-- Castbar for units it is enabled on
-- For player/target castbar can be (and defaults) to horizontal mode.
-- For pet/targettarget/pettarget castbar is always vertical overlaid on the power bar.
-- Note in this version the castbar is no longer anchored to the power bar, so each
-- element can be disabled independently
function VUF:ConstructCastbar(frame)
    self:AddElement(frame, "hcastbar")
    self:AddElement(frame, "vcastbar")
    self:AddElement(frame, "castbar")
    local hcastbar = self:ConstructStatusBar(frame, "hcastbar")
    local vcastbar = self:ConstructStatusBar(frame, "vcastbar")

    vcastbar.CustomDelayText = VUF.CustomCastDelayText
    vcastbar.CustomTimeText = VUF.CustomTimeText
    vcastbar.PostCastStart = VUF.PostCastStart
    vcastbar.PostChannelStart = VUF.PostCastStart
    vcastbar.PostCastStop = VUF.PostCastStop
    vcastbar.PostChannelStop = VUF.PostCastStop
    vcastbar.PostChannelUpdate = VUF.PostChannelUpdate
    vcastbar.PostCastInterruptible = UF.PostCastInterruptible
    vcastbar.PostCastNotInterruptible = UF.PostCastNotInterruptible
    vcastbar.OnUpdate = VUF.CastbarUpdate
    vcastbar.UpdatePipStep = UF.UpdatePipStep
    vcastbar.PostUpdatePip = UF.PostUpdatePip
    vcastbar.CreatePip = UF.CreatePip

    vcastbar:SetOrientation("VERTICAL")
    vcastbar:SetFrameStrata(frame.Power:GetFrameStrata())
    vcastbar:SetFrameLevel(frame.Power:GetFrameLevel() + 2)

    vcastbar.Time = self:ConstructFontString(frame, "vcastbar", vcastbar, "time")
    vcastbar.Time:Point("BOTTOM", vcastbar, "TOP", 0, 4)
    vcastbar.Time:SetTextColor(0.84, 0.75, 0.65)
    vcastbar.Time:SetJustifyH("RIGHT")

    vcastbar.Text = self:ConstructFontString(frame, "vcastbar", vcastbar, "text")
    vcastbar.Text:SetPoint("TOP", vcastbar, "BOTTOM", 0, -4)
    vcastbar.Text:SetTextColor(0.84, 0.75, 0.65)

    vcastbar.Spark = vcastbar:CreateTexture(nil, "OVERLAY")
    vcastbar.Spark:Height(12)
    vcastbar.Spark:SetBlendMode("ADD")
    vcastbar.Spark:SetVertexColor(1, 1, 1)

    --Set to vcastbar.SafeZone
    vcastbar.LatencyTexture = self:ConfigureTexture(frame, "vcastbar", vcastbar, "latency")
    vcastbar.LatencyTexture:SetVertexColor(0.69, 0.31, 0.31, 0.75)
    vcastbar.SafeZone = vcastbar.LatencyTexture

    local button = CreateFrame("Frame", nil, vcastbar, "BackdropTemplate")
    button:SetTemplate("Default")

    button:Point("BOTTOM", vcastbar, "BOTTOM", 0, 0)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:Point("TOPLEFT", button, 2, -2)
    icon:Point("BOTTOMRIGHT", button, -2, 2)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    icon.bg = button

    --Set to castbar.Icon
    vcastbar.ButtonIcon = icon
    frame.VertCastbar = vcastbar

    hcastbar:SetOrientation("HORIZONTAL")
    hcastbar:SetFrameLevel(6)
    hcastbar:SetRotatesTexture(false)

    hcastbar.CustomTimeText = VUF.CustomCastTimeText
    hcastbar.CustomDelayText = VUF.CustomCastDelayText
    hcastbar.CustomDelayText = VUF.CustomCastDelayText
    hcastbar.CustomTimeText = VUF.CustomTimeText
    hcastbar.PostCastStart = VUF.PostCastStart
    hcastbar.PostChannelStart = VUF.PostCastStart
    hcastbar.PostCastStop = VUF.PostCastStop
    hcastbar.PostChannelStop = VUF.PostCastStop
    hcastbar.PostChannelUpdate = VUF.PostChannelUpdate
    hcastbar.PostCastInterruptible = UF.PostCastInterruptible
    hcastbar.PostCastNotInterruptible = UF.PostCastNotInterruptible
    hcastbar.UpdatePipStep = UF.UpdatePipStep
    hcastbar.PostUpdatePip = UF.PostUpdatePip
    hcastbar.CreatePip = UF.CreatePip

    hcastbar.Time = self:ConstructFontString(frame, "hcastbar", hcastbar, "time")
    --hcastbar.Time:SetPoint("BOTTOMRIGHT", hcastbar, "TOPRIGHT", -4, -2)
    hcastbar.Time:SetTextColor(0.84, 0.75, 0.65)
    hcastbar.Time:SetJustifyH("RIGHT")

    hcastbar.button = CreateFrame("Frame", nil, hcastbar, "BackdropTemplate")
    hcastbar.button:Size(26)
    hcastbar.button:SetTemplate("Default")
    hcastbar.button:SetFrameLevel(hcastbar:GetFrameLevel() + 2)
    if BS then BS:StyleButton(hcastbar.button) end

    hcastbar.Spark = hcastbar:CreateTexture(nil, "OVERLAY")
    hcastbar.Spark:SetBlendMode("ADD")
    hcastbar.Spark:SetVertexColor(1, 1, 1)
    hcastbar.Spark:Width(12)

    hcastbar.Text = self:ConstructFontString(frame, "hcastbar", hcastbar, "text")
    hcastbar.Text:SetTextColor(0.84, 0.75, 0.65)
    --hcastbar.Text:SetPoint("LEFT", hcastbar.button, "RIGHT", 4, 6)

    hcastbar.Icon = hcastbar.button:CreateTexture(nil, "ARTWORK")
    hcastbar.Icon:Point("TOPLEFT", hcastbar.button, 2, -2)
    hcastbar.Icon:Point("BOTTOMRIGHT", hcastbar.button, -2, 2)
    hcastbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    hcastbar.button:SetPoint("BOTTOMLEFT", hcastbar, "BOTTOMLEFT")

    --Set to castbar.SafeZone
    hcastbar.LatencyTexture = self:ConfigureTexture(frame, "hcastbar", hcastbar, "latency")
    hcastbar.LatencyTexture:SetVertexColor(0.69, 0.31, 0.31, 0.75)
    hcastbar.SafeZone = hcastbar.LatencyTexture
    frame.HorizCastbar = hcastbar

    if frame.unit == "player" then
        hcastbar:HookScript("OnShow", function()
            if E.db.nihilistzscheui.vuf.hideOOC and not InCombatLockdown() then
                frame.casting = true
                VUF:UpdateHiddenStatus(frame, "PLAYER_REGEN_DISABLED")
            end
        end)
        hcastbar:HookScript("OnHide", function()
            if E.db.nihilistzscheui.vuf.hideOOC and not InCombatLockdown() then
                frame.casting = false
                VUF:UpdateHiddenStatus(frame, "PLAYER_REGEN_ENABLED")
            end
        end)
        vcastbar:HookScript("OnShow", function()
            if E.db.nihilistzscheui.vuf.hideOOC and not InCombatLockdown() then
                frame.casting = true
                VUF:UpdateHiddenStatus(frame, "PLAYER_REGEN_DISABLED")
            end
        end)
        vcastbar:HookScript("OnHide", function()
            if E.db.nihilistzscheui.vuf.hideOOC and not InCombatLockdown() then
                frame.casting = false
                VUF:UpdateHiddenStatus(frame, "PLAYER_REGEN_ENABLED")
            end
        end)
    end

    if (frame.unit ~= "player" and frame.unit ~= "target") or not self.db.units[frame.unit].horizCastbar then
        return vcastbar
    else
        return hcastbar
    end
end

function VUF:CustomCastDelayText(duration)
    local db = VUF.db.units[self:GetParent().unit]
    if not db then return end

    if self.channeling then
        if db.castbar.format == "CURRENT" then
            self.Time:SetText(("%.1f |cffaf5050%.1f|r"):format(abs(duration - self.max), self.delay))
        elseif db.castbar.format == "CURRENTMAX" then
            self.Time:SetText(("%.1f / %.1f |cffaf5050%.1f|r"):format(duration, self.max, self.delay))
        elseif db.castbar.format == "REMAINING" then
            self.Time:SetText(("%.1f |cffaf5050%.1f|r"):format(duration, self.delay))
        end
    else
        if db.castbar.format == "CURRENT" then
            self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(duration, "+", self.delay))
        elseif db.castbar.format == "CURRENTMAX" then
            self.Time:SetText(("%.1f / %.1f |cffaf5050%s %.1f|r"):format(duration, self.max, "+", self.delay))
        elseif db.castbar.format == "REMAINING" then
            self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(abs(duration - self.max), "+", self.delay))
        end
    end
end

function UF:CustomTimeText(duration)
    local db = VUF.db.units[self:GetParent().unit]
    if not db then return end

    if self.channeling then
        if db.castbar.format == "CURRENT" then
            self.Time:SetText(("%.1f"):format(abs(duration - self.max)))
        elseif db.castbar.format == "CURRENTMAX" then
            self.Time:SetText(("%.1f / %.1f"):format(duration, self.max))
            self.Time:SetText(("%.1f / %.1f"):format(abs(duration - self.max), self.max))
        elseif db.castbar.format == "REMAINING" then
            self.Time:SetText(("%.1f"):format(duration))
        end
    else
        if db.castbar.format == "CURRENT" then
            self.Time:SetText(("%.1f"):format(duration))
        elseif db.castbar.format == "CURRENTMAX" then
            self.Time:SetText(("%.1f / %.1f"):format(duration, self.max))
        elseif db.castbar.format == "REMAINING" then
            self.Time:SetText(("%.1f"):format(abs(duration - self.max)))
        end
    end
end

local updateSafeZone = function(self, c)
    local sz = self.SafeZone
    local height = self:GetHeight()
    local _, _, _, ms = GetNetStats()

    sz:ClearAllPoints()
    if c then
        sz:SetPoint("TOP")
    else
        sz:SetPoint("BOTTOM")
    end
    sz:SetPoint("LEFT")
    sz:SetPoint("RIGHT")

    -- Guard against GetNetStats returning latencies of 0.
    if ms ~= 0 then
        -- MADNESS!
        local safeZonePercent = (height / self.max) * (ms / 1e5)
        if safeZonePercent > 1 then safeZonePercent = 1 end
        sz:SetHeight(height * safeZonePercent)
        sz:Show()
    else
        sz:Hide()
    end
end

local hticks = {}
local vticks = {}
function VUF.HideTicks()
    for i = 1, #hticks do
        hticks[i]:Hide()
    end
    for i = 1, #vticks do
        vticks[i]:Hide()
    end
end

function VUF:SetCastTicks(frame, numTicks, extraTickRatio)
    extraTickRatio = extraTickRatio or 0
    self.HideTicks()
    if numTicks and numTicks <= 0 then return end
    local w = frame:GetOrientation() == "HORIZONTAL" and frame:GetWidth() or frame:GetHeight()
    local d = w / (numTicks + extraTickRatio)
    local color = VUF.db.units[frame:GetParent().unit].castbar.tickcolor
    local ticks = frame:GetOrientation() == "HORIZONTAL" and hticks or vticks
    local _, _, _, ms = GetNetStats()
    for i = 1, numTicks do
        if not ticks[i] then
            ticks[i] = frame:CreateTexture(nil, "OVERLAY")
            ticks[i]:SetTexture(E.media.normTex)
            ticks[i]:SetVertexColor(color.r, color.g, color.b, 0.8)
            if frame:GetOrientation() == "HORIZONTAL" then
                ticks[i]:Width(1)
                ticks[i]:SetHeight(frame:GetHeight() / 2)
            else
                ticks[i]:Height(1)
                ticks[i]:SetWidth(frame:GetWidth() / 2)
            end
        end

        if ms ~= 0 then
            local perc = (w / frame.max) * (ms / 1e5)
            if perc > 1 then perc = 1 end

            ticks[i]:SetWidth((w * perc) / (numTicks + extraTickRatio))
        else
            ticks[i]:Width(1)
        end
        ticks[i]:ClearAllPoints()
        if frame:GetOrientation() == "HORIZONTAL" then
            ticks[i]:SetPoint("TOPRIGHT", frame, "TOPLEFT", d * i, 0)
        else
            ticks[i]:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, d * i)
        end
        ticks[i]:Show()
    end
end

VUF.HarshDisciplineID = 373183

function VUF:PostCastStart(unit)
    if E.myclass == "PRIEST" and not VUF.HarshDisciplineName then
        VUF.HarshDisciplineName = GetSpellInfo(VUF.HarshDisciplineID)
    end
    local db = VUF.db.units[unit]
    if not db or not db.castbar then return end

    if unit == "vehicle" then unit = "player" end

    local name = GetSpellInfo(self.spellID)
    if db.castbar.displayTarget and self.curTarget then
        self.Text:SetText(
            strsub(
                name .. " --> " .. self.curTarget,
                0,
                floor((((32 / 245) * self:GetWidth()) / E.db.unitframe.fontSize) * 12)
            )
        )
    else
        self.Text:SetText(strsub(name, 0, floor((((32 / 245) * self:GetWidth()) / E.db.unitframe.fontSize) * 12)))
    end

    if self:GetOrientation() == "HORIZONTAL" then
        self.Spark:Height(self:GetHeight() * 2)
    else
        self.Spark:Width(self:GetWidth() * 2)
    end

    self.unit = unit
    VUF.units[unit].isCasting = true

    if db.castbar.ticks and unit == "player" then
        local unitframe = E.global.unitframe
        local baseTicks = unitframe.ChannelTicks[name]

        -- Detect channeling spell and if it's the same as the previously channeled one
        if baseTicks and name == self.prevSpellCast then
            self.chainChannel = true
        elseif baseTicks then
            self.chainChannel = nil
            self.prevSpellCast = name
        end

        if baseTicks and unitframe.ChannelTicksSize[name] and unitframe.HastedChannelTicks[name] then
            local tickIncRate = 1 / baseTicks
            local curHaste = UnitSpellHaste("player") * 0.01
            local firstTickInc = tickIncRate / 2
            local bonusTicks = 0
            if curHaste >= firstTickInc then bonusTicks = bonusTicks + 1 end
            local x = tonumber(E:Round(firstTickInc + tickIncRate, 2))
            while curHaste >= x do
                x = tonumber(E:Round(firstTickInc + (tickIncRate * bonusTicks), 2))
                if curHaste >= x then bonusTicks = bonusTicks + 1 end
            end

            local baseTickSize = unitframe.ChannelTicksSize[name]
            local hastedTickSize = baseTickSize / (1 + curHaste)
            local extraTick = self.max - hastedTickSize * (baseTicks + bonusTicks)
            local extraTickRatio = extraTick / hastedTickSize

            VUF:SetCastTicks(self, baseTicks + bonusTicks, extraTickRatio)
        elseif baseTicks and unitframe.ChannelTicksSize[name] then
            local curHaste = UnitSpellHaste("player") * 0.01
            local baseTickSize = unitframe.ChannelTicksSize[name]
            local hastedTickSize = baseTickSize / (1 + curHaste)
            local extraTick = self.max - hastedTickSize * baseTicks
            local extraTickRatio = extraTick / hastedTickSize

            VUF:SetCastTicks(self, baseTicks, extraTickRatio)
        elseif baseTicks then
            VUF:SetCastTicks(self, baseTicks)
        else
            VUF.HideTicks()
        end
    elseif unit == "player" then
        VUF.HideTicks()
    end

    local colors = _G.ElvUF.colors
    local r, g, b = colors.castColor[1], colors.castColor[2], colors.castColor[3]
    if UF.db.colors.castClassColor then
        local t
        if UnitIsPlayer(unit) then
            local _, class = UnitClass(unit)
            t = _G.ElvUF.colors.class[class]
        elseif UnitReaction(unit, "player") then
            t = _G.ElvUF.colors.reaction[UnitReaction(unit, "player")]
        end

        if t then
            r, g, b = t[1], t[2], t[3]
        end
    end

    if self.interrupt and unit ~= "player" and UnitCanAttack("player", unit) then
        r, g, b = colors.castNoInterrupt[1], colors.castNoInterrupt[2], colors.castNoInterrupt[3]
    end

    self:SetStatusBarColor(r, g, b)
    UF:ToggleTransparentStatusBar(UF.db.colors.transparentCastbar, self, self.bg, nil, true)
    if self.bg:IsShown() then
        self.bg:SetTexture(r * 0.25, g * 0.25, b * 0.25)

        if self.backdrop then
            local _, _, _, alpha = self.backdrop:GetBackdropColor()
            self.backdrop:SetBackdropColor(r * 0.58, g * 0.58, b * 0.58, alpha)
        end
    end

    if self:GetOrientation() == "VERTICAL" then
        local sz = self.SafeZone
        if sz then updateSafeZone(self, true) end
    end
end

function VUF:PostCastStop(unit)
    UF.PostCastStop(self, unit)
    local f = VUF.units[unit]
    if f then
        f.isCasting = nil
        VUF:UpdateHiddenStatus(f)
    end
end

function VUF:PostChannelUpdate(unit, name)
    local db = VUF.db.units[unit]
    if not db then return end
    if not (unit == "player" or unit == "vehicle") then return end

    if db.castbar.ticks then
        local unitframe = E.global.unitframe
        local baseTicks = unitframe.ChannelTicks[name]

        if baseTicks and unitframe.ChannelTicksSize[name] and unitframe.HastedChannelTicks[name] then
            local tickIncRate = 1 / baseTicks
            local curHaste = UnitSpellHaste("player") * 0.01
            local firstTickInc = tickIncRate / 2
            local bonusTicks = 0
            if curHaste >= firstTickInc then bonusTicks = bonusTicks + 1 end

            local x = tonumber(E:Round(firstTickInc + tickIncRate, 2))
            while curHaste >= x do
                x = tonumber(E:Round(firstTickInc + (tickIncRate * bonusTicks), 2))
                if curHaste >= x then bonusTicks = bonusTicks + 1 end
            end

            local baseTickSize = unitframe.ChannelTicksSize[name]
            local hastedTickSize = baseTickSize / (1 + curHaste)
            local extraTick = self.max - hastedTickSize * (baseTicks + bonusTicks)
            if self.chainChannel then
                self.extraTickRatio = extraTick / hastedTickSize
                self.chainChannel = nil
            end

            VUF:SetCastTicks(self, baseTicks + bonusTicks, self.extraTickRatio)
        elseif baseTicks and unitframe.ChannelTicksSize[name] then
            local curHaste = UnitSpellHaste("player") * 0.01
            local baseTickSize = unitframe.ChannelTicksSize[name]
            local hastedTickSize = baseTickSize / (1 + curHaste)
            local extraTick = self.max - hastedTickSize * baseTicks
            if self.chainChannel then
                self.extraTickRatio = extraTick / hastedTickSize
                self.chainChannel = nil
            end

            VUF:SetCastTicks(self, baseTicks, self.extraTickRatio)
        elseif baseTicks then
            VUF:SetCastTicks(self, baseTicks)
        else
            VUF.HideTicks()
        end
    else
        VUF.HideTicks()
    end

    if self:GetOrientation() == "VERTICAL" then
        local sz = self.SafeZone
        if sz then updateSafeZone(self, false) end
    end
end

function VUF:CastbarUpdate(elapsed)
    if self.casting then
        local duration = self.duration + elapsed
        if duration >= self.max then
            self.casting = nil
            self:Hide()

            if self.PostCastStop then self:PostCastStop(self.__owner.unit) end
            return
        end

        if self.Time then
            if self.delay ~= 0 then
                if self.CustomDelayText then
                    self:CustomDelayText(duration)
                else
                    self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", duration, self.delay)
                end
            else
                if self.CustomTimeText then
                    self:CustomTimeText(duration)
                else
                    self.Time:SetFormattedText("%.1f", duration)
                end
            end
        end

        self.duration = duration
        self:SetValue(duration)

        if self.Spark then
            self.Spark:SetPoint("CENTER", self, "BOTTOM", 0, (duration / self.max) * self:GetHeight())
        end
    elseif self.channeling then
        local duration = self.duration - elapsed

        if duration <= 0 then
            self.channeling = nil
            self:Hide()

            if self.PostChannelStop then self:PostChannelStop(self.__owner.unit) end
            return
        end

        if self.Time then
            if self.delay ~= 0 then
                if self.CustomDelayText then
                    self:CustomDelayText(duration)
                else
                    self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", duration, self.delay)
                end
            else
                if self.CustomTimeText then
                    self:CustomTimeText(duration)
                else
                    self.Time:SetFormattedText("%.1f", duration)
                end
            end
        end

        self.duration = duration
        self:SetValue(duration)
        if self.Spark then
            self.Spark:SetPoint("CENTER", self, "BOTTOM", 0, (duration / self.max) * self:GetHeight())
        end
    else
        self.unitName = nil
        self.casting = nil
        self.castid = nil
        self.channeling = nil

        self:SetValue(1)
        self:Hide()
    end
end

function VUF:GetCastbar(frame)
    local hc = self.units[frame.unit].elements.hcastbar
    local vc = self.units[frame.unit].elements.vcastbar
    frame:DisableElement("Castbar")
    if (frame.unit ~= "player" and frame.unit ~= "target") or not self.db.units[frame.unit].horizCastbar then
        self.units[frame.unit].elements.castbar = vc
        frame.Castbar = frame.VertCastbar
    else
        self.units[frame.unit].elements.castbar = hc
        frame.Castbar = frame.HorizCastbar
    end
    frame:EnableElement("Castbar")
    if frame.Castbar.ForceUpdate then frame.Castbar:ForceUpdate() end
end

function VUF:CastbarOptions(unit)
    return self:GenerateElementOptionsTable(
        unit,
        "castbar",
        300,
        "Castbar",
        true,
        true,
        false,
        false,
        false,
        unit == "player"
    )
end
