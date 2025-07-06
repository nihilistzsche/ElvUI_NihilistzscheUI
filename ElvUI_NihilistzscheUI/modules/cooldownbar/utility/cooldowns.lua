---@class NUI
local NUI = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

local GetTime = _G.GetTime
local C_Spell_GetSpellCooldown = _G.C_Spell.GetSpellCooldown
local C_Container_GetItemCooldown = _G.C_Container.GetItemCooldown

function CB:SpellIsOnCooldown(spellID)
    if not spellID or self.db.blacklist.spells[spellID] then return false end

    local cooldownInfo = C_Spell_GetSpellCooldown(spellID)

    if cooldownInfo and cooldownInfo.isEnabled and cooldownInfo.startTime ~= 0 and cooldownInfo.duration > 1.5 then
        return true
    end

    return false
end

function CB:ItemIsOnCooldown(itemID)
    if self.db.blacklist.items[itemID] then return false end

    local start, duration, enable = C_Container_GetItemCooldown(itemID)

    if enable and start and duration and start ~= 0 and duration > 1.5 then return true end

    return false
end

-- luacheck: no self
function CB:GetCooldown(frame)
    local start, duration
    if frame.type == "spell" then
        local cdInfo = C_Spell_GetSpellCooldown(frame.spellID)
        start = cdInfo.startTime
        duration = cdInfo.duration
    else
        start, duration = C_Container_GetItemCooldown(frame.itemID)
    end

    if start ~= 0 and duration > 1.5 then return (start + duration) - GetTime(), start, duration end

    return 0
end
