local NUI, E = _G.unpack((select(2, ...)))

local DBN = NUI.DataBarNotifier
local COMP = NUI.Compatibility

DBN.colors.azerite = "|cffe6cc80"

local AZ = DBN:NewNotifier(
    "Azerite",
    "Azerite XP",
    "axp",
    DBN.colors.azerite,
    NUI.UnitAzeriteXP,
    NUI.UnitAzeriteXPMax,
    NUI.UnitAzeriteLevel
)

function AZ:Initialize()
    if COMP.SLE then -- Only checkign SLE here because the rest rely on it
        self.textureMarkup = "|TInterface/ICONS/INV_GlowingAzeriteSpire.blp:12:12:0:0:64:64:4:60:4:60|t"
    end
    self:ScanXP()
    self:GetParent():RegisterNotifierEvent(self, "AZERITE_ITEM_EXPERIENCE_CHANGED")
end

DBN:RegisterNotifier(AZ)
