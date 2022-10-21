local MAJOR_VERSION = "LibNihilistzscheUITags-1.0"
local MINOR_VERSION = 1

if not _G.LibStub then
    error(MAJOR_VERSION .. " requires LibStub")
end

local NihilistzscheLib = _G.LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not NihilistzscheLib then
    return
end

local strsplit = _G.strsplit
local CreateFrame = _G.CreateFrame

NihilistzscheLib.registeredTags = {}
NihilistzscheLib.registeredEvents = {}
NihilistzscheLib.registeredTagStrings = {}

local mouseoverSeen = {}
local E
local function NTags_OnEnter(self)
    if not E then
        E = _G.ElvUI[1]
    end
    if (mouseoverSeen[self]) then
        E:UIFrameFadeIn(self, 0.2, 0, 1)
    end
end

local function NTags_OnLeave(self)
    if not E then
        E = _G.ElvUI[1]
    end
    if (mouseoverSeen[self]) then
        E:UIFrameFadeOut(self, 0.2, 1, 0)
    end
end

function NihilistzscheLib:RegisterTag(tag, evaluationFunc, events)
    if not events then
        events = ""
    end

    local _events = {strsplit(" ", events)}

    self.registeredTags[tag] = {evaluationFunc = evaluationFunc, events = _events}
    for _, event in ipairs(_events) do
        if (event ~= "") then
            if (not self.registeredEvents[event]) then
                self.driverFrame:RegisterEvent(event)
                self.registeredEvents[event] = 0
            end
            self.registeredEvents[event] = self.registeredEvents[event] + 1
        end
    end
end

function NihilistzscheLib:UnregisterTag(tag)
    if (not self.registeredTags[tag]) then
        return
    end
    local events = self.registeredTags[tag].events
    for _, event in ipairs(events) do
        self.registeredEvents[event] = self.registeredEvents[event] - 1
        if (self.registeredEvents[event] == 0) then
            self.driverFrame:UnregisterEvent(event)
            self.registeredEvents[event] = nil
        end
    end
    self.registeredTags[tag] = nil
end

function NihilistzscheLib:RegisterFontString(key, fs)
    if (not self.registeredTagStrings[key]) then
        self.registeredTagStrings[key] = {}
    end
    self.registeredTagStrings[key].fs = fs
    self.registeredTagStrings[key].backingText = ""
    local frame = fs:GetParent()
    frame:HookScript(
        "OnEnter",
        function()
            if (not NihilistzscheLib.registeredTagStrings[key]) then
                return
            end
            NTags_OnEnter(fs)
        end
    )
    frame:HookScript(
        "OnLeave",
        function()
            if (not NihilistzscheLib.registeredTagStrings[key]) then
                return
            end
            NTags_OnLeave(fs)
        end
    )
    -- We own this fs, so only we should change the text
    fs.blzSetText = fs.SetText
    fs.SetText = function()
    end
end

function NihilistzscheLib:UnregisterFontString(key)
    if (not self.registeredTagStrings[key]) then
        return
    end
    local fs = self.registeredTagStrings[key].fs
    fs.SetText = fs.blzSetText
    fs.blzSetText = nil
    self.registeredTagStrings[key] = nil
end

function NihilistzscheLib:Tag(key, tagStr)
    if (not self.registeredTagStrings[key]) then
        return
    end
    self.registeredTagStrings[key].backingText = tagStr
    NihilistzscheLib:UpdateTagStrings()
end

NihilistzscheLib.driverFrame = CreateFrame("Frame")
NihilistzscheLib.driverFrame:SetScript(
    "OnEvent",
    function()
        NihilistzscheLib:UpdateTagStrings()
    end
)

local CurrentFS, CurrentKey
NihilistzscheLib.tagDirector = {}
setmetatable(
    NihilistzscheLib.tagDirector,
    {
        __index = function(_, key)
            local customArgs = key:match("{(.-)}%]")
            if customArgs then
                key:gsub("{.-}%]", "]")
            end
            if (NihilistzscheLib.registeredTags[key]) then
                local res = NihilistzscheLib.registeredTags[key].evaluationFunc(CurrentFS, customArgs)
                if (res) then
                    NihilistzscheLib.registeredTags[key].cachedResult = res
                    return res
                end
                return NihilistzscheLib.registeredTags[key].cachedResult
            end
            return nil
        end
    }
)

NihilistzscheLib:RegisterTag(
    "mouseover",
    function()
        local key = CurrentKey
        mouseoverSeen[key] = true
        return ""
    end
)

function NihilistzscheLib:UpdateTagStrings()
    for k in pairs(self.registeredTagStrings) do
        self:UpdateTagString(k)
    end
end

function NihilistzscheLib:UpdateTagString(key)
    local _t = self.registeredTagStrings[key]
    CurrentKey = key
    CurrentFS = _t.fs
    mouseoverSeen[key] = false
    _t.fs:blzSetText(_t.backingText:gsub("%[([^%]]+)%]", self.tagDirector))
    if (mouseoverSeen[key]) then
        if (not _t.fs:IsMouseOver()) then
            NTags_OnLeave(_t.fs)
        else
            NTags_OnEnter(_t.fs)
        end
    end
end
