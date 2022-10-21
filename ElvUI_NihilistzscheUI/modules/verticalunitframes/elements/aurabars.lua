local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local LSM = E.Libs.LSM
local COMP = NUI.Compatibility
local ES = NUI.EnhancedShadows
local BS = NUI.ButtonStyle

function VUF:PostUpdateBar_AuraBars(unit, statusBar, index, position, duration, expiration, debuffType, isStealable)
    local dbUnit = unit
    if not unit or unit == "vehicle" then
        dbUnit = "player"
    end
    self.db = VUF.db.units[dbUnit].aurabars
    UF.PostUpdateBar_AuraBars(self, unit, statusBar, index, position, duration, expiration, debuffType, isStealable)

    local halfBar = VUF.db.units[dbUnit].aurabars.size.halfBar
    local width = self.auraBarWidth or 225
    local height = self.auraBarHeight or 20
    statusBar:SetSize(width, height * (halfBar and .5 or 1))
    statusBar.nameText:ClearAllPoints()
    if (halfBar) then
        statusBar.nameText:SetPoint("BOTTOMLEFT", statusBar, "TOPLEFT", 2, 2)
        statusBar.timeText:ClearAllPoints()
        statusBar.timeText:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", -2, 2)
    else
        statusBar.nameText:SetPoint("LEFT", statusBar, "LEFT", 2, 0)
    end
    statusBar.nameText:SetPoint("RIGHT", statusBar.timeText, "LEFT", -4, 0)
    statusBar.icon:SetSize(height, height)
    if (halfBar) then
        statusBar.icon:ClearAllPoints()
        statusBar.icon:SetPoint("BOTTOMRIGHT", statusBar, "BOTTOMLEFT", -2, 0)
    end
end

function VUF:AuraBarsSetPosition(from, to)
    local anchor = self.initialAnchor
    local growth = (self.growth == "BELOW" and -1) or 1
    local height = self.aurabarHeight or 20
    local spacing = (E.PixelMode and -1 or 1) + (self.halfBar and (height / 2.25) or 0)

    for i = from, to do
        local button = self[i]
        if not button then
            break
        end

        button:ClearAllPoints()
        button:Point(anchor, self, anchor, 0, (i == 1 and 0) or (growth * ((i - 1) * (height + spacing))))
    end
end

function VUF:ConstructAuraBarHeader(frame)
    self:AddElement(frame, "aurabars")
    local auraBar = self:CreateFrame(frame, "aurabars")

    local halfBar = VUF.db.units[frame.unit].aurabars.size.halfBar
    auraBar.gap = (E.PixelMode and -1 or 1)
    auraBar.halfBar = halfBar
    auraBar.PreSetPosition = UF.SortAuras
    auraBar.PostCreateBar = UF.Construct_AuraBars
    auraBar.PostUpdateBar = VUF.PostUpdateBar_AuraBars
    auraBar.CustomFilter = UF.AuraFilter
    auraBar.SetPosition = VUF.AuraBarsSetPosition
    auraBar.growth = "BELOW"

    auraBar.sparkEnabled = true
    auraBar.initialAnchor = "BOTTOMLEFT"
    auraBar.type = "aurabar"
    if (frame.db) then
        frame.db.aurabar = UF.db.units[frame.unit].aurabar
    end
    return auraBar
end

function VUF:AuraBarOptions(unit)
    return self:GenerateElementOptionsTable(unit, "aurabars", 700, "Aura Bars", false, true, false, false, false)
end
