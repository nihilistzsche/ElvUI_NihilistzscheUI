local NUI, E = _G.unpack(select(2, ...))

local BRC = NUI.Misc.BetterReputationColors
local DB = E.DataBars

local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon

function BRC:Initialize() hooksecurefunc("ReputationFrame_Update", BRC.ReputationFrame_Update) end

function BRC.ReputationFrame_Update()
    if not DB.db.colors.useCustomFactionColors then return end
    local factionOffset = FauxScrollFrame_GetOffset(_G.ReputationListScrollFrame)
    local numFactions = GetNumFactions()
    for i = 1, _G.NUM_FACTIONS_DISPLAYED do
        local bar = _G["ReputationBar" .. i .. "ReputationBar"]
        local factionIndex = factionOffset + i
        if factionIndex <= numFactions then
            local _, _, reaction, _, _, _, _, _, isHeader, _, _, _, _, factionID = GetFactionInfo(factionIndex)
            local friendshipInfo = C_GossipInfo.GetFriendshipReputation(factionID)
            if friendshipInfo.friendshipFactionID > 0 then
                reaction = friendshipInfo.standing
            elseif C_Reputation_IsFactionParagon(factionID) then
                reaction = 9
            end
            local color = DB.db.colors.factionColors[reaction]
            bar:SetStatusBarColor(color.r, color.g, color.b)
        end
    end
end

NUI:RegisterModule(BRC:GetName())
