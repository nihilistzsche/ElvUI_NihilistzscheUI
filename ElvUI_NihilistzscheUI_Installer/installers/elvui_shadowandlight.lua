local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer
local COMP = NUI.Compatibility

function NI:SLESetup(isSpec)
  local ic = "99.00"
  if not isSpec then
    self:EPRV().sle = self:EPRV().sle or {}
    self:EPRV().sle.install_complete = ic
  end
  if NUI.Lulupeep then
    self:SLELuluSetup()
    return
  end

  self:EDB().sle = {
    databars = {
      azerite = {
        chatfilter = {
          enable = false,
          style = "STYLE2"
        }
      },
      exp = {
        chatfilter = {
          enable = false,
          style = "STYLE2"
        }
      },
      rep = {
        autotrack = true,
        chatfilter = {
          style = "STYLE2",
          enable = false,
          styleDec = "STYLE2"
        }
      },
      honor = {
        chatfilter = {
          awardStyle = "STYLE4",
          enable = false,
          style = "STYLE3"
        }
      }
    },
    tooltipicon = true,
    media = {
      fonts = {
        gossip = {
          font = self.db.font
        },
        zone = {
          font = self.db.font
        },
        subzone = {
          font = self.db.font
        },
        questFontSuperHuge = {
          font = self.db.font
        },
        objectiveHeader = {
          font = self.db.font
        },
        mail = {
          font = self.db.font
        },
        objective = {
          font = self.db.font
        },
        editbox = {
          font = self.db.font
        },
        pvp = {
          font = self.db.font
        }
      }
    },
    blizzard = {
      rumouseover = true
    },
    characterframeoptions = {
      equipmentgradient = true
    },
    minimap = {
      instance = {
        font = self.db.font
      },
      mapicons = {
        iconsize = 24,
        iconmouseover = true
      }
    },
    legacy = {
      garrison = {
        autoOrder = {
          enable = true
        },
        toolbar = {
          enable = true
        }
      }
    },
    Glamour = {
      Character = {
        ItemLevel = {
          outline = "OUTLINE"
        },
        Stats = {
          IlvlFull = true,
          List = {
            HEALTH = true,
            ALTERNATEMANA = true,
            SPELLPOWER = true,
            ATTACK_DAMAGE = true,
            MOVESPEED = true,
            ATTACK_ATTACKSPEED = true,
            FOCUS_REGEN = true,
            RUNE_REGEN = true,
            POWER = true,
            ENERGY_REGEN = true,
            ATTACK_AP = true
          }
        }
      }
    },
    loot = {
      enable = true,
      autoroll = {
        autode = true,
        bylevel = true,
        autoconfirm = true,
        autogreed = true
      }
    },
    lfr = {
      legion = {
        trial = true,
        nightmare = true,
        tomb = true,
        palace = true
      }
    },
    chat = {
      tab = {
        select = true,
        style = "SQUARE"
      },
      textureAlpha = {
        enable = true,
        alpha = 0.25
      }
    },
    screensaver = {
      subtitle = {
        font = self.db.font
      },
      date = {
        font = self.db.font
      },
      player = {
        font = self.db.font
      },
      title = {
        font = self.db.font
      },
      tips = {
        font = self.db.font
      }
    },
    lfrshow = {
      enabled = true,
      nightmare = true,
      tomb = true,
      palace = true,
      trial = true
    },
    dt = {
      friends = {
        expandBNBroadcast = true
      }
    },
    tooltip = {
      RaidProg = {
        enable = true
      },
      alwaysCompareItems = true,
      showFaction = true
    },
    orderhall = {
      autoOrder = {
        enable = true,
        autoEquip = true
      }
    },
    raidmarkers = {
      enable = false
    },
    skins = {
      objectiveTracker = {
        underline = false
      }
    },
    Armory = {
      Character = {
        Azerite = {
          Font = self.db.font
        },
        Stats = {
          IlvlFull = true,
          List = {
            HEALTH = true,
            ALTERNATEMANA = true,
            SPELLPOWER = true,
            ATTACK_DAMAGE = true,
            MOVESPEED = true,
            ATTACK_ATTACKSPEED = true,
            FOCUS_REGEN = true,
            RUNE_REGEN = true,
            ENERGY_REGEN = true,
            POWER = true,
            ATTACK_AP = true
          },
          ItemLevel = {
            font = self.db.font
          }
        },
        Enchant = {
          Font = self.db.font
        },
        Level = {
          Font = self.db.font
        },
        Durability = {
          Font = self.db.font
        }
      },
      Inspect = {
        guildMembers = {
          Font = self.db.font
        },
        pvpText = {
          Font = self.db.font
        },
        pvpRating = {
          Font = self.db.font
        },
        Level = {
          Font = self.db.font
        },
        pvpType = {
          Font = self.db.font
        },
        pvpRecord = {
          Font = self.db.font
        },
        Spec = {
          Font = self.db.font
        },
        Enchant = {
          Font = self.db.font
        },
        Name = {
          Font = self.db.font
        },
        guildName = {
          Font = self.db.font
        },
        Title = {
          Font = self.db.font
        },
        infoTabs = {
          Font = self.db.font
        }
      }
    }
  }

  if not isSpec then
    self:EPRV().sle.equip = self:EPRV().sle.equip or {}
    self:EPRV().sle.equip.enable = true
    self:EPRV().sle.equip.lockbutton = true
    self:EPRV().sle.equip.setoverlay = true
    self:EPRV().sle.inspectframeoptions = {
      enable = true
    }
    self:EPRV().sle.characterframeoptions = {
      enable = true
    }
    self:EPRV().sle.minimap = {
      mapicons = {
        enable = true,
        barenable = true
      }
    }
    self:EPRV().sle.module = {
      screensaver = true,
      blizzmove = true
    }
    self:EPRV().sle.professions = {
      fishing = {
        EasyCast = true,
        CastButton = "None"
      }
    }
    self:EPRV().sle.skins = self:EPRV().sle.skins or {}
    self:EPRV().sle.skins.objectiveTracker = {
      texture = self.db.texture,
      class = true
    }
    self:EPRV().sle.skins.questguru = {
      enable = true,
      removeParchment = true
    }
    self:EPRV().sle.skins.merchant = {
      enable = true,
      style = "List"
    }
    self:EPRV().sle.actionbars = {
      transparentBackdrop = true,
      transparentButtons = true
    }
  end
end

function NI.GlobalSLESetup()
  E.global.sle.advanced.gameMenu.reload = true
end

function NI:SLELuluSetup()
  self:EDB().sle = {
    databars = {
      rep = {
        autotrack = true
      }
    },
    raidmarkers = {
      visibility = "INPARTY"
    },
    media = {
      fonts = {
        objective = {
          font = self.db.font
        },
        zone = {
          font = self.db.font
        },
        gossip = {
          font = self.db.font
        },
        objectiveHeader = {
          font = self.db.font
        },
        mail = {
          font = self.db.font
        },
        editbox = {
          font = self.db.font
        },
        subzone = {
          font = self.db.font
        },
        pvp = {
          font = self.db.font
        }
      }
    },
    tooltip = {
      alwaysCompareItems = true,
      RaidProg = {
        enable = true
      },
      showFaction = true
    },
    garrison = {
      autoOrder = true
    },
    dt = {
      friends = {
        expandBNBroadcast = true
      }
    },
    lfrshow = {
      enabled = true,
      brf = true,
      hm = true,
      hfc = true
    },
    loot = {
      enable = true,
      autoroll = {
        autoconfirm = true,
        autogreed = true
      }
    },
    farm = {
      autotarget = true,
      quest = true
    },
    datatexts = {
      dashboard = {
        enable = true
      }
    },
    tooltipicon = true,
    characterframeoptions = {
      equipmentgradient = true
    },
    minimap = {
      mapicons = {
        iconsize = 24
      },
      coords = {
        enable = true,
        font = self.db.font
      }
    }
  }
end
if (COMP.SLE) then
  NI:SaveInstallTable(_G.ElvUI_SLE[1])
end

NI:RegisterAddOnInstaller("ElvUI_SLE", NI.SLESetup, true)
NI:RegisterGlobalAddOnInstaller("ElvUI_SLE", NI.GlobalSLESetup)
