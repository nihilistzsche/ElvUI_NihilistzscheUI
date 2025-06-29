local NUI, E = unpack(_G.ElvUI_NihilistzscheUI)
if not E.Retail then return end
local RESF = NUI.RematchExpandedScriptFilter

function RESF:Initialize()
    if not E:IsAddOnEnabled("Rematch") then return end

    if not _G.Rematch then
        self:RegisterEvent("ADDON_LOADED")
    else
        self.ExpandRematchScriptFilterEnvironment()
    end
end

function RESF:ADDON_LOADED(addon)
    if addon == "Rematch" then
        self.ExpandRematchScriptFilterEnvironment()
        self:UnregisterEvent("ADDON_LOADED")
    end
end

function RESF.IsOnTeamInTab(petID, tabName)
    local tabIndex
    for i, v in ipairs(_G.RematchSettings.TeamGroups) do
        if v[1] == tabName then
            tabIndex = i
            break
        end
    end

    if not tabIndex then return end

    for _, v in pairs(_G.RematchSaved) do
        if v.tab and v.tab == tabIndex then
            for i = 1, 3 do
                if v[i] and v[i][1] == petID then return true end
            end
        end
    end

    return false
end

function RESF.IsOnTeam(petID, teamName)
    for k, v in pairs(_G.RematchSaved) do
        if k == teamName or (v.teamName and v.teamName == teamName) then
            for i = 1, 3 do
                if v[i] and v[i][1] == petID then return true end
            end
        end
    end

    return false
end

function RESF.ExpandRematchScriptFilterEnvironment()
    local rematch = _G.Rematch
    local roster = rematch.Roster
    local dialog = _G.RematchDialog
    local panel = dialog.ScriptFilter

    -- code expanded from Rematch
    -- to run in pre-filter setup: sets up script filter environment if code waiting to run.
    -- returns true if successful.
    -- luacheck: no self
    function rematch:SetupScriptEnvironment()
        local code = roster:GetFilter("Script", "code")
        if code then
            rematch.scriptEnvironment = {
                print = print,
                table = table,
                string = string,
                format = _G.format,
                pairs = pairs,
                ipairs = ipairs,
                select = select,
                tonumber = tonumber,
                tostring = tostring,
                random = _G.random,
                type = type,
                C_PetJournal = _G.C_PetJournal,
                C_PetBattles = _G.C_PetBattles,
                GetBreed = panel.GetBreed,
                GetSource = panel.GetSource,
                AllSpeciesIDs = roster.AllSpecies,
                AllPetIDs = roster.AllOwnedPets,
                AllPets = roster.AllPets,
                AllAbilities = panel.AllAbilities,
                IsPetLeveling = function(petID) return rematch:IsPetLeveling(petID) end,
                -- NihilistzscheUI block
                IsOnTeamInTab = function(petID, tabName) return RESF.IsOnTeamInTab(petID, tabName) end,
                IsOnTeam = function(petID, teamName) return RESF.IsOnTeam(petID, teamName) end,
                -- end NihilistzscheUI block
                petInfo = panel.scriptPetInfo,
            }
            -- it's critical that lua errors triggered by scripts not go through normal channels
            -- or it will be Rematch that's believed to be bugged and not the user script >:D
            local ok, func = pcall(function() return assert(loadstring(code, "")) end)
            if ok then -- code successfully parsed into a function, set it to environment
                panel.scriptFunc = func
                setfenv(panel.scriptFunc, rematch.scriptEnvironment)
            else -- code couldn't be turned into a function, throw a custom error with its lua error
                panel:ErrorHandler(func) -- func (second return from pcall) is the lua error instead of the function
            end
        end
    end
end

NUI:RegisterModule(RESF:GetName())
