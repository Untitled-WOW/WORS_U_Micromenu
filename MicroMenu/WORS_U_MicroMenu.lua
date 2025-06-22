
-- Store all MicroMenu frames and CombatStylePanel
MicroMenu_Frames = {WORS_U_SpellBookFrame, WORS_U_PrayBookFrame, WORS_U_EmoteBookFrame, WORS_U_MusicPlayerFrame, CombatStylePanel}

function MicroMenu_HideAll()
    for _, frame in ipairs(MicroMenu_Frames) do
        -- Always set strata/level
        if frame == WORS_U_SpellBookFrame or frame == WORS_U_PrayBookFrame then
            frame:SetFrameStrata("HIGH")
            frame:SetFrameLevel(10)
        else
            frame:SetFrameStrata("HIGH")
            frame:SetFrameLevel(20)
        end

        -- Only hide if not combat-locked
        if not (InCombatLockdown() and (frame == WORS_U_SpellBookFrame or frame == WORS_U_PrayBookFrame)) then
            frame:Hide()
        end
    end

    CloseBackpack()
    UpdateSpellMicroButtonBackground()
end


local LastOpenedBookFrame = nil

function MicroMenu_ToggleFrame(targetFrame)
    if InCombatLockdown() then
        if targetFrame == WORS_U_SpellBookFrame or targetFrame == WORS_U_PrayBookFrame then
            print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
            return
        end        
    end

    local function isMicroMenuFrame(frame)
        for _, f in ipairs(MicroMenu_Frames) do
            if f == frame then return true end
        end
        return false
    end

    if targetFrame:IsShown() then
        targetFrame:Hide()
        if isMicroMenuFrame(targetFrame) then
            RestoreMicroButtonsFromMicroMenu()
        end
    else
        if WORS_U_MicroMenuSettings.AutoCloseEnabled then
            MicroMenu_HideAll()
        end

        -- Enforce exclusivity between books
        if targetFrame == WORS_U_SpellBookFrame and not InCombatLockdown() then
            WORS_U_PrayBookFrame:Hide()
            LastOpenedBookFrame = WORS_U_SpellBookFrame
        elseif targetFrame == WORS_U_PrayBookFrame and not InCombatLockdown() then
            WORS_U_SpellBookFrame:Hide()
            LastOpenedBookFrame = WORS_U_PrayBookFrame
        end

        -- Show the target frame
        targetFrame:Show()

        -- Stealth-load the last used book if opening something else
        if not InCombatLockdown()
            and targetFrame ~= WORS_U_SpellBookFrame
            and targetFrame ~= WORS_U_PrayBookFrame
            and LastOpenedBookFrame
            and not LastOpenedBookFrame:IsShown()
        then
            -- Hide the other book first
            local other = (LastOpenedBookFrame == WORS_U_SpellBookFrame) and WORS_U_PrayBookFrame or WORS_U_SpellBookFrame
            if other and other:IsShown() then
                other:Hide()
            end

            LastOpenedBookFrame:SetFrameStrata("HIGH")
            LastOpenedBookFrame:SetFrameLevel(10)
            LastOpenedBookFrame:Show()
        end

        if isMicroMenuFrame(targetFrame) then
            AttachMicroButtonsTo(targetFrame)
        end
    end

    -- ✅ Always update the button appearance after toggling
    UpdateSpellMicroButtonBackground()
	UpdatePrayMicroButtonBackground()
end




local function SaveFramePosition(self)
    print("|cff00ff00[MicroMenu Debug]|r SaveFramePosition for", self:GetName())

    if not WORS_U_MicroMenuSettings.AutoCloseEnabled then
        print("|cff00ff00[MicroMenu Debug]|r AutoClose disabled, marking user-placed")
        for _, f in ipairs(MicroMenu_Frames) do f:SetUserPlaced(true) end
        if Backpack then Backpack:SetUserPlaced(true) end
        return
    end

    -- 1) raw anchor
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    local relName = relativeTo and relativeTo:GetName() or "UIParent"
    print(string.format("|cff00ff00[MicroMenu Debug]|r raw GetPoint: %s:SetPoint(%s, %s, %s, %.1f, %.1f)", self:GetName(), point, relName, relativePoint, xOfs, yOfs))
    -- 2) persist
    WORS_U_MicroMenuSettings.MicroMenuPOS = {point = point, relativeTo = relName, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
    local reference = _G[relName] or UIParent

    -- 3) two offset tables
    local bpOffsets = {
        RIGHT       = { -6,  -25 }, TOPRIGHT    = { -6,    0 }, BOTTOMRIGHT = { -6,  -50 },
        LEFT        = {  6,  -25 }, TOPLEFT     = {  6,    0 }, BOTTOMLEFT  = {  6,  -50 },
        CENTER      = {  0,  -25 }, TOP         = {  0,    0 }, BOTTOM      = {  0,  -50 },
    }-- MM ofsets for when backpack is moved to apply to Micromenu frames but is not working atm
    local mmOffsets = {
        RIGHT       = { 0, 0 }, TOPRIGHT    = { 0, 0 }, BOTTOMRIGHT = { 0, 0 },
        LEFT        = { 0, 0 }, TOPLEFT     = { 0, 0 }, BOTTOMLEFT  = { 0, 0 },
        CENTER      = { 0, 0 }, TOP         = { 0, 0 }, BOTTOM      = { 0, 0 },
    }
    local bpX, bpY = unpack(bpOffsets[relativePoint] or { xOfs, yOfs })
    local mmX, mmY = unpack(mmOffsets[relativePoint] or { xOfs, yOfs })

    -- 4a) you dragged the Backpack → move all micro-menu frames with mmOffsets
    if self == Backpack then
        for _, frame in ipairs(MicroMenu_Frames) do
            local fx, fy = mmX, mmY
            print(string.format("|cff00ff00[MicroMenu Debug]|r moving %s relative to Backpack: %s:SetPoint(%s, Backpack, %s, %.1f, %.1f)", frame:GetName(), frame:GetName(), point, relativePoint, fx, fy))
            frame:ClearAllPoints()
            frame:SetPoint(point, Backpack, relativePoint, fx, fy)
            frame:SetUserPlaced(false)
        end
        print(string.format("|cff00ff00[MicroMenu Debug]|r Backpack remains: Backpack:SetPoint(%s, %s, %s, %.1f, %.1f)", point, relName, relativePoint, xOfs, yOfs))
        Backpack:ClearAllPoints()
        Backpack:SetPoint(point, reference, relativePoint, xOfs, yOfs)
        Backpack:SetUserPlaced(false)
        return
    --end

    -- 4b) you dragged a MicroMenu frame → snap peers raw, then move Backpack with bpOffsets
    else
        for _, frame in ipairs(MicroMenu_Frames) do
            if frame ~= self then
                print(string.format("|cff00ff00[MicroMenu Debug]|r snapping %s:SetPoint(%s, %s, %s, %.1f, %.1f)", frame:GetName(), point, relName, relativePoint, xOfs, yOfs))
                frame:ClearAllPoints()
                frame:SetPoint(point, reference, relativePoint, xOfs, yOfs)
                frame:SetUserPlaced(false)
            end
        end
        if Backpack then
            local bx, by = xOfs + bpX, yOfs + bpY
            print(string.format("|cff00ff00[MicroMenu Debug]|r positioning Backpack:SetPoint(%s, %s, %s, %.1f, %.1f)", point, relName, relativePoint, bx, by))
            Backpack:ClearAllPoints()
            Backpack:SetPoint(point, reference, relativePoint, bx, by)
            Backpack:SetUserPlaced(false)
        end
    end
end



-- Hook Blizzard frames to hide micro-menu on show
local function HookAFrames()
    if not WORS_U_MicroMenuSettings.AutoCloseEnabled then return end
    if Backpack then
        Backpack:HookScript("OnShow", function()
            AttachMicroButtonsTo(Backpack)
            if WORS_U_MicroMenuSettings.AutoCloseEnabled then
                if not InCombatLockdown() then
                    --WORS_U_SpellBook.frame:Show()
                    --WORS_U_PrayBook.frame:Hide()
                end
                WORS_U_EmoteBook.frame:Hide()
                WORS_U_MusicBook.musicPlayer:Hide()
                CombatStylePanel:Hide()
            end
			UpdateSpellMicroButtonBackground()
			UpdatePrayMicroButtonBackground()
        end)
		Backpack:HookScript("OnHide", function()
			UpdateSpellMicroButtonBackground()
			UpdatePrayMicroButtonBackground()
        end)
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
            Backpack:ClearAllPoints()
            Backpack:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
            Backpack:SetUserPlaced(false)
        end
		hooksecurefunc(Backpack, "StopMovingOrSizing", function(self)
			-- only run if AutoClose is on
			if not WORS_U_MicroMenuSettings.AutoCloseEnabled then return end
			print("|cff00ff00[MicroMenu Debug]|r Backpack drag ended, saving position")
			SaveFramePosition(self)
		end)	
    end
    if CombatStylePanel then
        CombatStylePanel:HookScript("OnShow", function()
            AttachMicroButtonsTo(CombatStylePanel)
            if WORS_U_MicroMenuSettings.AutoCloseEnabled then
                if not InCombatLockdown() then
                    --WORS_U_SpellBook.frame:Show()
                    --WORS_U_PrayBook.frame:Hide()
                end
                WORS_U_EmoteBook.frame:Hide()
                WORS_U_MusicBook.musicPlayer:Hide()
                CloseBackpack()
            end
			--UpdateSpellMicroButtonBackground()
			--UpdatePrayMicroButtonBackground()
        end)
		CombatStylePanel:HookScript("OnHide", function()
			--UpdateSpellMicroButtonBackground()
			--UpdatePrayMicroButtonBackground()
        end)
		-- Button click handlers
		CombatStyleMicroButton:SetScript("OnClick", function()
			if not CombatStylePanel:IsShown() then
				print("[CombatStylePanel] CombatStylePanel frame is hidden: Toggling it on")
				WORS_U_EmoteBook.frame:Hide()
                WORS_U_MusicBook.musicPlayer:Hide()
                CloseBackpack()
				CombatStylePanel:Show()				
			else
                print("[CombatStylePanel] CombatStylePanel frame is already shown: HIDE")
				CombatStylePanel:Hide()	
			end

			
		end)		
		CombatStylePanel:SetFrameStrata("DIALOG")
		CombatStylePanel:SetFrameLevel(50)		
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
            CombatStylePanel:ClearAllPoints()
            CombatStylePanel:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
            CombatStylePanel:SetUserPlaced(false)
        end
    end
    if not Backpack and not CombatStylePanel then
        C_Timer.After(0.1, HookAFrames)
    end
end

-- Hook drag-stop on micro-menu frames for saving positions
local function HookMicroMenuFrames()
    if not WORS_U_MicroMenuSettings.AutoCloseEnabled then
        for _, frame in ipairs(MicroMenu_Frames) do
            if frame then frame:SetUserPlaced(true) end
        end
        return
    end
    for _, frame in ipairs(MicroMenu_Frames) do
        if frame then frame:HookScript("OnDragStop", SaveFramePosition) end
    end
end

-- Hook hide on micro-menu frames to restore buttons
local function HookMicroMenuButtonRestores()
    for _, frame in ipairs(MicroMenu_Frames) do
        if frame then frame:HookScript("OnHide", RestoreMicroButtonsFromMicroMenu) end
    end
	-- Hook the Backpack frame Show/Hide once it exists
	local hookedBackpack = false
	C_Timer.NewTicker(0.2, function(ticker)
		if hookedBackpack then
			ticker:Cancel()
			return
		end
		local bf = _G["Backpack"]
		if bf and type(bf.Hide) == "function" then
			hooksecurefunc(bf, "Hide", function(self)
				RestoreMicroButtonsFromMicroMenu()
			end)
			hooksecurefunc(bf, "Show", function(self)
				AttachMicroButtonsTo(self)
			end)
			hookedBackpack = true
			ticker:Cancel()
			print("|cff00ff00[MicroMenu]|r Backpack.Show/Hide hooked!")
		end
	end)	
end


-- Main initialization event
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0.5, function()
            HookAFrames()
            HookMicroMenuFrames()
            HookMicroMenuButtonRestores()
			local spellbookTriggered = false
			C_Timer.NewTicker(0.2, function(ticker)
				if spellbookTriggered then
					ticker:Cancel()
					return
				end
				if not InCombatLockdown() then
					print("[MagicMicro] Out of combat: Showing spellbook and opening backpack")
					WORS_U_SpellBookFrame:Show()
					SaveFramePosition(WORS_U_SpellBookFrame)
					MainMenuBarBackpackButton:Click()
					spellbookTriggered = true
					ticker:Cancel()
				else
					print("[MagicMicro] Still in combat: Waiting...")
				end
			end)		
        end)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
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
autoCloseEnabledCheckbox:SetScript("OnShow", function(self)
    if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then
        self:SetChecked(true)
    else
        self:SetChecked(false)
    end
end)
autoCloseEnabledCheckbox:SetScript("OnClick", function(self)
	WORS_U_MicroMenuSettings.AutoCloseEnabled = self:GetChecked() == 1 and true or false
	HookAFrames()
	HookMicroMenuFrames()
end)

-- Register the options frame
InterfaceOptions_AddCategory(optionsFrame)
