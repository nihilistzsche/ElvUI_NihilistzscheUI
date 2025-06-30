---@class NUI
local NUI = _G.unpack((select(2, ...)))
local COMP = NUI.Compatibility
if not COMP.AS then return end

local AS = _G.unpack(_G.AddOnSkins)
local SASX = NUI.NihilistzscheUIAddOnSkinExtension

local BOEICONTEMPLATE = "BarrelsOEasyTarget%d"
local BOERADIOTEMPLATE = "Radio%d"

function SASX.SkinBarrelsOEasy()
    if not _G.BOEIconFrame then return end
    _G.BOEIconFrame:SetTemplate("Transparent")
    AS:SkinCloseButton(_G.BarrelsOEasyClose)
    for i = 1, 8 do
        local icon = _G[BOEICONTEMPLATE:format(i)]
        local button = _G[BOERADIOTEMPLATE:format(i)]
        local texture = icon:GetTexture()
        local texcoord = { icon:GetTexCoord() }
        AS:SkinCheckBox(button)
        icon:SetTexture(texture)
        icon:SetTexCoord(unpack(texcoord))
    end
end

SASX:RegisterSkin("BarrelsOEasy", "SkinBarrelsOEasy")
