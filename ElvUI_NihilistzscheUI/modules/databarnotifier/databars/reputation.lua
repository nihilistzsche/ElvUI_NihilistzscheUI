local NUI, E = _G.unpack(select(2, ...))

local DBN = NUI.DataBarNotifier
local COMP = NUI.Compatibility

local REP = DBN:NewNotifier("Reputation")
local DB

local GetNumFactions = _G.GetNumFactions
local GetFactionInfo = _G.GetFactionInfo
local C_Reputation_IsFactionParagon = _G.C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = _G.C_Reputation.GetFactionParagonInfo
local GetFriendshipReputation = _G.GetFriendshipReputation
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS

local standingmax = 8
local standingmin = 1

function REP:ScanFactions()
    self.numFactions = GetNumFactions()
    for i = 1, self.numFactions do
        local name, _, standingID, _, _, barValue, _, _, isHeader, _, hasRep, _, _, factionID = GetFactionInfo(i)
        if (name and not isHeader or hasRep) then
            local hasParagonReward = false
            local isParagon = C_Reputation_IsFactionParagon(factionID)
            if (isParagon) then
                local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
                barValue = currentValue % threshold
                if hasRewardPending then
                    barValue = barValue + threshold
                end
                hasParagonReward = hasRewardPending
            end
            self.values[name] = {
                Standing = isParagon and 999 or standingID,
                Value = barValue,
                HasParagonReward = hasParagonReward,
                WasParagon = isParagon
            }
        end
    end
end

function REP:Initialize()
    if COMP.SLE then
        if not DB then
            DB = _G.ElvUI_SLE[1].DataBars or _G.ElvUI_SLE[1]:GetModule("DataBars")
        end
        local Icon = DB.Icons.Rep
        self.textureMarkup = "|T" .. Icon .. ":12|t"
    end
    self.values = {}
    self:ScanFactions()
    self:GetParent():RegisterNotifierEvent(self, "UPDATE_FACTION")
end

-- luacheck: no self
function REP:GenText(texts)
    return texts[1] ..
        " " ..
            DBN.colors.yellow ..
                texts[2] ..
                    DBN.colors.resume ..
                        " " .. texts[3] .. " " .. DBN.colors.yellow .. texts[4] .. DBN.colors.resume .. "!"
end

function REP:Notify()
    if (not DBN.db.enabled) then
        return
    end
    if (tonumber(DBN.db.repchatframe) == 0) then
        return
    end

    local chatframe = _G["ChatFrame" .. tonumber(DBN.db.repchatframe)]

    local tempfactions = GetNumFactions()
    if (tempfactions > self.numFactions) then
        self:ScanFactions()
        self.numFactions = tempfactions
    end
    for factionIndex = 1, GetNumFactions() do
        local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, _, _, factionID =
            GetFactionInfo(factionIndex)
        local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID)
        local isParagon = false
        local hasParagonReward = false
        if (factionID and C_Reputation_IsFactionParagon(factionID)) then
            local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
            barMin, barMax = 0, threshold
            barValue = currentValue % threshold
            if hasRewardPending then
                barValue = barValue + threshold
            end
            isParagon = true
            hasParagonReward = hasRewardPending
        end

        if (isParagon) then
            standingID = 999
        end

        if (not isHeader or hasRep) and self.values[name] then
            local diff = barValue - self.values[name].Value
            local skipMessage = false
            if diff ~= 0 then
                if standingID ~= self.values[name].Standing or hasParagonReward ~= self.values[name].HasParagonReward then
                    local newfaction = friendID and friendTextLevel or _G["FACTION_STANDING_LABEL" .. standingID]

                    local newstandingtext

                    if (isParagon and self.values[name].WasParagon) then
                        newstandingtext = self:GenText({"You have received a", "reward coffer", "from", name})
                        skipMessage = true
                    else
                        if (isParagon) then
                            newfaction = "Paragon"
                        end
                        newstandingtext = self:GenText({"New standing with", name, "is", newfaction})
                    end
                    chatframe:AddMessage(newstandingtext)
                end

                local remaining, nextstanding, nextstandingID
                nextstandingID = standingID
                if diff > 0 or isParagon then
                    remaining = barMax - barValue
                    if (friendID) then
                        nextstanding = ("next rank (current rank: %s)"):format(friendTextLevel)
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
                    if (friendID) then
                        nextstanding = ("next rank (current rank: %s)"):format(friendTextLevel)
                    else
                        if standingID > standingmin then
                            nextstanding = _G["FACTION_STANDING_LABEL" .. standingID - 1]
                            nextstandingID = standingID - 1
                        else
                            nextstanding = "Beginning of " .. _G["FACTION_STANDING_LABEL" .. standingmin]
                        end
                    end
                end

                local change = math.abs(barValue - self.values[name].Value)
                local repetitions = math.ceil(remaining / change)

                if not skipMessage then
                    local color, basecolor
                    if (isParagon and COMP.MERS) then
                        local colorDB = E.db.mui.misc.paragon.paragonColor
                        color = E:RGBToHex(colorDB.r, colorDB.g, colorDB.b)
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

                self.values[name].Value = barValue
                self.values[name].Standing = isParagon and 999 or standingID
                self.values[name].HasParagonReward = hasParagonReward
                self.values[name].WasParagon = isParagon
            end
        end
    end
end

DBN:RegisterNotifier(REP)
