local NUI, E = _G.unpack(select(2, ...))
local LSM = E.Libs.LSM

local CreateFrame = _G.CreateFrame
local EnumerateFrames = _G.EnumerateFrames

local backdropr, backdropg, backdropb, borderr, borderg, borderb = 0, 0, 0, 0, 0, 0

local function CreateInvertedShadow(f)
	if f.invertedshadow then
		return
	end

	local shadow = CreateFrame("Frame", nil, f, "BackdropTemplate")
	shadow:SetFrameLevel(f:GetFrameLevel() + 2)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetInside(f, -4, -4)
	shadow:SetBackdrop(
		{
			edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"),
			edgeSize = E:Scale(7),
			insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)}
		}
	)
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.9)
	shadow.inverted = true

	f.invertedshadow = shadow
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.CreateInvertedShadow then
		mt.CreateInvertedShadow = CreateInvertedShadow
	end
end

local handled = {Frame = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

local IS = NUI.InvertedShadows
function IS.Initialize()
end
NUI:RegisterModule(IS:GetName())
