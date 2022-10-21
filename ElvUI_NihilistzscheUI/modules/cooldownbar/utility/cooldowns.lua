local NUI = _G.unpack(select(2, ...))
local CB = NUI.CooldownBar

local GetSpellCooldown = _G.GetSpellCooldown
local GetItemCooldown = _G.GetItemCooldown
local GetTime = _G.GetTime

function CB:SpellIsOnCooldown(spellID)
	if (not spellID or self.db.blacklist.spells[spellID]) then
		return false
	end

	local start, duration = GetSpellCooldown(spellID)

	if (start ~= 0 and duration > 1.5) then
		return true
	end

	return false
end

function CB:ItemIsOnCooldown(itemID)
	if (self.db.blacklist.items[itemID]) then
		return false
	end

	local start, duration = GetItemCooldown(itemID)

	if (start ~= 0 and duration > 1.5) then
		return true
	end

	return false
end

-- luacheck: no self
function CB:GetCooldown(frame)
	local start, duration
	if (frame.type == "spell") then
		start, duration = GetSpellCooldown(frame.spellID)
	else
		start, duration = GetItemCooldown(frame.itemID)
	end

	if (start ~= 0 and duration > 1.5) then
		return (start + duration) - GetTime(), start, duration
	end

	return 0
end
