local NUI, E, L = unpack((select(2, ...)))

local DTF = NUI.Misc.DifficultyTooltipFix
local DT = E.DataTexts

local DiffLabel = {}

local DungeonTexture, RaidTexture, LegacyTexture =
    CreateAtlasMarkup("Dungeon", 20, 20),
    CreateAtlasMarkup("Raid", 20, 20),
    CreateAtlasMarkup("worldquest-icon-raid", 20, 20)

for i = 1, 200 do
    local name = GetDifficultyInfo(i)
    if name and not DiffLabel[i] then DiffLabel[i] = name end
end

function DTF.OnEnter()
    local dungeonDifficultyID, raidDifficultyID, legacyRaidDifficultyID =
        GetDungeonDifficultyID(), GetRaidDifficultyID(), GetLegacyRaidDifficultyID()
    if not (dungeonDifficultyID or raidDifficultyID or legacyRaidDifficultyID) then return end
    DT.tooltip:ClearLines()

    DT.tooltip:SetText(L["Current Difficulties:"])
    DT.tooltip:AddLine(" ")
    if dungeonDifficultyID then DT.tooltip:AddLine(("%s %s"):format(DungeonTexture, DiffLabel[dungeonDifficultyID])) end
    if raidDifficultyID then DT.tooltip:AddLine(("%s %s"):format(RaidTexture, DiffLabel[raidDifficultyID])) end
    if legacyRaidDifficultyID then
        DT.tooltip:AddLine(("%s %s"):format(LegacyTexture, DiffLabel[legacyRaidDifficultyID]))
    end
    DT.tooltip:Show()
end

function DTF:Initialize()
    if DT.RegisteredDataTexts["Difficulty"] then DT.RegisteredDataTexts["Difficulty"].onEnter = DTF.OnEnter end
end

NUI:RegisterModule(DTF:GetName())
