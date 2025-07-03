local addon, ns = ...
ns.oUF = _G.ElvUF
local oUF = ns.oUF

---@class NUI
local NUI, E, _, _, P = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local LSM = E.Libs.LSM
local COMP = NUI.Compatibility

E.VerticalUnitFrames = VUF

local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local UnitExists = _G.UnitExists
local InCombatLockdown = _G.InCombatLockdown
local UnitAffectingCombat = _G.UnitAffectingCombat
local tinsert = _G.tinsert
local gsub = _G.gsub
local tContains = _G.tContains
local hooksecurefunc = _G.hooksecurefunc
local GetAddOnMetadata = (_G.C_AddOns or _G).GetAddOnMetadata

function VUF.CreateWarningFrame()
    local f = CreateFrame("ScrollingMessageFrame", "ElvUIVerticalUnitFramesWarning", UIParent)
    f:SetFont(LSM:Fetch("font", (UF.db or P.unitframe).font), (UF.db or P.unitframe).fontSize * 2, "THINOUTLINE")
    f:SetShadowColor(0, 0, 0, 0)
    f:SetFading(true)
    f:SetFadeDuration(0.5)
    f:SetTimeVisible(0.6)
    f:SetMaxLines(10)
    f:SetSpacing(2)
    f:SetWidth(128)
    f:SetHeight(128)
    f:SetPoint("CENTER", 0, E:Scale(-100))
    f:SetMovable(false)
    f:SetResizable(false)
    --f:SetInsertMode("TOP") -- Bugged currently
end

function VUF.CreateScreenFlash()
    local f = CreateFrame("Frame", "ElvUIVerticalUnitFramesScreenFlash", E.UIParent)
    f:SetToplevel(true)
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:SetAllPoints(E.UIParent)
    f:EnableMouse(false)
    f.texture = f:CreateTexture(nil, "BACKGROUND")
    f.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
    f.texture:SetAllPoints(E.UIParent)
    f.texture:SetBlendMode("ADD")
    f:SetAlpha(0)
end

local portraitFixClosures = {}
local function GetPortraitFixClosure(frame)
    if portraitFixClosures[frame] then return portraitFixClosures[frame] end
    local portraitFix = function() frame.Portrait:SetAlpha(VUF.db.alphaOOC) end
    portraitFixClosures[frame] = portraitFix
    return portraitFix
end

function VUF:ActivateFrame(frame)
    E:UIFrameFadeIn(frame, 0.2, frame:GetAlpha(), self.db.alpha)
    if frame.Portrait then frame.Portrait:SetAlpha(math.min(self.db.alpha, 0.35)) end
end

function VUF:DeactivateFrame(frame)
    E:UIFrameFadeOut(frame, 0.2, frame:GetAlpha(), self.db.alphaOOC)
    if frame.Portrait then
        frame.Portrait:SetAlpha(self.db.alphaOOC)
        C_Timer.After(0.2, GetPortraitFixClosure(frame))
    end
end

function VUF:UpdateHideSetting()
    if self.db.hideOOC then
        self:EnableHide()
    else
        self:DisableHide()
    end
end

function VUF:UpdateHiddenStatus(frame, event)
    if frame.unit == "target" or not self.db.hideOOC then return end

    local combatEnded = event == "PLAYER_REGEN_ENABLED"
    local inCombat = event == "PLAYER_REGEN_DISABLED" or UnitAffectingCombat("player") or UnitAffectingCombat("pet")
    local isCasting = frame.isCasting
    local isMouseOver = frame:IsMouseMotionFocus()
    local isHealing = frame.healthSeen
    local overrideHide = (inCombat and not combatEnded) or isCasting or isHealing or isMouseOver
    if not overrideHide then
        self:DeactivateFrame(frame)
    else
        self:ActivateFrame(frame)
    end
end

function VUF.DisableFrame(f)
    f:Hide()
    f:EnableMouse(false)
    f:SetAlpha(0)
end

function VUF.EnableFrame(f, a, m)
    if a == nil then a = 1 end
    if m == nil then m = true end
    f:Show()
    f:EnableMouse(m)
    f:SetAlpha(a)
end

local elv_units = { "player", "target", "pet", "pettarget", "targettarget", "focus", "focustarget" }

function VUF.UpdateElvUFSetting()
    if InCombatLockdown() or UnitAffectingCombat("player") or UnitAffectingCombat("pet") then
        NUI.RegenWait(VUF.UpdateElvSetting)
        return
    end
    local value
    if E.db.nihilistzscheui.vuf.enabled then
        value = not E.db.nihilistzscheui.vuf.hideElv
    else
        value = true
    end
    for _, unit in pairs(elv_units) do
        E.db.unitframe.units[unit].enable = value
        if not value and UF.units[unit] then UF.units[unit]:Kill() end
    end
end

function VUF:EnableHide()
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:PLAYER_ENTERING_WORLD()
end

function VUF:DisableHide()
    self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:PLAYER_ENTERING_WORLD()
    for _, f in pairs(self.units) do
        f:SetAlpha(1)
    end
end

function VUF:Enable()
    self.UpdateElvUFSetting()
    for _, f in pairs(self.units) do
        if not self.db.enabled then
            VUF.DisableFrame(f)
        else
            VUF.EnableFrame(f, self.db.alpha, self.db.enableMouse)
        end
    end

    if self.db.hideOOC then
        self:EnableHide()
    else
        self:DisableHide()
    end
end

function VUF:UpdateMouseSetting()
    for _, f in pairs(self.units) do
        if self.db.enableMouse or self.db.hideElv then
            f:EnableMouse(true)
        else
            f:EnableMouse(false)
        end
    end
end

function VUF:UpdateAll()
    if UnitAffectingCombat("player") or UnitAffectingCombat("pet") then
        NUI:RegenWait(self.UpdateAll, self)
        return
    end

    self:UpdateAllFrames()
    self:UpdateMouseSetting()
    self:UpdateHideSetting()
    self:Enable()
end

function VUF.ResetFramePositions()
    E:ResetMovers("Focus Vertical Unit Frame")
    E:ResetMovers("Focus Target Vertical Unit Frame")
    E:ResetMovers("Pet Vertical Unit Frame")
    E:ResetMovers("Pet Target Vertical Unit Frame")
    E:ResetMovers("Player Vertical Unit Frame")
    E:ResetMovers("Target Vertical Unit Frame")
    E:ResetMovers("Target Target Vertical Unit Frame")
end

VUF.units = {}

VUF.RegisteredUnits = {}

function VUF:RegisterUnit(unit) tinsert(self.RegisteredUnits, unit) end

function VUF:Initialize()
    NUI:RegisterDB(self, "vuf")
    local ForUpdateAll = function(_self) _self:UpdateAll() end
    self.ForUpdateAll = ForUpdateAll

    self.CreateWarningFrame()
    self.CreateScreenFlash()

    oUF:RegisterStyle("NihilistzscheUI_VerticalUnitFrames", function(frame, unit)
        frame:SetFrameLevel(5)
        VUF:ConstructVerticalUnitFrame(frame, unit)
    end)

    oUF:SetActiveStyle("NihilistzscheUI_VerticalUnitFrames")

    local function spawnUnit(unit)
        local stringTitle = E:StringTitle(unit)
        if stringTitle:find("target") then stringTitle = gsub(stringTitle, "target", "Target") end
        oUF:Spawn(
            unit,
            "NihilistzscheUF_" .. stringTitle,
            E.Retail and "SecureUnitButtonTemplate, PingableUnitFrameTemplate" or "SecureUnitButtonTemplate"
        )
    end

    local needsManualCreate = { "player", "target" }
    for _, unit in ipairs(needsManualCreate) do
        spawnUnit(unit)
    end

    for _, unit in pairs(self.RegisteredUnits) do
        if not tContains(needsManualCreate, unit) then spawnUnit(unit) end
    end

    hooksecurefunc(E, "UpdateAll", function() self:UpdateAll() end)
    hooksecurefunc(UF, "Update_AllFrames", function() self:UpdateAllFrames() end)
    hooksecurefunc(UF, "CreateAndUpdateUF", function(_, unit) self:UpdateFrame(unit) end)
    if _G.CastingBarFrame then
        _G.CastingBarFrame:Hide()
        _G.CastingBarFrame.Show = function() end
        _G.CastingBarFrame.SetShown = function() end
    end

    self:UpdateAll()

    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("PET_BATTLE_CLOSE", "UpdateAllFrames")
    if COMP.FCT then self:RegisterEvent("PLAYER_TARGET_CHANGED") end
    self.version = GetAddOnMetadata(addon, "Version")
end

NUI:RegisterModule(VUF:GetName())
