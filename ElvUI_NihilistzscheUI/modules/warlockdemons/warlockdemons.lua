---@class NUI
local NUI, E, L, _, P = _G.unpack((select(2, ...)))

if not E.Retail then return end

local WD = NUI.WarlockDemons
local CandyBar = NUI.Libs.CandyBar
local LSM = E.Libs.LSM
local ES = NUI.EnhancedShadows
local COMP = NUI.Compatibility
local NP = E.NamePlates

local CreateFrame = _G.CreateFrame
local GetCVar = _G.GetCVar
local tremove = _G.tremove
local GetSpecialization = _G.GetSpecialization
local InCombatLockdown = _G.InCombatLockdown
local C_Spell_GetSpellTexture = _G.C_Spell.GetSpellTexture
local hooksecurefunc = _G.hooksecurefunc
local C_Timer_NewTicker = _G.C_Timer.NewTicker
local UnitName = _G.UnitName
local UnitIsFriend = _G.UnitIsFriend
local FindInTableIf = _G.FindInTableIf
local tinsert = _G.tinsert
local GetPetName, GetPetEnergy, GetPetDurationInfo

WD.activeNamePlateGUIDs = {}

function WD:CreateHeader()
    local header = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
    header:Size(self.db.width, self.db.height)
    header:CreateBackdrop("Transparent")

    if COMP.BUI then header:BuiStyle("Outside") end

    local fs = header:CreateFontString(nil, "ARTWORK")
    fs:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
    fs:SetAllPoints()

    fs:SetText(L["Demon Tracking"])
    header.fs = fs

    local container = CreateFrame("Frame", "NihilistzscheUIWarlockDemonsContainer", header, "BackdropTemplate")
    container:SetFrameLevel(header:GetFrameLevel())
    container:SetTemplate("Transparent")
    if ES then
        container:CreateShadow()
        ES:RegisterFrameShadows(container)
    end

    header.Container = container

    header:Point("TOP", E.UIParent, "TOP", 0, -80)
    E:CreateMover(header, "WarlockDemonsMover", L["Demon Tracker"], nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")

    return header
end

function WD:ShouldAttachToNamePlate()
    return NP.UpdatePlateGUID
        and self.db.attachToNamePlate
        and tonumber(GetCVar("nameplateShowFriendlyMinions")) == 1
        and not self.nameplatesForbidden
end

function WD:AttachBarToNamePlate(bar, guid)
    local np = NP.PlateGUID[guid]
    if not np or not np:IsVisible() then
        bar:Hide()
        return
    end
    self.activeNamePlateGUIDs[guid] = bar -- Otherwise well attach when we find one.
    bar:SetParent(nil)
    bar:ClearAllPoints()
    bar:SetParent(np)
    local yOffset = -4
    if GetPetName(guid):find("Imp") then yOffset = -8 end
    bar:SetPoint("TOPLEFT", np.Castbar, "BOTTOMLEFT", 0, yOffset)
    bar:SetPoint("TOPRIGHT", np.Castbar, "BOTTOMRIGHT", 0, yOffset)
    bar:Show()
    self.attachedNPs[np] = true
end

function WD:CreateBar(icon, duration, guid)
    local bar = CandyBar:New(LSM:Fetch("statusbar", self.db.texture), self.db.width, self.db.height)
    bar:SetParent(self.header.Container)
    bar:SetFrameLevel(self.header.Container:GetFrameLevel() + 1)
    bar:SetIcon(icon)
    bar.candyBarBackdrop:SetTemplate("Transparent")
    bar:SetDuration(duration)
    bar.remaining = duration
    bar:SetColor(self.db.color.r, self.db.color.g, self.db.color.b, self.db.alpha)
    bar.candyBarDuration:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
    bar.candyBarLabel:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
    bar.petGUID = guid
    NUI.ResetCandyBarLabelDurationAnchors(bar)
    return bar
end

local remove_queue = {}
local add_queue = {}

function WD:RemoveBar(bar)
    local toRemove = type(bar) == "number" and bar
        or FindInTableIf(self.activeBars, function(v) return v.petGUID == bar.petGUID end)
    if not toRemove then return end
    local guid = self.activeBars[toRemove].petGUID
    self.activeNamePlateGUIDs[guid] = nil
    tinsert(remove_queue, guid)
end

-- from LibCandyBar-3.0,we dont want it returned to the bar cache
local function stopBar(bar)
    bar.updater:Stop()
    bar.running = nil
    bar.paused = nil
end

function WD.RemoveBarByGUID(petGUID)
    local toRemove = FindInTableIf(WD.activeBars, function(v) return v.petGUID == petGUID end)
    if not toRemove then return end
    tremove(WD.activeBars, toRemove)
end

function WD.AddBar(bar) tinsert(WD.activeBars, bar) end

function WD:ResetDemonicTyrantCounts()
    self.demonicTyrantCounts = self.demonicTyrantCounts or {}
    wipe(self.demonicTyrantCounts)
end

function WD:IsValidDemonicTyrantExtension(name)
    local demonInfo = self.demons[name]
    if demonInfo and demonInfo.demonicTyrantValid then
        if type(demonInfo.demonicTyrantValid) == "number" then
            local maxCount = demonInfo.demonicTyrantValid
            local currentCount = self.demonicTyrantCounts[name] or 0
            if currentCount + 1 < maxCount then
                self.demonicTyrantCounts[name] = currentCount + 1
                return true
            end
        else
            return true
        end
    end
    return false
end

local demonicTyrantQueued
local demonicTyrantProcessed
function WD:UpdateBars(isDemonicTyrant)
    if self.updating then
        if isDemonicTyrant then demonicTyrantQueued = true end
        return
    end

    self.updating = true

    local function process(tbl, func)
        local v = tremove(tbl)
        while v do
            func(v)
            v = tremove(tbl)
        end
    end

    process(remove_queue, self.RemoveBarByGUID)
    process(add_queue, self.AddBar)

    if isDemonicTyrant or demonicTyrantQueued then
        self:ResetDemonicTyrantCounts()
        for _, b in ipairs(self.activeBars) do
            if self:IsValidDemonicTyrantExtension(GetPetName(b.petGUID)) then
                local c = b.remaining
                stopBar(b)
                b:SetDuration(c + 15)
                b:Start()
            end
        end
        if demonicTyrantQueued then demonicTyrantProcessed = true end
    end

    if demonicTyrantQueued and demonicTyrantProcessed then
        demonicTyrantQueued = false
        demonicTyrantProcessed = false
    end

    local width = self.db.width
    local height = self.db.height
    local spacing = self.db.spacing

    do
        local seen, unique = {}, {}

        for _, bar in ipairs(self.activeBars) do
            local key = bar.petGUID or bar -- use petGUID if available, else the bar object itself
            if not seen[key] then
                seen[key] = true
                table.insert(unique, bar)
            end
        end

        self.activeBars = unique
    end

    if not self:ShouldAttachToNamePlate() then
        table.sort(self.activeBars, function(a, b)
            if not a then return false end
            if not b then return true end

            local aName = a.petGUID and GetPetName(a.petGUID)
            local bName = b.petGUID and GetPetName(b.petGUID)

            -- Handle missing names
            if not aName and not bName then return false end
            if not aName then return false end
            if not bName then return true end

            -- If same pet name, sort by remaining time ascending
            if aName == bName then return (a.remaining or 0) < (b.remaining or 0) end

            local demons = self.demons
            local aDemon = demons[aName]
            local bDemon = demons[bName]

            -- Handle demon vs non-demon sorting
            if not aDemon and not bDemon then
                return aName < bName -- fallback alphabetical for unknowns
            end
            if not aDemon then return false end
            if not bDemon then return true end

            -- Compare by optionOrder
            return (aDemon.optionOrder or 9999) < (bDemon.optionOrder or 9999)
        end)

        local barsPerColumn = 12
        local numBars = #self.activeBars
        local numColumns = math.ceil(numBars / barsPerColumn)
        local numRows = math.min(numBars, barsPerColumn)

        NUI.ForEach(self.activeBars, function(b) b:ClearAllPoints() end)

        local down, left, header, container =
            self.db.grow == "DOWN", self.db.horizontalGrow == "LEFT", self.header, self.header.Container
        local fp, sp = down and "TOPLEFT" or "BOTTOMLEFT", down and "TOPRIGHT" or "BOTTOMRIGHT"
        container:ClearAllPoints()
        container:SetPoint(fp, header, fp)
        container:SetPoint(sp, header, sp)
        for i, bar in ipairs(self.activeBars) do
            local mod, first, newCol = (i - 1) % barsPerColumn, i == 1, (i - 1) % barsPerColumn == 0 and i > 1
            local anchor = first and self.header or self.activeBars[i - (newCol and barsPerColumn or 1)]
            local xOff = newCol and (left and -spacing or spacing) or 0
            local yOff = first and 0 or ((not newCol) and (down and -spacing or spacing) or 0)
            local p, rp
            if newCol then
                p, rp = left and "RIGHT" or "LEFT", left and "LEFT" or "RIGHT"
            else
                if down then
                    p, rp = left and "TOPRIGHT" or "TOPLEFT", left and "BOTTOMRIGHT" or "BOTTOMLEFT"
                else
                    p, rp = left and "BOTTOMRIGHT" or "BOTTOMLEFT", left and "TOPRIGHT" or "TOPLEFT"
                end
            end
            bar:Point(p, anchor, rp, xOff, yOff)
            if not bar.running then bar:Start() end
        end

        header:Size((width + spacing) * math.max(1, numColumns), height)
        local containerHeight = ((numRows + 1) * height) + (spacing * numRows)
        container:SetHeight(containerHeight)
    else
        for _, b in ipairs(self.activeBars) do
            if not b.running then b:Start() end
            self:AttachBarToNamePlate(b, b.petGUID)
        end
        self.header:Size(width, height)
        self.header.Container:SetHeight(0)
    end

    if #self.activeBars > 0 then
        self.header.fs:SetFormattedText(L["Total Demons: %d"], #self.activeBars)
    else
        self.header.fs:SetText(L["Demon Tracking"])
    end

    self.updating = nil

    -- Did something get queued while we were updating?
    if #remove_queue > 0 or #add_queue > 0 then self:UpdateBars() end
end

function WD:CheckEnabled()
    if E.myclass == "WARLOCK" and GetSpecialization() == 2 and self.db.enabled then
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        self.enabled = true
    else
        self:UnregisterEvent("PLAYER_REGEN_DISABLED")
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        self.header:Hide()
        self.enabled = false
    end
end

function WD:UpdateAll()
    self:CheckEnabled()
    if self.enabled then
        self.header:Size(self.db.width, self.db.height)
        self.header.fs:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
    end
end

function WD:ACTIVE_TALENT_GROUP_CHANGED() self:CheckEnabled() end

function WD:PLAYER_REGEN_ENABLED()
    self.header:Hide()
    self.header.fs:SetText("Demon Count")
end

function WD:NAME_PLATE_UNIT_ADDED(_, unitID)
    if UnitIsFriend("player", unitID) then
        self:UpdateNameplateForbiddenFlag(false)
        self:UpdateBars()
    end
end

function WD:NAME_PLATE_UNIT_REMOVED(_, unitID)
    if UnitIsFriend("player", unitID) and not self.nameplatesForbidden then self:UpdateBars() end
end

function WD:FORBIDDEN_NAME_PLATE_UNIT_ADDED()
    self:UpdateNameplateForbiddenFlag(true)
    self:UpdateBars()
end

function WD:PLAYER_ENTERING_WORLD()
    if not InCombatLockdown() then self.header:Hide() end
end

function WD:PLAYER_REGEN_DISABLED()
    self.header:Show()
    self:UpdateBars()
end

function WD:UpdateNameplateForbiddenFlag(flag) self.nameplatesForbidden = flag end

function WD.UpdateQueuedUpdateNPs()
    for guid in pairs(WD.queuedUpdateGUIDs or {}) do
        local np = NP.PlateGUID[guid]
        if np then NP:StyleFilterUpdate(np, "FAKE_WDForceUpdate") end
    end
end

function WD:InitializeNPHooks()
    E.StyleFilterDefaults.triggers.isDemonologyWarlockDemonNUI = false
    E.StyleFilterDefaults.triggers.isNotDemonologyWarlockDemonNUI = false
    E.StyleFilterDefaults.triggers.demonologyWarlockDemonAboutToExpireNUI = false
    hooksecurefunc(NP, "StyleFilterConfigure", function() NP.StyleFilterTriggerEvents.FAKE_WDForceUpdate = 0 end)
    NP:StyleFilterConfigure()
    self.styleFilterUpdateLoop = C_Timer_NewTicker(1, self.UpdateQueuedUpdateNPs)
    NP:StyleFilterAddCustomCheck("NihilistzscheUI_WarlockDemons", self.StyleFilterCustomCheck)
    self.styleFilterHooked = true
end

local WILD_IMP_ENERGY_COLORS = {
    [5] = { 0.1, 1.0, 0.1 },
    [4] = { 0.1, 1.0, 0.1 },
    [3] = { 1.0, 1.0, 0.0 },
    [2] = { 1.0, 1.0, 0.0 },
    [1] = { 1.0, 0.5, 0.25 },
    [0] = { 1.0, 0.5, 0.25 },
}
function WD:CreateWildImpUpdateClosure(bar, petGUID)
    return function()
        local petEnergy = GetPetEnergy(petGUID)
        if WILD_IMP_ENERGY_COLORS[petEnergy] then
            bar:SetLabel(
                ("%s (%s%s|r)"):format(
                    self:ShouldAttachToNamePlate() and "Remaining" or GetPetName(petGUID),
                    E:RGBToHex(unpack(WILD_IMP_ENERGY_COLORS[petEnergy])),
                    petEnergy
                )
            )
        else
            bar:SetLabel(self:ShouldAttachToNamePlate() and "Remaining (?)" or GetPetName(petGUID) .. " (?)")
        end
    end
end

function WD:QueueNPForUpdate(guid)
    self.queuedUpdateGUIDs = self.queuedUpdateGUIDs or {}
    self.queuedUpdateGUIDs[guid] = true
end

function WD:RemoveNPForUpdate(guid)
    self.queuedUpdateGUIDs = self.queuedUpdateGUIDs or {}
    self.queuedUpdateGUIDs[guid] = nil
end

function WD:IsValidReport(petName)
    if petName:find("Bunny") then return false end
    if petName == self.petName then return false end
    return true
end

function WD:CheckPetName()
    if UnitExists("pet") then
        local petName = UnitName("pet")
        if not self.petName or self.petName ~= petName then self.petName = petName end
    end
end

function WD:DebugReport(petName)
    self:CheckPetName()
    if self:IsValidReport(petName) then NUI:DebugPrint("Unknown demon ", petName, self.petName) end
end

function WD:OnSpawn(petGUID)
    local petName = GetPetName(petGUID)
    if petName == "Unknown" then
        E:Delay(0.2, self.OnSpawn, self, petGUID)
        return
    end

    if not self.demons[petName] then
        E:Delay(2, self.DebugReport, self, petName)
        return
    end
    local demon_info = self.demons[petName]

    local bar = self:CreateBar(demon_info.icon, select(2, GetPetDurationInfo(petGUID)), petGUID)

    local label = self:ShouldAttachToNamePlate() and "Remaining" or petName
    if petName:find("Imp") then
        local petEnergy = GetPetEnergy(petGUID)
        label = ("%s (%s%s|r)"):format(
            self:ShouldAttachToNamePlate() and "Remaining" or petName,
            WILD_IMP_ENERGY_COLORS[petEnergy] and E:RGBToHex(unpack(WILD_IMP_ENERGY_COLORS[petEnergy]))
                or E:RGBToHex(1, 1, 1),
            petEnergy
        )
        bar:AddUpdateFunction(WD:CreateWildImpUpdateClosure(bar, petGUID))
    end
    if self.styleFilterHooked then self:QueueNPForUpdate(petGUID) end
    bar:SetLabel(label)
    table.insert(add_queue, bar)
    self:UpdateBars(petName == "Demonic Tyrant")
end

function WD:OnDespawn(petGUID)
    self:RemoveNPForUpdate(petGUID)
    for i, b in ipairs(self.activeBars) do
        if b.petGUID == petGUID then
            b:Stop()
            if not self:ShouldAttachToNamePlate() then
                tinsert(remove_queue, b.petGUID)
            else
                local np = NP.PlateGUID[petGUID]
                if np then NP:StyleFilterUpdate(np, "FAKE_WDForceUpdate") end
                self.RemoveBarByGUID(petGUID)
            end
            break
        end
    end
    self:UpdateBars()
end

function WD.StyleFilterCustomCheck(frame, _, trigger)
    local passed = nil
    if _G.UnitIsUnit(frame.unit, "pet") then return false end
    if trigger.isDemonologyWarlockDemonNUI or trigger.isNotDemonologyWarlockDemonNUI then
        local guid = frame.unitGUID
        if guid then
            local petName = GetPetName(guid)
            local isDemonologyWarlockDemonNUI = petName and WD.demons[petName]
            if
                trigger.isDemonologyWarlockDemonNUI and isDemonologyWarlockDemonNUI
                or trigger.isNotDemonologyWarlockDemonNUI and not isDemonologyWarlockDemonNUI
            then
                passed = true
            else
                return false
            end
        end
    end
    if trigger.demonologyWarlockDemonAboutToExpireNUI then
        local guid = frame.unitGUID
        if guid then
            local petName = GetPetName(guid)
            local barIndex = FindInTableIf(WD.activeBars, function(b) return b.petGUID == guid end)
            if not barIndex then return false end
            if (petName:find("Imp") and (GetPetEnergy(guid) < 3)) or WD.activeBars[barIndex].remaining < 5 then
                passed = true
            else
                return false
            end
        end
    end
    return passed
end

WD.demons = {
    ["Wild Imp"] = {
        icon = C_Spell_GetSpellTexture(205145),
        optionOrder = 2,
        demonicTyrantValid = 10,
    },
    ["Demonic Tyrant"] = { icon = C_Spell_GetSpellTexture(265187), optionOrder = 1 },
    Dreadstalker = { icon = C_Spell_GetSpellTexture(104316), optionOrder = 3, demonicTyrantValid = true },
    ["Greater Dreadstalker"] = {
        icon = C_Spell_GetSpellTexture(104316),
        optionOrder = 4,
        demonicTyrantValid = true,
    },
    Felguard = { icon = C_Spell_GetSpellTexture(111898), optionOrder = 5, demonicTyrantValid = true },
    Bilescourge = { icon = C_Spell_GetSpellTexture(267992), optionOrder = 14 },
    Vilefiend = { icon = C_Spell_GetSpellTexture(264119), optionOrder = 13, demonicTyrantValid = true },
    ["Prince Malchezaar"] = { icon = C_Spell_GetSpellTexture(267986), optionOrder = 6 },
    ["Illidari Satyr"] = { icon = C_Spell_GetSpellTexture(267987), optionOrder = 15 },
    ["Vicious Hellhound"] = { icon = C_Spell_GetSpellTexture(267988), optionOrder = 16 },
    ["Eye of Gul'dan"] = { icon = C_Spell_GetSpellTexture(267989), optionOrder = 17 },
    ["Void Terror"] = { icon = C_Spell_GetSpellTexture(267991), optionOrder = 18 },
    Shivarra = { icon = C_Spell_GetSpellTexture(267994), optionOrder = 19 },
    Wrathguard = { icon = C_Spell_GetSpellTexture(267995), optionOrder = 20 },
    Darkhound = { icon = C_Spell_GetSpellTexture(267996), optionOrder = 21 },
    ["Ur'zul"] = { icon = C_Spell_GetSpellTexture(268001), optionOrder = 22 },
    ["Fel Lord"] = { icon = C_Spell_GetSpellTexture(212459), optionOrder = 23 },
    Observer = { icon = C_Spell_GetSpellTexture(201996), optionOrder = 24 },
    ["Imp Gang Boss"] = { icon = C_Spell_GetSpellTexture(387445), optionOrder = 25 },
    Soulkeeper = { icon = C_Spell_GetSpellTexture(386244), optionOrder = 26 },
    ["Pit Lord"] = { icon = C_Spell_GetSpellTexture(138787), optionOrder = 27 },
    ["Mother of Chaos"] = { icon = C_Spell_GetSpellTexture(432794), optionOrder = 28 },
    Overlord = { icon = C_Spell_GetSpellTexture(428524), optionOrder = 29 },
    Gloomhound = { icon = C_Spell_GetSpellTexture(455465), optionOrder = 30, demonicTyrantValid = true },
    Charhound = { icon = C_Spell_GetSpellTexture(455476), optionOrder = 31, demonicTyrantValid = true },
    Doomguard = { icon = C_Spell_GetSpellTexture(18540), optionOrder = 32 },
    ["Infernal Dreadlord"] = { icon = C_Spell_GetSpellTexture(1237711), optionOrder = 33 },
    ["Dreamweaver"] = { icon = C_Spell_GetSpellTexture(1242114), optionOrder = 34 },
    ["Infernal Flayer"] = { icon = C_Spell_GetSpellTexture(1242368), optionOrder = 35 },
    ["Infernal Jailer"] = { icon = C_Spell_GetSpellTexture(1242391), optionOrder = 36 },
    ["Infernal Inquisitor"] = { icon = C_Spell_GetSpellTexture(1242276), optionOrder = 37 },
}

for k in next, WD.demons do
    P.nihilistzscheui.warlockdemons.demons[k] = { enable = true }
end

function WD:Initialize()
    if E.myclass ~= "WARLOCK" or not COMP.ZP then return end
    NUI:RegisterDB(self, "warlockdemons")
    local ForUpdateAll = function(_self) _self:UpdateAll() end
    self.ForUpdateAll = ForUpdateAll

    self.activeBars = {}
    self.attachedNPs = {}

    self.header = self:CreateHeader()

    _G.zPets.RegisterPetEvent("OnSpawn", function(petGUID) WD:OnSpawn(petGUID) end)
    _G.zPets.RegisterPetEvent("OnDespawn", function(petGUID) WD:OnDespawn(petGUID) end)

    GetPetName = _G.zPets.GetPetName
    GetPetEnergy = _G.zPets.GetPetEnergy
    GetPetDurationInfo = _G.zPets.GetPetDurationInfo

    self:InitializeNPHooks()

    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED")
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    self:CheckEnabled()
end

NUI:RegisterModule(WD:GetName())
