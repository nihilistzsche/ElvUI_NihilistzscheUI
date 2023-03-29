local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
if not E.Retail then return end

local ETOYB = NUI.UtilityBars.EngineerToyBar
local NUB = NUI.UtilityBars

local C_ToyBox_GetNumToys = _G.C_ToyBox.GetNumToys
local C_ToyBox_GetToyFromIndex = _G.C_ToyBox.GetToyFromIndex
local tinsert = _G.tinsert
local CreateFrame = _G.CreateFrame
local tContains = _G.tContains

function ETOYB.CreateBar()
    -- luacheck: no max line length
    local bar = NUB:CreateBar(
        "NihilistzscheUI_EngineerToyBar",
        "engineertoybar",
        { "BOTTOMRIGHT", _G.RightChatPanel, "TOPRIGHT", 0, 65 },
        "Engineer Toy Bar"
    )

    return bar
end

ETOYB.EngineerToys = {
    112059,
    48933,
    87215,
    30542,
    18984,
    30544,
    18986,
    60854,
    87214,
    111821,
    151652,
    168667,
    168807,
    168808,
    172924,
}

table.sort(ETOYB.EngineerToys)

ETOYB.EngineeringSkillID = 202

function ETOYB:IsEngineer()
    for _, v in pairs({ _G.GetProfessions() }) do
        local _, _, _, _, _, _, skillID = _G.GetProfessionInfo(v)
        if skillID == self.EngineeringSkillID then return true end
    end
    return false
end

function ETOYB:GetToys(bar)
    local toys = {}

    for i = 1, C_ToyBox_GetNumToys() do
        local itemID = C_ToyBox_GetToyFromIndex(i)

        if tContains(self.EngineerToys, itemID) then
            local shouldInsert
            if bar.db.toys[itemID] == nil then
                shouldInsert = true
            else
                shouldInsert = bar.db.toys[itemID]
            end
            if shouldInsert then tinsert(toys, itemID) end
        end
    end

    return toys
end

function ETOYB:UpdateBar(bar)
    if not self:IsEngineer() then
        _G.RegisterStateDriver(bar, "visibility", "hide")
        return
    else
        _G.RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")
    end

    local toys = self:GetToys(bar)

    NUB.CreateButtons(bar, #toys)

    NUB.WipeButtons(bar)

    for i, toy in ipairs(toys) do
        local button = bar.buttons[i]
        NUB.UpdateButtonAsToy(bar, button, toy)
    end

    NUB.UpdateBar(self, bar, "ELVUIBAR39BINDBUTTON")
end

function ETOYB:Initialize()
    local frame = CreateFrame("Frame", "NihilistzscheUI_EngineerToyBarController")
    frame:RegisterEvent("TOYS_UPDATED")
    NUB:RegisterEventHandler(self, frame)

    NUB:InjectScripts(self)

    local bar = self.CreateBar()
    self.bar = bar

    self.hooks = {}

    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(ETOYB)
