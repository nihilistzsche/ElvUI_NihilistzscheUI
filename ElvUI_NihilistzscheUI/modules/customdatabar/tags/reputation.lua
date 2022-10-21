local NUI = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
local CDB = NUI.CustomDataBar
local NT = NUI.Libs.NT

local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = _G.C_Reputation.GetFactionParagonInfo
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local GetFriendshipReputation = _G.GetFriendshipReputation

function CDB.RegisterRepTags()
    local function GetParagonInfo(factionID)
        if (C_Reputation_IsFactionParagon(factionID)) then
            local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
            local min, max = 0, threshold
            local value = currentValue % threshold
            if hasRewardPending then
                value = value + threshold
            end
            return true, min, max, value
        end

        return false
    end

    NT:RegisterTag(
        "rep:name",
        function()
            local name = GetWatchedFactionInfo()

            if not name then
                return ""
            end

            return name
        end,
        "UPDATE_FACTION"
    )

    NT:RegisterTag(
        "rep:standing",
        function()
            local name, reaction, _, _, _, factionID = GetWatchedFactionInfo()
            local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID)
            if not name then
                return ""
            end

            if (not friendID and GetParagonInfo(factionID)) then
                return "Paragon"
            end

            return friendID and friendTextLevel or _G["FACTION_STANDING_LABEL" .. reaction]
        end,
        "UPDATE_FACTION"
    )

    NT:RegisterTag(
        "rep:current",
        function()
            local name, _, min, max, value, factionID = GetWatchedFactionInfo()

            if not name then
                return ""
            end

            local isParagon, pmin, pmax, pvalue = GetParagonInfo(factionID)
            if (isParagon) then
                min, max, value = pmin, pmax, pvalue
            end

            return CDB:GetFormattedText("CURRENT", value - min, max - min)
        end,
        "UPDATE_FACTION"
    )

    NT:RegisterTag(
        "rep:tonext",
        function()
            local name, _, min, max, value, factionID = GetWatchedFactionInfo()

            if not name then
                return ""
            end

            local isParagon, pmin, pmax, pvalue = GetParagonInfo(factionID)
            if (isParagon) then
                min, max, value = pmin, pmax, pvalue
            end

            return CDB:GetFormattedText("TONEXT", value - min, max - min)
        end,
        "UPDATE_FACTION"
    )

    NT:RegisterTag(
        "rep:current-percent",
        function()
            local name, _, min, max, value, factionID = GetWatchedFactionInfo()

            if not name then
                return ""
            end

            local isParagon, pmin, pmax, pvalue = GetParagonInfo(factionID)
            if (isParagon) then
                min, max, value = pmin, pmax, pvalue
            end

            return CDB:GetFormattedText("CURRENT_PERCENT", value - min, max - min)
        end,
        "UPDATE_FACTION"
    )

    NT:RegisterTag(
        "rep:current-max",
        function()
            local name, _, min, max, value, factionID = GetWatchedFactionInfo()

            if not name then
                return ""
            end

            local isParagon, pmin, pmax, pvalue = GetParagonInfo(factionID)
            if (isParagon) then
                min, max, value = pmin, pmax, pvalue
            end

            return CDB:GetFormattedText("CURRENT_MAX", value - min, max - min)
        end,
        "UPDATE_FACTION"
    )

    NT:RegisterTag(
        "rep:current-max-percent",
        function()
            local name, _, min, max, value, factionID = GetWatchedFactionInfo()

            if not name then
                return ""
            end

            local isParagon, pmin, pmax, pvalue = GetParagonInfo(factionID)
            if (isParagon) then
                min, max, value = pmin, pmax, pvalue
            end

            return CDB:GetFormattedText("CURRENT_MAX_PERCENT", value - min, max - min)
        end,
        "UPDATE_FACTION"
    )
end
