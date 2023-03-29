local NUI, E = _G.unpack((select(2, ...)))

if not E.Retail then return end

local LSM = E.Libs.LSM
local ES = NUI.EnhancedShadows
local ADB = NUI.AnimatedDataBars
local HAT = NUI.HiddenArtifactTracker
local COMP = NUI.Compatibility

local CreateFrame = _G.CreateFrame
local GetAchievementInfo = _G.GetAchievementInfo
local GetAchievementCriteriaInfo = _G.GetAchievementCriteriaInfo
local GameTooltip = _G.GameTooltip
local tinsert = _G.tinsert
local tremove = _G.tremove

function HAT.CreateHolder()
    local holder = CreateFrame("Frame", nil, E.UIParent)
    holder:SetSize(410, 10)
    holder:Show()
    holder:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 180)
    E:CreateMover(
        holder,
        "ArtifactHiddenAppearanceTrackerMover",
        "Artifact Hidden Appearance Tracker",
        nil,
        nil,
        nil,
        "ALL,SOLO,NIHILISTZSCHEUI"
    )
    E.FrameLocks[holder] = true
    return holder
end

function HAT:CreateStatusBar(holder, info, ...)
    local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(info.achievementID)
    if completed and wasEarnedByMe then return end

    local frame = CreateFrame("Frame", nil, holder, "BackdropTemplate")
    frame:SetTemplate("Transparent")
    if COMP.MERS then frame:Styling() end
    frame:SetSize(self.db.width, self.db.height)
    if ES then
        frame:CreateShadow()
        ES:RegisterFrameShadows(frame)
    end

    local bar = CreateFrame("StatusBar", nil, frame)
    bar:SetStatusBarTexture(E.media.normTex)
    E:RegisterStatusBar(bar)
    bar:SetInside()

    bar.info = info
    frame:SetPoint(...)

    bar.textFrame = CreateFrame("Frame", nil, bar)
    bar.textFrame:SetAllPoints()
    bar.textFrame:SetFrameLevel(bar:GetFrameLevel() + 5)
    bar.textFrame:Show()
    bar.text = bar.textFrame:CreateFontString()
    bar.text:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontFlags)
    bar.text:SetPoint("CENTER", bar, "CENTER", 0, 0)
    bar.text:SetJustifyH("CENTER")
    bar.text:SetJustifyV("MIDDLE")

    bar:SetScript("OnEnter", function(_self) HAT:Bar_OnEnter(_self) end)
    bar:SetScript("OnLeave", function(_self) HAT:Bar_OnLeave(_self) end)

    ADB:CreateTicks(bar)

    return bar
end

function HAT:Bar_OnEnter(bar)
    if self.db.mouseoverText then E:UIFrameFadeIn(bar.text, 0.2, 0, 1) end
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(bar, "ANCHOR_CURSOR", 0, -4)

    local info = bar.info

    local count = 0
    for i = 1, info.criteriaCount do
        local n = select(4, GetAchievementCriteriaInfo(info.achievementID, i))
        count = count + n
    end

    GameTooltip:AddLine(info.label)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("Count: ", count)
    GameTooltip:AddDoubleLine("Needed: ", info.needed)
    GameTooltip:AddDoubleLine("Remaining: ", info.needed - count)
    GameTooltip:Show()
end

function HAT:Bar_OnLeave(bar)
    GameTooltip:Hide()
    if self.db.mouseoverText then E:UIFrameFadeOut(bar.text, 0.2, 1, 0) end
end

function HAT.CheckAchievementProgress()
    local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(10460)
    if not completed or not wasEarnedByMe then return false end
    return true
end

function HAT:UpdateAll()
    local width = self.db.width
    local height = self.db.height

    for _, bar in ipairs(self.bars) do
        bar:SetSize(width, height)
        bar.text:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
        bar:SetStatusBarColor(unpack(bar.info.color))
    end
    self.holder:SetSize(width + 8, (height * #self.bars) + (2 * (#self.bars + 2)))
    self.holder:SetShown(self.db.enabled and self.CheckAchievementProgress())
end

function HAT:UpdateBars()
    if not self:CheckAchievementProgress() then
        for _, bar in ipairs(self.bars) do
            bar:Hide()
        end
        return
    end

    local criteriaTracked = 0
    local indexesToRemove = {}
    for i, bar in ipairs(self.bars) do
        local info = bar.info
        local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(info.achievementID)
        if completed and wasEarnedByMe then
            tinsert(indexesToRemove, i)
        else
            bar:SetMinMaxValues(0, info.needed)
            local count = 0
            for j = 1, info.criteriaCount do
                local n = select(4, GetAchievementCriteriaInfo(info.achievementID, j))
                count = count + n
            end
            if count > 0 then criteriaTracked = criteriaTracked + 1 end
            local textFormat = "%s: %d / %d"
            bar.text:SetText(textFormat:format(info.label, count, info.needed))
            bar:SetValue(count)
            bar:Show()
        end
    end
    local needsUpdate = false
    for _, v in pairs(indexesToRemove) do
        tremove(self.bars, v)
        needsUpdate = true
    end

    if needsUpdate then self:UpdateAll() end
    self.holder:SetShown(self.db.enabled and criteriaTracked > 0)
end

function HAT:Initialize()
    NUI:RegisterDB(self, "hiddenArtifactTracker")
    local ForUpdateAll = function(_self) _self:UpdateAll() end
    self.ForUpdateAll = ForUpdateAll

    self.holder = self.CreateHolder()

    local dungeonInfo = {
        label = "Dungeons",
        needed = 30,
        achievementID = 11152,
        criteriaCount = 15,
        color = { 0, 1, 0, 1 },
    }

    local point = { "TOP", self.holder, "TOP", 0, 0 }
    self.bars = {}
    local bar = self:CreateStatusBar(self.holder, dungeonInfo, unpack(point))
    if bar then
        tinsert(self.bars, bar)
        point = { "TOP", bar, "BOTTOM", 0, -4 }
    end

    local wqInfo = {
        label = "World Quests",
        needed = 200,
        achievementID = 11153,
        criteriaCount = 1,
        color = { 1, 1, 0, 1 },
    }

    bar = self:CreateStatusBar(self.holder, wqInfo, unpack(point))
    if bar then
        tinsert(self.bars, bar)
        point = { "TOP", bar, "BOTTOM", 0, -4 }
    end

    local hkInfo = {
        label = "Player Kills",
        needed = 1000,
        achievementID = 11154,
        criteriaCount = 1,
        color = { 1, 0, 0, 1 },
    }

    bar = self:CreateStatusBar(self.holder, hkInfo, unpack(point))
    if bar then tinsert(self.bars, bar) end

    self:UpdateAll()
    self:UpdateBars()
    self:RegisterEvent("CRITERIA_UPDATE", "UpdateBars")
    self:RegisterEvent("ACHIEVEMENT_EARNED", "UpdateBars")
    self:RegisterEvent("UNIT_INVENTORY_CHANGED", "UpdateBars")
end

NUI:RegisterModule(HAT:GetName())
