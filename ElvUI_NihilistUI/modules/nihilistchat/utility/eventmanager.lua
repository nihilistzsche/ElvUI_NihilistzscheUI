local NUI, E = _G.unpack(select(2, ...))
local NC = NUI.NihilistChat
local CH = E.Chat
local LSM = E.Libs.LSM

local PlaySoundFile = _G.PlaySoundFile
local gsub = _G.gsub
local GetNumGuildMembers = _G.GetNumGuildMembers
local GetGuildRosterInfo = _G.GetGuildRosterInfo

function NC.FindURL(event, msg)
	if
		(event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER") and CH.db.whisperSound ~= "None" and
			not CH.SoundPlayed
	 then
		if (msg:sub(1, 3) == "OQ,") then
			return msg
		end
		PlaySoundFile(LSM:Fetch("sound", CH.db.whisperSound), "Master")
		CH.SoundPlayed = true
		CH.SoundTimer = CH:ScheduleTimer("ThrottleSound", 1)
	end

	if not CH.db.url then
		msg = CH:CheckKeyword(msg)
		msg = CH:GetSmileyReplacementText(msg)
		return msg
	end

	local newMsg, found = gsub(msg, "(%a+)://(%S+)%s?", CH:PrintURL("%1://%2"))
	if found > 0 then
		return CH:GetSmileyReplacementText(CH:CheckKeyword(newMsg))
	end

	newMsg, found = gsub(msg, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", CH:PrintURL("www.%1.%2"))
	if found > 0 then
		return CH:GetSmileyReplacementText(CH:CheckKeyword(newMsg))
	end

	newMsg, found = gsub(msg, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", CH:PrintURL("%1@%2%3%4"))
	if found > 0 then
		return CH:GetSmileyReplacementText(CH:CheckKeyword(newMsg))
	end

	msg = CH:CheckKeyword(msg)
	msg = CH:GetSmileyReplacementText(msg)

	return msg
end

function NC:CHAT_MSG_BN_WHISPER(event, msg, sender, ...)
	local guid = select(10, ...)

	sender = NC:FixSameRealm(sender)
	self:AddIncoming(event, NC.FindURL(event, msg), sender, guid)
end

function NC:CHAT_MSG_BN_WHISPER_INFORM(event, msg, sender, ...)
	local guid = select(10, ...)

	sender = NC:FixSameRealm(sender)
	self:AddIncoming(event, NC.FindURL(event, msg), sender, guid)
end

function NC:CHAT_MSG_WHISPER_INFORM(event, msg, sender, ...)
	local guid = select(10, ...)

	sender = NC:FixSameRealm(sender)
	self:AddIncoming(event, NC.FindURL(event, msg), sender, guid)
end

function NC:CHAT_MSG_WHISPER(event, msg, sender, ...)
	local guid = select(10, ...)

	sender = NC:FixSameRealm(sender)
	self:AddIncoming(event, NC.FindURL(event, msg), sender, guid)
end

-- BN player goes offline/online
function NC:CHAT_MSG_BN_INLINE_TOAST_ALERT(event, toast, author)
	self:AddStatus(event, toast, author)
end

function NC:GUILD_ROSTER_UPDATE()
	local num = GetNumGuildMembers()
	for i = 1, num do
		local name, _, _, level, class, _, _, _, _, _, _, _, _, isMobile = GetGuildRosterInfo(i)
		if (name) then
			name = self:FixSameRealm(name)
			if (isMobile) then
				self.userCache[name] = {
					name = name,
					level = level,
					class = class,
					race = "Mobile"
				}
			end
		end
	end
end
