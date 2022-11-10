local NUI, E, L = _G.unpack(select(2, ...))
local COMP = NUI.Compatibility
local SLE = COMP.SLE and _G["ElvUI_Shadow&Light"][1]
local lib = _G.LibStub("LibElv-GameMenu-1.0")

local tinsert = _G.tinsert
local sort = _G.sort
local strsplit = _G.strsplit
local gsub = _G.gsub
local InCombatLockdown = _G.InCombatLockdown
local IsAddOnLoaded = _G.IsAddOnLoaded
local LoadAddOn = _G.LoadAddOn
local HideUIPanel = _G.HideUIPanel
local C_PetJournal_SetAllPetSourcesChecked = _G.C_PetJournal.SetAllPetSourcesChecked
local C_PetJournal_SetAllPetTypesChecked = _G.C_PetJournal.SetAllPetTypesChecked
local C_PetJournal_SetFilterChecked = _G.C_PetJournal.SetFilterChecked
local LE_PET_JOURNAL_FILTER_COLLECTED = _G.LE_PET_JOURNAL_FILTER_COLLECTED
local LE_PET_JOURNAL_FILTER_NOT_COLLECTED = _G.LE_PET_JOURNAL_FILTER_NOT_COLLECTED
local UnitAffectingCombat = _G.UnitAffectingCombat
local wipe = _G.wipe
local UnitLevel = _G.UnitLevel
local C_PvP_IsWarModeDesired = _G.C_PvP.IsWarModeDesired
local C_PvP_GetWarModeRewardBonus = _G.C_PvP.GetWarModeRewardBonus
local C_AzeriteItem_FindActiveAzeriteItem = _G.C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetAzeriteItemXPInfo = _G.C_AzeriteItem.GetAzeriteItemXPInfo
local C_AzeriteItem_GetPowerLevel = _G.C_AzeriteItem.GetPowerLevel
local GetQuestLogRewardXP = _G.GetQuestLogRewardXP
local C_QuestLog_GetSelectedQuest = _G.C_QuestLog.GetSelectedQuest
local C_QuestLog_GetNumQuestLogEntries = _G.C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_ReadyForTurnIn = _G.C_QuestLog.ReadyForTurnIn
local C_QuestLog_GetInfo = _G.C_QuestLog.GetInfo
local GetQuestUiMapID = _G.GetQuestUiMapID
local C_QuestLog_SetSelectedQuest = _G.C_QuestLog.SetSelectedQuest
local C_QuestLog_IsComplete = _G.C_QuestLog.IsComplete
local GetNumQuestLeaderBoards = _G.GetNumQuestLeaderBoards

function NUI:SetupProfileCallbacks()
    E.data.RegisterCallback(self, "OnProfileChanged", "UpdateAll")
    E.data.RegisterCallback(self, "OnProfileCopied", "UpdateAll")
    E.data.RegisterCallback(self, "OnProfileReset", "UpdateAll")
end

function NUI:AddMoverCategories()
    tinsert(E.ConfigModeLayouts, #E.ConfigModeLayouts + 1, "NIHILISTZSCHEUI")
    E.ConfigModeLocalizedStrings.NIHILISTZSCHEUI = L[self.Title]
end

NUI.SpecialChatIcons = {
    WyrmrestAccord = {
        Dirishia = true,
        Xanikani = true,
        Rikanza = true,
        Onaguda = true,
        Cerishia = true,
        Vellilara = true,
        Sayalia = true,
        Alledarisa = true,
        Orlyrala = true,
        Scerila = true,
        Ralaniki = true,
        Moyanza = true,
        Erasaya = true,
        Linabla = true,
        Dirikoa = true,
        Elaedarel = true,
        Alydrer = true,
        Issia = true,
        Leitara = true,
        Cherlyth = true,
        Tokashami = true,
        Millop = true,
        Aeondalew = true,
    },
}

function NUI.PairsByKeys(startChar, f)
    local a, i = {}, 0
    for n in pairs(startChar) do
        tinsert(a, n)
    end
    sort(a, f)
    local iter = function()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], startChar[a[i]]
        end
    end
    return iter
end

function NUI.InvertTable(t)
    local u = {}
    for k, v in pairs(t) do
        u[v] = k
    end
    return u
end

local nihilistzscheui_chat_icon =
    [[|TInterface\AddOns\ElvUI_NihilistzscheUI\media\textures\nihilistzsche_chat_logo:12:12|t]]
function NUI.GetChatIcon(sender)
    local senderName, senderRealm
    if sender then
        senderName, senderRealm = strsplit("-", sender)
    else
        senderName = E.myname
    end
    senderRealm = senderRealm or E.myrealm
    senderRealm = gsub(senderRealm, " ", "")

    if NUI.SpecialChatIcons[senderRealm] and NUI.SpecialChatIcons[senderRealm][senderName] then
        return nihilistzscheui_chat_icon
    end

    return nil
end

local ACD
function NUI.ClickGameMenu()
    if InCombatLockdown() then return end
    ACD = ACD or E.Libs.AceConfigDialog
    if not ACD then
        if not IsAddOnLoaded("ElvUI_OptionsUI") then LoadAddOn("ElvUI_OptionsUI") end
        ACD = E.Libs.AceConfigDialog
    end
    E:ToggleOptionsUI()
    ACD:SelectGroup("ElvUI", "NihilistzschetUI")
    HideUIPanel(_G.GameMenuFrame)
end

if SLE then
    NUI.SLEBuildGameMenu = SLE.BuildGameMenu
    SLE.BuildGameMenu = function() end
end

function NUI:BuildGameMenu()
    local button = {
        name = "GameMenu_NihilistzschetUIConfig",
        text = NUI.Title,
        func = function() self.ClickGameMenu() end,
    }
    lib:AddMenuButton(button)

    lib:UpdateHolder()

    if SLE then NUI.SLEBuildGameMenu(SLE) end
end

function NUI.FixPetJournal()
    C_PetJournal_SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, true)
    C_PetJournal_SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_PetJournal_SetAllPetTypesChecked(true)
    C_PetJournal_SetAllPetSourcesChecked(true)
end

function NUI:RegenWait(func, ...)
    if not InCombatLockdown() and not UnitAffectingCombat("player") and not UnitAffectingCombat("pet") then
        func(...)
        return
    end

    if not NUI.waitFuncs then NUI.waitFuncs = {} end

    local newArgs = { ... }
    local found = false
    for _, info in ipairs(NUI.waitFuncs) do
        if info.func == func then
            local argsEqual = true
            if #newArgs ~= #info.args then
                argsEqual = false
            else
                for i, arg in ipairs(info.args) do
                    if newArgs[i] ~= arg then
                        argsEqual = false
                        break
                    end
                end
            end
            if argsEqual then
                found = true
                break
            end
        end
    end

    if not found then tinsert(NUI.waitFuncs, { func = func, args = { ... } }) end
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function NUI:PLAYER_REGEN_ENABLED()
    if not NUI.waitFuncs or #NUI.waitFuncs == 0 then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    for _, funcInfo in ipairs(NUI.waitFuncs) do
        funcInfo.func(unpack(funcInfo.args))
    end

    wipe(NUI.waitFuncs)

    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function NUI:UpdateRegisteredDBs()
    if not NUI.RegisteredDBs then return end

    local dbs = NUI.RegisteredDBs

    for tbl, path in pairs(dbs) do
        self:UpdateRegisteredDB(tbl, path)
    end
end

function NUI:UpdateAll()
    self:UpdateRegisteredDBs()
    for _, module in ipairs(self:GetRegisteredModules()) do
        local mod = NUI:GetModule(module)
        if mod and mod.ForUpdateAll then mod:ForUpdateAll() end
    end
end

function NUI.UpdateRegisteredDB(tbl, path)
    if type(path) ~= "string" then return end
    local path_parts = { strsplit(".", path) }
    local _db = E.db.nihilistzscheui
    for _, path_part in ipairs(path_parts) do
        _db = _db[path_part]
    end
    tbl.db = _db
end

function NUI:RegisterDB(tbl, path)
    if not NUI.RegisteredDBs then NUI.RegisteredDBs = {} end
    self.UpdateRegisteredDB(tbl, path)
    NUI.RegisteredDBs[tbl] = path
end

function NUI:GetCurrentQuestXP() return NUI.currentQuestXP end

function NUI.CustomQuestXPWatcher(questXP) NUI.currentQuestXP = questXP end

function NUI.CPW(func)
    return function() return func("player") end
end

local function _GetAzeriteXP()
    local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()
    if not azeriteItemLocation or not azeriteItemLocation:IsEquipmentSlot() then return 0, 0, 0 end

    local x, m = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
    local l = C_AzeriteItem_GetPowerLevel(azeriteItemLocation)

    return x, m, l
end

function NUI.UnitAzeriteXP() return (_GetAzeriteXP()) end

function NUI.UnitAzeriteXPMax() return (select(2, _GetAzeriteXP())) end

function NUI.UnitAzeriteLevel() return (select(3, _GetAzeriteXP())) end

-- Code from LibCandyBar-3.0
function NUI.ResetCandyBarLabelDurationAnchors(bar)
    bar.candyBarDuration:ClearAllPoints()
    bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
    bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)

    bar.candyBarLabel:ClearAllPoints()
    bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
    bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)
end

function NUI.ForEach(tbl, func)
    for _, v in pairs(tbl) do
        func(v)
    end
end

function NUI.ExecIf(condition, func)
    if condition then func() end
end

function NUI.GetID(ID)
    if not ID then return nil end
    if strfind(ID, "item:") then
        return tonumber(strmatch(ID, "\124\124Hitem:(%d+)")), true
    elseif strfind(ID, "currency:") then
        return tonumber(strmatch(ID, "\124\124Hcurrency:(%d+)")), false
    end
end
