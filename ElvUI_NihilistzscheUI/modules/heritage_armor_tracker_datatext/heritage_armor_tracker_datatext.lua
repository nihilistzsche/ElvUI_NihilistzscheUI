local NUI, E, _, _, P = unpack((select(2, ...)))
if not E.Retail then return end
local DT = E.DataTexts
local HATDT = NUI.DataTexts.HeritageArmorTrackerDataText
local GetAchievementInfo = _G.GetAchievementInfo
local C_CreatureInfo_GetRaceInfo = _G.C_CreatureInfo.GetRaceInfo
local C_CreatureInfo_GetFactionInfo = _G.C_CreatureInfo.GetFactionInfo
local C_TransmogSets_IsBaseSetCollected = _G.C_TransmogSets.IsBaseSetCollected
local GREEN_FONT_COLOR_CODE = _G.GREEN_FONT_COLOR_CODE
local GameTooltip = _G.GameTooltip
local RED_FONT_COLOR_CODE = _G.RED_FONT_COLOR_CODE
local unpack, tinsert = _G.unpack, _G.tinsert

HATDT.AlliedRace = 1
HATDT.CoreRace = 2

HATDT.UnlockRequirements = {
    [29] = { unlock_req = 12242, completed_req = 12291, type = HATDT.AlliedRace, order = 1 },
    [27] = { unlock_req = 12244, completed_req = 12413, type = HATDT.AlliedRace, order = 1 },
    [30] = { unlock_req = 12243, completed_req = 12414, type = HATDT.AlliedRace, order = 2 },
    [28] = { unlock_req = 12245, completed_req = 12415, type = HATDT.AlliedRace, order = 2 },
    [34] = { unlock_req = 12515, completed_req = 13076, type = HATDT.AlliedRace, order = 3 },
    [36] = { unlock_req = 12518, completed_req = 13077, type = HATDT.AlliedRace, order = 3 },
    [31] = { unlock_req = 13161, completed_req = 13503, type = HATDT.AlliedRace, order = 4 },
    [32] = { unlock_req = 13163, completed_req = 13504, type = HATDT.AlliedRace, order = 4 },
    [35] = { unlock_req = 13206, completed_req = 14002, type = HATDT.AlliedRace, order = 5 },
    [37] = { unlock_req = 14013, completed_req = 14014, type = HATDT.AlliedRace, order = 5 },
    [84] = { unlock_req = 40307, completed_req = 40309, type = HATDT.AlliedRace, order = 6 },
    [85] = { unlock_req = 40307, completed_req = 40309, type = HATDT.AlliedRace, order = 6 },
    [3] = { appearance_set = 1803, type = HATDT.CoreRace, order = 1 },
    [7] = { appearance_set = 1828, type = HATDT.CoreRace, order = 2 },
    [10] = { appearance_set = 1804, type = HATDT.CoreRace, order = 1 },
    [6] = { appearance_set = 1829, type = HATDT.CoreRace, order = 2 },
    [9] = { appearance_set = 1977, type = HATDT.CoreRace, order = 3 },
    [22] = { appearance_set = 1976, type = HATDT.CoreRace, order = 3 },
    [2] = { appearance_set = 2830, type = HATDT.CoreRace, order = 4 },
    [1] = { appearance_set = 2833, type = HATDT.CoreRace, order = 4 },
    [4] = { appearance_set = 3121, type = HATDT.CoreRace, order = 5 },
    [5] = { appearance_set = 3086, type = HATDT.CoreRace, order = 5 },
    [11] = { appearance_set = 3346, type = HATDT.CoreRace, order = 6 },
    [8] = { appearance_set = 3350, type = HATDT.CoreRace, order = 6 },
}

function HATDT:SortUnlockTable()
    local sorted_allied = {}
    local sorted_core = {}
    local aoffset = 5
    local coffset = 4
    for k, info in next, self.UnlockRequirements do
        local isMyFaction = C_CreatureInfo_GetFactionInfo(k).groupTag == E.myfaction
        local isAlliedRace = info.type == self.AlliedRace
        local tbl = isAlliedRace and sorted_allied or sorted_core
        local offset = not isMyFaction and (isAlliedRace and aoffset or coffset) or 0
        tbl[info.order + offset] = k
    end
    self.SortedAllied = sorted_allied
    self.SortedCore = sorted_core
end

function HATDT:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("Heritage Armors Obtained", 1, 1, 1)
    GameTooltip:AddLine(" ")
    local completedTxt = GREEN_FONT_COLOR_CODE .. "Obtained|r"
    local uncompletedTxt = RED_FONT_COLOR_CODE .. "Unobtained|r"

    local GetFactionTexture
    if _G["ElvUI_SLE"] then
        GetFactionTexture = function(k)
            return [[|TInterface\AddOns\ElvUI_SLE\media\textures\afk\factionlogo\blizzard\]]
                .. k
                .. ".tga:15:15:0:0:64:64:4:56:4:56|t"
        end
    end
    GameTooltip:AddLine("Allied Races")
    for _, k in ipairs(HATDT.SortedAllied) do
        local info = HATDT.UnlockRequirements[k]
        local unlocked = select(4, GetAchievementInfo(info.unlock_req))
        if E.db.nihilistzscheui.heritageArmorTrackerDataText[k] and unlocked then
            local _, _, _, completed = GetAchievementInfo(info.completed_req)
            local raceInfo = C_CreatureInfo_GetRaceInfo(k)
            local factionInfo = C_CreatureInfo_GetFactionInfo(k)
            local color = factionInfo.groupTag == "Alliance" and { 0.29, 0.33, 0.91 } or { 0.90, 0.05, 0.07 }
            GameTooltip:AddDoubleLine(
                (GetFactionTexture and GetFactionTexture(factionInfo.groupTag) or "") .. raceInfo.raceName,
                completed and completedTxt or uncompletedTxt,
                unpack(color)
            )
        end
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("Core Races")
    for _, k in ipairs(HATDT.SortedCore) do
        local completed = E.global.nihilistzscheui.heritageArmorTrackerDataText[k]
        if E.db.nihilistzscheui.heritageArmorTrackerDataText[k] then
            local raceInfo = C_CreatureInfo_GetRaceInfo(k)
            local factionInfo = C_CreatureInfo_GetFactionInfo(k)
            local color = factionInfo.groupTag == "Alliance" and { 0.29, 0.33, 0.91 } or { 0.90, 0.05, 0.07 }
            GameTooltip:AddDoubleLine(
                (GetFactionTexture and GetFactionTexture(factionInfo.groupTag) or "") .. raceInfo.raceName,
                completed and completedTxt or uncompletedTxt,
                unpack(color)
            )
        end
    end
    GameTooltip:Show()
end

function HATDT:Update()
    if not self.text then return end

    local numCompleted, numTotal = 0, 0

    for k in next, P.nihilistzscheui.heritageArmorTrackerDataText do
        local info = HATDT.UnlockRequirements[k]
        local unlocked
        if info.type == HATDT.AlliedRace then
            unlocked = select(4, GetAchievementInfo(info.unlock_req))
        else
            unlocked = true
        end
        if E.db.nihilistzscheui.heritageArmorTrackerDataText[k] and unlocked then
            numTotal = numTotal + 1
            if info.type == HATDT.AlliedRace and select(4, GetAchievementInfo(info.completed_req)) then
                numCompleted = numCompleted + 1
            elseif info.type == HATDT.CoreRace then
                E.global.nihilistzscheui = E.global.nihilistzscheui or {}
                E.global.nihilistzscheui.heritageArmorTrackerDataText = E.global.nihilistzscheui.heritageArmorTrackerDataText
                    or {}
                E.global.nihilistzscheui.heritageArmorTrackerDataText[k] = E.global.nihilistzscheui.heritageArmorTrackerDataText[k]
                    or C_TransmogSets_IsBaseSetCollected(info.appearance_set)
                if E.global.nihilistzscheui.heritageArmorTrackerDataText[k] then numCompleted = numCompleted + 1 end
            end
        end
    end

    self.text:SetFormattedText(
        "%s%d/%d|r",
        numCompleted == numTotal and GREEN_FONT_COLOR_CODE or RED_FONT_COLOR_CODE,
        numCompleted,
        numTotal
    )
end

function HATDT:Initialize()
    NUI:RegisterDB(self, "heritageArmorTrackerDataText")
    self:SortUnlockTable()
end

DT:RegisterDatatext(
    "NihilistzscheUI Heritage Armor Tracker",
    "NihilistzscheUI",
    { "PLAYER_ENTERING_WORLD", "ACHIEVEMENT_EARNED", "TRANSMOG_COLLECTION_LOADED", "TRANSMOG_COLLECTION_UPDATED" },
    HATDT.Update,
    HATDT.Update,
    HATDT.OnClick,
    HATDT.OnEnter,
    nil,
    nil,
    nil,
    function() HATDT:Update() end
)

NUI:RegisterModule(HATDT:GetName())
