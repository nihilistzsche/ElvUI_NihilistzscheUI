local NUI, E = unpack(_G.ElvUI_NihilistzscheUI)

if not E:IsAddOnEnabled("TotalRP3") then return end

local RPSF = NUI.RPStyleFilter
local NP = E.NamePlates

local getProfile = _G.TRP3_API.register.getUnitIDCurrentProfileSafe
local getUnitID = _G.TRP3_API.utils.str.getUnitID
local getData = _G.TRP3_API.profile.getData

function RPSF.StyleFilterCustomCheck(frame, _, trigger)
    local passed = nil
    if trigger.hasRPProfile then
        if not UnitIsPlayer(frame.unit) then return false end
        local unitID = getUnitID(frame.unit)
        local profileID = unitID and getProfile(unitID)
        if profileID then
            passed = true
        else
            return false
        end
    end
    if trigger.isCurrentlyInCharacter or trigger.isNotCurrentlyInCharacter then
        if not UnitIsPlayer(frame.unit) then return false end
        local unitID = getUnitID(frame.unit)
        local profileID = unitID and getProfile(unitID)
        local value = profileID and tostring(getData("character/RP", profileID))
        if value then
            passed = (
                trigger.isCurrentlyInCharacter and value == "1"
                or trigger.isNotCurrentlyInCharacter and value == "2"
            )
            if not passed then return false end
        else
            return false
        end
    end
    return passed
end

function RPSF:Initialize()
    E.StyleFilterDefaults.triggers.hasRPProfile = false
    E.StyleFilterDefaults.triggers.isCurrentlyInCharacter = false
    E.StyleFilterDefaults.triggers.isNotCurrentlyInCharacter = false
    hooksecurefunc(NP, "StyleFilterConfigure", function() NP.StyleFilterTriggerEvents.FAKE_RPStyleFilterUpdate = 0 end)
    NP:StyleFilterConfigure()
    NP:StyleFilterAddCustomCheck("NihilistzscheUI_RPProfiles", self.StyleFilterCustomCheck)
    local TRP3_Addon = _G.TRP3_API.globals.addon
    _G.TRP3_API.RegisterCallback(
        TRP3_Addon,
        TRP3_Addon.Events.REGISTER_DATA_UPDATED,
        function(_, unitID, profileID, dataType)
            if not unitID then return end
            for np in pairs(NP.Plates) do
                if getUnitID(np.unit) == unitID then NP:StyleFilterUpdate(np, "FAKE_RPStyleFilterUpdate") end
            end
        end
    )

    E.FrameLocks[_G.TRP3_ToolbarFrame.Container] = true
end

NUI:RegisterModule(RPSF:GetName())
