local NUI, E = _G.unpack((select(2, ...)))
local CB = NUI.CooldownBar

local tinsert = _G.tinsert
local tremove = _G.tremove
local C_Spell_GetSpellTexture = _G.C_Spell.GetSpellTexture
local C_Item_GetItemIconByID = _G.C_Item.GetItemIconByID
local hooksecurefunc = _G.hooksecurefunc
local C_Timer_After = _G.C_Timer.After
local C_Timer_NewTicker = _G.C_Timer.NewTicker

CB.MAX_CB_VAL = math.pow(300, 0.3)

function CB:GetPosition(value)
    local val = math.pow(value, 0.3)
    if not val or type(val) ~= "number" then return 0 end
    local r = val / self.MAX_CB_VAL
    return r > 1 and 1 or r
end

local function DeactivateClosure() CB:Deactivate() end

function CB:Update()
    local framesToRemove = {}

    for _, frame in pairs(self.liveFrames) do
        if frame.type == "spell" and not self:SpellIsOnCooldown(frame.spellID) then
            frame:Hide()
            tinsert(framesToRemove, frame)
        elseif frame.type == "item" and not self:ItemIsOnCooldown(frame.itemID) then
            frame:Hide()
            tinsert(framesToRemove, frame)
        else
            self:UpdateFrame(frame)
            self:Activate()
        end
    end

    local frameFading = false
    for _, frame in pairs(framesToRemove) do
        tremove(self.liveFrames, self:FindIndexForFrame(frame))
        E:UIFrameFadeOut(frame, 0.2, frame:GetAlpha(), 0)
        frameFading = true
        if not frame.Close then
            frame.Close = function()
                frame:Hide()
                frame:SetAlpha(1)
                tinsert(self.usedFrames, frame)
            end
        end

        C_Timer_After(0.2, frame.Close)
    end

    if #self.liveFrames == 0 then
        if not frameFading then
            self:Deactivate()
        else
            C_Timer_After(0.2, DeactivateClosure)
        end
    end
end

-- luacheck: no self
function CB:GetTexture(frame)
    if frame.type == "spell" and frame.SpellID then
        return C_Spell_GetSpellTexture(frame.SpellID)
    elseif frame.itemID then
        return C_Item_GetItemIconByID(frame.itemID)
    end
end

local function RotateClosure() CB:RotateOverlapGroups() end

function CB:Enable(fromSettings)
    self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    self:RegisterEvent("SPELLS_CHANGED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("BAG_UPDATE_COOLDOWN")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("GET_ITEM_INFO_RECEIVED")

    self.bar:SetScript("OnEnter", function() self:Activate() end)
    self.bar:SetScript("OnLeave", function() self:Deactivate() end)
    self.bar:Show()
    _G.RegisterStateDriver(self.bar, "visibility", "[petbattle] hide; show")

    if not fromSettings then
        if not self.ticker then self.ticker = C_Timer_NewTicker(self.db.switchTime, RotateClosure) end
    else
        self:UpdateCache()
        self:UpdateItems()
    end
end

function CB:Disable()
    self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
    self:UnregisterEvent("SPELLS_CHANGED")
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    self:UnregisterEvent("BAG_UPDATE_COOLDOWN")
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("GET_ITEM_INFO_RECEIVED")

    self.bar:SetScript("OnEnter", nil)
    self.bar:SetScript("OnLeave", nil)
    self.bar:Hide()
    _G.RegisterStateDriver(self.bar, "visibility", "hide")
    self:Deactivate()
    if self.ticker then self.ticker:Cancel() end
end

function CB:UpdateSettings()
    if self.db.enabled then
        self:Enable(true)
    else
        self:Disable()
        return
    end

    self.bar:SetAlpha(self.db.alpha)
    if self.ticker then self.ticker:Cancel() end
    self.ticker = C_Timer_NewTicker(self.db.switchTime, RotateClosure)
end

local function UpdateToysClosure() CB:UpdateToys() end

local function UseToyClosure()
    if CB.db.enabled then C_Timer_After(1.5, UpdateToysClosure) end
end

function CB:Initialize()
    self.delta = 0
    self.frameLevelSerial = 0

    NUI:RegisterDB(self, "cooldownBar")
    local ForUpdateAll = function(_self) _self:UpdateSettings() end
    self.ForUpdateAll = ForUpdateAll

    self.db.blacklist = self.db.blacklist or {}
    self.db.blacklist.spells = self.db.blacklist.spells or {}
    self.db.blacklist.items = self.db.blacklist.items or {}

    self.values = { 1, 10, 30, 60, 120, 300 }

    self:CreateBar()
    self:CreateLabels()

    self.liveFrames = {}
    self.usedFrames = {}
    self.overlapGroups = {}

    self.activated = false

    if self.db.enabled then self:Enable() end

    self.cache = {}

    self:UpdateCache()
    self:UpdateItems()

    hooksecurefunc("UseToy", UseToyClosure)
    hooksecurefunc("UseToyByName", UseToyClosure)
end

NUI:RegisterModule(CB:GetName())
