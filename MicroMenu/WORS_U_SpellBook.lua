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
		WORS_U_SpellBook.frame:Hide()
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
	end
end)

-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_SpellBook.frame:IsShown() then
		
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- Set the color to red
	else
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color to red
	end
end
WORS_U_SpellBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_SpellBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- Function to handle MagicMicroButton clicks
local function OnMagicClick(self)
    local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if not InCombatLockdown() then
		if pos and not InCombatLockdown() then
			local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
			WORS_U_SpellBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
		else
			WORS_U_SpellBook.frame:SetPoint("CENTER")
		end
	else
		print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
	end
    if IsShiftKeyDown() then
		ToggleSpellBook(BOOKTYPE_SPELL)
    else
        if not InCombatLockdown() then		
			if WORS_U_SpellBook.frame:IsShown() then
				WORS_U_SpellBook.frame:Hide()
			else
				InitializeMagicPrayerLevels()
				SetupMagicButtons(-10, WORS_U_SpellBookFrame)
				if WORS_U_MicroMenuSettings.showMagicandPrayer then				
					SetupPrayerButtons(155, WORS_U_SpellBookFrame)		
				end		
				MicroMenu_ToggleFrame(WORS_U_SpellBook.frame)--:Show()
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
	SetupMagicButtons(-10, WORS_U_SpellBookFrame)	
	if WORS_U_MicroMenuSettings.showMagicandPrayer then	
		SetupPrayerButtons(155, WORS_U_SpellBookFrame)		
	end
end)

SpellbookMicroButton:SetScript("OnClick", OnMagicClick)
SpellbookMicroButton:HookScript("OnEnter", function(self)
    if GameTooltip:IsOwned(self) then
        GameTooltip:AddLine("Shift + Click to open WOW Spellbook.", 1, 1, 0, true)
        GameTooltip:Show()
    end
end)