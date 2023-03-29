local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

NI.WoWProRankCustom = {
    ["Wyrmrest Accord"] = {
        Dirishia = 3,
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

function NI:GetWoWProRank()
    if self.WoWProRankCustom[self.currentRealm] and self.WoWProRankCustom[self.currentRealm][self.currentName] then
        return self.WoWProRankCustom[self.currentRealm][self.currentName]
    end
    return 1
end

function NI:WowProSetup()
    local profile = {
        stepfont = self.db.font,
        notefont = self.db.font,
        trackfont = self.db.font,
        titlefont = self.db.font,
        stickytitlefont = self.db.font,
    }
    if NUI.Private then profile.rank = self:GetWoWProRank() end
    self:SetProfile(_G.WoWProData, profile, self.baseProfile)
end

NI:RegisterAddOnInstaller("WoWPro", NI.WowProSetup, nil, true)
