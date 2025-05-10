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

-- **********************************************************************
-- **********************************************************************
-- ************************OLD CODE FOR TOGGLE BUTTON *******************
-- **********************************************************************
-- **********************************************************************




-- -- Movable button to toggle prayer book
-- local function SaveButtonPosition()
    -- WORS_U_PrayBookButtonPosition = { WORS_U_PrayBook.toggleButton:GetPoint() }
-- end

-- WORS_U_PrayBook.toggleButton = CreateFrame("Button", "WORS_U_PrayBookToggleButton", UIParent)
-- WORS_U_PrayBook.toggleButton:SetSize(30, 35)
-- WORS_U_PrayBook.toggleButton:SetMovable(true)
-- WORS_U_PrayBook.toggleButton:SetClampedToScreen(true)
-- WORS_U_PrayBook.toggleButton:EnableMouse(true)
-- WORS_U_PrayBook.toggleButton:RegisterForDrag("LeftButton")
-- WORS_U_PrayBook.toggleButton:SetScript("OnDragStart", function(self) self:StartMoving() end)
-- WORS_U_PrayBook.toggleButton:SetScript("OnDragStop", function(self)
    -- self:StopMovingOrSizing()
    -- SaveButtonPosition()
-- end)

-- -- Custom background texture
-- local bg = WORS_U_PrayBook.toggleButton:CreateTexture(nil, "BACKGROUND")
-- WORS_U_PrayBook.toggleButton:SetBackdrop({
    -- bgFile = "Interface\\WORS\\OldSchoolBackground2",          -- Background texture
    -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",      -- Border texture
    -- tile = false, tileSize = 32, edgeSize = 16,                 -- Adjust edgeSize as needed for your border
    -- insets = { left = 1, right = 1, top = 1, bottom = 1 }       -- Adjust insets to control border thickness
-- })

-- -- Icon texture instead of text
-- local icon = WORS_U_PrayBook.toggleButton:CreateTexture(nil, "ARTWORK")
-- icon:SetSize(25, 25)
-- icon:SetPoint("CENTER")
-- icon:SetTexture("Interface\\Icons\\prayer.blp")


-- -- OnClick to toggle the prayer book and update transparency when Alt is held
-- WORS_U_PrayBook.toggleButton:SetScript("OnClick", function(self, button)
    -- if InCombatLockdown() then
        -- print("Cannot open Prayer Book while in combat. Retrying...")
        -- -- Wait 1 second and try again
        -- C_Timer.After(1, function()
            -- WORS_U_PrayBook.toggleButton:GetScript("OnClick")(self, button) -- Reinvoke the OnClick
        -- end)
        -- return
    -- end
    -- if IsAltKeyDown() then
        -- -- Cycle through transparency levels
        -- WORS_U_PrayBook.frame:Show()
        -- transparencyIndex = transparencyIndex % #transparencyLevels + 1
        -- local alpha = transparencyLevels[transparencyIndex]
        -- WORS_U_PrayBook.frame:SetAlpha(alpha)
        -- SaveTransparency()  -- Save transparency after change
        -- print("Prayer Book Transparency set to:", alpha * 100 .. "%")  -- Debug output
    -- else
        -- -- Regular toggle functionality
        -- if WORS_U_PrayBook.frame:IsShown() then
            -- WORS_U_PrayBook.frame:Hide()
        -- else
            -- InitializePrayerLevel()
            -- SetupPrayerButtons()
            -- WORS_U_PrayBook.frame:Show()
        -- end
    -- end
	-- UpdateButtonBackground()
-- end)

-- -- Initial highlight update
-- --PrayerMicroButton:Hide()
-- UpdateButtonBackground()
-- WORS_U_PrayBook.toggleButton:SetPoint(unpack(WORS_U_PrayBookButtonPosition or {"CENTER"}))
