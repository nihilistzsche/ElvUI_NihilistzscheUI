local NUI, E = _G.unpack(select(2, ...))

local ENA = NUI.EnhancedNameplateAuras
local NP = E.NamePlates
local UF = E.UnitFrames
local ES = NUI.EnhancedShadows

local UnitName = _G.UnitName
local UnitClass = _G.UnitClass
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local GetSpellInfo = _G.GetSpellInfo
local hooksecurefunc = _G.hooksecurefunc

-- luacheck: no self

local function CCDebuffTextNeedsUpdate(button, db)
  local bdb = button.cc_name.lastFontInfo
  return not bdb or bdb[1] ~= db.font or bdb[2] ~= db.fontSize or bdb[3] ~= db.fontOutline
end

local function SetAndSaveCCDebuffFontInfo(button, db)
  button.cc_name:FontTemplate(E.Libs.LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)
  button.cc_name.lastFontInfo = {db.font, db.fontSize, db.fontOutline}
end

function ENA:PostUpdateAura(unit, button)
  if not string.find(unit, "nameplate") then
    return
  end
  if button then
    local spell, ccSpell
    if (button.spellID) then
      spell = E.global.nameplates.spellList[button.spellID]
      ccSpell = E.global.unitframe.aurafilters.CCDebuffs.spells[button.spellID]
    end

    -- Size
    local width = 18
    local height = 18

    if spell and spell.width then
      width = spell.width
    elseif E.global.nameplates.spellListDefault.width then
      width = E.global.nameplates.spellListDefault.width
    elseif ccSpell and ccSpell ~= "" then
      width = 28
    end

    if spell and spell.height then
      height = spell.height
    elseif E.global.nameplates.spellListDefault.height then
      height = E.global.nameplates.spellListDefault.height
    elseif ccSpell and ccSpell ~= "" then
      height = 28
    end

    if width > height then
      local aspect = height / width
      button.icon:SetTexCoord(0.07, 0.93, (0.5 - (aspect / 2)) + 0.07, (0.5 + (aspect / 2)) - 0.07)
    elseif height > width then
      local aspect = width / height
      button.icon:SetTexCoord((0.5 - (aspect / 2)) + 0.07, (0.5 + (aspect / 2)) - 0.07, 0.07, 0.93)
    else
      button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    end

    button:SetWidth(width)
    button:SetHeight(height)

    button.size = {width = width, height = height}
    -- Stacks
    local stackSize = 7

    if spell and spell.stackSize then
      stackSize = spell.stackSize
    elseif E.global.nameplates.spellListDefault.stackSize then
      stackSize = E.global.nameplates.spellListDefault.stackSize
    end

    button.count:FontTemplate(nil, stackSize, "OUTLINE")

    if ENA.db.ccDebuffCasterInfo.enable and ccSpell and ccSpell ~= "" and button.caster then
      if (CCDebuffTextNeedsUpdate(button, ENA.db.ccDebuffCasterInfo)) then
        SetAndSaveCCDebuffFontInfo(button, ENA.db.ccDebuffCasterInfo)
      end
      local name = UnitName(button.caster)
      local class = select(2, UnitClass(button.caster))
      local color = ENA.db.ccDebuffCasterInfo.textColor
      if class and ENA.db.ccDebuffCasterInfo.classColor then
        color = class == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[class]
      end
      button.cc_name:SetText(name)
      button.cc_name:SetTextColor(color.r, color.g, color.b)
    elseif button.cc_name then
      button.cc_name:SetText("")
    end

    if ES and not button.shadow then
      button:CreateShadow()
      ES:RegisterFrameShadows(button)
    end
  end
end

function ENA:Construct_Auras(nameplate)
  nameplate.Buffs_.SetPosition = ENA.SetPosition
  nameplate.Debuffs_.SetPosition = ENA.SetPosition
end

--Credits: Merathilis
function ENA:Construct_AuraIcon(button)
  -- Creates an own font element for caster name
  if not button.cc_name then
    button.cc_name = button:CreateFontString("OVERLAY")
    SetAndSaveCCDebuffFontInfo(button, ENA.db.ccDebuffCasterInfo)
    button.cc_name:Point("BOTTOM", button, "TOP")
    button.cc_name:SetJustifyH("CENTER")
  end
end

function ENA:SortAuras(element)
  local function sortAuras(buttonA, buttonB)
    if (buttonA:IsShown() ~= buttonB:IsShown()) then
      return buttonA:IsShown()
    end

    if (not buttonA.size and not buttonB.size) then
      return true
    end

    if (not buttonA.size ~= not buttonB.size) then
      return not buttonB.size
    end

    local aWidth = buttonA.size.width
    local aHeight = buttonA.size.height

    local bWidth = buttonB.size.width
    local bHeight = buttonB.size.height

    local aCalc = (aWidth + aHeight) * (aWidth / aHeight)
    local bCalc = (bWidth + bHeight) * (bWidth / bHeight)

    return aCalc > bCalc
  end
  table.sort(element, sortAuras)
end

function ENA.SetPosition(element, _, to)
  local from = 1
  if not element[from] then
    return
  end

  if not element.forceShow and not element.forceCreate then
    ENA.SortAuras(ENA, element)
  end

  local anchor = element.initialAnchor or "BOTTOMLEFT"
  local growthx = (element["growth-x"] == "LEFT" and -1) or 1
  local spacingx = (element["spacing-x"] or element.spacing or 0)
  local eheight = element[from].db and element[from].db.height or 18

  local function GetAnchorPoint(index)
    local a = 0
    for i = index - 1, from, -1 do
      a = a + spacingx + element[i].size.width
    end
    return a * growthx
  end

  for i = from, to do
    local button = element[i]
    if (not button) then
      break
    end
    eheight = math.max(eheight, element[i].size and (element[i].size.height) or 0)
    button:ClearAllPoints()
    button:SetPoint(anchor, element, anchor, GetAnchorPoint(i), 0)
  end
  element:SetHeight(eheight)
end

function ENA:UpdateSpellList()
  local filters = E.global.nameplates.spellList

  for key, value in pairs(filters) do
    if (not tonumber(key) or value.version ~= 2) then
      local spellID = select(7, GetSpellInfo(key))
      if (spellID) then
        filters[spellID] = value
        filters[spellID].version = 2
      end
      filters[key] = nil
    end
  end
end

function ENA:PLAYER_ENTERING_WORLD()
  self:UpdateSpellList()
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function ENA:Initialize()
  NUI:RegisterDB(self, "enhancednameplateauras")
  hooksecurefunc(NP, "Construct_Auras", ENA.Construct_Auras)
  hooksecurefunc(UF, "PostUpdateAura", ENA.PostUpdateAura)
  hooksecurefunc(NP, "Construct_AuraIcon", ENA.Construct_AuraIcon)
  self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

NUI:RegisterModule(ENA:GetName())
