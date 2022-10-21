-------------------------------------------------------------------------------
-- ElvUI Companions Datatext By Lockslap
-------------------------------------------------------------------------------
local _, E, L = _G.unpack(select(2, ...))
local DT = E.DataTexts

local CreateFrame = _G.CreateFrame
local F = CreateFrame("frame")

local wipe = _G.wipe
local tinsert = table.insert
local join = _G.string.join
local C_MountJournal_GetDisplayedMountInfo = _G.C_MountJournal.GetDisplayedMountInfo
local C_MountJournal_GetMountInfoByID = _G.C_MountJournal.GetMountInfoByID
local C_MountJournal_GetNumDisplayedMounts = _G.C_MountJournal.GetNumDisplayedMounts
local C_MountJournal_GetNumMounts = _G.C_MountJournal.GetNumMounts
local C_MountJournal_SummonByID = _G.C_MountJournal.SummonByID
local C_Timer_After = _G.C_Timer.After
local GetSpecialization = _G.GetSpecialization
local GetSpecializationInfo = _G.GetSpecializationInfo
local IsAltKeyDown = _G.IsAltKeyDown
local IsControlKeyDown = _G.IsControlKeyDown
local IsShiftKeyDown = _G.IsShiftKeyDown
local DEFAULT_CHAT_FRAME = _G.DEFAULT_CHAT_FRAME
local MountJournal_Pickup = _G.MountJournal_Pickup
local UIDropDownMenu_AddButton = _G.UIDropDownMenu_AddButton
local CopyTable = _G.CopyTable
local IsFlyableArea = _G.IsFlyableArea
local ToggleDropDownMenu = _G.ToggleDropDownMenu
local ToggleCollectionsJournal = _G.ToggleCollectionsJournal
local GetNumSpecializations = _G.GetNumSpecializations
local IsSpellKnown = _G.IsSpellKnown

local menu = {}

local displayString = ""
local hexColor = "|cff00ff96"

local db = {}

local function GetCurrentMount()
	local numMounts = C_MountJournal_GetNumDisplayedMounts()
	if numMounts == 0 then
		return false, false
	end
	for i = 1, numMounts do
		local name, _, _, isActive = C_MountJournal_GetDisplayedMountInfo(i)
		if isActive then
			return i, name
		end
	end
	return false, false
end

local function UpdateDisplay(self)
	local curMount, name = GetCurrentMount()
	if curMount and name then
		self.text:SetFormattedText(displayString, name)
		db.id = curMount
		db.text = name
	else
		self.text:SetText(("%s"):format(L.Mounts))
	end
end

local function ModifiedClick(_, id)
	local specID, specname = GetSpecializationInfo(GetSpecialization())
	if (not db.specFavs[specID]) then
		db.specFavs[specID] = {}
	end
	local name, _, _, _, _ = C_MountJournal_GetMountInfoByID(id)
	if not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
		C_MountJournal_SummonByID(id)
	elseif IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
		db.specFavs[specID].favFlyer = id
		DEFAULT_CHAT_FRAME:AddMessage(
			(L["%sMounts:|r %s added as flying favorite. (%s)"]):format(hexColor, name, specname),
			1,
			1,
			1
		)
	elseif not IsShiftKeyDown() and IsControlKeyDown() and not IsAltKeyDown() then
		db.specFavs[specID].favGround = id
		DEFAULT_CHAT_FRAME:AddMessage(
			(L["%sMounts:|r %s added as ground favorite. (%s)"]):format(hexColor, name, specname),
			1,
			1,
			1
		)
	elseif not IsShiftKeyDown() and not IsControlKeyDown() and IsAltKeyDown() then
		db.favAlt = id
		DEFAULT_CHAT_FRAME:AddMessage((L["%sMounts:|r %s added as alternate favorite."]):format(hexColor, name), 1, 1, 1)
	else
		MountJournal_Pickup(id)
	end
end

local function ClearFavorites()
	db.specFavs = {}
	db.favAlt = nil
	DEFAULT_CHAT_FRAME:AddMessage((L["%sMounts:|r Favorites Cleared"]):format(hexColor))
end

local specialMounts = {522} -- Sky Golem

local expertRidingSpellID = 34090
local artisanRidingSpellID = 34091
local masterRidingSpellID = 90265

_G.SummonFavoriteMount = function()
	local specID = GetSpecializationInfo(GetSpecialization())
	local isSpellKnown = IsSpellKnown(expertRidingSpellID) or IsSpellKnown(artisanRidingSpellID) or IsSpellKnown(masterRidingSpellID)
	if (isSpellKnown and IsFlyableArea()) and db.specFavs[specID] and db.specFavs[specID].favFlyer then
		C_MountJournal_SummonByID(db.specFavs[specID].favFlyer)
	elseif db.specFavs[specID] and db.specFavs[specID].favGround then
		C_MountJournal_SummonByID(db.specFavs[specID].favGround)
	end
end

local function SummonSkyGolem()
	if (select(11, C_MountJournal_GetMountInfoByID(522))) then
		C_MountJournal_SummonByID(522)
	end
end

local function AddSpecialMounts(_, level)
	for _, id in ipairs(specialMounts) do
		local name, _, icon, active, _, _, _, _, _, _, isCollected, _ = C_MountJournal_GetMountInfoByID(id)
		if (isCollected) then
			menu.text = name
			menu.icon = icon
			menu.colorCode = active == 1 and hexColor or "|cffffffff"
			menu.func = ModifiedClick
			menu.arg1 = id
			menu.hasArrow = false
			menu.notCheckable = true
			UIDropDownMenu_AddButton(menu, level)
		end
	end
end

local function AddFavorites(self, level)
	local specID = GetSpecializationInfo(GetSpecialization())
	if (not db.specFavs[specID]) then
		return
	end

	if db.specFavs[specID].favFlyer ~= nil then
		local name, _, icon, active, _ = C_MountJournal_GetMountInfoByID(db.specFavs[specID].favFlyer)
		menu.text = ("Flying: %s"):format(name)
		menu.icon = icon
		menu.colorCode = active == 1 and hexColor or "|cffffffff"
		menu.func = ModifiedClick
		menu.arg1 = db.specFavs[specID].favFlyer
		menu.hasArrow = false
		menu.notCheckable = true
		UIDropDownMenu_AddButton(menu, level)
	end

	-- favorite two
	if db.specFavs[specID].favGround ~= nil then
		local name, _, icon, active, _ = C_MountJournal_GetMountInfoByID(db.specFavs[specID].favGround)
		menu.text = ("Ground: %s"):format(name)
		menu.icon = icon
		menu.colorCode = active == 1 and hexColor or "|cffffffff"
		menu.func = ModifiedClick
		menu.arg1 = db.specFavs[specID].favGround
		menu.hasArrow = false
		menu.notCheckable = true
		UIDropDownMenu_AddButton(menu, level)
	end

	-- favorite three
	if db.favAlt ~= nil then
		local name, _, icon, active, _ = C_MountJournal_GetMountInfoByID(db.favAlt)
		menu.text = ("Alternate: %s"):format(name)
		menu.icon = icon
		menu.colorCode = active == 1 and hexColor or "|cffffffff"
		menu.func = ModifiedClick
		menu.arg1 = db.favAlt
		menu.hasArrow = false
		menu.notCheckable = true
		UIDropDownMenu_AddButton(menu, level)
	end

	AddSpecialMounts(self, level)
end

local function CreateMenu(self, level)
	local numMounts = C_MountJournal_GetNumMounts()
	menu = wipe(menu)

	if numMounts == 0 then
		return
	elseif numMounts <= 20 then
		for i = 1, numMounts do
			local name, _, icon, active, _, _, _, _, _, _, isCollected, id = C_MountJournal_GetDisplayedMountInfo(i)
			if (isCollected) then
				menu.hasArrow = false
				menu.notCheckable = true
				menu.text = name
				menu.icon = icon
				menu.colorCode = active == 1 and hexColor or "|cffffffff"
				menu.func = ModifiedClick
				menu.arg1 = id
				UIDropDownMenu_AddButton(menu)
			end
		end
		AddFavorites(self, level)
	else
		local function CollectMountsByFirstChar(firstChar)
			local mounts = {}
			for i = 1, numMounts do
				local name, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal_GetDisplayedMountInfo(i)
				if name and isCollected and name:sub(1, 1):upper() == firstChar then
					tinsert(mounts, i)
				end
			end
			return mounts
		end

		local depthByKey = {}
		local countByKey = {}
		local key = "A"
		local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZA"
		repeat
			local count = #(CollectMountsByFirstChar(key))
			depthByKey[key] = (count / 16) + 1
			countByKey[key] = count
			key = alphabet:match(key .. "(.)")
		until key == "A"

		level = level or 1

		if level == 1 then
			key = "A"
			alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZA"
			repeat
				if (countByKey[key] > 0) then
					for i = 1, depthByKey[key] do
						menu.text = key
						menu.notCheckable = true
						menu.hasArrow = true
						menu.value = {["Level1_Key"] = key, ["Level1_Depth"] = i}
						UIDropDownMenu_AddButton(menu, level)
					end
				end
				key = alphabet:match(key .. "(.)")
			until key == "A"
			AddFavorites(self, level)
		elseif level == 2 then
			local Level1_Key = _G.UIDROPDOWNMENU_MENU_VALUE.Level1_Key
			local Level1_Depth = _G.UIDROPDOWNMENU_MENU_VALUE.Level1_Depth
			local mounts = CollectMountsByFirstChar(Level1_Key)
			local depthMod = 1 + ((Level1_Depth - 1) * 16)
			for k = depthMod, depthMod + 15 do
				if (mounts[k]) then
					local name, _, icon, active, _, _, _, _, _, _, isCollected, id = C_MountJournal_GetDisplayedMountInfo(mounts[k])
					if (name) then
						if (isCollected) then
							menu.text = name
							menu.icon = icon
							menu.colorCode = active == 1 and hexColor or "|cffffffff"
							menu.func = ModifiedClick
							menu.arg1 = id
							menu.hasArrow = false
							menu.notCheckable = true

							UIDropDownMenu_AddButton(menu, level)
						end
					end
				else
					break
				end
			end
		end
	end
end

local interval = 1
local function OnUpdate(self, elapsed)
	--if not self.lastUpdate then self.lastUpdate = 0 end
	self.lastUpdate = self.lastUpdate and self.lastUpdate + elapsed or 0
	if self.lastUpdate >= interval then
		UpdateDisplay(self)
		self.lastUpdate = 0
	end
end

local function OnClick(self, button)
	DT.tooltip:Hide()
	if IsAltKeyDown() and IsShiftKeyDown() then
		_G.SummonRandomStrider()
	elseif IsAltKeyDown() and IsControlKeyDown() then
		SummonSkyGolem()
	elseif IsAltKeyDown() then
		if (db.favAlt) then
			C_MountJournal_SummonByID(db.favAlt)
		end
	elseif button == "RightButton" then
		ToggleDropDownMenu(1, nil, F, self, 0, 0)
	elseif button == "LeftButton" then
		if IsShiftKeyDown() then
			_G.SummonFavoriteMount()
		else
			ToggleCollectionsJournal(1)
		end
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	DT.tooltip:AddLine((L["%sElvUI|r NihilistUI - Mounts Datatext"]):format(hexColor), 1, 1, 1)
	DT.tooltip:AddLine(("     %s"):format(L["<Left Click> to open Pet Journal."]))
	DT.tooltip:AddLine(("     %s"):format(L["<Right Click> to open mount list."]))
	DT.tooltip:AddLine(
		("     %s"):format(
			L["<Shift + Left Click> to summon your favorite flying or ground mount based on your ability in the current zone."]
		)
	)
	DT.tooltip:AddLine(("     %s"):format(L["<Alt + Click> to summon your favorite alternate mount."]))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(("     %s"):format(L["<Left Click> a mount to summon it."]))
	DT.tooltip:AddLine(("     %s"):format(L["<Right Click> a mount to pick it up."]))
	DT.tooltip:AddLine(("     %s"):format(L["<Shift + Click> a mount to set as your favorite flying mount."]))
	DT.tooltip:AddLine(("     %s"):format(L["<Ctrl + Click> a mount to set as your favorite ground mount."]))
	DT.tooltip:AddLine(("     %s"):format(L["<Alt + Click> a mount to set as your favorite alternate mount."]))
	if C_MountJournal_GetNumMounts() == 0 then
		DT.tooltip:AddLine("|cffff0000You have no mounts!|r")
	else
		DT.tooltip:AddLine(("|cff00ff00You have %d mounts.|r"):format(C_MountJournal_GetNumMounts()))
	end
	DT.tooltip:Show()
end

local function MigrateMounts()
	if (not db.favAlt) then
		if (GetNumSpecializations() == 0) then
			C_Timer_After(1, MigrateMounts)
			return
		end
		for i = 1, GetNumSpecializations() do
			local specID = GetSpecializationInfo(i)
			db.specFavs[specID] = {}
			db.specFavs[specID].favFlyer = db.favOne
			db.specFavs[specID].favGround = db.favTwo
		end
		db.favAlt = db.favThree
		db.favOne = nil
		db.favTwo = nil
		db.favThree = nil
	end
end

local function ValueColorUpdate(hex)
	displayString = join("", hex, "%s|r")
	hexColor = hex
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

_G.SLASH_MCF1 = "/mcf"
_G.SlashCmdList.MCF = ClearFavorites

F:RegisterEvent("PLAYER_ENTERING_WORLD")
F:SetScript(
	"OnEvent",
	function(self)
		db = E.private.nihilistui.mounts
		if (not db.favAlt) then
			MigrateMounts()
		end
		self.initialize = CreateMenu
		self.displayMode = "MENU"
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
)

DT:RegisterDatatext(
	L.Mounts,
	'NihilistUI',
	{"PLAYER_ENTERING_WORLD", "COMPANION_UPDATE", "PET_JOURNAL_LIST_UPDATE"},
	UpdateDisplay,
	OnUpdate,
	OnClick,
	OnEnter
)
