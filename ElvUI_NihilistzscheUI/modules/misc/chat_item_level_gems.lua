local NUI, E = unpack((select(2, ...)))

local CILG = NUI.Misc.ChatItemLevelGems
local COMP = NUI.Compatibility

local LibItemGem = LibStub("LibItemGem.7000")
local C_Item_GetItemInfo = _G.C_Item.GetItemInfo
local C_Item_GetDetailedItemLevelInfo = _G.C_Item.GetDetailedItemLevelInfo

hooksecurefunc(COMP, "MerathilisUICompatibility", function(self) E.db.mui.chat.iLevelLink = false end)

--  Chat ItemLevel  --
----------------------

local Caches = {}

local function ChatItemLevel(Hyperlink)
    if Caches[Hyperlink] then return Caches[Hyperlink] end
    local link = string.match(Hyperlink, "|H(.-)|h")
    local name, _, _, _, _, class, subclass, _, equipSlot = C_Item_GetItemInfo(link)
    local level = C_Item_GetDetailedItemLevelInfo(link)
    local yes = true
    if level then
        if equipSlot and string.find(equipSlot, "INVTYPE_") then
            level = format("%s(%s)", level, _G[equipSlot] or equipSlot)
        elseif class == ARMOR then
            level = format("%s(%s)", level, class)
        elseif subclass and string.find(subclass, RELICSLOT) then
            level = format("%s(%s)", level, RELICSLOT)
        else
            yes = false
        end
        if yes then
            local gem = ""
            local num, info = LibItemGem:GetItemGemInfo(link)
            for i = 1, num do
                gem = gem .. "|TInterface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic:0|t"
            end
            if gem ~= "" then gem = gem .. " " end
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":" .. name .. "]|h" .. gem)
        end
        Caches[Hyperlink] = Hyperlink
    end
    return Hyperlink
end

local function filter(self, event, msg, ...)
    msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", ChatItemLevel)
    return false, msg, ...
end

function CILG:Initialize()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)
end

NUI:RegisterModule(CILG:GetName())
