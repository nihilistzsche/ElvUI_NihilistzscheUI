local NUI, E = _G.unpack(select(2, ...))

local AFK = E.AFK
local NM = NUI.Misc
local COMP = NUI.Compatibility

local GetScreenWidth = _G.GetScreenWidth
local hooksecurefunc = _G.hooksecurefunc

function NM.HookAFK()
  local SS = AFK.AFKMode
  if (COMP.BUI) then
    SS.bottom.nuilogo = SS.bottom:CreateTexture(nil, "OVERLAY")
    SS.bottom.nuilogo:SetTexture(
      "Interface\\AddOns\\ElvUI_NihilistzscheUI\\media\\textures\\elvui_nihilistzscheui_logo.tga"
    )
    SS.bottom.nuilogo:SetPoint("CENTER", SS.bottom, "TOP", -(GetScreenWidth() / 10), 0)
    SS.bottom.nuilogo:SetSize(256, 128)
    SS.bottom.nuilogo:Show()
  elseif SS.bottom.logo then
    SS.bottom.logo:SetTexture(
      "Interface\\AddOns\\ElvUI_NihilistzscheUI\\media\\textures\\elvui_nihilistzscheui_logo.tga"
    )
    SS.bottom.logo:SetPoint("CENTER", SS.bottom, "TOP", -(GetScreenWidth() / 10), 0)
    SS.bottom.logo:Show()
  end
end

if (COMP.SLE and NUI.Private) then
  local SLE = _G.ElvUI_SLE[1]
  local SSS = SLE.Screensaver or SLE:GetModule("Screensaver")

  local function Setup()
    if (not E.private.sle.module.screensaver) then
      return
    end
    local SS = AFK.AFKMode
    SS.ClassCrest = SS.Top:CreateTexture(nil, "OVERLAY")
    SS.ClassCrest:Size(SSS.db.crest.size, SSS.db.crest.size)
    SS.ClassCrest:SetPoint("LEFT", SS.RaceCrest, "RIGHT", 10, 0)
    SS.ClassCrest:SetTexture(NUI.Private:GetClassTexture())
    SS.ClassCrest:SetTexCoord(0.25, 0.75, 0, 1)
  end

  hooksecurefunc(SSS, "Setup", Setup)
end
