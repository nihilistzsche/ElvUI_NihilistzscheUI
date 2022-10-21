local NUI, E = _G.unpack(select(2, ...))
local PXP = NUI.PartyXP

local strsplit = _G.strsplit
local GetMaxLevelForPlayerExpansion = _G.GetMaxLevelForPlayerExpansion
local GetExpansionLevel = _G.GetExpansionLevel
local UnitName = _G.UnitName

local PXP_UPDATE_THRESHOLD = 30
PXP.currentMessageProgress = 0

function PXP:GROUP_ROSTER_UPDATE()
    self:UpdatePartyMembers()
    self.Message()
    self:Update()
end

function PXP:PLAYER_XP_UPDATE()
    self.Message()
    self:Update()
end

function PXP:PLAYER_ENTERING_WORLD()
    self.Message()
    self:Update()
end

hooksecurefunc(
    NUI,
    "CustomQuestXPWatcher",
    function(questXP)
        PXP.QXPMessage(questXP)
    end
)

function PXP:CHAT_MSG_ADDON(_, ...)
    local prefix, message, _, sender = ...

    if
        (prefix ~= "PXP" and prefix ~= "PXPQXP" and prefix ~= "PXPREQ") or not sender or sender == E.myname or
            strsplit("-", sender) == E.myname
     then
        return
    end

    local guid = self.GetPartyMemberGUIDFromName(sender)

    print(prefix, sender, message)
    if prefix == "PXP" then
        if message == "[DISABLED]" and self:GetDataForPartyMember(guid) and self.GetPartyMemberIndex(sender) then
            self:UpdateData(guid, "disabled", true)
        elseif (self.GetPartyMemberIndex(sender)) then
            local level, current, max, rested = message:match("%[l:(%d+)c:(%d+)m:(%d+)r:(%d+)%]")
            level, current, max, rested = tonumber(level), tonumber(current), tonumber(max), tonumber(rested)

            if level == GetMaxLevelForPlayerExpansion() then
                return
            end

            self:UpdateData(
                guid,
                "name",
                UnitName(self.GetPartyMemberIndex(sender)),
                "level",
                level,
                "current",
                current,
                "max",
                max,
                "rested",
                rested
            )
        else
            self:UpdatePartyMembers()
            return
        end

        self:Update()
        if self.currentMessageProgress == 0 then
            self.Message()
            self.currentMessageProgress = 1
        else
            self.currentMessageProgress = self.currentMessageProgress + 1
            if self.currentMessageProgress > PXP_UPDATE_THRESHOLD then
                self.currentMessageProgress = 0
            end
        end
    elseif prefix == "PXPQXP" then
        local qxp = message:match("%[qxp:(%d+)%]")
        if not self:GetDataForPartyMember(guid) then
            return
        end
        self:UpdateData(guid, "qxp", qxp)
        self:Update()
    elseif prefix == "PXPREQ" then
        self.Message(sender)
    end
end

function PXP:RegisterEvents()
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    self:RegisterEvent("PLAYER_XP_UPDATE")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CHAT_MSG_ADDON")
end

function PXP:UnregisterEvents()
    self:UnregisterEvent("GROUP_ROSTER_UPDATE")
    self:UnregisterEvent("PLAYER_XP_UPDATE")
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("CHAT_MSG_ADDON")
end
