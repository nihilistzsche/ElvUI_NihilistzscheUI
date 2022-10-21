--
-- Created by IntelliJ IDEA.
-- User: mtindal
-- Date: 8/29/2017
-- Time: 10:50 PM
-- To change this template use File | Settings | File Templates.
--

local NUI, E = _G.unpack(select(2, ...))

local AL = NUI.AutoLog

local IsInInstance = _G.IsInInstance
local GetInstanceInfo = _G.GetInstanceInfo
local tContains = _G.tContains

-- Garrisons
local ignoredInstanceMapIDs = {
	1152,
	1330,
	1153,
	1154,
	1158,
	1331,
	1159,
	1160
}

-- Order Halls
local ignoredMapIDs = {
	1068,
	1052,
	1040,
	1035,
	1077,
	1057,
	1044,
	1072
}

function AL:LoggingCombat(arg)
	if arg ~= nil then
		self.loggingCombat = arg
	else
		return self.loggingCombat
	end
end

function AL:DisableCombatLogging()
	print("|cffff2020Combat logging off.|r")
	self:LoggingCombat(false)
end

function AL:EnableCombatLogging()
	print("|cff20ff20Combat logging on.|r")
	self:LoggingCombat(true)
end

function AL:CheckInstance(instanceType)
	if (instanceType == "none") then
		return
	end

	if self.db[instanceType] then
		return true
	end
end

function AL:PLAYER_ENTERING_WORLD()
	local inInstance, instanceType = IsInInstance()
	if (not inInstance) then
		if (self:LoggingCombat()) then
			self:DisableCombatLogging()
		end
		return
	end

	local instanceMapID = select(8, GetInstanceInfo())
	local currentMapAreaID = E.MapInfo.mapID

	if (tContains(ignoredInstanceMapIDs, instanceMapID) or tContains(ignoredMapIDs, currentMapAreaID)) then
		if self:LoggingCombat() then
			self:DisableCombatLogging()
		end
		return
	end

	if (AL:CheckInstance(instanceType)) then
		self:EnableCombatLogging()
	end
end

function AL:PLAYER_LOGOUT()
	self:DisableCombatLogging()
end

function AL:UpdateEnabled()
	if (not self.db.enabled) then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("PLAYER_LOGOUT")
		if (self:LoggingCombat()) then
			self:DisableCombatLogging()
		end
	else
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_LOGOUT")
		self:PLAYER_ENTERING_WORLD()
	end
end

function AL:Initialize()
	NUI:RegisterDB(self, "autolog")
	local ForUpdateAll = function(_self)
		_self:UpdateEnabled()
	end
	self.ForUpdateAll = ForUpdateAll

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LOGOUT")

	self:UpdateEnabled()
end

NUI:RegisterModule(AL:GetName())
