local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer
local COMP = NUI.Compatibility

local GetAddOnMetadata = _G.GetAddOnMetadata

function NI:KalielSetup()
    local modulesOrder

    if COMP.WQT and GetAddOnMetadata("!KalielsTracker", "X-WQTSupport") then
        modulesOrder = {
            nil, -- [1]
            "KT_CAMPAIGN_QUEST_TRACKER_MODULE",
            "KT_MONTHLY_ACTIVITIES_TRACKER_MODULE", -- [2]
            "KT_WORLD_QUEST_TRACKER_MODULE", -- [3]
            "KT_BONUS_OBJECTIVE_TRACKER_MODULE", -- [4]
            "WORLDQUESTTRACKER_TRACKER_MODULE", -- [5]
            "KT_AUTO_QUEST_POPUP_TRACKER_MODULE", -- [6]
            "KT_QUEST_TRACKER_MODULE", -- [7]
            "QUECHO_TRACKER_MODULE", -- [8]
            "PETTRACKER_TRACKER_MODULE", -- [9]
            "KT_ACHIEVEMENT_TRACKER_MODULE", -- [10]
        }
    else
        modulesOrder = {
            nil, -- [1]
            "KT_CAMPAIGN_QUEST_TRACKER_MODULE", -- [2]
            "KT_MONTHLY_ACTIVITIES_TRACKER_MODULE", -- [3]
            "KT_WORLD_QUEST_TRACKER_MODULE", -- [4]
            "KT_BONUS_OBJECTIVE_TRACKER_MODULE", --[5]
            "KT_AUTO_QUEST_POPUP_TRACKER_MODULE", --[6]
            "KT_QUEST_TRACKER_MODULE", --[7]
            nil, --[8]
            "PETTRACKER_TRACKER_MODULE", --[9]
            "KT_ACHIEVEMENT_TRACKER_MODULE", -- [10]
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
        addonQuecho = true,
        hdrTxtColorShare = true,
        textWordWrap = true,
        helpTutorial = 10,
        collapseInInstance = false,
        hdrBtnColorShare = true,
        soundQuest = false,
        modulesOrder = modulesOrder,
    })

    self.SaveMoverPosition("NUIKalielsTrackerMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -82, -335)
end

NI:RegisterAddOnInstaller("!KalielsTracker", NI.KalielSetup)
