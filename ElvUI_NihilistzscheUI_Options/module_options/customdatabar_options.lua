---@class NUI
local NUI, E, L = _G.unpack(_G.ElvUI_NihilistzscheUI)
local CDB = NUI.CustomDataBar

function CDB:GenerateOptions()
    E.Options.args.databars.args.experience.args.textFormat = nil
    E.Options.args.databars.args.experience.args.tag = {
        type = "input",
        width = "full",
        name = L["Text Format"],
        desc = L.TEXT_FORMAT_DESC,
        order = 10,
        get = function() return E.db.databars.experience.tag end,
        set = function(_, value)
            E.db.databars.experience.tag = value
            self:UpdateTag("experience")
        end,
    }
    E.Options.args.databars.args.experience.args.noRestedTag = {
        type = "input",
        width = "full",
        name = L["Text Format"] .. " (No Rested XP)",
        desc = L.TEXT_FORMAT_DESC,
        order = 11,
        get = function() return E.db.databars.experience.noRestedTag end,
        set = function(_, value)
            E.db.databars.experience.noRestedTag = value
            self:UpdateTag("experience")
        end,
    }
    E.Options.args.databars.args.experience.args.noQuestTag = {
        type = "input",
        width = "full",
        name = L["Text Format"] .. " (No Quest XP)",
        desc = L.TEXT_FORMAT_DESC,
        order = 12,
        get = function() return E.db.databars.experience.noQuestTag end,
        set = function(_, value)
            E.db.databars.experience.noQuestTag = value
            self:UpdateTag("experience")
        end,
    }
    E.Options.args.databars.args.experience.args.noQuestNoRestedTag = {
        type = "input",
        width = "full",
        name = L["Text Format"] .. " (No Quest XP or Rested XP)",
        desc = L.TEXT_FORMAT_DESC,
        order = 13,
        get = function() return E.db.databars.experience.noQuestNoRestedTag end,
        set = function(_, value)
            E.db.databars.experience.noQuestNoRestedTag = value
            self:UpdateTag("experience")
        end,
    }
    E.Options.args.databars.args.reputation.args.textFormat = nil
    E.Options.args.databars.args.reputation.args.tag = {
        type = "input",
        width = "full",
        name = L["Text Format"],
        desc = L.TEXT_FORMAT_DESC,
        order = 4,
        get = function() return E.db.databars.reputation.tag end,
        set = function(_, value)
            E.db.databars.reputation.tag = value
            self:UpdateTag("reputation")
        end,
    }

    if E.Retail then
        E.Options.args.databars.args.azerite.args.textFormat = nil
        E.Options.args.databars.args.azerite.args.tag = {
            type = "input",
            width = "full",
            name = L["Text Format"],
            desc = L.TEXT_FORMAT_DESC,
            order = 4,
            get = function() return E.db.databars.azerite.tag end,
            set = function(_, value)
                E.db.databars.azerite.tag = value
                self:UpdateTag("azerite")
            end,
        }

        E.Options.args.databars.args.honor.args.textFormat = nil
        E.Options.args.databars.args.honor.args.tag = {
            type = "input",
            width = "full",
            name = L["Text Format"],
            desc = L.TEXT_FORMAT_DESC,
            order = 6,
            get = function() return E.db.databars.honor.tag end,
            set = function(_, value)
                E.db.databars.honor.tag = value
                self:UpdateTag("honor")
            end,
        }
    end
end
