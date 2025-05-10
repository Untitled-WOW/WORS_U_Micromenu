-- Get current Prayer level from rep
local factionID = 1170
local prayerLevel = 1
local prayerButtons = {}  -- Table to hold button references for clearing/re-creation

-- Function to initialize Prayer level
local function InitializePrayerLevel()
    prayerLevel = GetLevelFromFactionReputation(factionID)
    print("Prayer Level:", prayerLevel)
end

-- Function to set up magic buttons dynamically
local function SetupPrayerButtons()
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
        local row = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        prayerButton:SetPoint("TOPLEFT", margin + (buttonSize + padding) * column, -margin - (buttonSize + padding) * row)

        local icon = prayerButton:CreateTexture(nil, "BACKGROUND")
        icon:SetAllPoints()
        icon:SetTexture(prayerIcon)

        if prayerLevel < requiredLevel then
            icon:SetDesaturated(true)
            prayerButton:SetAlpha(0.5)
        else
            icon:SetDesaturated(false)
            prayerButton:SetAlpha(1)
        end

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
	-- Load the saved variable transparency value when the frame is created
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
WORS_U_PrayBook.frame:Hide()
WORS_U_PrayBook.frame:SetMovable(true)
WORS_U_PrayBook.frame:EnableMouse(true)
WORS_U_PrayBook.frame:RegisterForDrag("LeftButton")
WORS_U_PrayBook.frame:SetClampedToScreen(true)
tinsert(UISpecialFrames, "WORS_U_PrayBookFrame")
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
	WORS_U_PrayBook.frame:Hide()
    PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
end)

-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_PrayBook.frame:IsShown() then
        --WORS_U_PrayBook.toggleButton:SetBackdropColor(1, 0, 0, 1)  -- Red background when open
		PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- Set the color to red	
	else
        --WORS_U_PrayBook.toggleButton:SetBackdropColor(1, 1, 1, 1)  -- Default white background when closed
		PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Default	
	end
end
WORS_U_PrayBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_PrayBook.frame:SetScript("OnHide", UpdateButtonBackground)



-- Function to handle PrayerMicroButton clicks
local function OnPrayerClick(self)
	local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if InCombatLockdown() then
		print("You cannot open Spell / Prayer Book in combat. Will open when out of combat.")
		local function tryOpenLoop()
			if not InCombatLockdown() then
				print("Combat ended. Opening Prayer Book.")
				OnPrayerClick(PrayerMicroButton)
			else
				C_Timer.After(1, tryOpenLoop)  -- Call itself again after 1 second
			end
		end

		C_Timer.After(1, tryOpenLoop)  -- Start the loop
		return
	end
	if pos then
		local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
		WORS_U_PrayBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
	else
		WORS_U_PrayBook.frame:SetPoint("CENTER")
	end

	if IsAltKeyDown() then
        WORS_U_PrayBook.frame:Show()
		currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        WORS_U_PrayBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
        SaveTransparency()  -- Save transparency after change
        print("Prayer Book Transparency set to:", transparencyLevels[currentTransparencyIndex] * 100 .. "%")
	
	elseif IsShiftKeyDown() then
        print("Shift key is down. Open normal Spellbook")  -- Debug statement for Shift key
        --AscensionSpellbookFrame:Show()
		ToggleSpellBook(BOOKTYPE_SPELL)

    else
        -- Regular toggle functionality
        if WORS_U_PrayBook.frame:IsShown() then
            WORS_U_PrayBook.frame:Hide()
        else
            InitializePrayerLevel()
            SetupPrayerButtons()
            MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)--:Show()
        end
    end
	UpdateButtonBackground()
end
PrayerMicroButton:SetScript("OnClick", OnPrayerClick)