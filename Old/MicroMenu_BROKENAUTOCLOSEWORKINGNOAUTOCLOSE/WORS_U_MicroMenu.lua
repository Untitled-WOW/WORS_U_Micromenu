-- Store all MicroMenu frames and CombatStylePanel
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
		if InCombatLockdown() and (frame == WORS_U_SpellBookFrame or frame == WORS_U_PrayBookFrame) then
			-- Skip hiding this frame during combat
		elseif frame == WORS_U_SpellBookFrame or frame == WORS_U_PrayBookFrame then
			frame:SetFrameStrata("High")
			frame:SetFrameLevel(10)
			frame:Hide()
		else
			frame:SetFrameStrata("High")
			frame:SetFrameLevel(20)
			frame:Hide()
		end
		
	end
	CloseBackpack()
end

-- Toggle a frame if target and open or hidesall frames if AutoCloseEnabled true
function MicroMenu_ToggleFrame(targetFrame)
	if InCombatLockdown() then
		if targetFrame ==  WORS_U_SpellBookFrame or targetFrame ==  WORS_U_PrayBookFrame then
			print("|cff00ff00MicroMenu: MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
			return
		end		
	end
	if targetFrame:IsShown() then
        targetFrame:Hide()
    else
        if WORS_U_MicroMenuSettings.AutoCloseEnabled then
            MicroMenu_HideAll()
        end
        targetFrame:Show()
    end
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
		}--print("Frame position saved:", point, relativePoint, xOfs, yOfs)  -- Debug output
		
		-- Apply this position to all other frames 
        local relativeFrame = relativeTo and _G[relativeTo] or UIParent
        for _, frame in ipairs(MicroMenu_Frames) do
            if frame and frame ~= self then
				if InCombatLockdown() and (frame == WORS_U_SpellBookFrame or frame == WORS_U_PrayBookFrame) then
				--print("Skipped position update for", frame:GetName(), "due to combat lockdown")
				else
					frame:ClearAllPoints()
					frame:SetPoint(point, relativeFrame, relativePoint, xOfs, yOfs)
					frame:SetUserPlaced(false)
				end
            end
        end		
		Backpack:ClearAllPoints()
		Backpack:SetPoint(point, relativeFrame, relativePoint, xOfs, yOfs)
        Backpack:SetUserPlaced(false)
	else
		for _, frame in ipairs(MicroMenu_Frames) do
            if frame and frame ~= self then
                frame:SetUserPlaced(true)
            end
        end
		Backpack:SetUserPlaced(true)
	end
end

-- Hook into Backpack and CombatStylePanel to hide MicroMenu frames and set postion
local function HookAFrames()
    if WORS_U_MicroMenuSettings.AutoCloseEnabled == false then
        return
    end
    if Backpack then
       if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then 
			Backpack:HookScript("OnShow", function()
				if not InCombatLockdown() then
					WORS_U_SpellBook.frame:Hide()
					WORS_U_PrayBook.frame:Hide()
				end
				WORS_U_EmoteBook.frame:Hide()
				WORS_U_MusicBook.musicPlayer:Hide()
				CombatStylePanel:Hide()
			end)
			local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
			if pos then
				local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
				Backpack:ClearAllPoints()
				Backpack:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs+25)
				Backpack:SetUserPlaced(false)
			end
		else
			print("AutoCloseEnabled set to false")
		end
    end
    if CombatStylePanel then
		if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then 
			CombatStylePanel:HookScript("OnShow", function()
				if not InCombatLockdown() then
					WORS_U_SpellBook.frame:Hide()
					WORS_U_PrayBook.frame:Hide()
				end
				WORS_U_EmoteBook.frame:Hide()
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
	--print("Backpack and CombatStylePanel Hooked")
end

local function HookMicroMenuFrames()
	if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then
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





---------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

local optionsFrame = CreateFrame("Frame", "MicroMenuOptionsFrame", InterfaceOptionsFramePanelContainer)
optionsFrame.name = "MicroMenu"
-- Create a scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "MicroMenuOptionsScrollFrame", optionsFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(550, 540) -- Set the desired size of the scroll frame
scrollFrame:SetPoint("TOPLEFT", 16, -16)
local contentFrame = CreateFrame("Frame", "MicroMenuOptionsContentFrame", scrollFrame)
contentFrame:SetSize(400, 500) -- Set size based on the expected total content height
scrollFrame:SetScrollChild(contentFrame)
-- Create a title
local title = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 0, 0)
title:SetText("Micro Menu Options")

-- Create checkbox for pinToBackpack
local autoCloseEnabledCheckbox = CreateFrame("CheckButton", "MicroMenuAutoCloseEnabledCheckbox", contentFrame, "InterfaceOptionsCheckButtonTemplate")
autoCloseEnabledCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 10, -10)
autoCloseEnabledCheckbox.text = autoCloseEnabledCheckbox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
autoCloseEnabledCheckbox.text:SetPoint("LEFT", autoCloseEnabledCheckbox, "RIGHT", 5, 0)
autoCloseEnabledCheckbox.text:SetText("Enable Auto Close and Stacking of MicroMenu, Backpack and Combat Style Windows") -- Set the checkbox label
autoCloseEnabledCheckbox:SetChecked(WORS_U_MicroMenuSettings.AutoCloseEnabled)
autoCloseEnabledCheckbox:SetScript("OnClick", function(self)
	if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then
        WORS_U_MicroMenuSettings.AutoCloseEnabled = false  -- Set the variable to false
    elseif WORS_U_MicroMenuSettings.AutoCloseEnabled == false then
        WORS_U_MicroMenuSettings.AutoCloseEnabled = true
	end
	HookAFrames()
	HookMicroMenuFrames()
end)

-- local transparencyLabel = contentFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
-- transparencyLabel:SetPoint("TOPLEFT", autoCloseEnabledCheckbox, "BOTTOMLEFT", 0, -50)
-- transparencyLabel:SetText("Transparency")

-- local transparencyDropdown = CreateFrame("Frame", "WORS_TransparencyDropdown", contentFrame, "UIDropDownMenuTemplate")
-- transparencyDropdown:SetPoint("TOPLEFT", transparencyLabel, "BOTTOMLEFT", -16, -5)

-- local transparencyOptions = {25, 50, 75, 100}

-- UIDropDownMenu_Initialize(transparencyDropdown, function(self, level)
    -- for _, value in ipairs(transparencyOptions) do
        -- local info = UIDropDownMenu_CreateInfo()
        -- info.text = value .. "%"
        -- info.value = value
        -- info.func = function()
            -- UIDropDownMenu_SetSelectedValue(transparencyDropdown, value)
            -- UIDropDownMenu_SetText(transparencyDropdown, value .. "%")

            -- -- Inline application of alpha
            -- local alpha = value / 100
            -- WORS_U_MicroMenuSettings.transparency = value
            -- if WORS_U_EmoteBook and WORS_U_EmoteBook.frame then
                -- WORS_U_EmoteBook.frame:SetAlpha(alpha)
            -- end
            -- if WORS_U_PrayBook and WORS_U_PrayBook.frame then
                -- WORS_U_PrayBook.frame:SetAlpha(alpha)
            -- end
            -- if WORS_U_SpellBook and WORS_U_SpellBook.frame then
                -- WORS_U_SpellBook.frame:SetAlpha(alpha)
            -- end
            -- if WORS_U_MusicBook and WORS_U_MusicBook.musicPlayer then
                -- WORS_U_MusicBook.musicPlayer:SetAlpha(alpha)
            -- end
			-- WORS_U_MicroMenuSettings.transparency = value
			

        -- end
        -- UIDropDownMenu_AddButton(info, level)
    -- end
-- end)

-- transparencyDropdown:SetScript("OnShow", function()
    -- local selected = WORS_U_MicroMenuSettings.transparency * 100 or 100
    -- UIDropDownMenu_SetSelectedValue(transparencyDropdown, selected)
    -- UIDropDownMenu_SetText(transparencyDropdown, selected .. "%")
-- end)





-- Register the options frame
InterfaceOptions_AddCategory(optionsFrame)
