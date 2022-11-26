local NUI, E, L, V, P, G = _G.unpack(select(2, ...))
local NC = NUI.NihilistzscheChat

function NC:SetUpHooks()
    function ChatEdit_ChooseBoxForSend(preferredChatFrame)
        NC:ProcessQueuedWhoRequests()

        if ChatEdit_GetLastActiveWindow() and ChatEdit_GetLastActiveWindow():GetParent():IsShown() then
            return ChatEdit_GetLastActiveWindow()
        else
            return FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK).editBox
        end
    end

    function ChatFrame_SendTell(name, chatFrame)
        if not name then return end
        local editBox = ChatEdit_ChooseBoxForSend()

        if editBox ~= ChatEdit_GetActiveWindow() then
            ChatFrame_OpenChat(SLASH_WHISPER1 .. " " .. name .. " ", chatFrame)
        else
            editBox:SetText(SLASH_WHISPER1 .. " " .. name .. " ")
        end
        ChatEdit_ParseText(editBox, 0)
    end

    self.activeChatEditBox = nil

    local function CheckDeactivate(editBox, ignoreLast)
        if ACTIVE_CHAT_EDIT_BOX and ACTIVE_CHAT_EDIT_BOX ~= editBox then
            if
                not ignoreLast
                and self.activeChatEditBox ~= LAST_ACTIVE_CHAT_EDIT_BOX
                and LAST_ACTIVE_CHAT_EDIT_BOX ~= ACTIVE_CHAT_EDIT_BOX
            then
                self.activeChatEditBox = ACTIVE_CHAT_EDIT_BOX
            end
            ChatEdit_DeactivateChat(ACTIVE_CHAT_EDIT_BOX)
        end
    end

    function ChatEdit_ActivateChat(editBox, ignoreLast)
        CheckDeactivate(editBox, ignoreLast)

        ACTIVE_CHAT_EDIT_BOX = editBox

        if editBox.chatFrame and editBox.chatFrame.isDocked and SELECTED_DOCK_FRAME ~= editBox.chatFrame then
            FCF_SelectDockFrame(editBox.chatFrame)
        end

        ChatEdit_SetLastActiveWindow(editBox)

        editBox:SetFocus()

        --Stop any sort of fading
        if not editBox.isNihilistzscheChatFrame then
            UIFrameFadeRemoveFrame(editBox)

            editBox:Show()
            editBox:SetFocus()
            editBox:SetFrameStrata("DIALOG")
            editBox:Raise()

            editBox.header:Show()
            editBox.focusLeft:Show()
            editBox.focusRight:Show()
            editBox.focusMid:Show()
            editBox:SetAlpha(1.0)

            ChatEdit_UpdateHeader(editBox)

            if CHAT_SHOW_IME then _G[editBox:GetName() .. "Language"]:Show() end
        end
    end

    function ChatFrame_OpenChat(text, chatFrame)
        local editBox = ChatEdit_ChooseBoxForSend()

        ChatEdit_ActivateChat(editBox)
        editBox.setText = 1
        editBox.text = text or ""

        if not editBox.isNihilistzscheChatFrame then
            if editBox:GetAttribute("chatType") == editBox:GetAttribute("stickyType") then
                if
                    (editBox:GetAttribute("stickyType") == "PARTY") and (not IsInGroup(LE_PARTY_CATEGORY_HOME))
                    or (editBox:GetAttribute("stickyType") == "RAID") and (not IsInRaid(LE_PARTY_CATEGORY_HOME))
                    or (editBox:GetAttribute("stickyType") == "INSTANCE_CHAT")
                        and (not IsInGroup(LE_PARTY_CATEGORY_INSTANCE))
                then
                    editBox:SetAttribute("chatType", "SAY")
                end
            end

            ChatEdit_UpdateHeader(editBox)
        end

        return editBox
    end

    function ChatEdit_SetLastActiveWindow(editBox)
        --print("ChatEdit_SetLastActiveWindow")

        local previousValue = LAST_ACTIVE_CHAT_EDIT_BOX

        LAST_ACTIVE_CHAT_EDIT_BOX = editBox

        if not editBox.isNihilistzscheChatFrame then
            if previousValue and previousValue.chatFrame then
                FCFClickAnywhereButton_UpdateState(previousValue.chatFrame.clickAnywhereButton)
            end
            FCFClickAnywhereButton_UpdateState(editBox.chatFrame.clickAnywhereButton)
        end
    end

    -- We have to hook these because of fucking Pet Battle UI opening a temporary chat frame
    hooksecurefunc("FloatingChatFrameManager_OnEvent", function(self, event, ...)
        local arg1 = ...
        if strsub(event, 1, 9) == "CHAT_MSG_" then
            local chatType = strsub(event, 10)
            local chatGroup = Chat_GetChatCategory(chatType)

            if chatGroup == "BN_CONVERSATION" then
                if GetCVar("conversationMode") == "popout" or GetCVar("conversationMode") == "popout_and_inline" then
                    local chatTarget = tostring(select(8, ...))
                    if FCFManager_GetNumDedicatedFrames(chatGroup, chatTarget) == 0 then
                        local chatFrame = FCF_OpenTemporaryWindow(chatGroup, chatTarget)
                        chatFrame:GetScript("OnEvent")(chatFrame, event, ...) --Re-fire the event for the frame.
                    elseif GetCVar("conversationMode") == "popout_and_inline" and BCIsSelf(select(13, ...)) then
                        FCFManager_StopFlashOnDedicatedWindows(chatGroup, chatTarget)
                    end
                end
            end

            if
                (chatGroup == "BN_WHISPER" or chatGroup == "WHISPER")
                and (GetCVar("whisperMode") == "popout" or GetCVar("whisperMode") == "popout_and_inline")
            then
                local chatTarget = tostring(select(2, ...))

                if FCFManager_GetNumDedicatedFrames(chatGroup, chatTarget) == 0 then
                    local chatFrame = FCF_OpenTemporaryWindow(chatGroup, chatTarget)
                    chatFrame:GetScript("OnEvent")(chatFrame, event, ...) --Re-fire the event for the frame.

                    -- If you started the whisper, immediately select the tab
                    if
                        (event == "CHAT_MSG_WHISPER_INFORM" or event == "CHAT_MSG_BN_WHISPER_INFORM")
                        and GetCVar("whisperMode") == "popout"
                    then
                        if not chatFrame.isNihilistzscheChatFrame then
                            FCF_SelectDockFrame(chatFrame)
                            FCF_FadeInChatFrame(chatFrame)
                        end
                    end
                else
                    local chatFrame = NC:FindChat(chatTarget)
                    -- While in "Both" mode, if you reply to a whisper, stop the flash on that dedicated whisper tab
                    if
                        (
                            (chatType == "WHISPER_INFORM" or chatType == "BN_WHISPER_INFORM")
                            and GetCVar("whisperMode") == "popout_and_inline"
                        ) or not chatFrame.isNihilistzscheChatFrame
                    then
                        FCFManager_StopFlashOnDedicatedWindows(chatGroup, chatTarget)
                    end
                end
            end
        end
    end)

    local CURRENT_CHATFRAME

    -- Code from Choonster, http://us.battle.net/wow/en/forum/topic/6307501712
    -- FCF_DF is called by FCF_OTW, so this hook will be called first
    hooksecurefunc("FCF_DockFrame", function(frame, index, selected) CURRENT_CHATFRAME = frame end)

    local function CloseChatClosure()
        if InCombatLockdown() or UnitAffectingCombat("player") or UnitAffectingCombat("pet") then
            NUI:RegenWait(CloseChatClosure)
            return
        end
        if CURRENT_CHATFRAME then
            FCF_Close(CURRENT_CHATFRAME)
            CURRENT_CHATFRAME = nil
        end
    end

    hooksecurefunc("FCF_OpenTemporaryWindow", function(chatType, chatTarget, sourceChatFrame, selectWindow)
        if chatType == "PET_BATTLE_COMBAT_LOG" then return end

        -- We don't want to use PopInWindow because we don't want it to go to the default frame, and we have to delay it because closing it here fucks with stupid
        -- ass Blizzard code
        E:Delay(0.01, CloseChatClosure)

        chatTarget = NC:FixSameRealm(chatTarget)
        local chatFrame = NC:AcquireChat(chatType, chatTarget)

        return chatFrame
    end)

    function ChatEdit_ResetChatType(self)
        if self:GetAttribute("chatType") == "PARTY" and (not IsInGroup(LE_PARTY_CATEGORY_HOME)) then
            self:SetAttribute("chatType", "SAY")
        end
        if self:GetAttribute("chatType") == "RAID" and (not IsInRaid(LE_PARTY_CATEGORY_HOME)) then
            self:SetAttribute("chatType", "SAY")
        end
        if
            (self:GetAttribute("chatType") == "GUILD" or self:GetAttribute("chatType") == "OFFICER")
            and not IsInGuild()
        then
            self:SetAttribute("chatType", "SAY")
        end
        if self:GetAttribute("chatType") == "INSTANCE_CHAT" and (not IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
            self:SetAttribute("chatType", "SAY")
        end

        if not self.isNihilistzscheChatFrame then
            self.lastTabComplete = nil
            self.tabCompleteText = nil
            self.tabCompleteTableIndex = 1
            ChatEdit_UpdateHeader(self)
            ChatEdit_OnInputLanguageChanged(self)
        end
    end

    function ChatEdit_SetDeactivated(editBox)
        if not editBox.isNihilistzscheChatFrame then editBox:SetFrameStrata("LOW") end

        if GetCVar("chatStyle") == "classic" and not editBox.isGM then
            editBox:Hide()
        else
            editBox:SetText("")
            editBox:ClearFocus()
        end

        if editBox:GetName() then
            if _G[editBox:GetName() .. "Language"] then _G[editBox:GetName() .. "Language"]:Hide() end
        end
    end

    function ChatEdit_DeactivateChat(editBox)
        if ACTIVE_CHAT_EDIT_BOX == editBox then ACTIVE_CHAT_EDIT_BOX = nil end

        ChatEdit_SetDeactivated(editBox)
    end
end
