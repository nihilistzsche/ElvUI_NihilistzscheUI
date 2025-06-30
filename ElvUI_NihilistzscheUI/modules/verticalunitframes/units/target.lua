---@class NUI
local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames

function VUF:ConstructTargetFrame(frame, unit)
    frame.unit = unit

    frame.RaisedElementParent = self:ConstructRaisedElementParent(frame)

    frame.Health = self:ConstructHealth(frame)

    frame.Power = self:ConstructPower(frame)

    frame.Castbar = self:ConstructCastbar(frame)
    frame.Castbar.SafeZone = nil
    frame.Name = self:ConstructName(frame)

    frame.Buffs = self:ConstructBuffs(frame)
    frame.Debuffs = self:ConstructDebuffs(frame)
    frame.PrivateAuras = UF:Construct_PrivateAuras(frame)

    frame.AuraBars = self:ConstructAuraBarHeader(frame)
    frame:DisableElement("AuraBars")

    frame.RaidTargetIndicator = self:ConstructRaidIcon(frame)

    frame.HealthPrediction = self:ConstructHealthPrediction(frame)

    frame.Portrait = self:ConstructPortrait(frame)

    frame.PhaseIndicator = self:ConstructPhaseIndicator(frame)

    frame.Cutaway = self:ConstructCutaway(frame)

    frame.colors = _G.ElvUF.colors

    frame.OnFirstUpdateFinish = function() frame:SetAlpha(self.db.alpha) end

    frame:Point("LEFT", E.UIParent, "CENTER", 275, 0) --Set to default position
    -- stylua: ignore start
    E:CreateMover(frame, frame:GetName() .. "Mover", "Target Vertical Unit Frame", nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")
    -- stylua: ignore end
end

VUF:RegisterUnit("target")
