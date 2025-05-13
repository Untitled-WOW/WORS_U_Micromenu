-- Function to initialize Prayer level from rep
local factionID = 1170
local prayerLevel = 1
local function InitializePrayerLevel()
    prayerLevel = GetLevelFromFactionReputation(factionID)
end

local prayerButtons = {}  
-- Function to set up magic buttons dynamically
local function SetupPrayerButtons()
	if InCombatLockdown() then
		return
	end
	-- Clear existing buttons before creating new ones
	for _, button in pairs(prayerButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    wipe(prayerButtons)
    local buttonSize = 35
    local padding 	 = 2	 -- space between buttons
	local margin   	 = 5 	 -- space from frame edge
    local columns 	 = 5
    
	for i, prayerData in ipairs(WORS_U_PrayBook.prayers) do
        local prayerID = prayerData.id
        local requiredLevel = prayerData.level
        local prayerName, _, prayerIcon = GetSpellInfo(prayerID)
        local prayerButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame, "SecureActionButtonTemplate")
        prayerButton:SetSize(buttonSize, buttonSize)
        -- Calculate position
		local row = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        prayerButton:SetPoint("TOPLEFT", margin + (buttonSize + padding) * column, -margin - (buttonSize + padding) * row)
        local icon = prayerButton:CreateTexture(nil, "BACKGROUND")
        icon:SetAllPoints()
        icon:SetTexture(prayerIcon)
		-- Check prayer level and set icon color
        if prayerLevel < requiredLevel then
			icon:SetVertexColor(0.2, 0.2, 0.2) -- No magic level: Dark Gray
        else
			icon:SetVertexColor(1, 1, 1) -- Normal icon
        end
		-- pre click used to cast prayer or remove aura
        prayerButton:SetScript("PreClick", function(self)
            if UnitBuff("player", prayerName) then
                self:SetAttribute("type", "macro")
                self:SetAttribute("macrotext", "/cancelaura " .. prayerName)
            else
                self:SetAttribute("type", "spell")
                self:SetAttribute("spell", prayerID)
            end
        end)
        prayerButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(prayerButton, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(prayerID)
            GameTooltip:Show()
        end)
        prayerButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
        prayerButton:SetScript("OnUpdate", function(self)
            if UnitBuff("player", prayerName) then
                icon:SetTexture(prayerData.buffIcon)
            else
                icon:SetTexture(prayerIcon)
            end
        end)
        table.insert(prayerButtons, prayerButton)
    end	
	LoadTransparency()
end

-- Create the prayer book frame
WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent)
WORS_U_PrayBook.frame:SetSize(192, 280)
WORS_U_PrayBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
WORS_U_PrayBook.frame:SetFrameStrata("High")
WORS_U_PrayBookFrame:SetFrameLevel(10)
WORS_U_PrayBook.frame:Hide()
WORS_U_PrayBook.frame:SetMovable(true)
WORS_U_PrayBook.frame:EnableMouse(true)
WORS_U_PrayBook.frame:RegisterForDrag("LeftButton")
WORS_U_PrayBook.frame:SetClampedToScreen(true)
--tinsert(UISpecialFrames, "WORS_U_PrayBookFrame")
WORS_U_PrayBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_PrayBook.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)
local closeButton = CreateFrame("Button", nil, WORS_U_PrayBookFrame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_PrayBookFrame, "TOPRIGHT", 4, 4)
WORS_U_PrayBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
	if InCombatLockdown() then
		print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
		return
	else	
		WORS_U_PrayBook.frame:Hide()
		PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
	end
end)

-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_PrayBook.frame:IsShown() then
		PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- Set the color to red	
	else
		PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Default	
	end
end
WORS_U_PrayBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_PrayBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- Function to handle PrayerMicroButton clicks
local function OnPrayerClick(self)
	local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if not InCombatLockdown() then
		if pos then
			local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
			WORS_U_PrayBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
		else
			WORS_U_PrayBook.frame:SetPoint("CENTER")
		end
	else
		print("|cff00ff00MicroMenu: You cannot open or close Spell / Prayer Book in combat.|r")
	end

	if IsAltKeyDown() and not InCombatLockdown() then
        WORS_U_PrayBook.frame:Show()
		currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        WORS_U_PrayBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
        SaveTransparency()  -- Save transparency after change
	elseif IsShiftKeyDown() then        
        --AscensionSpellbookFrame:Show()
		ToggleSpellBook(BOOKTYPE_SPELL)
    else
		if not InCombatLockdown() then	
			if WORS_U_PrayBook.frame:IsShown() then
				WORS_U_PrayBook.frame:Hide()
			else
				InitializePrayerLevel()
				SetupPrayerButtons()
				MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)--:Show()
			end
		elseif WORS_U_MicroMenuSettings.AutoCloseEnabled then	
			WORS_U_EmoteBookFrame:Hide()
			WORS_U_MusicPlayerFrame:Hide()
			CombatStylePanel:Hide()
			CloseBackpack()
		end
    end
end
PrayerMicroButton:SetScript("OnClick", OnPrayerClick)