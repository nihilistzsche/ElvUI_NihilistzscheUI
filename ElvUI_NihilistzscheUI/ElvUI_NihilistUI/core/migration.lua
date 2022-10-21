--
-- Created by IntelliJ IDEA.
-- User: mtindal
-- Date: 9/4/2017
-- Time: 1:56 PM
-- To change this template use File | Settings | File Templates.
--

local NUI, E = _G.unpack(select(2, ...))

local NM = NUI.Migration

local moversToCheck = {
	"UI_SpecSwitchBar",
	"UI_PartyXPHolder",
	"UI_EquipmentSetsMover",
	"UI_ToyBarMover",
	"UI_PortalBarMover",
	"UI_ProfessionBarMover",
	"UF_PlayerVerticalFrame AuraBar Mover",
	"UF_TargetVerticalFrame AuraBar Mover",
	"UF_PlayerVerticalUnitFrame Castbar Mover",
	"UF_TargetVerticalUnitFrame Castbar Mover"
}

function NM:CheckMigrations()
	if (not E.db.nihilistui.migrated and E.db.nenaui) then
		E:CopyTable(E.db.nihilistui, E.db.nenaui)
		E.db.nihilistui.nihilistchat = E:CopyTable(E.db.nenaui.nenachat)
		E.db.nenaui.nenachat = nil

		for _, mover in ipairs(moversToCheck) do
			if (E.db.movers["Nena" .. mover]) then
				self.SaveMoverPosition("Nihilist" .. mover, unpack(E.db.movers["Nena" .. mover]))
				E.db.movers["Nena" .. mover] = nil
			end
		end

		E.db.nihilistui.migrated = true

		E.db.nenaui = nil
	end
	if (not E.db.nihilistui.migrated and E.db.chaoticui) then
		E:CopyTable(E.db.nihilistui, E.db.chaoticui)
		E.db.nihilistui.nihilistchat = E:CopyTable(E.db.chaoticui.chaoticchat)
		E.db.nihilistui.chaoticchat = nil
		for _, mover in ipairs(moversToCheck) do
			if (E.db.movers["Chaotic" .. mover]) then
				self.SaveMoverPosition("Nihilist" .. mover, unpack(E.db.movers["Chaotic" .. mover]))
				E.db.movers["Chaotic" .. mover] = nil
			end
		end

		E.db.nihilistui.migrated = true

		E.db.chaoticui = nil
	end

	if
		((not E.db.nihilistui.migrated or type(E.db.nihilistui.migrated) ~= "table" or not E.db.nihilistui.migrated.wbn) and
			E.db.nihilistui.wbn)
	 then
		if (E.db.nihilistui.migrated and type(E.db.nihilistui.migrated) ~= "table") then
			E.db.nihilistui.migrated = {}
		end
		E.db.nihilistui.migrated = E.db.nihilistui.migrated or {}
		E:CopyTable(E.db.nihilistui.dbn, E.db.nihilistui.wbn)
		E.db.nihilistui.wbn = nil
		E.db.nihilistui.migrated.wbn = true
	end

	if
		((not E.db.nihilistui.migrated or type(E.db.nihilistui.migrated) ~= "table" or not E.db.nihilistui.migrated.vuf) and
			E.db.nihilistui.vuf)
	 then
		if (E.db.nihilistui.migrated and type(E.db.nihilistui.migrated) ~= "table") then
			E.db.nihilistui.migrated = {}
		end
		E.db.nihilistui.migrated = E.db.nihilistui.migrated or {}

		local elements = {
			{"resting", "restingindicator"},
			{"combat", "combatindicator"},
			{"pvp", "pvptext"},
			{"resurrecticon", "resurrectindicator"}
		}

		for _, p in pairs(elements) do
			local old = p[1]
			local new = p[2]

			if (not E.db.nihilistui.vuf.units.player[new] and E.db.nihilistui.vuf.units.player[old]) then
				E:CopyTable(E.db.nihilistui.vuf.units.player[new], E.db.nihilistui.vuf.units.player[old])
				E.db.nihilistui.vuf.units.player[old] = nil
			end
		end

		E.db.nihilistui.migrated.vuf = true
	end

	if
		-- luacheck: no max line length
		((not E.db.nihilistui.migrated or type(E.db.nihilistui.migrated) ~= "table" or not E.db.nihilistui.migrated.installer) and
			E.db.nihilistui.installer)
	 then
		if (E.db.nihilistui.migrated and type(E.db.nihilistui.migrated) ~= "table") then
			E.db.nihilistui.migrated = {}
		end
		E:CopyTable(E.global.nihilistui.installer, E.db.nihilistui.installer)
		E.db.nihilistui.installer = nil
		E.db.nihilistui.migrated.installer = true
	end

	if
		((not E.db.nihilistui.migrated or type(E.db.nihilistui.migrated) ~= "table" or not E.db.nihilistui.migrated.dbn) and
			E.db.nihilistui.cbn)
	 then
		if (E.db.nihilistui.migrated and type(E.db.nihilistui.migrated) ~= "table") then
			E.db.nihilistui.migrated = {}
		end
		E:CopyTable(E.db.nihilistui.databarnotifier, E.db.nihilistui.cbn)
		E.db.nihilistui.cbn = nil
		E.db.nihilistui.migrated.dbn = true
	end
end
