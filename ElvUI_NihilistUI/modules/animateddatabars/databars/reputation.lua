local NUI, E = _G.unpack(select(2, ...))
local ADB = NUI.AnimatedDataBars
local DB = E.DataBars
local COMP = NUI.Compatibility

local REP = ADB:NewDataBar()

local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local GetNumFactions = _G.GetNumFactions
local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = _G.C_Reputation.GetFactionParagonInfo
local GetFactionInfo = _G.GetFactionInfo
local GetFriendshipReputation = _G.GetFriendshipReputation
local GetFriendshipReputationRanks = _G.GetFriendshipReputationRanks
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local GameTooltip = _G.GameTooltip
local STANDING = _G.STANDING
local REPUTATION = _G.REPUTATION
local format = _G.format

function REP.GetLevel()
	return 0
end

-- luacheck: no self
function REP:Update(bar)
	local ID
	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()
	local isParagon = false
	if (C_Reputation_IsFactionParagon(factionID)) then
		local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
		min, max = 0, threshold
		value = currentValue % threshold
		if hasRewardPending then
			value = value + threshold
		end
		isParagon = true
	end
	local numFactions = GetNumFactions()

	local level

	for i = 1, numFactions do
		local factionName, _, standingID, _, _, _, _, _, _, _, _, _, _, _factionID = GetFactionInfo(i)
		local friendID, friendRep = GetFriendshipReputation(_factionID)
		if factionName == name then
			if friendID ~= nil then
				-- do something different for friendships
				local _, _, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(_factionID)
				level = GetFriendshipReputationRanks(_factionID)
				if (nextFriendThreshold) then
					min, max, value = friendThreshold, nextFriendThreshold, friendRep
				else
					-- max rank, make it look like a full bar
					min, max, value = 0, 1, 1
				end
				reaction = 5
				ID = friendID
			else
				ID = standingID
				level = reaction
			end
		end
	end

	if (isParagon and COMP.MERS) then
		local colorDB = E.db.mui.misc.paragon.paragonColor
		bar.animatedStatusBar:SetStatusBarColor(colorDB.r, colorDB.g, colorDB.b)
		bar.animatedStatusBar:SetAnimatedTextureColors(colorDB.r, colorDB.g, colorDB.b)
	else
		local color = FACTION_BAR_COLORS[reaction] or FACTION_BAR_COLORS[1]
		bar.animatedStatusBar:SetStatusBarColor(color.r, color.g, color.b)
		bar.animatedStatusBar:SetAnimatedTextureColors(color.r, color.g, color.b)
	end
	bar.animatedStatusBar:SetAnimatedValues(value, min, max, ID == bar.lastSeenFaction and level or 0)
	if (ID ~= bar.lastSeenFactionID) then
		bar.lastSeenFactionID = ID
		bar.animatedStatusBar:ProcessChangesInstantly()
	end
end

function REP:OnEnter()
	REP.OrigOnEnter(DB.StatusBars.Reputation)
	if DB.db.reputation.mouseover then
		E:UIFrameFadeIn(self, 0.4, self:GetAlpha(), 1)
	end
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, -4)

	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()

	local standing = _G["FACTION_STANDING_LABEL" .. reaction]
	if (C_Reputation_IsFactionParagon(factionID)) then
		local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
		min, max = 0, threshold
		value = currentValue % threshold
		if hasRewardPending then
			value = value + threshold
		end
		standing = "Paragon"
	end

	local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID)
	if name then
		GameTooltip:AddLine(name)
		GameTooltip:AddLine(" ")

		GameTooltip:AddDoubleLine(STANDING .. ":", friendID and friendTextLevel or standing, 1, 1, 1)
		GameTooltip:AddDoubleLine(
			REPUTATION .. ":",
			format("%d / %d (%d%%)", value - min, max - min, (value - min) / ((max - min == 0) and max or (max - min)) * 100),
			1,
			1,
			1
		)
	end
	GameTooltip:Show()
end

function REP:Initialize()
	self:GetParent():CreateAnimatedBar(self, "Reputation")
	self.OrigOnEnter = DB.ReputationBar_OnEnter
	function DB:ReputationBar_OnEnter()
		REP:OnEnter()
	end
end

ADB:RegisterDataBar(REP)
