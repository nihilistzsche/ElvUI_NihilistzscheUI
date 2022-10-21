local NUI, E = _G.unpack(select(2, ...))

local UnitXP = _G.UnitXP
local UnitXPMax = _G.UnitXPMax
local UnitLevel = _G.UnitLevel

local DBN = NUI.DataBarNotifier
local COMP = NUI.Compatibility
local DB
local XP = DBN:NewNotifier("XP", "XP", "xp", DBN.colors.yellow, NUI.CPW(UnitXP), NUI.CPW(UnitXPMax), NUI.CPW(UnitLevel))

function XP:Initialize()
    if COMP.SLE then
        if not DB then
            DB = _G.ElvUI_SLE[1].DataBars or _G.ElvUI_SLE[1]:GetModule("DataBars")
        end
        local XPIcon = DB.Icons.XP
        self.textureMarkup = "|T" .. XPIcon .. ":12|t"
    end
    self:ScanXP()
    self:GetParent():RegisterNotifierEvent(self, "PLAYER_XP_UPDATE")
end

DBN:RegisterNotifier(XP)
