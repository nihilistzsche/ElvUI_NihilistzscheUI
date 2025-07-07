---@class NUI
local NUI, E, L = _G.unpack(_G.ElvUI_NihilistzscheUI)
local BESI = NUI.BagEquipmentSetIcon
local B = E.Bags

function BESI:GenerateOptions()
    local options = {
        type = "group",
        name = L.BagEquipmentSetIcon,
        get = function(info) return self.db[info[#info]] end,
        set = function(info, value)
            self.db[info[#info]] = value
            B:UpdateAllSlots(B.BagFrame)
            B:UpdateAllSlots(B.BankFrame)
        end,
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["NihilistzscheUI BagEquipmentSetIcon by Nihilistzsche"],
            },
            description = {
                order = 2,
                type = "description",
                name = L["NihilistzscheUI BagEquipmentSetIcon shows a set icon over items in your bag belonging to a set.\n"],
            },
            general = {
                order = 3,
                type = "group",
                name = L.General,
                guiInline = true,
                args = {
                    enabled = {
                        type = "toggle",
                        order = 1,
                        name = L.Enable,
                        desc = L["Enable the set icon on bag equipment slots."],
                    },
                },
            },
        },
    }

    return options
end
