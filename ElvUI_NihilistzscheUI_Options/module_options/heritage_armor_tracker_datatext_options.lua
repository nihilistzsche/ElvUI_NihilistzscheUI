local NUI, E, _, _, P = unpack(_G.ElvUI_NihilistzscheUI)

local HATDT = NUI.DataTexts.HeritageArmorTrackerDataText
if not HATDT then return end

local C_CreatureInfo_GetRaceInfo = _G.C_CreatureInfo.GetRaceInfo
local C_CreatureInfo_GetFactionInfo = _G.C_CreatureInfo.GetFactionInfo
local GetAchievementInfo = _G.GetAchievementInfo

function HATDT:GenerateOptions()
    local options = {
        type = "group",
        name = "Heritage Armor Tracker Datatext",
        desc = "Datatext showing Heritage Armor status",
        get = function(info) return self.db[tonumber(info[#info])] end,
        set = function(info, value) self.db[tonumber(info[#info])] = value end,
        args = {},
    }
    local ai = 2
    local ci = ai
    NUI.ForEach(self.UnlockRequirements, function(v)
        if v.type == self.AlliedRace then ci = ci + 1 end
    end)

    for k in next, P.nihilistzscheui.heritageArmorTrackerDataText do
        local info = self.UnlockRequirements[k]
        local raceInfo = C_CreatureInfo_GetRaceInfo(k)
        options.args[tostring(k)] = {
            name = raceInfo.raceName,
            desc = "Show heritage armor obtained status for " .. raceInfo.raceName,
            type = "toggle",
            order = info.type == self.AlliedRace and ai or ci,
            disabled = function()
                return info.type == self.AlliedRace and not select(4, GetAchievementInfo(info.unlock_req))
            end,
        }
        if info.type == self.AlliedRace then
            ai = ai + 1
        else
            ci = ci + 1
        end
    end

    return options
end
