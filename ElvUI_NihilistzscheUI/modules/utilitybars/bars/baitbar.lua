local NUI, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
local BB = NUI.UtilityBars.BaitBar
local NUB = NUI.UtilityBars
local FL = NUI.Libs.FL

local PT = NUI.Libs.PT

local GetItemCount = _G.GetItemCount
local RegisterStateDriver = _G.RegisterStateDriver
local CreateFrame = _G.CreateFrame

function BB.AddBaits()
    -- luacheck: no max line length
    PT:AddData(
        "NihilistzscheUI.Baits",
        "Rev: 1",
        {
            ["NihilistzscheUI.Baits.Draenor"] = "110293, 110291, 110289, 110290, 110292, 110274, 110294, 128229",
            ["NihilistzscheUI.Baits.BrokenIsles"] = "133701, 133702, 133703, 133704, 133705, 133706, 133707, 133708, 133709, 133710, 133711, 133712, 133713, 133714, 133715, 133716, 133717, 133719, 133720, 133721, 133722, 133723, 133724, 133795, 139175",
            ["NihilistzscheUI.Baits.Shadowlands"] = "173038,173039,173040,173041,173042,173043"
        }
    )
end

function BB:CreateBar()
    local bar =
        NUB:CreateBar("NihilistzscheUI_BaitBar", "baitBar", {"CENTER", E.UIParent, "CENTER", 0, -280}, "Bait Bar")
    NUB.RegisterUpdateButtonHook(
        bar,
        function(button, ...)
            self.UpdateButtonHook(button, ...)
        end
    )

    return bar
end

function BB.UpdateButtonHook(button)
    button.texture:SetDesaturated(GetItemCount(button.data) == 0)
end

local DRAENOR_MAP_ID = 572
local BROKEN_ISLES_MAP_ID = 619
local SHADOWLANDS_MAP_ID = 1550

function BB.IsInDraenor()
    return E.MapInfo.continentMapID == DRAENOR_MAP_ID
end

function BB.IsInBrokenIsles()
    return E.MapInfo.continentMapID == BROKEN_ISLES_MAP_ID
end

function BB.IsInShadowlands()
    return E.MapInfo.continentMapID == SHADOWLANDS_MAP_ID
end

function BB:UpdateBar(bar)
    local inBaitZone = false
    local key
    if (self.IsInDraenor()) then
        key = "NihilistzscheUI.Baits.Draenor"
        inBaitZone = true
    elseif (self.IsInBrokenIsles()) then
        key = "NihilistzscheUI.Baits.BrokenIsles"
        inBaitZone = true
    elseif (self.IsInShadowlands()) then
        key = "NihilistzscheUI.Baits.Shadowlands"
        inBaitZone = true
    end

    NUB.WipeButtons(bar)

    local j = 1

    local function addButton(itemID)
        local count = GetItemCount(itemID)

        if (count > 0) then
            local button = bar.buttons[j]
            if (not button) then
                button = NUB.CreateButton(bar)
                bar.buttons[j] = button
            end

            NUB.UpdateButtonAsItem(bar, button, itemID)

            j = j + 1
        end
    end

    local checkAndAdd

    checkAndAdd = function(k, v)
        if (type(v) == "table") then
            for _k, _v in pairs(v) do
                if (type(_k) == "number") then
                    checkAndAdd(_k, _v)
                end
            end
        else
            addButton(k)
        end
    end

    if (inBaitZone) then
        local db = PT:GetSetTable(key)
        for k, v in pairs(db) do
            if (type(k) == "number") then
                checkAndAdd(k, v)
            end
        end
    end

    NUB.UpdateBar(self, bar, "ELVUIBAR23BINDBUTTON")
    if (not FL:IsFishingPole() or not inBaitZone) then
        RegisterStateDriver(bar, "visibility", "hide")
    end
end

function BB:Initialize()
    self.AddBaits()
    local frame = CreateFrame("Frame", "NihilistzscheUI_BaitBarController")
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    NUB:RegisterEventHandler(self, frame)

    NUB:InjectScripts(self)

    local bar = self:CreateBar()
    self.bar = bar
    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(BB)
