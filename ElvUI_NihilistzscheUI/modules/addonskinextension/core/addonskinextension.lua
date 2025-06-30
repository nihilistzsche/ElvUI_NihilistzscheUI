---@class NUI
local NUI = _G.unpack((select(2, ...)))
local COMP = NUI.Compatibility
if not COMP.AS then return end

local AS = _G.unpack(_G.AddOnSkins)
local SASX = NUI.NihilistzscheUIAddOnSkinExtension

function SASX:RegisterSkin(addon, func)
    if self.initialized then
        AS:RegisterSkin(addon, SASX[func])
    else
        if not self.RegisteredSkins then self.RegisteredSkins = {} end
        self.RegisteredSkins[addon] = func
    end
end

function SASX:Initialize()
    for k, v in pairs(self.RegisteredSkins) do
        AS:RegisterSkin(k, SASX[v])
    end
    self.initialized = true
end

NUI:RegisterModule(SASX:GetName())
