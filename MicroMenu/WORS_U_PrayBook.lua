if not WORS_U_PrayerBookSettings then WORS_U_PrayerBookSettings = {} end
if WORS_U_PrayerBookSettings.hideAboveLevel == nil then WORS_U_PrayerBookSettings.hideAboveLevel = false end
if WORS_U_PrayerBookSettings.scaleButtons == nil then WORS_U_PrayerBookSettings.scaleButtons = true end
if not WORS_U_PrayerBookSettings.activeFilters then
    WORS_U_PrayerBookSettings.activeFilters = {
        Protection = true,
        Other = true,
    }
end


-- WORS_U_PrayBook Data
WORS_U_PrayBook = {}  -- Create the main table for the PrayBook

WORS_U_PrayBook.prayers = {
    {level = 1, id = 79502, buffIcon = "Interface\\Icons\\active_thickskin.blp"},  -- Thick Skin
    {level = 4, id = 79506, buffIcon = "Interface\\Icons\\active_burststrength.blp"},  -- Burst of Strength
    {level = 7, id = 79508, buffIcon = "Interface\\Icons\\active_claritythought.blp"},  -- Clarity of Thought
    {level = 8, id = 79512, buffIcon = "Interface\\Icons\\active_sharpeye.blp"},  -- Sharp Eye
    {level = 9, id = 79514, buffIcon = "Interface\\Icons\\active_mysticwill.blp"},  -- Mystic Will
    {level = 10, id = 79503, buffIcon = "Interface\\Icons\\active_rockskin.blp"},  -- Rock Skin
    {level = 13, id = 79505, buffIcon = "Interface\\Icons\\active_superhumanstrength.blp"},  -- Superhuman Strength
    {level = 16, id = 79509, buffIcon = "Interface\\Icons\\active_improvedreflexes.blp"},  -- Improved Reflexes
    {level = 19, id = 80019, buffIcon = "Interface\\Icons\\active_rapidrestore.blp"},    -- Rapid Restore
    {level = 22, id = 79521, buffIcon = "Interface\\Icons\\active_rapidheal.blp"},    -- Rapid Heal
    {level = 25, id = 114131, category = "Protection", buffIcon = "Interface\\Icons\\active_protectitem.blp"},    -- Protect Item
    {level = 26, id = 79511, buffIcon = "Interface\\Icons\\active_hawkeye.blp"},    -- Hawk Eye
    {level = 27, id = 79516, buffIcon = "Interface\\Icons\\active_mysticlore.blp"},    -- Mystic Lore
    {level = 28, id = 79504, buffIcon = "Interface\\Icons\\active_steelskin.blp"},    -- Steel Skin
    {level = 31, id = 79507, buffIcon = "Interface\\Icons\\active_ultimatestrength.blp"},    -- Ultimate Strength
    {level = 34, id = 79510, buffIcon = "Interface\\Icons\\active_incrediblereflexes.blp"},    -- Incredible Reflexes
    {level = 37, id = 79501, category = "Protection", buffIcon = "Interface\\Icons\\active_magicpray.blp"},    -- Protect from Magic
    {level = 40, id = 79500, category = "Protection", buffIcon = "Interface\\Icons\\active_rangepray.blp"},    -- Protect from Missiles
    {level = 43, id = 465, category = "Protection", buffIcon = "Interface\\Icons\\active_meleepray.blp"},    -- Protect from Melee
    {level = 44, id = 79513, buffIcon = "Interface\\Icons\\active_eagleeye.blp"},    -- Eagle Eye
    {level = 45, id = 79515, buffIcon = "Interface\\Icons\\active_mysticmight.blp"},    -- Mystic Might
    --{level = 46, id = nil, buffIcon = "Interface\\Icons\\active_.blp"},    -- Retribution
    --{level = 49, id = nil, buffIcon = "Interface\\Icons\\active_.blp"},    -- Redemption
    --{level = 52, id = nil, buffIcon = "Interface\\Icons\\active_.blp"},    -- Smite
    --{level = 55, id = nil, buffIcon = "Interface\\Icons\\active_.blp"},    -- Preserve
    --{level = 60, id = 79517, buffIcon = "Interface\\Icons\\active_chivalry.blp"},    -- Chivalry
    --{level = 70, id = 79518, buffIcon = "Interface\\Icons\\active_piety.blp"},    -- Piety
    --{level = 74, id = 79519, buffIcon = "Interface\\Icons\\active_rigour.blp"},    -- Rigour
    --{level = 77, id = 79520, buffIcon = "Interface\\Icons\\active_augury.blp"},    -- Augury
}

WORS_U_PrayBook.filterGroups = {
	["Protection"] = { 114131, 79501, 79500, 465,},
} 




-- Function to initialize Prayer level from rep
local prayerLevel = 1
local function InitializePrayerLevel()
	_, _, prayerLevel, _, _, _ = WORSSkillsUtil.GetSkillInfo(Enum.WORSSkills.Prayer)
end

local prayerButtons = {}

local function GetPrayerLayoutForCount(count)
    if not WORS_U_PrayerBookSettings.scaleButtons then
        return 35, 1, 5, 5 -- buttonSize, padding, margin, columns
    elseif count <= 4 then
        return 80, 10, 10, 2
    elseif count <= 8 then
        return 60, 10, 10, 2
    elseif count <= 15 then
        return 50, 6, 10, 3
    elseif count <= 25 then
        return 38, 6, 10, 4
    elseif count <= 40 then
        return 30, 6, 10, 5
    elseif count <= 48 then
        return 25, 5, 10, 6
    else
        return 20, 5, 10, 7
    end
end

local function SetupPrayerButtons()
    if InCombatLockdown() then return end

	-- -- Filter visible prayers
	local visible = {}
	for _, data in ipairs(WORS_U_PrayBook.prayers) do
		local cat = data.category or "Other"
		if WORS_U_PrayerBookSettings.activeFilters[cat]
		and (not WORS_U_PrayerBookSettings.hideAboveLevel or prayerLevel >= data.level) then
			table.insert(visible, data)
		end
	end

    local count = #visible
    local buttonSize, padding, margin, columns = GetPrayerLayoutForCount(count)
    local extraYOffset = 5

    for i, prayerData in ipairs(visible) do
        local prayerID       = prayerData.id
        local requiredLevel  = prayerData.level
        local prayerName, _, prayerIcon = GetSpellInfo(prayerID)

        local prayerButton = prayerButtons[i]
        if not prayerButton then
            prayerButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame, "SecureActionButtonTemplate")
            prayerButton:RegisterForDrag("LeftButton")
            prayerButton:SetScript("OnDragStart", function(self)
                if not self.prayerID then return end
                local name = GetSpellInfo(self.prayerID)
                if name and IsSpellKnown(self.prayerID) then
                    PickupSpell(name)
                end
            end)

            prayerButton.icon = prayerButton:CreateTexture(nil, "BACKGROUND")
            prayerButton.icon:SetAllPoints()

            prayerButton:RegisterForClicks("AnyUp")
            prayerButton:SetAttribute("type", "spell")
            prayerButton:SetAttribute("checkselfcast", true)

            prayerButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                if self.prayerID then
                    GameTooltip:SetSpellByID(self.prayerID)
                    if prayerLevel < self.prayerData.level then
                        GameTooltip:AddLine("Requires Prayer Level " .. self.prayerData.level, 1, 0, 0, true)
                    end
                    GameTooltip:Show()
                end
            end)
            prayerButton:SetScript("OnLeave", GameTooltip_Hide)

            prayerButton:SetScript("OnUpdate", function(self)
                if self.prayerName and self.prayerData and self.prayerData.buffIcon then
                    if UnitBuff("player", self.prayerName) then
                        self.icon:SetTexture(self.prayerData.buffIcon)
                    else
                        self.icon:SetTexture(self.prayerIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
                    end
                end
            end)

            prayerButtons[i] = prayerButton
        end

        prayerButton.index      = i
        prayerButton.prayerID   = prayerID
        prayerButton.prayerName = prayerName
        prayerButton.prayerData = prayerData
        prayerButton.prayerIcon = prayerIcon
        prayerButton:SetAttribute("spell", prayerName)

        prayerButton:SetSize(buttonSize, buttonSize)
        prayerButton.icon:SetTexture(prayerIcon or "Interface\\Icons\\INV_Misc_QuestionMark")

        if prayerLevel < requiredLevel then
            prayerButton.icon:SetVertexColor(0.2, 0.2, 0.2)
        else
            prayerButton.icon:SetVertexColor(1, 1, 1)
        end

        local row    = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        prayerButton:ClearAllPoints()
        prayerButton:SetPoint(
            "TOPLEFT", WORS_U_PrayBook.frame, "TOPLEFT",
            margin + (buttonSize + padding) * column,
            -margin - extraYOffset - (buttonSize + padding) * row
        )

        prayerButton:Show()
    end

    -- Hide leftover buttons
    for i = count + 1, #prayerButtons do
        if prayerButtons[i] then prayerButtons[i]:Hide() end
    end
end

-- ===========================
-- SECURE WRAPPER + VISIBILITY
-- ===========================

-- Create the main frame as a secure handler so it can Show/Hide in combat
WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent, "SecureHandlerShowHideTemplate,SecureHandlerStateTemplate,OldSchoolFrameTemplate")
--WORS_U_PrayBook.frame:SetSize(192, 304)

WORS_U_PrayBook.frame:SetSize(192, 355)
tinsert(UISpecialFrames, "WORS_U_PrayBookFrame")

WORS_U_PrayBook.frame:SetFrameStrata("LOW")
WORS_U_PrayBook.frame:SetFrameLevel(20)

local bg = WORS_U_PrayBook.frame:CreateTexture(nil, "LOW")
WORS_U_PrayBook.frame.Background = bg
bg:SetTexture("Interface\\WORS\\OldSchoolBackground1")
bg:SetAllPoints(WORS_U_PrayBook.frame)
bg:SetHorizTile(true)
bg:SetVertTile(true)

WORS_U_PrayBook.frame:Hide()
WORS_U_PrayBook.frame:SetMovable(true)
WORS_U_PrayBook.frame:EnableMouse(true)
WORS_U_PrayBook.frame:RegisterForDrag("LeftButton")
WORS_U_PrayBook.frame:SetClampedToScreen(true)

WORS_U_PrayBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_PrayBook.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing() 
	self:SetUserPlaced(true) 
	-- Print out the current anchor info
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
   --print("PrayBook position:", point, relativeTo and relativeTo:GetName() or "UIParent", relativePoint, xOfs, yOfs)
end)


if WORS_U_PrayBookFrame.CloseButton then WORS_U_PrayBookFrame.CloseButton:ClearAllPoints() end


-- Build content when the frame becomes visible and we're not in combat
WORS_U_PrayBook.frame:SetScript("OnShow", function()
    if not InCombatLockdown() then
        InitializePrayerLevel()
        SetupPrayerButtons()
    end
end)

-- Update micro button tint on show/hide
local function UpdateButtonBackground()
    if WORS_U_PrayBook.frame:IsShown() then
		PrayerMicroButton:SetButtonState("PUSHED", true)
	else
		PrayerMicroButton:SetButtonState("NORMAL", true)
    end
end
WORS_U_PrayBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_PrayBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- =========================================
-- EVENTS: keep icons up-to-date 
-- =========================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") 
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
--eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if InCombatLockdown() then return end
		if WORS_U_PrayBook.frame and not WORS_U_PrayBook.frame:IsUserPlaced() then
            WORS_U_PrayBook.frame:ClearAllPoints()
            WORS_U_PrayBook.frame:SetPoint("RIGHT", UIParent, "RIGHT", -270, 5)
            WORS_U_PrayBook.frame:SetUserPlaced(true)
		end
		
		InitializePrayerLevel()
		SetupPrayerButtons()	
	elseif event == "PLAYER_REGEN_ENABLED" then
		InitializePrayerLevel()
		SetupPrayerButtons()
	end
end)


-- =========================
-- SECURE CLOSE BUTTON
-- =========================
local closeButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame, "SecureHandlerClickTemplate")
closeButton:SetSize(16, 16)
closeButton:SetPoint("TOPRIGHT", WORS_U_PrayBook.frame, "TOPRIGHT", 4, 4)
WORS_U_PrayBook.closeButton = closeButton
closeButton:SetNormalTexture("Interface\\WORS\\OldSchool-CloseButton-Up.blp")
closeButton:SetHighlightTexture("Interface\\WORS\\OldSchool-CloseButton-Highlight.blp", "ADD")
closeButton:SetPushedTexture("Interface\\WORS\\OldSchool-CloseButton-Down.blp")

closeButton:SetFrameRef("uPrayerBook", WORS_U_PrayBook.frame)
closeButton:SetAttribute("_onclick", [=[
  local uPrayerBook = self:GetFrameRef("uPrayerBook")
  uPrayerBook:SetAttribute("userToggle", nil)
  uPrayerBook:Hide()
]=])

-- =========================
-- Secure Toggle
-- =========================
local PrayerMicroMenuToggle = CreateFrame("Button", "WORS_UPrayBook_Toggle", UIParent, "SecureHandlerClickTemplate")
if PrayerMicroButton then
	WORS_UPrayBook_Toggle:ClearAllPoints()
	WORS_UPrayBook_Toggle:SetParent(PrayerMicroButton)
	WORS_UPrayBook_Toggle:SetAllPoints(PrayerMicroButton)
	WORS_UPrayBook_Toggle:SetFrameStrata(PrayerMicroButton:GetFrameStrata())
	WORS_UPrayBook_Toggle:SetFrameLevel(PrayerMicroButton:GetFrameLevel() + 1)
	WORS_UPrayBook_Toggle:RegisterForClicks("AnyUp")
	if PrayerMicroButton:GetScript("OnEnter") then
		WORS_UPrayBook_Toggle:SetScript("OnEnter", function()
			PrayerMicroButton:GetScript("OnEnter")(PrayerMicroButton)
		end)
	end
	if PrayerMicroButton:GetScript("OnLeave") then
		WORS_UPrayBook_Toggle:SetScript("OnLeave", function()
			PrayerMicroButton:GetScript("OnLeave")(PrayerMicroButton)
		end)
	end
end

PrayerMicroMenuToggle:RegisterForClicks("AnyUp")
PrayerMicroMenuToggle:SetFrameRef("uPrayerBook", WORS_U_PrayBook.frame)
PrayerMicroMenuToggle:SetAttribute("_onclick", [=[
	local f = self:GetFrameRef("uPrayerBook")
	if not f then return end

	-- Flip desired state
	local willShow = not f:GetAttribute("userToggle")
	f:SetAttribute("userToggle", willShow and true or nil)

	-- Apply visibility to match the flag
	if willShow then
		f:Show()
	else
		f:Hide()
	end
]=])

WORS_U_PrayBook.frame:SetAttribute("_onshow", [=[
  self:SetAttribute("userToggle", true)
]=])

WORS_U_PrayBook.frame:SetAttribute("_onhide", [=[
  self:SetAttribute("userToggle", nil)
]=])

-- =========================
-- Keybind Secure Toggle 
-- =========================
local kb = CreateFrame("Frame")
kb:RegisterEvent("PLAYER_LOGIN")
kb:RegisterEvent("UPDATE_BINDINGS")
kb:RegisterEvent("PLAYER_REGEN_ENABLED")
kb:SetScript("OnEvent", function(self, event)
	if InCombatLockdown() then
		self.need = true
		return
	end

	-- bind both keys for TOGGLEPRAYER
	local k1, k2 = GetBindingKey("TOGGLEPRAYER")
	if k1 then SetOverrideBindingClick(UIParent, true, k1, "WORS_UPrayBook_Toggle", "LeftButton") end
	if k2 then SetOverrideBindingClick(UIParent, true, k2, "WORS_UPrayBook_Toggle", "LeftButton") end

	if event == "PLAYER_REGEN_ENABLED" then
		self.need = nil
	end
end)


-- =========================
-- FILTER MENU UI (Prayer)
-- =========================
local filterMenu = CreateFrame("Frame", "WORS_U_PrayBookFilterMenu", WORS_U_PrayBook.frame, "OldSchoolFrameTemplate")
filterMenu:SetSize(160, 215)
filterMenu:SetPoint("CENTER", WORS_U_PrayBook.frame, "CENTER", 0, 0)
filterMenu:Hide()
filterMenu:SetFrameStrata("TOOLTIP")
tinsert(UISpecialFrames, filterMenu:GetName())

local bg = filterMenu:CreateTexture(nil, "BACKGROUND")
filterMenu.Background = bg
bg:SetTexture("Interface\\WORS\\OldSchoolBackground1")
bg:SetAllPoints(filterMenu)
bg:SetHorizTile(true)
bg:SetVertTile(true)

-- =========================
-- Helper: Create toggle buttons
-- =========================
local function CreateToggleButton(parent, key, label, anchor, isSetting)
    local btn = parent[key] or CreateFrame("Button", nil, parent, "OldSchoolButtonTemplate")
    parent[key] = btn
    btn:SetSize(130, 30)

    if anchor then
        btn:SetPoint("TOP", anchor, "BOTTOM", 0, -10)
    else
        btn:SetPoint("TOP", parent, "TOP", 0, -12)
    end

    btn:SetText(label)
    btn.Text:SetTextColor(1, 0.5, 0) -- orange text

    btn:SetScript("OnClick", function(self)
        if isSetting then
            WORS_U_PrayerBookSettings[key] = not WORS_U_PrayerBookSettings[key]
            self:SetSelected(WORS_U_PrayerBookSettings[key])
        else
            WORS_U_PrayerBookSettings.activeFilters[key] = not WORS_U_PrayerBookSettings.activeFilters[key]
            self:SetSelected(WORS_U_PrayerBookSettings.activeFilters[key])
        end
        SetupPrayerButtons()
    end)

    if isSetting then
        btn:SetSelected(WORS_U_PrayerBookSettings[key])
    else
        btn:SetSelected(WORS_U_PrayerBookSettings.activeFilters[key])
    end

    return btn
end

-- =========================
-- Build Filter Buttons
-- =========================
local btnProtection = CreateToggleButton(filterMenu, "Protection", "Show Protection Prayers")
local btnOther      = CreateToggleButton(filterMenu, "Other", "Show Other Prayers", btnProtection)
local btnHideAbove  = CreateToggleButton(filterMenu, "hideAboveLevel", "Hide Above Level", btnOther, true)
local btnScale      = CreateToggleButton(filterMenu, "scaleButtons", "Scale Buttons", btnHideAbove, true)


-- =========================
-- Bottom bar (Prayer tracker + Filters button)
-- =========================
local bottomBar = CreateFrame("Frame", nil, WORS_U_PrayBook.frame)
bottomBar:SetSize(WORS_U_PrayBook.frame:GetWidth(), 25)
bottomBar:SetPoint("BOTTOM", WORS_U_PrayBook.frame, "BOTTOM", 0, 5)

-- tweak this value to bring Prayer and Filters closer/further
local PRAYER_FILTER_GAP = 10   -- smaller = closer, larger = more spaced

-- Prayer display
local prayerDisplay = bottomBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
prayerDisplay:SetPoint("RIGHT", bottomBar, "CENTER", -PRAYER_FILTER_GAP, 0)
prayerDisplay:SetTextColor(1, 0.5, 0)

local function UpdatePrayerDisplay()
    local v     = UnitPower("player", 0)       -- 0 = mana
    local vmax  = UnitPowerMax("player", 0) or 1
    local shown    = math.ceil((v or 0) / 1000)
    local maxShown = math.ceil((vmax or 0) / 1000)

    prayerDisplay:SetFormattedText(
        "|TInterface\\Icons\\Skills\\Prayericon:16:16:0:0|t %d / %d |TInterface\\Icons\\Skills\\Prayericon:16:16:0:0|t",
        shown, maxShown
    )
end

-- update events
local manaEvents = CreateFrame("Frame")
manaEvents:RegisterEvent("UNIT_MANA")
manaEvents:RegisterEvent("UNIT_MAXMANA")
manaEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
manaEvents:SetScript("OnEvent", function(_, event, unit)
    if unit == "player" or event == "PLAYER_ENTERING_WORLD" then
        UpdatePrayerDisplay()
    end
end)
UpdatePrayerDisplay()

-- Filters button
local filterToggle = CreateFrame("Button", nil, bottomBar, "OldSchoolButtonTemplate")
filterToggle:SetSize(50, 20)
filterToggle:SetPoint("LEFT", bottomBar, "CENTER", PRAYER_FILTER_GAP, 0)
filterToggle:SetText("Filters")
filterToggle.Text:SetTextColor(1, 0.5, 0)




filterMenu:HookScript("OnShow", function()
    btnProtection:SetSelected(WORS_U_PrayerBookSettings.activeFilters.Protection)
    if btnOther then
        btnOther:SetSelected(WORS_U_PrayerBookSettings.activeFilters.Other)
    end
    btnHideAbove:SetSelected(WORS_U_PrayerBookSettings.hideAboveLevel)
    btnScale:SetSelected(WORS_U_PrayerBookSettings.scaleButtons)
end)

filterMenu:HookScript("OnHide", function()
    if filterToggle.SetSelected then
        filterToggle:SetSelected(false)
    end
end)

filterToggle:SetScript("OnClick", function(self)
    if filterMenu:IsShown() then
        filterMenu:Hide()
    else
        filterMenu:Show()
    end
end)

WORS_U_PrayBook.frame:HookScript("OnHide", function()
    if filterMenu:IsShown() then
        filterMenu:Hide()
    end
end)
