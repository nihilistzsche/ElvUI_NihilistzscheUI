local NUI, E = _G.unpack((select(2, ...))) --Inport: Engine, Locales, ProfileDB, GlobalDB
local VUF = NUI.VerticalUnitFrames
local COMP = NUI.Compatibility
local LSM = E.Libs.LSM
local UF = E.UnitFrames

local GetSpecialization = _G.GetSpecialization
local gsub = _G.gsub
local CreateFrame = _G.CreateFrame

function VUF.UpdatePredictionStatusBar(prediction, parent, name)
    if not (prediction and parent) then return end
    local texture = (not parent.isTransparent and parent:GetStatusBarTexture():GetTexture()) or E.media.blankTex
    if name == "Health" then
        UF:Update_StatusBar(prediction.myBar, texture)
        UF:Update_StatusBar(prediction.otherBar, texture)
        UF:Update_StatusBar(prediction.absorbBar, texture)
        UF:Update_StatusBar(prediction.healAbsorbBar, texture)
    elseif name == "Power" then
        UF:Update_StatusBar(prediction.mainBar, texture)
    end
end

function VUF:UpdateElement(frame, element)
    if element == "castbar" then self:GetCastbar(frame) end

    local config = self.db.units[frame.unit][element]

    local size = config.size
    local e = self.units[frame.unit].elements[element]
    if size then
        if element == "portrait" then return end
        if e.statusbars then
            local horizCastbar
            if element == "castbar" and size.vertical ~= nil then
                if not self.db.units[frame.unit].horizCastbar then
                    size = size.vertical
                else
                    size = size.horizontal
                    horizCastbar = true
                end
            end

            for _, statusbar in pairs(e.statusbars) do
                local height = (horizCastbar and size.halfBar) and size.height * 0.5 or size.height
                if element == "powerprediction" then height = 0 end
                statusbar:Size(size.width, height)
            end
            if element == "castbar" then
                if
                    (frame.unit ~= "player" and frame.unit ~= "target") or not self.db.units[frame.unit].horizCastbar
                then
                    frame.Castbar.Spark:Width(frame.Castbar:GetWidth() * 2)
                else
                    frame.Castbar.Spark:Height(frame.Castbar:GetHeight() * 2)
                    frame.Castbar.Text:ClearAllPoints()
                    frame.Castbar.Time:ClearAllPoints()
                    if size.halfBar then
                        frame.Castbar.Text:SetPoint(
                            "BOTTOMLEFT",
                            frame.Castbar,
                            "TOPLEFT",
                            frame.Castbar.button:GetWidth() + 4,
                            2
                        )
                        frame.Castbar.Time:SetPoint("BOTTOMRIGHT", frame.Castbar, "TOPRIGHT", -4, 2)
                    else
                        frame.Castbar.Text:SetPoint("LEFT", frame.Castbar.button, "RIGHT", 4, 0)
                        frame.Castbar.Time:SetPoint("RIGHT", frame.Castbar, "RIGHT", -4, 0)
                    end
                end
            end
        end
        if e.frame then
            local height = size.height
            if element == "classbars" then
                if config.spaced then height = (height + 2) - (config.spacesettings.offset * 2) end
            end
            e.WIDTH = size.width
            e.HEIGHT = height
            e.frame:Size(size.width, height)
            if element == "classbars" then self:UpdateClassBar(frame, element) end
        end
    end
    local texture = LSM:Fetch("statusbar", UF.db.statusbar)
    local font = LSM:Fetch("font", UF.db.font)
    if e.statusbars then
        for _, statusbar in pairs(e.statusbars) do
            statusbar:SetStatusBarTexture(texture)
            if element == "power" then statusbar.texture = texture end
        end
    end
    if e.textures then
        for _, _texture in pairs(e.textures) do
            _texture:SetTexture(texture)
        end
    end
    if e.fontstrings then
        for _, fs in pairs(e.fontstrings) do
            fs:FontTemplate(font, UF.db.fontSize, "THINOUTLINE")
        end
    end
    if element == "power" then
        local power = frame.Power
        if UF.db.colors.powerselection then
            --[[elseif UF.db.colors.powerthreat then
			power.colorThreat = true]]
            power.colorSelection = true
        elseif UF.db.colors.powerclass then
            power.colorClass = true
            power.colorReaction = true
        else
            power.colorPower = true
        end
        power.custom_backdrop = UF.db.colors.custompowerbackdrop and UF.db.colors.power_backdrop

        --Transparency Settings
        UF:ToggleTransparentStatusBar(UF.db.colors.transparentPower, power, power.BG, nil, UF.db.colors.invertPower)

        --Prediction Texture; keep under ToggleTransparentStatusBar
        VUF.UpdatePredictionStatusBar(frame.PowerPrediction, power, "Power")
    end
    if element == "health" then
        --Transparency Settings
        UF:ToggleTransparentStatusBar(UF.db.colors.transparentHealth, frame.Health, frame.Health.bg, true, nil, nil)

        --Prediction Texture; keep under ToggleTransparentStatusBar
        VUF.UpdatePredictionStatusBar(frame.HealthPrediction, frame.Health, "Health")
        if COMP.FCT then
            VUF.FCT = VUF.FCT or E.Libs.AceAddon:GetAddon("ElvUI_FCT")
            VUF.FCT.ToggleFrame(VUF, frame)
        end
    end
    if element == "castbar" then
        local castbar = frame.Castbar
        castbar.custom_backdrop = UF.db.colors.customcastbarbackdrop and UF.db.colors.castbar_backdrop
        UF:ToggleTransparentStatusBar(
            UF.db.colors.transparentCastbar,
            castbar,
            castbar.bg,
            nil,
            UF.db.colors.invertCastbar
        )
    end
    if element == "aurabars" then
        local buffColor = UF.db.colors.auraBarBuff
        local debuffColor = UF.db.colors.auraBarDebuff
        local aurabars = frame.AuraBars
        aurabars.db = config
        aurabars.buffColor = { buffColor.r, buffColor.g, buffColor.b }
        aurabars.debuffColor = { debuffColor.r, debuffColor.g, debuffColor.b }
        aurabars.auraBarHeight = size.height
        aurabars.auraBarWidth = size.width
        aurabars:Size(size.width, size.height)
        aurabars:ForceUpdate()
    end
end

function VUF:UpdateElementAnchor(frame, element)
    local e = VUF:GetElement(element)
    local config = self.db.units[frame.unit][element]
    local enabled = config.enabled
    if element == "resurrectindicator" or element == "powerPrediction" then
        if enabled then
            frame:EnableElement(e)
        else
            frame:DisableElement(e)
        end
        return
    end
    if element == "healPrediction" then
        enabled = self.db.units[frame.unit].healPrediction and self.db.units[frame.unit].healPrediction.enabled
        local c = UF.db.colors.healPrediction
        local healPrediction = frame[e]
        if enabled then
            if not frame:IsElementEnabled("HealthPrediction") then frame:EnableElement("HealthPrediction") end

            UF:Configure_HealComm(frame)

            frame:EnableElement(e)
        else
            frame:DisableElement(e)
        end
        return
    end
    if element == "powerPrediction" then
        local mb = frame.PowerPrediction.mainBar
        local ab = frame.PowerPrediction.altBar
        if frame.Power then
            mb:ClearAllPoints()
            mb:SetPoint("LEFT", frame.Power, "LEFT")
            mb:SetPoint("RIGHT", frame.Power, "RIGHT")
            mb:SetPoint("BOTTOM", frame.Power:GetStatusBarTexture(), "BOTTOM")
        end

        if frame.AdditionalPower then
            ab:ClearAllPoints()
            ab:SetPoint("LEFT", frame.AdditionalPower, "LEFT")
            ab:SetPoint("RIGHT", frame.AdditionalPower, "RIGHT")
            ab:SetPoint("BOTTOM", frame.AdditionalPower:GetStatusBarTexture(), "BOTTOM")
        end
    end
    if element == "cutaway" then
        local c = self.db.units[frame.unit].cutaway
        if c then
            local eitherEnabled = c.health.enabled or c.power.enabled
            if not eitherEnabled then
                frame:DisableElement("Cutaway")
            else
                enabled = true
                if not frame:IsElementEnabled("Cutaway") then frame:EnableElement("Cutaway") end

                local hs, ps = frame.Cutaway:UpdateConfigurationValues(c)

                local ch = frame.Cutaway.Health
                local cp = frame.Cutaway.Power
                if ch and hs then
                    local texture = frame.Health:GetStatusBarTexture()
                    ch:ClearAllPoints()
                    ch:SetPoint("BOTTOMLEFT", texture, "TOPLEFT")
                    ch:SetPoint("BOTTOMRIGHT", texture, "TOPRIGHT")
                end

                if cp and ps then
                    local texture = frame.Power:GetStatusBarTexture()
                    cp:ClearAllPoints()
                    cp:SetPoint("BOTTOMLEFT", texture, "TOPLEFT")
                    cp:SetPoint("BOTTOMRIGHT", texture, "TOPRIGHT")
                end
            end
        end
    end
    if element == "aurabars" then
        local growthDirection = config.growthDirection
        frame.AuraBars.down = growthDirection == "DOWN"
    end
    local anchor = config.anchor
    if element == "stagger" and not (E.myclass == "MONK") then return end

    local hasAnchor = anchor ~= nil
    if element == "castbar" then
        if frame.unit == "player" or frame.unit == "target" then
            if self.db.units[frame.unit].horizCastbar then hasAnchor = false end
        end
    end

    if element == "stagger" then enabled = GetSpecialization() == 1 end

    if element == "health" then
        frame.Health:ClearAllPoints()
        local point = "TOPLEFT"
        local su = frame.unit:sub(1, 5)
        local o = 1
        if su == "focus" or su == "target" then
            point = "TOPRIGHT"
            o = -1
        end
        frame.Health:SetPoint(point, frame, point, o, -1)
    end

    if hasAnchor then
        local pointFrom = anchor.pointFrom
        local attachTo = VUF:GetAnchor(frame, anchor.attachTo)
        local pointTo = anchor.pointTo
        local xOffset = anchor.xOffset
        local yOffset = anchor.yOffset
        local _frame = frame[e]
        if element == "classbars" then
            if config.spaced then yOffset = yOffset + config.spacesettings.offset end
        end
        if not _frame or not attachTo then return end
        _frame:Point(pointFrom, attachTo, pointTo, xOffset, yOffset)
    elseif element == "aurabars" or element == "castbar" then
        local f, format, moverFormat
        if element == "aurabars" then
            f = frame.AuraBars
            format = "%s Vertical Unit Frame AuraBar Header"
            moverFormat = "%s AuraBar Mover"
        else
            f = frame.Castbar
            format = "%s Vertical Unit Frame Castbar"
            moverFormat = "%s Castbar Mover"
        end
        local stringTitle = E:StringTitle(frame.unit)
        if stringTitle:find("target") then stringTitle = gsub(stringTitle, "target", "Target") end
        local name = string.format(format, stringTitle)
        if not self.moversCreated then self.moversCreated = {} end
        if not self.moversCreated[frame.unit] then self.moversCreated[frame.unit] = {} end
        if not self.moversCreated[frame.unit][element] then
            local holder = CreateFrame("Frame", nil, f)
            holder:Size(f:GetWidth(), f:GetHeight())
            if element == "aurabars" then
                holder:Point("TOP", frame.Health, "BOTTOM", 9, -60) --Set to default position
            else
                if frame.unit == "player" then
                    holder:Point("CENTER", E.UIParent, "CENTER", 0, -170)
                else
                    holder:Point("CENTER", E.UIParent, "CENTER", 0, -200)
                end
            end
            f:ClearAllPoints()
            f:SetPoint("TOPLEFT", holder, "TOPLEFT", 0, 0)
            f:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 0, 0)
            f.Holder = holder

            E:CreateMover(
                f.Holder,
                string.format(moverFormat, frame:GetName()),
                name,
                nil,
                nil,
                nil,
                "ALL,SOLO,NIHILISTZSCHEUI"
            )
            self.moversCreated[frame.unit][element] = true
        end
    elseif element == "portrait" then
        local portrait = frame.Portrait
        if not portrait then return end
        portrait:ClearAllPoints()
        portrait:SetFrameLevel(frame.Health:GetFrameLevel())
        portrait:SetAllPoints(frame.Health)
        if config.enabled then
            portrait:SetAlpha(0)
            portrait:SetAlpha(0.35)
            portrait:Show()
        else
            portrait:Hide()
        end
    end
    if config.tag then frame:Tag(frame[e], config.tag) end
    if config.value and frame[e].value then
        local venable = config.value.enabled
        local vanchor = config.value.anchor
        local vpointFrom = vanchor.pointFrom
        local vattachTo = VUF:GetAnchor(frame, vanchor.attachTo)
        local vpointTo = vanchor.pointTo
        local vxOffset = vanchor.xOffset
        local vyOffset = vanchor.yOffset
        frame[e].value:SetPoint(vpointFrom, vattachTo, vpointTo, vxOffset, vyOffset)
        if config.value.tag then frame:Tag(frame[e].value, config.value.tag) end
        if venable then
            frame[e].value:Show()
        else
            frame[e].value:Hide()
        end
    end

    if element == "buffs" or element == "debuffs" then
        UF:EnableDisable_Auras(frame)
        frame[e]:SetShown(enabled)
    end

    if enabled then
        if element == "aurabars" then frame[e]:ForceUpdate() end
        if config.value and frame[e].value then
            if config.value.enabled then
                frame[e].value:Show()
            else
                frame[e].value:Hide()
            end
        end
        if element == "raidicon" then frame[e]:Size(frame:GetWidth() * 0.8) end
        if frame[e].ForceUpdate and not frame.OnFirstUpdateFinish then frame[e]:ForceUpdate() end
        frame:EnableElement(e)
    else
        frame:DisableElement(e)
        if config.value and frame[e].value then frame[e].value:Hide() end
        if element == "classbars" then -- Dirty hack for DKs
            VUF:ScheduleTimer(function()
                local oldValue = E.db.unitframe.units.player.classbar.enable
                E.db.unitframe.units.player.classbar.enable = false
                UF:CreateAndUpdateUF("player")
                E.db.unitframe.units.player.classbar.enable = oldValue
                UF:CreateAndUpdateUF("player")
            end, 1)
        end
        if frame[e].ForceUpdate then frame[e]:ForceUpdate() end
    end
end
