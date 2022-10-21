local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames

local oUF = _G.ElvUF

local UnitPowerType = _G.UnitPowerType
local Enum_PowerType_Mana = _G.Enum.PowerType.Mana
local CreateFrame = _G.CreateFrame
local hooksecurefunc = _G.hooksecurefunc

-- Power for units it is enabled on
function VUF:ConstructPower(frame)
	self:AddElement(frame, "power")

	local power = self:ConstructStatusBar(frame, "power", nil, nil, nil, true)
	power:SetOrientation("VERTICAL")
	power:SetFrameLevel(frame.Health:GetFrameLevel() + 15)

	power.BG = power:CreateTexture(nil, "BORDER")
	power.BG:SetAllPoints()
	power.BG:SetTexture(E.media.blankTex)

	power.value = self:ConstructFontString(frame, "power", power)

	power.PreUpdate = VUF.PreUpdatePowerVerticalUnitFrame
	power.PostUpdate = VUF.PostUpdatePowerVerticalUnitFrame
	power.PostUpdateColor = UF.PostUpdatePowerColor

	-- Update the Power bar Frequently
	power.frequentUpdates = true

	power.colorTapping = nil
	power.colorPower = nil
	power.colorReaction = nil
	power.colorDisconnected = nil

	hooksecurefunc(
		power,
		"SetStatusBarColor",
		function(_, r, g, b)
			if frame and frame.PowerPrediction and frame.PowerPrediction.mainBar then
				if UF and UF.db and UF.db.colors and UF.db.colors.powerPrediction and UF.db.colors.powerPrediction.enable then
					local color = UF.db.colors.powerPrediction.color
					frame.PowerPrediction.mainBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
				else
					frame.PowerPrediction.mainBar:SetStatusBarColor(r * 1.25, g * 1.25, b * 1.25)
				end
			end
		end
	)

	local clipFrame = CreateFrame('Frame', nil, power)
	clipFrame:SetClipsChildren(true)
	clipFrame:SetAllPoints()
	clipFrame.__frame = frame
	power.ClipFrame = clipFrame

	return power
end

function VUF:PreUpdatePowerVerticalUnitFrame(unit)
	local _, pType = UnitPowerType(unit)

	local color = oUF.colors.power[pType]
	if color then
		self:SetStatusBarColor(color[1], color[2], color[3])
	end
end

local warningTextShown = false
-- luacheck: push no self
function VUF:PostUpdatePowerVerticalUnitFrame(unit, cur, _, max)
	if (max == 0) then
		return
	end
	-- Flash mana below threshold %
	local powerMana, _ = UnitPowerType(unit)
	if (cur / max * 100) < (E.db.nihilistzscheui.vuf.lowThreshold) and (powerMana == Enum_PowerType_Mana) and VUF.db.flash then
		if VUF.db.warningText then
			if not warningTextShown and unit == "player" then
				_G.ElvUIVerticalUnitFramesWarning:AddMessage("|cff00ffffLOW MANA")
				warningTextShown = true
			else
				_G.ElvUIVerticalUnitFramesWarning:Clear()
				warningTextShown = false
			end
		end
	else
		warningTextShown = false
	end
end
-- luacheck: pop

function VUF:PowerOptions(unit)
	return self:GenerateElementOptionsTable(unit, "power", 200, "Power", true, true, true, true, false)
end
