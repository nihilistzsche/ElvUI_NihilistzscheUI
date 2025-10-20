---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local NI = NUI.Installer

function NI:WowProSetup()
    local LSM = E.Libs.LSM

    local hashtable = LSM:HashTable("font")
    local fonthash = hashtable[self.db.font]
    local profile = {
        stepfont = fonthash,
        steptextsize = 12,
        notefont = fonthash,
        notetextsize = 10,
        trackfont = fonthash,
        tracktextsize = 10,
        titlefont = fonthash,
        titletextsize = 12,
        stickytitlefont = fonthash,
        sticktitletextsize = 12,
        position = { "TOP", "UIParent", "TOP", 418, -48 },
    }
    if NUI.NihilPrivate then
        local WoWProRank = {
            ["Wyrmrest Accord"] = {
                Uvarha = 3,
                Zepide = 3,
                Ralaniki = 2,
                Cerishia = 2,
                Sayalia = 2,
                Elaedarel = 2,
                Alyder = 2,
                Onaguda = 2,
                Irgrii = 2,
                Nilala = 2,
                Millop = 2,
                Linabla = 2,
                Issia = 2,
                Cherylth = 2,
            },
        }
        profile.rank = WoWProRank[self.currentRealm] and WoWProRank[self.currentRealm][self.currentName] or 1
    end

    self:SetProfile(_G.WoWProData, profile, self.baseProfile)
end

NI:RegisterAddOnInstaller("WoWPro", NI.WowProSetup, nil, nil, true)
