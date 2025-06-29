local NUI, E, _, _, P = unpack((select(2, ...)))
if not E.Retail then return end
local DT = E.DataTexts
local PBCDT = NUI.DataTexts.PetBattleChallengeDataText
local COMP = NUI.Compatibility

local CreateFrame = _G.CreateFrame
local GetBuildInfo = _G.GetBuildInfo
local C_QuestLog_IsQuestFlaggedCompleted = _G.C_QuestLog.IsQuestFlaggedCompleted
local HIGHLIGHT_FONT_COLOR_CODE = _G.HIGHLIGHT_FONT_COLOR_CODE
local wipe = _G.wipe
local UIDropDownMenu_AddButton = _G.UIDropDownMenu_AddButton
local NORMAL_FONT_COLOR_CODE = _G.NORMAL_FONT_COLOR_CODE
local GREEN_FONT_COLOR_CODE = _G.GREEN_FONT_COLOR_CODE
local DISABLED_FONT_COLOR_CODE = _G.DISABLED_FONT_COLOR_CODE
local GameTooltip = _G.GameTooltip
local GameTooltip_Hide = _G.GameTooltip_Hide
local ToggleDropDownMenu = _G.ToggleDropDownMenu
local RED_FONT_COLOR_CODE = _G.RED_FONT_COLOR_CODE

local F = CreateFrame("Frame")
local menu = {}

local TomTom = _G.TomTom

PBCDT.QuestNameToID = {
    { "Celestial Tournament", 33137, 50400 },
    { "Wailing Caverns", 45539, 70200 },
    { "Deadmines", 46292, 70300 },
    { "Gnomeregan", 54186, 80100 },
    { "Stratholme", 56492, 80200 },
    { "Blackrock Depths", 58458, 80300 },
}

PBCDT.DropdownEntries = {
    {
        "Pandaria Master Tamers and Spirit Tamers",
        {
            [{ "Wastewalker Shu", 422, 0.55, 0.38, "Dread Wastes 55 38" }] = 31957,
            [{ "Corageous Yon", 379, 0.36, 0.74, "Kun-Lai Summit 36 74" }] = 31956,
            [{ "Mo'ruk", 418, 0.6502, 0.4272, "Krasarang Wilds 65.02 42.72" }] = 31954,
            [{ "Hyuna of the Shrines", 371, 0.48, 0.54, "The Jade Forest 48 54" }] = 31953,
            [{ "Seeker Zusshi", 388, 0.36, 0.52, "Townlong Steppes 36 52" }] = 31991,
            [{ "Farmer Nishi", 376, 0.46, 0.44, "Valley of the Four Winds 46 44" }] = 31955,
            [{ "Aki the Chosen", 390, 0.31, 0.74, "Vale of Eternal Blossoms 31 74" }] = 31958,
            [{ "Flowing Pandaren Spirit", 422, 0.6118, 0.8752, "Dread Wastes 61.18 87.52" }] = 32439,
            [{ "Whispering Pandaren Spirit", 371, 0.2891, 0.3603, "The Jade Forest 28.91 36.03" }] = 32440,
            [{ "Thundering Pandaren Spirit", 379, 0.648, 0.936, "Kun-Lai Summit 64.8 93.6" }] = 32441,
            [{ "Burning Pandaren Spirit", 388, 0.570, 0.422, "Townlong Steppes 57.0 42.2" }] = 32434,
        },
        {
            "Thundering Pandaren Spirit",
            "Whispering Pandaren Spirit",
            "Hyuna of the Shrines",
            "Farmer Nishi",
            "Mo'ruk",
            "Flowing Pandaren Spirit",
            "Wastewalker Shu",
            "Aki the CHosen",
            "Corageous Yon",
            "Burning Pandaren Spirit",
            "Seeker Zusshi",
        },
    },
    {
        "Beasts of Fable",
        {
            [{
                { "Ka'wi the Gorger", 371, 0.4842, 0.7096, "The Jade Forest 48.42 70.96" },
                { "Kafi", 379, 0.3518, 0.5617, "Kun-Lai Summit 35.18 56.17" },
                { "Dos-Ryga", 379, 0.6787, 0.8469, "Kun-Lai Summit 67.87 84.69" },
                { "Nitun", 371, 0.5704, 0.2912, "The Jade Forest 57.04 29.12" },
            }] = 32604,
            [{
                { "Greyhoof", 376, 0.2529, 0.7854, "Valley of the Four Winds 25.29 78.54" },
                { "Lucky Yi", 376, 0.4054, 0.4367, "Valley of the Four Winds 40.54 43.67" },
                { "Skitterer Xi'a", 418, 0.3623, 0.3734, "Krasarang Wilds 36.23 37.34" },
            }] = 36868,
            [{
                { "Gorespine", 422, 0.2618, 0.5027, "Dread Wastes 26.18 50.27" },
                { "No-No", 390, 0.11, 0.71, "Vale of Eternal Blossoms 11 71" },
                { "Ti'un the Wanderer", 388, 0.7226, 0.7976, "Townlong Steppes 72.26 79.78" },
            }] = 32869,
        },
        {
            "Lucky Yi",
            "No-No",
            "Ti'un the Wanderer",
            "Kafi",
            "Gorespine",
            "Greyhoof",
            "Skitterer Xi'a",
            "Ka'wi the Gorger",
            "Nitun",
            "Dos-Ryga",
        },
    },
    {
        "Draenor Master Tamers",
        {
            [{ "Ashlei", 539, 0.50, 0.312, "Shadowmoon Valley:Draenor 50.0 31.2" }] = 37203,
            [{ "Gargra", 525, 0.686, 0.646, "Frostfire Ridge 68.6 64.6" }] = 37205,
            [{ "Cymre Brightblade", 543, 0.51, 0.706, "Gorgrond 51.0 70.6" }] = 37201,
            [{ "Taralune", 535, 0.49, 0.804, "Talador 49.0 80.4" }] = 37208,
            [{ "Tarr the Terrible", 550, 0.562, 0.098, "Nagrand:Draenor 56.2 9.8" }] = 37206,
            [{ "Vesharr", 542, 0.462, 0.454, "Spires of Arak 46.2 45.4" }] = 37207,
        },
        {
            "Ashlei",
            "Vesharr",
            "Taralune",
            "Cymre Brightblade",
            "Gargra",
            "Tarr the Terrible",
        },
    },
    {
        "Tiny Terrors of Tanaan",
        {
            [{ "Felsworn Sentry", 534, 0.261, 0.316, "Tanaan Jungle 26.1 31.6" }] = 39157,
            [{ "Chaos Pup", 534, 0.251, 0.762, "Tanaan Jungle 25.1 76.2" }] = 39161,
            [{ "Chaos Pup (entrance)", 534, 0.296, 0.706, "Tanaan Jungle 29.6 70.6" }] = 39161,
            [{ "Direflame", 534, 0.577, 0.374, "Tanaan Jungle 57.7 37.4" }] = 39165,
            [{ "Dark Gazer", 534, 0.54, 0.299, "Tanaan Jungle 54.0 29.9" }] = 39167,
            [{ "Vile Blood of Draenor", 534, 0.44, 0.457, "Tanaan Jungle 44.0 45.7" }] = 39169,
            [{ "Defiled Earth", 534, 0.754, 0.374, "Tanaan Jungle 75.4 37.4" }] = 39173,
            [{ "Corrupted Thundertail", 534, 0.531, 0.652, "Tanaan Jungle 53.1 65.2" }] = 39160,
            [{ "Cursed Spirit", 534, 0.314, 0.381, "Tanaan Jungle 31.4 38.1" }] = 39162,
            [{ "Tainted Maulclaw", 534, 0.432, 0.845, "Tanaan Jungle 43.2 84.5" }] = 39164,
            [{ "Mirecroak", 534, 0.423, 0.718, "Tanaan Jungle 42.3 71.8" }] = 39166,
            [{ "Bleakclaw", 534, 0.157, 0.444, "Tanaan Jungle 15.7 44.4" }] = 39168,
            [{ "Netherfist", 534, 0.484, 0.354, "Tanaan Jungle 48.4 35.4" }] = 39171,
            [{ "Dreadwalker", 534, 0.473, 0.528, "Tanaan Jungle 47.3 52.8" }] = 39170,
            [{ "Felfly", 534, 0.559, 0.808, "Tanaan Jungle 55.9 80.8" }] = 39163,
            [{ "Skrillix", 534, 0.485, 0.313, "Tanaan Jungle 48.5 31.3" }] = 39172,
        },
        {
            "Defiled Earth",
            "Direflame",
            "Dark Gazer",
            "Skrillix",
            "Netherfist",
            "Vile Blood of Draenor",
            "Dreadwalker",
            "Corrupted Thundertail",
            "Felfly",
            "Tainted Maulclaw",
            "Mirecroak",
            "Cursed Spirit",
            "Felsworn Sentry",
            "Bleakclaw",
            { "Chaos Pup (entrance)" },
            "Chaos Pup",
        },
    },
}

local chaosPupEntraceSeen = false
local justSetWaypoint = nil

PBCDT.waypointText = ""

function PBCDT:GetTomTomCallback(wayPointTbl, title)
    local opts = { title = title }
    opts.callbacks = TomTom:DefaultCallbacks(opts)
    local oldFunc = opts.callbacks.distance[TomTom.profile.persistence.cleardistance]
    opts.callbacks.distance[TomTom.profile.persistence.cleardistance] = function(...)
        oldFunc(...)
        self:SetTomTomWaypoints(wayPointTbl)
    end
    return opts
end

function PBCDT:SetTomTomWaypoints(wayPointTbl, tooltipText)
    for i = 1, #wayPointTbl[3] do
        local desiredWaypoint = type(wayPointTbl[3][i]) == "table" and wayPointTbl[3][i][1] or wayPointTbl[3][i]
        for wayPoint, questID in pairs(wayPointTbl[2]) do
            if
                not C_QuestLog_IsQuestFlaggedCompleted(questID)
                and (type(wayPointTbl[3][i]) ~= table or not chaosPupEntraceSeen)
                and (tooltipText ~= nil or desiredWaypoint ~= justSetWaypoint)
            then
                if type(wayPoint[1]) == "table" then
                    for _, _wayPoint in ipairs(wayPoint) do
                        if _wayPoint[1] == desiredWaypoint then
                            if tooltipText ~= nil then
                                tooltipText = tooltipText
                                    .. HIGHLIGHT_FONT_COLOR_CODE
                                    .. _wayPoint[1]
                                    .. ": |r"
                                    .. _wayPoint[5]
                                    .. "|n"
                            else
                                justSetWaypoint = desiredWaypoint
                                local mapPoint =
                                    UiMapPoint.CreateFromCoordinates(_wayPoint[2], _wayPoint[3], _wayPoint[4])
                                C_Map.SetUserWaypoint(mapPoint)
                                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                                TomTom:AddWaypoint(
                                    _wayPoint[2],
                                    _wayPoint[3],
                                    _wayPoint[4],
                                    self:GetTomTomCallback(wayPointTbl, desiredWaypoint)
                                )
                                return
                            end
                        end
                    end
                elseif wayPoint[1] == desiredWaypoint then
                    if tooltipText ~= nil then
                        tooltipText = tooltipText
                            .. HIGHLIGHT_FONT_COLOR_CODE
                            .. wayPoint[1]
                            .. ": |r"
                            .. wayPoint[5]
                            .. "|n"
                    else
                        if type(wayPointTbl[3][i]) == "table" then chaosPupEntraceSeen = true end
                        justSetWaypoint = desiredWaypoint
                        local mapPoint = UiMapPoint.CreateFromCoordinates(wayPoint[2], wayPoint[3], wayPoint[4])
                        C_Map.SetUserWaypoint(mapPoint)
                        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                        TomTom:AddWaypoint(
                            wayPoint[2],
                            wayPoint[3],
                            wayPoint[4],
                            self:GetTomTomCallback(wayPointTbl, desiredWaypoint)
                        )
                        return
                    end
                end
            end
        end
    end

    return tooltipText
end

function PBCDT.HasAvailableQuests(wayPointTbl)
    for _, questID in pairs(wayPointTbl) do
        if not C_QuestLog_IsQuestFlaggedCompleted(questID) then return true end
    end
    return false
end

function PBCDT:DropdownClick(waypointTbl)
    if _G.IsInInstance() then return end
    chaosPupEntraceSeen = false
    justSetWaypoint = nil
    PBCDT:SetTomTomWaypoints(waypointTbl)
end

function PBCDT:CreateMenu(level)
    menu = wipe(menu)
    menu.text = "Set Trainer Waypoints"
    menu.isTitle = true
    menu.hasArrow = false
    menu.notCheckable = true
    UIDropDownMenu_AddButton(menu, level)
    menu = wipe(menu)
    menu.hasArrow = false
    menu.notCheckable = true
    menu.tooltipTitle = NORMAL_FONT_COLOR_CODE .. "Waypoints That Will Be Set|n-------------------------------"
    menu.tooltipOnButton = true
    for _, infoPair in ipairs(PBCDT.DropdownEntries) do
        local hasAvailableQuests = PBCDT.HasAvailableQuests(infoPair[2])
        menu.colorCode = hasAvailableQuests and HIGHLIGHT_FONT_COLOR_CODE or DISABLED_FONT_COLOR_CODE
        menu.disabled = not hasAvailableQuests
        menu.text = infoPair[1] .. (not hasAvailableQuests and (GREEN_FONT_COLOR_CODE .. " (Complete!)|r") or "")
        menu.func = PBCDT.DropdownClick
        menu.arg1 = infoPair
        menu.tooltipText = PBCDT:SetTomTomWaypoints(infoPair, "")
        UIDropDownMenu_AddButton(menu, level)
    end
end

function PBCDT:OnClick()
    if not E:IsAddOnEnabled("TomTom") then return end
    GameTooltip_Hide()
    ToggleDropDownMenu(1, nil, F, self, 0, 0)
end

function PBCDT:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("Pet Battle Challenges Completed")
    GameTooltip:AddLine(" ")
    local completed = GREEN_FONT_COLOR_CODE .. "Completed|r"
    local uncompleted = RED_FONT_COLOR_CODE .. "Uncompleted|r"
    for _, infoPair in ipairs(PBCDT.QuestNameToID) do
        if
            select(4, GetBuildInfo()) >= infoPair[3] and E.db.nihilistzscheui.petBattleChallengeDataText[infoPair[2]]
        then
            GameTooltip:AddDoubleLine(
                infoPair[1],
                C_QuestLog.IsQuestFlaggedCompleted(infoPair[2]) and completed or uncompleted
            )
        end
    end
    GameTooltip:Show()
end

function PBCDT:Update()
    if not self.text then return end

    local numCompleted, numTotal = 0, 0

    for _, infoPair in ipairs(PBCDT.QuestNameToID) do
        if
            select(4, GetBuildInfo()) >= infoPair[3] and E.db.nihilistzscheui.petBattleChallengeDataText[infoPair[2]]
        then
            numTotal = numTotal + 1
            if C_QuestLog.IsQuestFlaggedCompleted(infoPair[2]) then numCompleted = numCompleted + 1 end
        end
    end

    local battleText = ""
    if self:GetWidth() > 300 then battleText = "Battle " end
    self.text:SetFormattedText(
        "%s Pet %sChallenge %s%d/%d|r",
        self.PetTexture or "",
        battleText,
        numCompleted == numTotal and GREEN_FONT_COLOR_CODE or RED_FONT_COLOR_CODE,
        numCompleted,
        numTotal
    )
end

function PBCDT:Initialize()
    NUI:RegisterDB(self, "petBattleChallengeDataText")
    self.PetTexture = _G.CreateAtlasMarkup("worldquest-icon-petbattle", 16, 16)
end

F:RegisterEvent("PLAYER_ENTERING_WORLD")
F:SetScript("OnEvent", function(self)
    self.initialize = PBCDT.CreateMenu
    self.displayMode = "MENU"
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

DT:RegisterDatatext(
    "NihilistzscheUI Pet Challenge Tracker",
    "NihilistzscheUI",
    { "PLAYER_ENTERING_WORLD", "QUEST_LOG_UPDATE" },
    PBCDT.Update,
    PBCDT.Update,
    PBCDT.OnClick,
    PBCDT.OnEnter,
    nil,
    nil,
    nil,
    function() PBCDT:Update() end
)

NUI:RegisterModule(PBCDT:GetName())
