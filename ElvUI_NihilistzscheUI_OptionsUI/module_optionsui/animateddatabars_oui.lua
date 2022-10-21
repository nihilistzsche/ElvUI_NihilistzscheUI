local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local ADB = NUI.AnimatedDataBars
if not ADB then
  return
end

function ADB:GenerateOptions()
  local options = {
    type = "group",
    name = L["Animated Data Bars"],
    args = {
      header = {
        order = 1,
        type = "header",
        name = L["NihilistzschetUI Animated DataBars by Nihilistzsche"]
      },
      description = {
        order = 2,
        type = "description",
        name = L[
          "NihilistzschetUI Animated DataBars change the xp/rep/etc. databars to use the animated status bar template."
        ]
      },
      ticks = {
        order = 3,
        type = "group",
        name = "Ticks",
        guiInline = true,
        get = function(info)
          return E.db.nihilistzscheui.animateddatabars.ticks[info[#info]]
        end,
        set = function(info, value)
          E.db.nihilistzscheui.animateddatabars.ticks[info[#info]] = value
          self:UpdateTicks()
        end,
        args = {
          enabled = {
            type = "toggle",
            order = 1,
            name = L.Enable,
            desc = L["Enable animated databar ticks"]
          },
          resetsettings = {
            type = "execute",
            order = 2,
            name = L["Reset Settings"],
            desc = L["Reset the settings of this addon to their defaults."],
            func = function()
              E:CopyTable(E.db.nihilistzscheui.animateddatabars, P.nihilistzscheui.animateddatabars)
              ADB:UpdateTicks()
            end
          },
          width = {
            type = "range",
            order = 3,
            name = L.Width,
            desc = L["Width of the tick"],
            min = 1,
            max = 10,
            step = 1
          },
          alpha = {
            type = "range",
            order = 7,
            name = L.Alpha,
            desc = L["Alpha of the bar"],
            min = 0,
            max = 1,
            step = .1
          }
        }
      }
    }
  }
  return options
end
