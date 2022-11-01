local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local PBAS = NUI.PetBattleAutoStart
if not PBAS then return end

function PBAS:GenerateOptions()
    local options = {
        type = "group",
        name = "Pet Battle AutoStart",
        get = function(info) return E.db.nihilistzscheui.petbattleautostart[info[#info]] end,
        set = function(info, value) E.db.nihilistzscheui.petbattleautostart[info[#info]] = value end,
        args = {
            header = {
                order = 1,
                type = "header",
                name = "Pet Battle AutoStart",
            },
            description = {
                order = 2,
                type = "description",
                name = "Pet Battle AutoStart auto accepts pet battle trainer quests, gossip options, and starts fights.",
            },
            autoStartBattle = {
                order = 3,
                type = "toggle",
                name = "Auto Start Battle",
                desc = "Automatically start trainer pet battles",
            },
            autoQuestAccept = {
                order = 4,
                type = "toggle",
                name = "Auto Quest Accept",
                desc = "Automatically Accept Trainer quests",
            },
            autoQuestComplete = {
                order = 5,
                type = "toggle",
                name = "Auto Quest Complete",
                desc = "Automatically Complete Trainer quests",
            },
        },
    }
    return options
end
