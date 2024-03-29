local NUI = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
local CDB = NUI.CustomDataBar
local NT = NUI.Libs.NT

local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local C_Reputation_IsMajorFaction = _G.C_Reputation.IsMajorFaction
local C_MajorFactions_GetMajorFactionData = _G.C_MajorFactions.GetMajorFactionData
function CDB.RegisterRepTags()
    NT:RegisterTag("rep:name", function()
        local name = GetWatchedFactionInfo()

        if not name then return "" end

        return name
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:standing", function()
        local name, reaction, _, _, _, factionID = GetWatchedFactionInfo()
        if not name then return "" end

        local isFriend, friendData = NUI.GetFriendshipInfo(factionID)
        if NUI.GetParagonInfo(factionID) then return "Paragon" end
        if not isFriend and C_Reputation_IsMajorFaction(factionID) then
            local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
            return RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel
        end
        return isFriend and friendData.reaction or _G["FACTION_STANDING_LABEL" .. reaction]
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:current", function()
        local name, min, max, value = NUI.GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("CURRENT", value - min, max - min)
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:tonext", function()
        local name, min, max, value = NUI.GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("TONEXT", value - min, max - min)
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:current-percent", function()
        local name, min, max, value = NUI.GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("CURRENT_PERCENT", value - min, max - min)
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:current-max", function()
        local name, min, max, value = NUI.GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("CURRENT_MAX", value - min, max - min)
    end, "UPDATE_FACTION")

    NT:RegisterTag("rep:current-max-percent", function()
        local name, min, max, value = NUI.GetFactionValues()

        if not name then return "" end

        if type(max) == "boolean" then return "MAX" end
        return CDB:GetFormattedText("CURRENT_MAX_PERCENT", value - min, max - min)
    end, "UPDATE_FACTION")
end
