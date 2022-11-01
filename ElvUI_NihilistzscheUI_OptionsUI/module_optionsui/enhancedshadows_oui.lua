local NUI, E, L = _G.unpack(_G.ElvUI_NihilistzscheUI)
local ES = NUI.EnhancedShadows

function ES:GenerateOptions()
    local options = {
        type = "group",
        name = "Enhanced Shadows",
        get = function(info) return self.db[info[#info]] end,
        set = function(info, value)
            self.db[info[#info]] = value
            self:UpdateShadows()
        end,
        args = {
            enabled = {
                type = "toggle",
                order = 1,
                name = L.Enable,
                desc = L["Enable the enhanced shadows."],
                set = function(info, value)
                    self.db[info[#info]] = value
                    E:StaticPopup_Show("CONFIG_RL")
                end,
            },
            shadowcolor = {
                type = "color",
                order = 2,
                name = "Shadow Color",
                hasAlpha = false,
                get = function(info)
                    local t = self.db[info[#info]]
                    return t.r, t.g, t.b, t.a
                end,
                set = function(info, r, g, b)
                    local t = {}
                    t.r, t.g, t.b = r, g, b
                    self.db[info[#info]] = t
                    self:UpdateShadows()
                end,
            },
            size = {
                order = 3,
                type = "range",
                name = L.Size,
                min = 2,
                max = 10,
                step = 1,
            },
        },
    }

    return options
end
