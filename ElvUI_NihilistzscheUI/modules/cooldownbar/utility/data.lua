---@class NUI
local NUI = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

local wipe = _G.wipe
local Enum_SpellBookSpellBank_Player = Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player or _G.BOOKTYPE_SPELL
local Enum_SpellBookSpellBank_Pet = Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Pet or _G.BOOKTYPE_PET
local C_SpellBook_GetSpellBookItemInfo = _G.C_SpellBook.GetSpellBookItemInfo or _G.GetSpellBookItemInfo

function CB:ClearCache() wipe(self.cache) end

function CB:UpdateCache()
    self:ClearCache()

    self:CacheSpells(Enum_SpellBookSpellBank_Player)
    self:CacheSpells(Enum_SpellBookSpellBank_Pet)

    self:UpdateSpells()
end

local function checkID(itemInfo)
    if itemInfo.spellID then return itemInfo.spellID end
    if itemInfo.actionID and itemInfo.actionID > 0 then return itemInfo.actionID end
end

function CB:CacheSpells(book)
    for i = 1, 1000 do
        local itemInfo = C_SpellBook_GetSpellBookItemInfo(i, book)
        local id
        if itemInfo then id = checkID(itemInfo) end
        if itemInfo and id then self.cache[id] = true end
    end
end
