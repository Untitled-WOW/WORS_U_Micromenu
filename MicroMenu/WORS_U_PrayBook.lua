-- Function to initialize Prayer level from rep
local prayerLevel = 1
local function InitializePrayerLevel()
	_, _, prayerLevel, _, _, _ = WORSSkillsUtil.GetSkillInfo(Enum.WORSSkills.Prayer)
end

local prayerButtons = {}

-- Function to set up prayer buttons  
local function SetupPrayerButtons()
    if InCombatLockdown() then
        -- can't create/modify secure children in combat
        return
    end

    local buttonSize = 35
    local padding    = 2          -- space between buttons
    local margin     = 5           -- space from frame edge
    local columns    = 5

    for i, prayerData in ipairs(WORS_U_PrayBook.prayers) do
        local prayerID       = prayerData.id
        local requiredLevel  = prayerData.level
        local prayerName, _, prayerIcon = GetSpellInfo(prayerID)

        -- ✅ Reuse button if it exists, otherwise create it once
        local prayerButton = prayerButtons[i]
        if not prayerButton then
            prayerButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame, "SecureActionButtonTemplate")
            prayerButton:SetSize(buttonSize, buttonSize)

            -- Create and store icon texture
            prayerButton.icon = prayerButton:CreateTexture(nil, "BACKGROUND")
            prayerButton.icon:SetAllPoints()

            -- One-time setup
            prayerButton:RegisterForClicks("AnyUp")
            prayerButton:SetAttribute("type", "spell")
            prayerButton:SetAttribute("checkselfcast", true)

            -- Tooltip
            prayerButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                if self.prayerID then
                    GameTooltip:SetSpellByID(self.prayerID)
                end
                GameTooltip:Show()
            end)
            prayerButton:SetScript("OnLeave", GameTooltip_Hide)

            -- Buff check updater (just swaps icon if buff active)
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

        -- Update spell data references
        prayerButton.prayerID   = prayerID
        prayerButton.prayerName = prayerName
        prayerButton.prayerData = prayerData
        prayerButton.prayerIcon = prayerIcon

        prayerButton:SetAttribute("spell", prayerName)

        -- Update icon + color
        prayerButton.icon:SetTexture(prayerIcon or "Interface\\Icons\\INV_Misc_QuestionMark")
        if prayerLevel < requiredLevel then
            prayerButton.icon:SetVertexColor(0.2, 0.2, 0.2) -- not high enough level
        else
            prayerButton.icon:SetVertexColor(1, 1, 1)
        end

        -- Reposition
        local row    = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        prayerButton:ClearAllPoints()
        prayerButton:SetPoint(
            "TOPLEFT", WORS_U_PrayBook.frame, "TOPLEFT",
            margin + (buttonSize + padding) * column,
            -margin - (buttonSize + padding) * row
        )

        prayerButton:Show()
    end

    -- ✅ Hide leftover buttons if prayer list shrinks
    for i = #WORS_U_PrayBook.prayers + 1, #prayerButtons do
        if prayerButtons[i] then
            prayerButtons[i]:Hide()
        end
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


