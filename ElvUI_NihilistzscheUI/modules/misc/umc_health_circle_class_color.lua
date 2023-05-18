local NUI = unpack((select(2, ...)))
local COMP = NUI.Compatibility

local UMCHCCC = NUI.Misc.UltimateMouseCursorHealthCircleClassColor

function UMCHCCC:Initialize()
    if not COMP.IsAddOnEnabled("WeakAuras") then return end

    local WeakAuras = _G.WeakAuras
    local hdata = WeakAuras.GetData("Health-Circle")
    if hdata then
        local c = NUI.ClassColor(true)
        hdata.foregroundColor = c
        hdata.conditions[1].changes[1].value = c
    end
    local ic_ids = { "GCD-Bar", "GCD-Circle", "Cast-Bar", "Cast-Circle" }
    local ic = NUI.InvertedClassColor(true)
    for _, id in next, ic_ids do
        local data = WeakAuras.GetData(id)
        if data then data.foregroundColor = ic end
    end
end

NUI:RegisterModule(UMCHCCC:GetName())
