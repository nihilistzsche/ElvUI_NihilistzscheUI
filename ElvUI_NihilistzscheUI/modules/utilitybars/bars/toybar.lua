local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
if not E.Retail then return end
local TOYB = NUI.UtilityBars.ToyBar
local NUB = NUI.UtilityBars

local C_ToyBox_GetIsFavorite = _G.C_ToyBox.GetIsFavorite
local C_ToyBox_GetNumToys = _G.C_ToyBox.GetNumToys
local C_ToyBox_GetToyFromIndex = _G.C_ToyBox.GetToyFromIndex
local C_ToyBox_HasFavorites = _G.C_ToyBox.HasFavorites
local tinsert = _G.tinsert
local CreateFrame = _G.CreateFrame

function TOYB.CreateBar()
    -- luacheck: no max line length
    local bar = NUB:CreateBar(
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

    if not C_ToyBox_HasFavorites() then return toys end

    for i = 1, C_ToyBox_GetNumToys() do
        local itemID = C_ToyBox_GetToyFromIndex(i)

        if C_ToyBox_GetIsFavorite(itemID) then tinsert(toys, itemID) end
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

    local bar = self.CreateBar()
    self.bar = bar
    self.ignoreCombatLockdown = true

    self.hooks = {}

    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(TOYB)
