local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local ST = NUI.SetTransfer

if not ST then return end

function ST:GenerateOptions()
    local options = {
        type = "group",
        name = "Set Transfer",
        get = function(info) return E.db.nihilistzscheui.settransfer[info[#info]] end,
        set = function(info, value) E.db.nihilistzscheui.settransfer[info[#info]] = value end,
        args = {
            header = {
                order = 1,
                type = "header",
                name = "Set Transfer",
            },
            description = {
                order = 2,
                type = "description",
                name = "Set Transfer adds the ability to deposit or withdraw sets from the bank.",
            },
            enabled = {
                order = 3,
                type = "toggle",
                name = "Enable",
                desc = "Enable the set transfer button on the bank.",
            },
            notify = {
                order = 4,
                type = "toggle",
                name = "Notify",
                desc = "Print when an item is moved.",
            },
        },
    }
    return options
end
