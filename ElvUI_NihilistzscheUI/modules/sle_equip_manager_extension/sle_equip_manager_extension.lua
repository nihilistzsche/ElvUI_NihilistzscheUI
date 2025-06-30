---@class NUI
local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local COMP = NUI.Compatibility

if not COMP.SLE then return end

local SEME = NUI.SLEEquipManagerExtension
local FL = NUI.Libs.FL
local INVSLOT_HEAD = _G.INVSLOT_HEAD
local GetInventoryItemID = _G.GetInventoryItemID

SEME.EngineeringHelmIDs = {
    [172905] = true,
    [172906] = true,
    [172907] = true,
    [172908] = true,
}

function SEME.IsFishing() return NUI:HasFishingBuff() or FL:IsFishingPole() end

function SEME.HasEngineeringHelm() return SEME.EngineeringHelmIDs[GetInventoryItemID("player", INVSLOT_HEAD)] end

local EM = _G["ElvUI_SLE"][1].EquipManager
local EMInitialize = EM.Initialize
EM.Initialize = E.noop

-- luacheck: push no self
function SEME:PLAYER_REGEN_DISABLED()
    EM:UnregisterEvent("UNIT_AURA")
    EM.Events.UNIT_AURA = nil
end

function SEME:PLAYER_REGEN_ENABLED() EM:RegisterNewEvent("UNIT_AURA") end
-- luacheck: pop

function SEME:Initialize()
    local db = E.private.sle.equip
    if not db or not db.enable then return end

    EM.TagsTable.fishing = SEME.IsFishing
    EM.TagsTable.engineering = SEME.HasEngineeringHelm
    EM:RegisterNewEvent("UNIT_AURA")
    EMInitialize(EM)
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

NUI:RegisterModule(SEME:GetName())
