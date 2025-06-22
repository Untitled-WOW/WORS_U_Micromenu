-- WORS_U_PrayBook.lua

local magicButtons = {}
local prayerButtons = {}

-- Create the prayer book frame
WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent)
WORS_U_PrayBook.frame:SetSize(192, 280)
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
WORS_U_PrayBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_PrayBook.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

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

-- PrayerMicroButton click handler
local function OnPrayerClick(self)
    if IsShiftKeyDown() then
		print("[PrayerMicro] Shift-click detected: Opening default spellbook")
        ToggleSpellBook(BOOKTYPE_SPELL)
    else
        if not InCombatLockdown() then
			print("[PrayerMicro] Normal click detected: Preparing custom spellbook frame")
			WORS_U_SpellBookFrame:Hide()
			InitializeMagicPrayerLevels()
			SetupPrayerButtons(-10, WORS_U_PrayBookFrame, prayerButtons)				
			if WORS_U_MicroMenuSettings.showMagicandPrayer then
				SetupMagicButtons(155, WORS_U_PrayBookFrame, magicButtons)
			end
			
			if not WORS_U_PrayBook.frame:IsShown() then
				print("[PrayerMicro] Spellbook frame is hidden: Toggling it on")

				MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)
			else
                print("[PrayerMicro] Spellbook frame is already shown: No toggle")
            end
		end
        if WORS_U_MicroMenuSettings.AutoCloseEnabled then
            print("[PrayerMicro] In combat and AutoClose is enabled: Hiding other frames")
			WORS_U_EmoteBookFrame:Hide()
            WORS_U_MusicPlayerFrame:Hide()
            CombatStylePanel:Hide()
            CloseBackpack()
        else
            print("[PrayerMicro] In combat and AutoClose is disabled: No action taken")
        end
    end
end

local eventFrame = CreateFrame("Frame")
local hasSetPrayerBookPosition = false  -- track this internally, not saved

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if not hasSetPrayerBookPosition and not InCombatLockdown() then
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
            WORS_U_PrayBook.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
        else
            WORS_U_PrayBook.frame:SetPoint("CENTER")
        end
        hasSetPrayerBookPosition = true
    elseif not hasSetPrayerBookPosition and InCombatLockdown() then
        print("|cff00ff00MicroMenu: You cannot reposition the Prayer Book in combat.|r")
    end
    if InCombatLockdown() then return end
    InitializeMagicPrayerLevels()
    SetupPrayerButtons(-10, WORS_U_PrayBookFrame, prayerButtons)
    if WORS_U_MicroMenuSettings.showMagicandPrayer then
        SetupMagicButtons(155, WORS_U_PrayBookFrame, magicButtons)
    end
end)


PrayerMicroButton:SetScript("OnClick", OnPrayerClick)
PrayerMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:AddLine("Shift + Click to open WOW Spellbook.", 1, 1, 0, true)
        GameTooltip:Show()
    end
end)