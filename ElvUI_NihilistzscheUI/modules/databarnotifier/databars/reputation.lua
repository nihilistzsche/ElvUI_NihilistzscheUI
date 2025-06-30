---@class NUI
local NUI, E = _G.unpack((select(2, ...)))

local DBN = NUI.DataBarNotifier
local COMP = NUI.Compatibility

local REP = DBN:NewNotifier("Reputation")
local DB

local GetNumFactions = _G.C_Reputation.GetNumFactions
local GetFactionDataByIndex = _G.C_Reputation.GetFactionDataByIndex
local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = _G.C_Reputation.GetFactionParagonInfo
local C_Reputation_IsMajorFaction = _G.C_Reputation.IsMajorFaction
local C_GossipInfo_GetFriendshipReputation = _G.C_GossipInfo.GetFriendshipReputation
local C_GossipInfo_GetFriendshipReputationRanks = _G.C_GossipInfo.GetFriendshipReputationRanks
local C_MajorFactions_GetMajorFactionData = _G.C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = _G.C_MajorFactions.HasMaximumRenown

local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local RENOWN_LEVEL_LABEL = _G.RENOWN_LEVEL_LABEL
local BLUE_FONT_COLOR = _G.BLUE_FONT_COLOR
local standingmax = 8
local standingmin = 1

function REP:InitializeDB()
    self.dbKey = E.myname .. "-" .. E.myrealm
    E.global.nihilistzscheui = E.global.nihilistzscheui or {}
    E.global.nihilistzscheui.reputations = E.global.nihilistzscheui.reputations or {}
    E.global.nihilistzscheui.reputations[self.dbKey] = E.global.nihilistzscheui.reputations[self.dbKey] or {}
end

function REP:GetDB() return E.global.nihilistzscheui.reputations[self.dbKey] end
function REP:CheckMetatable(db)
    if not getmetatable(db) then
        setmetatable(db, {
            __eq = function(a, b)
                return a.Standing == b.Standing
                    and a.Value == b.Value
                    and a.HasParagonReward == b.HasParagonReward
                    and a.WasParagon == b.WasParagon
                    and a.IsMajorFaction == b.IsMajorFaction
                    and a.IsFriend == b.IsFriend
            end,
        })
    end
end

function REP:UpdateDBValues(name, values)
    local db = self:GetDB()

    if not db[name] then
        db[name] = values
    else
        self:CheckMetatable(db[name])
        self:CheckMetatable(values)
        if db[name] ~= values then db[name] = values end
    end
end

function REP:ScanFactions()
    local db = self:GetDB()
    local numFactions = GetNumFactions()
    local standingID
    for i = 1, numFactions do
        local factionData = GetFactionDataByIndex(i)
        if factionData and not (factionData.isHeader or factionData.isHeaderWithRep) then
            local barValue = factionData.currentStanding
            local factionID = factionData.factionID
            local hasParagonReward = false
            local isParagon = C_Reputation_IsFactionParagon(factionID)
            local isMajorFaction = C_Reputation_IsMajorFaction(factionID)
            local friendData = C_GossipInfo_GetFriendshipReputation(factionID)
            local isFriend = friendData and friendData.friendshipFactionID ~= 0
            if isParagon then
                local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
                barValue = currentValue % threshold
                hasParagonReward = hasRewardPending
            elseif isFriend then
                barValue = friendData.standing
                local rankData = C_GossipInfo_GetFriendshipReputationRanks(friendData.friendshipFactionID)
                standingID = rankData.currentLevel
            elseif isMajorFaction then
                local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
                if not majorFactionData then return end
                local isCapped = C_MajorFactions_HasMaximumRenown(factionID)
                standingID = majorFactionData.renownLevel
                barValue = isCapped and majorFactionData.renownLevelThreshold
                    or majorFactionData.renownReputationEarned
                    or 0
            end
            local values = {
                Standing = isParagon and 999 or standingID,
                Value = barValue,
                HasParagonReward = hasParagonReward,
                WasParagon = isParagon,
                IsMajorFaction = isMajorFaction,
                IsFriend = isFriend,
            }
            self:UpdateDBValues(factionData.name, values)
        end
    end
    if numFactions > (db.numFactions or 0) then db.numFactions = numFactions end
end

function REP:Initialize()
    if COMP.SLE then
        if not DB then DB = _G["ElvUI_SLE"][1].DataBars or _G["ElvUI_SLE"][1]:GetModule("DataBars") end
        local Icon = DB.Icons.Rep
        self.textureMarkup = "|T" .. Icon .. ":12|t"
    end
    self:InitializeDB()
    self:ScanFactions()
    self:GetParent():RegisterNotifierEvent(self, "UPDATE_FACTION")
end

-- luacheck: no self
function REP:GenText(texts)
    return texts[1]
        .. " "
        .. DBN.colors.yellow
        .. texts[2]
        .. DBN.colors.resume
        .. " "
        .. texts[3]
        .. " "
        .. DBN.colors.yellow
        .. texts[4]
        .. DBN.colors.resume
        .. "!"
end

function REP:Notify()
    if not DBN.db.enabled then return end
    if tonumber(DBN.db.repchatframe) == 0 then return end

    local chatframe = _G["ChatFrame" .. tonumber(DBN.db.repchatframe)]

    local db = self:GetDB()
    local tempfactions = GetNumFactions()
    if tempfactions > db.numFactions then
        self:ScanFactions()
        db.numFactions = tempfactions
    end
    for factionIndex = 1, tempfactions do
        local factionData = GetFactionDataByIndex(factionIndex)
        if factionData then
            local barValue = factionData.currentStanding
            local barMin = factionData.currentReactionThreshold
            local barMax = factionData.nextReactionThreshold
            local factionID = factionData.factionID
            local standingID = factionData.reaction
            local _, friendData = xpcall(C_GossipInfo_GetFriendshipReputation, E.noop, factionID)
            local isFriend = friendData and friendData.friendshipFactionID ~= 0
            local friendID, friendRep
            local isParagon = false
            local hasParagonReward = false
            local isMajorFaction = false
            local rankData
            local name = factionData.name

            if factionID and C_Reputation_IsFactionParagon(factionID) then
                local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
                barMin, barMax = 0, threshold
                barValue = currentValue % threshold
                isParagon = true
                hasParagonReward = hasRewardPending
            end
            if factionID and C_Reputation_IsMajorFaction(factionID) then
                local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
                local isCapped = C_MajorFactions_HasMaximumRenown(factionID)
                if not majorFactionData then return end
                standingID = majorFactionData.renownLevel
                barMin, barMax = 0, majorFactionData.renownLevelThreshold
                barValue = isCapped and majorFactionData.renownLevelThreshold
                    or majorFactionData.renownReputationEarned
                    or 0
                isMajorFaction = true
            end
            if isFriend and not isParagon then
                rankData = C_GossipInfo_GetFriendshipReputationRanks(friendData.friendshipFactionID)
                barMin, barMax, barValue =
                    friendData.reactionThreshold,
                    friendData.nextThreshold or friendData.reactionThreshold,
                    friendData.standing
                standingID = rankData.currentLevel
                friendID, friendRep = friendData.friendshipFactionID, friendData.reaction
            end
            if isParagon then standingID = 999 end

            if (not factionData.isHeader or factionData.isHeaderWithRep) and db[name] then
                local diff = barValue - db[name].Value
                local skipMessage = false
                if diff ~= 0 then
                    if standingID ~= db[name].Standing or hasParagonReward ~= db[name].HasParagonReward then
                        local newfaction = friendID and friendID ~= 0 and friendRep
                            or _G["FACTION_STANDING_LABEL" .. standingID]

                        local newstandingtext

                        if isParagon and db[name].WasParagon then
                            newstandingtext = self:GenText({ "You have received a", "reward coffer", "from", name })
                            skipMessage = true
                        elseif isMajorFaction then
                            newstandingtext =
                                self:GenText({ "New standing with", name, "is", RENOWN_LEVEL_LABEL .. standingID })
                        else
                            if isParagon then newfaction = "Paragon" end
                            newstandingtext = self:GenText({ "New standing with", name, "is", newfaction })
                        end
                        chatframe:AddMessage(newstandingtext)
                    end

                    local remaining, nextstanding, nextstandingID
                    nextstandingID = standingID
                    if diff > 0 or isParagon then
                        remaining = barMax - barValue
                        if friendID and friendID ~= 0 then
                            nextstanding = ("next rank (current rank: %s)"):format(friendRep)
                        elseif isMajorFaction then
                            nextstanding = RENOWN_LEVEL_LABEL .. standingID + 1
                        else
                            if standingID < standingmax then
                                nextstanding = _G["FACTION_STANDING_LABEL" .. standingID + 1]
                                nextstandingID = standingID + 1
                            elseif isParagon then
                                nextstanding = "the next reward coffer"
                            else
                                nextstanding = "End of " .. _G["FACTION_STANDING_LABEL" .. standingmax]
                            end
                        end
                    else
                        remaining = barValue - barMin
                        if friendID and friendID ~= 0 then
                            nextstanding = ("next rank (current rank: %s)"):format(friendRep)
                        elseif isMajorFaction then
                            nextstanding = RENOWN_LEVEL_LABEL .. standingID - 1
                        else
                            if standingID > standingmin then
                                nextstanding = _G["FACTION_STANDING_LABEL" .. standingID - 1]
                                nextstandingID = standingID - 1
                            else
                                nextstanding = "Beginning of " .. _G["FACTION_STANDING_LABEL" .. standingmin]
                            end
                        end
                    end

                    local change = math.abs(barValue - db[name].Value)
                    local repetitions = math.ceil(remaining / change)

                    if not skipMessage then
                        local color, basecolor
                        if isParagon and COMP.PR then
                            local r, g, b = unpack(_G.ParagonReputationDB.value)
                            color = E:RGBToHex(r, g, b)
                            basecolor = color
                        elseif isFriend then
                            local offset = standingmax - rankData.maxLevel
                            local _color = FACTION_BAR_COLORS[rankData.currentLevel + offset]
                            color = E:RGBToHex(_color.r, _color.g, _color.b)
                            basecolor = color
                        elseif isMajorFaction then
                            color = E:RGBToHex(BLUE_FONT_COLOR.r, BLUE_FONT_COLOR.g, BLUE_FONT_COLOR.b)
                            basecolor = color
                        else
                            local _color = FACTION_BAR_COLORS[nextstandingID] or FACTION_BAR_COLORS[1]
                            local _basecolor = FACTION_BAR_COLORS[standingID] or FACTION_BAR_COLORS[1]
                            color = E:RGBToHex(_color.r, _color.g, _color.b)
                            basecolor = E:RGBToHex(_basecolor.r, _basecolor.g, _basecolor.b)
                        end
                        chatframe:AddMessage(
                            self:GetParent():GenerateNotification(
                                self.textureMarkup,
                                basecolor,
                                name,
                                change,
                                remaining,
                                color,
                                nextstanding,
                                repetitions
                            )
                        )
                    end

                    local values = {
                        Standing = isParagon and 999 or standingID,
                        Value = barValue,
                        HasParagonReward = hasParagonReward,
                        WasParagon = isParagon,
                        IsMajorFaction = isMajorFaction,
                        IsFriend = isFriend,
                    }
                    self:UpdateDBValues(name, values)
                end
            end
        end
    end
end

DBN:RegisterNotifier(REP)
