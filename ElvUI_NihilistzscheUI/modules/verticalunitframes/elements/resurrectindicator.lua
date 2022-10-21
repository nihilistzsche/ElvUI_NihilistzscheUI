local NUI = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames

function VUF:ConstructResurrectIndicator(frame)
	self:AddElement(frame, "resurrectindicator")
	local tex = frame:CreateTexture(nil, "OVERLAY")
	tex:Point("CENTER", frame.Health, "CENTER")
	tex:Size(30, 25)
	tex:SetDrawLayer("OVERLAY", 7)

	return tex
end

function VUF:ResurrectIndicatorOptions(unit)
	return self:GenerateElementOptionsTable(
		unit,
		"resurrectindicator",
		950,
		"Resurrect Indicator",
		false,
		false,
		false,
		false,
		false
	)
end
