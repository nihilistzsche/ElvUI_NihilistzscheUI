---@class NUI
local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local DBN = NUI.DataBarNotifier

function DBN.GenerateOptions()
    local options = {
        type = "group",
        name = L.DataBarNotifier,
        get = function(info) return E.db.nihilistzscheui.databarnotifier[info[#info]] end,
        set = function(info, value) E.db.nihilistzscheui.databarnotifier[info[#info]] = value end,
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["NihilistzscheUI DataBarNotifier by Nihilistzsche"],
            },
            description = {
                order = 2,
                type = "description",
                name = L["NihilistzscheUI DataBarNotifier prints out messages to a given chat frame when you gain experience, reputation, artifact xp, or honor.\n"],
            },
            general = {
                order = 3,
                type = "group",
                name = L.General,
                guiInline = true,
                args = {
                    enabled = {
                        type = "toggle",
                        order = 1,
                        name = L.Enable,
                        desc = L["Enable the watcher."],
                    },
                    resetsettings = {
                        type = "execute",
                        order = 2,
                        name = L["Reset Settings"],
                        desc = L["Reset the settings of this addon to their defaults."],
                        func = function()
                            E:CopyTable(E.db.nihilistzscheui.databarnotifier, P.nihilistzscheui.databarnotifier)
                        end,
                    },
                },
            },
            expRepWatcherOptions = {
                order = 4,
                type = "group",
                name = L["DataBarNotifier Options"],
                set = function(info, value)
                    if not tonumber(value) then value = "0" end
                    E.db.nihilistzscheui.databarnotifier[info[#info]] = value
                end,
                guiInline = true,
                args = {
                    xpchatframe = {
                        name = "XPChatFrame",
                        type = "input",
                        order = 1,
                        desc = L["Chat Frame to output XP messages to.  1-10.  Enter 0 to disable xp watcher."],
                    },
                    repchatframe = {
                        name = "RepChatFrame",
                        type = "input",
                        order = 1,
                        desc = L["Chat Frame to output rep messages to.  1-10.  Enter 0 to disable rep watcher."],
                    },
                    axpchatframe = {
                        name = "ArtifactXPChatFrame",
                        type = "input",
                        order = 1,
                        desc = L["Chat Frame to output Artifact XP messages to.  1-10.  Enter 0 to disable artifact xp watcher."],
                    },
                    honorchatframe = {
                        name = "HonorChatFrame",
                        type = "input",
                        order = 1,
                        desc = L["Chat Frame to output Honor messages to.  1-10.  Enter 0 to disable honor watcher."],
                    },
                },
            },
        },
    }

    return options
end
