---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
if not E.Retail then return end
local ADB = NUI.AnimatedDataBars

local UnitHonor = _G.UnitHonor
local UnitHonorMax = _G.UnitHonorMax
local UnitHonorLevel = _G.UnitHonorLevel

local HN = ADB:NewDataBar(NUI.CPW(UnitHonor), NUI.CPW(UnitHonorMax), NUI.CPW(UnitHonorLevel))

function HN:Initialize() self:GetParent():CreateAnimatedBar(self, "Honor") end

ADB:RegisterDataBar(HN)
