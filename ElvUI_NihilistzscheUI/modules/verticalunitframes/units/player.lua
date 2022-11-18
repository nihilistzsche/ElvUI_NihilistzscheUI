local NUI, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames
local AuraUtil_FindAuraByName = _G.AuraUtil.FindAuraByName

VUF.PlayerFrameClassSpecific = {
    WARLOCK = {
        ClassPower = "ConstructShardBar",
    },
    PALADIN = {
        ClassPower = "ConstructHolyPower",
    },
    DEATHKNIGHT = {
        Runes = "ConstructRunes",
    },
    MONK = {
        ClassPower = "ConstructHarmony",
        Exec = function(self, frame) frame.Stagger = self:ConstructStagger(frame) end,
    },
    MAGE = {
        ClassPower = "ConstructArcaneBar",
    },
    ROGUE = {
        ClassPower = "ConstructComboPoints",
    },
    DRUID = {
        ClassPower = "ConstructComboPoints",
        AdditionalPower = true,
    },
    PRIEST = {
        AdditionalPower = true,
    },
    SHAMAN = {
        AdditionalPower = true,
    },
    EVOKER = {
        ClassPower = "ConstructEssence",
    }
}

local EntropicEmbraceSpellID = 256374
local skipTime = 0.5
local EntropicEmbraceSpellName

VUF.PlayerFrameRaceSpecific = {
    VoidElf = {
        Exec = function(_, frame)
            local UnitAuraUpdate = function(f, e)
                if not EntropicEmbraceSpellName then
                    EntropicEmbraceSpellName = _G.GetSpellInfo(EntropicEmbraceSpellID)
                end
                if ((f.entropicEmbraceElapsed or 0) + e) > skipTime then
                    local es = AuraUtil_FindAuraByName(EntropicEmbraceSpellName, "player", "HELPFUL")
                    if f.entropicEmbraceState and (f.entropicEmbraceState ~= es) then
                        f.Portrait:ClearModel()
                        f.Portrait:SetUnit(f.unit)
                    end
                    f.entropicEmbraceState = es
                else
                    f.entropicEmbraceElapsed = (f.entropicEmbraceElapsed or 0) + e
                end
            end
            frame:HookScript("OnUpdate", UnitAuraUpdate)
        end,
    },
}
function VUF:AddClassSpecificElements(frame)
    local tbl = self.PlayerFrameClassSpecific[E.myclass]
    if not tbl then return end

    local key = tbl.ClassPower and "ClassPower" or "Runes"

    if tbl[key] then
        frame[key] = VUF[tbl[key]](VUF, frame)
        frame.ClassBar = frame[key]
    end

    if tbl.Exec then tbl.Exec(self, frame) end

    if tbl.AdditionalPower then frame.AdditionalPower = self:ConstructAdditionalPower(frame) end
end

function VUF:AddRaceSpecificElements(frame)
    local tbl = self.PlayerFrameRaceSpecific[E.myrace]
    if not tbl then return end

    tbl.Exec(self, frame)
end

function VUF:ConstructPlayerFrame(frame, unit)
    frame.unit = unit

    frame.Health = self:ConstructHealth(frame)

    frame.Power = self:ConstructPower(frame)

    frame.Castbar = self:ConstructCastbar(frame)
    frame.Castbar.LatencyTexture:Show()

    frame.Name = self:ConstructName(frame)

    frame.AuraBars = self:ConstructAuraBarHeader(frame)
    frame:DisableElement("AuraBars")

    self:AddClassSpecificElements(frame)
    self:AddRaceSpecificElements(frame)

    frame.Buffs = self:ConstructBuffs(frame)
    frame.Debuffs = self:ConstructDebuffs(frame)
    frame.RaidTargetIndicator = self:ConstructRaidIcon(frame)
    frame.RestingIndicator = self:ConstructRestingIndicator(frame)
    frame.CombatIndicator = self:ConstructCombatIndicator(frame)
    frame.PvPText = self:ConstructPvPText(frame)
    frame.HealthPrediction = self:ConstructHealthPrediction(frame)
    frame.PowerPrediction = self:ConstructPowerPrediction(frame)
    frame.GCD = self:ConstructGCD(frame)
    frame.Portrait = self:ConstructPortrait(frame)
    frame.ResurrectIndicator = self:ConstructResurrectIndicator(frame)
    frame.Cutaway = self:ConstructCutaway(frame)

    frame.colors = _G.ElvUF.colors

    frame.OnFirstUpdateFinish = function()
        frame:SetAlpha(self.db.alpha)
        VUF:HookSetAlpha(frame)
    end

    frame:Point("RIGHT", E.UIParent, "CENTER", -275, 0) --Set to default position
    E:CreateMover(frame, frame:GetName() .. "Mover", "Player Vertical Unit Frame", nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")
end

VUF:RegisterUnit("player")
