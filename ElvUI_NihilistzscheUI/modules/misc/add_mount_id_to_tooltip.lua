local NUI, E = unpack((select(2, ...)))
local AMITT = NUI.Misc.AddMountIDToTooltip

local TT = E:GetModule("Tooltip")
local IDLine = "|cFFCA3C3C%s:|r %d"

function AMITT:SetUnitAura(tt, unit, index, filter)
    if not tt or tt:IsForbidden() then return end

    local name, _, _, _, _, _, _, _, _, spellID = E:GetAuraData(unit, index, filter)
    if not name then return end

    local mountID = E.MountIDs[spellID]
    if mountID then
        local sourceText = E.MountText[mountID]
        if sourceText then tt:AddLine(format(IDLine, "Mount ID", mountID)) end
        tt:Show()
    end
end

function AMITT:Initialize() hooksecurefunc(TT, "SetUnitAura", self.SetUnitAura) end

NUI:RegisterModule(AMITT:GetName())
