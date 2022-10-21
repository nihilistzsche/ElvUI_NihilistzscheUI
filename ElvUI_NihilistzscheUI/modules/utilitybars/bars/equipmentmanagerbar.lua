local NUI, E = _G.unpack(select(2, ...))

local EM = NUI.UtilityBars.EquipmentManagerBar
local NUB = NUI.UtilityBars
local LSM = E.Libs.LSM

local CreateFrame = _G.CreateFrame
local GameTooltip = _G.GameTooltip
local EQUIPMENT_SET_EDIT = _G.EQUIPMENT_SET_EDIT
local GameTooltip_Hide = _G.GameTooltip_Hide
local ToggleCharacter = _G.ToggleCharacter
local PaperDollEquipmentManagerPane = _G.PaperDollEquipmentManagerPane
local PaperDollFrame_ClearIgnoredSlots = _G.PaperDollFrame_ClearIgnoredSlots
local PaperDollFrame_IgnoreSlotsForSet = _G.PaperDollFrame_IgnoreSlotsForSet
local PaperDollEquipmentManagerPane_Update = _G.PaperDollEquipmentManagerPane_Update
local GearManagerDialogPopup = _G.GearManagerDialogPopup
local StaticPopup_Show = _G.StaticPopup_Show
local StaticPopup_Hide = _G.StaticPopup_Hide
local RecalculateGearManagerDialogPopup = _G.RecalculateGearManagerDialogPopup
local SAVE_CHANGES = _G.SAVE_CHANGES
local C_EquipmentSet_GetEquipmentSetID = _G.C_EquipmentSet.GetEquipmentSetID
local C_EquipmentSet_GetEquipmentSetIDs = _G.C_EquipmentSet.GetEquipmentSetIDs
local C_EquipmentSet_GetEquipmentSetInfo = _G.C_EquipmentSet.GetEquipmentSetInfo
local C_EquipmentSet_GetNumEquipmentSets = _G.C_EquipmentSet.GetNumEquipmentSets
local C_EquipmentSet_UseEquipmentSet = _G.C_EquipmentSet.UseEquipmentSet

function EM:CreateBar()
    local bar =
        NUB:CreateBar(
        "NihilistzscheUI_EquipmentManagerBar",
        "equipmentManagerBar",
        {"BOTTOMLEFT", _G.LeftChatPanel, "BOTTOMRIGHT", 4, 24},
        "Equipment Manager Bar"
    )
    NUB.RegisterCreateButtonHook(
        bar,
        function(button)
            self:CreateButtonHook(button)
        end
    )
    NUB.RegisterUpdateButtonHook(
        bar,
        function(button)
            self.UpdateButtonHook(bar, button)
        end
    )
    bar:Size(36, 160)

    return bar
end

function EM.CreateEditButton(button)
    local editButton = CreateFrame("Button", nil, button)

    editButton:SetFrameLevel(button:GetFrameLevel() + 2)
    editButton:SetSize(14, 14)
    editButton:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
    editButton.Icon = editButton:CreateTexture(nil, "ARTWORK")
    editButton.Icon:SetTexture("Interface\\WorldMap\\GEAR_64GREY")
    editButton.Icon:SetAllPoints()
    editButton.Icon:SetAlpha(.5)

    editButton:SetScript(
        "OnEnter",
        function(self)
            local setName = self:GetParent().data
            if not setName then
                return
            end
            self.Icon:SetAlpha(1)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(EQUIPMENT_SET_EDIT)
        end
    )
    editButton:SetScript(
        "OnLeave",
        function(self)
            local setName = self:GetParent().data
            if not setName then
                return
            end
            self.Icon:SetAlpha(.5)
            GameTooltip_Hide()
        end
    )
    editButton:SetScript(
        "OnClick",
        function(self)
            local setName = self:GetParent().data
            if not setName then
                return
            end
            ToggleCharacter("PaperDollFrame")
            local isShown = PaperDollEquipmentManagerPane:IsVisible()
            PaperDollEquipmentManagerPane:Show()
            PaperDollEquipmentManagerPane:SetShown(isShown)
            PaperDollEquipmentManagerPane.selectedSetName = setName
            PaperDollFrame_ClearIgnoredSlots()
            PaperDollFrame_IgnoreSlotsForSet(setName)
            PaperDollEquipmentManagerPane_Update()
            GearManagerDialogPopup:Hide()
            StaticPopup_Hide("CONFIRM_SAVE_EQUIPMENT_SET")
            StaticPopup_Hide("CONFIRM_OVERWRITE_EQUIPMENT_SET")
            GearManagerDialogPopup:Show()
            GearManagerDialogPopup.isEdit = true
            GearManagerDialogPopup.origName = setName
            RecalculateGearManagerDialogPopup(setName, self:GetParent().texture:GetTexture())
        end
    )

    editButton:Show()

    return editButton
end

function EM.CreateSaveButton(button)
    local saveButton = CreateFrame("Button", nil, button)

    saveButton:SetFrameLevel(button:GetFrameLevel() + 2)
    saveButton:SetSize(14, 14)
    saveButton:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)
    saveButton.Icon = saveButton:CreateTexture(nil, "ARTWORK")
    saveButton.Icon:SetAllPoints()
    saveButton:SetScript(
        "OnEnter",
        function(self)
            local setName = self:GetParent().data
            if not setName then
                return
            end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(SAVE_CHANGES)
        end
    )
    saveButton:SetScript("OnLeave", GameTooltip_Hide)
    saveButton:SetScript(
        "OnClick",
        function(self)
            local setName = self:GetParent().data
            if not setName then
                return
            end
            local setID = C_EquipmentSet_GetEquipmentSetID(setName)
            local Dialog = StaticPopup_Show("CONFIRM_SAVE_EQUIPMENT_SET", setName)
            Dialog.data = setID
        end
    )

    saveButton:Show()

    return saveButton
end

function EM:CreateButtonHook(button)
    button.missingOverlay = button:CreateTexture(nil, "OVERLAY")
    button.missingOverlay:SetInside()
    button.missingOverlay:SetColorTexture(1, .2, .2, .4)

    button.setnametext = button:CreateFontString(nil, "OVERLAY")
    button.setnametext:FontTemplate(LSM:Fetch("font", E.db.general.font), 10, "THINOUTLINE")
    button.setnametext:SetWidth(E:Scale(self.bar.db.buttonsize) - 4)
    button.setnametext:SetHeight(E:Scale(14))
    button.setnametext:SetJustifyH("CENTER")
    button.setnametext:Point("TOP", 0, 0)

    button.SetTooltip = function(_self)
        if not _self.data then
            return nil
        end
        local ret = GameTooltip:SetEquipmentSet(_self.data)
        GameTooltip:Show()
        return ret
    end
    button:SetScript(
        "OnClick",
        function(_self)
            if not _self.data then
                return
            end
            local equipmentSetID = C_EquipmentSet_GetEquipmentSetID(_self.data)
            if not select(4, C_EquipmentSet_GetEquipmentSetInfo(equipmentSetID)) then
                C_EquipmentSet_UseEquipmentSet(equipmentSetID)
            end
        end
    )

    button.editButton = self.CreateEditButton(button)
    button.saveButton = self.CreateSaveButton(button)
end

function EM.UpdateButtonHook(bar, button)
    local equipmentSetIDs = C_EquipmentSet_GetEquipmentSetIDs()
    local setName, setIcon, _, _, numItems, numEquipped, _, numMissing =
        C_EquipmentSet_GetEquipmentSetInfo(equipmentSetIDs[NUI.InvertTable(bar.buttons)[button]])
    button.data = setName
    button.setnametext:SetText(setName)
    button.texture:SetTexture(setIcon)
    button.missingOverlay:SetShown(numMissing > 0)

    if (numEquipped < numItems) then
        button.saveButton.Icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
        button.saveButton:Enable()
        button.saveButton:EnableMouse(true)
    else
        button.saveButton.Icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
        button.saveButton:Disable()
        button.saveButton:EnableMouse(false)
    end
end

function EM:UpdateBar(bar)
    NUB.CreateButtons(bar, C_EquipmentSet_GetNumEquipmentSets())
    NUB.WipeButtons(bar)

    local equipmentSetIDs = C_EquipmentSet_GetEquipmentSetIDs()
    for i, v in ipairs(bar.buttons) do
        local setID = equipmentSetIDs[i]
        if setID then
            local _, setIcon = C_EquipmentSet_GetEquipmentSetInfo(setID)
            NUB.UpdateButtonAsCustom(bar, v, setIcon)
        end
    end

    NUB.UpdateBar(self, bar, "ELVUIBAR20BINDBUTTON")
    for _, button in ipairs(bar.buttons) do
        if (bar.db.mouseover) then
            if not (self.sbhooks[button]) then
                self:HookScript(button.editButton, "OnEnter", "SecondaryButton_OnEnter")
                self:HookScript(button.saveButton, "OnEnter", "SecondaryButton_OnEnter")
                self.sbhooks[button] = true
            end
        else
            if (self.sbhooks[button]) then
                self:Unhook(button.editButton, "OnEnter")
                self:Unhook(button.saveButton, "OnEnter")
                self.sbhooks[button] = nil
            end
        end
    end
end

function EM:SecondaryButton_OnEnter(button)
    self:Button_OnEnter(button:GetParent())
end

function EM:Initialize()
    NUB:InjectScripts(self)

    local frame = CreateFrame("Frame", "NihilistzscheUI_EquipMgrBarController")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
    frame:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
    NUB:RegisterEventHandler(self, frame)

    local bar = self:CreateBar()
    self.bar = bar
    self.hooks = {}
    self.sbhooks = {}

    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(EM)
