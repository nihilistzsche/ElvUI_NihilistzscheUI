local NUI = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer
local COMP = NUI.Compatibility

local GetAddOnMetadata = _G.GetAddOnMetadata

function NI:KalielSetup()
  local modulesOrder

  if (COMP.WQT and GetAddOnMetadata("!KalielsTracker", "X-WQTSupport")) then
    modulesOrder = {
      nil, -- [1]
      "CAMPAIGN_QUEST_TRACKER_MODULE",
      "WORLD_QUEST_TRACKER_MODULE", -- [2]
      "BONUS_OBJECTIVE_TRACKER_MODULE", -- [3]
      "WORLDQUESTTRACKER_TRACKER_MODULE", -- [4]
      "AUTO_QUEST_POPUP_TRACKER_MODULE", -- [5]
      "QUEST_TRACKER_MODULE", -- [6]
      "QUECHO_TRACKER_MODULE", -- [7]
      "PETTRACKER_TRACKER_MODULE", -- [8]
      "ACHIEVEMENT_TRACKER_MODULE" -- [9]
    }
  else
    modulesOrder = {
      nil, -- [1]
      "CAMPAIGN_QUEST_TRACKER_MODULE",
      "WORLD_QUEST_TRACKER_MODULE", -- [2]
      "BONUS_OBJECTIVE_TRACKER_MODULE", --[3]
      "AUTO_QUEST_POPUP_TRACKER_MODULE", --[4]
      "QUEST_TRACKER_MODULE", --[5]
      nil, --[6]
      "PETTRACKER_TRACKER_MODULE", --[7]
      "ACHIEVEMENT_TRACKER_MODULE" -- [8]
    }
  end
  self:SetProfile(
    _G.KalielsTrackerDB,
    {
      classBorder = true,
      borderThickness = 2,
      xOffset = -90,
      yOffset = -320,
      addonPetTracker = true,
      bgrColor = NUI.Private and self:Color() or {r = 0, g = 0, b = 0, a = 0},
      bgrInset = 0,
      bgr = NUI.Private and "NihilistzscheUI" or "ElvUI Blank",
      hideEmptyTracker = true,
      font = self.db.font,
      progressBar = self.db.texture,
      version = "3.0.3",
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
      ["sink20OutputSink"] = "xCT_Plus",
      collapseInInstance = false,
      hdrBtnColorShare = true,
      ["sink20ScrollArea"] = "General",
      soundQuest = false,
      modulesOrder = modulesOrder
    }
  )
end

NI:RegisterAddOnInstaller("!KalielsTracker", NI.KalielSetup)
