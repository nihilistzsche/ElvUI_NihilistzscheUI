local NUI = unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

function NI:mMediaTagSetup()
    self:EDB().mMediaTag = self:EDB().mMediaTag or {}
    self:EDB().mMediaTag.mClassNameplate = true
    self:EDB().mMediaTag.mTIcon = false
    self:EDB().mMediaTag.mMsg = false
    self:EDB().mMediaTag.mMythicPlusTools = self:EDB().mMediaTag.mythicPlusTools or {}
    self:EDB().mMediaTag.mMythicPlusTools.keys = true
end

NI:RegisterAddOnInstaller("ElvUI_mMediaTag", NI.mMediaTagSetup, true)
