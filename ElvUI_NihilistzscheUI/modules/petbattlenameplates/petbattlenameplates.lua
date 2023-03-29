local NUI, E = _G.unpack((select(2, ...)))
if not E.Retail then return end
local PBN = NUI.PetBattleNameplates
local NP = E.NamePlates
local UF = E.UnitFrames
local BattlePetBreedID = _G.IsAddOnLoaded("BattlePetBreedID")
local COMP = NUI.Compatibility

local Enum_BattlePetOwner_Ally = _G.Enum.BattlePetOwner.Ally
local Enum_BattlePetOwner_Enemy = _G.Enum.BattlePetOwner.Enemy
local SetCVar = _G.SetCVar
local GetCVar = _G.GetCVar
local C_PetBattles_GetAuraInfo = _G.C_PetBattles.GetAuraInfo
local C_PetBattles_GetAbilityInfoByID = _G.C_PetBattles.GetAbilityInfoByID
local C_PetBattles_IsInBattle = _G.C_PetBattles.IsInBattle
local C_PetBattles_GetActivePet = _G.C_PetBattles.GetActivePet
local C_PetBattles_GetNumPets = _G.C_PetBattles.GetNumPets
local C_Timer_After = _G.C_Timer.After
local wipe = _G.wipe
local tinsert = _G.tinsert
local UnitGUID = _G.UnitGUID
local hooksecurefunc = _G.hooksecurefunc

PBN.CVarCache = {}

function PBN:PET_BATTLE_CLOSE()
    for cvar, value in next, self.CVarCache do
        SetCVar(cvar, value)
    end
    wipe(self.CVarCache)
end

function PBN:PET_BATTLE_OPENING_START()
    local function CacheCVarAndSet(cvar, newValue, firstValue)
        if not self.CVarCache[cvar] then self.CVarCache[cvar] = GetCVar(cvar) end
        if firstValue then
            SetCVar(cvar, firstValue)
            C_Timer_After(1, function() SetCVar(cvar, newValue) end)
        else
            SetCVar(cvar, newValue)
        end
    end
    CacheCVarAndSet("nameplateShowFriendlyNPCs", self.db.enable and "1" or "0", "0")
    CacheCVarAndSet("nameplateShowAll", self.db.enable and "1" or "0", "0")
    CacheCVarAndSet("nameplateOccludedAlphaMult", "1")
end

PBN.seenGUIDs = {}
PBN.handledNameplates = {}

function PBN:UpdatePlateGUID()
    if not C_PetBattles_IsInBattle() then return end
    local lowestIDValue = nil

    for guid, _ in pairs(self.PlateGUID) do
        if not PBN.seenGUIDs[guid] and guid:sub(1, 11) == "ClientActor" then
            local ID = tonumber(guid:sub(17, -1))
            if ID then lowestIDValue = math.min(lowestIDValue or 4340000000000, ID) end
        end
        PBN.seenGUIDs[guid] = true
    end

    if not lowestIDValue then return end

    local oldIDNumber = PBN.lowestIDValue
    PBN.lowestIDValue = math.min(PBN.lowestIDValue or 4340000000000, lowestIDValue)
    if oldIDNumber and PBN.lowestIDValue >= oldIDNumber then return end

    local myPets = C_PetBattles_GetNumPets(Enum_BattlePetOwner_Ally)
    local theirPets = C_PetBattles_GetNumPets(Enum_BattlePetOwner_Enemy)
    local guidID
    wipe(PBN.myPets)
    for i = 1, myPets do
        local pet = { petOwner = Enum_BattlePetOwner_Ally, petIndex = i }
        guidID = PBN.lowestIDValue + (i - 1)
        pet.GUID = string.format("ClientActor-6-0-%d", guidID)
        PBN:UpdateNamePlate(pet)
        tinsert(PBN.myPets, pet)
    end

    wipe(PBN.theirPets)
    for i = 1, theirPets do
        local pet = { petOwner = Enum_BattlePetOwner_Enemy, petIndex = i }
        guidID = PBN.lowestIDValue + (i + (myPets - 1))
        pet.GUID = string.format("ClientActor-6-0-%d", guidID)
        PBN:UpdateNamePlate(pet)
        tinsert(PBN.theirPets, pet)
    end
end

function PBN.GetNamePlateForPet(pet)
    if pet.GUID then
        return NP.PlateGUID[pet.GUID]
    else
        return nil
    end
end

-- Borrowed from ElvUI so we can force some things
-- PBN changes are just removing the db check for power and power text
-- and forcing them on
function PBN:Update_Power(nameplate)
    local db = self.db.units.FRIENDLY_NPC

    if not nameplate:IsElementEnabled("Power") then nameplate:EnableElement("Power") end

    nameplate.Power:Point("CENTER", nameplate, "CENTER", db.power.xOffset, db.power.yOffset)

    E:SetSmoothing(nameplate.Power, NP.db.smoothbars)

    nameplate.Power.Text:ClearAllPoints()
    nameplate.Power.Text:Point(
        E.InversePoints[db.power.text.position],
        db.power.text.parent == "Nameplate" and nameplate or nameplate[db.power.text.parent],
        db.power.text.position,
        db.power.text.xOffset,
        db.power.text.yOffset
    )
    nameplate.Power.Text:FontTemplate(
        E.Libs.LSM:Fetch("font", db.power.text.font),
        db.power.text.fontSize,
        db.power.text.fontOutline
    )
    nameplate.Power.Text:Show()

    nameplate:Tag(nameplate.Power.Text, db.power.text.format)

    nameplate.Power.displayAltPower = db.power.displayAltPower
    nameplate.Power.useAtlas = db.power.useAtlas
    nameplate.Power.colorClass = db.power.useClassColor
    nameplate.Power.colorPower = not db.power.useClassColor
    nameplate.Power.width = db.power.width
    nameplate.Power.height = db.power.height
    nameplate.Power:Size(db.power.width, db.power.height)
end

local C_PetBattles_GetHealth = _G.C_PetBattles.GetHealth
local C_PetBattles_GetMaxHealth = _G.C_PetBattles.GetMaxHealth
local C_PetBattles_GetXP = _G.C_PetBattles.GetXP
local C_PetBattles_GetLevel = _G.C_PetBattles.GetLevel

PBN.PetInfoByGUID = {}
PBN.LastSeenHealthValueForNP = {}

local function closureFunc(self)
    self.ready = nil
    self.playing = nil
    self.cur = nil
    self.enabled = false
    self:Hide()
end

local function startFunc(self)
    self.enabled = true
    self:Show()
end

function PBN:NamePlate_UpdateHealth(pet, np)
    local health = C_PetBattles_GetHealth(pet.petOwner, pet.petIndex)
    if self.LastSeenHealthValueForNP[np] == health then
        np.Cutaway.Health:Hide()
        return
    end
    local maxHealth = C_PetBattles_GetMaxHealth(pet.petOwner, pet.petIndex)
    if np.__nui_pbn_cutawayEnabled then
        local h = np.Cutaway.Health
        if not h.__nui_pbn_fadeobject then
            h.__nui_pbn_fadeobject = {
                finishedFuncKeep = true,
                finishedArg1 = h,
                finishedFunc = closureFunc,
                __nui_pbn_fadeobject = true,
            }
            h.__orig_fadeobject = h.FadeObject
            h.FadeObject = h.__nui_pbn_fadeoject
        end
        if health <= (self.LastSeenHealthValueForNP[np] or 1) then startFunc(h) end
    end
    np.Health:ForceUpdate()
    if not COMP.PA then np.Health.Text:SetText(E:GetFormattedText("PERCENT", health, maxHealth)) end
    self.LastSeenHealthValueForNP[np] = health
end

function PBN:NamePlate_UpdateXP(pet, np)
    self.Update_Power(NP, np)
    local xp, maxXP = C_PetBattles_GetXP(pet.petOwner, pet.petIndex)
    local level = C_PetBattles_GetLevel(pet.petOwner, pet.petIndex)
    local powerShown = false
    if pet.petOwner == Enum_BattlePetOwner_Ally and level < 25 then
        np.Power:SetMinMaxValues(0, maxXP)
        np.Power:SetValue(xp)
        np.Power:SetStatusBarColor(0.24, 0.54, 0.78)
        np.Power:SetStatusBarTexture(E.media.normTex)
        if not COMP.PA then np.Power.Text:SetFormattedText("%d / %d", xp, maxXP) end
        powerShown = true
        np.Power:Show()
        if np.Power.Text.__nui_Show then
            np.Power.Text.Show = np.Power.Text.__nui_Show
            np.Power.Text.__nui_Show = nil
        end
        np.Power.Text:Show()
    else
        np.Power.Text:Hide()
        np.Power:Hide()
        if not np.Power.Text.__nui_Show then np.Power.Text.__nui_Show = np.Power.Text.Show end
        np.Power.Text.Show = E.noop
    end
    return powerShown
end

function PBN:NamePlate_UpdateBreedInfo(pet, np, powerShown)
    if BattlePetBreedID and self.db.showBreedID then
        if not COMP.PA then np.Title:SetText(_G.GetBreedID_Battle(pet)) end
        np.Title:ClearAllPoints()
        np.Title:SetPoint("CENTER", np, "CENTER", 0, powerShown and -26 or -14)
        np.Title:Show()
    end
end

function PBN.PostUpdateAura(_, button)
    if not C_PetBattles_IsInBattle() then return end
    if button.__nui_pbn_shown then button:Show() end
end

function PBN:NameplateHealthOverride(_, unit)
    if not unit or self.unit ~= unit then return end
    local info = self.pbouf_petinfo
    if not info then return end

    local element = self.Health

    --[[ Callback: Health:PreUpdate(unit)
	Called before the element has been updated.

	* self - the Health element
	* unit - the unit for which the update has been triggered (string)
	--]]
    if element.PreUpdate then element:PreUpdate(unit) end

    local cur, max =
        C_PetBattles_GetHealth(info.petOwner, info.petIndex), C_PetBattles_GetMaxHealth(info.petOwner, info.petIndex)

    element:SetMinMaxValues(0, max)

    element:SetValue(cur)

    element.cur = cur
    element.max = max

    --[[ Callback: Health:PostUpdate(unit, cur, max)
	Called after the element has been updated.

	* self - the Health element
	* unit - the unit for which the update has been triggered (string)
	* cur  - the unit's current health value (number)
	* max  - the unit's maximum possible health value (number)
	--]]
    if element.PostUpdate then element:PostUpdate(unit, cur, max) end
end

function PBN:GetHealthMax()
    local guid = UnitGUID(self)
    local np = NP.PlateGUID[guid]
    if not np then return 0 end
    local info = np.pbouf_petinfo
    if not info then return end
    return C_PetBattles_GetMaxHealth(info.petOwner, info.petIndex)
end

function PBN:ConstructBuffs(frame, petOwner, petIndex)
    local buffs = CreateFrame("Frame", nil, frame)
    buffs.size = 26
    buffs.num = 5
    buffs.numRow = 9
    buffs.spacing = 2
    buffs.PostCreateIcon = self.PostCreateAura
    return buffs
end

function PBN:ConstructDebuffs(frame, petOwner, petIndex)
    local debuffs = CreateFrame("Frame", nil, frame)
    debuffs.size = 26
    debuffs.num = 5
    debuffs.spacing = 2
    debuffs.isDebuff = true
    debuffs.PostCreateIcon = self.PostCreateAura
    return debuffs
end

function PBN:PostCreateAura(button)
    button:SetTemplate()

    local Font, FontSize, FontFlag = PA.LSM:Fetch("font", EPB.db["Font"]), EPB.db["FontSize"], EPB.db["FontFlag"]
    button.turnsRemaining:SetFont(Font, FontSize, FontFlag)
    button.icon:SetTexCoord(unpack(E.TexCoords))
    button.icon:SetInside()
    button:SetBackdropBorderColor(unpack(self.isDebuff and { 1, 0, 0 } or { 0, 1, 0 }))
end

function PBN:InitNameplate(np)
    if np.__nui_pbn_init then return end

    if np.__nui_pbn_questIconEnabled == nil then np.__nui_pbn_questIconEnabled = np:IsElementEnabled("QuestIcons") end
    if np:IsElementEnabled("QuestIcons") then np:DisableElement("QuestIcons") end
    if np.__nui_pbn_faderEnabled == nil then np.__nui_pbn_faderEnabled = np:IsElementEnabled("Fader") end
    if np:IsElementEnabled("Fader") then np:DisableElement("Fader") end
    if np.__nui_pbn_cutawayEnabled == nil then np.__nui_pbn_cutawayEnabled = np:IsElementEnabled("Cutaway") end
    if np:IsElementEnabled("Cutaway") then np:DisableElement("Cutaway") end
    if not np.Cutaway.Health.GetHealthMax then np.Cutaway.Health.GetHealthMax = PBN.GetHealthMax end
    if not np.Health.Override then np.Health.Override = self.NameplateHealthOverride end
    if not np.PBBuffs then
        np.PBBuffs = self:ConstructBuffs(np, np.pbouf_petinfo.petOwner, np.pbouf_petinfo.petIndex)
    end
    if not np.PBDebuffs then
        np.PBDebuffs = self:ConstructDebuffs(np, np.pbouf_petinfo.petOwner, np.pbouf_petinfo.petIndex)
    end
    np.__nui_pbn_init = true
end

function PBN:Configure_Auras(frame, element, db)
    local petInfo = frame.pbouf_petinfo
    if not petInfo then return end
    if not element.isDebuff then
        element.initialAnchor = petInfo.petOwner == Enum_BattlePetOwner_Ally and "TOPLEFT" or "TOPRIGHT"
        element["growth-y"] = "DOWN"
        element["growth-x"] = petInfo.petOwner == Enum_BattlePetOwner_Ally and "RIGHT" or "LEFT"
    else
        element.initialAnchor = petInfo.petOwner == Enum_BattlePetOwner_Ally and "TOPRIGHT" or "TOPLEFT"
        element["growth-y"] = "DOWN"
        element["growth-x"] = petInfo.petOwner == Enum_BattlePetOwner_Ally and "LEFT" or "RIGHT"
    end
    NP:Configure_Auras(frame, element, db)
    element.num = 5
end

function PBN:UpdateNamePlate(pet)
    local np = self.GetNamePlateForPet(pet)
    if not np then return end

    np.pbouf_petinfo = { petOwner = pet.petOwner, petIndex = pet.petIndex }
    np.frameType = "ENEMY_NPC"
    self:InitNameplate(np)

    self:NamePlate_UpdateHealth(pet, np)

    -- XP uses the nameplates power bar
    local powerShown = self:NamePlate_UpdateXP(pet, np)

    -- Breed Info uses the nameplates title field
    self:NamePlate_UpdateBreedInfo(pet, np, powerShown)

    PBN:Configure_Auras(np, np.PBBuffs, NP:PlateDB(np).buffs)
    PBN:Configure_Auras(np, np.PBDebuffs, NP:PlateDB(np).debuffs)

    NP:StyleFilterUpdate(np, "FAKE_PBNForceUpdate")

    PBN.handledNameplates[np] = true
end

function PBN:ResetNameplates()
    for np in pairs(self.handledNameplates) do
        if np.__nui_pbn_questIconEnabled then np:EnableElement("QuestIcons") end
        np.__nui_pbn_questIconEnabled = nil
        if np.__nui_pbn_faderEnabled then np:EnableElement("Fader") end
        np.__nui_pbn_faderEnabled = nil
        if np.__nui_pbn_cutawayEnabled then np:EnableElement("Cutaway") end
        np.__nui_pbn_cutawayEnabled = nil
        np.Health.Override = nil
        local h = np.Cutaway.Health
        if h.FadeObject and h.FadeObject.__nui_pbn_fadeobject then h.FadeObject = h.__orig_fadeobject end
        h.GetHealthMax = nil
        if np.Power.Text.__nui_Show then np.Power.Text.Show = np.Power.Text.__nui_Show end
        np.pbouf_petinfo = nil
        np.__nui_pbn_init = nil
    end
    wipe(self.handledNameplates)
    wipe(self.seenGUIDs)
    wipe(self.myPets)
    wipe(self.theirPets)
    wipe(self.PetInfoByGUID)
    wipe(self.LastSeenHealthValueForNP)
    PBN.TickerFrame:SetScript("OnUpdate", nil)
    self.lowestIDValue = nil
    NP:ConfigureAll()
end

PBN.StyleFilterTriggerDefaults = {
    isBattlePet = false,
    isNotBattlePet = false,
    isAllyBattlePet = false,
    isEnemyBattlePet = false,
    isActiveBattlePet = false,
    isNotActiveBattlePet = false,
}

function PBN:AddNPStyleFilterTriggerDefaults()
    for k, v in pairs(self.StyleFilterTriggerDefaults) do
        E.StyleFilterDefaults.triggers[k .. "PBN"] = v
    end
end

function PBN.TickerFrameOnUpdate(self, elapsed)
    if (self.elapsed or 0) + elapsed > 0.5 then
        for plate in pairs(PBN.handledNameplates) do
            NP:StyleFilterUpdate(plate, "FAKE_PBNForceUpdate")
        end
        self.elapsed = 0
    else
        self.elapsed = (self.elapsed or 0) + elapsed
    end
end

function PBN:CheckActions(frame, actions)
    if
        actions.show
        and (not InCombatLockdown() and not UnitAffectingCombat("player") and not UnitAffectingCombat("pet"))
    then
        frame:Show()
    end
end

function PBN:InitializeNPHooks()
    self:AddNPStyleFilterTriggerDefaults()
    E.StyleFilterDefaults.triggers.instanceType.petBattle = false
    hooksecurefunc(NP, "StyleFilterConfigure", function() NP.StyleFilterTriggerEvents.FAKE_PBNForceUpdate = 0 end)
    E.StyleFilterDefaults.actions.show = false
    NP:StyleFilterConfigure()
    NP:StyleFilterAddCustomCheck("PBNStyleFilter", self.StyleFilterCustomCheck)
    hooksecurefunc(UF, "PostUpdateAura", self.PostUpdateAura)
    hooksecurefunc(NP, "StyleFilterSetChanges", self.CheckActions)
    PBN.TickerFrame = CreateFrame("Frame")
end

function PBN.StyleFilterCustomCheck(frame, _, trigger)
    local passed = nil
    if trigger.isBattlePetPBN or trigger.isNotBattlePetPBN then
        local guid = UnitGUID(frame.unit)
        local isBattlePet = guid and guid:sub(1, 11) == "ClientActor"
        if trigger.isBattlePetPBN and isBattlePet or trigger.isNotBattlePetPBN and not isBattlePet then
            passed = true
        else
            return false
        end
    end
    if trigger.isAllyBattlePetPBN or trigger.isEnemyBattlePetPBN then
        local petInfo = frame.pbouf_petinfo
        if not petInfo then return false end
        if
            trigger.isAllyBattlePetPBN and petInfo.petOwner == Enum_BattlePetOwner_Ally
            or trigger.isEnemyBattlePetPBN and petInfo.petOwner == Enum_BattlePetOwner_Enemy
        then
            passed = true
        else
            return false
        end
    end
    if trigger.isActiveBattlePetPBN or trigger.isNotActiveBattlePetPBN then
        local petInfo = frame.pbouf_petinfo
        if not petInfo then return false end
        local isActivePet = petInfo.petIndex == C_PetBattles_GetActivePet(petInfo.petOwner)
        if trigger.isActiveBattlePetPBN and isActivePet or trigger.isNotActiveBattlePetPBN and not isActivePet then
            passed = true
        else
            return false
        end
    end
    if trigger.instanceType and trigger.instanceType.petBattle then passed = C_PetBattles_IsInBattle() end
    return passed
end

function PBN:Update(event)
    if self[event] then self[event](self) end
    if event == "PET_BATTLE_CLOSE" and not C_PetBattles_IsInBattle() then
        self:ResetNameplates()
    else
        PBN.UpdatePlateGUID(NP)
        for _, tbl in pairs({ self.myPets, self.theirPets }) do
            for _, pet in ipairs(tbl) do
                self:UpdateNamePlate(pet)
            end
        end
        if not self.TickerFrame:GetScript("OnUpdate") then
            self.TickerFrame:SetScript("OnUpdate", self.TickerFrameOnUpdate)
        end
    end
    for plate in pairs(NP.Plates) do
        NP:StyleFilterUpdate(plate, "FAKE_PBNForceUpdate")
    end
end

function PBN:Initialize()
    if _G.EPB then
        hooksecurefunc(_G.EPB, "ChangePetBattlePetSelectionFrameState", function()
            for np in pairs(self.handledNameplates) do
                NP:StyleFilterUpdate(np, "FAKE_PBNForceUpdate")
            end
        end)
    end
    self.myPets = {}
    self.theirPets = {}
    local events = {
        "PET_BATTLE_ACTION_SELECTED",
        "PET_BATTLE_MAX_HEALTH_CHANGED",
        "PET_BATTLE_HEALTH_CHANGED",
        "PET_BATTLE_LEVEL_CHANGED",
        "PET_BATTLE_AURA_APPLIED",
        "PET_BATTLE_AURA_CANCELED",
        "PET_BATTLE_AURA_CHANGED",
        "PET_BATTLE_XP_CHANGED",
        "PET_BATTLE_OPENING_START",
        "PET_BATTLE_OPENING_DONE",
        "PET_BATTLE_CAPTURED",
        "PET_BATTLE_OVER",
        "PET_BATTLE_PET_CHANGED",
        "PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE",
        "PET_BATTLE_PET_ROUND_RESULTS",
        "PET_BATTLE_CLOSE",
    }
    for _, event in ipairs(events) do
        self:RegisterEvent(event, "Update")
    end

    self.db = E.db.nihilistzscheui.petbattlenameplates
    hooksecurefunc(NP, "UpdatePlateGUID", self.UpdatePlateGUID)
    self:InitializeNPHooks()
end

NUI:RegisterModule(PBN:GetName())
