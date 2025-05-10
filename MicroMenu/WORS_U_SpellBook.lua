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

WORS_U_SpellBook.frame:Hide()
WORS_U_SpellBook.frame:SetMovable(true)
WORS_U_SpellBook.frame:EnableMouse(true)
WORS_U_SpellBook.frame:RegisterForDrag("LeftButton")
WORS_U_SpellBook.frame:SetClampedToScreen(true)
tinsert(UISpecialFrames, "WORS_U_SpellBookFrame")
WORS_U_SpellBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_SpellBook.frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    -- local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    -- WORS_U_MicroMenuSettings.MicroMenuPOS = {
        -- point = point,
        -- relativeTo = relativeTo and relativeTo:GetName() or nil,
        -- relativePoint = relativePoint,
        -- xOfs = xOfs,
        -- yOfs = yOfs
    -- }
	-- self:SetUserPlaced(false)
end)
local closeButton = CreateFrame("Button", nil, WORS_U_SpellBookFrame)
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_SpellBookFrame, "TOPRIGHT", 4, 4)
WORS_U_SpellBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")
closeButton:SetScript("OnClick", function()
	WORS_U_SpellBook.frame:Hide()
    SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color default
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
	if InCombatLockdown() then
		print("You cannot open Spell / Prayer Book in combat. Will open when out of combat.")
		local function tryOpenLoop()
			if not InCombatLockdown() then
				print("Combat ended. Opening Spell Book.")
				OnMagicClick(SpellbookMicroButton)
			else
				C_Timer.After(1, tryOpenLoop)  -- Call itself again after 1 second
			end
		end
		C_Timer.After(1, tryOpenLoop)  -- Start the loop
		return
	end
	
	if pos then
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
        --AscensionSpellbookFrame:Show()
		ToggleSpellBook(BOOKTYPE_SPELL)
    else
        print("Toggling Mini Spell Book visibility.")  
        -- Standard toggle functionality
        if WORS_U_SpellBook.frame:IsShown() then
            WORS_U_SpellBook.frame:Hide()
            print("Spell Book hidden.")  
        else
            InitializeMagicLevel()
            SetupMagicButtons()
			MicroMenu_ToggleFrame(WORS_U_SpellBook.frame)--:Show()
            
            print("Spell Book shown.")  -- Debug statement for showing
        end
    end
end
-- Register the click event for the SpellbookMicroButton
SpellbookMicroButton:SetScript("OnClick", OnMagicClick)

-- **********************************************************************
-- **********************************************************************
-- ************************OLD CODE FOR TOGGLE BUTTON *******************
-- **********************************************************************
-- **********************************************************************


-- -- Movable button to toggle spell book
-- local function SaveButtonPosition()
    -- WORS_U_SpellBookButtonPosition = { WORS_U_SpellBook.toggleButton:GetPoint() }
-- end

-- WORS_U_SpellBook.toggleButton = CreateFrame("Button", "WORS_U_SpellBookToggleButton", UIParent)
-- WORS_U_SpellBook.toggleButton:SetSize(30, 35)
-- WORS_U_SpellBook.toggleButton:SetMovable(true)
-- WORS_U_SpellBook.toggleButton:SetClampedToScreen(true)
-- WORS_U_SpellBook.toggleButton:EnableMouse(true)
-- WORS_U_SpellBook.toggleButton:RegisterForDrag("LeftButton")
-- WORS_U_SpellBook.toggleButton:SetScript("OnDragStart", function(self) self:StartMoving() end)
-- WORS_U_SpellBook.toggleButton:SetScript("OnDragStop", function(self)
    -- self:StopMovingOrSizing()
    -- SaveButtonPosition()
-- end)

-- -- Custom background texture for the toggle button
-- local bg = WORS_U_SpellBook.toggleButton:CreateTexture(nil, "BACKGROUND")
-- WORS_U_SpellBook.toggleButton:SetBackdrop({
    -- bgFile = "Interface\\WORS\\OldSchoolBackground2",
    -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    -- tile = false, tileSize = 32, edgeSize = 16,
    -- insets = { left = 1, right = 1, top = 1, bottom = 1 }
-- })

-- -- Icon texture for the toggle button
-- local icon = WORS_U_SpellBook.toggleButton:CreateTexture(nil, "ARTWORK")
-- icon:SetSize(25, 25)
-- icon:SetPoint("CENTER")
-- icon:SetTexture("Interface\\Icons\\magicicon")  -- Replace with your spell icon


-- WORS_U_SpellBook.toggleButton:SetScript("OnClick", function(self)
    -- if InCombatLockdown() then
        -- print("Cannot open Spell Book during combat. Will check again in 1 second.")
        -- C_Timer.After(1, function()
            -- WORS_U_SpellBook.toggleButton:GetScript("OnClick")(self)  -- Re-check the click logic after 1 second
        -- end)
        -- return
    -- end
    -- if IsAltKeyDown() then
        -- -- Cycle through transparency levels
        -- WORS_U_SpellBook.frame:Show()
        -- currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        -- WORS_U_SpellBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
        -- SaveTransparency()  -- Save transparency after change
        -- print("Spell Book Transparency:", transparencyLevels[currentTransparencyIndex] * 100, "%")
    -- else
        -- -- Standard toggle functionality
        -- if WORS_U_SpellBook.frame:IsShown() then
            -- WORS_U_SpellBook.frame:Hide()
        -- else
            -- InitializeMagicLevel()  -- Refresh magic level before showing frame
            -- SetupMagicButtons()      -- Ensure buttons are set up based on current magic level
            -- WORS_U_SpellBook.frame:Show()
        -- end
        -- UpdateButtonBackground()
    -- end
-- end)

-- -- Initial highlight update
-- --SpellbookMicroButton:Hide()
-- UpdateButtonBackground()
-- WORS_U_SpellBook.toggleButton:SetPoint(unpack(WORS_U_SpellBookButtonPosition or {"CENTER"}))
