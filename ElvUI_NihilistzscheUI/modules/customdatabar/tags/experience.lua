---@class NUI
local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
local CDB = NUI.CustomDataBar
local NT = NUI.Libs.NT

local UnitLevel = _G.UnitLevel
local UnitXP = _G.UnitXP
local UnitXPMax = _G.UnitXPMax
local GetXPExhaustion = _G.GetXPExhaustion

-- luacheck: no max line length

function CDB.RegisterExperienceTags()
    NT:RegisterTag("xp:current", function()
        local cur = UnitXP("player")

        return CDB:GetFormattedText("CURRENT", cur, cur)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:max", function()
        local _, max = UnitXP("player"), UnitXPMax("player")

        return CDB:GetFormattedText("CURRENT", max, max)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:percent", function()
        local min, max = UnitXP("player"), UnitXPMax("player")

        return CDB:GetFormattedText("PERCENT", min, max)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:tonext", function()
        local min, max = UnitXP("player"), UnitXPMax("player")

        return CDB:GetFormattedText("TONEXT", min, max)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:current-percent", function()
        local min, max = UnitXP("player"), UnitXPMax("player")

        return CDB:GetFormattedText("CURRENT_PERCENT", min, max)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:current-max", function()
        local min, max = UnitXP("player"), UnitXPMax("player")

        return CDB:GetFormattedText("CURRENT_MAX", min, max)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:current-max-percent", function()
        local min, max = UnitXP("player"), UnitXPMax("player")

        return CDB:GetFormattedText("CURRENT_MAX_PERCENT", min, max)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:rested", function()
        local min, max = UnitXP("player"), UnitXPMax("player")
        local rested = GetXPExhaustion()

        return CDB:GetFormattedText("RESTED", min, max, rested)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:current-rested", function()
        local min, max = UnitXP("player"), UnitXPMax("player")
        local rested = GetXPExhaustion()

        if rested and rested > 0 then
            return CDB:GetFormattedText("CURRENT_RESTED", min, max, rested)
        else
            return CDB:GetFormattedText("CURRENT", min, max)
        end
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:current-percent-rested", function()
        local min, max = UnitXP("player"), UnitXPMax("player")
        local rested = GetXPExhaustion()

        if rested and rested > 0 then
            return CDB:GetFormattedText("CURRENT_PERCENT_RESTED", min, max, rested)
        else
            return CDB:GetFormattedText("CURRENT_PERCENT", min, max)
        end
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:current-max-rested", function()
        local min, max = UnitXP("player"), UnitXPMax("player")
        local rested = GetXPExhaustion()

        if rested and rested > 0 then
            return CDB:GetFormattedText("CURRENT_MAX_RESTED", min, max, rested)
        else
            return CDB:GetFormattedText("CURRENT_MAX", min, max)
        end
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:current-max-percent-rested", function()
        local min, max = UnitXP("player"), UnitXPMax("player")
        local rested = GetXPExhaustion()

        if rested and rested > 0 then
            return CDB:GetFormattedText("CURRENT_MAX_PERCENT_RESTED", min, max, rested)
        else
            return CDB:GetFormattedText("CURRENT_MAX_PERCENT", min, max)
        end
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:bars", function()
        local min, max = UnitXP("player"), UnitXPMax("player")

        return CDB:GetFormattedText("BUBBLES", min, max)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:level", function()
        local level = UnitLevel("player")

        return CDB:GetFormattedText("CURRENT", level)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag("xp:nextlevel", function()
        local level = UnitLevel("player")

        return CDB:GetFormattedText("CURRENT", level + 1)
    end, "PLAYER_XP_UPDATE")

    NT:RegisterTag(
        "xp:quest",
        function()
            CDB.currQXP = NUI:GetCurrentQuestXP()
            return CDB:GetFormattedText("CURRENT", CDB.currQXP or 0)
        end,
        "QUEST_ITEM_UPDATE UNIT_QUEST_LOG_CHANGED QUEST_LOG_UPDATE PLAYER_XP_UPDATE UNIT_PORTRAIT_UPDATE PLAYER_ENTERING_WORLD"
    )

    NT:RegisterTag(
        "xp:levelup?",
        function()
            CDB.currQXP = NUI:GetCurrentQuestXP()

            local min, max = UnitXP("player"), UnitXPMax("player")
            local cq = CDB.currQXP + min
            if cq >= max then
                return "[Level Up!]"
            else
                return ""
            end
        end,
        "QUEST_ITEM_UPDATE UNIT_QUEST_LOG_CHANGED QUEST_LOG_UPDATE PLAYER_XP_UPDATE UNIT_PORTRAIT_UPDATE PLAYER_ENTERING_WORLD"
    )

    NT:RegisterTag(
        "xp:quest-percent",
        function()
            CDB.currQXP = NUI:GetCurrentQuestXP()
            local max = UnitXPMax("player")
            return CDB:GetFormattedText("PERCENT", CDB.currQXP or 0, max)
        end,
        "QUEST_ITEM_UPDATE UNIT_QUEST_LOG_CHANGED QUEST_LOG_UPDATE PLAYER_XP_UPDATE UNIT_PORTRAIT_UPDATE PLAYER_ENTERING_WORLD"
    )
end

function CDB.UpdateExperienceTags()
    local questXP = NUI:GetCurrentQuestXP() or 0
    local restedXP = GetXPExhaustion() or 0

    if restedXP > 0 and questXP == 0 then
        return E.db.databars.experience.noQuestTag
    elseif questXP > 0 and restedXP == 0 then
        return E.db.databars.experience.noRestedTag
    elseif restedXP == 0 and questXP == 0 then
        return E.db.databars.experience.noQuestNoRestedTag
    else
        return E.db.databars.experience.tag
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("QUEST_ITEM_UPDATE")
f:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
f:RegisterEvent("QUEST_LOG_UPDATE")
f:RegisterEvent("QUEST_COMPLETE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then self:UnregisterEvent("PLAAYER_ENTERING_WORLD") end
    CDB:UpdateTag("experience")
end)
f:Show()
CDB.ExperienceDriveFrame = f
