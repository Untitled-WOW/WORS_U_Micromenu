-- Function to initialize Prayer level from rep
local magicLevel = 1
local function InitializeMagicLevel()
	_, _, magicLevel, _, _, _ = WORSSkillsUtil.GetSkillInfo(Enum.WORSSkills.Magic)
end

local magicButtons = {}


-- Function to set up magic buttons  
local function SetupMagicButtons()
    if InCombatLockdown() then return end

    local buttonSize = 20
    local padding    = 5          -- space between buttons
    local margin     = 10         -- space from frame edge
    local columns    = 7

    for i, spellData in ipairs(WORS_U_SpellBook.spells) do
        local spellID       = spellData.id
        local requiredLevel = spellData.level
        local spellName, _, spellIcon = GetSpellInfo(spellID)

        -- ✅ Reuse button if it exists, otherwise create it once
        local spellButton = magicButtons[i]
        if not spellButton then
            spellButton = CreateFrame("Button", nil, WORS_U_SpellBook.frame, "SecureActionButtonTemplate")
            spellButton:SetSize(buttonSize, buttonSize)

            -- Create and store icon texture
            spellButton.icon = spellButton:CreateTexture(nil, "BACKGROUND")
            spellButton.icon:SetAllPoints()

            -- Tooltip handlers
            spellButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                if self.spellID then
                    GameTooltip:SetSpellByID(self.spellID)
                end
                GameTooltip:Show()
            end)
            spellButton:SetScript("OnLeave", GameTooltip_Hide)

            magicButtons[i] = spellButton
        end

        -- Update secure attributes
        spellButton.spellID = spellID
        spellButton:SetAttribute("type", "spell")
        spellButton:SetAttribute("spell", spellID)

        -- Update icon
        spellButton.icon:SetTexture(spellIcon or "Interface\\Icons\\INV_Misc_QuestionMark")

        -- Position
        local row    = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        spellButton:ClearAllPoints()
        spellButton:SetPoint(
            "TOPLEFT", WORS_U_SpellBook.frame, "TOPLEFT",
            margin + (buttonSize + padding) * column,
            -margin - (buttonSize + padding) * row
        )

        -- Update color based on requirements
        if magicLevel < requiredLevel then
            spellButton.icon:SetVertexColor(0.1, 0.1, 0.1) -- No magic level: Dark Gray
        elseif WORS_U_SpellBook:HasRequiredRunes(spellData.runes) then
            spellButton.icon:SetVertexColor(1, 1, 1)       -- Can cast
        else
            spellButton.icon:SetVertexColor(0.25, 0.25, 0.25) -- No runes
        end

        spellButton:Show()
    end

    -- ✅ Hide any leftover buttons if the spell list shrinks
    for i = #WORS_U_SpellBook.spells + 1, #magicButtons do
        if magicButtons[i] then
            magicButtons[i]:Hide()
        end
    end
end



-- ===========================
-- SECURE WRAPPER + VISIBILITY
-- ===========================

-- Create the main frame as a secure handler so it can Show/Hide in combat
--WORS_U_SpellBook.frame = CreateFrame("Frame", "WORS_U_SpellBookFrame", UIParent, "SecureHandlerStateTemplate,OldSchoolFrameTemplate")

WORS_U_SpellBook.frame:SetSize(192, 304)
WORS_U_SpellBook.frame:SetFrameStrata("LOW")
WORS_U_SpellBook.frame:SetFrameLevel(10)

local bg = WORS_U_SpellBook.frame:CreateTexture(nil, "LOW")
WORS_U_SpellBook.frame.Background = bg
bg:SetTexture("Interface\\WORS\\OldSchoolBackground1")
bg:SetAllPoints(WORS_U_SpellBook.frame)
bg:SetHorizTile(true)
bg:SetVertTile(true)

WORS_U_SpellBook.frame:Hide()
WORS_U_SpellBook.frame:SetMovable(true)
WORS_U_SpellBook.frame:EnableMouse(true)
WORS_U_SpellBook.frame:RegisterForDrag("LeftButton")
WORS_U_SpellBook.frame:SetClampedToScreen(true)

WORS_U_SpellBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_SpellBook.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing() 
	SaveFramePosition(self)
end)


-- Hide template button to use securec
if WORS_U_SpellBookFrame.CloseButton then WORS_U_SpellBookFrame.CloseButton:ClearAllPoints() end

-- Update micro button tint on show/hide
local function UpdateButtonBackground()
    if WORS_U_SpellBook.frame:IsShown() then
        --SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- red when open
		U_SpellMicroMenuButton:SetButtonState("PUSHED", true)
    else
        --SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- default
		U_SpellMicroMenuButton:SetButtonState("NORMAL", true)
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
		local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
		if pos then
			local relativeTo = pos.relativeTo and _G[pos.relativeTo] or UIParent
			WORS_U_SpellBook.frame:SetPoint(pos.point, relativeTo, pos.relativePoint, pos.xOfs, pos.yOfs)
		else
			ResetMicroMenuPOSByAspect(WORS_U_SpellBook.frame)
		end	
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

-- Secure TOGGLE overlay on the U_SpellBookMicroButtonCopy


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




