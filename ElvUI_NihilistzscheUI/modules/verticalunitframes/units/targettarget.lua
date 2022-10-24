local NUI, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructTargetTargetFrame(frame, unit)
    frame.unit = unit

    frame.Health = self:ConstructHealth(frame)

    frame.Name = self:ConstructName(frame)

    frame.Power = self:ConstructPower(frame)
    frame.RaidTargetIndicator = self:ConstructRaidIcon(frame)

    frame.HealthPrediction = self:ConstructHealthPrediction(frame)
    frame.Portrait = self:ConstructPortrait(frame)
    frame.Cutaway = self:ConstructCutaway(frame)

    frame.colors = _G.ElvUF.colors

    frame.OnFirstUpdateFinish = function()
        frame:SetAlpha(self.db.alpha)
        VUF:HookSetAlpha(frame)
    end

<<<<<<< Updated upstream
    frame:Point("BOTTOMLEFT", _G.NihilistzscheUF_Target, "BOTTOMRIGHT", 110, 0)
=======
    frame:Point("LEFT", _G.NihilistzscheUF_Target, "RIGHT", 140, 50)
>>>>>>> Stashed changes
    E:CreateMover(
        frame,
        frame:GetName() .. "Mover",
        "Target Target Vertical Unit Frame",
        nil,
        nil,
        nil,
        "ALL,SOLO,NIHILISTUI"
    )
end

VUF:RegisterUnit("targettarget")
