---@class NUI
local NUI, E = _G.unpack((select(2, ...)))

local AB = E.ActionBars
local COMP = NUI.Compatibility
local NM = NUI.Misc
local hooksecurefunc = _G.hooksecurefunc
local C_AddOns_LoadAddOn = _G.C_AddOns.LoadAddOn

function NM:Initialize()
    self.HookAFK()
    self.UpdateQuestMapFrame()
    hooksecurefunc(AB, "UpdateButtonConfig", function(barName)
        if barName and AB.handledBars[barName] then
            for _, button in pairs(AB.handledBars[barName].buttonss) do
                button:SetAttribute("unit2", "player")
            end
        end
    end)
    if COMP.IF then
        C_AddOns_LoadAddOn("InFlight")
        hooksecurefunc(_G.InFlight, "StartTimer", function()
            local InFlightBar = _G.InFlightBar
            if InFlightBar then
                if COMP.BUI and not InFlightBar.style then
                    InFlightBar:CreateBackdrop("Transparent")
                    InFlightBar:BuiStyle("Outside")
                end
                InFlightBar:ClearAllPoints()
                InFlightBar:SetPoint("TOP", 0, -262)
            end
        end)
    end
    if COMP.IsAddOnEnabled("Forward") and _G.MovePad then
        E.FrameLocks[_G.MovePad] = true
        E:CreateMover(
            _G.MovePad,
            "NUIForwardMovePadMover",
            "Forward Move Pad",
            nil,
            nil,
            nil,
            "ALL,SOLO,NIHILISTZSCHEUI"
        )
    end
    if COMP.IsAddOnEnabled("OldGodWhispers") then
        if not _G.DragFrame then C_AddOns_LoadAddOn("OldGodWhispers") end
        E:CreateMover(
            _G.DragFrame,
            "OldGodWhispersDragFrameMover",
            "Old God Whispers Drag Frame",
            nil,
            nil,
            nil,
            "ALL,SOLO,NIHILISTZSCHEUI"
        )
    end
    if COMP.SLE then
        CharacterStatsPane.OffenseCategory:Kill()
        CharacterStatsPane.DefenseCategory:Kill()
    end

    --if COMP.PAWN and COMP.IMMERSION then self:HookImmersionRewards() end
end

NUI:RegisterModule(NM:GetName())
