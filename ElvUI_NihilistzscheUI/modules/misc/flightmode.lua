local NUI, E = _G.unpack(select(2, ...))
local COMP = NUI.Compatibility
local VUF = NUI.VerticalUnitFrames
local LO = E.Layout

if not COMP.BUI then return end

local NFM = NUI.Misc.FlightMode

local hooksecurefunc = _G.hooksecurefunc

function NFM:SetFlightMode(status)
    local RightChatPanel = _G.RightChatPanel
    local RightChatMover = _G.RightChatMover

    if status then
        self.NUIInFlightMode = true
        if E.private.chat.enable then
            RightChatPanel:SetParent(self.FlightMode)
            if RightChatPanel.backdrop.shadow then RightChatPanel.backdrop.shadow:Hide() end
            RightChatPanel:ClearAllPoints()
            RightChatPanel:Point("BOTTOMRIGHT", self.FlightMode.bottom, "TOPRIGHT", -24, 24)

            if RightChatPanel.backdrop.style then
                RightChatPanel.backdrop.style:SetFrameStrata("BACKGROUND")
                RightChatPanel.backdrop.style:SetFrameLevel(2)
                if RightChatPanel.backdrop.style.styleShadow then
                    RightChatPanel.backdrop.style.styleShadow:SetFrameStrata("BACKGROUND")
                    RightChatPanel.backdrop.style.styleShadow:SetFrameLevel(0)
                end
            end
            _G.RightChatDataPanel:Hide()
        end
    elseif self.NUIInFlightMode then
        self.NUIInFlightMode = false
        if E.private.chat.enable then
            RightChatPanel:SetParent(E.UIParent)
            if RightChatPanel.backdrop.shadow then
                RightChatPanel.backdrop.shadow:Show()
                RightChatPanel.backdrop.shadow:SetFrameStrata("BACKGROUND") -- it loses its framestrata somehow. Needs digging
                RightChatPanel.backdrop.shadow:SetFrameLevel(0)
            end
            if RightChatPanel.backdrop.style then
                RightChatPanel.backdrop.style:SetFrameStrata("BACKGROUND")
                RightChatPanel.backdrop.style:SetFrameLevel(2)
                if RightChatPanel.backdrop.style.styleShadow then
                    RightChatPanel.backdrop.style.styleShadow:SetFrameStrata("BACKGROUND")
                    RightChatPanel.backdrop.style.styleShadow:SetFrameLevel(0)
                end
            end
            RightChatPanel:ClearAllPoints()
            RightChatPanel:Point("BOTTOMRIGHT", RightChatMover, "BOTTOMRIGHT")
            LO:RepositionChatDataPanels()
            LO:ToggleChatPanels()
        end
    end
    VUF:UpdateMouseSetting()
end

function NFM:Initialize()
    local BFM = _G.ElvUI_BenikUI[1].FlightMode
    hooksecurefunc(BFM, "SetFlightMode", self.SetFlightMode)
    BFM:SetFlightMode(true)
    BFM:SetFlightMode(false)
end

NUI:RegisterModule(NFM:GetName())
