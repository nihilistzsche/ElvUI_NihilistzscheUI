local NUI = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

function NI:Ls_ToastsSetup()
    self:SetProfile(_G.LS_TOASTS_GLOBAL_CONFIG, {
        font = {
            name = self.db.font,
        },
        skin = NUI.Private and "MerathilisUI" or "elv-no-artwork",
        anchors = {
            {
                point = {
                    rP = "TOP",
                    p = "TOP",
                    y = -300,
                    x = 0,
                },
            },
        },
    })
end

NI:RegisterAddOnInstaller("Ls_Toasts", NI.Ls_ToastsSetup)
