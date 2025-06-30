---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local LSM = E.Libs.LSM

local format = _G.format
local ceil = _G.ceil
local floor = _G.floor
local GetTime = _G.GetTime
local CreateFrame = _G.CreateFrame
local UnitAura = _G.UnitAura
local UnitIsFriend = _G.UnitIsFriend
local DebuffTypeColor = _G.DebuffTypeColor

function VUF:ConstructDebuffs(frame)
    self:AddElement(frame, "debuffs")
    local debuffs = self:CreateFrame(frame, "debuffs")

    debuffs.size = 26
    debuffs.num = 36
    debuffs.stacks = {}
    debuffs.rows = {}

    debuffs.spacing = 2
    debuffs.initialAnchor = "TOPRIGHT"
    debuffs["growth-y"] = "UP"
    debuffs["growth-x"] = "LEFT"
    debuffs.PreUpdate = UF.PreUpdateAura
    debuffs.PostCreateButton = UF.Construct_AuraIcon
    debuffs.PostUpdateButton = UF.PostUpdateAura
    debuffs.CustomFilter = UF.AuraFilter
    debuffs.type = "debuffs"

    -- an option to show only our debuffs on target
    --[[if unit == "target" then
		debuffs.onlyShowPlayer = C.unitframes.onlyselfdebuffs
	end]]
    return debuffs
end

function VUF:ConstructBuffs(frame)
    self:AddElement(frame, "buffs")
    local buffs = self:CreateFrame(frame, "buffs")

    buffs.size = 26
    buffs.num = 36
    buffs.numRow = 9
    buffs.stacks = {}
    buffs.rows = {}

    buffs.spacing = 2
    buffs.initialAnchor = "TOPLEFT"
    buffs.PreUpdate = UF.PreUpdateAura
    buffs.PostCreateButton = UF.Construct_AuraIcon
    buffs.PostUpdateButton = UF.PostUpdateAura
    buffs.CustomFilter = UF.AuraFilter
    buffs.type = "buffs"

    return buffs
end

function VUF:BuffOptions(unit)
    return self:GenerateElementOptionsTable(unit, "buffs", 725, "Buffs", true, true, false, false, false)
end

function VUF:DebuffOptions(unit)
    return self:GenerateElementOptionsTable(unit, "debuffs", 750, "Debuffs", true, true, false, false, false)
end
