local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB

local PRB = NUI.UtilityBars.PortalBar
local NUB = NUI.UtilityBars
local COMP = NUI.Compatibility

local PT = NUI.Libs.PT

local GetItemCount = _G.GetItemCount
local IsSpellKnown = _G.IsSpellKnown
local tinsert = _G.tinsert
local CreateFrame = _G.CreateFrame
local Item = _G.Item

function PRB.CreateBar()
    local bar = NUB:CreateBar(
        "NihilistzscheUI_PortalBar",
        "portalBar",
        { "BOTTOMRIGHT", _G.NihilistzscheUI_ProfessionBar, "TOPRIGHT", 0, 2 },
        "Portal Bar"
    )
    if COMP.SLE then NUB.RegisterUpdateButtonHook(bar, function(button) PRB.UpdateButtonHook(button) end) end
    return bar
end

if COMP.SLE then
    local EM = _G["ElvUI_SLE"][1].EquipManager or _G["ElvUI_SLE"][1]:GetModule("EquipManager")

    function PRB.PLAYER_ENTERING_WORLD()
        EM.lock = false
        PRB:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end

    function PRB.UpdateButtonHook(button)
        if not button.__OnClick_Hooked then
            button:HookScript("OnClick", function(self)
                local t = self:GetAttribute("type")
                if t == "item" then
                    EM.lock = true
                    PRB:RegisterEvent("PLAYER_ENTERING_WORLD")
                end
            end)
            button.__OnClick_Hooked = true
        end
    end
end

function PRB.CreateButtons(bar)
    local j = 1

    local function addItemButton(itemID, row)
        local count = GetItemCount(itemID)

        if count > 0 then
            local button = bar.buttons[j]
            if not button then
                button = NUB.CreateButton(bar)
                bar.buttons[j] = button
            end

            NUB.UpdateButtonAsItem(bar, button, itemID)
            button.row = row

            j = j + 1
        end
    end

    local function addSpellButton(spellID, row)
        if IsSpellKnown(spellID) then
            local button = bar.buttons[j]
            if not button then
                button = NUB.CreateButton(bar)
                bar.buttons[j] = button
            end

            NUB.UpdateButtonAsSpell(bar, button, spellID)
            button.row = row

            j = j + 1
        end
    end

    local function addButton(id, row)
        if id < 0 then
            addSpellButton(math.abs(id), row)
        else
            addItemButton(id, row)
        end
    end

    local checkAndAdd

    checkAndAdd = function(k, v, row)
        if type(v) == "table" then
            for _k, _v in pairs(v) do
                if type(_k) == "number" then checkAndAdd(_k, _v, row) end
            end
        else
            addButton(k, row)
        end
    end

    local function addDbData(key, row)
        local db = PT:GetSetTable(key)
        for k, v in pairs(db) do
            if type(k) == "number" then checkAndAdd(k, v, row) end
        end
    end

    for row, key in pairs(bar.keys) do
        if type(key) == "table" then
            for _, _k in ipairs(key) do
                addDbData(_k, row)
            end
        else
            addDbData(key, row)
        end
    end
end

function PRB.UpdateBarKeys(bar)
    bar.keys = {
        "NihilistzscheUI.TeleportSpells.Teleports",
        "NihilistzscheUI.TeleportSpells.Portals",
        { "Misc.Hearth", "NihilistzscheUI.Misc.Hearth" },
    }

    if bar.db.challengeModePandaria then
        tinsert(bar.keys, 3, "NihilistzscheUI.TeleportSpells.ChallengeMode.Pandaria")
    end

    if bar.db.challengeModeDraenor then tinsert(bar.keys, 4, "NihilistzscheUI.TeleportSpells.ChallengeMode.Draenor") end
end

function PRB:UpdateBar(bar)
    PRB.UpdateBarKeys(bar)
    NUB.WipeButtons(bar)
    PRB.CreateButtons(bar)

    NUB.UpdateBarMultRow(self, bar, "ELVUIBAR24BINDBUTTON")
    if COMP.MERS then self:BlacklistPortalItemMeraAutoButtons(bar) end
end

function PRB.AddNihilsitzscheUIData()
    -- luacheck: no max line length
    PT:AddData("NihilistzscheUI.TeleportSpells", "Rev: 1", {
        ["NihilistzscheUI.TeleportSpells.Teleports"] = "-556,-53140,-120145,-3565,-32271,-3562,-3567,-33690,-35715,-32272,-49358,-176248,-3561,-49359,-3566,-88342,-88344,-3563,-132621,-132627,-176242,-18960,-50977,-126892,-193753,-193759, -224768, -281403, -281404, -312372,-344587",
        ["NihilistzscheUI.TeleportSpells.Portals"] = "-53142, -120146, -11419, -32266, -11416, -11417, -33691, -35717, -32267, -49361, -176246, -10059, -49360, -11420, -88345, -88346, -11418, -132620, -132626, -176244, -224871, -281400, -281402,-344597",
        ["NihilistzscheUI.TeleportSpells.ChallengeMode.Pandaria"] = "-131228, -131204, -131222, -131225, -131206, -131205, -131229, -131231, -131232",
        ["NihilistzscheUI.TeleportSpells.ChallengeMode.Draenor"] = "-169764, -169762, -169766, -169763, -169769, -169765, -169767, -169769",
    })
    local nihilistzscheHearth = "163073,180817"
    if E.myrace == "GNOME" then nihilistzscheHearth = nihilistzscheHearth .. ", 168862" end
    PT:AddData("NihilistzscheUI.Misc", "Rev: 1", {
        ["NihilistzscheUI.Misc.Hearth"] = nihilistzscheHearth,
    })
end

if COMP.MERS then
    function PRB:BlacklistPortalItemMeraAutoButtons()
        E.db.mui = E.db.mui or {}
        E.db.mui.autoButtons = E.db.mui.autoButtons or {}
        E.db.mui.autoButtons.blackList = E.db.mui.autoButtons.blackList or {}

        local function addBlacklist(itemID)
            local item = Item:CreateFromItemID(itemID)

            if item and not item:IsItemEmpty() and not E.db.mui.autoButtons.blackList[itemID] then
                item:ContinueOnItemLoad(function() E.db.mui.autoButtons.blackList[itemID] = item:GetItemName() end)
            end
        end

        local checkAndAdd

        checkAndAdd = function(k, v)
            if type(v) == "table" then
                for _k, _v in pairs(v) do
                    if type(_k) == "number" then checkAndAdd(_k, _v) end
                end
            else
                addBlacklist(k)
            end
        end

        local function addDbData(key)
            local db = PT:GetSetTable(key)
            for k, v in pairs(db) do
                if type(k) == "number" then checkAndAdd(k, v) end
            end
        end

        for _, key in pairs(self.bar.keys) do
            if type(key) == "table" then
                for _, _k in ipairs(key) do
                    addDbData(_k)
                end
            else
                addDbData(key)
            end
        end

        _G.ElvUI_MerathilisUI[1].Modules.AutoButtons:UpdateBars()
    end
end

function PRB:Initialize()
    self.AddNihilsitzscheUIData()
    NUB:InjectScripts(self)

    local frame = CreateFrame("Frame", "NihilistzscheUI_PortalBarController")
    frame:RegisterEvent("SPELLS_CHANGED")
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    frame:RegisterEvent("SPELL_UPDATE_ICON")
    NUB:RegisterEventHandler(self, frame)

    local bar = self.CreateBar()
    self.bar = bar
    self.hooks = {}

    self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(PRB)
