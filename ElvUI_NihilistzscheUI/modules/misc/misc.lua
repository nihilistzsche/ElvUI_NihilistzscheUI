local NUI, E = _G.unpack(select(2, ...))

local AB = E.ActionBars
local COMP = NUI.Compatibility
local NM = NUI.Misc

local hooksecurefunc = _G.hooksecurefunc
local LoadAddOn = _G.LoadAddOn
local GetNumSpecializations = _G.GetNumSpecializations

function NM:Initialize()
    self.HookAFK()
    self.UpdateQuestMapFrame()
    hooksecurefunc(AB, "UpdateButtonConfig", function(barName, buttonName)
        if barName and AB.handledBars[barName] then
            for _, button in pairs(AB.handledBars[barName].buttonss) do
                button:SetAttribute("unit2", "player")
            end
        end
    end)
    if COMP.IF then
        LoadAddOn("InFlight")
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
    _G.PlayerTalentFrameSpecialization:HookScript("OnShow", function(_self)
        local numSpecs = GetNumSpecializations(false, _self.isPet)
        -- demon hunters have 2 specs, druids have 4
        if numSpecs == 1 then
            _self.specButton1:SetPoint("TOPLEFT", 6, -161)
            _self.specButton2:Hide()
            _self.specButton3:Hide()
        elseif numSpecs == 2 then
            _self.specButton1:SetPoint("TOPLEFT", 6, -131)
            _self.specButton3:Hide()
        elseif numSpecs == 4 then
            _self.specButton1:SetPoint("TOPLEFT", 6, -61)
            _self.specButton4:Show()
        end
    end)
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
        if not _G.DragFrame then LoadAddOn("OldGodWhispers") end
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
end

NUI:RegisterModule(NM:GetName())
