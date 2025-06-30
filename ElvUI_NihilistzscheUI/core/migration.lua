--
-- Created by IntelliJ IDEA.
-- User: mtindal
-- Date: 9/4/2017
-- Time: 1:56 PM
-- To change this template use File | Settings | File Templates.
--

---@class NUI
local NUI, E = _G.unpack((select(2, ...)))

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
    "UF_TargetVerticalUnitFrame Castbar Mover",
}

function NM:CheckMigrations()
    if not E.db.nihilistzscheui.migrated and E.db.nenaui then
        E:CopyTable(E.db.nihilistzscheui, E.db.nenaui)
        E.db.nihilistzscheui.nihilistzschechat = E:CopyTable(E.db.nenaui.nenachat)
        E.db.nenaui.nenachat = nil

        for _, mover in ipairs(moversToCheck) do
            if E.db.movers["Nena" .. mover] then
                self:SaveMoverPosition("Nihilistzsche" .. mover, unpack(E.db.movers["Nena" .. mover]))
                E.db.movers["Nena" .. mover] = nil
            end
        end

        E.db.nihilistzscheui.migrated = true

        E.db.nenaui = nil
    end
    if not E.db.nihilistzscheui.migrated and E.db.chaoticui then
        E:CopyTable(E.db.nihilistzscheui, E.db.chaoticui)
        E.db.nihilistzscheui.nihilistzschechat = E:CopyTable(E.db.chaoticui.chaoticchat)
        E.db.nihilistzscheui.chaoticchat = nil
        for _, mover in ipairs(moversToCheck) do
            if E.db.movers["Chaotic" .. mover] then
                self:SaveMoverPosition("Nihilistzsche" .. mover, unpack(E.db.movers["Chaotic" .. mover]))
                E.db.movers["Chaotic" .. mover] = nil
            end
        end

        E.db.nihilistzscheui.migrated = true

        E.db.chaoticui = nil
    end

    if not E.db.nihilistzscheui.migrated and E.db.nihilistui then
        E:CopyTable(E.db.nihilistzscheui, E.db.nihilistui)
        E.db.nihilistzscheui.nihilistzschechat = E:CopyTable(E.db.nihilistui.nihilistchat)
        E.db.nihilistzscheui.nihilistchat = nil
        for _, mover in ipairs(moversToCheck) do
            if E.db.movers["Nihilist" .. mover] then
                self:SaveMoverPosition("Nihilistzsche" .. mover, unpack(E.db.movers["Nihilist" .. mover]))
                E.db.movers["Nihilist" .. mover] = nil
            end
        end

        E.db.nihilistzscheui.migrated = true

        E.db.nihilsitui = nil
    end

    if
        (
            not E.db.nihilistzscheui.migrated
            or type(E.db.nihilistzscheui.migrated) ~= "table"
            or not E.db.nihilistzscheui.migrated.wbn
        ) and E.db.nihilistzscheui.wbn
    then
        if E.db.nihilistzscheui.migrated and type(E.db.nihilistzscheui.migrated) ~= "table" then
            E.db.nihilistzscheui.migrated = {}
        end
        E.db.nihilistzscheui.migrated = E.db.nihilistzscheui.migrated or {}
        E:CopyTable(E.db.nihilistzscheui.dbn, E.db.nihilistzscheui.wbn)
        E.db.nihilistzscheui.wbn = nil
        E.db.nihilistzscheui.migrated.wbn = true
    end

    if
        (
            not E.db.nihilistzscheui.migrated
            or type(E.db.nihilistzscheui.migrated) ~= "table"
            or not E.db.nihilistzscheui.migrated.vuf
        ) and E.db.nihilistzscheui.vuf
    then
        if E.db.nihilistzscheui.migrated and type(E.db.nihilistzscheui.migrated) ~= "table" then
            E.db.nihilistzscheui.migrated = {}
        end
        E.db.nihilistzscheui.migrated = E.db.nihilistzscheui.migrated or {}

        local elements = {
            { "resting", "restingindicator" },
            { "combat", "combatindicator" },
            { "pvp", "pvptext" },
            { "resurrecticon", "resurrectindicator" },
        }

        for _, p in pairs(elements) do
            local old = p[1]
            local new = p[2]

            if not E.db.nihilistzscheui.vuf.units.player[new] and E.db.nihilistzscheui.vuf.units.player[old] then
                E:CopyTable(E.db.nihilistzscheui.vuf.units.player[new], E.db.nihilistzscheui.vuf.units.player[old])
                E.db.nihilistzscheui.vuf.units.player[old] = nil
            end
        end

        E.db.nihilistzscheui.migrated.vuf = true
    end

    if
        (
            not E.db.nihilistzscheui.migrated
            or type(E.db.nihilistzscheui.migrated) ~= "table"
            or not E.db.nihilistzscheui.migrated.installer
        ) and E.db.nihilistzscheui.installer
    then
        if E.db.nihilistzscheui.migrated and type(E.db.nihilistzscheui.migrated) ~= "table" then
            E.db.nihilistzscheui.migrated = {}
        end
        E:CopyTable(E.global.nihilistzscheui.installer, E.db.nihilistzscheui.installer)
        E.db.nihilistzscheui.installer = nil
        E.db.nihilistzscheui.migrated.installer = true
    end

    if
        (
            not E.db.nihilistzscheui.migrated
            or type(E.db.nihilistzscheui.migrated) ~= "table"
            or not E.db.nihilistzscheui.migrated.dbn
        ) and E.db.nihilistzscheui.cbn
    then
        if E.db.nihilistzscheui.migrated and type(E.db.nihilistzscheui.migrated) ~= "table" then
            E.db.nihilistzscheui.migrated = {}
        end
        E:CopyTable(E.db.nihilistzscheui.databarnotifier, E.db.nihilistzscheui.cbn)
        E.db.nihilistzscheui.cbn = nil
        E.db.nihilistzscheui.migrated.dbn = true
    end

    if E.private.nihilistzscheui.mounts.favDragonridingMount then
        E.private.nihilistzscheui.mounts.favSkyridingMount = E.private.nihilistzscheui.mounts.favDragonridingMount
        E.private.nihilistzscheui.mounts.favDragonridingMount = nil
    end
end
