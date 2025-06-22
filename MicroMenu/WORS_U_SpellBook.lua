local magicButtons = {}
local prayerButtons = {}


-- Create the main frame for the custom spell book
WORS_U_SpellBook.frame = CreateFrame("Frame", "WORS_U_SpellBookFrame", UIParent)
WORS_U_SpellBook.frame:SetSize(192, 280)
WORS_U_SpellBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
WORS_U_SpellBook.frame:SetFrameStrata("High")
WORS_U_SpellBook.frame:SetFrameLevel(10)
WORS_U_SpellBook.frame:Hide()
WORS_U_SpellBook.frame:SetMovable(true)
WORS_U_SpellBook.frame:EnableMouse(true)
WORS_U_SpellBook.frame:RegisterForDrag("LeftButton")
WORS_U_SpellBook.frame:SetClampedToScreen(true)
WORS_U_SpellBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_SpellBook.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)
local closeButton = CreateFrame("Button", nil, WORS_U_SpellBookFrame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_SpellBookFrame, "TOPRIGHT", 4, 4)
WORS_U_SpellBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
	if InCombatLockdown() then
		print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
		return
	else
		MicroMenu_ToggleFrame(WORS_U_SpellBookFrame)
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
	end
end)

function UpdateSpellMicroButtonBackground()
    local spellBookShown = WORS_U_SpellBookFrame and WORS_U_SpellBookFrame:IsShown()

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
    local buttonTexture = SpellbookMicroButton:GetNormalTexture()

    if spellBookShown then
        if visibleCount == 1 then
            buttonTexture:SetVertexColor(1, 0, 0)  -- red = only frame open
        else
            buttonTexture:SetVertexColor(0, 1, 0)  -- green = stealth/preloaded
        end
    else
        buttonTexture:SetVertexColor(1, 1, 1)      -- white = hidden
    end
end




WORS_U_SpellBook.frame:SetScript("OnShow", UpdateSpellMicroButtonBackground)
WORS_U_SpellBook.frame:SetScript("OnHide", UpdateSpellMicroButtonBackground)

-- Function to handle MagicMicroButton clicks
-- Function to handle MagicMicroButton clicks
local function OnMagicClick(self)
    if IsShiftKeyDown() then
        print("[MagicMicro] Shift-click detected: Opening default spellbook")
        ToggleSpellBook(BOOKTYPE_SPELL)
    else
        if not InCombatLockdown() then
            print("[MagicMicro] Normal click detected: Preparing custom spellbook frame")
            WORS_U_PrayBookFrame:Hide()
			InitializeMagicPrayerLevels()
            SetupMagicButtons(-10, WORS_U_SpellBookFrame, magicButtons)
            if WORS_U_MicroMenuSettings.showMagicandPrayer then
                print("[MagicMicro] Setting up prayer buttons")
                SetupPrayerButtons(155, WORS_U_SpellBookFrame, prayerButtons)
            end

            if not WORS_U_SpellBook.frame:IsShown() then
                print("[MagicMicro] Spellbook frame is hidden: Toggling it on")
                MicroMenu_ToggleFrame(WORS_U_SpellBook.frame)
            else
                print("[MagicMicro] Spellbook frame is already shown: No toggle")
            end
		end
        if WORS_U_MicroMenuSettings.AutoCloseEnabled then
            print("[MagicMicro] In combat and AutoClose is enabled: Hiding other frames")
            WORS_U_EmoteBookFrame:Hide()
            WORS_U_MusicPlayerFrame:Hide()
            CombatStylePanel:Hide()
            CloseBackpack()
        else
            print("[MagicMicro] In combat and AutoClose is disabled: No action taken")
        end
    end
end






local eventFrame = CreateFrame("Frame")
local hasSetSpellBookPosition = false  -- track this internally, not saved

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if not hasSetSpellBookPosition and not InCombatLockdown() then
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
            WORS_U_SpellBook.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
        else
            WORS_U_SpellBook.frame:SetPoint("CENTER")
        end
        hasSetSpellBookPosition = true
    elseif not hasSetSpellBookPosition and InCombatLockdown() then
        print("|cff00ff00MicroMenu: You cannot reposition the Prayer Book in combat.|r")
    end
    if InCombatLockdown() then return end
	InitializeMagicPrayerLevels()
	SetupMagicButtons(-10, WORS_U_SpellBookFrame, magicButtons)
	if WORS_U_MicroMenuSettings.showMagicandPrayer then				
		SetupPrayerButtons(155, WORS_U_SpellBookFrame, prayerButtons)		
	end		
	MicroMenu_ToggleFrame(WORS_U_SpellBook.frame)--:Show()
	UpdateSpellMicroButtonBackground()
end)

SpellbookMicroButton:SetScript("OnClick", OnMagicClick)
SpellbookMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:AddLine("Shift + Click to open WOW Spellbook.", 1, 1, 0, true)
        GameTooltip:Show()
    end
end)