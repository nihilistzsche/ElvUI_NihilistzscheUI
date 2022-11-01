local NUI = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

function NI:DynamicCamSetup()
    -- luacheck: no max line length
    self:SetProfile(_G.DynamicCamDB, {
        defaultVersion = 1,
        version = 2,
        situations = {
            ["033"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["023"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["006"] = {
                cameraActions = {
                    zoomFitUseCurAsMin = true,
                    zoomMax = 35,
                    zoomSetting = "fit",
                    zoomFitToggleNameplate = false,
                },
                cameraCVars = {
                    test_cameraTargetFocusEnemyEnable = 1,
                },
            },
            ["302"] = {
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                    zoomSetting = "set",
                    zoomValue = 7,
                },
                cameraCVars = {
                    test_cameraDynamicPitch = 1,
                },
            },
            ["103"] = {
                condition = 'return (GetShapeshiftFormID() == 27 or GetShapeshiftFormID() == 3 or GetShapeshiftFormID() == 29 or GetShapeshiftFormID() == 4) and not UnitAffectingCombat("player");',
                name = "Travel Forms",
                events = {
                    "UPDATE_SHAPESHIFT_FORMS", -- [1]
                    "ZONE_CHANGED_NEW_AREA", -- [2]
                },
                priority = 100,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["034"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["002"] = {
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                    zoomSetting = "in",
                    zoomValue = 8,
                },
            },
            ["100"] = {
                condition = "return IsMounted();",
                cameraCVars = {
                    test_cameraDynamicPitch = 0,
                    test_cameraHeadMovementStrength = 0,
                    test_cameraOverShoulder = 0,
                },
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                    zoomSetting = "out",
                    zoomValue = 30,
                },
            },
            ["200"] = {
                executeOnInit = "this.spells = {136508, 189838, 54406, 94719, 556, 168487, 168499, 171253, 50977, 8690, 222695, 171253, 224869, 53140, 3565, 32271, 193759, 3562, 3567, 33690, 35715, 32272, 49358, 176248, 3561, 49359, 3566, 88342, 88344, 3563, 132627, 132621, 176242, 192085, 192084, 216016, 145430, 375357};",
                cameraActions = {
                    zoomFitToggleNameplate = false,
                    zoomMax = 20,
                    rotateSetting = "degrees",
                    transitionTime = 10,
                    timeIsMax = false,
                    zoomSetting = "in",
                    yawDegrees = 360,
                    rotate = true,
                    zoomValue = 4,
                },
                executeOnEnter = 'local _, _, _, startTime, endTime = UnitCastingInfo("player");\nthis.transitionTime = ((endTime - startTime) - 250)/1000;',
                cameraCVars = {
                    test_cameraDynamicPitch = 0,
                    test_cameraHeadMovementStrength = 0,
                    test_cameraOverShoulder = 0,
                },
                extras = {
                    hideUI = false,
                },
                condition = '        for k,v in pairs(this.spells) do \n            if (UnitCastingInfo("player") == GetSpellInfo(v)) then \n                return true;\n            end\n        end\n        return false;',
            },
            ["102"] = {
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
                cameraCVars = {
                    test_cameraOverShoulder = 0,
                    test_cameraHeadMovementStrength = 0,
                    test_cameraDynamicPitch = 0,
                },
            },
            ["050"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["201"] = {
                executeOnInit = "this.annoyingSpellsToLookFor = {46924, 51690, 188499, 210152};",
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
                cameraCVars = {
                    test_cameraDynamicPitch = 0,
                    test_cameraHeadMovementStrength = 0,
                    test_cameraOverShoulder = 0,
                },
                condition = '    for k,v in pairs(this.annoyingSpellsToLookFor) do \n        name = GetSpellInfo(v)\n        if (AuraUtil.FindAuraByName(name, "player")) then\n            return true;\n        end\n    end\n\n    return false;\n    ',
            },
            ["301"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                    zoomSetting = "in",
                    zoomValue = 4,
                },
            },
            ["005"] = {
                cameraActions = {
                    zoomMax = 20,
                    zoomSetting = "in",
                    zoomFitToggleNameplate = false,
                },
            },
            ["101"] = {
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                    zoomSetting = "set",
                    zoomValue = 15,
                },
                cameraCVars = {
                    test_cameraHeadMovementStrength = 0,
                    test_cameraOverShoulder = -1,
                },
            },
            ["021"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["061"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["001"] = {
                cameraActions = {
                    zoomMax = 20,
                    zoomMin = 10,
                    zoomSetting = "range",
                    zoomFitToggleNameplate = false,
                },
            },
            ["024"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["051"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["004"] = {
                cameraActions = {
                    zoomMax = 20,
                    zoomMin = 15,
                    zoomSetting = "range",
                    zoomFitToggleNameplate = false,
                },
            },
            ["300"] = {
                enabled = false,
                executeOnInit = 'this.frames = {"GarrisonCapacitiveDisplayFrame", "BankFrame", "MerchantFrame", "GossipFrame", "ClassTrainerFrame", "QuestFrame", "ImmersionFrame"}',
                cameraActions = {
                    zoomFitIncrements = 0.5,
                    zoomMax = 30,
                    zoomMin = 3,
                    zoomFitToggleNameplate = false,
                    zoomValue = 4,
                    zoomFitPosition = 90,
                    zoomSetting = "fit",
                },
                cameraCVars = {
                    test_cameraDynamicPitch = 1,
                    test_cameraTargetFocusInteractEnable = 1,
                    test_cameraTargetFocusEnemyEnable = 1,
                },
                condition = 'local shown = false;\nfor k,v in pairs(this.frames) do\n    if (_G[v] and _G[v]:IsShown()) then\n        shown = true;\n    end\nend\nreturn UnitExists("npc") and UnitIsUnit("npc", "target") and shown;',
            },
            ["020"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["030"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["031"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
            ["060"] = {
                enabled = false,
                cameraActions = {
                    zoomMax = 20,
                    zoomFitToggleNameplate = false,
                },
            },
        },
        firstRun = false,
    })
end

NI:RegisterAddOnInstaller("DynamicCam", NI.DynamicCamSetup)
