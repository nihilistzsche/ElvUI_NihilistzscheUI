local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local LSM = E.Libs.LSM

local format = _G.format
local ceil = _G.ceil
local floor = _G.floor
local GetTime = _G.GetTime
local CreateFrame = _G.CreateFrame
local UnitAura = _G.UnitAura
local UnitIsFriend = _G.UnitIsFriend
local DebuffTypeColor = _G.DebuffTypeColor

function VUF:ConstructDebuffs(frame)
    self:AddElement(frame, "debuffs")
    local debuffs = self:CreateFrame(frame, "debuffs")

    debuffs.size = 26
    debuffs.num = 36

    debuffs.spacing = 2
    debuffs.initialAnchor = "TOPRIGHT"
    debuffs["growth-y"] = "UP"
    debuffs["growth-x"] = "LEFT"
    debuffs.PostCreateIcon = self.PostCreateAura
    debuffs.PostUpdateIcon = self.PostUpdateAura
    debuffs.CustomFilter = UF.AuraFilter
    debuffs.type = "debuffs"

    -- an option to show only our debuffs on target
    --[[if unit == "target" then
		debuffs.onlyShowPlayer = C.unitframes.onlyselfdebuffs
	end]]
    return debuffs
end

function VUF:ConstructBuffs(frame)
    self:AddElement(frame, "buffs")
    local buffs = self:CreateFrame(frame, "buffs")

    buffs.size = 26
    buffs.num = 36
    buffs.numRow = 9

    buffs.spacing = 2
    buffs.initialAnchor = "TOPLEFT"
    buffs.PostCreateIcon = self.PostCreateAura
    buffs.PostUpdateIcon = self.PostUpdateAura
    buffs.CustomFilter = UF.AuraFilter
    buffs.type = "buffs"

    return buffs
end

local function FormatTime(s)
    local day, hour, minute = 86400, 3600, 60
    if s >= day then
        return format("%dd", ceil(s / day))
    elseif s >= hour then
        return format("%dh", ceil(s / hour))
    elseif s >= minute then
        return format("%dm", ceil(s / minute))
    elseif s >= minute / 12 then
        return floor(s)
    end
    return format("%.1f", s)
end

-- create a timer on a buff or debuff
local function CreateAuraTimer(self, elapsed)
    if self.timeLeft and tonumber(self.timeLeft) then
        self.timeLeft = tonumber(self.timeLeft)
        self.elapsed = (self.elapsed or 0) + elapsed
        if self.elapsed >= 0.1 then
            if not self.first then
                self.timeLeft = self.timeLeft - self.elapsed
            else
                self.timeLeft = self.timeLeft - GetTime()
                self.first = false
            end
            if self.timeLeft > 0 then
                local time = FormatTime(self.timeLeft)
                self.remaining:SetText(time)
                if self.timeLeft <= 5 then
                    self.remaining:SetTextColor(0.99, 0.31, 0.31)
                else
                    self.remaining:SetTextColor(1, 1, 1)
                end
            else
                self.remaining:Hide()
                self:SetScript("OnUpdate", nil)
            end
            self.elapsed = 0
        end
    end
end

-- luacheck: push no self
-- create a skin for all unitframes buffs/debuffs
function VUF:PostCreateAura(button)
    button:SetTemplate("Transparent")

    button.remaining = button:CreateFontString()
    -- Dummy font
    button.remaining:FontTemplate(LSM:Fetch("font", E.db.general.font), 12, "THINOUTLINE")
    button.remaining:Point("CENTER", 1, 0)

    button.cd.noOCC = true -- hide OmniCC CDs, because we  create our own cd with CreateAuraTimer()
    button.cd.noCooldownCount = true -- hide CDC CDs, because we create our own cd with CreateAuraTimer()

    button.cd:SetReverse()
    button.icon:Point("TOPLEFT", 2, -2)
    button.icon:Point("BOTTOMRIGHT", -2, 2)
    button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    button.icon:SetDrawLayer("ARTWORK")

    button.count:Point("BOTTOMRIGHT", 3, 3)
    button.count:SetJustifyH("RIGHT")
    button.count:SetFont(LSM:Fetch("font", E.db.general.font), 9, "THICKOUTLINE")
    button.count:SetTextColor(0.84, 0.75, 0.65)

    button.overlayFrame = CreateFrame("frame", nil, button, nil)
    button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
    button.cd:ClearAllPoints()
    button.cd:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
    button.cd:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)
    button.overlay:SetParent(button.overlayFrame)
    button.count:SetParent(button.overlayFrame)
    button.remaining:SetParent(button.overlayFrame)

    button.Glow = CreateFrame("Frame", nil, button, "BackdropTemplate")
    button.Glow:Point("TOPLEFT", button, "TOPLEFT", -3, 3)
    button.Glow:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
    button.Glow:SetFrameStrata("BACKGROUND")
    button.Glow:SetBackdrop({
        edgeFile = E.media.blankTex,
        edgeSize = 3,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    button.Glow:SetBackdropColor(0, 0, 0, 0)
    button.Glow:SetBackdropBorderColor(0, 0, 0)

    local Animation = button:CreateAnimationGroup()
    Animation:SetLooping("BOUNCE")

    local FadeOut = Animation:CreateAnimation("Alpha")
    FadeOut:SetFromAlpha(1)
    FadeOut:SetToAlpha(0.1)
    FadeOut:SetDuration(0.6)
    FadeOut:SetSmoothing("IN_OUT")

    button.Animation = Animation
end

-- update cd, border color, etc on buffs / debuffs
function VUF:PostUpdateAura(unit, icon, index, _, _, _, duration)
    local _, _, _, _, dtype, _, expirationTime, _, isStealable = UnitAura(unit, index, icon.filter)
    if icon then
        if icon.filter == "HARMFUL" then
            if not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle" then
                icon.icon:SetDesaturated(true)
                icon:SetBackdropBorderColor(unpack(E.media.bordercolor))
            else
                local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
                icon.icon:SetDesaturated(false)
                icon:SetBackdropBorderColor(color.r * 0.8, color.g * 0.8, color.b * 0.8)
            end
        else
            if
                (
                    isStealable
                    or ((E.myclass == "MAGE" or E.myclass == "PRIEST" or E.myclass == "SHAMAN") and dtype == "Magic")
                ) and not UnitIsFriend("player", unit)
            then
                if not icon.Animation:IsPlaying() then icon.Animation:Play() end
            else
                if icon.Animation:IsPlaying() then icon.Animation:Stop() end
            end
        end

        if duration and tonumber(duration) and tonumber(duration) > 0 then
            icon.remaining:Show()
        else
            icon.remaining:Hide()
        end

        icon.cd:Hide()

        icon.duration = duration
        icon.timeLeft = expirationTime
        icon.first = true
        icon:SetScript("OnUpdate", CreateAuraTimer)
    end
end
-- luacheck: pop

function VUF:BuffOptions(unit)
    return self:GenerateElementOptionsTable(unit, "buffs", 725, "Buffs", true, true, false, false, false)
end

function VUF:DebuffOptions(unit)
    return self:GenerateElementOptionsTable(unit, "debuffs", 750, "Debuffs", true, true, false, false, false)
end
