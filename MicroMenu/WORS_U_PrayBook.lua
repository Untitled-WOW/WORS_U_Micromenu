-- WORS_U_PrayBook.lua

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
local function UpdateButtonBackground()
    if WORS_U_PrayBook.frame:IsShown() then
        PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0)
    else
        PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1)
    end
end
WORS_U_PrayBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_PrayBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- PrayerMicroButton click handler
local function OnPrayerClick(self)
    local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
    if not InCombatLockdown() then
        if pos then
            local rel = pos.relativeTo and _G[pos.relativeTo] or UIParent
            WORS_U_PrayBook.frame:SetPoint(pos.point, rel, pos.relativePoint, pos.xOfs, pos.yOfs)
        else
            WORS_U_PrayBook.frame:SetPoint("CENTER")
        end
    else
        print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
    end        
    if IsShiftKeyDown() then
        ToggleSpellBook(BOOKTYPE_SPELL)
    else
        if not InCombatLockdown() then
            if WORS_U_PrayBook.frame:IsShown() then
                WORS_U_PrayBook.frame:Hide()
            else
                InitializeMagicPrayerLevels()
                SetupPrayerButtons(-10, WORS_U_PrayBookFrame)				
				if WORS_U_MicroMenuSettings.showMagicandPrayer then
					SetupMagicButtons(155, WORS_U_PrayBookFrame)
				end
                MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)
            end
        elseif WORS_U_MicroMenuSettings.AutoCloseEnabled then
            WORS_U_EmoteBookFrame:Hide()
            WORS_U_MusicPlayerFrame:Hide()
            CombatStylePanel:Hide()
            CloseBackpack()
        end
    end
end

-- Event used to check if magic run requirments are met
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if InCombatLockdown() then return end
    if not WORS_U_SpellBook.frame:IsShown() then return end
	InitializeMagicPrayerLevels()
	SetupPrayerButtons(-10, WORS_U_PrayBookFrame)	
	if WORS_U_MicroMenuSettings.showMagicandPrayer then	
		SetupMagicButtons(155, WORS_U_PrayBookFrame)		
	end
end)

PrayerMicroButton:SetScript("OnClick", OnPrayerClick)
PrayerMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:AddLine("Shift + Click to open WOW Spellbook.", 1, 1, 0, true)
        GameTooltip:Show()
    end
end)