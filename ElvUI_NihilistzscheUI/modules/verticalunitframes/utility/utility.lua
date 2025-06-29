local NUI, E, _, _, P = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB

local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local LSM = E.Libs.LSM
local COMP = NUI.Compatibility
local ES = NUI.EnhancedShadows

local strsplit = _G.strsplit
local gsub = _G.gsub
local DELETE = _G.DELETE
local UIParent = _G.UIParent
local UnitAffectingCombat = _G.UnitAffectingCombat
local IsAddOnLoaded = _G.C_AddOns.IsAddOnLoaded
local InCombatLockdown = _G.InCombatLockdown
local GetSpecialization = _G.GetSpecialization
local tContains = _G.tContains
local CreateFrame = _G.CreateFrame
local UnitFrame_OnEnter = _G.UnitFrame_OnEnter
local UnitFrame_OnLeave = _G.UnitFrame_OnLeave

local function IsDefaultHelper(tbl1, tbl2)
    --
    for k, v in pairs(tbl2) do
        --
        if tbl1[k] ~= v then
            if (type(tbl1[k]) ~= "table") or (type(v) ~= "table") then
                --
                return false -- some entry didn't exist or was different!
            end

            -- Subtables need to be dived into (different refs doesn't mean
            -- different contents).
            --
            if not IsDefaultHelper(tbl1[k], v) then return false end
        end
    end

    return true -- covered it all!
end

function VUF:IsDefault(settingstring)
    local settings = { strsplit(".", settingstring) }
    local options, profile = self.db, P.nihilistzscheui.vuf
    for _, setting in pairs(settings) do
        options = options[setting]
        profile = profile[setting]
        if not profile then -- this only happens for customTexts
            profile = {}
            E:CopyTable(profile, P.nihilistzscheui.vuf.customtext)
        end
    end
    return IsDefaultHelper(options, profile)
end

function VUF.GetUnitFrame(unit)
    local stringTitle = E:StringTitle(unit)
    if stringTitle:find("target") then stringTitle = gsub(stringTitle, "target", "Target") end
    return "NihilistzscheUF_" .. stringTitle
end

local __elements = {
    health = "Health",
    power = "Power",
    castbar = "Castbar",
    name = "Name",
    aurabars = "AuraBars",
    raidicon = "RaidTargetIndicator",
    restingindicator = "RestingIndicator",
    combatindicator = "Combat",
    pvptext = "PvPText",
    healPrediction = "HealthPrediction",
    powerPrediction = "PowerPrediction",
    stagger = "Stagger",
    gcd = "GCD",
    buffs = "Buffs",
    debuffs = "Debuffs",
    portrait = "Portrait",
    resurrectindicator = "ResurrectIndicator",
    classbars = "ClassBar",
    additionalpower = "AdditionalPower",
    phaseindicator = "PhaseIndicator",
    cutaway = "Cutaway",
}

VUF.Elements = __elements

function VUF:GetElement(element)
    if self.Elements[element] then
        return self.Elements[element]
    else
        return nil
    end
end

function VUF:AddCustomText(unit, name, optionsTbl)
    local real_name = string.format("customtext_%s", name)
    local frame = self.units[unit]
    if frame[real_name] then return end
    self:AddElement(frame, name)
    if not self.Elements[name] then self.Elements[name] = real_name end
    frame[real_name] = self:ConstructFontString(frame, name)
    if not E.db.nihilistzscheui.vuf.units[unit][name] then
        E.db.nihilistzscheui.vuf.units[unit][name] = {}
        E:CopyTable(E.db.nihilistzscheui.vuf.units[unit][name], P.nihilistzscheui.vuf.customtext)
        if not E.db.nihilistzscheui.vuf.units[unit].customTexts then
            E.db.nihilistzscheui.vuf.units[unit].customTexts = {}
        end
        E.db.nihilistzscheui.vuf.units[unit].customTexts[name] = true
    end
    optionsTbl = optionsTbl or E.Options.args.NihilistzscheUI.args.modules.args.VerticalUnitFrames
    if optionsTbl.args[unit] then
        optionsTbl.args[unit].args[name] = self:GenerateElementOptionsTable(
            unit,
            name,
            4000,
            E:StringTitle(name),
            true,
            false,
            false,
            true,
            false,
            false
        )
        optionsTbl.args[unit].args[name].args.delete = {
            type = "execute",
            order = 1,
            name = DELETE,
            func = function()
                E.db.nihilistzscheui.vuf.units[unit].customTexts[name] = nil
                E.db.nihilistzscheui.vuf.units[unit][name] = nil
                optionsTbl.args[unit].args[name] = nil
                frame:Tag(frame[real_name], "")
                frame[real_name]:Hide()
                frame[real_name] = nil
            end,
        }
    end
    frame[real_name]:Show()
end

function VUF:SetUpCustomTexts(frame, optionsTbl)
    local unit = frame.unit
    if not E.db.nihilistzscheui.vuf.units[unit] then return end
    if E.db.nihilistzscheui.vuf.units[unit].customTexts then
        for textName, _ in pairs(E.db.nihilistzscheui.vuf.units[unit].customTexts) do
            self:AddCustomText(unit, textName, optionsTbl)
        end
    end
end

function VUF:GetAnchor(frame, anchor)
    if anchor == "self" then
        return frame
    elseif anchor == "ui" then
        return UIParent
    elseif string.find(anchor, ":") then
        local f, e = strsplit(":", anchor)
        f = self.GetUnitFrame(f)
        e = self:GetElement(e)
        return _G[f][e]
    else
        local e = anchor
        e = self:GetElement(e)
        if e then
            return frame[e]
        else
            e = self.GetUnitFrame(anchor)
            return e
        end
    end
end

function VUF:CheckHealthValue(frame, eclipse)
    if not frame or not frame.Health then return end
    local config = self.db.units.player.health.value
    if config.enabled then
        if VUF:IsDefault("units.player.health.value.anchor") then
            if eclipse then
                frame.Health.value:Point("TOPRIGHT", frame.Health, "TOPLEFT", -30, 0)
            else
                frame.Health.value:Point("TOPRIGHT", frame.Health, "TOPLEFT", -20, 0)
            end
        end
    end
end

function VUF:ConstructVerticalUnitFrame(frame, unit)
    if not self.db.units then return end
    self.units[unit] = frame
    self.units[unit].elements = {}
    frame:RegisterForClicks("AnyUp", "AnyDown")
    frame:SetScript("OnEnter", function(_self)
        UnitFrame_OnEnter(_self)
        if
            E.db.nihilistzscheui.vuf.hideOOC
            and not UnitAffectingCombat("player")
            and not UnitAffectingCombat("pet")
            and _self.unit ~= "target"
        then
            VUF:UpdateHiddenStatus(frame)
        end
    end)
    frame:SetScript("OnLeave", function(_self)
        UnitFrame_OnLeave(_self)
        if
            E.db.nihilistzscheui.vuf.hideOOC
            and not UnitAffectingCombat("player")
            and not UnitAffectingCombat("pet")
            and self.unit ~= "target"
        then
            VUF:UpdateHiddenStatus(frame)
        end
    end)

    frame.__nui__needsVUFPortraitFix = true
    frame.menu = UF.SpawnMenu
    frame.db = UF.db.units[unit]
    frame.unitframeType = unit
    local stringTitle = E:StringTitle(unit)
    if stringTitle:find("target") then stringTitle = gsub(stringTitle, "target", "Target") end
    frame.frameName = "NihilistzscheUF_" .. stringTitle
    self["Construct" .. stringTitle .. "Frame"](self, frame, unit)

    frame:CreateBackdrop("Transparent")
    frame:SetParent(E.UFParent)
    E.FrameLocks[frame] = true
    if ES then
        frame:CreateShadow()
        ES:RegisterFrameShadows(frame)
    end
    if COMP.BUI then frame:BuiStyle("Outside") end

    return frame
end

function VUF:UpdateFrame(unit)
    if UnitAffectingCombat("player") or UnitAffectingCombat("pet") then
        NUI:RegenWait(self.UpdateFrame, self, unit)
        return
    end
    local frame = self.units[unit]
    if not self.db.units[unit] then return end
    local spacer = 2
    local health = self.db.units[unit].health
    if not health then return end
    local size = health.size
    if not size then return end
    local width = size.width + spacer
    local height = size.height + spacer
    if
        self.db.units[unit].power
        and self.db.units[unit].power.enabled
        and self.db.units[unit].power.anchor.attachTo == "health"
    then
        width = width + self.db.units[unit].power.size.width
    end
    frame:Size(width, height)
    _G[frame:GetName() .. "Mover"]:Size(frame:GetSize())
    frame.backdrop:SetFrameLevel(0)
    if E.db.nihilistzscheui.vuf.enabled and self.db.units[unit].enabled then
        frame:EnableMouse(self.db.hideElv or self.db.enableMouse)
        frame:Enable()

        if unit == "target" then
            local db = E.db.unitframe.units.target
            if not IsAddOnLoaded("Clique") then
                if db.middleClickFocus then
                    frame:SetAttribute("type3", "focus")
                elseif frame:GetAttribute("type3") == "focus" then
                    frame:SetAttribute("type3", nil)
                end
            end
        end
        local event
        if InCombatLockdown() or UnitAffectingCombat("player") or UnitAffectingCombat("pet") then
            event = "PLAYER_REGEN_DISABLED"
        else
            event = "PLAYER_REGEN_ENABLED"
        end
        if self.db.hideOOC then VUF:UpdateHiddenStatus(frame, event) end
        self:UpdateAllElements(frame)
        self:UpdateAllElementAnchors(frame)

        if frame.PrivateAuras then UF:Configure_PrivateAuras(frame) end

        if E.myclass == "DRUID" and unit == "player" then
            local spec = GetSpecialization()
            self:CheckHealthValue(frame, spec == 1)
        end

        if E.myclass == "DEATHKNIGHT" and unit == "player" then
            frame.Runes.sortOrder = (frame.db.classbar.sortDirection ~= "NONE") and frame.db.classbar.sortDirection
        end

        if COMP.DSI and (unit == "player" or unit == "target") then
            local DSI = ElvUI_DynamicStatusIcons[1]
            DSI:Update_PlayerFrame(frame)
        end
    else
        if frame:IsVisible() then frame:Hide() end
        frame:SetAlpha(0)
        frame:Disable()
        VUF:ScheduleTimer("DisableThisShit", 1)
    end
end

function VUF:HookSetAlpha(frame)
    if frame._NihilistzscheUI_SetAlpha then return end
    frame._NihilistzscheUI_SetAlpha = frame.SetAlpha
    frame.SetAlpha = function(_self, alpha)
        if not alpha then return end
        if InCombatLockdown() then
            _self:_NihilistzscheUI_SetAlpha(self.db.alpha)
        else
            _self:_NihilistzscheUI_SetAlpha(alpha)
        end
    end
end

function VUF:DisableThisShit()
    if not VUF.db or not VUF.db.units then
        VUF:ScheduleTimer("DisableThisShit", 1)
        return
    end
    if UnitAffectingCombat("player") or UnitAffectingCombat("pet") then
        NUI:RegenWait(self.DisableThisShit, self)
        return
    end
    for _, f in pairs(VUF.units) do
        local unit = f.unit
        if unit == "vehicle" then unit = "player" end
        if not VUF.db.units[unit].enabled then f:Disable() end
    end
end

function VUF:UpdateAllFrames()
    if not self.db then return end
    for unit, frame in pairs(self.units) do
        self:UpdateFrame(unit)
        if frame.OnFirstUpdateFinish then
            frame.OnFirstUpdateFinish()
            frame.OnFirstUpdateFinish = nil
        end
    end
end

local needsManualUpdate = { "health", "power", "additionalpower", "classbars", "buffs" }

function VUF:UpdateAllElements(frame)
    local elements = self.units[frame.unit].elements
    for _, element in ipairs(needsManualUpdate) do
        if elements[element] then self:UpdateElement(frame, element) end
    end
    for element, _ in pairs(elements) do
        if not tContains(needsManualUpdate, element) and self:GetElement(element) then
            self:UpdateElement(frame, element)
        end
    end
end

function VUF:UpdateAllElementAnchors(frame)
    if not frame then return end
    local elements = self.units[frame.unit].elements
    local seenClassbars = false

    for _, element in ipairs(needsManualUpdate) do
        if elements[element] then self:UpdateElementAnchor(frame, element) end
    end
    for element, _ in pairs(elements) do
        if not tContains(needsManualUpdate, element) and self:GetElement(element) then
            if element == "classbars" then
                if not seenClassbars then
                    self:UpdateElementAnchor(frame, element)
                    seenClassbars = true
                end
            else
                self:UpdateElementAnchor(frame, element)
            end
        end
    end
end

function VUF:AddElement(frame, element)
    if not self.units[frame.unit].elements[element] then self.units[frame.unit].elements[element] = {} end
end

function VUF:ConstructStatusBar(frame, element, parent, name, t, noBG)
    if parent == nil then parent = frame end
    if name == nil then name = "statusbar" end
    local sbname = frame.unit .. "_vuf_" .. element .. "_" .. name

    -- Create the status bar
    local sb = CreateFrame("StatusBar", sbname, parent, "BackdropTemplate")
    if not t then sb:SetTemplate("Transparent") end

    -- Dummy texture so we can set colors
    sb:SetStatusBarTexture(E.media.blankTex)
    sb:GetStatusBarTexture():SetHorizTile(false)

    -- Frame strata/level
    sb:SetFrameStrata(parent:GetFrameStrata())
    sb:SetFrameLevel(parent:GetFrameLevel())

    sb:SetRotatesTexture(true)

    if not t and not noBG then
        -- Create the status bar background
        local bg = sb:CreateTexture(nil, "BORDER")
        bg:SetInside(sb)
        bg:SetTexture(E.media.blankTex)
        if element == "gcd" then bg:SetTexture(0.1, 0.1, 0.1) end
        bg:SetAlpha(0.2)
        bg.multiplier = 0.25
        sb.bg = bg

        if not t and noBG then
            if ES then
                sb:CreateShadow()
                ES:RegisterFrameShadows(sb)
            end
        end
    end

    if not self.units[frame.unit].elements[element].statusbars then
        self.units[frame.unit].elements[element].statusbars = {}
    end

    self.units[frame.unit].elements[element].statusbars[name] = sb
    return sb
end

function VUF:ConstructFontString(frame, element, parent, name)
    if parent == nil then parent = frame end
    if name == nil then name = "value" end
    local fsname = frame.unit .. "_vuf_" .. element .. "_" .. name

    if not self.units[frame.unit].elements[element].fontstrings then
        self.units[frame.unit].elements[element].fontstrings = {}
    end

    local fs = parent:CreateFontString(fsname, "OVERLAY")
    -- Dummy font
    fs:FontTemplate(LSM:Fetch("font", E.db.general.font), 12, "THINOUTLINE")
    self.units[frame.unit].elements[element].fontstrings[name] = fs

    return fs
end

function VUF:ConfigureTexture(frame, element, parent, name)
    if parent == nil then parent = frame end
    if name == nil then name = "texture" end
    local texname = frame.unit .. "_vuf_" .. element .. "_" .. name
    if not self.units[frame.unit].elements[element].textures then
        self.units[frame.unit].elements[element].textures = {}
    end

    local t = parent:CreateTexture(texname, "OVERLAY")
    -- Dummy texture
    t:SetTexture(E.media.blankTex)
    self.units[frame.unit].elements[element].textures[name] = t
    return t
end

function VUF:CreateFrame(frame, element, parent)
    if parent == nil then parent = frame end
    local name = frame.unit .. "_vuf_" .. element
    local f = CreateFrame("Frame", name, parent, "BackdropTemplate")
    self.units[frame.unit].elements[element].frame = f
    return f
end

function VUF:ResetUnitSettings(unit)
    local frame = self.units[unit]
    if not frame then return end
    E:CopyTable(self.db.units[unit], P.nihilistzscheui.vuf.units[unit])
    self:UpdateAllFrames()
end

function VUF:OldDefault()
    self.db.units.player.width = 39
    self.db.units.player.health.size.width = 15
    self.db.units.player.portrait.enabled = false
    self.db.units.target.width = 39
    self.db.units.target.health.size.width = 15
    self.db.units.target.portrait.enabled = false
end

function VUF:SimpleLayout()
    self.db.units.target.enabled = false
    self.db.units.targettarget.enabled = false
    self.db.units.pet.enabled = false
    self.db.units.pettarget.enabled = false
    for element, _ in pairs(self.db.units.player) do
        if self:GetElement(element) then self.db.units.player[element].enabled = false end
    end
    self.db.units.player.width = 39
    self.db.units.player.health.enabled = true
    self.db.units.player.health.size.width = 15
    self.db.units.player.power.enabled = true
    self.db.units.player.power.anchor.xOffset = 550
    self.db.units.player.classbars.enabled = true
    self.db.units.player.castbar.enabled = true
end

function VUF:ComboLayout()
    self.db.hideElv = false
    self.db.hideOOC = true
    self.db.enableMouse = false
    self.db.units.focus.enabled = false
    self.db.units.focustarget.enabled = false
    self.db.units.targettarget.enabled = false
    self.db.units.pettarget.enabled = false
    self.db.units.player.enabled = true
    self.db.units.target.enabled = true
    self.db.units.pet.enabled = true
    for element, _ in pairs(self.db.units.player) do
        if self:GetElement(element) then self.db.units.player[element].enabled = false end
    end
    for element, _ in pairs(self.db.units.target) do
        if self:GetElement(element) then self.db.units.target[element].enabled = false end
    end
    for element, _ in pairs(self.db.units.pet) do
        if self:GetElement(element) then self.db.units.pet[element].enabled = false end
    end
    self.db.units.player.health.enabled = true
    self.db.units.player.castbar.enabled = true
    self.db.units.player.aurabars.enabled = true
    self.db.units.target.health.enabled = true
    self.db.units.target.name.enabled = true
    self.db.units.target.raidicon.enabled = true
    self.db.units.target.aurabars.enabled = true
    self.db.units.target.castbar.enabled = true
    self.db.units.pet.health.enabled = true
    self.db.units.player.horizCastbar = true
    self.db.units.target.horizCastbar = true
    self.db.units.player.width = 39
    self.db.units.player.health.size.width = 15
    self.db.units.target.width = 39
    self.db.units.target.health.size.width = 15
    local db = E.db.unitfram.units
    db.player.castbar.enable = false
    db.target.castbar.enable = false
    db.player.aurabar.enable = false
    db.target.aurabar.enable = false
    UF:Update_AllFrames()
end
