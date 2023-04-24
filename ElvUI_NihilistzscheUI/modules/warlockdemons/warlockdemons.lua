local NUI, E, L = _G.unpack((select(2, ...)))

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
local GetSpellTexture = _G.GetSpellTexture
local hooksecurefunc = _G.hooksecurefunc
local C_Timer_After = _G.C_Timer.After
local C_Timer_NewTicker = _G.C_Timer.NewTicker
local strmatch = _G.strmatch
local UnitName = _G.UnitName
local UnitIsFriend = _G.UnitIsFriend
local FindInTableIf = _G.FindInTableIf
local tinsert = _G.tinsert
local InPetBattle = _G.C_PetBattles.IsInBattle
local GetPetName

WD.activeNamePlateGUIDs = {}

function WD:CreateHeader()
    local header = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
    header:Size(self.db.width, self.db.height)
    header:CreateBackdrop("Transparent")

    if COMP.MERS then header:Styling() end

    if COMP.BUI then header:BuiStyle("Outside") end

    local fs = header:CreateFontString(nil, "ARTWORK")
    fs:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
    fs:SetAllPoints()

    fs:SetText(L["Demon Tracking"])
    header.fs = fs

    local container = CreateFrame("Frame", "NihilistzscheUIWarlockDemonsContainer", header, "BackdropTemplate")
    container:SetFrameLevel(header:GetFrameLevel())
    local fp, sp =
        self.db.grow == "DOWN" and "TOP" or "BOTTOMLEFT", self.db.grow == "DOWN" and "TOPRIGHT" or "BOTTOMRIGHT"
    container:SetPoint(fp, header, fp)
    container:SetPoint(sp, header, sp)
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
    if _G.zPets.GetPetName(guid):find("Imp") then yOffset = -8 end
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
    if COMP.MERS then bar:Styling() end
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
    tinsert(remove_queue, toRemove)
end

-- from LibCandyBar-3.0,we dont want it returned to the bar cache
local function stopBar(bar)
    bar.updater:Stop()
    bar.running = nil
    bar.paused = nil
end

function WD.RemoveBarByIndex(index) tremove(WD.activeBars, index) end

function WD.AddBar(bar) tinsert(WD.activeBars, bar) end

function WD:UpdateBars(isDemonicTyrant)
    if self.updating then return end

    self.updating = true

    local bars = self.activeBars

    local function process(tbl, func)
        local v = tremove(tbl)
        while v do
            func(v)
            v = tremove(tbl)
        end
    end

    table.sort(remove_queue, function(a, b) return b < a end)
    process(remove_queue, self.RemoveBarByIndex)
    process(add_queue, self.AddBar)

    if isDemonicTyrant then
        for _, b in ipairs(bars) do
            local start, duration = _G.GetSpellCooldown(265187)
            local mod = 4
            if start > 0 and duration > 0 then
                local running = _G.GetTime() - start
                if running < 5 then -- give 5 sec buffer for the bars to update but if this takes
                    mod = 15
                end
            end
            if _G.zPets.GetPetName(b.petGUID) ~= "Demonic Tyrant" then
                local c = b.remaining
                stopBar(b)
                b:SetDuration(c + mod)
                b:Start()
            end
        end
    end

    if not self:ShouldAttachToNamePlate() then
        local growingDown = self.db.grow == "DOWN"
        local point, relativePoint, yOffset, newColumnRelativePoint
        if growingDown then
            point = "TOPLEFT"
            relativePoint = "BOTTOMLEFT"
            newColumnRelativePoint = "TOPRIGHT"
            yOffset = -self.db.spacing
        else
            point = "BOTTOMLEFT"
            relativePoint = "TOPLEFT"
            newColumnRelativePoint = "BOTTOMRIGHT"
            yOffset = self.db.spacing
        end

        table.sort(bars, function(a, b)
            local aName = a and GetPetName(a.petGUID)
            local bName = b and GetPetName(b.petGUID)
            if not aName then
                return bName ~= nil
            elseif not bName then
                return true
            end
            if aName == bName then return a.remaining < b.remaining end
            if not self.demons[aName] then
                return self.demons[bName] ~= nil
            elseif not self.demons[bName] then
                return true
            else
                return self.demons[aName].priority < self.demons[bName].priority
            end
        end)

        NUI.ForEach(bars, function(b) b:ClearAllPoints() end)
        local barsPerColumn = 12
        local numColumns = math.ceil(#bars / barsPerColumn)
        local numRows = math.min(#bars, barsPerColumn)
        for i, b in ipairs(bars) do
            if i == 1 then
                pcall(b.Point, b, point, self.header, relativePoint, 0, yOffset)
            elseif (i - 1) % barsPerColumn == 0 then
                pcall(b.Point, b, point, bars[i - barsPerColumn], newColumnRelativePoint, 0, 0)
            else
                pcall(b.Point, b, point, bars[i - 1], relativePoint, 0, yOffset)
            end
            if not b.running then b:Start() end
        end
        self.header:Size(self.db.width * math.max(1, numColumns), self.db.height)
        local height = ((numRows + 1) * self.db.height) + (self.db.spacing * numRows)
        self.header.Container:SetHeight(height)
    else
        for _, b in ipairs(bars) do
            if not b.running then b:Start() end
            self:AttachBarToNamePlate(b, b.petGUID)
        end
        self.header:Size(self.db.width, self.db.height)
        self.header.Container:SetHeight(0)
    end

    if #bars > 0 then
        self.header.fs:SetFormattedText(L["Total Demons: %d"], #bars)
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
    E.StyleFilterDefaults.triggers.isNotDemonologyWarlockDemonUI = false
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
        local petEnergy = _G.zPets.GetPetEnergy(petGUID)
        if WILD_IMP_ENERGY_COLORS[petEnergy] then
            bar:SetLabel(
                ("%s (%s%s|r)"):format(
                    self:ShouldAttachToNamePlate() and "Remaining" or _G.zPets.GetPetName(petGUID),
                    E:RGBToHex(unpack(WILD_IMP_ENERGY_COLORS[petEnergy])),
                    petEnergy
                )
            )
        else
            bar:SetLabel(self:ShouldAttachToNamePlate() and "Remaining (?)" or _G.zPets.GetPetName(petGUID) .. " (?)")
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

local closures = {}
local function CreateWDRespawnClosure(petGUID)
    if closures[petGUID] then return closures[petGUID] end
    local closure = function() WD:OnSpawn(petGUID) end
    closures[petGUID] = closure
    return closure
end

function WD:OnSpawn(petGUID)
    local petName = GetPetName(petGUID)
    if petName == "Unknown" then
        C_Timer_After(0.2, CreateWDRespawnClosure(petGUID))
        return
    end

    if not (self.demons[petName] and petName ~= UnitName("pet")) then
        NUI:DebugPrint("Unknown demon ", petName)
        return
    end
    local demon_info = self.demons[petName]

    local bar = self:CreateBar(demon_info.icon, select(2, _G.zPets.GetPetDurationInfo(petGUID)), petGUID)

    local label = self:ShouldAttachToNamePlate() and "Remaining" or petName
    if petName:find("Imp") then
        local petEnergy = _G.zPets.GetPetEnergy(petGUID)
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
    self:UpdateBars(GetPetName(petGUID) == "Demonic Tyrant")
end

function WD:OnDespawn(petGUID)
    self:RemoveNPForUpdate(petGUID)
    for i, b in ipairs(self.activeBars) do
        if b.petGUID == petGUID then
            b:Stop()
            self.RemoveBarByIndex(i)
            local np = NP.PlateGUID[petGUID]
            if np then NP:StyleFilterUpdate(np, "FAKE_WDForceUpdate") end
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
            if (petName:find("Imp") and (_G.zPets.GetPetEnergy(guid) < 3)) or WD.activeBars[barIndex].remaining < 5 then
                passed = true
            else
                return false
            end
        end
    end
    return passed
end

function WD:Initialize()
    if E.myclass ~= "WARLOCK" or not COMP.ZP then return end
    NUI:RegisterDB(self, "warlockdemons")
    local ForUpdateAll = function(_self) _self:UpdateAll() end
    self.ForUpdateAll = ForUpdateAll

    self.activeBars = {}
    self.attachedNPs = {}

    self.demons = {
        ["Wild Imp"] = { icon = GetSpellTexture(205145), priority = 4, optionOrder = 2 },
        ["Demonic Tyrant"] = { icon = GetSpellTexture(265187), priority = 1, optionOrder = 1 },
        Dreadstalker = { icon = GetSpellTexture(104316), priority = 5, optionOrder = 3 },
        Felguard = { icon = GetSpellTexture(111898), priority = 6, optionOrder = 11 },
        Bilescourge = { icon = GetSpellTexture(267992), priority = 9, optionOrder = 14 },
        Vilefiend = { icon = GetSpellTexture(264119), priority = 10, optionOrder = 13 },
        ["Prince Malchezaar"] = { icon = GetSpellTexture(267986), priority = 2, optionOrder = 4 },
        ["Illidari Satyr"] = { icon = GetSpellTexture(267987), priority = 7, optionOrder = 15 },
        ["Vicious Hellhound"] = { icon = GetSpellTexture(267988), priority = 8, optionOrder = 16 },
        ["Eye of Gul'dan"] = { icon = GetSpellTexture(267989), priority = 11, optionOrder = 17 },
        ["Void Terror"] = { icon = GetSpellTexture(267991), priority = 12, optionOrder = 18 },
        Shivarra = { icon = GetSpellTexture(267994), priority = 14, optionOrder = 20 },
        Wrathguard = { icon = GetSpellTexture(267995), priority = 15, optionOrder = 21 },
        Darkhound = { icon = GetSpellTexture(267996), priority = 16, optionOrder = 22 },
        ["Ur'zul"] = { icon = GetSpellTexture(268001), priority = 17, optionOrder = 23 },
        ["Fel Lord"] = { icon = GetSpellTexture(212459), priority = 18, optionOrder = 24 },
        Observer = { icon = GetSpellTexture(201996), priority = 19, optionOrder = 25 },
        ["Imp Gang Boss"] = { icon = GetSpellTexture(387445), priority = 3, optionsOrder = 26 },
        ["Soulkeeper"] = { icon = GetSpellTexture(386244), priority = 2, optionsOrder = 27 },
        ["Pit Lord"] = { icon = GetSpellTexture(138787), priority = 1, optionsOrder = 28 },
    }

    self.header = self:CreateHeader()

    _G.zPets.RegisterPetEvent("OnSpawn", function(petGUID) WD:OnSpawn(petGUID) end)
    _G.zPets.RegisterPetEvent("OnDespawn", function(petGUID) WD:OnDespawn(petGUID) end)

    GetPetName = _G.zPets.GetPetName

    self:InitializeNPHooks()

    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED")
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    self:CheckEnabled()
end

NUI:RegisterModule(WD:GetName())
