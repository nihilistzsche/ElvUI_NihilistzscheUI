local NUI, E = _G.unpack(select(2, ...))
local NC = NUI.NihilistzscheChat

NUI.Libs.LibWho = _G.LibStub("LibWho-2.0")

local tContains = _G.tContains
local C_CreatureInfo_GetRaceInfo = _G.C_CreatureInfo.GetRaceInfo
local strlower = _G.strlower
local CreateFrame = _G.CreateFrame
local FillLocalizedClassList = _G.FillLocalizedClassList
local SetCVar = _G.SetCVar
local ChatFrame_RemoveMessageGroup = _G.ChatFrame_RemoveMessageGroup
local format = _G.format
local C_GuildInfo_GuildRoster = _G.C_GuildInfo.GuildRoster
local tInvert = _G.tInvert

local raceIdBlacklist = { 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 25, 26, 33 }

local maxRaceID = 37

function NC:FillRaceMap()
    for i = 1, maxRaceID do
        if not tContains(raceIdBlacklist, i) then
            local t = C_CreatureInfo_GetRaceInfo(i)
            if t then self.raceMap[t.raceName] = strlower(t.clientFileString) end
        end
    end
end

function NC:Initialize()
    NUI:RegisterDB(self, "nihilistzschechat")
    if not self.db.general.enabled then return end
    self.frame = CreateFrame("Frame", "NihilistzscheChat", E.UIParent)
    self.chats = {}

    self.raceMap = {}

    self:FillRaceMap()

    self.maleClasses = {}
    self.femaleClasses = {}
    self.userCache = {}
    self.delayed = {}
    self.mobileStatus = {}

    local tMale = {}
    local tFemale = {}
    FillLocalizedClassList(tMale, false)
    FillLocalizedClassList(tFemale, true)

    self.maleClasses = tInvert(tMale)
    self.femaleClasses = tInvert(tFemale)

    local ForUpdateAll = function(_self) _self:UpdateAll() end
    self.ForUpdateAll = ForUpdateAll

    self:SetUpHooks()
    self:CreateDock()
    self:InitializeChatSystem()

    self:RegisterEvent("CHAT_MSG_BN_WHISPER")
    self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
    self:RegisterEvent("CHAT_MSG_BN_INLINE_TOAST_ALERT")
    self:RegisterEvent("GUILD_ROSTER_UPDATE")

    SetCVar("chatStyle", "im")
    SetCVar("whisperMode", "popout")

    for i = 1, 4 do -- Make sure whispers don't exist in chatframe 1-4
        local Frame = _G[format("ChatFrame%s", i)]
        ChatFrame_RemoveMessageGroup(Frame, "WHISPER")
        ChatFrame_RemoveMessageGroup(Frame, "BN_WHISPER")
    end

    self.myrealm = E.myrealm:gsub(" ", "")

    C_GuildInfo_GuildRoster()
end

NUI:RegisterModule(NC:GetName())
