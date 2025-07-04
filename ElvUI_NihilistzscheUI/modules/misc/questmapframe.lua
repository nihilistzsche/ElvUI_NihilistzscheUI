---@class NUI
local NUI, E = _G.unpack((select(2, ...)))

if not E.Retail then return end

local NM = NUI.Misc
local COMP = NUI.Compatibility
local LSM = E.Libs.LSM

local WorldMapFrame = _G.WorldMapFrame
local WorldMapFrameTitleText = _G.WorldMapFrameTitleText
local QuestMapFrame = _G.QuestMapFrame
local CreateFrame = _G.CreateFrame

function NM.UpdateQuestMapFrame()
    if COMP.QG or COMP.CQL then
        WorldMapFrame.SidePanelToggle.OpenButton:Hide()
        WorldMapFrame.SidePanelToggle.OpenButton.Show = function() end
        ---@diagnostic disable-next-line: redundant-parameter
        WorldMapFrameTitleText:SetText("World Map")
        WorldMapFrameTitleText.SetText = function() end
    else
        local frame = CreateFrame("Frame", nil, QuestMapFrame)
        QuestMapFrame.QuestCountFrame = frame

        frame:RegisterEvent("QUEST_LOG_UPDATE")
        frame:Size(240, 20)
        frame:Point("TOP", 0, 30)

        local text = frame:CreateFontString(nil, "OVERLAY")
        text:FontTemplate(LSM:Fetch("font", E.db.general.font), 12, "THINOUTLINE")
        text:SetAllPoints()

        frame.text = text
        local str = "%d / 25 Quests"
        frame.text:SetFormattedText(str, select(2, C_QuestLog.GetNumQuestLogEntries()))

        frame:SetScript("OnEvent", function()
            local _, quests = C_QuestLog.GetNumQuestLogEntries()

            frame.text:SetFormattedText(str, quests)
        end)
    end
end
