local NUI, E = _G.unpack(select(2, ...))
local ES = NUI.EnhancedShadows
local BS = NUI.ButtonStyle
local AB = E.ActionBars
local A = E.Auras
local IS = NUI.InvertedShadows
local COMP = NUI.Compatibility

local Masque = E.Libs.Masque
local hooksecurefunc = _G.hooksecurefunc

-- luacheck: no self
function BS:StyleButton(button, _, useMasque)
	if (useMasque) then
		return
	end

	if BS.db.enabled then
		local changed = false
		if not button.shadow then
			button:CreateShadow()
			changed = true
		end
		if IS and not button.ishadow then
			button:CreateInvertedShadow()
			changed = true
		end
		if changed then
			ES:RegisterFrameShadows(button)
			BS.styledButtons[button] = true
		end
	end
end

function BS:StyleAura(button)
	local db = E.private.auras.masque.debuffs
	if (button.auraType == "buffs") then
		db = E.private.auras.masque.buffs
	end

	if Masque and db then
		if (not button.shadow) then
			button:CreateShadow()
			ES:RegisterFrameShadows(button)
		end
		return
	end

	BS:StyleButton(button)
end

function BS:UpdateButtons()
	for button, _ in pairs(BS.styledButtons) do
		BS:StyleButton(button)
	end
end

function BS:StyleMERAutoButtons()
	if COMP.MER then
		local MAB = _G.ElvUI_MerathilisUI[1].AutoButtons
		for i = 1, MAB.db.questAutoButtons.questNum do
			self:StyleButton(_G["AutoQuestButton" .. i])
		end
		for i = 1, MAB.db.soltAutoButtons.slotNum do
			self:StyleButton(_G["AutoSlotButton" .. i])
		end
	end
end

BS.styledButtons = {}
function BS:Initialize()
	NUI:RegisterDB(self, "buttonStyle")
	local ForUpdateAll = function(_self)
		_self:UpdateButtons()
	end
	self.ForUpdateAll = ForUpdateAll
	hooksecurefunc(AB, "StyleButton", BS.StyleButton)
	hooksecurefunc(A, "UpdateAura", BS.StyleAura)

	hooksecurefunc(
		"PetBattleFrame_UpdateActionBarLayout",
		function()
			local bf = _G.PetBattleFrame.BottomFrame
			if not bf.TurnTimer.SkipButton.shadow then
				bf.TurnTimer.SkipButton:CreateShadow()
				ES:RegisterFrameShadows(bf.TurnTimer.SkipButton)
			end
			bf.TurnTimer.SkipButton:SetFrameLevel(bf.SwitchPetButton:GetFrameLevel() + 1)
			for i = 1, _G.NUM_BATTLE_PET_ABILITIES do
				self:StyleButton(bf.abilityButtons[i])
			end
			self:StyleButton(bf.SwitchPetButton)
			self:StyleButton(bf.CatchButton)
			self:StyleButton(bf.ForfeitButton)
		end
	)

	if COMP.MERS then
		if _G.ElvUI_MerathilisUI[1].initialized then
			self:StyleMERAutoButtons()
		else
			hooksecurefunc(
				_G.ElvUI_MerathilisUI[1],
				"Initialize",
				function()
					self:StyleMERAutoButtons()
				end
			)
		end
	end
	AB:UpdateButtonSettings()
end

NUI:RegisterModule(BS:GetName())
