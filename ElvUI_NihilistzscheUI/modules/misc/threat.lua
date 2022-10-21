local NUI, E = _G.unpack(select(2, ...))
local NT = NUI.Misc.Threat
local DB = E.DataBars
local hooksecurefunc = _G.hooksecurefunc

function NT.Initialize()
	hooksecurefunc(DB, "ThreatBar_Update", function()
		local bar = DB.StatusBars.Threat

		bar:ClearAllPoints()
		bar:SetParent(_G.RightChatDataPanel)
		bar:SetAllPoints()
		bar:SetFrameStrata("MEDIUM")
	end)
	hooksecurefunc(
		DB,
		"ThreatBar_Update",
		function()
			local bar = DB.StatusBars.Threat

			bar:SetStatusBarTexture(E.media.normTex)
			if not bar.nuiMoved then
				E:DisableMover(bar.holder.mover:GetName())

				bar.holder:ClearAllPoints()
				bar.holder:SetParent(_G.RightChatDataPanel)
				bar.holder:SetAllPoints()
				bar.nuiMoved = true
			end
			bar.holder:SetFrameStrata("HIGH")
			bar:SetFrameStrata("DIALOG")
		end
	)
end

NUI:RegisterModule(NT:GetName())
