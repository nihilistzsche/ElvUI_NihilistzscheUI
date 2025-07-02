---@class NUI
local NUI, E = _G.unpack((select(2, ...)))

local BRC = NUI.Misc.BetterReputationColors
local COMP = NUI.Compatibility
local DB = E.DataBars

local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionDataByID = _G.C_Reputation.GetFactionDataByID
local C_GossipInfo_GetFriendshipReputation = _G.C_GossipInfo.GetFriendshipReputation
local C_Reputation_IsMajorFaction = _G.C_Reputation.IsMajorFaction

function BRC:Initialize()
    ScrollUtil.AddInitializedFrameCallback(
        _G.ReputationFrame.ScrollBox,
        function(_, button, elementData) BRC.UpdateReputation(button, elementData) end,
        self,
        true
    )
end

function BRC.ShouldSkipRep(button, factionID)
    if not button.Content or not button.Content.ReputationBar then return true end
    if not factionID or factionID == 0 then return true end
    if C_Reputation_IsMajorFaction(factionID) then return true end
    return false
end

function BRC.UpdateReputation(button, elementData)
    local factionID = elementData.factionID
    if BRC.ShouldSkipRep(button, factionID) then return end
    if not DB.db.colors.useCustomFactionColors then return end
    local bar = button.Content.ReputationBar
    local factionInfo = C_Reputation_GetFactionDataByID(factionID)
    if not factionInfo then return end
    local reaction = factionInfo.reaction
    if not COMP.PR or not C_Reputation_IsFactionParagon(factionID) then
        local color = DB.db.colors.factionColors[reaction]
        if not color then
            print("No color found for reaction " .. reaction .. " for faction with ID " .. factionID)
            return
        end
        bar:SetStatusBarColor(color.r, color.g, color.b)
    else
        bar:SetStatusBarColor(unpack(_G.ParagonReputationDB.value))
    end
end

NUI:RegisterModule(BRC:GetName())
