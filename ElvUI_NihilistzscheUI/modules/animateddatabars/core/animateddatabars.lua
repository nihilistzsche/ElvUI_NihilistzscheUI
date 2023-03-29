local NUI, E = _G.unpack((select(2, ...)))

local ADB = NUI.AnimatedDataBars
local DB = E.DataBars
local ES = NUI.EnhancedShadows
local COMP = NUI.Compatibility
local LSM = E.Libs.LSM

local CreateFrame = _G.CreateFrame
local tinsert = _G.tinsert
local unpack = _G.unpack
local hooksecurefunc = _G.hooksecurefunc
local Mixin = _G.Mixin
local C_Timer_After = _G.C_Timer.After

ADB.TickBars = {}

function ADB:CreateTicks(bar)
    bar.ticks = {}
    for i = 1, 19 do
        local tick = CreateFrame("Frame", nil, bar, "BackdropTemplate")
        tick:SetFrameLevel(bar:GetFrameLevel() + 5)
        tick:SetTemplate("Transparent")
        tick:SetPoint("TOPLEFT", i * (bar:GetWidth() / 20), 0)
        tick:EnableMouse(false)
        bar.ticks[i] = tick
    end
    tinsert(ADB.TickBars, bar)
    self:UpdateTicksForBar(bar)
end

function ADB:UpdateTicksForBar(bar)
    for i = 1, 19 do
        local tick = bar.ticks[i]
        tick:Size(self.db.ticks.width, bar:GetHeight() / 2)
        tick:SetAlpha(self.db.ticks.alpha)
        tick:SetShown(self.db.ticks.enabled)
    end
end

function ADB:UpdateTicks()
    for _, bar in ipairs(self.TickBars) do
        self:UpdateTicksForBar(bar)
    end
end

function ADB:CreateAnimatedBar(tbl, key)
    local bar = DB.StatusBars[key]
    local holder = bar.holder

    holder:SetTemplate("Transparent")
    if COMP.MERS then holder:Styling() end
    if not holder.shadow then holder:CreateShadow() end
    ES:RegisterFrameShadows(holder)
    local color = { bar:GetStatusBarColor() }
    local value = bar:GetValue()
    local min, max = bar:GetMinMaxValues()
    local level = tbl:GetLevel()
    bar:Kill()

    local db = DB.db[string.lower(key)]

    local animatedStatusBar = CreateFrame("StatusBar", nil, bar.holder, "AnimatedStatusBarTemplate")
    animatedStatusBar:SetInside()
    animatedStatusBar:SetStatusBarTexture(E.media.normTex)
    local oldSSBC = animatedStatusBar.SetStatusBarColor
    animatedStatusBar.SetStatusBarColor = function(_self, ...)
        oldSSBC(_self, ...)
        _self:SetAnimatedTextureColors(...)
    end
    animatedStatusBar:SetStatusBarColor(unpack(color))
    local orientation = db.orientation
    if orientation == "AUTOMATIC" then orientation = bar:GetOrientation() end
    animatedStatusBar:SetOrientation(orientation)
    animatedStatusBar:SetAnimatedValues(value, min, max, level)
    animatedStatusBar:ProcessChangesInstantly()
    if key == "Experience" then animatedStatusBar:GetStatusBarTexture():SetDrawLayer("ARTWORK", 4) end
    animatedStatusBar:EnableMouse(true)
    animatedStatusBar:SetScript("OnEnter", function() (bar.holder:GetScript("OnEnter"))(bar.holder) end)
    animatedStatusBar:SetScript("OnLeave", function() (bar.holder:GetScript("OnLeave"))(bar.holder) end)
    E:RegisterStatusBar(animatedStatusBar)
    bar.textFrame = CreateFrame("Frame", nil, animatedStatusBar)
    bar.textFrame:SetAllPoints()
    bar.textFrame:SetFrameLevel(bar:GetFrameLevel() + 5)
    bar.textFrame:Show()
    bar.text = bar.textFrame:CreateFontString(nil, "OVERLAY")
    bar.text:FontTemplate(LSM:Fetch("font", db.font), db.fontSize, "THINOUTLINE")
    bar.text:Point("CENTER", 0, 0)
    bar.animatedStatusBar = animatedStatusBar
    bar.barTexture = animatedStatusBar:GetStatusBarTexture()
    if key == "Reputation" then bar.Reward:SetParent(bar.animatedStatusBar) end
    self:CreateTicks(holder)
    hooksecurefunc(DB, key .. "Bar_Update", function() tbl:Update(bar) end)
    C_Timer_After(2, function() tbl:Update(bar) end)
end

ADB.RegisteredDataBars = {}

local prototype = { parent = ADB }

function prototype:GetParent() return self.parent end

function prototype:GetLevel() return self.levelFunc() end

function prototype:Update(bar)
    local cur = self.curFunc()
    local max = self.maxFunc()
    local level = self.levelFunc()

    bar.animatedStatusBar:SetAnimatedValues(cur, 0, max, level)
end

function ADB:NewDataBar(curFunc, maxFunc, levelFunc)
    if curFunc then
        return Mixin({
            curFunc = curFunc,
            maxFunc = maxFunc,
            levelFunc = levelFunc,
        }, prototype)
    else
        return {
            GetParent = function(_) return self end,
        }
    end
end

function ADB:RegisterDataBar(tbl) tinsert(self.RegisteredDataBars, tbl) end

function ADB:InitializeDataBars()
    for _, tbl in pairs(self.RegisteredDataBars) do
        tbl:Initialize()
    end
end

function ADB:Initialize()
    NUI:RegisterDB(self, "animateddatabars")
    local ForUpdateAll = function(_self) _self:UpdateTicks() end
    self.ForUpdateAll = ForUpdateAll

    self:InitializeDataBars()
end

NUI:RegisterModule(ADB:GetName())
