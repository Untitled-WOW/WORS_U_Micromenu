-- Get current Magic level from rep
local factionID = 1169
local magicLevel = 1
local magicButtons = {}

-- Function to initialize Magic level
local function InitializeMagicLevel()
    magicLevel = GetLevelFromFactionReputation(factionID)
    print("Magic Level:", magicLevel)
end

-- Function to set up magic buttons dynamically
local function SetupMagicButtons()
    if InCombatLockdown() then
		return
	end
	
	-- Clear existing buttons before creating new ones
    for _, button in pairs(magicButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    wipe(magicButtons)
	local buttonSize = 20
	local padding 	 = 5         -- space between buttons
	local margin 	 = 10        -- space from frame edge
	local columns 	 = 7

    for i, spellData in ipairs(WORS_U_SpellBook.spells) do
        local spellID = spellData.id
        local requiredLevel = spellData.level
        local spellName, _, spellIcon = GetSpellInfo(spellID)
		--local spellButton = CreateFrame("Button", nil, WORS_U_SpellBook.frame, "ActionButtonTemplate")
        local spellButton = CreateFrame("Button", nil, WORS_U_SpellBook.frame, "SecureActionButtonTemplate")
        spellButton:SetSize(buttonSize, buttonSize)

        -- Calculate position
        local row = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        --spellButton:SetPoint("TOPLEFT", padding + (buttonSize + padding) * column, -padding - (buttonSize + padding) * row)
		spellButton:SetPoint("TOPLEFT", WORS_U_SpellBook.frame, "TOPLEFT", margin + (buttonSize + padding) * column, -margin - (buttonSize + padding) * row)
        -- Set up the button icon
        local icon = spellButton:CreateTexture(nil, "BACKGROUND")
        icon:SetAllPoints()
        icon:SetTexture(spellIcon)

        -- Check if player's level meets the spell's required level
        if magicLevel < requiredLevel then
            icon:SetDesaturated(true)
            spellButton:SetAlpha(0.5)
        else
            icon:SetDesaturated(false)
            spellButton:SetAlpha(1)
        end

        -- Set up secure attributes for spell button
        spellButton:SetAttribute("type", "spell")
        spellButton:SetAttribute("spell", spellID)

        -- Tooltip
        spellButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(spellButton, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(spellID)
            GameTooltip:Show()
        end)
        spellButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
        table.insert(magicButtons, spellButton)
    end
    -- Load the saved variable transparency value when the frame is created
    LoadTransparency()
end

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
--tinsert(UISpecialFrames, "WORS_U_SpellBookFrame")
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
		print("You cannot open or close Spell / Prayer Book in combat.")
		return
	else
		WORS_U_SpellBook.frame:Hide()
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
	end
end)



-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_SpellBook.frame:IsShown() then
        --WORS_U_SpellBook.toggleButton:SetBackdropColor(1, 0, 0, 1)  -- Red background when open
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- Set the color to red
	else
        --WORS_U_SpellBook.toggleButton:SetBackdropColor(1, 1, 1, 1)  -- Default white background when closed
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color to red
	end
end
WORS_U_SpellBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_SpellBook.frame:SetScript("OnHide", UpdateButtonBackground)


-- Function to handle MagicMicroButton clicks
local function OnMagicClick(self)
    print("MagicMicroButton has been clicked!")  -- Debug statement
    local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
	if pos and not InCombatLockdown() then
		local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
		WORS_U_SpellBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
	else
		WORS_U_SpellBook.frame:SetPoint("CENTER")
	end

    if IsAltKeyDown() then
        WORS_U_SpellBook.frame:Show()
        currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        WORS_U_SpellBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
        SaveTransparency()
        print("Spell Book Transparency:", transparencyLevels[currentTransparencyIndex] * 100, "%")
		
    elseif IsShiftKeyDown() then
        print("Shift key is down. Open normal Spellbook")  
		ToggleSpellBook(BOOKTYPE_SPELL)
    else
        print("Toggling Mini Spell Book visibility.")  
        -- Standard toggle functionality
        if WORS_U_SpellBook.frame:IsShown() then
            WORS_U_SpellBook.frame:Hide()
        else
            InitializeMagicLevel()
            SetupMagicButtons()
			MicroMenu_ToggleFrame(WORS_U_SpellBook.frame)--:Show()
        end
    end
end
-- Register the click event for the SpellbookMicroButton
SpellbookMicroButton:SetScript("OnClick", OnMagicClick)