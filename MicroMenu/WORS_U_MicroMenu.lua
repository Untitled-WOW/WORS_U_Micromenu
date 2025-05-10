-- enable or disable auto-closing of other micromenu frames

WORS_U_MicroMenuSettings = WORS_U_MicroMenuSettings or {
    transparency = 1,  -- Default transparency value
	AutoCloseEnabled = true,
	MicroMenuPOS = { point = "CENTER", relativeTo = nil, relativePoint = "CENTER", xOfs = 0, yOfs = 0 }
}


-- Store all micro menu frames
MicroMenu_Frames = {
    WORS_U_SpellBookFrame,
    WORS_U_PrayBookFrame,
    WORS_U_EmoteBookFrame,
    WORS_U_MusicPlayerFrame,
	CombatStylePanel,	
}

-- Hide all frames and reset button colors
function MicroMenu_HideAll()	
	for _, frame in ipairs(MicroMenu_Frames) do
        frame:Hide()
		print("Frame: ".. frame:GetName() .."Hiden")
    end
	CloseBackpack()
end

-- Toggle a frame if target and open or hidesall frames if AutoCloseEnabled true
function MicroMenu_ToggleFrame(targetFrame)
    if targetFrame:IsShown() then
        targetFrame:Hide()
    else
        if WORS_U_MicroMenuSettings.AutoCloseEnabled then
            MicroMenu_HideAll()
        end
        targetFrame:Show()
    end
end

-- Function to save transparency to saved variables
function SaveTransparency()
    WORS_U_MicroMenuSettings.transparency = transparencyLevels[currentTransparencyIndex]
    print("Transparency saved:", WORS_U_MicroMenuSettings.transparency * 100 .. "%")  -- Debug output
end

-- Function to load transparency from saved variables
function LoadTransparency()
    local savedAlpha = WORS_U_MicroMenuSettings.transparency or 1  -- Default to 1 (100%) if not saved
    -- Apply transparency to each frame in the list
	for _, frame in ipairs(MicroMenu_Frames) do
        if frame then
            frame:SetAlpha(savedAlpha)  -- Set transparency for the frame
        end
    end
    print("Transparency loaded:", savedAlpha * 100 .. "%")  -- Debug output
end

-- Function to save the position of the frame
local function SaveFramePosition(self)
    if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
		WORS_U_MicroMenuSettings.MicroMenuPOS = {
			point = point,
			relativeTo = relativeTo and relativeTo:GetName() or nil,
			relativePoint = relativePoint,
			xOfs = xOfs,
			yOfs = yOfs
		}
		print("Frame position saved:", point, relativePoint, xOfs, yOfs)  -- Debug output
		
		 -- Apply this position to all other frames in MicroMenuFramesToAdjust
        local relativeFrame = relativeTo and _G[relativeTo] or UIParent
        for _, frame in ipairs(MicroMenu_Frames) do
            if frame and frame ~= self then
                frame:ClearAllPoints()
                frame:SetPoint(point, relativeFrame, relativePoint, xOfs, yOfs)
                frame:SetUserPlaced(false)
            end
        end
		print("Frame pos applied to all MicroMenuFrames and CombatStylePanel")
		Backpack:ClearAllPoints()
		Backpack:SetPoint(point, relativeFrame, relativePoint, xOfs, yOfs+25)
        Backpack:SetUserPlaced(false)
		print("Frame pos applied Backpack")
	else
		for _, frame in ipairs(MicroMenu_Frames) do
            if frame and frame ~= self then
                frame:SetUserPlaced(true)
            end
        end
		Backpack:SetUserPlaced(true)
		print("AutoCloseEnabled set to false")
	end
end


local function HookAFrames()
    if WORS_U_MicroMenuSettings.AutoCloseEnabled ~= true then
        return
    end

    if Backpack then
       if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then 
			Backpack:HookScript("OnShow", function()
				WORS_U_EmoteBook.frame:Hide()
				WORS_U_SpellBook.frame:Hide()
				WORS_U_PrayBook.frame:Hide()
				WORS_U_MusicBook.musicPlayer:Hide()
				CombatStylePanel:Hide()
			end)
			local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
			if pos then
				local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
				Backpack:ClearAllPoints()
				Backpack:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs+25)
				Backpack:SetUserPlaced(false)
			else
				
			end
			
		else
			print("AutoCloseEnabled set to false")
		end

    end

    if CombatStylePanel then
		if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then 
			CombatStylePanel:HookScript("OnShow", function()
				WORS_U_EmoteBook.frame:Hide()
				WORS_U_SpellBook.frame:Hide()
				WORS_U_PrayBook.frame:Hide()
				WORS_U_MusicBook.musicPlayer:Hide()
				CloseBackpack()
			end)
			local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
			if pos then
				local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
				CombatStylePanel:ClearAllPoints()
				CombatStylePanel:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
				CombatStylePanel:SetUserPlaced(false)
			else
				
			end
			
		else
			print("AutoCloseEnabled set to false")
		end
		LoadTransparency()
    end
    -- If neither are available, retry after a short delay
    if not Backpack and not CombatStylePanel then
        C_Timer.After(0.1, HookAFrames)
    end
	print("Backpack and CombatStylePanel Hooked")
end

local function HookMicroMenuFrames()
	if WORS_U_MicroMenuSettings.AutoCloseEnabled ~= true then
		for _, frame in ipairs(MicroMenu_Frames) do
			if frame then
				frame:SetUserPlaced(true)
			end
		end 
		return
    end
-- Hook into the OnDragStop handler for MicroMenu and CombatStylePanel frames
	for _, frame in ipairs(MicroMenu_Frames) do
		if frame then
			frame:HookScript("OnDragStop", function(self)
				SaveFramePosition(self)  -- Save the position after drag
				
			end)
		end
	end
end


local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")  -- Ensure it's only triggered after login
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
		
		C_Timer.After(0.5, function()
			HookAFrames()			
			HookMicroMenuFrames()
		end)		

        self:UnregisterEvent("PLAYER_LOGIN")  -- Unregister the event after hooking
    end
end)

