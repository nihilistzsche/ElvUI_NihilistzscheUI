local NUI, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
if not E.Retail then return end
local CDB = NUI.CustomDataBar
local NT = NUI.Libs.NT

local UnitHonor = _G.UnitHonor
local UnitHonorMax = _G.UnitHonorMax
local UnitHonorLevel = _G.UnitHonorLevel

function CDB.RegisterHonorTags()
    NT:RegisterTag("honor:current", function()
        local min, max = UnitHonor("player"), UnitHonorMax("player")

        return CDB:GetFormattedText("CURRENT", min, max)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:max", function()
        local _, max = UnitHonor("player"), UnitHonorMax("player")

        return CDB:GetFormattedText("CURRENT", max, max)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:percent", function()
        local min, max = UnitHonor("player"), UnitHonorMax("player")

        return CDB:GetFormattedText("PERCENT", min, max)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:tonext", function()
        local min, max = UnitHonor("player"), UnitHonorMax("player")

        return CDB:GetFormattedText("TONEXT", min, max)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:current-percent", function()
        local min, max = UnitHonor("player"), UnitHonorMax("player")

        return CDB:GetFormattedText("CURRENT_PERCENT", min, max)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:current-max", function()
        local min, max = UnitHonor("player"), UnitHonorMax("player")

        return CDB:GetFormattedText("CURRENT_MAX", min, max)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:current-max-percent", function()
        local min, max = UnitHonor("player"), UnitHonorMax("player")

        return CDB:GetFormattedText("CURRENT_MAX_PERCENT", min, max)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:bars", function()
        local min, max = UnitHonor("player"), UnitHonorMax("player")

        return CDB:GetFormattedText("BUBBLES", min, max)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:level", function()
        local level = UnitHonorLevel("player")

        return CDB:GetFormattedText("CURRENT", level)
    end, "HONOR_XP_UPDATE")

    NT:RegisterTag("honor:nextlevel", function()
        local level = UnitHonorLevel("player")

        return CDB:GetFormattedText("CURRENT", level + 1)
    end, "HONOR_XP_UPDATE")
end
