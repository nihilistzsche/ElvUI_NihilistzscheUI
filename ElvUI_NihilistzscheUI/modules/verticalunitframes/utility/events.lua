local NUI = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames
local COMP = NUI.Compatibility
local InCombatLockdown = _G.InCombatLockdown
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitAffectingCombat = _G.UnitAffectingCombat

function VUF:PLAYER_TARGET_CHANGED()
    local frame = self.units.target
    if COMP.FCT then
        if frame and frame.ElvFCT and self.FCT then self.FCT:Disable(frame) end
    end
    if frame then
        frame.Cutaway.Health:SetAlpha(0)
        frame.Cutaway.Power:SetAlpha(0)
    end
end

function VUF:PLAYER_REGEN_DISABLED()
    for _, frame in pairs(self.units) do
        if frame.unit ~= "target" then VUF:UpdateHiddenStatus(frame, "PLAYER_REGEN_DISABLED") end
    end
end

function VUF:PLAYER_REGEN_ENABLED()
    for _, frame in pairs(self.units) do
        if frame.unit ~= "target" then VUF:UpdateHiddenStatus(frame, "PLAYER_REGEN_ENABLED") end
    end
end

function VUF:PLAYER_ENTERING_WORLD()
    if self.db.hideOOC then
        if InCombatLockdown() then
            self:PLAYER_REGEN_DISABLED()
        else
            self:PLAYER_REGEN_ENABLED()
        end
    end
end

function VUF:UNIT_HEALTH(_, unit)
    if not self.db.hideOOC then return end

    if not self.units[unit] or unit == "target" then return end

    local f = self.units[unit]
    local healthSeen = UnitHealth(unit)
    if healthSeen == UnitHealthMax(unit) or healthSeen == f.healthSeen and not f.isCasting then
        if not UnitAffectingCombat("player") and not UnitAffectingCombat("pet") then
            VUF:UpdateHiddenStatus(f, "PLAYER_REGEN_ENABLED")
        end
        f.healthSeen = nil
    else
        VUF:UpdateHiddenStatus(f, "PLAYER_REGEN_DISABLED")
        f.HealthSeen = healthSeen
    end
end
