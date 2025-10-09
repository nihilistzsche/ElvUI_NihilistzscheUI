---@class NUI
local NUI, E = _G.unpack(_G.ElvUI_NihilistzscheUI)
local NI = NUI.Installer

local installVersion = { 13.03, 4 }

function NI.GetInstallInfo(idx)
    local tbl = installVersion
    return (tbl.classes and tbl.classes[E.myclass] and tbl.classes[E.myclass][idx]) or tbl[idx]
end

function NI.GetInstallVersion() return NI.GetInstallInfo(1) end

function NI.GetInstallBuild() return NI.GetInstallInfo(2) end
