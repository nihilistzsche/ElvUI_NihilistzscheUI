local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local RPB = NUI.UtilityBars.RaidPrepBar

function RPB:GenerateUtilityBarOptions()
  local options = {
    type = "group",
    name = L["Raid Prep Bar"],
    args = {
      header = {
        order = 1,
        type = "header",
        name = L["NihilistzscheUI RaidPrepBar by Nihilistzsche, based on work by Azilroka"]
      },
      description = {
        order = 2,
        type = "description",
        name = L["NihilistzscheUI RaidPrepBar provides a bar for your flasks and food."]
      },
      general = {
        order = 3,
        type = "group",
        name = "General",
        guiInline = true,
        get = function(info)
          return E.db.nihilistzscheui.utilitybars.raidPrepBar[info[#info]]
        end,
        set = function(info, value)
          E.db.nihilistzscheui.utilitybars.raidPrepBar[info[#info]] = value
          self:UpdateBar(self.bar)
        end,
        args = {
          enabled = {
            type = "toggle",
            order = 1,
            name = L.Enable,
            desc = L["Enable the raid prep bar"]
          },
          resetsettings = {
            type = "execute",
            order = 2,
            name = L["Reset Settings"],
            desc = L["Reset the settings of this addon to their defaults."],
            func = function()
              E:CopyTable(E.db.nihilistzscheui.utilitybars.raidPrepBar, P.nihilistzscheui.utilitybars.raidPrepBar)
              self:UpdateBar(self.bar)
            end
          },
          mouseover = {
            type = "toggle",
            order = 3,
            name = L.Mouseover,
            desc = L["Only show the raid prep bar when you mouseover it"]
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
          },
          buttonsPerRow = {
            type = "range",
            order = 7,
            name = L["Buttons Per Row"],
            desc = L["Number of buttons on each row"],
            min = 1,
            max = 11,
            step = 1
          }
        }
      }
    }
  }

  return options
end
