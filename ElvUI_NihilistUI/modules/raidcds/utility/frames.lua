local NUI, E = _G.unpack(select(2, ...))
local RCD = NUI.RaidCDs
local LSM = E.Libs.LSM
local CandyBar = NUI.Libs.CandyBar
local ES = NUI.EnhancedShadows
local COMP = NUI.Compatibility

local UnitName = _G.UnitName
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local GetSpellTexture = _G.GetSpellTexture
local UnitGUID = _G.UnitGUID
local IsInRaid = _G.IsInRaid
local GetSpellCharges = _G.GetSpellCharges
local GameTooltip = _G.GameTooltip
local CreateFrame = _G.CreateFrame
local tinsert = _G.tinsert
local strsplit = _G.strsplit
local UnitAffectingCombat = _G.UnitAffectingCombat

RCD.barCache = {}

function RCD:CreateBar(spell_id, guid)
	local category = self.reverse_mappings[spell_id]

	if (self.barCache[category] and self.barCache[category][spell_id] and self.barCache[category][spell_id][guid]) then
		local bar = self.barCache[category][spell_id][guid]
		bar:SetLabel(UnitName(self.cached_players[guid].unit))
		NUI.ResetCandyBarLabelDurationAnchors(bar)
		return bar
	end
	local bar = CandyBar:New(LSM:Fetch("statusbar", self.db.texture), self.db.width, self.db.height)

	bar:SetParent(self:GetHolder(category))
	bar.candyBarBackdrop:SetTemplate("Transparent")
	if (COMP.MERS) then
		bar:Styling()
	end

	local class = self.cached_players[guid].unitInfo.class
	local classColor = class == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[class]
	bar:SetColor(classColor.r, classColor.g, classColor.b)
	bar.candyBarDuration:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
	bar.candyBarLabel:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
	bar:SetLabel(UnitName(self.cached_players[guid].unit))
	local duration = self.cd_list[category][spell_id][guid]
	bar:SetDuration(duration)
	local icon = GetSpellTexture(spell_id)
	bar:SetIcon(icon)
	bar.info = {
		id = spell_id,
		guid = guid,
		duration = duration,
		raidBattleRes = self.categories[category][spell_id].raid_battle_res
	}
	bar:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	bar:SetScript(
		"OnEvent",
		function(_self, _, ...)
			local unit, _, _spell_id = ...
			if (UnitGUID(unit) == _self.info.guid and _spell_id == _self.info.id) then
				if (IsInRaid() and _self.info.raidBattleRes) then
					local currentCharges, _, _, cooldownDuration = GetSpellCharges(_spell_id)
					if (currentCharges == 0) then
						_self:SetDuration(cooldownDuration)
						_self:Start()
						_self.loopProtect = false
						return
					else
						_self.candyBarDuration:SetText(("%d RDY"):format(currentCharges))
					end
				end
				_self:Start()
				_self.loopProtect = nil
			end
		end
	)
	if (not bar.cdyStop) then
		bar.cdyStop = bar.Stop
	end
	bar.Stop = function(_self)
		_self.updater:Stop()
		_self.candyBarDuration:SetText("READY")
		if (not _self.loopProtect) then
			_self.loopProtect = true
			_self.remaining = _self.info.duration
			_self:Start()
			_self:Stop()
		end
	end
	bar:Start()
	bar.loopProtect = true
	bar:Stop()
	bar.loopProtect = false
	bar.candyBarDuration:SetText("READY")

	bar:SetScript(
		"OnEnter",
		function(_self)
			GameTooltip:SetOwner(_self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(spell_id)
			GameTooltip:Show()
		end
	)

	NUI.ResetCandyBarLabelDurationAnchors(bar)

	self.barCache[category] = self.barCache[category] or {}
	self.barCache[category][spell_id] = self.barCache[category][spell_id] or {}
	self.barCache[category][spell_id][guid] = bar

	bar.category = category
	tinsert(self.bars[category], bar)
	return bar
end

function RCD:GetHolder(category)
	return self.holders[category]
end

function RCD:CreateHolder(category, defaultPoint)
	local holder = CreateFrame("Frame", "NihilistUIRaidCDs_" .. category, E.UIParent, "BackdropTemplate")
	holder:SetSize(self.db.width, self.db.height)
	holder:CreateBackdrop("Transparent")

	if (COMP.MERS) then
		holder:Styling()
	end

	if (COMP.BUI) then
		holder:BuiStyle("Outside")
	end

	local fs = holder:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, "THINOUTLINE")
	fs:SetTextColor(1, 1, 1)
	fs:SetText(self.category_labels[category])
	fs:Point("CENTER")

	holder:SetPoint(unpack(defaultPoint))

	local container = CreateFrame("Frame", holder:GetName() .. "Container", holder)
	container:SetPoint("TOPLEFT", holder, "TOPLEFT")
	container:SetPoint("TOPRIGHT", holder, "TOPRIGHT")
	if ES then
		container:CreateShadow()
		ES:RegisterFrameShadows(container)
	end

	holder.Container = container

	E:CreateMover(
		holder,
		self.category_labels[category] .. "Mover",
		self.category_labels[category],
		nil,
		nil,
		nil,
		"ALL,RAID,NIHILISTUI"
	)

	self.holders[category] = holder
	self.bars[category] = {}
end

function RCD:PositionAllBars()
	for category, _ in pairs(self.categories) do
		self:PositionBars(category)
	end
end

function RCD:PositionBars(category)
	if (not self.bars[category] or #self.bars[category] == 0) then
		self.holders[category]:SetAlpha(0)
		self.holders[category].Container:SetHeight(self.db.height)
		return
	end

	self.holders[category]:SetAlpha(1)
	local function SortBars(barA, barB)
		if (not barA.info.spell_id) then
			return barB.info.spell_id ~= nil
		end

		if barA.info.spell_id ~= barB.info.spell_id then
			return barA.info.spell_id < barB.info.spell_id
		end

		if (not barA.info.guid) then
			return barB.info.guid ~= nil
		end

		local server_idA, player_idA = select(2, strsplit("-", barA.info.guid))
		local server_idB, player_idB = select(2, strsplit("-", barB.info.guid))
		if (player_idA ~= player_idB) then
			return player_idA < player_idB
		end

		if server_idA == server_idB then
			return false
		end

		return server_idA < server_idB
	end

	table.sort(self.bars[category], SortBars)

	for _, bar in ipairs(self.bars[category]) do
		bar:ClearAllPoints()
	end

	local numBars = 0
	for i, bar in ipairs(self.bars[category]) do
		if i == 1 then
			bar:SetPoint("TOP", self:GetHolder(category), "BOTTOM", 0, -2)
		else
			bar:SetPoint("TOP", self.bars[category][i - 1], "BOTTOM", 0, -2)
		end
		numBars = numBars + 1
	end

	self.holders[category].Container:SetHeight(((numBars + 1) * self.db.height) + (2 * numBars))
end

function RCD:Hide()
	for _, holder in pairs(self.holders) do
		holder:Hide()
	end
end

function RCD:Show()
	if (self.db.onlyInCombat and not UnitAffectingCombat("player") and not UnitAffectingCombat("pet")) then
		self:Hide()
		return
	end
	for _, holder in pairs(self.holders) do
		holder:Show()
	end
	self:UpdateCDs()
end
