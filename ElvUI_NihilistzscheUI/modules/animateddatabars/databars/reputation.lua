---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local ADB = NUI.AnimatedDataBars
local DB = E.DataBars
local COMP = NUI.Compatibility

local REP = ADB:NewDataBar()

local GetWatchedFactionData = _G.C_Reputation.GetWatchedFactionData
local GetNumFactions = _G.C_Reputation.GetNumFactions
local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = _G.C_Reputation.GetFactionParagonInfo
local C_Reputation_GetWatchedFactionData = _G.C_Reputation.GetWatchedFactionData
local GetFactionDataByIndex = _G.C_Reputation.GetFactionDataByIndex
local C_GossipInfo_GetFriendshipReputation = _G.C_GossipInfo.GetFriendshipReputation
local C_GossipInfo_GetFriendshipReputationRanks = _G.C_GossipInfo.GetFriendshipReputationRanks
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local GameTooltip = _G.GameTooltip
local STANDING = _G.STANDING
local REPUTATION = _G.REPUTATION
local format = _G.format
local xpcall = _G.xpcall
local C_Reputation_IsMajorFaction = _G.C_Reputation.IsMajorFaction
local C_MajorFactions_GetMajorFactionData = _G.C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = _G.C_MajorFactions.HasMaximumRenown
local BLUE_FONT_COLOR = _G.BLUE_FONT_COLOR
local RENOWN_LEVEL_LABEL = _G.RENOWN_LEVEL_LABEL

function REP.GetLevel() return 0 end

-- luacheck: no self
function REP:Update(bar)
    local ID
    local data = GetWatchedFactionData()
    if not data then return end
    local name, value, min, max, level, factionID =
        data.name,
        data.reaction,
        data.currentReactionThreshold,
        data.nextReactionThreshold,
        data.currentStanding,
        data.factionID
    local isParagon = false
    local showReward = false
    local isMajorFaction = false
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
    local numFactions = GetNumFactions()

    local reaction

    for i = 1, numFactions do
        local _data = GetFactionDataByIndex(i)
        if _data then
            local _factionID = _data.factionID
            local standingID = _data.currentStanding
            local success, fdata = xpcall(C_GossipInfo_GetFriendshipReputation, E.noop, _factionID)
            local friendID, friendRep, friendThreshold, nextFriendThreshold
            if success and fdata then
                friendID, friendRep, friendThreshold, nextFriendThreshold =
                    fdata.friendshipFactionID, fdata.standing, fdata.reactionThreshold, fdata.nextThreshold
            end
            if _data.name == name then
                if friendID and friendID ~= 0 then
                    -- do something different for friendships
                    local rankData = C_GossipInfo_GetFriendshipReputationRanks(friendID)
                    level = rankData.currentLevel
                    local offset = 8 - rankData.maxLevel
                    if nextFriendThreshold then
                        min, max, value = friendThreshold, nextFriendThreshold, friendRep
                    else
                        -- max rank, make it look like a full bar
                        min, max, value = 0, 1, 1
                    end
                    reaction = level + offset
                    ID = friendID
                else
                    ID = standingID
                    level = reaction
                end
            end
        end
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
        local color = FACTION_BAR_COLORS[reaction] or FACTION_BAR_COLORS[1]
        bar.animatedStatusBar:SetStatusBarColor(color.r, color.g, color.b)
        bar.animatedStatusBar:SetAnimatedTextureColors(color.r, color.g, color.b)
    end
    bar.animatedStatusBar:SetAnimatedValues(value, min, max, ID == bar.lastSeenFaction and level or 0)
    if ID ~= bar.lastSeenFactionID then
        bar.lastSeenFactionID = ID
        bar.animatedStatusBar:ProcessChangesInstantly()
    end
end

function REP:Initialize() self:GetParent():CreateAnimatedBar(self, "Reputation") end

ADB:RegisterDataBar(REP)
