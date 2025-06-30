---@class NUI
local NUI = _G.unpack((select(2, ...)))

local PXP = NUI.PartyXP
local NT = NUI.Libs.NT
local CDB = NUI.CustomDataBar
local currentPartyMember

function PXP.SetCurrentPartyMember(partyMember) currentPartyMember = partyMember end

function PXP.RegisterTags()
    NT:RegisterTag("pxp:name", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end

        return data.name
    end)

    NT:RegisterTag("pxp:current", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max

        return CDB:GetFormattedText("CURRENT", min, max)
    end, "CHAT_MSG_ADDON")

    NT:RegisterTag("pxp:max", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local _, max = data.current, data.max

        return CDB:GetFormattedText("CURRENT", max, max)
    end, "")

    NT:RegisterTag("pxp:percent", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max

        return CDB:GetFormattedText("PERCENT", min, max)
    end, "")

    NT:RegisterTag("pxp:tonext", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max

        return CDB:GetFormattedText("TONEXT", min, max)
    end, "")

    NT:RegisterTag("pxp:current-percent", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max

        return CDB:GetFormattedText("CURRENT_PERCENT", min, max)
    end, "")

    NT:RegisterTag("pxp:current-max", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max

        return CDB:GetFormattedText("CURRENT_MAX", min, max)
    end, "")

    NT:RegisterTag("pxp:current-max-percent", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max

        return CDB:GetFormattedText("CURRENT_MAX_PERCENT", min, max)
    end, "")

    NT:RegisterTag("pxp:rested", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max
        local rested = data.rested

        return CDB:GetFormattedText("RESTED", min, max, rested)
    end, "")

    NT:RegisterTag("pxp:current-rested", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max
        local rested = data.rested

        if rested and rested > 0 then
            return CDB:GetFormattedText("CURRENT_RESTED", min, max, rested)
        else
            return CDB:GetFormattedText("CURRENT", min, max)
        end
    end, "")

    NT:RegisterTag("pxp:current-percent-rested", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max
        local rested = data.rested

        if rested and rested > 0 then
            return CDB:GetFormattedText("CURRENT_PERCENT_RESTED", min, max, rested)
        else
            return CDB:GetFormattedText("CURRENT_PERCENT", min, max)
        end
    end, "")

    NT:RegisterTag("pxp:current-max-rested", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max
        local rested = data.rested

        if rested and rested > 0 then
            return CDB:GetFormattedText("CURRENT_MAX_RESTED", min, max, rested)
        else
            return CDB:GetFormattedText("CURRENT_MAX", min, max)
        end
    end, "")

    NT:RegisterTag("pxp:current-max-percent-rested", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max
        local rested = data.rested

        if rested and rested > 0 then
            return CDB:GetFormattedText("CURRENT_MAX_PERCENT_RESTED", min, max, rested)
        else
            return CDB:GetFormattedText("CURRENT_MAX_PERCENT", min, max)
        end
    end, "")

    NT:RegisterTag("pxp:bars", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local min, max = data.current, data.max

        return CDB:GetFormattedText("BUBBLES", min, max)
    end, "")

    NT:RegisterTag("pxp:level", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local level = data.level

        return CDB:GetFormattedText("CURRENT", level)
    end, "")

    NT:RegisterTag("pxp:nextlevel", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local level = data.level

        return CDB:GetFormattedText("CURRENT", level + 1)
    end, "")

    NT:RegisterTag("pxp:quest", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local currQXP = data.qxp or 0

        return CDB:GetFormattedText("CURRENT", currQXP)
    end, "")

    NT:RegisterTag("pxp:levelup?", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local currQXP = data.qxp or 0
        local min, max = data.current, data.max
        local cq = currQXP + min
        if cq >= max then
            return "[Level Up!]"
        else
            return ""
        end
    end, "")

    NT:RegisterTag("pxp:quest-percent", function()
        local data = PXP:GetDataForPartyMember(currentPartyMember)
        if not data then return end
        local currQXP = data.qxp or 0
        local max = data.max

        return CDB:GetFormattedText("PERCENT", currQXP, max)
    end, "")
end
