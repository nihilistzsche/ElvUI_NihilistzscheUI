local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI) --Inport: Engine, Locales, ProfileDB, GlobalDB
local LSM = E.Libs.LSM

local PB = NUI.UtilityBars.ProfessionBar
local NUB = NUI.UtilityBars

local C_Spell_GetSpellTexture = _G.C_Spell.GetSpellTexture
local GetProfessionInfo = _G.GetProfessionInfo
local GetProfessions = _G.GetProfessions
local C_Spell_GetSpellInfo = _G.C_Spell.GetSpellInfo
local C_Spell_GetSpellName = _G.C_Spell.GetSpellName
local tinsert = _G.tinsert
local CreateFrame = _G.CreateFrame

function PB:CreateBar()
    local bar = NUB:CreateBar(
        self,
        "NihilistzscheUI_ProfessionBar",
        "professionBar",
        { "BOTTOMRIGHT", _G.RightChatPanel, "TOPRIGHT", 0, 2 },
        "Profession Bar"
    )

    NUB.RegisterCreateButtonHook(bar, function(button) self:CreateButtonHook(button) end)
    NUB.RegisterUpdateButtonHook(bar, function(button, ...) self.UpdateButtonHook(button, ...) end)

    return bar
end

-- Positive numbers here mean use this skill id for this profession rather than the profession itself
-- Negative numbers mean this skill id is used for the second skill for this profession
PB.SkillFixMap = {
    [186] = 2656,
    [182] = 2366,
    [185] = -818,
    [333] = -13262,
    [356] = -271990,
    [755] = -31252,
    [773] = -51005,
    [794] = -80451,
}

PB.ClassProfMap = {
    DEATHKNIGHT = 53428,
}

function PB:CreateButtonHook(button)
    button.ranktext = button:CreateFontString(nil, "OVERLAY")
    button.ranktext:FontTemplate(LSM:Fetch("font", E.db.general.font), 10, "THINOUTLINE")
    button.ranktext:SetWidth(E:Scale(self.bar.db.buttonsize) - 4)
    button.ranktext:SetHeight(E:Scale(14))
    button.ranktext:SetJustifyH("RIGHT")
    button.ranktext:Point("BOTTOMRIGHT", 0, 0)
end

function PB.UpdateButtonHook(button, prof, ranks)
    button.texture:SetTexture(C_Spell_GetSpellTexture(prof))
    button.ranktext:SetText(ranks[prof] or "")
end

function PB:GetProfessions()
    local professions = {}
    local ranks = {}

    for _, v in pairs({ GetProfessions() }) do
        local name, _, rank, _, _, _, skillID = GetProfessionInfo(v)
        if name then
            if self.SkillFixMap[skillID] then
                local realSkill = self.SkillFixMap[skillID]
                if realSkill > 0 then
                    name = C_Spell_GetSpellName(realSkill)
                    tinsert(professions, name)
                    ranks[name] = rank
                else
                    tinsert(professions, name)
                    ranks[name] = rank
                    local secondSkillName = C_Spell_GetSpellName(-self.SkillFixMap[skillID])
                    if secondSkillName then tinsert(professions, secondSkillName) end
                end
            else
                tinsert(professions, name)
                ranks[name] = rank
            end
        end
    end

    if self.ClassProfMap[E.myclass] then
        local name = C_Spell_GetSpellName(self.ClassProfMap[E.myclass])
        tinsert(professions, name)
    end

    return professions, ranks
end

function PB:UpdateBar(bar)
    local professions, ranks = self:GetProfessions()

    NUB.WipeButtons(bar)
    NUB.CreateButtons(bar, #professions)

    for i, prof in ipairs(professions) do
        local button = bar.buttons[i]
        local spellInfo = C_Spell_GetSpellInfo(prof)
        if spellInfo then NUB.UpdateButtonAsSpell(bar, button, spellInfo.spellID, prof, ranks) end
    end

    NUB.UpdateBar(self, bar, "ELVUIBAR25BINDBUTTON")
end

function PB:Initialize()
    local frame = CreateFrame("Frame", "NihilistzscheUI_ProfBarController")
    frame:RegisterEvent("SPELLS_CHANGED")
    frame:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
    NUB:RegisterEventHandler(self, frame)

    NUB:InjectScripts(self)

    local bar = self:CreateBar()
    self.bar = bar
    self.hooks = {}

    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(PB)
