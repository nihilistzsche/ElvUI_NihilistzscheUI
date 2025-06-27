local NUI = unpack((select(2, ...)))
local COMP = NUI.Compatibility

local UMCHCCC = NUI.Misc.UltimateMouseCursorHealthCircleClassColor

function UMCHCCC:Initialize()
    if not COMP.IsAddOnEnabled("WeakAuras") then return end

    local WeakAuras = _G.WeakAuras

    local c_ids = { "Health-Circle", "Mouse Cursor", "Mouse Cursor Combat", "Mouse Cursor Dot", "Mouse Cursor Trail" }
    for _, id in next, c_ids do
        local data = WeakAuras.GetData(id)
        if data then
            data.config.MainRingClassColor = true
            if id == "Health-Circle" then data.conditions[1].changes[1].value = NUI.ClassColor(true) end
        end
    end
    local ic_ids = { "GCD-Bar", "GCD-Circle", "Cast-Bar", "Cast-Circle" }
    local ic = NUI.InvertedClassColor(true)
    for _, id in next, ic_ids do
        local data = WeakAuras.GetData(id)
        if data then data.foregroundColor = ic end
    end
end

NUI:RegisterModule(UMCHCCC:GetName())
