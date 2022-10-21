local NUI, E = _G.unpack(select(2, ...))
local VUF = NUI.VerticalUnitFrames
local UF = E.UnitFrames

local hooksecurefunc = _G.hooksecurefunc

function VUF:ConstructPowerPrediction(frame)
    self:AddElement(frame, "powerPrediction")
    local mb = self:ConstructStatusBar(frame, "powerPrediction", frame.Power, "mainbar", true)
    mb:SetStatusBarTexture(E.media.blankTex)
    mb:SetOrientation("VERTICAL")
    mb:SetReverseFill(true)
    mb:Hide()

    hooksecurefunc(
        frame.Power,
        "SetStatusBarColor",
        function(_, r, g, b)
            if frame and frame.PowerPrediction and frame.PowerPrediction.mainBar then
                if
                    UF and UF.db and UF.db.colors and UF.db.colors.powerPrediction and
                        UF.db.colors.powerPrediction.enable
                 then
                    local color = UF.db.colors.powerPrediction.color
                    frame.PowerPrediction.mainBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
                else
                    frame.PowerPrediction.mainBar:SetStatusBarColor(r * 1.25, g * 1.25, b * 1.25)
                end
            end
        end
    )

    local ab
    if frame.AdditionalPower then
        ab = self:ConstructStatusBar(frame, "powerPrediction", frame.AdditionalPower, "altbar", true)
        ab:SetStatusBarTexture(E.media.blankTex)
        ab:SetOrientation("VERTICAL")
        ab:SetReverseFill(true)
        ab:Hide()

        hooksecurefunc(
            frame.AdditionalPower,
            "SetStatusBarColor",
            function(_, r, g, b)
                if frame and frame.PowerPrediction and frame.PowerPrediction.altBar then
                    if
                        UF and UF.db and UF.db.colors and UF.db.colors.powerPrediction and
                            UF.db.colors.powerPrediction.enable
                     then
                        local color = UF.db.colors.powerPrediction.additional
                        frame.PowerPrediction.altBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
                    else
                        frame.PowerPrediction.altBar:SetStatusBarColor(r * 1.25, g * 1.25, b * 1.25)
                    end
                end
            end
        )
    end

    return {
        mainBar = mb,
        altBar = ab
    }
end

function VUF:PowerPredictionOptions(unit)
    return self:GenerateElementOptionsTable(
        unit,
        "powerPrediction",
        1250,
        "Mana Cost Prediction",
        false,
        false,
        false,
        false,
        false
    )
end
