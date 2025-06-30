---@class NUI
local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer
local COMP = NUI.Compatibility

local GetAddOnMetadata = (_G.C_AddOns or _G).GetAddOnMetadata

function NI:KalielSetup()
    local modulesOrder

    if COMP.WQT and GetAddOnMetadata("!KalielsTracker", "X-WQTSupport") then
        modulesOrder = {
            "KT_ScenarioObjectiveTracker",
            "KT_UIWidgetObjectiveTracker",
            "KT_CampaignQuestObjectiveTracker",
            "KT_WorldQuestObjectiveTracker",
            "KT_BonusObjectiveTracker",
            "KT_WorldQuestTrackerObjectiveTracker",
            "KT_QuestObjectiveTracker",
            "KT_AdventureObjectiveTracker",
            "KT_MonthlyActivitiesObjectiveTracker",
            "KT_PetTrackerObjectiveTracker",
            "KT_ProfessionsRecipeTracker",
            "KT_AchievementObjectiveTracker",
        }
    else
        modulesOrder = {
            "KT_ScenarioObjectiveTracker",
            "KT_UIWidgetObjectiveTracker",
            "KT_CampaignQuestObjectiveTracker",
            "KT_WorldQuestObjectiveTracker",
            "KT_BonusObjectiveTracker",
            "KT_QuestObjectiveTracker",
            "KT_AdventureObjectiveTracker",
            "KT_MonthlyActivitiesObjectiveTracker",
            "KT_PetTrackerObjectiveTracker",
            "KT_ProfessionsRecipeTracker",
            "KT_AchievementObjectiveTracker",
        }
    end
    self:SetProfile(_G.KalielsTrackerDB, {
        classBorder = true,
        borderThickness = 2,
        xOffset = -90,
        yOffset = -320,
        addonPetTracker = true,
        bgrColor = NUI.Private and self:Color() or { r = 0, g = 0, b = 0, a = 0 },
        bgrInset = 0,
        bgr = NUI.Private and "NihilistzscheUI" or "ElvUI Blank",
        hideEmptyTracker = true,
        font = self.db.font,
        progressBar = self.db.texture,
        version = "6.0.1",
        hdrBgr = 4,
        qiBgrBorder = true,
        border = "1 Pixel",
        hdrBgrColorShare = true,
        colorDifficulty = true,
        addonWorldQuestTracker = true,
        addonTomTom = true,
        hdrTxtColorShare = true,
        textWordWrap = true,
        helpTutorial = 10,
        maxHeight = 450,
        collapseInInstance = false,
        hdrBtnColorShare = true,
        soundQuest = false,
        modulesOrder = E:CopyTable({}, modulesOrder),
    })

    self:SaveMoverPosition("NUIKalielsTrackerMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -82, -335)
end

NI:RegisterAddOnInstaller("!KalielsTracker", NI.KalielSetup)
