local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local PBCDT = NUI.DataTexts.PetBattleChallengeDataText
if not PBCDT then return end

function PBCDT:GenerateOptions()
    local options = {
        type = "group",
        name = "Pet Battle Challenge Datatext",
        desc = "Datatext showing Pet Battle Challenges",
        get = function(info) return self.db[tonumber(info[#info])] end,
        set = function(info, value) self.db[tonumber(info[#info])] = value end,
        args = {},
    }

    for i, infoPair in ipairs(self.QuestNameToID) do
        if select(4, GetBuildInfo()) >= infoPair[3] then
            options.args[tostring(infoPair[2])] = {
                name = infoPair[1],
                desc = "Show completed status for " .. infoPair[1],
                type = "toggle",
                order = i,
            }
        end
    end

    return options
end
