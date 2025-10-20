---@class NUI
local NUI, E = _G.unpack((select(2, ...)))

local NI = NUI.Installer

function NI.OPieElvUISetup() _G.OPieElvUIDB = { global = { shadow = true } } end

NI:RegisterGlobalAddOnInstaller("OPie_ElvUI", NI.OPieElvUISetup)
