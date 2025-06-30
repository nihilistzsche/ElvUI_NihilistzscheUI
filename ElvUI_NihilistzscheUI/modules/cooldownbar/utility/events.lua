---@class NUI
local NUI = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

local C_Timer_After = _G.C_Timer.After

local function CreateFrameClosure()
    local self = CB
    local onCooldown = self:SpellIsOnCooldown(self._spellID)

    if onCooldown then self:CreateFrame("spell", self._spellID) end
end

function CB:UNIT_SPELLCAST_SUCCEEDED(_, ...)
    local unitID, _, spellID = ...

    if unitID ~= "player" and unitID ~= "pet" then return end

    self._spellID = spellID
    C_Timer_After(0.2, CreateFrameClosure)
end

function CB:BAG_UPDATE_COOLDOWN() self:UpdateItems() end

function CB:GET_ITEM_INFO_RECEIVED() self:UpdateItems() end

function CB:SPELL_UPDATE_COOLDOWN() self:UpdateSpells() end

function CB:SPELLS_CHANGED() self:UpdateCache() end

function CB:PLAYER_REGEN_ENABLED() self:Deactivate() end

function CB:PLAYER_REGEN_DISABLED() self:Activate() end

function CB:PLAYER_ENTERING_WORLD()
    for _, frame in pairs(self.liveFrames) do
        frame:SetAlpha(1)
    end
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end
