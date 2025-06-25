local NUI = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

local GetInventoryItemCooldown = _G.GetInventoryItemCooldown
local GetInventoryItemID = _G.GetInventoryItemID
local GetContainerNumSlots = _G.C_Container.GetContainerNumSlots
local GetContainerItemID = _G.C_Container.GetContainerItemID
local GetContainerItemCooldown = _G.C_Container.GetContainerItemCooldown
local C_Item_GetItemCooldown = _G.C_Item.GetItemCooldown
local C_ToyBox_GetNumToys = _G.C_ToyBox.GetNumToys
local C_ToyBox_GetToyFromIndex = _G.C_ToyBox.GetToyFromIndex

function CB:UpdateSpells()
    for spellID, _ in pairs(self.cache) do
        if self:SpellIsOnCooldown(spellID) then
            local frame = self:FindFrame("spell", spellID)
            if frame then
                self:UpdateFrame(frame)
            else
                self:CreateFrame("spell", spellID)
            end
            self:Activate()
        end
    end
    self:Update()
end

function CB:UpdateItems()
    for i = 1, 18 do
        local start, duration, active = GetInventoryItemCooldown("player", i)

        if active == 1 and start > 0 and duration > 1.5 then
            local id = GetInventoryItemID("player", i)

            if id then
                local frame = self:FindFrame("item", id)
                if frame then
                    self:UpdateFrame(frame)
                else
                    self:CreateFrame("item", id)
                end
                self:Activate()
            end
        end
    end

    for i = 0, 4 do
        local slots = GetContainerNumSlots(i)

        for j = 1, slots do
            local start, duration, active = GetContainerItemCooldown(i, j)

            if active == 1 and start > 0 and duration > 1.5 then
                local id = GetContainerItemID(i, j)

                if id then
                    local frame = self:FindFrame("item", id)
                    if frame then
                        self:UpdateFrame(frame)
                    else
                        self:CreateFrame("item", id)
                    end
                    self:Activate()
                end
            end
        end
    end
end

function CB:UpdateToys()
    for i = 1, C_ToyBox_GetNumToys() do
        local id = C_ToyBox_GetToyFromIndex(i)

        local start, duration, active = C_Item_GetItemCooldown(id)

        if active and start > 0 and duration > 1.5 then
            local frame = self:FindFrame("item", id)
            if frame then
                self:UpdateFrame(frame)
            else
                self:CreateFrame("item", id)
            end
            self:Activate()
        end
    end
end
