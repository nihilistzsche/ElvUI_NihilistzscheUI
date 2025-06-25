local NUI, E = _G.unpack((select(2, ...)))
local ES = NUI.EnhancedShadows
local COMP = NUI.Compatibility

_G.EnhancedShadows = ES
local LSM = E.Libs.LSM
local NP = E.NamePlates
local UF = E.UnitFrames
local DT = E.DataTexts
local B = E.Bags
--local DB = E.DataBars
local Border, LastSize

ES.shadows = {}

local IsAddOnLoaded = _G.C_AddOns.IsAddOnLoaded
local C_AddOns_LoadAddOn = _G.C_AddOns.LoadAddOn
local tinsert = _G.tinsert
local NUM_STANCE_SLOTS = _G.NUM_STANCE_SLOTS
local hooksecurefunc = _G.hooksecurefunc
local C_Timer_After = _G.C_Timer.After
local GetNumGroupMembers = _G.GetNumGroupMembers
local wipe = _G.wipe
if not IsAddOnLoaded("Blizzard_TalentUI") then C_AddOns_LoadAddOn("Blizzard_TalentUI") end

ES.AddOnFrames = {
    QG = "QuestGuru",
    CQL = "ClassicQuestLog",
    LH = "LightHeadedFrame",
}

function ES:ElvUIShadows()
    local Frames = {
        _G.ElvUI_ConsolidatedBuffs,
        _G.ElvUI_ContainerFrame,
        _G.ElvUI_BankFrame,
        _G.PlayerTalentFrame,
        _G.CharacterFrame,
        _G.WorldMapFrame,
        _G.FriendsFrame,
        _G.PVEFrame,
        _G.TradeFrame,
        _G.AchievementFrame,
        _G.ZoneAbilityFrame.SpellButton,
        _G.MinimapBackdrop,
        _G.GameTooltip,
        _G.ElvConfigToggle,
    }

    for k, v in pairs(self.AddOnFrames) do
        if COMP[k] then tinsert(Frames, _G[v]) end
    end

    local BackdropFrames = {
        _G.ElvUIBags,
        _G.ElvUI_BarPet,
        _G.ElvUI_StanceBar,
        _G.ElvUI_TotemBar,
        _G.LeftChatPanel,
        _G.RightChatPanel,
        _G.FarmModeMap,
        _G.GameTooltipStatusBar,
        _G.LossOfControlFrame,
    }

    if COMP.BUI then
        tinsert(BackdropFrames, _G.BUI_ProfessionsDashboard)
        tinsert(BackdropFrames, _G.BUI_SystemsDashboard)
        tinsert(BackdropFrames, _G.BUI_TokensDashboard)
    end

    for _, frame in pairs(Frames) do
        if frame then
            frame:CreateShadow()
            ES:RegisterFrameShadows(frame)
        end
    end
    for _, frame in pairs(BackdropFrames) do
        if frame.backdrop then
            frame.backdrop:CreateShadow()
            ES:RegisterFrameShadows(frame.backdrop)
        end
    end

    for i = 1, 10 do
        if _G["ElvUI_Bar" .. i] then
            _G["ElvUI_Bar" .. i]:CreateShadow()
            ES:RegisterFrameShadows(_G["ElvUI_Bar" .. i])
            for k = 1, 12 do
                _G["ElvUI_Bar" .. i .. "Button" .. k]:CreateShadow()
                ES:RegisterFrameShadows(_G["ElvUI_Bar" .. i .. "Button" .. k])
            end
        end
    end

    -- Stance Bar buttons
    for i = 1, NUM_STANCE_SLOTS do
        local stanceBtn = { _G["ElvUI_StanceBarButton" .. i] }
        for _, button in pairs(stanceBtn) do
            if button then
                button:CreateShadow()
                ES:RegisterFrameShadows(button)
            end
        end
    end

    -- Unitframes (toDo Player ClassBars, Target ComboBar)
    local unitframes = { "Player", "Target", "TargetTarget", "Pet", "PetTarget", "Focus", "FocusTarget" }

    do
        for _, frame in pairs(unitframes) do
            local _self = _G["ElvUF_" .. frame]
            local unit = string.lower(frame)
            local health = _self.Health
            local power = _self.Power
            local castbar = _self.Castbar
            local portrait = _self.Portrait

            health:CreateShadow()
            ES:RegisterFrameShadows(health)
            if power then
                power:CreateShadow()
                ES:RegisterFrameShadows(power)
            end
            if unit == "player" or unit == "target" or unit == "focus" then
                if castbar then
                    castbar:CreateShadow()
                    castbar.ButtonIcon.bg:CreateShadow()
                    ES:RegisterFrameShadows(castbar)
                    ES:RegisterFrameShadows(castbar.ButtonIcon.bg)
                end
            end
            if unit == "player" or unit == "target" then
                if portrait then
                    portrait:CreateShadow()
                    ES:RegisterFrameShadows(portrait)
                end
            end
        end
    end

    local LeftChatToggleButton = _G.LeftChatToggleButton
    local RightChatToggleButton = _G.RightChatToggleButton

    if LeftChatToggleButton then
        LeftChatToggleButton:SetFrameStrata("BACKGROUND")
        LeftChatToggleButton:SetFrameLevel(_G.LeftChatDataPanel:GetFrameLevel() - 1)
        Mixin(LeftChatToggleButton, BackdropTemplateMixin)
        LeftChatToggleButton:SetTemplate()
        LeftChatToggleButton:CreateShadow()
        ES:RegisterFrameShadows(LeftChatToggleButton)
        RightChatToggleButton:SetFrameStrata("BACKGROUND")
        RightChatToggleButton:SetFrameLevel(_G.RightChatDataPanel:GetFrameLevel() - 1)
        Mixin(RightChatToggleButton, BackdropTemplateMixin)
        RightChatToggleButton:SetTemplate()
        RightChatToggleButton:CreateShadow()
        ES:RegisterFrameShadow(RightChatToggleButton)
    end

    _G.GameTooltip:HookScript("OnShow", function() ES:UpdateShadow(_G.GameTooltip.shadow) end)

    if COMP.LCP then
        _G.LeftCoordDtPanel:CreateShadow()
        _G.RightCoordDtPanel:CreateShadow()
        _G.LocationPlusPanel:CreateShadow()
        _G.XCoordsPanel:CreateShadow()
        _G.YCoordsPanel:CreateShadow()

        ES:RegisterFrameShadows(_G.LeftCoordDtPanel)
        ES:RegisterFrameShadows(_G.RightCoordDtPanel)
        ES:RegisterFrameShadows(_G.LocationPlusPanel)
        ES:RegisterFrameShadows(_G.XCoordsPanel)
        ES:RegisterFrameShadows(_G.YCoordsPanel)
    end

    if COMP.MERS then
        local MERS = _G.ElvUI_MerathilisUI[1]
        if MERS.raidManagerHeader then
            MERS.raidManagerHeader:CreateShadow()
            ES:RegisterFrameShadows(MERS.raidManagerHeader)
        end
        local frame = _G[MERS.Title .. "KeyFeedback"]
        if frame then
            frame.mirror:CreateShadow()
            ES:RegisterFrameShadows(frame.mirror)
        end
    end

    if COMP.BUI then
        _G.BuiTaxiButton:CreateShadow()

        ES:RegisterFrameShadows(_G.BuiTaxiButton)
    end
end

function ES:SkinAlerts()
    if not E.private.skins.blizzard.alertframes then return end
    local function AddShadow(f)
        f.backdrop:CreateShadow()
        self:RegisterFrameShadows(f.backdrop)
    end

    local function H(s)
        local function S()
            return function(f) AddShadow(f) end
        end

        hooksecurefunc(s, "setUpFunction", S())
    end

    local systems = {
        _G.AchievementAlertSystem,
        _G.CriteriaAlertSystem,
        _G.DungeonCompletionAlertSystem,
        _G.GuildChallengeAlertSystem,
        _G.InvasionAlertSystem,
        _G.ScenarioAlertSystem,
        _G.WorldQuestCompleteAlertSystem,
        _G.GarrisonFollowerAlertSystem,
        _G.LegendaryItemAlertSystem,
        _G.LootAlertSystem,
        _G.LootUpgradeAlertSystem,
        _G.MoneyWonAlertSystem,
        _G.StorePurchaseAlertSystem,
        _G.DigsiteCompleteAlertSystem,
        _G.NewRecipeLearnedAlertSystem,
    }

    for _, system in pairs(systems) do
        if system then H(system) end
    end

    local alerts = {
        _G.ScenarioLegionInvasionAlertFrame,
        _G.BonusRollMoneyWonFrame,
        _G.BonusRollLootWonFrame,
        _G.GarrisonBuildingAlertFrame,
        _G.GarrisonMissionAlertFrame,
        _G.GarrisonShipMissionAlertFrame,
        _G.GarrisonRandomMissionAlertFrame,
        _G.WorldQuestCompleteAlertFrame,
        _G.GarrisonFollowerAlertFrame,
        _G.LegendaryItemAlertFrame,
    }

    for _, alert in pairs(alerts) do
        if alert then AddShadow(alert) end
    end
end

ES.pendingShadows = {}
function ES:UpdateShadows(hide, shadow)
    if not self:CheckShadowColor() then
        if shadow then tinsert(self.pendingShadows, shadow) end
        if not self.pendingUpdate then
            C_Timer_After(2, function() self:UpdateShadows(hide) end)
            self.pendingUpdate = true
        end
        return
    end
    if #self.pendingShadows > 0 then
        for _, _shadow in next, self.pendingShadows do
            self:UpdateShadow(_shadow, hide)
        end
        wipe(self.pendingShadows)
    end
    if shadow then
        self:UpdateShadow(shadow, hide)
    else
        for frame, _ in pairs(ES.shadows) do
            self:UpdateShadow(frame, hide)
        end
    end
    self.pendingUpdate = nil
end

function ES:RegisterFrameShadows(frame)
    local shadow = frame.shadow or frame.Shadow
    if shadow and not shadow.isRegistered then
        self.shadows[shadow] = true
        shadow.isRegistered = true
        self:UpdateShadows(false, shadow)
    end
    local ishadow = frame.invertedshadow or frame.InvertedShadow
    if ishadow and not ishadow.isRegistered then
        self.shadows[ishadow] = true
        ishadow.isRegistered = true
        self:UpdateShadows(false, ishadow)
    end
end

function ES:RegisterShadow(shadow)
    if shadow.isRegistered then
        self:UpdateShadows(false, shadow)
        return
    end
    self.shadows[shadow] = shadow
    shadow.isRegistered = true
    self:UpdateShadows(false, shadow)
end

function ES:CheckShadowColor()
    local color = self.db and self.db.shadowcolor
    if color and not self.classColorUpdated then
        E:UpdateClassColor(color)
        self.classColorUpdated = true
    end
    return not not color
end

function ES:UpdateShadow(shadow, hide)
    local ShadowColor = self.db.shadowcolor

    local r, g, b = ShadowColor.r, ShadowColor.g, ShadowColor.b

    local size = self.db.size
    if size ~= LastSize then
        if shadow.inverted then
            shadow:SetInside(nil, -size, -size)
        else
            shadow:SetOutside(nil, size, size)
        end
        shadow:SetBackdrop({
            edgeFile = Border,
            edgeSize = E:Scale(size > 3 and size or 3),
            insets = { left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5) },
        })
        LastSize = size
    end
    shadow:SetBackdropColor(r, g, b, 0)
    shadow:SetBackdropBorderColor(r, g, b, 0.9)
    shadow:SetShown(self.db.enabled and not hide)
end

function ES:MERInit()
    local MER = _G.ElvUI_MerathilisUI[1]
    if not _G[MER.Title .. "MicroBar"] then return end
    _G[MER.Title .. "MicroBar"]:CreateShadow()
    self:RegisterFrameShadows(_G[MER.Title .. "MicroBar"])
end

function ES:EPBHook()
    local EPB = _G.EnhancedPetBattleUI
    hooksecurefunc(EPB, "UpdatePetFrame", function(_, frame)
        if not frame.enhanced then
            if not frame.shadow then frame:CreateShadow() end
            ES:RegisterFrameShadows(frame)
            frame.enhanced = true
        end
    end)
end

function ES:GROUP_ROSTER_UPDATE() self:UpdateShadows(GetNumGroupMembers() > 20) end
ES.PLAYER_ENTERING_WORLD = ES.GROUP_ROSTER_UPDATE

function ES:Initialize()
    if COMP.PA then _G.ProjectAzilroka.ES = ES end
    if COMP.AS then _G.AddOnSkins.ES = ES end

    NUI:RegisterDB(self, "enhancedshadows")
    local ForUpdateAll = function(_self)
        if _self.db.enabled ~= _self.enable_state then E:StaticPopup_Show("CONFIG_RL") end
    end
    self.ForUpdateAll = ForUpdateAll
    Border = LSM:Fetch("border", "ElvUI GlowBorder")
    hooksecurefunc(NP, "Update_Health", function(_, frame)
        if not frame.Health.shadow then frame.Health:CreateShadow() end
        ES:RegisterFrameShadows(frame.Health)
    end)

    hooksecurefunc(DT, "UpdatePanelInfo", function(_, panelName, panel, ...)
        if not panel then panel = DT.RegisteredPanels[panelName] end
        if panel and not panel.shadow then panel:CreateShadow() end
        ES:RegisterFrameShadows(panel)
        for _, dataPanel in ipairs(panel.dataPanels) do
            Mixin(dataPanel, BackdropTemplateMixin)
            dataPanel:SetTemplate()
            if not dataPanel.shadow then dataPanel:CreateShadow() end
            ES:RegisterFrameShadows(dataPanel)
        end
    end)
    C_Timer.After(5, function()
        for panelName, panel in pairs(DT.RegisteredPanels) do
            DT:UpdatePanelInfo(panelName, panel)
        end
    end)

    local framesKeys = { "Arena", "Assist", "Boss", "Party", "Raid", "Tank" }
    local frameKeys = {
        "Focus",
        "FocusTarget",
        "Pet",
        "PetTarget",
        "Player",
        "Target",
        "TargetTarget",
        "TargetTargetTarget",
    }

    for _, frames in ipairs(framesKeys) do
        hooksecurefunc(UF, "Update_" .. frames .. "Frames", function(_, frame)
            if not frame.shadow then
                frame:CreateShadow()
                ES:RegisterFrameShadows(frame)
            end
        end)
    end

    for _, frame in ipairs(frameKeys) do
        hooksecurefunc(UF, "Update_" .. frame .. "Frame", function(_, _frame)
            if not _frame.shadow then
                _frame:CreateShadow()
                ES:RegisterFrameShadows(_frame)
            end
        end)
    end

    UF:Update_AllFrames()
    if COMP.IF then
        C_AddOns_LoadAddOn("InFlight-WW")
        _G.InFlight:CreateBar()
        _G.InFlightBar:CreateShadow()
        ES:RegisterFrameShadows(_G.InFlightBar)
        _G.InFlightBar:HookScript("OnShow", function(_) ES:UpdateShadow(_.shadow) end)
    end
    if COMP.BUI then
        local BUI = _G.ElvUI_BenikUI[1]
        hooksecurefunc(BUI, "UpdateStyleColors", function()
            for frame, _ in pairs(BUI.styles) do
                if frame and not frame.enhanced then
                    if not frame.shadow then frame:CreateShadow() end
                    ES:RegisterFrameShadows(frame)
                    frame.enhanced = true
                end
            end
        end)
        BUI:UpdateStyleColors()
    end
    if COMP.MERS then
        local MER = _G.ElvUI_MerathilisUI[1]
        if MER.initialized then
            self:MERInit()
        else
            hooksecurefunc(_G.ElvUI_MerathilisUI[1], "Initialize", function() self:MERInit() end)
        end
    end
    if COMP.PA then
        if not _G.EnhancedPetBattleUI then C_AddOns_LoadAddOn("ProjectAzilroka") end
        local EPB = _G.EnhancedPetBattleUI
        if EPB then
            if EPB.UpdatePetFrame then
                self:EPBHook()
            else
                hooksecurefunc(EPB, "InitPetFrameAPI", function() self:EPBHook() end)
            end
            hooksecurefunc(EPB, "UpdateReviveBar", function()
                local f = function(frame)
                    if not frame.enhanced then
                        if not frame.shadow then frame:CreateShadow() end
                        ES:RegisterFrameShadows(frame)
                        frame.enhanced = true
                    end
                end
                f(EPB.holder.ReviveButton)
                f(EPB.holder.BandageButton)
            end)
        end
    end
    hooksecurefunc(E, "ToggleOptions", function(_)
        local win = _:Config_GetWindow()
        if win and not win.shadow then win:CreateShadow() end
        if win then ES:RegisterFrameShadows(win) end
    end)
    ES:RegisterEvent("GROUP_ROSTER_UPDATE")
    ES:RegisterEvent("PLAYER_ENTERING_WORLD")
    hooksecurefunc(B, "OpenBank", function(_) ES:UpdateShadows(true) end)
    hooksecurefunc(B, "CloseBank", function(_) ES:UpdateShadows() end)
    ES:SkinAlerts()
    ES:UpdateShadows()
end

NUI:RegisterModule(ES:GetName())
