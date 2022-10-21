local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NC = NUI.NihilistzscheChat

NC.MinimizeAll = true

function NC:MinimizeAllChats()
  local ACR = E.Libs.AceConfigRegistry
  for _, v in ipairs(self.chats) do
    if self.MinimizeAll then
      if not v.minimized then
        self:SetMinimized(v)
      end
    else
      self:SetMaximized(v)
    end
  end
  if self.MinimizeAll then
    self.MinimizeAll = false
    E.Options.args.NihilistzscheUI.args.modules.args.NihilistzscheChat.args.general.args.minimizeall.name = L.Maximize
  else
    self.MinimizeAll = true
    E.Options.args.NihilistzscheUI.args.modules.args.NihilistzscheChat.args.general.args.minimizeall.name = L.Minimize
  end
  ACR:NotifyChange("ElvUI")
end

function NC:GenerateOptions()
  local choices = {
    ["12Hour"] = "12 Hour",
    ["24Hour"] = "24 Hour"
  }
  local options = {
    type = "group",
    name = L.NihilistzscheChat,
    args = {
      header = {
        order = 1,
        type = "header",
        name = L["NihilistzscheChat by Nihilistzsche/Hydrazine (tukui.org)"]
      },
      description = {
        order = 2,
        type = "description",
        name = L["NihilistzscheChat makes your chat experience awesome"]
      },
      general = {
        order = 3,
        type = "group",
        name = L.General,
        guiInline = true,
        get = function(info)
          return E.db.nihilistzscheui.nihilistzschechat.general[info[#info]]
        end,
        set = function(info, value)
          E.db.nihilistzscheui.nihilistzschechat.general[info[#info]] = value
          self:UpdateAll()
        end,
        args = {
          enabled = {
            type = "toggle",
            order = 1,
            name = L.Enable,
            desc = L["Enable NihilistzscheChat."],
            set = function(info, value)
              E.db.nihilistzscheui.nihilistzschechat.general[info[#info]] = value
              E:StaticPopup_Show("CONFIG_RL")
            end
          },
          resetsettings = {
            type = "execute",
            order = 2,
            name = L["Reset Settings"],
            desc = L["Reset the settings of this addon to their defaults."],
            func = function()
              local old = E.db.nihilistzscheui.nihilistzschechat.general.enabled
              E:CopyTable(E.db.nihilistzscheui.nihilistzschechat, P.nihilistzscheui.NihilistzscheChat)
              if (old ~= E.db.nihilistzscheui.nihilistzschechat.general.enabled) then
                E:StaticPopup_Show("CONFIG_RL")
              else
                NC:UpdateAll()
              end
            end
          },
          minimizeall = {
            type = "execute",
            name = L.Minimize,
            order = 3,
            func = function()
              NC:MinimizeAllChats()
            end
          },
          bordercolor = {
            type = "color",
            order = 4,
            name = L["Border Color"],
            get = function()
              local t = E.db.nihilistzscheui.nihilistzschechat.general.bordercolor
              return t.r, t.g, t.b, t.a
            end,
            set = function(_, r, g, b)
              local t = E.db.nihilistzscheui.nihilistzschechat.general.bordercolor
              t.r, t.g, t.b = r, g, b
              NC:UpdateAll()
            end
          },
          Backdropcolor = {
            type = "color",
            order = 5,
            name = L["Backdrop Color"],
            hasAlpha = true,
            get = function()
              local t = E.db.nihilistzscheui.nihilistzschechat.general.backdropcolor
              return t.r, t.g, t.b, t.a
            end,
            set = function(_, r, g, b)
              local t = E.db.nihilistzscheui.nihilistzschechat.general.backdropcolor
              t.r, t.g, t.b = r, g, b
              NC:UpdateAll()
            end
          },
          alpha = {
            order = 6,
            name = L.Alpha,
            type = "range",
            min = 0,
            max = 1,
            step = .1
          }
        }
      },
      windows = {
        order = 4,
        type = "group",
        name = L.Options,
        guiInline = true,
        get = function(info)
          return E.db.nihilistzscheui.nihilistzschechat.windows[info[#info]]
        end,
        set = function(info, value)
          E.db.nihilistzscheui.nihilistzschechat.windows[info[#info]] = value
          NC:UpdateAll()
        end,
        args = {
          autofade = {
            type = "toggle",
            order = 4,
            name = L.AutoFade
          },
          autohide = {
            type = "toggle",
            order = 5,
            name = L.AutoHide
          },
          showtitle = {
            type = "toggle",
            order = 6,
            name = L.ShowTitle
          },
          timestamp = {
            type = "toggle",
            name = L.Timestamps,
            order = 8
          },
          localtime = {
            order = 9,
            name = L["Local Time"],
            type = "toggle"
          },
          width = {
            order = 10,
            name = L.Width,
            type = "range",
            min = 100,
            max = 500,
            step = 1
          },
          height = {
            order = 11,
            name = L.Height,
            type = "range",
            min = 50,
            max = 120,
            step = 1
          },
          fontsize = {
            order = 12,
            name = L.FontSize,
            type = "range",
            min = 9,
            max = 16,
            step = 1
          },
          font = {
            type = "select",
            dialogControl = "LSM30_Font",
            order = 13,
            name = L.Font,
            values = _G.AceGUIWidgetLSMlists.font
          },
          timeformat = {
            order = 14,
            name = L.TimeFormat,
            type = "select",
            values = choices
          }
        }
      }
    }
  }

  return options
end
