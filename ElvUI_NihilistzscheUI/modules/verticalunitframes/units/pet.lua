local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructPetFrame(frame, unit)
    frame.unit = unit

    frame.Health = self:ConstructHealth(frame)

    frame.Name = self:ConstructName(frame)

    frame.Power = self:ConstructPower(frame)

    frame.AuraBars = self:ConstructAuraBarHeader(frame)
    frame:DisableElement("AuraBars")

    frame.Castbar = self:ConstructCastbar(frame)
    frame.Castbar.SafeZone = nil
    frame.RaidTargetIndicator = self:ConstructRaidIcon(frame)

    frame.Buffs = self:ConstructBuffs(frame)
    frame.Debuffs = self:ConstructDebuffs(frame)

    frame.HealthPrediction = self:ConstructHealthPrediction(frame)
    frame.Portrait = self:ConstructPortrait(frame)
    frame.Cutaway = self:ConstructCutaway(frame)

    frame.colors = _G.ElvUF.colors

    frame.OnFirstUpdateFinish = function()
        frame:SetAlpha(self.db.alpha)
        VUF:HookSetAlpha(frame)
    end

    frame:Point("BOTTOMRIGHT", _G.NihilistzscheUF_Player, "BOTTOMLEFT", -150, 0)
    -- stylua: ignore start
    E:CreateMover(frame, frame:GetName() .. "Mover", "Pet Vertical Unit Frame", nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")
    -- stylua: ignore end
end

VUF:RegisterUnit("pet")
