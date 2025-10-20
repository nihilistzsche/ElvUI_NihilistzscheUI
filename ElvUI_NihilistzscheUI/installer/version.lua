---@class NUI
local NUI, E = _G.unpack((select(2, ...)))
local NI = NUI.Installer

local installVersion = { 14.00, 1 }

function NI.GetInstallInfo(idx)
    local tbl = installVersion
    return (tbl.classes and tbl.classes[E.myclass] and tbl.classes[E.myclass][idx]) or tbl[idx]
end

function NI.GetInstallVersion() return NI.GetInstallInfo(1) end

function NI.GetInstallBuild() return NI.GetInstallInfo(2) end
