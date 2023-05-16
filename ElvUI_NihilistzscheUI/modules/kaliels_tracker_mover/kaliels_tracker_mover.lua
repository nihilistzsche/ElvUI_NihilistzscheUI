local NUI, E = _G.unpack((select(2, ...)))
local COMP = NUI.Compatibility
local KTM = NUI.KalielsTrackerMover

function KTM.Initialize()
    if not COMP.KT then return end

    local KT = _G.LibStub("AceAddon-3.0"):GetAddon("!KalielsTracker")
    KT.MoveTracker = E.noop
    local frame = KT.frame
    frame:SetParent(E.UIParent)
    frame:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", -82, -335)
    E:CreateMover(frame, "NUIKalielsTrackerMover", "Kaliels Tracker", nil, nil, nil, "ALL,SOLO,NIHILISTZSCHEUI")
    frame:SetAllPoints(_G["NUIKalielsTrackerMover"])
end

NUI:RegisterModule(KTM:GetName())
