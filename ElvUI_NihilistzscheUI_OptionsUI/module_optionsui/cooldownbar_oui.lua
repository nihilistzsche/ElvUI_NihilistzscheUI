local NUI, E, L = _G.unpack(_G.ElvUI_NihilistzscheUI)
local CB = NUI.CooldownBar

local wipe = _G.wipe

function CB:GenerateOptions()
  local options = {
    type = "group",
    name = L.CooldownBar,
    get = function(info)
      return E.db.nihilistzscheui.cooldownBar[info[#info]]
    end,
    set = function(info, value)
      E.db.nihilistzscheui.cooldownBar[info[#info]] = value
      self:UpdateSettings()
    end,
    args = {
      header = {
        order = 1,
        type = "header",
        name = L["NihilistzscheUI CooldownBar by Nihilistzsche"]
      },
      description = {
        order = 2,
        type = "description",
        name = L["NihilistzscheUI CooldownBar provides a logarithmic cooldown display similar to SexyCooldown2\n"]
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
            desc = L["Enable the cooldown bar."]
          },
          alpha = {
            order = 12,
            type = "range",
            name = L.Alpha,
            isPercent = true,
            min = 0,
            max = 1,
            step = 0.01
          },
          autohide = {
            order = 2,
            type = "toggle",
            name = L.Autohide,
            desc = L[
              "Hide the cooldown bar when the mouse is not over it, you are not in combat, and there is nothing tracked on cooldown"
            ]
          },
          switchTime = {
            order = 3,
            type = "range",
            name = L["Switch Time"],
            min = 1,
            max = 5,
            step = 1
          },
          resetblacklist = {
            type = "execute",
            order = 2,
            name = L["Reset Blacklist"],
            desc = L["Reset the blacklist."],
            func = function()
              wipe(E.db.nihilistzscheui.cooldownBar.blacklist.spells)
              wipe(E.db.nihilistzscheui.cooldownBar.blacklist.items)
              CB:UpdateCache()
              CB:RefreshItemList()
            end
          }
        }
      }
    }
  }

  return options
end
