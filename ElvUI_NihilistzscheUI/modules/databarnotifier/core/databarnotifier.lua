local NUI = _G.unpack(select(2, ...))
local DBN = NUI.DataBarNotifier

local Mixin = _G.Mixin

DBN.colors = {
    white = "|cffffffff",
    yellow = "|cffffff78",
    orange = "|cffff7831",
    resume = "|r"
}

function DBN:InitRegisteredNotifiers()
    for _, t in pairs(self.RegisteredNotifiers) do
        t:Initialize(self)
    end
end

function DBN:Initialize()
    NUI:RegisterDB(self, "databarnotifier")
    self:InitRegisteredNotifiers()
end

local prototype = {parent = DBN}

function prototype:GetParent()
    return self.parent
end

function prototype:ScanXP()
    self.values = {last = self.curFunc(), max = self.maxFunc(), level = self.levelFunc()}
end

function prototype:Notify()
    local c = self.curFunc()
    local max = self.maxFunc()

    if (not self.values) then
        self:ScanXP()
    end

    self:GetParent():XPNotification(self, c, max)
end

function DBN:NewNotifier(name, label, chatFrameKey, color, curFunc, maxFunc, levelFunc)
    if not label then
        return {
            name = name,
            GetParent = function()
                return self
            end
        }
    end
    return Mixin(
        {
            name = name,
            label = label,
            color = color,
            curFunc = curFunc,
            maxFunc = maxFunc,
            levelFunc = levelFunc,
            chatFrameKey = chatFrameKey
        },
        prototype
    )
end

function DBN:RegisterNotifier(notifierTbl)
    if (not self.RegisteredNotifiers) then
        self.RegisteredNotifiers = {}
    end
    self.RegisteredNotifiers[notifierTbl.name] = notifierTbl
end

local overflowVal = 2e9

function DBN.SaveXP(value)
    if (value > overflowVal) then
        value = value - overflowVal
        return {value, true}
    end
    return value
end

function DBN.GetXP(value)
    if (type(value) == "table") then
        return value[1] + overflowVal
    end
    return value
end

function DBN:GenerateNotification(textureMarkup, color, label, change, remaining, levelColor, level, repetitions)
    return string.format(
        "%s%s%+.0f%s %s%s, %s%.0f%s more to %s%s%s%s (%s%d%s Repetitions).",
        textureMarkup and textureMarkup or "",
        self.colors.orange,
        change,
        color,
        label,
        self.colors.resume,
        self.colors.orange,
        remaining,
        self.colors.resume,
        levelColor or DBN.colors.yellow,
        type(level) == "number" and "level " or "",
        level,
        self.colors.resume,
        self.colors.orange,
        repetitions,
        self.colors.resume
    )
end

function DBN:XPNotification(module, c, max)
    local chatframeID = tonumber(DBN.db[module.chatFrameKey .. "chatframe"])
    if chatframeID == 0 then
        return
    end
    local chatframe = _G["ChatFrame" .. chatframeID]
    local values = module.values
    local change, remaining, repetitions, level
    if (c < self.GetXP(values.last)) then
        change = math.abs(c + (self.GetXP(values.max) - self.GetXP(values.last)))
        values.max = self.SaveXP(max)
        remaining = self.GetXP(values.max) - c
        repetitions = math.ceil(remaining / change)
        level = values.level + 1
        values.level = level
    else
        change = math.abs(c - self.GetXP(values.last))
        if (change == 0) then
            return
        end
        remaining = self.GetXP(values.max) - c
        repetitions = math.ceil(remaining / change)
        level = values.level
    end
    values.last = self.SaveXP(c)
    chatframe:AddMessage(
        self:GenerateNotification(
            module.textureMarkup,
            module.color,
            module.label,
            change,
            remaining,
            nil,
            level + 1,
            repetitions
        )
    )
end

DBN.NotifierEventCallbacks = {}

function DBN:RegisterNotifierEvent(notifierObj, event)
    if (not self.NotifierEventCallbacks[notifierObj]) then
        self.NotifierEventCallbacks[notifierObj] = function()
            notifierObj:Notify()
        end
    end

    self:RegisterEvent(event, self.NotifierEventCallbacks[notifierObj])
end

NUI:RegisterModule(DBN:GetName())
