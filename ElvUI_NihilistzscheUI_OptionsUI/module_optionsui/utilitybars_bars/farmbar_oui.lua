local NUI, E, L, _, P = _G.unpack(_G.ElvUI_NihilistzscheUI)
local FB = NUI.UtilityBars.FarmBar

local itemID, currencyID, itemTarget, currencyTarget, itemLink, currencyLink

function FB:UpdateWatchOptions(options)
  options.args.watches = {
    order = 4,
    type = "group",
    name = "Add Watch",
    guiInline = true,
    args = {
      items = {
        order = 1,
        type = "group",
        name = "Add Item Watch",
        guiInline = true,
        args = {
          id = {
            order = 1,
            name = "ItemID or ItemLink",
            type = "input",
            get = function()
              return itemLink or ""
            end,
            set = function(_, value)
              itemLink = value
              itemID = value:gsub("\124", "\124\124")
              self:UpdateWatchOptions(options)
            end
          },
          target = {
            order = 2,
            name = "Target",
            type = "input",
            get = function()
              return itemTarget or ""
            end,
            set = function(_, value)
              itemTarget = value
              self:UpdateWatchOptions(options)
            end
          },
          addwatch = {
            order = 3,
            type = "execute",
            name = "Add Item Watch",
            disabled = function()
              return not self.GetID(itemID, true) or not tonumber(itemTarget)
            end,
            func = function()
              self:AddWatch(true, self.GetID(itemID, true), tonumber(itemTarget))
              itemID = nil
              itemLink = nil
              itemTarget = nil
              FB:UpdateWatchOptions(options)
            end
          }
        }
      },
      currency = {
        order = 2,
        type = "group",
        name = "Add Currency Watch",
        guiInline = true,
        args = {
          id = {
            order = 1,
            name = "CurrencyID or CurrencyLink",
            type = "input",
            get = function()
              return currencyLink or ""
            end,
            set = function(_, value)
              currencyLink = value
              currencyID = value:gsub("\124", "\124\124")
              self:UpdateWatchOptions(options)
            end
          },
          target = {
            order = 2,
            name = "Target",
            type = "input",
            get = function()
              return currencyTarget or ""
            end,
            set = function(_, value)
              currencyTarget = value
              self:UpdateWatchOptions(options)
            end
          },
          addwatch = {
            order = 3,
            type = "execute",
            name = "Add Currency Watch",
            disabled = function()
              return not FB:GetID(currencyID, false) or not tonumber(currencyTarget)
            end,
            func = function()
              FB:AddWatch(false, FB:GetID(currencyID, false), tonumber(currencyTarget))
              currencyID = nil
              currencyLink = nil
              currencyTarget = nil
              FB:UpdateWatchOptions(options)
            end
          }
        }
      }
    }
  }
end

function FB:GenerateUtilityBarOptions()
  local options = {
    type = "group",
    name = L["Farm Bar"],
    args = {
      header = {
        order = 1,
        type = "header",
        name = L["NihilistzscheUI FarmBar by Nihilistzsche, based on work by Azilroka"]
      },
      description = {
        order = 2,
        type = "description",
        name = L["NihilistzscheUI FarmBar provides a bar to manually track items and currencies you are farming."]
      },
      general = {
        order = 3,
        type = "group",
        name = "General",
        guiInline = true,
        get = function(info)
          return E.db.nihilistzscheui.utilitybars.farmBar[info[#info]]
        end,
        set = function(info, value)
          E.db.nihilistzscheui.utilitybars.farmBar[info[#info]] = value
          self:UpdateBar(self.bar)
        end,
        args = {
          enabled = {
            type = "toggle",
            order = 1,
            name = L.Enable,
            desc = L["Enable the farm bar"]
          },
          resetsettings = {
            type = "execute",
            order = 2,
            name = L["Reset Settings"],
            desc = L["Reset the settings of this addon to their defaults."],
            func = function()
              E:CopyTable(E.db.nihilistzscheui.utilitybars.farmBar, P.nihilistzscheui.utilitybars.farmBar)
              self:UpdateBar(self.bar)
            end
          },
          mouseover = {
            type = "toggle",
            order = 3,
            name = L.Mouseover,
            desc = L["Only show the farm bar when you mouseover it"]
          },
          notify = {
            type = "toggle",
            order = 4,
            name = L.Notify,
            desc = L["Notify you when you gain (or lose) watched items/currencies"]
          },
          buttonsize = {
            type = "range",
            order = 5,
            name = L.Size,
            desc = L["Button Size"],
            min = 12,
            max = 40,
            step = 1
          },
          spacing = {
            type = "range",
            order = 6,
            name = L.Spacing,
            desc = L["Spacing between buttons"],
            min = 1,
            max = 10,
            step = 1
          },
          alpha = {
            type = "range",
            order = 7,
            name = L.Alpha,
            desc = L["Alpha of the bar"],
            min = 0.2,
            max = 1,
            step = .1
          },
          buttonsPerRow = {
            type = "range",
            order = 8,
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
  FB:UpdateWatchOptions(options)

  return options
end
