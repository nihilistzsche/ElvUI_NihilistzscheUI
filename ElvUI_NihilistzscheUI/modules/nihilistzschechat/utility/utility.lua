---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local CH = E.Chat
local NC = NUI.NihilistzscheChat
local LW = NUI.Libs.LibWho
local ES = NUI.EnhancedShadows

local CreateFrame = _G.CreateFrame
local ChatTypeInfo = _G.ChatTypeInfo
local BNet_GetBNetIDAccount = _G.BNet_GetBNetIDAccount
local C_BattleNet_GetAccountInfoByID = _G.C_BattleNet.GetAccountInfoByID
local C_BattleNet_GetGameAccountInfoByID = _G.C_BattleNet.GetGameAccountInfoByID
local GetQuestDifficultyColor = _G.GetQuestDifficultyColor
local GetPlayerInfoByGUID = _G.GetPlayerInfoByGUID
local UnitInParty = _G.UnitInParty
local UnitClass = _G.UnitClass
local UnitRace = _G.UnitRace
local UnitLevel = _G.UnitLevel
local UnitName = _G.UnitName
local UNKNOWN = _G.UNKNOWN
local strfind = _G.strfind
local tinsert = _G.tinsert
local tremove = _G.tremove
local GetGameTime = _G.GetGameTime
local format = _G.format
local ERR_FRIEND_OFFLINE_S = _G.ERR_FRIEND_OFFLINE_S
local ERR_FRIEND_ONLINE_SS = _G.ERR_FRIEND_ONLINE_SS

local Backdrop = {
    bgFile = E.media.blankTex,
    edgeFile = E.media.blankTex,
    tile = false,
    tileSize = 0,
    edgeSize = 1,
}

function NC.URLChatFrame_OnHyperlinkShow(self, link)
    CH.clickedframe = self
    if (link):sub(1, 3) == "url" then
        local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
        local currentLink = (link):sub(5)
        if not ChatFrameEditBox:IsShown() then ChatEdit_ActivateChat(ChatFrameEditBox) end
        ChatFrameEditBox:Insert(currentLink)
        ChatFrameEditBox:HighlightText()
        return
    end
end

function NC:SetStyle(f, panel, border)
    f:SetBackdrop(Backdrop)

    if panel then
        local color = self.db.general.backdropcolor
        f:SetBackdropColor(color.r, color.g, color.b, self.db.general.alpha)
    else
        f:SetBackdropColor(0, 0, 0, 1)
    end

    if border then
        local color = self.db.general.bordercolor
        f:SetBackdropBorderColor(color.r, color.g, color.b, self.db.general.alpha)
    else
        f:SetBackdropBorderColor(0, 0, 0)
    end
end

function NC:CreateDock()
    local dock = CreateFrame("Frame", "NihilistzscheChatDock", E.UIParent, "BackdropTemplate")
    local bcolor = self.db.general.backdropcolor
    local rcolor = self.db.general.bordercolor

    dock:Size(160, 8)
    dock:SetPoint("LEFT", E.UIParent, "LEFT", 0, 0)
    dock:CreateBackdrop("Transparent")
    dock.backdrop:SetBackdropColor(bcolor.r, bcolor.g, bcolor.b, self.db.general.alpha)
    dock.backdrop:SetBackdropBorderColor(rcolor.r, rcolor.g, rcolor.b, self.db.general.alpha)
    dock:SetAlpha(0)
    dock:EnableMouse(false)

    E:CreateMover(dock, dock:GetName() .. "Mover", "NihilistzscheChat Dock", nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")

    self.dock = dock
end

function NC:CheckDelayed()
    for sender, _ in pairs(self.delayed) do
        if self.userCache[sender] then
            for _, args in ipairs(self.delayed[sender]) do
                self:AddIncoming(args.event, args.msg, sender, args.guid)
            end
        end
    end
end

function NC:FixSameRealm(string)
    if string:find("%-") then
        local name, realm = string.split("-", string)
        if realm == self.myrealm then return name end
    end
    return string
end

NC.TexturePath = "Interface\\AddOns\\ElvUI_NihilistzscheUI\\media\\textures\\"
NC.CrestFormat = "%s_crest.tga"

NC.Clients = {
    WTCG = "Hearthstone",
    ["D3"] = "Diablo 3",
    ["S2"] = "StarCraft 2",
    Hero = "Heroes of the Storm",
    App = "Battle.net Desktop App",
    ["S1"] = "StarCraft: Remastered",
    ["DST2"] = "Destiny 2",
    VIPR = "Call of Duty 4",
    BSAp = "Mobile",
    ["W3"] = "Warcraft 3",
    ODIN = "Call of Duty: Modern Warfare",
    CLNT = "Battle.net Desktop App",
    Pro = "Overwatch",
    LAZR = "Call of Duty: Modern Warfare II",
    ZEUS = "Call of Duty: Black Ops Cold War",
    RTRO = "Blizzard Arcade Collection",
    ["WLBY"] = "Crash Bandicoot 4",
    OSI = "Diablo II: Ressurected",
}

setmetatable(NC.Clients, {
    __index = function(t, k) return rawget(t, k) or ("Unknown: %s"):format(k) end,
})

function NC:GetRaceTexture(race)
    if not race then return end
    return self.TexturePath .. string.format(self.CrestFormat, race)
end

function NC:QueueWhoUpdate(sender)
    self.queuedWhoUpdates = self.queuedWhoUpdates or {}
    self.queuedWhoUpdates[sender] = true
end

function NC:ProcessQueuedWhoRequests()
    for sender in pairs(self.queuedWhoUpdates or {}) do
        local results = LW:UserInfo(sender, {
            callback = function(results)
                if results then
                    self.userCache[sender] = {}
                    self.userCache[sender].level = results.Level
                    self.userCache[sender].class = results.Class
                    self.userCache[sender].race = results.Race
                    self.userCache[sender].name = results.Name
                    self.queuedWhoUpdates[sender] = nil
                    self:CheckDelayed()
                else
                    self.userCache[sender] = {}
                    self.userCache[sender].level = UNKNOWN
                    self.userCache[sender].class = UNKNOWN
                    self.userCache[sender].race = UNKNOWN
                    self.userCache[sender].name = sender
                    self:CheckDelayed()
                end
            end,
        })
        if results then
            self.userCache[sender] = {}
            self.userCache[sender].level = results.Level
            self.userCache[sender].class = results.Class
            self.userCache[sender].race = results.Race
            self.userCache[sender].name = results.Name
            self.queuedWhoUpdates[sender] = nil
            self:CheckDelayed()
        end
    end
end
function NC:SetInfoString(event, sender, guid)
    sender = NC:FixSameRealm(sender)
    local chat = self.chats[sender]

    local infoString
    local tabName
    local hasInfo = true
    local isWoW, raceBackground = false, nil
    local classColor, classColorHex

    local chatType, chatColor
    if event == "CHAT_MSG_BN_WHISPER" or event == "CHAT_MSG_BN_WHISPER_INFORM" then
        chatType = "BN_WHISPER"
        chatColor = ChatTypeInfo[chatType]
        local id = BNet_GetBNetIDAccount(sender)
        local accountInfo = C_BattleNet_GetAccountInfoByID(id)
        if not accountInfo then return end
        local gameAccountInfo = C_BattleNet_GetGameAccountInfoByID(accountInfo.gameAccountInfo.gameAccountID)
        if not gameAccountInfo then return end
        if gameAccountInfo.clientProgram == "WoW" then
            local token = self.maleClasses[gameAccountInfo.className]
            if not token then token = self.femaleClasses[gameAccountInfo.className] end
            local color = GetQuestDifficultyColor(gameAccountInfo.characterLevel)
            local levelColor = E:RGBToHex(color.r, color.g, color.b)
            classColor = NUI.ClassColor(false, token)
            classColorHex = E:RGBToHex(classColor.r, classColor.g, classColor.b)
            tabName = classColorHex .. accountInfo.accountName .. "|r"
            infoString = classColorHex
                .. accountInfo.accountName
                .. " "
                .. gameAccountInfo.characterName
                .. "|r ("
                .. levelColor
                .. gameAccountInfo.characterLevel
                .. "|r  "
                .. gameAccountInfo.raceName
                .. " "
                .. classColorHex
                .. gameAccountInfo.className
                .. "|r) "
            isWoW = true
            raceBackground = self:GetRaceTexture(self.raceMap[gameAccountInfo.raceName])
            self.senderInfo[sender] = { classColor = classColorHex, toonName = gameAccountInfo.characterName }
        elseif gameAccountInfo.clientProgram then
            local fixedClient = NC.Clients[gameAccountInfo.clientProgram]
            tabName = accountInfo.accountName
            infoString = accountInfo.accountName .. " (" .. fixedClient .. ")"
            self.senderInfo[sender] = nil
        else
            tabName = "Unknown"
            infoString = "Unknown"
        end
        chat.hex = E:RGBToHex(chatColor.r, chatColor.g, chatColor.b)
    elseif event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM" then
        local realm, class, level, race, name
        local onMyRealm = true
        local inParty = false
        self.senderInfo[sender] = nil

        if guid then
            local _
            class, _, race, _, _, name, realm = GetPlayerInfoByGUID(guid)

            onMyRealm = realm == ""
            inParty = UnitInParty(name)

            if not onMyRealm and not inParty then
                level = UnitLevel(sender)
                if not level or level == 0 then level = "??" end

                self.userCache[sender] = {}
                self.userCache[sender].level = level
                self.userCache[sender].race = race
                self.userCache[sender].class = class
                self.userCache[sender].name = name
            end
        end
        if onMyRealm or inParty then
            realm = onMyRealm and NC.myrealm or realm

            class = UnitClass(sender)
            level = UnitLevel(sender)
            race = UnitRace(sender)
            name = UnitName(sender)

            if class and level and level > 0 and race and name and not self.userCache[sender] then
                self.userCache[sender] = {}
                self.userCache[sender].level = level
                self.userCache[sender].race = race
                self.userCache[sender].class = class
                self.userCache[sender].name = name
            end

            if not self.userCache[sender] or self.userCache[sender].level == "UNKNOWN" then
                self:QueueWhoUpdate(sender)
                hasInfo = false
                chat.hex = E:RGBToHex(1.0, 1.0, 1.0)
                tabName = sender
                infoString = sender
            end
        end

        if hasInfo then
            level = self.userCache[sender].level
            class = self.userCache[sender].class
            race = self.userCache[sender].race
            name = self.userCache[sender].name
            isWoW = true
            raceBackground = self:GetRaceTexture(self.raceMap[race])

            if level ~= UNKNOWN then
                local color = level ~= "??" and GetQuestDifficultyColor(level) or GetQuestDifficultyColor(1)
                local levelColor = E:RGBToHex(color.r, color.g, color.b)

                local token = self.maleClasses[class]
                if not token then token = self.femaleClasses[class] end
                classColor = NUI.ClassColor(false, token)
                classColorHex = E:RGBToHex(classColor.r, classColor.g, classColor.b)

                if realm ~= NC.myrealm then
                    infoString = classColorHex
                        .. name
                        .. "|r ("
                        .. levelColor
                        .. level
                        .. "|r "
                        .. race
                        .. " "
                        .. classColorHex
                        .. class
                        .. "|r) "
                        .. realm
                else
                    infoString = classColorHex
                        .. name
                        .. "|r ("
                        .. levelColor
                        .. level
                        .. "|r  "
                        .. race
                        .. " "
                        .. classColorHex
                        .. class
                        .. "|r)"
                end
                tabName = classColorHex .. name .. "|r"
            else
                classColorHex = E:RGBToHex(1.0, 1.0, 1.0)
                tabName = name
                infoString = name
            end

            self.senderInfo[sender] = { classColor = classColorHex, toonName = name }
            chat.hex = classColorHex
        end
    end

    chat.Name:SetText(infoString)
    chat.DockedName:SetText(infoString)
    chat.Background:SetShown(isWoW)
    if raceBackground then chat.Background:SetTexture(raceBackground) end

    NC:UpdateTab(chat, tabName, isWoW and classColor)

    return true
end

function NC:AddIncoming(event, msg, sender, guid) -- Add messages to the text
    sender = NC:FixSameRealm(sender)
    local chat = self.chats[sender]
    if not chat then return end
    local text = chat.Text
    if
        not text
        or (strfind(msg, "<DBM>"))
        or (strfind(msg, "<Deadly Boss Mods>"))
        or (strfind(msg, "<VEM>"))
        or (strfind(msg, "<Voice Encounter Mods>"))
        or (strfind(msg, "<BigWigs>"))
    then
        return
    end -- Blocking dumb DBM messages
    local color, str

    if event == "CHAT_MSG_BN_WHISPER" or event == "CHAT_MSG_BN_WHISPER_INFORM" then
        color = ChatTypeInfo.BN_WHISPER
    elseif event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM" then
        color = ChatTypeInfo.WHISPER
    end

    local res = NC:SetInfoString(event, sender, guid)
    if res == true then
        if self.delayed[sender] then
            local remove
            for i, v in ipairs(self.delayed[sender]) do
                if v.msg == msg then
                    remove = i
                    break
                end
            end
            tremove(self.delayed[sender], remove)
        end
    elseif res == false then
        if not self.delayed[sender] then self.delayed[sender] = {} end
        tinsert(self.delayed[sender], { event = event, msg = msg, guid = guid })
        return
    else
        return
    end

    local timestamp = ""
    if NC.db.windows.timestamp then timestamp = NC:GetFormattedTime(false, true) end

    if not chat.hex then chat.hex = "|cffffffff" end

    if event == "CHAT_MSG_WHISPER_INFORM" then -- Whisper
        local classColor = NUI.ClassColor()
        classColor = E:RGBToHex(classColor.r, classColor.g, classColor.b)
        if self.senderInfo[sender] then
            str = classColor
                .. "@|r"
                .. self.senderInfo[sender].classColor
                .. "|Hplayer:"
                .. sender
                .. "|h"
                .. chat.hex
                .. sender
                .. "|r|h: "
                .. msg
        else
            str = classColor .. "@|r" .. " |Hplayer:" .. sender .. "|h" .. chat.hex .. sender .. "|r|h:" .. msg
        end
    elseif event == "CHAT_MSG_WHISPER" then
        if self.senderInfo[sender] then
            str = "|Hplayer:"
                .. sender
                .. "|h"
                .. self.senderInfo[sender].classColor
                .. sender
                .. "|r|h"
                .. chat.hex
                .. ": "
                .. msg
        else
            str = "|Hplayer:" .. sender .. "|h" .. chat.hex .. sender .. "|r|h" .. ": " .. msg
        end
        chat.LastMessage:SetText("Last message recieved at " .. NC:GetFormattedTime(true))
    elseif event == "CHAT_MSG_BN_WHISPER_INFORM" then -- BNet
        local classColor = NUI.ClassColor()
        classColor = E:RGBToHex(classColor.r, classColor.g, classColor.b)
        if self.senderInfo[sender] then
            str = classColor
                .. "@|r"
                .. self.senderInfo[sender].classColor
                .. self.senderInfo[sender].toonName
                .. "|r"
                .. chat.hex
                .. " ("
                .. sender
                .. "): "
                .. msg
        else
            str = classColor .. "@|r" .. sender .. ": " .. msg
        end
    else
        if self.senderInfo[sender] then
            str = self.senderInfo[sender].classColor
                .. self.senderInfo[sender].toonName
                .. "|r"
                .. chat.hex
                .. " ("
                .. sender
                .. "): "
                .. msg
        else
            str = sender .. ": " .. msg
        end
        chat.LastMessage:SetText("Last message recieved at " .. NC:GetFormattedTime(true))
    end

    if not chat.StartFlashClosure then chat.StartFlashClosure = function() self:StartFlash(chat.DockedName, 0.6) end end

    if not chat.TabStartFlashClosure then
        chat.TabStartFlashClosure = function() self:StartFlash(self.tabs[chat].text, 0.6) end
    end

    if chat.minimized then
        chat.Flash:SetScript("OnUpdate", chat.StartFlashClosure)
    elseif not chat.active then
        self.tabs[chat].Flash:SetScript("OnUpdate", chat.TabStartFlashClosure)
    end

    text:AddMessage(timestamp .. str, color.r, color.g, color.b, nil, false)
end

function NC:AddStatus(_, toast, author) -- Add messages to the text
    if not self.chats[author] then return end
    local text = self.chats[author].Text
    if not text then return end

    local status, hr, min, timestamp

    if self.db.windows.timestamp then
        hr, min = GetGameTime()
        timestamp = format("[%d:%d] ", hr, min)
    else
        timestamp = ""
    end

    if toast == "FRIEND_ONLINE" then
        status = format(ERR_FRIEND_ONLINE_SS, author, author)
    else
        status = format(ERR_FRIEND_OFFLINE_S, "[" .. author .. "]")
    end

    text:AddMessage(
        timestamp .. status,
        ChatTypeInfo.BN_WHISPER.r,
        ChatTypeInfo.BN_WHISPER.g,
        ChatTypeInfo.BN_WHISPER.b,
        nil,
        false
    )
end

local removeIconFromLine
do
    local raidIconFunc = function(x)
        x = x ~= "" and _G["RAID_TARGET_" .. x]
        return x and ("{" .. strlower(x) .. "}") or ""
    end
    local stripTextureFunc = function(w, x, y)
        if x == "" then return (w ~= "" and w) or (y ~= "" and y) or "" end
    end
    local hyperLinkFunc = function(w, x, y)
        if w ~= "" then return end
        local emoji = (x ~= "" and x) and strmatch(x, "elvmoji:%%(.+)")
        return (emoji and E.Libs.Deflate:DecodeForPrint(emoji)) or y
    end
    local fourString = function(v, w, x, y) return format("%s%s%s", v, w, (v and v == "1" and x) or y) end
    removeIconFromLine = function(text)
        text = gsub(text, [[|TInterface\TargetingFrame\UI%-RaidTargetingIcon_(%d+):0|t]], raidIconFunc) --converts raid icons into {star} etc, if possible.
        text = gsub(text, "(%s?)(|?)|[TA].-|[ta](%s?)", stripTextureFunc) --strip any other texture out but keep a single space from the side(s).
        text = gsub(text, "(|?)|H(.-)|h(.-)|h", hyperLinkFunc) --strip hyperlink data only keeping the actual text.
        text = gsub(text, "(%d+)(.-)|4(.-):(.-);", fourString) --stuff where it goes 'day' or 'days' like played; tech this is wrong but okayish
        return text
    end
end

local function colorizeLine(text, r, g, b)
    local hexCode = E:RGBToHex(r, g, b)
    return format("%s%s|r", hexCode, text)
end

local copyLines = {}
function NC:GetLines(frame)
    local index = 1
    for i = 1, frame:GetNumMessages() do
        local message, r, g, b = frame:GetMessageInfo(i)
        if message and not CH:MessageIsProtected(message) then
            --Set fallback color values
            r, g, b = r or 1, g or 1, b or 1

            --Remove icons
            message = removeIconFromLine(message)

            --Add text color
            message = colorizeLine(message, r, g, b)

            copyLines[index] = message
            index = index + 1
        end
    end

    return index - 1
end

function NC:CopyChat(frame)
    if not _G.CopyChatFrame:IsShown() then
        _G.CopyChatFrame:Show()
        local lineCt = self:GetLines(frame)
        local text = table.concat(copyLines, " \n", 1, lineCt)
        _G.CopyChatFrameEditBox:SetText(text)
    else
        _G.CopyChatFrame:Hide()
    end
end

local date = _G.date

function NC:GetFormattedTime(tag, timestamp)
    local hour, minutes
    if self.db.windows.localtime then
        hour, minutes = tonumber(date("%H")), tonumber(date("%M"))
    else
        hour, minutes = GetGameTime()
    end

    local _tag = "AM"

    if minutes < 10 then minutes = "0" .. tostring(minutes) end

    if hour > 12 then
        _tag = "PM"

        if self.db.windows.timeformat == "12Hour" then hour = hour - 12 end
    end

    if tag then
        if self.db.windows.timeformat == "12Hour" then
            return format("%s:%s %s", hour, minutes, _tag)
        else
            return format("%s:%s ", hour, minutes)
        end
    elseif timestamp then
        return format("[%s:%s] ", hour, minutes)
    end
end

function NC:StartFlash(obj, duration)
    if not obj.anim then
        obj.anim = obj:CreateAnimationGroup("Flash")

        obj.anim.fadein = obj.anim:CreateAnimation("ALPHA", "FadeIn")
        obj.anim.fadein:SetFromAlpha(0)
        obj.anim.fadein:SetToAlpha(1)
        obj.anim.fadein:SetOrder(2)

        obj.anim.fadeout = obj.anim:CreateAnimation("ALPHA", "FadeOut")
        obj.anim.fadeout:SetFromAlpha(1)
        obj.anim.fadeout:SetToAlpha(0)
        obj.anim.fadeout:SetOrder(1)
    end

    obj.anim.fadein:SetDuration(duration)
    obj.anim.fadeout:SetDuration(duration)
    obj.anim:Play()
end

function NC:StopFlash(obj)
    if obj.anim then obj.anim:Stop() end
end

function NC:UpdateAll()
    local width = self.db.windows.width
    local height = self.db.windows.height
    local fontsize = self.db.windows.fontsize
    local bcolor = self.db.general.backdropcolor
    local rcolor = self.db.general.bordercolor

    self.dock.backdrop:SetBackdropColor(bcolor.r, bcolor.g, bcolor.b, self.db.general.alpha)
    self.dock.backdrop:SetBackdropBorderColor(rcolor.r, rcolor.g, rcolor.b, self.db.general.alpha)

    for _, v in pairs(self.chats) do
        v:Size(width, height + 46)
        v.backdrop:SetBackdropColor(bcolor.r, bcolor.g, bcolor.b, self.db.general.alpha)
        v.backdrop:SetBackdropBorderColor(rcolor.r, rcolor.g, rcolor.b, self.db.general.alpha)
        v.Top:Size(width, 23)
        v.Top.backdrop:SetBackdropColor(bcolor.r, bcolor.g, bcolor.b, self.db.general.alpha)
        v.Top.backdrop:SetBackdropBorderColor(rcolor.r, rcolor.g, rcolor.b, self.db.general.alpha)
        v.Bottom:Size(width, 23)
        v.Bottom.backdrop:SetBackdropColor(bcolor.r, bcolor.g, bcolor.b, self.db.general.alpha)
        v.Bottom.backdrop:SetBackdropBorderColor(rcolor.r, rcolor.g, rcolor.b, self.db.general.alpha)
        v.EditBox:SetWidth(v:GetWidth())
        v.Text:SetFont(E.Libs.LSM:Fetch("font", self.db.windows.font), fontsize, "")
        if self.db.windows.showtitle then
            v.Name:SetAlpha(1)
        else
            v.Name:SetAlpha(0)
        end
    end
end
