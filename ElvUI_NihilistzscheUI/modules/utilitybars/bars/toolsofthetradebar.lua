local NUI, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
local TOTTB = NUI.UtilityBars.ToolsOfTheTradeBar
local NUB = NUI.UtilityBars

local PT = NUI.Libs.PT

local GetItemCount = _G.GetItemCount
local RegisterStateDriver = _G.RegisterStateDriver
local CreateFrame = _G.CreateFrame

function TOTTB.AddTools()
    -- luacheck: no max line length
    PT:AddData("NihilistzscheUI.ToolsOfTheTrade", "Rev: 1", {
        ["NihilistzscheUI.ToolsOfTheTrade"] = "156631,152839,164766,153670,153716,154170,164733,164740",
    })
end

function TOTTB.CreateBar()
    local bar = NUB:CreateBar(
        "NihilistzscheUI_ToolsOfTheTradeBar",
        "toolsOfTheTradeBar",
        { "CENTER", E.UIParent, "CENTER", 0, -280 },
        "Tools of the Trade Bar"
    )

    return bar
end

local availableZones = {
    [875] = true, -- Zandalar, (Continent)
    [876] = true, -- Kul Tiras (Continent)
    [1355] = true, -- Nazjatar (Map)
}

function TOTTB.CanUseToolOfTheTrade()
    local continentMapID = E.MapInfo.continentMapID
    local mapID = E.MapInfo.mapID
    return availableZones[continentMapID] or availableZones[mapID]
end

function TOTTB:UpdateBar(bar)
    local inToolZone = self.CanUseToolOfTheTrade()

    NUB.WipeButtons(bar)

    local j = 1

    local function addButton(itemID)
        local count = GetItemCount(itemID)

        if count > 0 then
            local button = bar.buttons[j]
            if not button then
                button = NUB.CreateButton(bar)
                bar.buttons[j] = button
            end

            NUB.UpdateButtonAsItem(bar, button, itemID)

            j = j + 1
        end
    end

    local checkAndAdd

    checkAndAdd = function(k, v)
        if type(v) == "table" then
            for _k, _v in pairs(v) do
                if type(_k) == "number" then checkAndAdd(_k, _v) end
            end
        else
            addButton(k)
        end
    end

    if inToolZone then
        local db = PT:GetSetTable("NihilistzscheUI.ToolsOfTheTrade")
        for k, v in pairs(db) do
            if type(k) == "number" then checkAndAdd(k, v) end
        end
    end

    NUB.UpdateBar(self, bar, "ELVUIBAR32BINDBUTTON")
    if not inToolZone then RegisterStateDriver(bar, "visibility", "hide") end
end

function TOTTB:Initialize()
    self.AddTools()
    local frame = CreateFrame("Frame", "NihilistzscheUI_ToolsOfTheTradeController")
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    NUB:RegisterEventHandler(self, frame)

    NUB:InjectScripts(self)

    local bar = self.CreateBar()
    bar.doNotHideInCombat = true
    self.bar = bar
    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(TOTTB)
