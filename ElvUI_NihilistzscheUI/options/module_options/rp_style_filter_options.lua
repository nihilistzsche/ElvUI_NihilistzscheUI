local NUI, E = unpack(_G.ElvUI_NihilistzscheUI)
local RPSF = NUI.RPStyleFilter

function RPSF:GenerateOptions()
    local PROVIDED_BY_NUI = "  This filter is provided by NihilistzscheUI."
    local IF_ENABLED = "If enabled then the filter will only activate when the nameplate "
    local nlogo = [[|TInterface\AddOns\ElvUI_NihilistzscheUI\media\textures\nihilistzscheui_logo:12:12|t]]
    local oldFunc = E.Options.args.nameplates.args.stylefilters.args.selectFilter.set
    E.Options.args.nameplates.args.stylefilters.args.selectFilter.set = function(info, value)
        oldFunc(info, value)
        -- luacheck: push  no max line length
        if not E.Options.args.nameplates.args.stylefilters.args.triggers.args.combat.args.hasRPProfile then
            E.Options.args.nameplates.args.stylefilters.args.triggers.args.combat.args.hasRPProfile = {
                name = nlogo .. "Unit Has TRP3 Profile",
                desc = IF_ENABLED .. "belongs to a unit that has a TotalRP3 profile." .. PROVIDED_BY_NUI,
                type = "toggle",
                order = 75,
            }
            E.Options.args.nameplates.args.stylefilters.args.triggers.args.combat.args.isCurrentlyInCharacter = {
                name = nlogo .. "Unit Is Currently In Character",
                desc = IF_ENABLED
                    .. "belongs to a unit that has a TotalRP3 profile and is currently in character."
                    .. PROVIDED_BY_NUI,
                type = "toggle",
                order = 76,
            }
            E.Options.args.nameplates.args.stylefilters.args.triggers.args.combat.args.isNotCurrentlyInCharacter = {
                name = nlogo .. "Unit Is Not Currently In Character",
                desc = IF_ENABLED
                    .. "belongs to a unit that has a TotalRP3 profile and is currently out of character."
                    .. PROVIDED_BY_NUI,
                type = "toggle",
                order = 77,
            }
        end
        --luacheck: pop
    end
end
