local NUI, E = _G.unpack(select(2, ...))
local RCD = NUI.RaidCDs
local LSM = E.Libs.LSM
local GI = NUI.Libs.GI

local wipe = _G.wipe
local tFilter = _G.tFilter
local IsInRaid = _G.IsInRaid
local GetSpellCharges = _G.GetSpellCharges
local UnitAffectingCombat = _G.UnitAffectingCombat
local GetNumGroupMembers = _G.GetNumGroupMembers
local UnitGUID = _G.UnitGUID
local IsInGroup = _G.IsInGroup
local UnitExists = _G.UnitExists

function RCD:GetModifiedCooldown(node)
    if (type(node.cd) == "number") then
        return node.cd
    end

    local guid = node.guid
    local unitInfo = self.cached_players[guid].unitInfo
    local cd = node.cd.base
    for mkey, mtbl in pairs(node.cd) do
        if (mkey ~= "base") then
            local mtype = RCD.modifierTypes.Talent
            if mkey == "pvp_talent" then
                mtype = RCD.modifierTypes.PvPTalent
            elseif mkey == "legendary" then
                mtype = RCD.modifierTypes.Legendary
            end
            local modifier, isPercent = self:EvaluateModifier(unitInfo, mtbl, mtype)
            if (isPercent) then
                cd = cd * (1 - (modifier / 100))
            else
                cd = cd - modifier
            end
        end
    end
    return cd
end

function RCD:BuildList()
    wipe(self.cd_list)
    for category, _ in pairs(self.categories) do
        self.cd_list[category] = {}
        for guid, _ in pairs(self.cached_players) do
            local knownSpells = self:GetSpellsForCategory(category, guid)
            for spell_id, tbl in pairs(knownSpells) do
                if (not self.cd_list[category][spell_id]) then
                    self.cd_list[category][spell_id] = {}
                end
                self.cd_list[category][spell_id][guid] = self:GetModifiedCooldown(tbl)
            end
        end
    end
end

function RCD:IsBarDead(bar)
    return not bar.info or not bar.info.guid or not bar.info.id or not self.cached_players[bar.info.guid] or
        not self.cd_list[bar.category] or
        not self.cd_list[bar.category][bar.info.id] or
        not self.cd_list[bar.category][bar.info.id][bar.info.guid]
end

function RCD:KillBar(category, bar)
    if (bar.cdyStop) then
        bar:cdyStop()
    end
    self.barCache[category][bar.info.id][bar.info.guid] = nil
    if bar.cdyStop then
        bar.Stop = bar.cdyStop
        bar.cdyStop = nil
    end
end

function RCD:RemoveDeadBars(category)
    local bars = self.bars[category]
    local change = false
    for _, bar in ipairs(bars) do
        if (self:IsBarDead(bar)) then
            self:KillBar(category, bar)
            change = true
        end
    end
    if change then
        self.bars[category] =
            tFilter(
            bars,
            function(v)
                return not RCD:IsBarDead(v)
            end,
            true
        )
    end
end

function RCD:UpdateCDs()
    if (not self.initialized) then
        return
    end

    for category, _ in pairs(self.categories) do
        self:RemoveDeadBars(category)
    end

    self:BuildList()
    self:GenerateReverseMappings()

    for category, _ in pairs(self.categories) do
        local cd_list = self.cd_list[category]
        for spell_id, guid_tbl in pairs(cd_list) do
            for guid, _ in pairs(guid_tbl) do
                self:CreateBar(spell_id, guid)
            end
        end
    end

    self:PositionAllBars()
end

function RCD:GenerateReverseMappings()
    wipe(self.reverse_mappings)
    for category, spells in pairs(self.categories) do
        for spell_id, _ in pairs(spells) do
            self.reverse_mappings[spell_id] = category
        end
    end
end

function RCD:CheckRaidBattleRes()
    if (not IsInRaid()) then
        return
    end
    for _, bar in ipairs(self.bars.battleRes) do
        if bar.info.raidBattleRes then
            local currentCharges = GetSpellCharges(bar.info.id)
            bar.candyBarDuration:SetText(("%d RDY"):format(currentCharges))
        end
    end
end

function RCD:UpdateMedia()
    for category, _ in pairs(self.categories) do
        for _, bar in ipairs(self.bars[category]) do
            bar:SetTexture(self.db.texture)
            bar.candyBarLabel:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
            bar.candyBarDuration:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
        end
    end
end

function RCD:CheckCombatState()
    local inCombat = UnitAffectingCombat("player") or UnitAffectingCombat("pet")
    local show = (not self.db.onlyInCombat or inCombat) and self:ShouldShow()
    if (show) then
        self:Show()
    else
        self:Hide()
    end
end

function RCD:UpdateVisibility(show)
    if (show) then
        self:Show()
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterEvent("UNIT_PET", "UpdateCDs")
        GI:Rescan()
    else
        self:Hide()
        self:UnregisterAllEvents()
    end
end

function RCD:PLAYER_REGEN_ENABLED()
    if (self.db.onlyInCombat) then
        self:Hide()
    end

    if (IsInRaid()) then
        for i = 1, GetNumGroupMembers() do
            if (not self.cached_players[UnitGUID("raid" .. i)]) then
                GI:Rescan()
                break
            end
        end
    elseif (IsInGroup()) then
        for i = 2, 5 do
            if (not UnitExists("party" .. i)) then
                break
            end
            if (not self.cached_players[UnitGUID("party" .. i)]) then
                GI:Rescan()
                break
            end
        end
    end
end

function RCD:PLAYER_REGEN_DISABLED()
    if (self.db.onlyInCombat and self:ShouldShow()) then
        self:Show()
    end
    self:CheckRaidBattleRes()
end

function RCD:ShouldShow()
    local inRaid = IsInRaid()
    local inParty = IsInGroup() and not IsInRaid()

    if (not inRaid and not inParty) then
        return self.db.solo
    end

    if (not inRaid) then
        return self.db.party
    end

    return self.db.raid
end

function RCD:GROUP_ROSTER_UPDATE()
    GI:UpdateCommScope()
    GI:Rescan()
    self:UpdateCDs()
    self:UpdateVisibility(self:ShouldShow())
end

function RCD.PLAYER_ENTERING_WORLD()
    GI:UpdateCommScope()
end

function RCD:UpdateEnableState()
    if (not self.db.enabled) then
        self:Hide()
        self:UnregisterAllEvents()
    else
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterEvent("UNIT_PET", "UpdateCDs")
        self:GROUP_ROSTER_UPDATE()
    end
end

RCD.holders = {}
RCD.cached_players = {}
RCD.bars = {}
RCD.cd_list = {}
RCD.reverse_mappings = {}

function RCD:InitProfile()
    local profile = E.db.nihilistzscheui.raidCDs.cooldowns
    for k, tbl in pairs(self.categories) do
        for _k, _ in pairs(tbl) do
            if profile[k][_k] == nil then
                profile[k][_k] = true
            end
        end
    end
end

function RCD:Initialize()
    NUI:RegisterDB(self, "raidCDs")
    self:InitProfile()

    local ForUpdateAll = function(_self)
        _self:UpdateMedia()
        _self:UpdateEnableState()
    end
    self.ForUpdateAll = ForUpdateAll

    local defaultPoint = {
        aoeCC = {"TOPLEFT", E.UIParent, "TOPLEFT", 0, -22}
    }

    local key = "aoeCC"
    for _, k in ipairs({"externals", "raidCDs", "utilityCDs", "immunities", "interrupts", "battleRes"}) do
        defaultPoint[k] = {"TOPLEFT", "NihilistzscheUIRaidCDs_" .. key .. "Container", "TOPRIGHT", 8, 0}
        key = k
    end
    local holders = {"aoeCC", "externals", "raidCDs", "utilityCDs", "immunities", "interrupts", "battleRes"}
    for _, h in ipairs(holders) do
        self:CreateHolder(h, defaultPoint[h])
    end

    GI:Rescan()

    self.initialized = true

    self:UpdateEnableState()
end

NUI:RegisterModule(RCD:GetName())
