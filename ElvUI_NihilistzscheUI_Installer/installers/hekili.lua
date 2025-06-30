---@class NUI
local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

function NI:HekiliSetup()
    local setupTbl = {
        ["rel"] = "CENTER",
        ["primaryWidth"] = 40,
        ["border"] = {
            ["coloring"] = "class",
        },
        ["numIcons"] = 5,
        ["zoom"] = 0,
        ["elvuiCooldown"] = true,
        ["keybindings"] = {
            ["font"] = self.db.font,
        },
        ["captions"] = {
            ["font"] = self.db.font,
        },
        ["queue"] = {
            ["direction"] = "TOP",
            ["width"] = 30,
            ["elvuiCooldown"] = true,
            ["anchor"] = "TOP",
            ["offsetY"] = 4,
            ["height"] = 30,
        },
        ["y"] = -75.0000228881836,
        ["x"] = -244.4443664550781,
        ["primaryHeight"] = 40,
        ["targets"] = {
            ["font"] = self.db.font,
        },
        ["flash"] = {
            ["enabled"] = true,
            ["color"] = self:IColor(true),
        },
        ["visibility"] = {
            ["advanced"] = true,
            ["pve"] = {
                ["hideMounted"] = true,
                ["always"] = 0,
            },
            ["pvp"] = {
                ["always"] = 0,
            },
        },
    }
    local otherSetupTbl = {
        ["elvuiCooldown"] = true,
        ["keybindings"] = {
            ["font"] = self.db.font,
        },
        ["captions"] = {
            ["font"] = self.db.font,
        },
        ["targets"] = {
            ["font"] = self.db.font,
        },
        ["flash"] = {
            ["enabled"] = true,
            ["color"] = self:IColor(true),
        },
        ["enabled"] = true,
    }
    self:SetProfile(_G.HekiliDB, {
        ["toggles"] = {
            ["potions"] = {
                ["value"] = true,
            },
            ["cooldowns"] = {
                ["value"] = true,
                ["override"] = true,
            },
            ["defensives"] = {
                ["value"] = true,
            },
            ["interrupts"] = {
                ["value"] = true,
            },
        },
        ["minimapIcon"] = true,
        ["notifications"] = {
            ["enabled"] = true,
            ["fontSize"] = 20,
            ["color"] = {
                1, -- [1]
                1, -- [2]
                1, -- [3]
                1, -- [4]
            },
            ["fontStyle"] = "OUTLINE",
            ["width"] = 360,
            ["y"] = 0,
            ["x"] = 0,
            ["height"] = 40,
            ["font"] = self.db.font,
        },
        ["displays"] = {
            ["Primary"] = E:CopyTable({}, setupTbl),
            ["AOE"] = E:CopyTable({}, setupTbl),
            ["Interrupts"] = E:CopyTable({}, otherSetupTbl),
            ["Cooldowns"] = E:CopyTable({}, otherSetupTbl),
            ["Defensives"] = E:CopyTable({}, otherSetupTbl),
        },
    })
end

NI:RegisterAddOnInstaller("Hekili", NI.HekiliSetup)
