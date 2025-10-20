---@class NUI
local NUI = _G.unpack((select(2, ...)))
local NI = NUI.Installer

function NI:PetTrackerSetup()
    local db = _G.PetTracker_Sets
    db.switcher = false
    db.promptForfeit = false
    db.alertUpgrades = false
    db.forfeit = false
    db.capturedPets = true
    db.hideStables = false
    db.tutorial = 99
    db.journalTutorial = 99
    db.unlockActions = true
end

NI:RegisterGlobalAddOnInstaller("PetTracker", NI.PetTrackerSetup)
