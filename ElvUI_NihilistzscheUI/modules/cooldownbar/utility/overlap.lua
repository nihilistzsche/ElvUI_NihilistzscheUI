local NUI = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

local tinsert = _G.tinsert
local tremove = _G.tremove
local tContains = _G.tContains

function CB:AddToOverlapGroup(frame) tinsert(self.overlapGroups, frame) end

function CB:FindFrameIndexInOverlapGroup(frame)
    for i = 1, #self.overlapGroups do
        if self.overlapGroups[i] == frame then return i end
    end

    return -1
end

function CB:RemoveFromOverlapGroup(frame)
    tremove(self.overlapGroups, self:FindFrameIndexInOverlapGroup(frame))
    if #self.overlapGroups == 0 then self.frameLevelSerial = 0 end
end

function CB:InOverlapGroup(frame) return tContains(self.overlapGroups, frame) end

function CB:RotateOverlapGroups()
    local frame = tremove(self.overlapGroups)
    if frame and frame:IsShown() then
        self.frameLevelSerial = self.frameLevelSerial + 5
        frame:SetFrameLevel(self.frameLevelSerial)
        tinsert(self.overlapGroups, 1, frame)
    end
end

function CB:CheckOverlap(current)
    local l, r = current:GetLeft(), current:GetRight()

    if not l or not r then return end

    local seenOverlap = false

    for _, icon in ipairs(self.liveFrames) do
        if icon ~= current then
            local ir, il = icon:GetLeft(), icon:GetRight()

            if ir and il then
                if (ir >= l and ir <= r) or (il >= l and il <= r) then
                    local overlap = math.min(math.abs(ir - l), math.abs(il - r))

                    if overlap >= 0 then
                        seenOverlap = true
                        if not self:InOverlapGroup(current) then self:AddToOverlapGroup(current) end
                        if not self:InOverlapGroup(icon) then self:AddToOverlapGroup(icon) end
                    end
                end
            end
        end
    end

    if not seenOverlap and self:InOverlapGroup(current) then self:RemoveFromOverlapGroup(current) end
end
