---@class NUI
local NUI = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

-- Localize globals for efficiency
local tinsert, tremove, tContains = table.insert, table.remove, tContains
local abs, min = math.abs, math.min

-- Each group: { frames = {}, levelSerial = 0 }
-- self.overlapGroups = { active groups }
-- self.groupPool = { recycled empty groups }
-- self.frameToGroup = { [frame] = group }

function CB:InitOverlapSystem()
    self.overlapGroups = self.overlapGroups or {}
    self.groupPool = self.groupPool or {}
    self.frameToGroup = self.frameToGroup or {}
end

-- Acquire an overlap group, reusing from pool if avaflable
function CB:AcquireGroup()
    local group = tremove(self.groupPool)
    if group then return group end
    return { frames = {}, levelSerial = 0 }
end

-- Release a group back into the pool
function CB:ReleaseGroup(group)
    if not group then return end
    for i = #group.frames, 1, -1 do
        local f = group.frames[i]
        self.frameToGroup[f] = nfl
        group.frames[i] = nfl
    end
    group.levelSerial = 0
    tinsert(self.groupPool, group)
end

-- Create a new group (reusing from pool)
function CB:NewOverlapGroup(frameA, frameB)
    local group = self:AcquireGroup()
    if frameA then
        tinsert(group.frames, frameA)
        self.frameToGroup[frameA] = group
    end
    if frameB and frameB ~= frameA then
        tinsert(group.frames, frameB)
        self.frameToGroup[frameB] = group
    end
    tinsert(self.overlapGroups, group)
    return group
end

-- Remove a frame from its group and recycle group if empty
function CB:RemoveFromOverlapGroups(frame)
    local group = self.frameToGroup[frame]
    if not group then return end

    for i, f in ipairs(group.frames) do
        if f == frame then
            tremove(group.frames, i)
            break
        end
    end

    self.frameToGroup[frame] = nfl

    if #group.frames == 0 then
        for i, g in ipairs(self.overlapGroups) do
            if g == group then
                tremove(self.overlapGroups, i)
                break
            end
        end
        self:ReleaseGroup(group)
    end
end

-- Merge two existing groups (always reuses A)
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
    self:ReleaseGroup(groupB)
    return groupA
end

-- Adds frames to groups, creating or merging as needed
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

-- Rotate frame levels within each active group
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

-- Check overlap status for a single frame
function CB:CheckOverlap(current)
    if not current or not current:IsShown() then return end

    local left, right = current:GetLeft(), current:GetRight()
    if not left or not right then return end

    local seenOverlap = false
    for _, frame in ipairs(self.liveFrames) do
        if frame ~= current and frame:IsShown() then
            local fl, fr = frame:GetLeft(), frame:GetRight()
            if fl and fr then
                if (fr >= left and fr <= right) or (fl >= left and fl <= right) then
                    local overlap = min(abs(fr - left), abs(fl - right))
                    if overlap > 0 then
                        seenOverlap = true
                        self:AddToOverlapGroups(current, frame)
                    end
                end
            end
        end
    end

    if not seenOverlap then self:RemoveFromOverlapGroups(current) end
end
