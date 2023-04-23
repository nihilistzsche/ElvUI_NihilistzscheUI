local NUI = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
local CDB = NUI.CustomDataBar
local NT = NUI.Libs.NT

local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = _G.C_Reputation.GetFactionParagonInfo
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local C_GossipInfo_GetFriendshipReputation = _G.C_GossipInfo.GetFriendshipReputation
local C_Reputation_IsMajorFaction = _G.C_Reputation.IsMajorFaction
local C_MajorFactions_GetMajorFactionData = _G.C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = _G.C_MajorFactions.HasMaximumRenown
function CDB.RegisterRepTags()
    local function GetParagonInfo(factionID)
        if C_Reputation_IsFactionParagon(factionID) then
            local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
            local min, max = 0, threshold
            local value = currentValue % threshold
            if hasRewardPending then value = value + threshold end
            return true, min or 0, max or 0, value
        end

        return false
    end

    local function GetFriendshipInfo(factionID)
        local data = C_GossipInfo_GetFriendshipReputation(factionID)
        if not data or data.friendshipFactionID == 0 then
            return false
        else
            return true, data
        end
    end

    local function GetMajorFactionInfo(factionID)
        if C_Reputation_IsMajorFaction(factionID) then
            local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
            local isCapped = C_MajorFactions_HasMaximumRenown(factionID)
            local min, max = 0, majorFactionData.renownLevelThreshold
            local value = isCapped and majorFactionData.renownLevelThreshold
                or majorFactionData.renownReputationEarned
                or 0
            return true, min, max, value
        end
        return false
    end

    local function GetFactionValues()
        local name, _, min, max, value, factionID = GetWatchedFactionInfo()
        if not factionID then return end
        local isParagon, pmin, pmax, pvalue = GetParagonInfo(factionID)
        if isParagon then
            min, max, value = pmin, pmax, pvalue
        end

        local isMajorFaction, mmin, mmax, mvalue = GetMajorFactionInfo(factionID)
        if isMajorFaction then
            min, max, value = mmin, mmax, mvalue
        end
        local isFriend, data = GetFriendshipInfo(factionID)
        if isFriend and not isParagon then
            min, max, value = data.reactionThreshold, data.nextThreshold or true, data.standing
        end

        return name, min, max, value
    end

    NT:RegisterTag("rep:name", function()
        local name = GetWatchedFactionInfo()

        if not name then return "" end

        return name
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:standing", function()
        local name, reaction, _, _, _, factionID = GetWatchedFactionInfo()
        if not name then return "" end

        local isFriend, friendData = GetFriendshipInfo(factionID)
        if GetParagonInfo(factionID) then return "Paragon" end
        if not isFriend and C_Reputation_IsMajorFaction(factionID) then
            local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
            return RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel
        end
        return isFriend and friendData.reaction or _G["FACTION_STANDING_LABEL" .. reaction]
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:current", function()
        local name, min, max, value = GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("CURRENT", value - min, max - min)
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:tonext", function()
        local name, min, max, value = GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("TONEXT", value - min, max - min)
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:current-percent", function()
        local name, min, max, value = GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("CURRENT_PERCENT", value - min, max - min)
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:current-max", function()
        local name, min, max, value = GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("CURRENT_MAX", value - min, max - min)
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:current-max-percent", function()
        local name, min, max, value = GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("CURRENT_MAX_PERCENT", value - min, max - min)
    end, "UPDATE_FACTION")
end
