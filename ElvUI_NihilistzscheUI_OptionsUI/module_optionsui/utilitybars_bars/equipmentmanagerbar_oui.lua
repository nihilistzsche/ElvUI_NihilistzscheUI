local NUI, E, L, _, P, _ = _G.unpack(_G.ElvUI_NihilistzscheUI)
local EM = NUI.UtilityBars.EquipmentManagerBar

function EM:GenerateUtilityBarOptions()
  local options = {
    type = "group",
    name = L["Equipment Manager"],
    args = {
      header = {
        order = 1,
        type = "header",
        name = L["NihilistzscheUI Equipment Manager by Nihilistzsche, based on work by Azilroka"]
      },
      description = {
        order = 2,
        type = "description",
        name = L["NihilistzscheUI Equipment Manager provides a bar for managing your equipment sets."]
      },
      general = {
        order = 3,
        type = "group",
        name = L.General,
        guiInline = true,
        get = function(info)
          return E.db.nihilistzscheui.utilitybars.equipmentManagerBar[info[#info]]
        end,
        set = function(info, value)
          E.db.nihilistzscheui.utilitybars.equipmentManagerBar[info[#info]] = value
          self:UpdateBar(self.bar)
        end,
        args = {
          enabled = {
            type = "toggle",
            order = 1,
            name = L.Enable,
            desc = L["Enable the equipment manager bar"]
          },
          resetsettings = {
            type = "execute",
            order = 2,
            name = L["Reset Settings"],
            desc = L["Reset the settings of this addon to their defaults."],
            func = function()
              E:CopyTable(
                E.db.nihilistzscheui.utilitybars.equipmentManagerBar,
                P.nihilistzscheui.utilitybars.equipmentManagerBar
              )
              self:UpdateBar(self.bar)
            end
          },
          mouseover = {
            type = "toggle",
            order = 3,
            name = L.Mouseover,
            desc = L["Only show the equipment manager bar when you mouseover it"]
          },
          buttonsize = {
            type = "range",
            order = 4,
            name = L.Size,
            desc = L["Button Size"],
            min = 12,
            max = 40,
            step = 1
          },
          spacing = {
            type = "range",
            order = 5,
            name = L.Spacing,
            desc = L["Spacing between buttons"],
            min = 1,
            max = 10,
            step = 1
          },
          alpha = {
            type = "range",
            order = 6,
            name = L.Alpha,
            desc = L["Alpha of the bar"],
            min = 0.2,
            max = 1,
            step = .1
          }
        }
      }
    }
  }

  return options
end
