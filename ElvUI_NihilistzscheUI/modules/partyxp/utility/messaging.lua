local NUI = _G.unpack(select(2, ...))
local PXP = NUI.PartyXP

local C_ChatInfo_RegisterAddonMessagePrefix = _G.C_ChatInfo.RegisterAddonMessagePrefix
local C_ChatInfo_SendAddonMessage = _G.C_ChatInfo.SendAddonMessage
local UnitLevel = _G.UnitLevel
local UnitXP = _G.UnitXP
local UnitXPMax = _G.UnitXPMax
local GetXPExhaustion = _G.GetXPExhaustion
local GetExpansionLevel = _G.GetExpansionLevel
local IsXPUserDisabled = _G.IsXPUserDisabled
local IsInGroup = _G.IsInGroup
local GetMaxLevelForPlayerExpansion = _G.GetMaxLevelForPlayerExpansion
local LE_PARTY_CATEGORY_INSTANCE = _G.LE_PARTY_CATEGORY_INSTANCE

function PXP.InitMessaging()
    C_ChatInfo_RegisterAddonMessagePrefix("PXP")
    C_ChatInfo_RegisterAddonMessagePrefix("PXPQXP")
    C_ChatInfo_RegisterAddonMessagePrefix("PXPREQ")
end

function PXP.Message(sender)
    local current, max = UnitXP("player"), UnitXPMax("player")
    local rested = GetXPExhaustion()
    local level = UnitLevel("player")

    if level == GetMaxLevelForPlayerExpansion() then return end

    local message
    if IsXPUserDisabled() then
        message = "[DISABLED]"
    else
        message = ("[l:%dc:%dm:%dr:%d]"):format(level, current, max, rested)
    end

    if sender then
        C_ChatInfo_SendAddonMessage("PXP", message, "WHISPER", sender)
    else
        C_ChatInfo_SendAddonMessage(
            "PXP",
            message,
            IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY"
        )
    end
end

function PXP.QXPMessage(val)
    local level = UnitLevel("player")

    if level == GetMaxLevelForPlayerExpansion() or IsXPUserDisabled() then return end

    local message = ("[qxp:%d]"):format(val)

    C_ChatInfo_SendAddonMessage("PXPQXP", message, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")
end

function PXP.REQMessage(target)
    local message = "[req]"

    C_ChatInfo_SendAddonMessage("PXPREQ", message, "WHSIPER", target)
end
