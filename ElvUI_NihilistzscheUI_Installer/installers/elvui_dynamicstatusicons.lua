local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer
local COMP = NUI.Compatibility

local installTier = {
    ["DEATHKNIGHT"] = {
        ["name"] = "Death Knight",
        ["tier"] = 7,
    },
    ["DEMONHUNTER"] = {
        ["name"] = "Demon Hunter",
        ["tier"] = 19,
    },
    ["DRUID"] = {
        ["name"] = "Druid",
        ["tier"] = 2,
    },
    ["HUNTER"] = {
        ["name"] = "Hunter",
        ["tier"] = 2,
    },
    ["MAGE"] = {
        ["name"] = "Mage",
        ["tier"] = 2,
    },
    ["MONK"] = {
        ["name"] = "Monk",
        ["tier"] = 14,
    },
    ["PALADIN"] = {
        ["name"] = "Paladin",
        ["tier"] = 2,
    },
    ["PRIEST"] = {
        ["name"] = "Priest",
        ["tier"] = 2,
    },
    ["ROGUE"] = {
        ["name"] = "Rogue",
        ["tier"] = 2,
    },
    ["SHAMAN"] = {
        ["name"] = "Shaman",
        ["tier"] = 2,
    },
    ["WARLOCK"] = {
        ["name"] = "Warlock",
        ["tier"] = 2,
    },
    ["WARRIOR"] = {
        ["name"] = "Warrior",
        ["tier"] = 2,
    },
    ["EVOKER"] = "SoD - Pepe - Cloth (LFR)",
}

function NI:DynamicStatusIconsSetup()
    local installTemplate = installTier[self.currentClass]
    if type(installTemplate) == "string" then
        self:EDB().unitframe.units.player.DynamicStatusIcons = {
            ["iconpack"] = installTemplate,
            ["color"] = self:Color(),
        }
    else
        self:EDB().unitframe.units.player.DynamicStatusIcons = {
            ["iconpack"] = string.format("Classes - Pepe - %s (Tier %d)", installTemplate.name, installTemplate.tier),
            ["color"] = self:Color(),
        }
    end
    self:EDB().unitframe.units.target.DynamicStatusIcons = {
        ["iconpack"] = "Battle Pets - Murloc - KnightCaptain Murky",
        ["color"] = self:IColor(),
    }
end

NI:RegisterAddOnInstaller("ElvUI_DynamicStatusIcons", NI.DynamicStatusIconsSetup, true)
