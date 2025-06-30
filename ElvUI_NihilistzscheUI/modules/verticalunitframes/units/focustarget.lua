---@class NUI
local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
if E.Classic then return end
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructFocusTargetFrame(frame, unit)
    frame.unit = unit

    frame.RaisedElementParent = self:ConstructRaisedElementParent(frame)

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

    frame:Point("BOTTOMLEFT", _G.NihilistzscheUF_Focus, "BOTTOMRIGHT", 110, 0)
    -- stylua: ignore start
    E:CreateMover(frame, frame:GetName() .. "Mover", "Focus Target Vertical Unit Frame", nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")
    -- stylua: ignore end
end

VUF:RegisterUnit("focustarget")
