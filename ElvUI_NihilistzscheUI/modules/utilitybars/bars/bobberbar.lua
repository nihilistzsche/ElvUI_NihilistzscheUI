local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
if not E.Retail then return end
local BOBB = NUI.UtilityBars.BobberBar
local NUB = NUI.UtilityBars
local FL = NUI.Libs.FL

local PlayerHasToy = _G.PlayerHasToy
local tinsert = _G.tinsert
local CreateFrame = _G.CreateFrame

function BOBB.CreateBar()
    -- luacheck: no max line length
    local bar = NUB:CreateBar(
        "NihilistzscheUI_BobberBar",
        "bobberbar",
        { "BOTTOMRIGHT", _G.RightChatPanel, "TOPRIGHT", 0, 45 },
        "Bobber Bar"
    )

    return bar
end

BOBB.Bobbers = {
    [147310] = true, -- Crate of Bobbers: Floating Totem
    [180993] = true, -- Bat Visage Bobber
    [147311] = true, -- Crate of Bobbers: Replica Gondola
    [147307] = true, -- Crate of Bobbers: Carved Wooden Helm
    [147312] = true, -- Crate of Bobbers: Demon Noggin
    [142530] = true, -- Crate of Bobbers: Tugboat
    [147308] = true, -- Crate of Bobbers: Enchanted Bobber
    [142529] = true, -- Crate of Bobbers: Cat Head
    [143662] = true, -- Crate of Bobbers: Wooden pepe
    [147309] = true, -- Crate of Bobbers: Face of the Forest
    [142532] = true, -- Crate of Bobbers: Murloc Head
    [142528] = true, -- Crate of Bobbers: Can of Worms
    [142531] = true, -- Crate of Bobbers: Squeaky Duck
    [202207] = true, -- Reusable Oversized Bobber
}

function BOBB:GetToys()
    local toys = {}

    for itemID in next, self.Bobbers do
        if PlayerHasToy(itemID) and self.bar.db.bobbers[itemID].enable then tinsert(toys, itemID) end
    end

    return toys
end

function BOBB:UpdateBar(bar)
    local toys = self:GetToys()

    NUB.CreateButtons(bar, #toys)

    NUB.WipeButtons(bar)

    for i, toy in ipairs(toys) do
        local button = bar.buttons[i]
        NUB.UpdateButtonAsToy(bar, button, toy)
    end

    bar.forceHide = (not NUI:HasFishingBuff() and not FL:IsFishingPole())
    NUB.UpdateBar(self, bar, "ELVUIBAR32BINDBUTTON")
    if NUI.OptionsLoaded then
        E.Options.args.NihilistzscheUI.args.modules.args.UtilityBars.args.BobberBar.args.bobbers =
            self:GenerateUtilityBarOptions(true)
    end
end

function BOBB:Initialize()
    local frame = CreateFrame("Frame", "NihilistzscheUI_BobberBarController")
    frame:RegisterEvent("TOYS_UPDATED")
    frame:RegisterEvent("UNIT_AURA")
    NUB:RegisterEventHandler(self, frame)

    NUB:InjectScripts(self)

    local bar = self.CreateBar()
    self.bar = bar
    self.ignoreCombatLockdown = true

    self.hooks = {}

    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(BOBB)
