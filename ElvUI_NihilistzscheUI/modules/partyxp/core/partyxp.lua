local NUI, E = _G.unpack(select(2, ...))
local PXP = NUI.PartyXP
local LSM = E.Libs.LSM

local NT = NUI.Libs.NT
local COMP = NUI.Compatibility
local ES = NUI.EnhancedShadows

local min = _G.math.min
local UnitClass = _G.UnitClass
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local tinsert = _G.tinsert
local tremove = _G.tremove
local tInvert = _G.tInvert
local strfind = _G.strfind
local strsplit = _G.strsplit
local GetNumGroupMembers = _G.GetNumGroupMembers
local UnitName = _G.UnitName
local UnitGUID = _G.UnitGUID
local GetNumSubgroupMembers = _G.GetNumSubgroupMembers
local GetMaxLevelForPlayerExpansion = _G.GetMaxLevelForPlayerExpansion
local GetExpansionLevel = _G.GetExpansionLevel
local CreateFrame = _G.CreateFrame
local wipe = _G.wipe

function PXP:UpdateMedia()
    for _, v in pairs(self.bars) do
        v:SetStatusBarTexture(LSM:Fetch("statusbar", self.db.texture))
        v.restedBar:SetStatusBarTexture(LSM:Fetch("statusbar", self.db.texture))
        v.questbar:SetStatusBarTexture(LSM:Fetch("statusbar", self.db.texture))
        v.text:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontsize, "THINOUTLINE")
    end
end

function PXP:UpdateColorSetting()
    for _, v in pairs(self.bars) do
        if self.db.classColor then
            local _, class = UnitClass(self:GetDataForPartyMember(v.guid).name)
            if class then
                local color = class == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[class]
                v:SetStatusBarColor(color.r, color.g, color.b)
                v.restedbar:SetStatusBarColor(color.r * 0.8, color.g * 0.8, color.b * 0.8, 0.2)
            end
        else
            v:SetStatusBarColor(self.db.color.r, self.db.color.g, self.db.color.b)
            v.restedbar:SetStatusBarColor(1, 0, 1, 0.2)
        end
    end
end

function PXP:UpdatePartyMembers()
    local bar = next(self.bars)
    while bar do
        self:RecycleBar(bar)
        bar = next(self.bars)
    end
    PXP:Update()
end

function PXP:UpdateBar(bar)
    local guid = bar.guid
    local data = self:GetDataForPartyMember(guid)
    if (not data) then
        return
    end

    bar:SetMinMaxValues(0, data.max)
    bar:SetValue(data.current)

    local rbar = bar.restedbar
    rbar:SetMinMaxValues(0, data.max)
    rbar:SetValue(min(data.current + data.rested), data.max)

    NT:Tag(bar.ctKey, self.db.tag)
    if (not data.qxp) then
        bar.questbar:Hide()
        return
    end

    local qbar = bar.questbar
    local cq = data.current + data.qxp

    qbar:SetMinMaxValues(0, data.max)
    qbar:SetValue(min(data.max, cq))
    if (cq >= data.max) then
        qbar:SetStatusBarColor(0.2, 0.6, 0.2, 0.8)
    else
        qbar:SetStatusBarColor(1.0, 1.0, 0.2, 0.4)
    end
    qbar:SetShown(data.qxp > 0)
end

function PXP:RecycleBar(bar)
    if (not self.barCache) then
        self.barCache = {}
    end
    bar:Hide()
    tinsert(self.barCache, bar)
    tremove(self.bars, tInvert(self.bars)[bar])
end

function PXP:GetBarForPartyMember(guid)
    for _, bar in ipairs(self.bars) do
        if (bar.guid == guid) then
            return bar
        end
    end
end

function PXP.GetPartyMemberGUIDFromName(name)
    local n, r
    r = ""
    if strfind(name, "-") then
        n, r = strsplit("-", name)
    else
        n = name
    end
    if (r == E.myrealm) then
        r = ""
    end
    for i = 1, GetNumGroupMembers() do
        local _n, _r = UnitName("party" .. i)
        if n == _n and r == _r then
            return UnitGUID("party" .. i)
        end
    end
    return nil
end

function PXP.GetPartyMemberIndex(name)
    local n, r
    r = ""
    if strfind(name, "-") then
        n, r = strsplit("-", name)
    else
        n = name
    end
    if (r == E.myrealm) then
        r = ""
    end
    for i = 1, GetNumGroupMembers() do
        local _n, _r = UnitName("party" .. i)
        if n == _n and r == _r then
            return "party" .. i
        end
    end
    return nil
end

function PXP:Update()
    if not self.db.enabled then
        return
    end
    for i = 1, GetNumSubgroupMembers() do
        local guid = UnitGUID("party" .. i)
        local data = self:GetDataForPartyMember(guid)

        if data then
            -- luacheck: no max line length
            if (data.level == GetMaxLevelForPlayerExpansion() or data.disabled) and self:GetBarForPartyMember(guid) then
                local bar = self:GetBarForPartyMember(guid)
                if (bar) then
                    self:RecycleBar(bar)
                end
            else
                local bar = self:GetBarForPartyMember(guid)
                if (not bar) then
                    bar = self:CreateBar()
                    tinsert(self.bars, bar)
                end
                bar.guid = guid
                if self.db.classColor then
                    local _, class = UnitClass("party" .. i)
                    if class then
                        local color = class == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[class]
                        bar:SetStatusBarColor(color.r, color.g, color.b)
                        bar.restedbar:SetStatusBarColor(color.r * 0.8, color.g * 0.8, color.b * 0.8, 0.2)
                    end
                else
                    bar:SetStatusBarColor(self.db.color.r, self.db.color.g, self.db.color.b)
                    bar:SetStatusBarColor(1, 0, 1, 0.2)
                end
                self:UpdateBar(bar)
            end
        end
    end

    local function sortBars(barA, barB)
        return barA.guid < barB.guid
    end

    table.sort(self.bars, sortBars)

    for _, v in ipairs(self.bars) do
        v:ClearAllPoints()
    end

    for i, v in ipairs(self.bars) do
        local relative = i == 1 and _G.NihilistzscheUI_PartyXPHolder or self.bars[i - 1]
        v:SetPoint("TOP", relative, "BOTTOM", 0, self.db.offset)
        self.SetCurrentPartyMember(v.guid)
        NT:UpdateTagString(v.ctKey)
    end
end

local ctKeyID = 1

function PXP:CreateBar()
    local bar = self.barCache and tremove(self.barCache) or nil
    if (bar) then
        return
    end

    bar = CreateFrame("StatusBar", nil, _G.NihilistzscheUI_PartyXPHolder, "BackdropTemplate")
    bar:SetSize(_G.NihilistzscheUI_PartyXPHolder:GetSize())
    bar:CreateBackdrop("Transparent")
    if (COMP.MERS) then
        bar:Styling()
    end

    bar:SetStatusBarTexture(LSM:Fetch("statusbar", self.db.texture))
    if ES then
        bar:CreateShadow()
        ES:RegisterFrameShadows(bar)
    end

    local restedbar = CreateFrame("StatusBar", nil, bar)
    restedbar:SetInside(bar)
    restedbar:SetStatusBarTexture(LSM:Fetch("statusbar", self.db.texture))
    restedbar:SetMinMaxValues(0, 1)
    restedbar:SetValue(0)

    bar.restedbar = restedbar

    local questbar = CreateFrame("StatusBar", nil, bar)
    questbar:SetPoint("TOPLEFT", bar:GetStatusBarTexture("TOPRIGHT"))
    questbar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT")
    questbar:SetStatusBarTexture(LSM:Fetch("statusbar", self.db.texture))
    questbar:SetMinMaxValues(0, 1)
    questbar:SetValue(0)

    bar.questbar = questbar

    bar.text = bar:CreateFontString()
    bar.text:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontsize, "THINOUTLINE")
    bar.text:SetPoint("CENTER", bar, "CENTER", 0, 0)
    bar.text:SetJustifyH("CENTER")
    bar.text:SetJustifyV("MIDDLE")
    local ctKey = "pxp" .. ctKeyID
    bar.ctKey = ctKey
    NT:RegisterFontString(ctKey, bar.text)
    ctKeyID = ctKeyID + 1

    return bar
end

function PXP.HideBar(bar)
    bar:Hide()
    bar.restedbar:Hide()
    bar.questbar:Hide()
end

function PXP.ShowBar(bar)
    bar:Show()
    bar.restedbar:Show()
    bar.questbar:Show()
end

function PXP:Enable()
    if (self.db.enabled) then
        self:RegisterEvents()
        self.Message()
        self:Update()
    else
        self:UnregisterEvents()
        for _, bar in ipairs(self.bars) do
            self.HideBar(bar)
        end
        wipe(self.data)
    end
end

function PXP:Initialize()
    NUI:RegisterDB(self, "pxp")
    self:InitData()
    self.bars = {}

    local ForUpdateAll = function(_self)
        _self:Enable()
        _self:UpdateColorSetting()
        _self:Update()
    end
    self.ForUpdateAll = ForUpdateAll
    local frame = CreateFrame("Frame", "NihilistzscheUI_PartyXPHolder", E.UIParent)
    frame:Size(self.db.width, self.db.height)
    frame:Point("TOP", E.UIParent, "TOP", 0, -50)
    E:CreateMover(
        frame,
        "NihilistzscheUI_PartyXPHolderMover",
        "ElvUI PartyXP Holder",
        nil,
        nil,
        nil,
        "GENERAL,ALL,NIHILISTUI"
    )

    self.frame = frame
    self.InitMessaging()
    self.RegisterTags()
    self:Enable()
end

NUI:RegisterModule(PXP:GetName())
