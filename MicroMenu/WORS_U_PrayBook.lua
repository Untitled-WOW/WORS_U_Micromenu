if not WORS_U_PrayerBookSettings then WORS_U_PrayerBookSettings = {} end
if WORS_U_PrayerBookSettings.hideAboveLevel == nil then WORS_U_PrayerBookSettings.hideAboveLevel = false end
if WORS_U_PrayerBookSettings.scaleButtons == nil then WORS_U_PrayerBookSettings.scaleButtons = true end
if not WORS_U_PrayerBookSettings.activeFilters then
    WORS_U_PrayerBookSettings.activeFilters = {
        Protection = true,
        Other = true,
    }
end

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
--WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent, "SecureHandlerStateTemplate,OldSchoolFrameTemplate")

WORS_U_PrayBook.frame:SetSize(192, 304)

WORS_U_PrayBook.frame:SetFrameStrata("LOW")
WORS_U_PrayBook.frame:SetFrameLevel(10)

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
	SaveFramePosition(self)
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
        --PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- red when open
		U_PrayerMicroMenuButton:SetButtonState("PUSHED", true)
	else
        --PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- default
		U_PrayerMicroMenuButton:SetButtonState("NORMAL", true)
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
		local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
		if pos then
			local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
			WORS_U_PrayBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
		else
			ResetMicroMenuPOSByAspect(WORS_U_PrayBook.frame)
			SaveFramePosition(WORS_U_PrayBook.frame)
		end	
		InitializePrayerLevel()
		SetupPrayerButtons()	
	elseif event == "PLAYER_REGEN_ENABLED" then
		InitializePrayerLevel()
		SetupPrayerButtons()
	end
end)



-- Secure CLOSE button inside the frame (works in combat)
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
