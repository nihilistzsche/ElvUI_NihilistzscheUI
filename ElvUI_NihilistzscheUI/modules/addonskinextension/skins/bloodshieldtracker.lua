local NUI = _G.unpack(select(2, ...))
local COMP = NUI.Compatibility
if (not COMP.AS) then
  return
end

local AS = _G.unpack(_G.AddOnSkins)
local SASX = NUI.NihilistzscheUIAddOnSkinExtension

function SASX.HideBloodShieldTracker()
  local Bars = {
    _G.BloodShieldTracker_AMSBar,
    _G.BloodShieldTracker_BloodChargeBar,
    _G.BloodShieldTracker_EstimateBar,
    _G.BloodShieldTracker_HealthBar,
    _G.BloodShieldTracker_IllumBar,
    _G.BloodShieldTracker_PurgatoryBar,
    _G.BloodShieldTracker_PWSBar,
    _G.BloodShieldTracker_ShieldBar,
    _G.BloodShieldTracker_TotalAbsorbsBar
  }

  for _, bar in pairs(Bars) do
    AS:RegisterForPetBattleHide(bar)
  end
end

SASX:RegisterSkin("BloodShieldTracker", "HideBloodShieldTracker")
