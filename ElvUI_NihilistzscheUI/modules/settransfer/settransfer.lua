local NUI, E, L, V, P, G = _G.unpack((select(2, ...)))
if E.Classic then return end
local ST = NUI.SetTransfer
local B = E.Bags
local S = E.Skins

local C_EquipmentSet_GetItemIDs = _G.C_EquipmentSet.GetItemIDs
local C_EquipmentSet_GetEquipmentSetInfo = _G.C_EquipmentSet.GetEquipmentSetInfo
local C_EquipmentSet_GetEquipmentSetIDs = _G.C_EquipmentSet.GetEquipmentSetIDs
local C_EquipmentSet_GetNumEquipmentSets = _G.C_EquipmentSet.GetNumEquipmentSets
local C_Item_GetItemLink = _G.C_Item.GetItemLink
local DEFAULT_CHAT_FRAME = _G.DEFAULT_CHAT_FRAME
local ItemLocation = _G.ItemLocation
local Item = _G.Item
local UseContainerItem = _G.C_Container and _G.C_Container.UseContainerItem or _G.UseContainerItem
local GetContainerNumSlots = _G.C_Container and _G.C_Container.GetContainerNumSlots or _G.GetContainerNumSlots
local tContains = _G.tContains
local UIDropDownMenu_AddButton = _G.UIDropDownMenu_AddButton
local ToggleDropDownMenu = _G.ToggleDropDownMenu
local hooksecurefunc = _G.hooksecurefunc
local wipe = _G.wipe
local menu = {}

local CreateFrame = _G.CreateFrame
local F = CreateFrame("frame")

function ST:WithdrawDepositSetHelper(isWithdraw, setID)
    local itemIDs = C_EquipmentSet_GetItemIDs(setID)
    local setName, setIcon = C_EquipmentSet_GetEquipmentSetInfo(setID)
    local markup = "|T" .. setIcon .. ":12|t "
    local prefix = markup .. setName
    local f = B:GetContainerFrame(isWithdraw)
    B:SortingFadeBags(f)
    for _, bagID in ipairs(f.BagIDs) do
        for slotID = 1, GetContainerNumSlots(bagID) do
            local itemID = B:GetItemID(bagID, slotID)
            if itemID then
                if tContains(itemIDs, itemID) then
                    if self.db.notify then
                        local itemLocation = ItemLocation:CreateFromBagAndSlot(bagID, slotID)
                        local itemLink = C_Item_GetItemLink(itemLocation)
                        if itemLink then
                            local item = Item:CreateFromItemLink(itemLink)
                            item:ContinueOnItemLoad(function()
                                local icon = item:GetItemIcon()
                                local itemMarkup = "|T" .. icon .. ":12|t "
                                local direction = isWithdraw and " |> bags" or "bank <| "
                                local message = isWithdraw and (itemMarkup .. itemLink .. direction)
                                    or (direction .. itemMarkup .. itemLink)
                                message = ("%s (%s)"):format(prefix, message)
                                DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1)
                            end)
                        end
                    end
                    UseContainerItem(bagID, slotID)
                end
            end
        end
    end
    B:SearchRefresh()
end

-- luacheck: push no self
function ST:WithdrawSet(setID) ST:WithdrawDepositSetHelper(true, setID) end
function ST:DepositSet(setID) ST:WithdrawDepositSetHelper(false, setID) end
-- luacheck: pop

local function CreateMenu(_, level)
    wipe(menu)
    level = level or 1

    if level == 1 then
        local ids = C_EquipmentSet_GetEquipmentSetIDs()
        for i = 1, C_EquipmentSet_GetNumEquipmentSets() do
            local setID = ids[i]
            local setName, setIcon = C_EquipmentSet_GetEquipmentSetInfo(setID)
            menu.text = "|T" .. setIcon .. ":12|t " .. setName
            menu.notCheckable = true
            menu.hasArrow = true
            menu.value = setID
            UIDropDownMenu_AddButton(menu, level)
        end
    else
        local setID = _G.UIDROPDOWNMENU_MENU_VALUE
        if setID then
            menu.text = "Withdraw"
            menu.notCheckable = true
            menu.func = ST.WithdrawSet
            menu.arg1 = setID
            UIDropDownMenu_AddButton(menu, level)
            menu.text = "Deposit"
            menu.func = ST.DepositSet
            UIDropDownMenu_AddButton(menu, level)
        end
    end
end

F:RegisterEvent("PLAYER_ENTERING_WORLD")
F:SetScript("OnEvent", function(self)
    self.initialize = CreateMenu
    self.displayMode = "MENU"
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

function ST.CreateButton()
    local button = CreateFrame("Button", nil, B.BankFrame, "BackdropTemplate")
    S:HandleButton(button)
    button.text = button:CreateFontString(nil, "ARTWORK")
    button.text:FontTemplate()
    button.text:SetPoint("CENTER", button, "CENTER")
    button.text:SetText(L["Set Transfer"])
    button:Size(button.text:GetStringWidth() + 4, 12)
    button:SetScript("OnClick", function(self, button) ToggleDropDownMenu(1, nil, F, self, 0, 0) end)
    return button
end

function ST:Initialize()
    NUI:RegisterDB(self, "settransfer")
    self.button = self.CreateButton()
    hooksecurefunc(B, "Layout", function(_, isBank)
        if not isBank then return end
        if _G.BankFrame.selectedTab ~= 1 or not ST.db.enabled then return end
        local f = B:GetContainerFrame(isBank)
        f:SetHeight(f:GetHeight() + 20)
        ST.button:Point("TOPRIGHT", B.BankFrame, "TOPRIGHT", -4, -56)
        ST.button:Show()
        local slot = f.Bags[-1][1]
        local point, relativeTo, relativePoint, xOfs, yOfs = slot:GetPoint()
        slot:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs - 20)
    end)
end

NUI:RegisterModule(ST:GetName())
