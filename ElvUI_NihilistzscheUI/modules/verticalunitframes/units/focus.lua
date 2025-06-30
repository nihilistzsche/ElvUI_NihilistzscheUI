---@class NUI
local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB

if E.Classic then return end
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames

function VUF:ConstructFocusFrame(frame, unit)
    frame.unit = unit

    frame.RaisedElementParent = self:ConstructRaisedElementParent(frame)

    frame.Health = self:ConstructHealth(frame)

    frame.Name = self:ConstructName(frame)

    frame.Power = self:ConstructPower(frame)

    frame.Castbar = self:ConstructCastbar(frame)
    frame.Castbar.SafeZone = nil
    frame.RaidTargetIndicator = self:ConstructRaidIcon(frame)

    frame.Buffs = self:ConstructBuffs(frame)
    frame.Debuffs = self:ConstructDebuffs(frame)
    frame.PrivateAuras = UF:Construct_PrivateAuras(frame)

    frame.HealthPrediction = self:ConstructHealthPrediction(frame)
    frame.Portrait = self:ConstructPortrait(frame)
    frame.Cutaway = self:ConstructCutaway(frame)

    frame.colors = _G.ElvUF.colors

    frame.OnFirstUpdateFinish = function()
        frame:SetAlpha(self.db.alpha)
        VUF:HookSetAlpha(frame)
    end

    frame:Point("TOP", E.UIParent, "TOP", 300, -250)
    -- stylua: ignore start
    E:CreateMover(frame, frame:GetName() .. "Mover", "Focus Vertical Unit Frame", nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")
    -- stylua: ignore end
end

VUF:RegisterUnit("focus")
