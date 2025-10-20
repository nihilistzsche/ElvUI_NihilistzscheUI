---@class NUI
local NUI = _G.unpack((select(2, ...)))

local NI = NUI.Installer
local COMP = NUI.Compatibility

function NI:AddOnSkinsSetup()
    local AS = _G.AddOnSkins[1]
    self:SetProfile(_G.AddOnSkinsDB, {
        Atlas = true,
        Auctionator = true,
        BagSync = true,
        BugSack = true,
        ["Classic Quest Log"] = true,
        EmbedBackdrop = true,
        EmbedBackdropTransparent = false,
        EmbedOoC = true,
        EmbedRightChat = true,
        EmbedSystemMessage = true,
        Guild_Roster_Manager = true,
        Immersion = true,
        LoginMsg = true,
        MinimalArchaeology = true,
        MogIt = true,
        Parchment = false,
        Pawn = true,
        RaiderIO = true,
        RareScanner = true,
        Simulationcraft = true,
        TomTom = true,
        WoWPro = true,
        tdBattlePetScript = true,
        EmbedLeft = "",
        EmbedLeftWidth = 240,
        DBMFont = self.db.font,
        DBMSkinHalf = true,
        Blizzard_AbilityButton = true,
        EmbedSystem = true,
        EmbedSystemDual = false,
        EmbedFrameLevel = 5,
        EmbedOoCDelay = 10,
        EmbedBelowTop = true,
        FontSize = 10,
        EmbedFrameStrata = "3-MEDIUM",
        EmbedMain = "Details",
        HideChatFrame = "ChatFrame3",
        EmbedIsHidden = true,
        BarrelsOEasy = true,
        SkinDebug = AS.Nihilistzsche and true or false,
        Font = self.db.font,
        StatusBarTexture = self.db.texture,
    })
end

NI:RegisterAddOnInstaller("AddOnSkins", NI.AddOnSkinsSetup)
