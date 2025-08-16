-- Function to initialize Prayer level from rep
local magicLevel = 1
local function InitializeMagicLevel()
	_, _, magicLevel, _, _, _ = WORSSkillsUtil.GetSkillInfo(Enum.WORSSkills.Magic)
end

local magicButtons = {}

-- Function to set up magic buttons dynamically
local function SetupMagicButtons()
    if InCombatLockdown() then
        -- can't create/modify secure children in combat
        return
    end

    -- Clear existing buttons before creating new ones
    for _, button in pairs(magicButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    wipe(magicButtons)

    local buttonSize = 20
    local padding    = 5          -- space between buttons
    local margin     = 10         -- space from frame edge
    local columns    = 7

    for i, spellData in ipairs(WORS_U_SpellBook.spells) do
        local spellID = spellData.id
        local requiredLevel = spellData.level
        local spellName, _, spellIcon = GetSpellInfo(spellID)

        local spellButton = CreateFrame("Button", nil, WORS_U_SpellBook.frame, "SecureActionButtonTemplate")
        spellButton:SetSize(buttonSize, buttonSize)

        -- Calculate position
        local row = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        spellButton:SetPoint(
            "TOPLEFT", WORS_U_SpellBook.frame, "TOPLEFT",
            margin + (buttonSize + padding) * column,
            -margin - (buttonSize + padding) * row
        )

        local icon = spellButton:CreateTexture(nil, "BACKGROUND")
        icon:SetAllPoints()
        icon:SetTexture(spellIcon)

        -- Check Magic level and Rune requirements and set icon color
        if magicLevel < requiredLevel then
            icon:SetVertexColor(0.1, 0.1, 0.1) -- No magic level: Dark Gray
        else
            local hasRunes = WORS_U_SpellBook:HasRequiredRunes(spellData.runes)
            if hasRunes then
                icon:SetVertexColor(1, 1, 1)   -- Can cast: Normal icon
            else
                icon:SetVertexColor(0.25, 0.25, 0.25) -- No runes: Gray
            end
        end
		
        -- Set up secure attributes for spell button
        spellButton:SetAttribute("type", "spell")
        spellButton:SetAttribute("spell", spellID)

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
end

-- ===========================
-- SECURE WRAPPER + VISIBILITY
-- ===========================

-- Create the main frame as a secure handler so it can Show/Hide in combat
WORS_U_SpellBook.frame = CreateFrame("Frame", "WORS_U_SpellBookFrame", UIParent, "SecureHandlerStateTemplate")
WORS_U_SpellBook.frame:SetSize(192, 304)
WORS_U_SpellBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground1",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
WORS_U_SpellBook.frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)

WORS_U_SpellBook.frame:SetFrameStrata("LOW")
WORS_U_SpellBook.frame:SetFrameLevel(10)
WORS_U_SpellBook.frame:Hide()
WORS_U_SpellBook.frame:SetMovable(true)
WORS_U_SpellBook.frame:EnableMouse(true)
WORS_U_SpellBook.frame:RegisterForDrag("LeftButton")
WORS_U_SpellBook.frame:SetClampedToScreen(true)
-- tinsert(UISpecialFrames, "WORS_U_SpellBookFrame")
WORS_U_SpellBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_SpellBook.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Keep a secure "desired visibility" attribute (no drivers; we allow in-combat show)
WORS_U_SpellBook.frame:SetAttribute("userToggle", nil) -- hidden by default

-- Build content when the frame becomes visible and we're not in combat
WORS_U_SpellBook.frame:SetScript("OnShow", function()
    if not InCombatLockdown() then
        InitializeMagicLevel()
        SetupMagicButtons()
    end
end)

-- Update micro button tint on show/hide
local function UpdateButtonBackground()
    if WORS_U_SpellBook.frame:IsShown() then
        SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- red when open
    else
        SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- default
    end
end
WORS_U_SpellBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_SpellBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- =========================================
-- EVENTS: keep icons up-to-date 
-- =========================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") 
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
--eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if InCombatLockdown() then return end
		InitializeMagicLevel()
		SetupMagicButtons()	
	elseif event == "PLAYER_REGEN_ENABLED" then
		InitializeMagicLevel()
		SetupMagicButtons()
	elseif event == "BAG_UPDATE" then
		if InCombatLockdown() then return end
		InitializeMagicLevel()
		SetupMagicButtons()
	end
end)

-- =========================
-- SECURE TOGGLE + CLOSE UI
-- =========================

-- Secure TOGGLE overlay on the SpellbookMicroButton
local Toggle = CreateFrame("Button", "WORS_USpellBook_Toggle", UIParent, "SecureHandlerClickTemplate")
Toggle:SetAllPoints(SpellbookMicroButton)
Toggle:RegisterForClicks("AnyUp")
Toggle:SetFrameStrata("HIGH")
Toggle:SetFrameLevel(SpellbookMicroButton:GetFrameLevel() + 1)

-- before: after you create CombatStylePanel and WORS_U_SpellBook.frame
-- Pass references into secure environment
Toggle:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
Toggle:SetFrameRef("aCombatStyle", CombatStylePanel)  

-- Secure click snippet
Toggle:SetAttribute("_onclick", [=[
  local uSpellBook = self:GetFrameRef("uSpellBook")
  local aCombatStyle = self:GetFrameRef("aCombatStyle")
  -- Toggle the Spell Book
  local isShown = uSpellBook:GetAttribute("userToggle")
  if isShown then
    uSpellBook:SetAttribute("userToggle", nil)
    uSpellBook:Hide()
  else
	if aCombatStyle:IsShown() then aCombatStyle:Hide() end
    uSpellBook:SetAttribute("userToggle", true)
    uSpellBook:Show()
  end
]=])

-- Shift+Click to reset position 
Toggle:SetScript("OnMouseUp", function(self)
    if IsShiftKeyDown() and not InCombatLockdown() then
        local f = WORS_U_SpellBook.frame
        f:ClearAllPoints()
        f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)
        print("|cff00ff00Spell/Prayer Book position reset.|r")
    end
end)

-- Secure CLOSE button inside the frame (works in combat)
local closeButton = CreateFrame("Button", nil, WORS_U_SpellBook.frame, "SecureHandlerClickTemplate")
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_SpellBook.frame, "TOPRIGHT", 4, 4)
WORS_U_SpellBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")

closeButton:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
closeButton:SetAttribute("_onclick", [=[
  local uSpellBook = self:GetFrameRef("uSpellBook")
  uSpellBook:SetAttribute("userToggle", nil)
  uSpellBook:Hide()
]=])