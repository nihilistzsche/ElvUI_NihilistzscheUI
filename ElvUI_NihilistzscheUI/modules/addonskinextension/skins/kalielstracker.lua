local NUI = _G.unpack(select(2, ...))
local COMP = NUI.Compatibility
if (not COMP.AS) then
  return
end

local SASX = NUI.NihilistzscheUIAddOnSkinExtension
local BS = NUI.ButtonStyle

function SASX.SkinKalielsTracker()
  if BS and _G["!KalielsTrackerActiveButton"] then
    BS:StyleButton(_G["!KalielsTrackerActiveButton"])
  end
  _G["!KalielsTrackerFrame"]:CreateBackdrop("Transparent")
  if COMP.BUI then
    _G["!KalielsTrackerFrame"]:BuiStyle("Outside")
  end
end

SASX:RegisterSkin("!KalielsTracker", "SkinKalielsTracker")
