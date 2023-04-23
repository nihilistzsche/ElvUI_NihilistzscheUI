local NUI = _G.unpack((select(2, ...)))

local LibStub = _G.LibStub

local MD = NUI.NihilistzscheUIMedia
local LSM3 = LibStub("LibSharedMedia-3.0", true)
local LSM2 = LibStub("LibSharedMedia-2.0", true)
local SML = LibStub("SharedMedia-1.0", true)

local tinsert = _G.tinsert

function MD:Register(mediatype, key, data, langmask)
    if LSM3 then LSM3:Register(mediatype, key, data, langmask) end
    if LSM2 then LSM2:Register(mediatype, key, data) end
    if SML then SML:Register(mediatype, key, data) end
    if not self.registry[mediatype] then self.registry[mediatype] = {} end
    tinsert(self.registry[mediatype], { key, data, langmask })
end

function MD:AddTextures()
    self:Register("statusbar", "Aluminium", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Aluminium.tga]])
    self:Register("statusbar", "Armory", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Armory.tga]])
    self:Register("statusbar", "BantoBar", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\BantoBar.tga]])
    self:Register("statusbar", "Glaze2", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Glaze2.tga]])
    self:Register("statusbar", "Gloss", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Gloss.tga]])
    self:Register("statusbar", "Graphite", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Graphite.tga]])
    self:Register("statusbar", "Grid", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Grid.tga]])
    self:Register("statusbar", "Healbot", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Healbot.tga]])
    self:Register("statusbar", "LiteStep", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\LiteStep.tga]])
    self:Register("statusbar", "Minimalist", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Minimalist.tga]])
    self:Register("statusbar", "Otravi", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Otravi.tga]])
    self:Register("statusbar", "Outline", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Outline.tga]])
    self:Register("statusbar", "Perl", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Perl.tga]])
    self:Register("statusbar", "Round", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Round.tga]])
    self:Register("statusbar", "Skyline", [[Interface\\AddOns\ElvUI_NihilistzscheUI\media\textures\Skyline.tga]])
    self:Register("statusbar", "Smooth", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Smooth.tga]])
    self:Register("statusbar", "normTex", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\normTex.tga]])
    self:Register("statusbar", "Rainbow1", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Rainbow1]])
    self:Register("statusbar", "Rainbow2", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\Rainbow2]])
    self:Register("statusbar", "Simpy Gloss 1", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex1]])
    self:Register("statusbar", "Simpy Sword", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex2]])
    self:Register("statusbar", "Simpy Beam", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex3]])
    self:Register("statusbar", "Simpy Storm", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex4]])
    self:Register("statusbar", "Simpy Crater", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex5]])
    self:Register("statusbar", "Simpy Strokes", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex6]])
    self:Register("statusbar", "Simpy Sponge", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex7]])
    self:Register("statusbar", "Simpy Simple 1", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex8]])
    self:Register("statusbar", "Simpy Grudge", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex9]])
    self:Register("statusbar", "Simpy Grass", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex10]])
    self:Register("statusbar", "Simpy Explosion", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex11]])
    self:Register(
        "statusbar",
        "Simpy Water Paper",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex12]]
    )
    self:Register(
        "statusbar",
        "Simpy Dark Strokes",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex13]]
    )
    self:Register("statusbar", "Simpy Dry Swirl", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex14]])
    self:Register(
        "statusbar",
        "Simpy Crosshatch",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex15]]
    )
    self:Register(
        "statusbar",
        "Simpy Double Dragon",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex16]]
    )
    self:Register(
        "statusbar",
        "Simpy Single Dragon",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex17]]
    )
    self:Register("statusbar", "Simpy Split Ice", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex18]])
    self:Register(
        "statusbar",
        "Simpy Water Droplets",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex19]]
    )
    self:Register(
        "statusbar",
        "Simpy Paw Prints",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\textures\simpy_tex20]]
    )
end

function MD:AddFonts()
    self:Register("font", "ABF", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\ABF.ttf]])
    self:Register(
        "font",
        "Accidental Presidency",
        [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Accidental Presidency.ttf]]
    )
    self:Register("font", "Adventure", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Adventure.ttf]])
    self:Register("font", "Avqest", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Avqest.ttf]])
    self:Register("font", "Bazooka", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Bazooka.ttf]])
    self:Register(
        "font",
        "BigNoodleTitling-Oblique",
        [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\BigNoodleTitling-Oblique.ttf]]
    )
    self:Register(
        "font",
        "BigNoodleTitling",
        [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\BigNoodleTitling.ttf]]
    )
    self:Register("font", "BlackChancery", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\BlackChancery.ttf]])
    self:Register("font", "Colaborate", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\fonts\ColabReg.ttf]])
    self:Register("font", "Emblem", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Emblem.ttf]])
    self:Register("font", "Enigma__2", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Enigma__2.ttf]])
    self:Register(
        "font",
        "Movie_Poster-Bold",
        [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Movie_Poster-Bold.ttf]]
    )
    self:Register("font", "Porky", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Porky.ttf]])
    self:Register("font", "Skull and Void", [[Interface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Skull-and-Void.ttf]])
    self:Register("font", "Tangerin", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Tangerin.ttf]])
    self:Register("font", "Tw_Cen_MT_Bold", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Tw_Cen_MT_Bold.ttf]])
    self:Register(
        "font",
        "Ultima_Campagnoli",
        [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Ultima_Campagnoli.ttf]]
    )
    self:Register("font", "VeraSe", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\VeraSe.ttf]])
    self:Register("font", "Yellowjacket", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\Yellowjacket.ttf]])
    self:Register("font", "rm_midse", [[Inteface\AddOns\ElvUI_NihilistzscheUI\media\fonts\rm_midse.ttf]])
    self:Register(
        "font",
        "Source Sans Pro",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\fonts\SourceSansPro-Regular.ttf]]
    )
    self:Register(
        "font",
        "Xpaider Pixel Explosion 01",
        [[Interface\AddOns\ElvUI_NihilistzscheUI\media\fonts\XPAIDERP.TTF]]
    )
    for _, weight in pairs({ "Bold", "Medium", "Regular" }) do
        self:Register(
            "font",
            "Fira Mono " .. weight,
            [[|TInterface\AddOns\ElvUI_NihilistzscheUI\media\fonts\FiraMono-]] .. weight .. ".ttf"
        )
    end
end

MD.registry = {}
MD:AddTextures()
MD:AddFonts()

NUI:RegisterModule(MD:GetName())
