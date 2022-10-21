local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

NI.WoWProRankCustom = {
  ["Wyrmrest Accord"] = {
    Dirishia = 3,
    Ralaniki = 2,
    Cerishia = 2,
    Sayalia = 2
  }
}

function NI:GetWoWProRank()
  if self.WoWProRankCustom[self.currentRealm] and self.WoWProRankCustom[self.currentRealm][self.currentName] then
    return self.WoWProRankCustom[self.currentRealm][self.currentName]
  end
  return 1
end

function NI:WowProSetup()
  self:SetProfile(
    _G.WoWProData,
    {
      stepfont = self.db.font,
      notefont = self.db.font,
      trackfont = self.db.font,
      titlefont = self.db.font,
      stickytitlefont = self.db.font,
      rank = self:GetWoWProRank()
    },
    self.baseProfile
  )
end

NI:RegisterAddOnInstaller("WoWPro", NI.WowProSetup, nil, true)
