-- WORS_U_PrayBook.lua
local magicButtons = {}
local prayerButtons = {}

-- Create the prayer book frame
WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent)
WORS_U_PrayBook.frame:SetSize(180, 330)
WORS_U_PrayBook.frame:SetBackdrop({
    bgFile   = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile     = false, tileSize = 32, edgeSize = 32,
    insets   = { left = 5, right = 5, top = 5, bottom = 5 },
})
WORS_U_PrayBook.frame:SetFrameStrata("HIGH")
WORS_U_PrayBookFrame:SetFrameLevel(10)
WORS_U_PrayBook.frame:Hide()
WORS_U_PrayBook.frame:SetMovable(true)
WORS_U_PrayBook.frame:EnableMouse(true)
WORS_U_PrayBook.frame:RegisterForDrag("LeftButton")
WORS_U_PrayBook.frame:SetClampedToScreen(true)
WORS_U_PrayBook.frame:SetScript("OnDragStart", function(self) 	
	self:StartMoving() 
end)
WORS_U_PrayBook.frame:SetScript("OnDragStop", function(self) 	
	self:StopMovingOrSizing() 
	SaveFramePosition(self)
end)

-- Close button
local closeButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_PrayBook.frame, "TOPRIGHT", 4, 4)
WORS_U_PrayBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
    if InCombatLockdown() then
        print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
    else
        WORS_U_PrayBook.frame:Hide()
        PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
    end
end)

-- Micro button highlight update
function UpdatePrayMicroButtonBackground()
    local prayerBookShown = WORS_U_PrayBookFrame and WORS_U_PrayBookFrame:IsShown()

    -- Count how many of your custom frames are visible
    local visibleCount = 0
    for _, frame in ipairs(MicroMenu_Frames) do
        if frame and frame:IsShown() then
            visibleCount = visibleCount + 1
        end
    end
	if Backpack and Backpack:IsShown() then
		visibleCount = visibleCount + 1
	end
    local buttonTexture = PrayerMicroButton:GetNormalTexture()
    if prayerBookShown then
        if visibleCount == 1 then
	        buttonTexture:SetVertexColor(1, 0, 0)  -- red = only frame open
        else
            buttonTexture:SetVertexColor(0, 1, 0)  -- green = stealth/preloaded
        end
    else
        buttonTexture:SetVertexColor(1, 1, 1)      -- white = hidden
    end
end


WORS_U_PrayBook.frame:SetScript("OnShow", UpdatePrayMicroButtonBackground)
WORS_U_PrayBook.frame:SetScript("OnHide", UpdatePrayMicroButtonBackground)

local function refreshPrayerFrame()
    InitializeMagicPrayerLevels()
    SetupPrayerButtons(-8, -5, WORS_U_PrayBook.frame, prayerButtons)
    if WORS_U_MicroMenuSettings.showMagicandPrayer then
        SetupMagicButtons(-8, 160, WORS_U_PrayBook.frame, magicButtons)
    end
end


-- PrayerMicroButton click handler
local function OnPrayerClick(self)
    if IsShiftKeyDown() then
		--print("[PrayerMicro] Shift-click detected: Opening default spellbook")
        --ToggleSpellBook(BOOKTYPE_SPELL)
	end
	
	if not InCombatLockdown() then
		--print("[PrayerMicro] Normal click detected: Preparing custom spellbook frame")
		WORS_U_SpellBookFrame:Hide()
		refreshPrayerFrame()
		
		if not WORS_U_PrayBook.frame:IsShown() then
			--print("[PrayerMicro] Spellbook frame is hidden: Toggling it on")
			MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)
		else
			--print("[MagicMicro] Spellbook frame is already shown: No toggle")
		end
	else			
		if not WORS_U_SpellBookFrame:IsShown() and not WORS_U_PrayBook.frame:IsShown() then
			print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
		end			
	end

	if WORS_U_MicroMenuSettings.AutoCloseEnabled then
		--print("[PrayerMicro] In combat and AutoClose is enabled: Hiding other frames")
		WORS_U_EmoteBookFrame:Hide()
		WORS_U_MusicPlayerFrame:Hide()
		CombatStylePanel:Hide()
		CloseBackpack()
	else
		--print("[PrayerMicro] In combat and AutoClose is disabled: No action taken")
	end

end



local positioned = false
local needsRefresh = false
local eventFrame = CreateFrame("Frame")
-- Register the events we'll use
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("BAG_UPDATE_COOLDOWN")    -- fires when you leave combat
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if not positioned then
        -- initial placement, only once and only out of combat
        if not InCombatLockdown() then
            local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
            if pos then
                local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
                WORS_U_PrayBook.frame:SetPoint(
                    pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs
                )
            else
                WORS_U_PrayBook.frame:SetPoint("CENTER")
            end
            positioned = true            
            refreshPrayerFrame()
        end
        return
    end

    if event == "BAG_UPDATE" or event == "PLAYER_EQUIPMENT_CHANGED" then
        -- if in combat and frame is open (and backpack is closed), defer refresh
        if InCombatLockdown() and  WORS_U_PrayBook.frame:IsShown() then
            needsRefresh = true
			print("prayer needsRefresh set true. Event: " .. event)
        -- otherwise, if the book is open and backpack closed, refresh immediately
        elseif not InCombatLockdown() and WORS_U_PrayBook.frame:IsShown() then
            refreshPrayerFrame()
			needsRefresh = false
			print("prayer needsRefresh set false. Event: " .. event)
		end

    elseif event == "PLAYER_REGEN_ENABLED" then
        -- combat just ended (or cooldown info arrived): do any deferred refresh
        if needsRefresh then            
            if WORS_U_PrayBook.frame:IsShown() and not InCombatLockdown() then
				refreshPrayerFrame()
				needsRefresh = false
				print("prayer needsRefresh set false. Event: " .. event)
            end			
        end		
    end
end)

PrayerMicroButton:SetScript("OnClick", OnPrayerClick)
PrayerMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")    -- anchor the tooltip below the button
		GameTooltip:SetText("Prayer", 1, 1, 1, 1, true) -- white text, wrap if needed
		GameTooltip:AddLine("Open Prayer menu for spells, to open WOW Prayer book ui click Spellbook & Abilities", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		GameTooltip:Show()
    end
end)