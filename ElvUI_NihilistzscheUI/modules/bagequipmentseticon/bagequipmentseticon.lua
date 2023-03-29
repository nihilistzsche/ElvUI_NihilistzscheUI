local NUI, E = unpack((select(2, ...)))
local B = E:GetModule("Bags")

local BESI = NUI.BagEquipmentSetIcon

function BESI:UpdateSlot(bagID, slotID)
    if not self.db.enabled then return end
    if
        (self.Bags[bagID] and self.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID))
        or not self.Bags[bagID]
        or not self.Bags[bagID][slotID]
    then
        return
    end

    local slot = self.Bags[bagID][slotID]
    if not slot then return end

    if not slot.eqSetIcon then
        local eqSetIcon = slot:CreateTexture(nil, "OVERLAY")
        eqSetIcon:Size(20, 20)
        eqSetIcon:Point("BOTTOMRIGHT")
        eqSetIcon:SetTexCoord(E.TexCoords)
        slot.eqSetIcon = eqSetIcon
    end

    local itemID = GetContainerItemID(bagID, slotID)
    local setIDs = C_EquipmentSet.GetEquipmentSetIDs()

    local eqSetIcon = slot.eqSetIcon

    local setIcon = nil
    for _, setID in ipairs(setIDs) do
        local itemIDs = C_EquipmentSet.GetItemIDs(setID)
        if tContains(itemIDs, itemID) then
            setIcon = select(2, C_EquipmentSet.GetEquipmentSetInfo(setID))
            break
        end
    end
    if setIcon then
        eqSetIcon:SetTexture(setIcon)
        eqSetIcon:Show()
    else
        eqSetIcon:Hide()
    end
end

function BESI:HookElvUIBags()
    if not B.BagFrames then return end
    for _, bagFrame in pairs(B.BagFrames) do
        for _, bagID in pairs(bagFrame.BagIDs) do
            for slotID = 1, GetContainerNumSlots(bagID) do
                self:UpdateSlot(bagID, slotID)
            end
        end
    end
end

function BESI:Initialize()
    NUI:RegisterDB(self, "bagequipmentseticon")
    hooksecurefunc(B, "Layout", function(self) BESI:HookElvUIBags() end)
end

NUI:RegisterModule(BESI:GetName())
