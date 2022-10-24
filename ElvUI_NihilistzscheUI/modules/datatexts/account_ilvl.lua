local NUI, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E.DataTexts
local COMP = NUI.Compatibility

local format = string.format
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local GetItemLevelColor = _G.GetItemLevelColor
local GetAverageItemLevel = _G.GetAverageItemLevel
local strfind = _G.strfind
local strmatch = _G.strmatch
local tremove = _G.tremove
local tinsert = _G.tinsert

local displayString = ""

local function sortIlevels(entrya, entryb)
    if entrya.faction ~= entryb.faction then
        return entrya.faction > entryb.faction
    end

    if entrya.ilvl == entryb.ilvl then
        return true
    end

    return entrya.ilvl > entryb.ilvl
end

local alliance_color = "|cff0070de"
local horde_color = "|cffc41f3b"

local function buildIlvlString(entry)
    local hex = E:RGBToHex(unpack(entry.color))
    return format("%s%s|r", hex, math.floor(entry.ilvl))
end

local SLEiconPath, iconPath, buildFactionIconString, buildClassIconString

if (COMP.SLE) then
    SLEiconPath = [[Interface\AddOns\ElvUI_SLE\media\textures\afk\factionlogo\]]

    buildFactionIconString = function(entry)
        return "|T" .. SLEiconPath .. entry.faction .. ".blp:15:15:0:0:64:64:4:56:4:56|t"
    end
end

local function buildCharacterNameString(entry)
    if NUI.Private and not buildClassIconString then
        iconPath = [[Interface\AddOns\ElvUI_NihilistzscheUI_Private\media\textures\]]
        buildClassIconString = function(_entry)
            return "|T" .. iconPath .. _entry.class .. ".tga:15:15:0:0:64:64:4:56:4:56|t"
        end
    end
    local classColors = entry.class == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[entry.class]
    local color = E:RGBToHex(classColors.r, classColors.g, classColors.b)
    if (COMP.SLE and NUI.Private) then
        return format("%s %s%s|r %s", buildClassIconString(entry), color, entry.name, buildFactionIconString(entry))
    elseif (NUI.Private) then
        return format("%s %s%s|r", buildClassIconString(entry), color, entry.name)
    elseif (COMP.SLE) then
        return format("%s%s|r %s", color, entry.name, buildFactionIconString(entry))
    else
        return format("%s%s|r", color, entry.name)
    end
end

local function buildEntryString(entry)
    local fc = entry.faction == "Horde" and horde_color or alliance_color
    local str1 = format("%s(|r%s%s)|r", fc, buildIlvlString(entry), fc)
    local str2 = buildCharacterNameString(entry)
    return str1, str2
end

local function OnEnter(self)
    self:GetParent().anchor = "ANCHOR_BOTTOM"
    DT:SetupTooltip(self)

    local tbl = E.global.nihilistzscheui.accountilvl[E.myrealm]
    if (not tbl) then
        DT.tooltip:AddLine("No recorded ilevels?")
        DT.tooltip:Show()
        return
    end

    table.sort(tbl, sortIlevels)

    for _, entry in ipairs(tbl) do
        DT.tooltip:AddDoubleLine(buildEntryString(entry))
    end

    DT.tooltip:Show()
end

local function addOrUpdateIlvlEntry()
    if (not E.global.nihilistzscheui) then
        E.global.nihilistzscheui = {}
    end

    if (not E.global.nihilistzscheui.accountilvl) then
        E.global.nihilistzscheui.accountilvl = {}
    end

    if (not E.global.nihilistzscheui.accountilvl[E.myrealm]) then
        E.global.nihilistzscheui.accountilvl[E.myrealm] = {}
    end

    local name = E.myname
    local class = E.myclass
    local faction = E.myfaction

    local r, g, b = GetItemLevelColor()

    local entry = nil
    for _, e in ipairs(E.global.nihilistzscheui.accountilvl[E.myrealm]) do
        if e.name == name then
            entry = e
            break
        end
    end
    if (not entry) then
        entry = {name = name, class = class, faction = faction, ilvl = GetAverageItemLevel(), color = {r, g, b}}
        tinsert(E.global.nihilistzscheui.accountilvl[E.myrealm], entry)
    else
        entry.ilvl = GetAverageItemLevel()
        entry.color = {r, g, b}
    end

    return entry
end

local function UpdateDisplay(self)
    self.text:SetText(displayString)
end

local function OnEvent(self)
    for _, v in pairs(E.global.nihilistzscheui.accountilvl[1] or {}) do
        if (type(v) ~= "table") then
            E.global.nihilistzscheui.accountilvl = {}
        end
    end

    local entry = addOrUpdateIlvlEntry()
    local str1, str2 = buildEntryString(entry)
    displayString = format("%s %s", str1, str2)
    UpdateDisplay(self)
end

local function ValueColorUpdate()
    local entry = addOrUpdateIlvlEntry()

    if not entry then
        displayString = "|cffff2020No Data|r"
    else
        local str1, str2 = buildEntryString(entry)
        displayString = format("%s %s", str1, str2)
    end
end

local function RmTrackedCharacter(msg)
    local name, realm
    if (strfind(msg, "-")) then
        name, realm = strmatch(msg, "(.+)-(.+)")
    else
        name = msg
    end
    if (not realm) then
        realm = E.myrealm
    end
    local removeIndex = 0
    for i, entry in ipairs(E.global.nihilistzscheui.accountilvl[realm]) do
        if (entry.name == name) then
            removeIndex = i
            break
        end
    end
    if (removeIndex ~= 0) then
        tremove(E.global.nihilistzscheui.accountilvl[realm], removeIndex)
    end
end

_G.SLASH_RMILVLWATCH1 = "/rmilvlwatch"
_G.SlashCmdList.RMILVLWATCH = RmTrackedCharacter

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext(
    "NihilistzscheUI Account Item Level",
    "NihilistzscheUI",
    {"PLAYER_ENTERING_WORLD", "PLAYER_EQUIPMENT_CHANGED", "PLAYER_AVG_ITEM_LEVEL_UPDATE"},
    UpdateDisplay,
    OnEvent,
    nil,
    OnEnter
)
