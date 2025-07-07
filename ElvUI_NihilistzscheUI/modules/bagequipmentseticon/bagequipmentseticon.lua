local NUI, E = unpack((select(2, ...)))
local B = E:GetModule("Bags")

local BESI = NUI.BagEquipmentSetIcon
local C_Container_GetContainerNumSlots = _G.C_Container.GetContainerNumSlots
local C_Container_GetContainerItemID = _G.C_Container.GetContainerItemID
local C_EquipmentSet_GetEquipmentSetIDs = _G.C_EquipmentSet.GetEquipmentSetIDs
local C_EquipmentSet_GetItemIDs = _G.C_EquipmentSet.GetItemIDs
local C_EquipmentSet_GetEquipmentSetInfo = _G.C_EquipmentSet.GetEquipmentSetInfo

function BESI:UpdateSlot(bagFrame, bagID, slotID)
    if
        (bagFrame.Bags[bagID] and bagFrame.Bags[bagID].numSlots ~= C_Container_GetContainerNumSlots(bagID))
        or not bagFrame.Bags[bagID]
        or not bagFrame.Bags[bagID][slotID]
    then
        return
    end

    local slot = bagFrame.Bags[bagID][slotID]
    if not slot then return end

    if not BESI.db.enabled then
        if slot.eqSetIcon then slot.eqSetIcon:Hide() end
        return
    end

    if not slot.eqSetIcon then
        local eqSetIcon = CreateFrame("Frame", nil, slot)
        local tex = eqSetIcon:CreateTexture(nil, "OVERLAY")
        eqSetIcon:SetTemplate()
        eqSetIcon:Size(14, 14)
        eqSetIcon:Point("TOPRIGHT", -2, -2)
        tex:SetTexCoord(unpack(E.TexCoords))
        tex:SetInside()
        eqSetIcon.texture = tex
        slot.eqSetIcon = eqSetIcon
    end

    local itemID = C_Container_GetContainerItemID(bagID, slotID)
    local setIDs = C_EquipmentSet_GetEquipmentSetIDs()

    local eqSetIcon = slot.eqSetIcon

    local setIcon = nil
    for _, setID in ipairs(setIDs) do
        local itemIDs = C_EquipmentSet_GetItemIDs(setID)
        if tContains(itemIDs, itemID) then
            setIcon = select(2, C_EquipmentSet_GetEquipmentSetInfo(setID))
            break
        end
    end
    if setIcon then
        eqSetIcon.texture:SetTexture(setIcon)
        eqSetIcon:Show()
    else
        eqSetIcon:Hide()
    end
end

function BESI:Initialize()
    NUI:RegisterDB(self, "bagequipmentseticon")
    hooksecurefunc(B, "UpdateSlot", BESI.UpdateSlot)
end

NUI:RegisterModule(BESI:GetName())
