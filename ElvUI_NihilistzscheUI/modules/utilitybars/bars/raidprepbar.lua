local NUI, E = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB

local RPB = NUI.UtilityBars.RaidPrepBar
local NUB = NUI.UtilityBars
local COMP = NUI.Compatibility

local PT = NUI.Libs.PT

local UnitLevel = _G.UnitLevel
local GetItemCount = _G.GetItemCount
local CreateFrame = _G.CreateFrame
local unpack = _G.unpack
local Item = _G.Item

function RPB.CreateBar()
  return NUB:CreateBar(
    "NihilistzscheUI_RaidPrepBar",
    "raidPrepBar",
    {"TOPRIGHT", _G.NihilistzscheUI_TrackerBar, "BOTTOMRIGHT", 0, -2},
    "Raid Prep Bar"
  )
end

local function InLevelRange(min, max, inclusiveMin, inclusiveMax)
  local level = UnitLevel("player")
  if (type(max) == "boolean") then
    return level == min
  end

  if (not max) then
    if inclusiveMin then
      return level >= min
    else
      return level > min
    end
  end

  if inclusiveMin then
    if inclusiveMax then
      return level >= min and level <= max
    else
      return level >= min and level < max
    end
  end

  if inclusiveMax then
    return level > min and level <= max
  end

  return level > min and level < max
end

RPB.DataKeys = {
  {
    key = "NihilistzscheUI.RaidPrep.LegionBuffFood",
    req = {40, 50}
  },
  {
    key = "Muffin.Food.Buff",
    req = {40, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.AugmentRunes",
    req = {35, 45, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.LegionFlasks",
    req = {40, 50, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.LegionAugmentRunes",
    req = {40, 50, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.DemonHunter"
  },
  {
    key = "Muffin.Flask",
    req = {40, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.BattleForAzerothFood",
    req = {45, 50, false, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.BattleForAzerothAugmentRunes",
    req = {45, 50, false, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.BattleForAzerothFlasks",
    req = {45, 50, false, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.ShadowlandsFood",
    red = {50, 60, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.ShadowlandsOils",
    req = {50, 60, false, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.ShadowlandsAugmentRunes",
    req = {60, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.ShadowlandsFlasks",
    req = {50, 60, false, true}
  },
  {
    key = "NihilistzscheUI.RaidPrep.PermanentFlasks"
  },
  {
    key = "NihilistzscheUI.RaidPrep.FishingFood"
  }
}

function RPB.CreateButtons(bar)
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

  for _, info in pairs(RPB.DataKeys) do
    if (not info.req or InLevelRange(unpack(info.req))) then
      local db = PT:GetSetTable(info.key)
      if db then
        for k, v in pairs(db) do
          if (type(k) == "number") then
            checkAndAdd(k, v)
          end
        end
      else
        print("No db found for " .. info.key)
      end
    end
  end
end

function RPB:UpdateBar(bar)
  NUB.WipeButtons(bar)
  RPB.CreateButtons(bar)
  NUB.UpdateBar(self, bar, "ELVUIBAR26BINDBUTTON")
  if COMP.MERS then
    self:BlacklistRPItemMeraAutoButtons()
  end
end

function RPB.AddNihilistzscheUIData()
  -- luacheck: no max line length
  PT:AddData(
    "NihilistzscheUI.RaidPrep",
    "Rev: 1",
    {
      ["NihilistzscheUI.RaidPrep.AugmentRunes"] = "118630,118631,118632,128482,174906",
      ["NihilistzscheUI.RaidPrep.LegionAugmentRunes"] = "140587,153023",
      ["NihilistzscheUI.RaidPrep.LegionFlasks"] = "127847,127848,127849,127850,127858",
      ["NihilistzscheUI.RaidPrep.LegionBuffFood"] = "133565,133566,133567,133568,133569,133570,133571,133572,133573,133574,133576,133577,133578,133579,133681",
      ["NihilistzscheUI.RaidPrep.DemonHunter"] = "129192,129210",
      ["NihilistzscheUI.RaidPrep.BattleForAzerothAugmentRunes"] = "160053,174906",
      ["NihilistzscheUI.RaidPrep.BattleForAzerothFlasks"] = "152638, 152639, 152640, 152641,168651,168652,168653,168654",
      ["NihilistzscheUI.RaidPrep.BattleForAzerothFood"] = "154887, 154883, 154885, 154882, 154888, 154884, 154886,166344,168314,168313,168311,168310,168312,166804,174352,174350,174349,174348,174351",
      ["NihilistzscheUI.RaidPrep.ShadowlandsAugmentRunes"] = "181468",
      ["NihilistzscheUI.RaidPrep.ShadowlandsFlasks"] = "171276,171278",
      ["NihilistzscheUI.RaidPrep.ShadowlandsOils"] = "171285,171286",
      ["NihilistzscheUI.RaidPrep.ShadowlandsFood"] = "172040,172041,172043,172044,172045,172048,172049,172050,172051,172060,172061,172062,172063,172068,172069",
      ["NihilistzscheUI.RaidPrep.PermanentFlasks"] = "118922,147707",
      ["NihilistzscheUI.RaidPrep.FishingFood"] = "34832"
    }
  )
end

if COMP.MERS then
  function RPB:BlacklistRPItemMeraAutoButtons()
    E.db.mui = E.db.mui or {}
    E.db.mui.autoButtons = E.db.mui.autoButtons or {}
    E.db.mui.autoButtons.blackList = E.db.mui.autoButtons.blackList or {}

    local function addBlacklist(itemID)
      local item = Item:CreateFromItemID(itemID)

      if item and not item:IsItemEmpty() and not E.db.mui.autoButtons.blackList[itemID] then
        item:ContinueOnItemLoad(
          function()
            E.db.mui.autoButtons.blackList[itemID] = item:GetItemName()
          end
        )
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
        addBlacklist(k)
      end
    end

    for _, info in pairs(self.DataKeys) do
      local db = PT:GetSetTable(info.key)
      if db then
        for k, v in pairs(db) do
          if (type(k) == "number") then
            checkAndAdd(k, v)
          end
        end
      end
    end

    _G.ElvUI_MerathilisUI[1].Modules.AutoButtons:UpdateBars()
  end
end

function RPB:Initialize()
  self.AddNihilistzscheUIData()
  NUB:InjectScripts(self)

  local frame = CreateFrame("Frame", "NihilistzscheUI_RaidPrepBarController")
  frame:RegisterEvent("BAG_UPDATE")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
  NUB:RegisterEventHandler(self, frame)

  local bar = self:CreateBar()
  self.bar = bar
  self.hooks = {}

  self:UpdateBar(bar)
end

NUB:RegisterUtilityBar(RPB)
