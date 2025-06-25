local _, E, L = _G.unpack((select(2, ...)))
local DT = E.DataTexts

local CreateFrame = _G.CreateFrame
local F = CreateFrame("frame")

local wipe = _G.wipe
local tinsert = table.insert
local format = string.format
local join = _G.string.join
local C_PetJournal_GetNumPets = _G.C_PetJournal.GetNumPets
local C_PetJournal_GetPetInfoByIndex = _G.C_PetJournal.GetPetInfoByIndex
local C_PetJournal_GetPetInfoByPetID = _G.C_PetJournal.GetPetInfoByPetID
local C_PetJournal_GetSummonedPetGUID = _G.C_PetJournal.GetSummonedPetGUID
local C_PetJournal_PickupPet = _G.C_PetJournal.PickupPet
local C_PetJournal_SummonPetByGUID = _G.C_PetJournal.SummonPetByGUID
local IsShiftKeyDown = _G.IsShiftKeyDown
local IsAltKeyDown = _G.IsAltKeyDown
local IsControlKeyDown = _G.IsControlKeyDown
local DEFAULT_CHAT_FRAME = _G.DEFAULT_CHAT_FRAME
local tContains = _G.tContains
local UIDropDownMenu_AddButton = _G.UIDropDownMenu_AddButton
local ToggleDropDownMenu = _G.ToggleDropDownMenu
local ToggleCollectionsJournal = _G.ToggleCollectionsJournal
local IsAddOnLoaded = _G.C_AddOns.IsAddOnLoaded
local PetJournalFilterDropDown = _G.PetJournalFilterDropDown
local C_AddOns_LoadAddOn = _G.C_AddOns.LoadAddOn

local menu = {}

local displayString = ""
local hexColor = "|cff00ff96"

local db

local function UpdateDisplay(self)
    if db.id and db.text then self.text:SetFormattedText(displayString, db.text) end

    local summonedPetID = C_PetJournal_GetSummonedPetGUID()
    if summonedPetID then
        local _, customName, _, _, _, _, _, petName, _, _, _ = C_PetJournal_GetPetInfoByPetID(summonedPetID)
        local creatureName = petName
        if customName then creatureName = customName end
        if creatureName then
            self.text:SetFormattedText(displayString, creatureName)
            db.id = summonedPetID
            db.text = creatureName
        end
    else
        self.text:SetText(("%s"):format(L["Battle Pets"]))
    end
end

local function ModifiedClick(_, id)
    local _, customName, _, _, _, _, _, petName = C_PetJournal_GetPetInfoByPetID(id)
    local creatureName = petName
    if customName then creatureName = customName end

    if IsShiftKeyDown() then
        C_PetJournal_PickupPet(id)
    elseif IsAltKeyDown() and not IsControlKeyDown() then
        db.favOne = id
        DEFAULT_CHAT_FRAME:AddMessage(
            (L["%sCompanions:|r %s added as favorite one."]):format(hexColor, creatureName),
            1,
            1,
            1
        )
    elseif IsControlKeyDown() and not IsAltKeyDown() then
        db.favTwo = id
        DEFAULT_CHAT_FRAME:AddMessage(
            (L["%sCompanions:|r %s added as favorite two."]):format(hexColor, creatureName),
            1,
            1,
            1
        )
    elseif IsControlKeyDown() and IsAltKeyDown() then
        db.favThree = id
        DEFAULT_CHAT_FRAME:AddMessage(
            (L["%sCompanions:|r %s added as favorite three."]):format(hexColor, creatureName),
            1,
            1,
            1
        )
    else
        C_PetJournal_SummonPetByGUID(id)
    end
end

local specialPets = {
    "Snowfeather Hatchling",
    "Bloodgazer Hatchling",
    "Direbeak Hatchling",
    "Sharptalon Hatchling",
}

local function AddSpecialPets(_, level)
    local numPets = C_PetJournal_GetNumPets()
    for i = 1, numPets do
        local petID, _, isOwned, customName, _, _, _, name, icon = C_PetJournal_GetPetInfoByIndex(i)
        local creatureName = name
        if customName then creatureName = customName end
        if tContains(specialPets, name) and isOwned then
            menu.text = creatureName
            menu.icon = icon
            menu.colorCode = "|cffffffff"
            menu.func = ModifiedClick
            menu.arg1 = petID
            menu.hasArrow = false
            menu.notCheckable = true
            UIDropDownMenu_AddButton(menu, level)
        end
    end
end

local function AddFavorites(self, level)
    if db.favOne ~= nil then
        local _, customName, _, _, _, _, _, petName, petIcon = C_PetJournal_GetPetInfoByPetID(db.favOne)
        local creatureName = petName
        if customName then creatureName = customName end
        menu.text = format("1. %s", creatureName)
        menu.icon = petIcon
        menu.colorCode = "|cffffffff"
        menu.func = ModifiedClick
        menu.arg1 = db.favOne
        menu.hasArrow = nil
        menu.notCheckable = true

        local summonedPetID = C_PetJournal_GetSummonedPetGUID()
        if summonedPetID == db.favOne then menu.colorCode = hexColor end
        UIDropDownMenu_AddButton(menu, level)
    end

    if db.favTwo ~= nil then
        local _, customName, _, _, _, _, _, petName, petIcon = C_PetJournal_GetPetInfoByPetID(db.favTwo)
        local creatureName = petName
        if customName then creatureName = customName end
        menu.text = format("2. %s", creatureName)
        menu.icon = petIcon
        menu.colorCode = "|cffffffff"
        menu.func = ModifiedClick
        menu.arg1 = db.favTwo
        menu.hasArrow = nil
        menu.notCheckable = true

        local summonedPetID = C_PetJournal_GetSummonedPetGUID()
        if summonedPetID == db.favTwo then menu.colorCode = hexColor end
        UIDropDownMenu_AddButton(menu, level)
    end

    if db.favThree ~= nil then
        local _, customName, _, _, _, _, _, petName, petIcon = C_PetJournal_GetPetInfoByPetID(db.favThree)
        local creatureName = petName
        if customName then creatureName = customName end
        menu.text = format("3. %s", creatureName)
        menu.icon = petIcon
        menu.colorCode = "|cffffffff"
        menu.func = ModifiedClick
        menu.arg1 = db.favThree
        menu.hasArrow = nil
        menu.notCheckable = true

        local summonedPetID = C_PetJournal_GetSummonedPetGUID()
        if summonedPetID == db.favThree then menu.colorCode = hexColor end
        UIDropDownMenu_AddButton(menu, level)
    end

    AddSpecialPets(self, level)
end

local function CreateMenu(self, level)
    wipe(menu)
    local numPets = C_PetJournal_GetNumPets()
    if numPets <= 20 then
        for i = 1, numPets do
            local petID, _, isOwned, customName, _, _, _, name, icon = C_PetJournal_GetPetInfoByIndex(i)
            local creatureName = name
            if customName then creatureName = customName end
            --firstChar = strupper(strsub(creatureName, 1, 1))
            if isOwned then
                menu.hasArrow = false -- Start menu creation
                menu.notCheckable = true
                menu.text = creatureName
                menu.icon = icon
                menu.colorCode = "|cffffffff"
                menu.func = ModifiedClick
                menu.arg1 = petID

                local summonedPetID = C_PetJournal_GetSummonedPetGUID()
                if summonedPetID == petID then menu.colorCode = "|cff00ff00" end
                UIDropDownMenu_AddButton(menu)
            end
        end
        AddFavorites(self, level)
    else
        local function CollectPetsByFirstChar(firstChar)
            local pets = {}
            for i = 1, numPets do
                local _, _, isOwned, customName, _, _, _, name = C_PetJournal_GetPetInfoByIndex(i)
                local creatureName = name
                if customName then creatureName = customName end
                if creatureName and isOwned and creatureName:sub(1, 1):upper() == firstChar then tinsert(pets, i) end
            end
            return pets
        end

        local depthByKey = {}
        local countByKey = {}
        local key = "A"
        local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZA"
        repeat
            local count = #(CollectPetsByFirstChar(key))
            depthByKey[key] = (count / 32) + 1
            countByKey[key] = count
            key = alphabet:match(key .. "(.)")
        until key == "A"

        level = level or 1

        if level == 1 then
            key = "A"
            alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZA"
            repeat
                if countByKey[key] > 0 then
                    for i = 1, depthByKey[key] do
                        menu.text = key
                        menu.notCheckable = true
                        menu.hasArrow = true
                        menu.value = { ["Level1_Key"] = key, ["Level1_Depth"] = i }
                        UIDropDownMenu_AddButton(menu, level)
                    end
                end
                key = alphabet:match(key .. "(.)")
            until key == "A"
            AddFavorites(self, level)
        elseif level == 2 then
            local Level1_Key = _G.UIDROPDOWNMENU_MENU_VALUE.Level1_Key
            local Level1_Depth = _G.UIDROPDOWNMENU_MENU_VALUE.Level1_Depth
            local pets = CollectPetsByFirstChar(Level1_Key)
            local depthMod = 1 + ((Level1_Depth - 1) * 32)
            for k = depthMod, depthMod + 31 do
                if pets[k] then
                    local petID, _, isOwned, customName, _, _, _, name, icon = C_PetJournal_GetPetInfoByIndex(pets[k])
                    local creatureName = name
                    if customName then creatureName = customName end
                    if creatureName and isOwned then
                        menu.text = creatureName
                        menu.icon = icon
                        menu.colorCode = "|cffffffff"
                        menu.func = ModifiedClick
                        menu.arg1 = petID
                        menu.hasArrow = false
                        menu.notCheckable = true

                        UIDropDownMenu_AddButton(menu, level)
                    end
                else
                    break
                end
            end
        end
    end
end

local interval = 1
local function OnEvent(self) UpdateDisplay(self) end

local function OnClick(self, button)
    DT.tooltip:Hide()

    if button == "RightButton" and not IsShiftKeyDown() then ToggleDropDownMenu(1, nil, F, self, 0, 0) end
    if IsShiftKeyDown() and button == "LeftButton" then ToggleCollectionsJournal(2) end
    if button == "LeftButton" and not IsShiftKeyDown() then
        if db.id ~= nil then C_PetJournal_SummonPetByGUID(db.id) end
    end
    if IsShiftKeyDown() and button == "RightButton" then
        if IsAddOnLoaded("Blizzard_PetJournal") then
            ToggleDropDownMenu(1, nil, PetJournalFilterDropDown, self, 0, 0)
        else
            C_AddOns_LoadAddOn("Blizzard_PetJournal")
            ToggleDropDownMenu(1, nil, PetJournalFilterDropDown, self, 0, 0)
        end
    end
end

local function OnEnter(self)
    DT:SetupTooltip(self)
    local _, numOwned = C_PetJournal_GetNumPets(false)
    DT.tooltip:AddLine((L["%sElvUI|r NihilistzscheUI - Companions Datatext"]):format(hexColor), 1, 1, 1)
    DT.tooltip:AddLine(("     %s"):format(L["<Left Click> to resummon/dismiss pet"]))
    DT.tooltip:AddLine(("     %s"):format(L["<Right Click> to open pet list"]))
    DT.tooltip:AddLine(("     %s"):format(L["<Shift + Left Click> to open pet journal"]))
    DT.tooltip:AddLine(("     %s"):format(L["<Shift + Right Click> to open filter menu"]))
    DT.tooltip:AddLine(("     %s"):format(L["<Alt + Click> to reset your favorites."]))
    DT.tooltip:AddLine(" ")
    DT.tooltip:AddLine(("     %s"):format(L["<Click> a pet to summon/dismiss it."]))
    DT.tooltip:AddLine(("     %s"):format(L["<Shift + Left Click> a pet to pick it up"]))
    DT.tooltip:AddLine(("     %s"):format(L["<Alt + Click> a pet to set as favorite 1"]))
    DT.tooltip:AddLine(("     %s"):format(L["<Ctrl + Click> a pet to set as favorite 2"]))
    DT.tooltip:AddLine(("     %s"):format(L["<Ctrl + Alt + Click> a pet to set as favorite 3"]))
    if numOwned == 0 then
        DT.tooltip:AddLine("|cffff0000You have no pets|r")
    else
        DT.tooltip:AddLine(format("|cff00ff00You have %s pets|r", numOwned))
    end
    DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
    displayString = join("", hex, "%s|r")
    hexColor = hex
end

F:RegisterEvent("PLAYER_ENTERING_WORLD")
F:SetScript("OnEvent", function(self)
    db = E.private.nihilistzscheui.pets
    self.initialize = CreateMenu
    self.displayMode = "MENU"
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

DT:RegisterDatatext(
    L["Battle Pets"],
    "NihilistzscheUI",
    { "PLAYER_ENTERING_WORLD", "COMPANION_UPDATE", "PET_JOURNAL_LIST_UPDATE" },
    OnEvent,
    UpdateDisplay,
    OnClick,
    OnEnter,
    nil,
    nil,
    nil,
    ValueColorUpdate
)
