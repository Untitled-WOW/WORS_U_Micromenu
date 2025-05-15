-- enable or disable auto-closing of other micromenu frames

WORS_U_MicroMenuSettings = WORS_U_MicroMenuSettings or {
    transparency = 1,  -- Default transparency value
	AutoCloseEnabled = true,
}

--MicroMenu_AutoCloseEnabled = true

-- Store all micro menu frames
MicroMenu_Frames = {
    WORS_U_SpellBookFrame,
    WORS_U_PrayBookFrame,
    WORS_U_EmoteBookFrame,
    WORS_U_MusicPlayerFrame,
	CombatStylePanel,
}

-- Map frames to their associated buttons for color updates
MicroMenu_Buttons = {
    [WORS_U_SpellBookFrame]   = SpellbookMicroButton,
    [WORS_U_PrayBookFrame]    = PrayerMicroButton,
    [WORS_U_EmoteBookFrame]   = EmotesMicroButton,
    [WORS_U_MusicPlayerFrame] = MusicMicroButton,
	[CombatStylePanel]		  = CombatStyleMicroButton,
}

-- Utility: hide all frames and reset button colors
function MicroMenu_HideAll()
    for _, frame in ipairs(MicroMenu_Frames) do
        frame:Hide()
        local button = MicroMenu_Buttons[frame]
        if button and button:GetNormalTexture() then
            button:GetNormalTexture():SetVertexColor(1, 1, 1)  -- default color
        end
    end
end

-- Toggle a frame, optionally hiding all others first, and update button color
function MicroMenu_ToggleFrame(targetFrame)
    local button = MicroMenu_Buttons[targetFrame]

    if targetFrame:IsShown() then
        targetFrame:Hide()
        if button and button:GetNormalTexture() then
            button:GetNormalTexture():SetVertexColor(1, 1, 1)  -- reset to default
        end
    else
        if WORS_U_MicroMenuSettings.AutoCloseEnabled then
            MicroMenu_HideAll()
			CloseBackpack()
        end
        targetFrame:Show()
        if button and button:GetNormalTexture() then
            button:GetNormalTexture():SetVertexColor(1, 0, 0)  -- red when open
        end
    end
end

-- local f = CreateFrame("Frame")
-- f:SetScript("OnUpdate", function(self)
    -- if CombatStylePanel then
        -- CombatStylePanel:HookScript("OnShow", function()
            -- if WORS_U_MicroMenuSettings.AutoCloseEnabled then
                -- MicroMenu_HideAll()
                -- CloseBackpack()
            -- end
        -- end)
		-- print("CombatStylePanel hooked")
        -- self:SetScript("OnUpdate", nil) -- stop checking once hooked
    -- end
-- end)
