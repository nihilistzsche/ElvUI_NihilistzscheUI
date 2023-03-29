local NUI, E = _G.unpack((select(2, ...)))
local ADB = NUI.AnimatedDataBars
local DB = E.DataBars
local COMP = NUI.Compatibility

local REP = ADB:NewDataBar()

local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local GetNumFactions = _G.GetNumFactions
local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = _G.C_Reputation.GetFactionParagonInfo
local GetFactionInfo = _G.GetFactionInfo
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
    local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()
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
        min, max = 0, majorFactionData.renownLevelThreshold
        value = isCapped and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0
        isMajorFaction = true
    end
    local numFactions = GetNumFactions()

    local level

    for i = 1, numFactions do
        local factionName, _, standingID, _, _, _, _, _, _, _, _, _, _, _factionID = GetFactionInfo(i)
        if _factionID then
            local success, data = xpcall(C_GossipInfo_GetFriendshipReputation, E.noop, _factionID)
            local friendID, friendRep, friendThreshold, nextFriendThreshold
            if success then
                friendID, friendRep, friendThreshold, nextFriendThreshold =
                    data.friendshipFactionID, data.standing, data.reactionThreshold, data.nextThreshold
            end
            if factionName == name then
                if friendID and friendID ~= 0 then
                    -- do something different for friendships
                    local rankData = C_GossipInfo_GetFriendshipReputationRanks(friendID)
                    level = rankData.currentLevel
                    if nextFriendThreshold then
                        min, max, value = friendThreshold, nextFriendThreshold, friendRep
                    else
                        -- max rank, make it look like a full bar
                        min, max, value = 0, 1, 1
                    end
                    reaction = friendRep
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

function REP:OnEnter()
    REP.OrigOnEnter(DB.StatusBars.Reputation)
    if DB.db.reputation.mouseover then E:UIFrameFadeIn(self, 0.4, self:GetAlpha(), 1) end
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, -4)

    local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()

    local standing = _G["FACTION_STANDING_LABEL" .. reaction]
    if C_Reputation_IsFactionParagon(factionID) then
        local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
        min, max = 0, threshold
        value = currentValue % threshold
        if hasRewardPending then value = value + threshold end
        standing = "Paragon"
    end

    if C_Reputation_IsMajorFaction(factionID) then
        local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
        local isCapped = C_MajorFactions_HasMaximumRenown(factionID)
        min, max = 0, majorFactionData.renownLevelThreshold
        value = isCapped and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0
        standing = RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel
    end

    local data = C_GossipInfo_GetFriendshipReputation(factionID)
    local friendID, friendTextLevel = data.friendshipFactionID, data.text

    if name then
        GameTooltip:AddLine(name)
        GameTooltip:AddLine(" ")

        GameTooltip:AddDoubleLine(STANDING .. ":", friendID ~= 0 and friendTextLevel or standing, 1, 1, 1)
        GameTooltip:AddDoubleLine(
            REPUTATION .. ":",
            format(
                "%d / %d (%d%%)",
                value - min,
                max - min,
                (value - min) / ((max - min == 0) and max or (max - min)) * 100
            ),
            1,
            1,
            1
        )
    end
    GameTooltip:Show()
end

function REP:Initialize()
    self:GetParent():CreateAnimatedBar(self, "Reputation")
    self.OrigOnEnter = DB.ReputationBar_OnEnter
    function DB:ReputationBar_OnEnter() REP:OnEnter() end
end

ADB:RegisterDataBar(REP)
