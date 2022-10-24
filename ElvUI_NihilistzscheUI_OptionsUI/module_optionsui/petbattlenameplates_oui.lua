local NUI, E, L, _, P, _ = _G.unpack(_G.ElvUI_NihilistzscheUI)
local PBN = NUI.PetBattleNameplates
if not PBN then
    return
end

local BattlePetBreedID = _G.IsAddOnLoaded("BattlePetBreedID")
function PBN:AddStyleFilterOptions()
    -- luacheck: push no max line length
    local npTriggerOptions = {
        {
            "isBattlePet",
            "Is Battle Pet",
            "belongs to a battle pet during a pet battle."
        },
        {
            "isNotBattlePet",
            "Is Not Battle Pet",
            "does not belong to a battle pet during a pet battle."
        },
        {
            "isAllyBattlePet",
            "Is Ally Battle Pet",
            "belongs to a pet on the player's team during a pet battle."
        },
        {
            "isEnemyPattlePet",
            "Is Enemy Battle Pet",
            "belongs to a pet on the opponent's team during a pet battle."
        },
        {
            "isActiveBattlePet",
            "Is Active Battle Pet",
            "belongs to a pet who is currently active on either the friendly or opponent side during a pet battle."
        },
        {
            "isNotActiveBattlePet",
            "Is Not Active Battle Pet",
            "does not belong to the currently active pet on either the friendly or opponent side during a pet battle."
        }
    }
    local oldFunc = E.Options.args.nameplates.args.stylefilters.args.selectFilter.set
    E.Options.args.nameplates.args.stylefilters.args.selectFilter.set = function(info, value)
        oldFunc(info, value)
        local nlogo = [[|TInterface\AddOns\ElvUI_NihilistzscheUI\media\textures\nihilistzscheui_logo:12:12|t]]
        local tbl = E.Options.args.nameplates.args.stylefilters.args.triggers.args.combat.args
        if not tbl.isBattlePetPBN then
            local order = 53
            local PROVIDED_BY_NUI = "  This filter is provided by NihilistzscheUI."
            local IF_ENABLED = "If enabled then the filter will only activate when the nameplate "
            for i, v in ipairs(npTriggerOptions) do
                tbl[v[1] .. "PBN"] = {
                    name = nlogo .. v[2],
                    desc = IF_ENABLED .. v[3] .. PROVIDED_BY_NUI,
                    type = "toggle",
                    order = order + (i - 1)
                }
            end
            E.Options.args.nameplates.args.stylefilters.args.triggers.args.instanceType.args.petBattle = {
                name = nlogo .. "Pet Battle",
                type = "toggle",
                order = 20
            }
            E.Options.args.nameplates.args.stylefilters.args.actions.args.show = {
                name = nlogo .. "Show Frame",
                type = "toggle",
                order = 1
            }
            E.Options.args.nameplates.args.stylefilters.args.actions.args.hide.order = 2
            E.Options.args.nameplates.args.stylefilters.args.actions.args.usePortrait.order = 3
            E.Options.args.nameplates.args.stylefilters.args.actions.args.nameOnly.order = 4
            E.Options.args.nameplates.args.stylefilters.args.actions.args.spacer1.order = 5
            E.Options.args.nameplates.args.stylefilters.args.actions.args.scale.order = 6
            E.Options.args.nameplates.args.styleFilters.args.actions.args.alpha.order = 7
        end
    end
    -- luacheck: pop
end

function PBN:GenerateOptions()
    self:AddStyleFilterOptions()
    local options = {
        type = "group",
        name = "Pet Battle Nameplates",
        get = function(info)
            return E.db.nihilistzscheui.petbattlenameplates[info[#info]]
        end,
        set = function(info, value)
            E.db.nihilistzscheui.petbattlenameplates[info[#info]] = value
        end,
        args = {
            header = {
                order = 1,
                type = "header",
                name = "Pet Battle Nameplates"
            },
            description = {
                order = 2,
                type = "description",
                name = "Pet Battle Nameplates allow ElvUI nameplates to work during pet battles, and includes additional style filter triggers you can use with ElvUI's nameplates."
            },
            enabled = {
                order = 3,
                type = "toggle",
                name = L.Enable
            },
            showBreedID = {
                order = 4,
                type = "toggle",
                name = "Show Breed ID",
                desc = "Show the breed ID (retreived from BattlePetBreedID) on the nameplate.",
                disabled = function()
                    return not BattlePetBreedID or not self.db.enabled
                end
            }
        }
    }
    return options
end
