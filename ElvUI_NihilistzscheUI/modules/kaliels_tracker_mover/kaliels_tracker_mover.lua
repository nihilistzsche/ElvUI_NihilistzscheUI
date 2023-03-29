local NUI, E = unpack((select(2, ...)))
local COMP = NUI.Compatibility
local KTM = NUI.KalielsTrackerMover

if not COMP.KT then return end

local KT = LibStub("AceAddon-3.0"):GetAddon("!KalielsTracker")
hooksecurefunc(KT, "MoveTracker", function()
    local frame = KT.frame
    frame:SetParent(E.UIParent)
    frame:SetPoint("CENTER", E.UIParent, "CENTER", 0, 0)
    E:CreateMover(frame, "NUIKalielsTrackerMover", "Kaliels Tracker", nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")
    frame:SetAllPoints(_G["NUIKalielsTrackerMover"])
end)

NUI:RegisterModule(KTM:GetName())
