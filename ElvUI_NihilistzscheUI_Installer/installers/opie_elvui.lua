---@class NUI
local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)

local NI = NUI.Installer

function NI.OPieElvUISetup() _G.OPieElvUIDB = { global = { shadow = true } } end

NI:RegisterGlobalAddOnInstaller("OPie_ElvUI", NI.OPieElvUISetup)
