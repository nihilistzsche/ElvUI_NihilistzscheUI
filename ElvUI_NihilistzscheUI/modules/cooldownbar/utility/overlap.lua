---@class NUI
local NUI = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

-- Localize globals for efficiency
local tinsert, tremove, tContains = table.insert, table.remove, tContains
local abs, min = math.abs, math.min

-- Each group: { frames = {}, levelSerial = 0 }
-- self.overlapGroups = { group1, group2, ... }
-- self.frameToGroup = { [frame] = group }

function CB:InitOverlapSystem()
    self.overlapGroups = self.overlapGroups or {}
    self.frameToGroup = self.frameToGroup or {}
end

---Creates and registers a new overlap group
function CB:NewOverlapGroup(frameA, frameB)
    local group = { frames = {}, levelSerial = 0 }
    if frameA then
        tinsert(group.frames, frameA)
        self.frameToGroup[frameA] = group
    end
    if frameB and not tContains(group.frames, frameB) then
        tinsert(group.frames, frameB)
        self.frameToGroup[frameB] = group
    end
    tinsert(self.overlapGroups, group)
    return group
end

---Removes a frame from its group
function CB:RemoveFromOverlapGroups(frame)
    local group = self.frameToGroup[frame]
    if not group then return end

    for i, f in ipairs(group.frames) do
        if f == frame then
            tremove(group.frames, i)
            break
        end
    end

    self.frameToGroup[frame] = nil

    -- Remove empty group
    if #group.frames == 0 then
        for i, g in ipairs(self.overlapGroups) do
            if g == group then
                tremove(self.overlapGroups, i)
                break
            end
        end
    end
end

---Merges two groups when their frames overlap
function CB:MergeGroups(groupA, groupB)
    if groupA == groupB then return groupA end
    for _, f in ipairs(groupB.frames) do
        if not tContains(groupA.frames, f) then
            tinsert(groupA.frames, f)
            self.frameToGroup[f] = groupA
        end
    end
    for i, g in ipairs(self.overlapGroups) do
        if g == groupB then
            tremove(self.overlapGroups, i)
            break
        end
    end
    return groupA
end

---Adds two frames to the overlap tracking, merging if needed
function CB:AddToOverlapGroups(frameA, frameB)
    local groupA = self.frameToGroup[frameA]
    local groupB = self.frameToGroup[frameB]

    if groupA and groupB then
        self:MergeGroups(groupA, groupB)
    elseif groupA then
        if frameB and not self.frameToGroup[frameB] then
            tinsert(groupA.frames, frameB)
            self.frameToGroup[frameB] = groupA
        end
    elseif groupB then
        if frameA and not self.frameToGroup[frameA] then
            tinsert(groupB.frames, frameA)
            self.frameToGroup[frameA] = groupB
        end
    else
        self:NewOverlapGroup(frameA, frameB)
    end
end

---Rotates frame levels within each group only
function CB:RotateOverlapGroups()
    for _, group in ipairs(self.overlapGroups) do
        if #group.frames > 1 then
            local frame = tremove(group.frames)
            if frame and frame:IsShown() then
                group.levelSerial = group.levelSerial + 5
                frame:SetFrameLevel(group.levelSerial)
                tinsert(group.frames, 1, frame)
            end
        end
    end
end

---Checks a frame’s overlap status and updates its group membership
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
                        self:AddToOverlapGroups(current, icon)
                    end
                end
            end
        end
    end

    if not seenOverlap then self:RemoveFromOverlapGroups(current) end
end
