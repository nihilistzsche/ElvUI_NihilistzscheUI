---@class NUI
local NUI = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

function NI:SkilletSetup()
    self:SetProfile(_G.SkilletDB, {
        vendor_auto_buy = true,
        show_crafters_tooltip = true,
        queue_more_than_one = true,
        quque_glyph_reagents = true,
        display_required_level = true,
        display_shopping_list_at_merchant = true,
        enhanced_recipe_display = true,
        tsm_compat = true,
    })
end

NI:RegisterAddOnInstaller("Skillet", NI.SkilletSetup)
