local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI) --Inport: Engine, Locales, ProfileDB, GlobalDB
if not E.Retail then return end
local TOYB = NUI.UtilityBars.ToyBar
local NUB = NUI.UtilityBars

local C_ToyBox_GetIsFavorite = _G.C_ToyBox.GetIsFavorite
local C_ToyBox_GetNumToys = _G.C_ToyBox.GetNumToys
local C_ToyBox_GetToyFromIndex = _G.C_ToyBox.GetToyFromIndex
local C_ToyBox_HasFavorites = _G.C_ToyBox.HasFavorites
local C_ToyBox_GetCollectedShown = _G.C_ToyBox.GetCollectedShown
local C_ToyBox_GetUncollectedShown = _G.C_ToyBox.GetUncollectedShown
local C_ToyBox_GetUnusableShown = _G.C_ToyBox.GetUnusableShown
local C_ToyBox_SetCollectedShown = _G.C_ToyBox.SetCollectedShown
local C_ToyBox_SetUncollectedShown = _G.C_ToyBox.SetUncollectedShown
local C_ToyBox_SetUnusableShown = _G.C_ToyBox.SetUnusableShown
local C_ToyBox_IsSourceTypeFilterChecked = _G.C_ToyBox.IsSourceTypeFilterChecked
local C_ToyBox_SetSourceTypeFilter = _G.C_ToyBox.SetSourceTypeFilter
local C_ToyBox_SetFilterString = _G.C_ToyBox.SetFilterString
local C_ToyBox_IsExpansionTypeFilterChecked = _G.C_ToyBox.IsExpansionTypeFilterChecked
local C_ToyBox_SetExpansionTypeFilter = _G.C_ToyBox.SetExpansionTypeFilter
local C_ToyBoxInfo_IsUsingDefaultFilters = _G.C_ToyBoxInfo.IsUsingDefaultFilters
local C_ToyBoxInfo_IsToySourceValid = _G.C_ToyBoxInfo.IsToySourceValid
local C_ToyBoxInfo_SetDefaultFilters = _G.C_ToyBoxInfo.SetDefaultFilters
local C_PetJournal_GetNumPetSources = _G.C_PetJournal.GetNumPetSources
local GetNumExpansions = _G.GetNumExpansions
local tinsert = _G.tinsert
local CreateFrame = _G.CreateFrame

function TOYB:CreateBar()
    -- luacheck: no max line length
    local bar = NUB:CreateBar(
        self,
        "NihilistzscheUI_ToyBar",
        "toybar",
        { "BOTTOMRIGHT", _G.RightChatPanel, "TOPRIGHT", 0, 45 },
        "Toy Bar"
    )

    bar.doNotHideInCombat = true

    return bar
end

function TOYB.GetToys()
    local toys = {}
    local oldFilters

    if not C_ToyBoxInfo_IsUsingDefaultFilters() then
        oldFilters = {
            collected = C_ToyBox_GetCollectedShown(),
            uncollected = C_ToyBox_GetUncollectedShown(),
            unusable = C_ToyBox_GetUnusableShown(),
            sources = {},
            expansions = {},
        }
        for i = 1, C_PetJournal_GetNumPetSources() do -- blizzard uses this for toys really
            if C_ToyBoxInfo_IsToySourceValid(i) then oldFilters.sources[i] = C_ToyBox_IsSourceTypeFilterChecked(i) end
        end
        for i = 1, GetNumExpansions() do
            oldFilters.expansions[i] = C_ToyBox_IsExpansionTypeFilterChecked(i)
        end

        -- default filters show all toys (collected/uncollected, all sources/expansions)
        C_ToyBoxInfo_SetDefaultFilters()
    end

    -- anything in search is not counted towards default filters; clear just to be safe.
    -- this is only done a second after login where search should have nothing, but it's possible
    -- a user immediately opened the journal and typed something in

    C_ToyBox_SetFilterString("")
    if not C_ToyBox_HasFavorites() then return toys end

    for i = 1, C_ToyBox_GetNumToys() do
        local itemID = C_ToyBox_GetToyFromIndex(i)

        if C_ToyBox_GetIsFavorite(itemID) then tinsert(toys, itemID) end
    end

    if oldFilters then
        C_ToyBox_SetCollectedShown(oldFilters.collected)
        C_ToyBox_SetUncollectedShown(oldFilters.uncollected)
        C_ToyBox_SetUnusableShown(oldFilters.unusable)
        for i = 1, C_PetJournal_GetNumPetSources() do
            if C_ToyBoxInfo_IsToySourceValid(i) then C_ToyBox_SetSourceTypeFilter(i, oldFilters.sources[i]) end
        end
        for i = 1, GetNumExpansions() do
            C_ToyBox_SetExpansionTypeFilter(i, oldFilters.expansions[i])
        end
    end

    return toys
end

function TOYB:UpdateBar(bar)
    local toys = self.GetToys()

    NUB.CreateButtons(bar, #toys)

    NUB.WipeButtons(bar)

    for i, toy in ipairs(toys) do
        local button = bar.buttons[i]
        NUB.UpdateButtonAsToy(bar, button, toy)
    end

    NUB.UpdateBar(self, bar, "ELVUIBAR30BINDBUTTON")
end

function TOYB:Initialize()
    local frame = CreateFrame("Frame", "NihilistzscheUI_ToyBarController")
    frame:RegisterEvent("TOYS_UPDATED")
    NUB:RegisterEventHandler(self, frame)

    NUB:InjectScripts(self)

    local bar = self:CreateBar()
    self.bar = bar
    self.ignoreCombatLockdown = true

    self.hooks = {}

    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(TOYB)
