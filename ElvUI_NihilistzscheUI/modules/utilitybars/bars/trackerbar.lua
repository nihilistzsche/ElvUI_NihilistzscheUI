local NUI, E, L = _G.unpack(_G.ElvUI_NihilistzscheUI) --Inport: Engine, Locales, ProfileDB, GlobalDB

local LSM = E.Libs.LSM

local TB = NUI.UtilityBars.TrackerBar
local NUB = NUI.UtilityBars
local B = E.Bags

local tremove = _G.tremove
local GameTooltip = _G.GameTooltip
local C_Item_GetItemCount = _G.C_Item.GetItemCount
local C_CurrencyInfo_GetCurrencyInfo = _G.C_CurrencyInfo.GetCurrencyInfo
local tContains = _G.tContains
local tinsert = _G.tinsert
local C_Item_GetItemInfo = _G.C_Item.GetItemInfo
local UIErrorsFrame = _G.UIErrorsFrame
local C_CurrencyInfo_GetCurrencyLink = _G.C_CurrencyInfo.GetCurrencyLink
local CreateFrame = _G.CreateFrame
local GetContainerNumSlots = _G.C_Container.GetContainerNumSlots
local GetContainerItemID = _G.C_Container.GetContainerItemID
local ClearCursor = _G.ClearCursor
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
local HybridScrollFrame_GetOffset = _G.HybridScrollFrame_GetOffset
local C_CurrencyInfo_GetCurrencyListInfo = _G.C_CurrencyInfo.GetCurrencyListInfo
local C_CurrencyInfo_GetCurrencyListLink = _G.C_CurrencyInfo.GetCurrencyListLink
local hooksecurefunc = _G.hooksecurefunc

function TB:CreateBar()
    local bar = NUB:CreateBar(
        self,
        "NihilistzscheUI_TrackerBar",
        "trackerbar",
        { "TOPLEFT", E.UIParent, "TOPLEFT", 0, -20 },
        "Tracker Bar"
    )
    NUB.RegisterCreateButtonHook(bar, function(button) self:CreateButtonHook(bar, button) end)
    NUB.RegisterUpdateButtonHook(bar, function(button, ...) self:UpdateButtonHook(button, ...) end)

    return bar
end

function TB:CreateButtonHook(bar, button)
    button.farmed = button:CreateFontString(nil, "OVERLAY")
    button.farmed:FontTemplate(LSM:Fetch("font", E.db.general.font), 10, "THINOUTLINE")
    button.farmed:SetWidth(E:Scale(bar.db.buttonsize) - 4)
    button.farmed:SetHeight(E:Scale(14))
    button.farmed:SetJustifyH("RIGHT")
    button.farmed:Point("BOTTOMRIGHT", 0, 0)
    button.farmed:Show()

    button:RegisterForClicks("AnyDown")
    button:SetScript("OnClick", function(_self, mouseButton)
        if mouseButton == "RightButton" then
            tremove(_G.ElvDB.trackerbar[TB.myname][button.table], button.index)
            self:UpdateBar(bar)
        end
        _self:SetChecked(false)
    end)
end

local boaStr = _G.ITEM_BNETACCOUNTBOUND
local DataStore
function TB:GetItemCount(itemID)
    local count = _G.ElvDB.trackerbar[self.myname].count.items[itemID]
    E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
    E.ScanTooltip:SetItemByID(itemID)
    E.ScanTooltip:Show()
    local bindTypeLines = (_G.GetCVarBool("colorblindmode") and 5) or 4
    local boa = false
    for i = 2, bindTypeLines do
        local line = _G[E.ScanTooltip:GetName() .. ("TextLeft%d"):format(i)]:GetText()
        if not line or line == "" then break end
        if line == boaStr then
            boa = true
            break
        end
    end
    if not DataStore then DataStore = _G.DataStore end
    if boa and DataStore then
        local total = 0
        for _, character in pairs(DataStore:GetCharacters()) do
            local c = DataStore:GetContainerItemCount(character, itemID) or 0
            local mc = DataStore:GetMailItemCount(character, itemID) or 0
            total = total + c + mc
        end
        count = total
    end
    return count
end

function TB:SetItemTooltip(itemID)
    local ret = GameTooltip:SetItemByID(itemID)

    if not self.sessionDB.items[itemID] then return ret end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["Session:"])
    local gained = self.sessionDB.items[itemID].gained
    local lost = self.sessionDB.items[itemID].lost
    local change = gained - lost

    GameTooltip:AddDoubleLine(L["Earned:"], gained, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine(L["Spent:"], lost, 1, 1, 1, 1, 1, 1)
    if change < 0 then
        GameTooltip:AddDoubleLine(L["Deficit:"], -change, 1, 0, 0, 1, 1, 1)
    elseif change > 0 then
        GameTooltip:AddDoubleLine(L["Profit:"], change, 0, 1, 0, 1, 1, 1)
    end
    local count = self:GetItemCount(itemID)
    GameTooltip:AddDoubleLine(L["Total: "], count, 1, 1, 1, 1, 1, 1)

    GameTooltip:Show()

    return ret
end

function TB:SetCurrencyTooltip(currencyID)
    local ret = GameTooltip:SetCurrencyByID(currencyID)

    NUB.AddAltoholicCurrencyInfo(currencyID)

    if not self.sessionDB.currency[currencyID] then return ret end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["Session:"])
    local gained = self.sessionDB.currency[currencyID].gained
    local lost = self.sessionDB.currency[currencyID].lost
    local change = gained - lost

    GameTooltip:AddDoubleLine(L["Earned:"], gained, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine(L["Spent:"], lost, 1, 1, 1, 1, 1, 1)
    if change < 0 then
        GameTooltip:AddDoubleLine(L["Deficit:"], -change, 1, 0, 0, 1, 1, 1)
    elseif change > 0 then
        GameTooltip:AddDoubleLine(L["Profit:"], change, 0, 1, 0, 1, 1, 1)
    end
    local count = _G.ElvDB.trackerbar[TB.myname].count.currency[currencyID]

    GameTooltip:AddDoubleLine(L["Total: "], count, 1, 1, 1, 1, 1, 1)

    GameTooltip:Show()

    return ret
end

function TB:UpdateItemButton(button)
    local v = button.data
    if not self.sessionDB.items[v] then self:AddWatchStartValue(true, v) end

    local count = C_Item_GetItemCount(v, true)
    TB:UpdateAndNotify(true, v, count)
    count = self:GetItemCount(v)
    button.farmed:SetText(count)
    button.texture:SetDesaturated(count == 0)
    button.table = "items"

    button.SetTooltip = function() return self:SetItemTooltip(v) end
end

function TB:UpdateCurrencyButton(button)
    local v = button.data
    if not self.sessionDB.currency[v] then self:AddWatchStartValue(false, v) end
    local info = C_CurrencyInfo_GetCurrencyInfo(v)
    TB:UpdateAndNotify(false, v, info.quantity)
    button.farmed:SetText(info.quantity)
    button.table = "currency"

    button.SetTooltip = function() return self:SetCurrencyTooltip(v) end
end

function TB:UpdateButtonHook(button, type, index)
    button.index = index
    button.count:Hide()
    if type == "item" then
        self:UpdateItemButton(button)
    else
        self:UpdateCurrencyButton(button)
    end
end

function TB:UpdateBar(bar)
    local ElvDB = _G.ElvDB
    local items = ElvDB.trackerbar[TB.myname].items
    local currency = ElvDB.trackerbar[TB.myname].currency

    NUB.CreateButtons(bar, #items + #currency)

    NUB.WipeButtons(bar)

    table.sort(items, function(a, b) return a > b end)
    for i = 1, #items do
        local button = bar.buttons[i]

        NUB.UpdateButtonAsItem(bar, button, items[i], "item", i)
    end

    -- Holy crap why are there strings for the currency ids??
    local fixMePls = {}
    for i, v in pairs(ElvDB.trackerbar[TB.myname].currency) do
        if type(v) ~= "number" then tinsert(fixMePls, i) end
    end

    for _, v in ipairs(fixMePls) do
        ElvDB.trackerbar[TB.myname].currency[v] = tonumber(ElvDB.trackerbar[TB.myname].currency[v])
    end

    table.sort(currency, function(a, b) return a > b end)
    for i = #items + 1, #items + #currency do
        local button = bar.buttons[i]

        local v = currency[i - #items]
        local info = C_CurrencyInfo_GetCurrencyInfo(v)
        button.data = v
        NUB.UpdateButtonAsCustom(bar, button, info.iconFileID, "currency", i - #items)
    end

    NUB.UpdateBar(self, bar, "ELVUIBAR22BINDBUTTON")
end

function TB:AddWatchStartValue(isItem, id)
    if not id then return end
    local table = isItem and "items" or "currency"

    self.sessionDB[table][id] = {}
    self.sessionDB[table][id].gained = 0
    self.sessionDB[table][id].lost = 0
end

function TB:AddWatch(item, id)
    local ElvDB = _G.ElvDB
    local table = item and "items" or "currency"

    local notificationItem = L["Added item watch for %s"]
    local notificationCurrency = L["Added currency watch for %s"]

    if not tContains(ElvDB.trackerbar[TB.myname][table], id) then
        ElvDB.trackerbar[TB.myname].count[table][id] = item and C_Item_GetItemCount(id, true)
            or (C_CurrencyInfo_GetCurrencyInfo(id)).quantity
        tinsert(ElvDB.trackerbar[TB.myname][table], id)
        if E.db.nihilistzscheui.utilitybars.trackerbar.notify then
            local string = item and notificationItem or notificationCurrency
            UIErrorsFrame:AddMessage(
                string:format(item and select(2, C_Item_GetItemInfo(id)) or C_CurrencyInfo_GetCurrencyLink(id))
            )
        end
    end

    self:UpdateBar(self.bar)
end

function TB:HookElvUIBags()
    if not B.BagFrames then return end
    for _, bagFrame in pairs(B.BagFrames) do
        for _, bagID in pairs(bagFrame.BagIDs) do
            if not self.hookedBags[bagID] then
                for slotID = 1, GetContainerNumSlots(bagID) do
                    local button = bagFrame.Bags[bagID][slotID]
                    button:RegisterForClicks("AnyUp", "AnyDown")
                    button:HookScript("OnDoubleClick", function(_, mouseButton)
                        if mouseButton == "LeftButton" then self:AddWatch(true, GetContainerItemID(bagID, slotID)) end
                        ClearCursor()
                    end)
                end
                self.hookedBags[bagID] = true
            end
        end
    end

    if _G.ElvUIReagentBankFrameItem1 and not self.hookedBags[REAGENTBANK_CONTAINER] then
        for slotID = 1, 98 do
            local button = _G["ElvUIReagentBankFrameItem" .. slotID]
            button:RegisterForClicks("AnyUp", "AnyDown")
            button:HookScript("OnDoubleClick", function(_, mouseButton)
                if mouseButton == "LeftButton" then
                    self:AddWatch(true, GetContainerItemID(REAGENTBANK_CONTAINER, slotID))
                end
                ClearCursor()
            end)
        end
        self.hookedBags[REAGENTBANK_CONTAINER] = true
    end
end

function TB:HookCurrencyButtons()
    local count = 0
    for _, button in pairs(TokenFrame.ScrollBox.ScrollTarget) do
        if
            type(button) == "table"
            and not button.isHeader
            and button.RegisterForClicks
            and not button.nui_utibar_hooked
        then
            button:RegisterForClicks("AnyUp", "AnyDown")
            button:HookScript("OnDoubleClick", function(_, mouseButton)
                if mouseButton == "LeftButton" then
                    local offset = HybridScrollFrame_GetOffset(TokenFrameContainer)
                    local _, isHeader = C_CurrencyInfo_GetCurrencyListInfo(i + offset)
                    if not isHeader then
                        local link = C_CurrencyInfo_GetCurrencyListLink(i + offset)
                        local id = tonumber(string.match(link, "currency:(%d+)"))
                        self:AddWatch(false, id)
                    end
                end
                TokenFramePopup:Hide()
            end)
            button.nui_utibar_hooked = true
            count = count + 1
        end
    end
    return count
end

function TB:UpdateAndNotify(item, id, count)
    if not id then return end
    local table = item and "items" or "currency"
    local oldCount = _G.ElvDB.trackerbar[TB.myname].count[table][id] or 0

    local earned = L["You have |cff00ff00earned|r %d %s (|cff00ffffcurrently|r %d)"]
    local lost = L["You have |cffff0000lost|r %d %s (|cff00ffffcurrently|r %d)"]
    local change = count - oldCount
    local link = item and select(2, C_Item_GetItemInfo(id)) or C_CurrencyInfo_GetCurrencyLink(id, 0)
    local notify = E.db.nihilistzscheui.utilitybars.trackerbar.notify
    if change and link and change > 0 then
        self.sessionDB[table][id].gained = self.sessionDB[table][id].gained + change
        if notify then UIErrorsFrame:AddMessage(earned:format(change, link, count)) end
    elseif change and link and change < 0 then
        self.sessionDB[table][id].lost = self.sessionDB[table][id].lost + -change
        if notify then UIErrorsFrame:AddMessage(lost:format(-change, link, count)) end
    end
    _G.ElvDB.trackerbar[TB.myname].count[table][id] = count
end

function TB.FixDataTable()
    local fixed = false
    return fixed
end

local function GetNumberOfTokenFrameButtons()
    local count = 0
    for _, button in pairs(TokenFrame.ScrollBox.ScrollTarget) do
        if type(button) == "table" and not button.isHeader then count = count + 1 end
    end
    return count
end

local function AddTrackWatch(msg)
    msg = msg:gsub("\124", "\124\124")
    local id, type = NUI.GetID(msg)
    if not id or type == nil then
        print("Usage: /tbadd [item or currency link]")
        return
    end
    TB:AddWatch(type, id)
end

function TB:Initialize()
    NUB:InjectScripts(self)

    --[[if (not E.global.nihilistzscheui.farmmigrated) then
		NUI:MigrateFarmDataToTracker();
		E.global.nihilistzscheui.farmmigrated = true;
	end]]
    TB.sessionDB = {}
    TB.sessionDB.items = {}
    TB.sessionDB.currency = {}

    TB.myname = ("%s-%s"):format(E.myname, E.myrealm)
    _G.ElvDB = _G.ElvDB or {}
    local ElvDB = _G.ElvDB
    if not self.FixDataTable() then
        ElvDB.trackerbar = ElvDB.trackerbar or {}
        ElvDB.trackerbar[TB.myname] = ElvDB.trackerbar[TB.myname] or {}
        ElvDB.trackerbar[TB.myname].items = ElvDB.trackerbar[TB.myname].items or {}
        ElvDB.trackerbar[TB.myname].currency = ElvDB.trackerbar[TB.myname].currency or {}
        ElvDB.trackerbar[TB.myname].count = ElvDB.trackerbar[TB.myname].count or {}
        ElvDB.trackerbar[TB.myname].count.items = ElvDB.trackerbar[TB.myname].count.items or {}
        ElvDB.trackerbar[TB.myname].count.currency = ElvDB.trackerbar[TB.myname].count.currency or {}
    end

    local frame = CreateFrame("Frame", "NihilistzscheUI_TrackerBarController")
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("CHAT_MSG_MONEY")
    frame:RegisterEvent("CHAT_MSG_CURRENCY")
    frame:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN")
    frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    NUB:RegisterEventHandler(self, frame)

    local bar = self:CreateBar()

    self.bar = bar
    self.hooks = {}

    self:UpdateBar(bar)

    self.hookedBags = {}
    self:HookElvUIBags()
    hooksecurefunc(B, "Layout", function() self:HookElvUIBags() end)

    hooksecurefunc(_G.TokenFrame, "Update", function()
        if GetNumberOfTokenFrameButtons() ~= self.hookedCurrency then
            self.hookedCurrency = self:HookCurrencyButtons()
        end
    end)

    _G.SLASH_TBADD1 = "/tbadd"
    _G.SlashCmdList.TBADD = AddTrackWatch
end

NUB:RegisterUtilityBar(TB)
