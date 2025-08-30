---@diagnostic disable: need-check-nil
---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local ADB = NUI.AnimatedDataBars
local DB = E.DataBars
local COMP = NUI.Compatibility

local REP = ADB:NewDataBar()

local C_Reputation_GetWatchedFactionData = _G.C_Reputation.GetWatchedFactionData
local C_Reputation_GetNumFactions = _G.C_Reputation.GetNumFactions
local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = _G.C_Reputation.GetFactionParagonInfo
local C_Reputation_GetFactionDataByIndex = _G.C_Reputation.GetFactionDataByIndex
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local C_Reputation_IsMajorFaction = E.Retail and _G.C_Reputation.IsMajorFaction
local C_MajorFactions_GetMajorFactionData = E.Retail and _G.C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = E.Retail and _G.C_MajorFactions.HasMaximumRenown
local BLUE_FONT_COLOR = _G.BLUE_FONT_COLOR
local RENOWN_LEVEL_LABEL = _G.RENOWN_LEVEL_LABEL

function REP.GetLevel() return 0 end
-- luacheck: no self
function REP:Update(bar)
    local data = C_Reputation_GetWatchedFactionData()
    if not data then return end
    local value, min, max, reaction, factionID =
        data.currentStanding, data.currentReactionThreshold, data.nextReactionThreshold, data.reaction, data.factionID
    local isParagon = false
    local showReward = false
    local isMajorFaction = false
    if E.Retail then
        if C_Reputation_IsFactionParagon(factionID) then
            local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
            min, max = 0, threshold
            value = currentValue % threshold
            if hasRewardPending then
                value = value + threshold
                showReward = true
            end
            isParagon = true
        end
        if C_Reputation_IsMajorFaction(factionID) then
            local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
            local isCapped = C_MajorFactions_HasMaximumRenown(factionID)
            if not majorFactionData then return end
            min, max = 0, majorFactionData.renownLevelThreshold
            value = isCapped and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0
            isMajorFaction = true
        end
    end

    local isFriend, fdata, rankData = NUI.GetFriendshipInfo(factionID)
    local friendID, friendRep, friendThreshold, nextFriendThreshold
    if isFriend and fdata then
        friendID, friendRep, friendThreshold, nextFriendThreshold =
            fdata.friendshipFactionID, fdata.standing, fdata.reactionThreshold, fdata.nextThreshold
    end
    if isFriend then
        -- do something different for friendships
        reaction = rankData.currentLevel
        local offset = 0
        if rankData.maxLevel < #DB.db.colors.factionColors then
            offset = #DB.db.colors.factionColors - rankData.maxLevel
        end
        if nextFriendThreshold then
            min, max, value = friendThreshold, nextFriendThreshold, friendRep
        else
            -- max rank, make it look like a full bar
            min, max, value = 0, 1, 1
        end
        reaction = math.min(#DB.db.colors.factionColors, reaction + offset)
        factionID = friendID
    end

    if isParagon and COMP.PR then
        local r, g, b = unpack(_G.ParagonReputationDB.value)
        bar.animatedStatusBar:SetStatusBarColor(r, g, b)
        bar.animatedStatusBar:SetAnimatedTextureColors(r, g, b)
        bar.Reward:SetShown(showReward)
    elseif isMajorFaction then
        local color = BLUE_FONT_COLOR
        bar.animatedStatusBar:SetStatusBarColor(color.r, color.g, color.b)
        bar.animatedStatusBar:SetAnimatedTextureColors(color.r, color.g, color.b)
    else
        local color = DB.db.colors.factionColors[reaction] or DB.db.colors.factionColors[1]
        bar.animatedStatusBar:SetStatusBarColor(color.r, color.g, color.b)
        bar.animatedStatusBar:SetAnimatedTextureColors(color.r, color.g, color.b)
    end
    bar.animatedStatusBar:SetAnimatedValues(value, min, max, factionID == bar.lastSeenFaction and reaction or 0)
    if factionID ~= bar.lastSeenFactionID then
        bar.lastSeenFactionID = factionID
        bar.animatedStatusBar:ProcessChangesInstantly()
    end
end

function REP:Initialize()
    local bar = self:GetParent():CreateAnimatedBar(self, "Reputation")
    if C_Reputation.SetWatchedFactionByIndex then
        hooksecurefunc(C_Reputation, "SetWatchedFactionByIndex", function() self:Update(bar) end)
    else
        hooksecurefunc(_G, "SetWatchedFactionIndex", function() self:Update(bar) end)
    end
end

ADB:RegisterDataBar(REP)
