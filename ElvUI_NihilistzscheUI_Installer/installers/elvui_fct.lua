local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

local tinsert = _G.tinsert
local strmatch = _G.strmatch
local GetAddOnMetadata = _G.GetAddOnMetadata
local tContains = _G.tContains

function NI:ElvUIFCTSetup()
  local db = {}
  local ndb = {
    textShake = true,
    critShake = true,
    isTarget = false,
    font = self.db.font
  }
  local allNameplateFrames = {"Player", "FriendlyPlayer", "FriendlyNPC", "EnemyNPC", "EnemyPlayer"}
  local enabledNameplateFrames = {"EnemyNPC", "EnemyPlayer"}
  if self.currentRole == "Healer" then
    tinsert(enabledNameplateFrames, "FriendlyPlayer")
    tinsert(enabledNameplateFrames, "FriendlyNPC")
  end
  db.nameplates = {}
  db.nameplates.frames = {}
  for _, frame in ipairs(allNameplateFrames) do
    db.nameplates.frames[frame] = {}
    E:CopyTable(db.nameplates.frames[frame], ndb)
    if (strmatch(frame, "Friendly") or frame == "Player") then
      db.nameplates.frames[frame].showHots = true
    else
      db.nameplates.frames[frame].showDots = true
    end
    db.nameplates.frames[frame].enable = tContains(enabledNameplateFrames, frame)
  end
  local unitFrames = {
    "Player",
    "Target",
    "TargetTarget",
    "TargetTargetTarget",
    "Focus",
    "FocusTarget",
    "Pet",
    "PetTarget"
  }
  local udb = {
    enable = true,
    showName = true,
    showIcon = true,
    textShake = true,
    critShake = true,
    font = self.db.font,
    iconX = -5,
    spellY = 2
  }
  db.unitframes = {}
  db.unitframes.frames = {}
  for _, frame in ipairs(unitFrames) do
    db.unitframes.frames[frame] = {}
    E:CopyTable(db.unitframes.frames[frame], udb)
    if frame == "Player" or frame == "Pet" then
      db.unitframes.frames[frame].showHots = true
    else
      db.unitframes.frames[frame].showDots = true
    end
  end
  local groupUnitFrames = {"Arena", "Boss", "Party", "Raid", "Raid40", "RaidPet", "Assist", "Tank"}
  local gudb = {
    enable = true,
    showName = true,
    showIcon = true,
    font = self.db.font,
    iconX = -5,
    spellY = 2
  }
  for _, frame in ipairs(groupUnitFrames) do
    db.unitframes.frames[frame] = {}
    E:CopyTable(db.unitframes.frames[frame], gudb)
    if
      frame == "Party" or frame == "Raid" or frame == "Raid40" or frame == "RaidPet" or frame == "Assist" or
        frame == "Tank"
     then
      db.unitframes.frames[frame].showHots = true
    else
      db.unitframes.frames[frame].showDots = true
    end
  end
  if GetAddOnMetadata("ElvUI_FCT", "X-NZEdit") then
    self:EDB().elvui_fct = db
  else
    E:CopyTable(_G.ElvFCT, db)
  end
end

if GetAddOnMetadata("ElvUI_FCT", "X-NZEdit") then
  NI:RegisterAddOnInstaller("ElvUI_FCT", NI.ElvUIFCTSetup, true)
else
  NI:RegisterGlobalAddOnInstaller("ElvUI_FCT", NI.ElvUIFCTSetup)
end
