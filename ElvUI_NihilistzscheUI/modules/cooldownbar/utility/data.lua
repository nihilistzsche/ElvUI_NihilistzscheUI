local NUI = _G.unpack(select(2, ...))
local CB = NUI.CooldownBar

local wipe = _G.wipe
local BOOKTYPE_SPELL = _G.BOOKTYPE_SPELL
local BOOKTYPE_PET = _G.BOOKTYPE_PET
local GetSpellBookItemInfo = _G.GetSpellBookItemInfo

function CB:ClearCache() wipe(self.cache) end

function CB:UpdateCache()
    self:ClearCache()

    self:CacheSpells(BOOKTYPE_SPELL)
    self:CacheSpells(BOOKTYPE_PET)

    self:UpdateSpells()
end

function CB:CacheSpells(book)
    for i = 1, 1000 do
        local skillType, _, _, _, _, _, id = GetSpellBookItemInfo(i, book)
        if skillType and id and id > 0 then self.cache[id] = true end
    end
end
