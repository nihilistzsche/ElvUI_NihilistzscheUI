local NUI, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
local CDB = NUI.CustomDataBar
local DB = E.DataBars
local NT = NUI.Libs.NT

local floor = math.floor
local UnitName = _G.UnitName

-- luacheck: no self

--Replacement of text formats on 'player'frames.
local styles = {
	CURRENT = "%s",
	CURRENT_MAX = "%s - %s",
	CURRENT_PERCENT = "%s ( %s%% )",
	CURRENT_MAX_PERCENT = "%s - %s ( %s%% )",
	CURRENT_RESTED = "%s | R: %s",
	CURRENT_MAX_RESTED = "%s - %s | R: %s",
	CURRENT_PERCENT_RESTED = "%s ( %s%% ) | R: %s",
	CURRENT_MAX_PERCENT_RESTED = "%s - %s ( %s%% ) | R: %s",
	TONEXT = "%s",
	BUBBLES = "%s",
	PERCENT = "%s%%",
	RESTED = "%s"
}

function CDB:GetFormattedText(style, min, max, rested)
	if (not styles[style] or not min) then
		return
	end

	if max == 0 then
		max = 1
	end

	local useStyle = styles[style]

	local percentValue
	if max ~= nil then
		percentValue = floor(min / max * 100)
	end

	if style == "TONEXT" then
		local deficit = max - min
		if deficit <= 0 then
			return ""
		else
			return string.format(useStyle, deficit)
		end
	elseif
		style == "CURRENT" or
			((style == "CURRENT_MAX" or style == "CURRENT_MAX_PERCENT" or style == "CURRENT_PERCENT") and min == max)
	 then
		return string.format(styles.CURRENT, min)
	elseif style == "CURRENT_MAX" then
		return string.format(useStyle, min, max)
	elseif style == "CURRENT_PERCENT" then
		return string.format(useStyle, min, percentValue)
	elseif style == "CURRENT_MAX_PERCENT" then
		return string.format(useStyle, min, max, percentValue)
	elseif
		style == "CURRENT_RESTED" or
			((style == "CURRENT_MAX_RESTED" or style == "CURRENT_MAX_PERCENT_RESTED" or style == "CURRENT_PERCENT_RESTED") and
				min == max)
	 then
		return string.format(styles.CURRENT_RESTED, min, rested)
	elseif style == "CURRENT_MAX_RESTED" then
		return string.format(useStyle, min, max, rested)
	elseif style == "CURRENT_PERCENT_RESTED" then
		return string.format(useStyle, min, percentValue, rested)
	elseif style == "CURRENT_MAX_PERCENT_RESTED" then
		return string.format(useStyle, min, max, percentValue, rested)
	elseif style == "BUBBLES" then
		local bubbles = floor(20 * (max - min) / max)
		return string.format(useStyle, bubbles)
	elseif style == "RESTED" then
		if not rested then
			rested = 0
		end
		return string.format(useStyle, rested)
	elseif style == "PERCENT" then
		return string.format(useStyle, percentValue)
	end
end

function CDB:RegisterDataBar(key, frame)
	NT:RegisterFontString(key, frame.text)
end

function CDB:UpdateTag(frameKey)
	local tagstr
	if frameKey == "xp" then
		tagstr = E.db.databars.experience.tag
	elseif frameKey == "rep" then
		tagstr = E.db.databars.reputation.tag
	elseif frameKey == "azerite" then
		tagstr = E.db.databars.azerite.tag
	elseif frameKey == "honor" then
		tagstr = E.db.databars.honor.tag
	end
	NT:Tag(frameKey, tagstr)
end

function CDB:Initialize()
	E.db.databars.experience.textFormat = "NONE"
	E.db.databars.reputation.textFormat = "NONE"
	E.db.databars.azerite.textFormat = "NONE"
	E.db.databars.honor.textFormat = "NONE"

	CDB.currQXP = NUI:GetCurrentQuestXP()

	NT:RegisterTag(
		"name",
		function()
			return UnitName("player")
		end
	)

	self.RegisterXPTags()
	self.RegisterRepTags()
	self.RegisterAzeriteTags()
	self.RegisterHonorTags()

	self:RegisterDataBar("xp", DB.StatusBars.Experience)
	self:RegisterDataBar("rep", DB.StatusBars.Reputation)
	self:RegisterDataBar("azerite", DB.StatusBars.Azerite)
	self:RegisterDataBar("honor", DB.StatusBars.Honor)

	self:UpdateTag("xp")
	self:UpdateTag("rep")
	self:UpdateTag("azerite")
	self:UpdateTag("honor")
end

NUI:RegisterModule(CDB:GetName())
