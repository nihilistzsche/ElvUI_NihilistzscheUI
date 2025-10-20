---@class NUI
local NUI = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

-- Localize globals for efficiency
local tinsert, tremove, tContains = table.insert, table.remove, tContains
local abs, min = math.abs, math.min

--- Adds one or two frames to the overlap group (no duplicates)
function CB:AddToOverlapGroup(frameA, frameB)
    if frameA and not self:InOverlapGroup(frameA) then tinsert(self.overlapGroups, frameA) end
    if frameB and not self:InOverlapGroup(frameB) then tinsert(self.overlapGroups, frameB) end
end

function CB:FindFrameIndexInOverlapGroup(frame)
    for i, f in ipairs(self.overlapGroups) do
        if f == frame then return i end
    end
    return nil
end

function CB:RemoveFromOverlapGroup(frame)
    local index = self:FindFrameIndexInOverlapGroup(frame)
    if index then
        tremove(self.overlapGroups, index)
        if #self.overlapGroups == 0 then self.frameLevelSerial = 0 end
    end
end

function CB:InOverlapGroup(frame) return tContains(self.overlapGroups, frame) end

function CB:RotateOverlapGroups()
    local frame = tremove(self.overlapGroups)
    if not frame or not frame:IsShown() then return end

    self.frameLevelSerial = self.frameLevelSerial + 5
    frame:SetFrameLevel(self.frameLevelSerial)
    tinsert(self.overlapGroups, 1, frame)
end

function CB:CheckOverlap(current)
    if not current or not current:IsShown() then return end

    local left, right = current:GetLeft(), current:GetRight()
    if not left or not right then return end

    local seenOverlap = false
    for _, icon in ipairs(self.liveFrames) do
        if icon ~= current and icon:IsShown() then
            local il, ir = icon:GetLeft(), icon:GetRight()
            if il and ir then
                if (ir >= left and ir <= right) or (il >= left and il <= right) then
                    local overlap = min(abs(ir - left), abs(il - right))
                    if overlap > 0 then
                        seenOverlap = true
                        self:AddToOverlapGroup(current, icon)
                    end
                end
            end
        end
    end

    if not seenOverlap then self:RemoveFromOverlapGroup(current) end
end
