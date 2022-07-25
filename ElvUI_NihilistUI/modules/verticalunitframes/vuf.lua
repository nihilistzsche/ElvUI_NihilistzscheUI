local addon, ns = ...
ns.oUF = _G.ElvUF
local oUF = ns.oUF
local NUI, E, _, _, P = _G.unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames
local LSM = E.Libs.LSM
local COMP = NUI.Compatibility

E.VerticalUnitFrames = VUF

local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local UnitExists = _G.UnitExists
local InCombatLockdown = _G.InCombatLockdown
local GetMouseFocus = _G.GetMouseFocus
local UnitAffectingCombat = _G.UnitAffectingCombat
local tinsert = _G.tinsert
local gsub = _G.gsub
local tContains = _G.tContains
local hooksecurefunc = _G.hooksecurefunc
local GetAddOnMetadata = _G.GetAddOnMetadata

function VUF.CreateWarningFrame()
	local f = CreateFrame("ScrollingMessageFrame", "ElvUIVerticalUnitFramesWarning", UIParent)
	f:SetFont(LSM:Fetch("font", (UF.db or P.unitframe).font), (UF.db or P.unitframe).fontSize * 2, "THINOUTLINE")
	f:SetShadowColor(0, 0, 0, 0)
	f:SetFading(true)
	f:SetFadeDuration(0.5)
	f:SetTimeVisible(0.6)
	f:SetMaxLines(10)
	f:SetSpacing(2)
	f:SetWidth(128)
	f:SetHeight(128)
	f:SetPoint("CENTER", 0, E:Scale(-100))
	f:SetMovable(false)
	f:SetResizable(false)
	--f:SetInsertMode("TOP") -- Bugged currently
end

function VUF.CreateScreenFlash()
	local f = CreateFrame("Frame", "ElvUIVerticalUnitFramesScreenFlash", E.UIParent)
	f:SetToplevel(true)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetAllPoints(E.UIParent)
	f:EnableMouse(false)
	f.texture = f:CreateTexture(nil, "BACKGROUND")
	f.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
	f.texture:SetAllPoints(E.UIParent)
	f.texture:SetBlendMode("ADD")
	f:SetAlpha(0)
end

function VUF:ActivateFrame(frame)
	if (UnitExists(frame.unit)) then
		E:UIFrameFadeIn(frame, 0.2, frame:GetAlpha(), self.db.alpha)
	end
end

function VUF:DeactivateFrame(frame)
	if (InCombatLockdown() or GetMouseFocus() == frame and frame:IsMouseOver(2, -2, -2, 2)) then
		return
	end

	E:UIFrameFadeOut(frame, 0.2, frame:GetAlpha(), self.db.alphaOOC)
end

function VUF:UpdateHideSetting()
	if (self.db.hideOOC) then
		self:EnableHide()
	else
		self:DisableHide()
	end
end

function VUF:UpdateHiddenStatus(frame, event)
	if frame.unit == "target" then
		return
	end
	if not UnitExists(frame.unit) then
		return
	end

	if (event == "PLAYER_REGEN_DISABLED") then
		self:ActivateFrame(frame)
	elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD") then
		self:DeactivateFrame(frame)
	end
end

function VUF.DisableFrame(f)
	f:Hide()
	f:EnableMouse(false)
	f:SetAlpha(0)
end

function VUF.EnableFrame(f, a, m)
	if a == nil then
		a = 1
	end
	if m == nil then
		m = true
	end
	f:Show()
	f:EnableMouse(m)
	f:SetAlpha(a)
end

local elv_units = {"player", "target", "pet", "pettarget", "targettarget", "focus", "focustarget"}
local old_settings = {}

function VUF.UpdateElvUFSetting()
	local value
	if E.db.nihilistui.vuf.enabled then
		value = not E.db.nihilistui.vuf.hideElv
	else
		value = true
	end
	for _, unit in pairs(elv_units) do
		if not value and old_settings[unit] == nil then
			old_settings[unit] = E.db.unitframe.units[unit].enable
		end
		E.db.unitframe.units[unit].enable =
			(value and old_settings[unit] or (E.db.nihilistui.vuf.units[unit].enabled and value)) or value
		UF:CreateAndUpdateUF(unit)
	end
end

function VUF:EnableHide()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:PLAYER_ENTERING_WORLD()
end

function VUF:DisableHide()
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:PLAYER_ENTERING_WORLD()
	for _, f in pairs(self.units) do
		f:SetAlpha(1)
	end
end

function VUF:Enable()
	self.UpdateElvUFSetting()
	for _, f in pairs(self.units) do
		if not self.db.enabled then
			VUF.DisableFrame(f)
		else
			VUF.EnableFrame(f, self.db.alpha, self.db.enableMouse)
		end
	end

	if (self.db.hideOOC) then
		self:EnableHide()
	else
		self:DisableHide()
	end
end

function VUF:UpdateMouseSetting()
	for _, f in pairs(self.units) do
		if self.db.enableMouse or self.db.hideElv then
			f:EnableMouse(true)
		else
			f:EnableMouse(false)
		end
	end
end

function VUF:UpdateAll()
	if UnitAffectingCombat("player") or UnitAffectingCombat("pet") then
		NUI:RegenWait(self.UpdateAll, self)
		return
	end

	self:UpdateAllFrames()
	self:UpdateMouseSetting()
	self:UpdateHideSetting()
	self:Enable()
end

function VUF.ResetFramePositions()
	E:ResetMovers("Focus Vertical Unit Frame")
	E:ResetMovers("Focus Target Vertical Unit Frame")
	E:ResetMovers("Pet Vertical Unit Frame")
	E:ResetMovers("Pet Target Vertical Unit Frame")
	E:ResetMovers("Player Vertical Unit Frame")
	E:ResetMovers("Target Vertical Unit Frame")
	E:ResetMovers("Target Target Vertical Unit Frame")
end

VUF.units = {}

VUF.RegisteredUnits = {}

function VUF:RegisterUnit(unit)
	tinsert(self.RegisteredUnits, unit)
end

function VUF:Initialize()
	NUI:RegisterDB(self, "vuf")
	local ForUpdateAll = function(_self)
		_self:UpdateAll()
	end
	self.ForUpdateAll = ForUpdateAll

	self.CreateWarningFrame()
	self.CreateScreenFlash()

	oUF:RegisterStyle(
		"NihilistUI_VerticalUnitFrames",
		function(frame, unit)
			frame:SetFrameLevel(5)
			VUF:ConstructVerticalUnitFrame(frame, unit)
		end
	)

	oUF:SetActiveStyle("NihilistUI_VerticalUnitFrames")

	local function spawnUnit(unit)
		local stringTitle = E:StringTitle(unit)
		if stringTitle:find("target") then
			stringTitle = gsub(stringTitle, "target", "Target")
		end
		oUF:Spawn(unit, "NihilistUF_" .. stringTitle)
	end

	local needsManualCreate = {"player", "target"}
	for _, unit in ipairs(needsManualCreate) do
		spawnUnit(unit)
	end

	for _, unit in pairs(self.RegisteredUnits) do
		if not tContains(needsManualCreate, unit) then
			spawnUnit(unit)
		end
	end

	hooksecurefunc(
		E,
		"UpdateAll",
		function()
			self:UpdateAll()
		end
	)
	hooksecurefunc(
		UF,
		"Update_AllFrames",
		function()
			self:UpdateAllFrames()
		end
	)

	self:UpdateAll()

	self:RegisterEvent("UNIT_HEALTH")
	if COMP.FCT then
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
	end
	self.version = GetAddOnMetadata(addon, "Version")
end

NUI:RegisterModule(VUF:GetName())
