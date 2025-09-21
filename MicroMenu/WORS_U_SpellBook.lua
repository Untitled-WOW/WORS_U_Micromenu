-- =========================
-- WORS_U_SpellBook.lua
-- =========================
if not WORS_U_SpellBookSettings then
    WORS_U_SpellBookSettings = {}
end

if not WORS_U_SpellBookSettings.activeFilters then
    WORS_U_SpellBookSettings.activeFilters = {
        Combat = true,
        Teleport = true,
        Utility = true,
    }
end

if WORS_U_SpellBookSettings.hideAboveLevel == nil then
    WORS_U_SpellBookSettings.hideAboveLevel = false
end

if WORS_U_SpellBookSettings.scaleButtons == nil then
    WORS_U_SpellBookSettings.scaleButtons = true
end

local function GetSpellCategory(spellID)
    for group, ids in pairs(WORS_U_SpellBook.filterGroups) do
        for _, id in ipairs(ids) do
            if id == spellID then
                return group
            end
        end
    end
    return "Combat"
end

local magicLevel = 1
local function InitializeMagicLevel()
	_, _, magicLevel, _, _, _ = WORSSkillsUtil.GetSkillInfo(Enum.WORSSkills.Magic)
end

-- Return: buttonSize, colPadding, rowPadding, margin, columns
local function GetLayoutForCount(count)
    if not WORS_U_SpellBookSettings.scaleButtons then
		return 20, 5, 5, 10, 7	
	elseif count <= 4 then
		return 80, 10, 10, 10, 2
	elseif count <= 8 then	
        return 60, 20, 10, 10, 2
    elseif count <= 15 then
        return 50, 6, 2, 10, 3
    elseif count <= 25 then
        return 38, 6, 2, 10, 4	
    elseif count <= 40 then
        return 30, 6, 2, 10, 5			
	elseif count <= 48 then
        return 25, 5, 2, 10, 6				
	else
        return 20, 5, 5, 10, 7
    end
end



local magicButtons = {}

local function SetupMagicButtons()
    if InCombatLockdown() then return end

    -- Build a filtered list of visible spells
    local visible = {}
    for _, data in ipairs(WORS_U_SpellBook.spells) do
        local cat = GetSpellCategory(data.id)
		if (WORS_U_SpellBookSettings.activeFilters[cat]) 
		and (not WORS_U_SpellBookSettings.hideAboveLevel or magicLevel >= data.level) then
			table.insert(visible, data)
		end

    end

    local count = #visible
    -- Get layout values: buttonSize, colPad, rowPad, margin, columns
    local buttonSize, colPad, rowPad, margin, columns = GetLayoutForCount(count)

    -- Calculate total grid width for centering the block
    local frameWidth = WORS_U_SpellBook.frame:GetWidth()
    local totalGridWidth = columns * buttonSize + (columns - 1) * colPad
    local startX = (frameWidth - totalGridWidth) / 2

    for i, data in ipairs(visible) do
        local spellID = data.id
        local requiredLevel = data.level
        local _, _, icon = GetSpellInfo(spellID)

        local btn = magicButtons[i]
        if not btn then
            btn = CreateFrame("Button", nil, WORS_U_SpellBook.frame, "SecureActionButtonTemplate")
            btn:RegisterForDrag("LeftButton")
            btn:SetScript("OnDragStart", function(self)
                if self.spellID and IsSpellKnown(self.spellID) then
                    local name = GetSpellInfo(self.spellID)
                    if name then PickupSpell(name) end
                end
            end)
            btn.icon = btn:CreateTexture(nil, "BACKGROUND")
            btn.icon:SetAllPoints()
            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                if self.spellID then
                    GameTooltip:SetSpellByID(self.spellID)
                    local sd = WORS_U_SpellBook.spells[self.index]
                    if sd and magicLevel < sd.level then
                        GameTooltip:AddLine("Requires Magic Level " .. sd.level, 1, 0, 0, true)
                        GameTooltip:Show()
                    end
                end
            end)
            btn:SetScript("OnLeave", GameTooltip_Hide)
            magicButtons[i] = btn
        end

        btn:SetSize(buttonSize, buttonSize)
        btn.index = i
        btn.spellID = spellID
        btn:SetAttribute("type","spell")
        btn:SetAttribute("spell",spellID)
        btn.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")

        local row = math.floor((i-1)/columns)
        local col = (i-1)%columns

        btn:ClearAllPoints()
        btn:SetPoint(
            "TOPLEFT", WORS_U_SpellBook.frame, "TOPLEFT",
            startX + col*(buttonSize+colPad),
            -margin - row*(buttonSize+rowPad)
        )

        if magicLevel < requiredLevel then
            btn.icon:SetVertexColor(0.1,0.1,0.1)
        elseif WORS_U_SpellBook:HasRequiredRunes(data.runes) then
            btn.icon:SetVertexColor(1,1,1)
        else
            btn.icon:SetVertexColor(0.25,0.25,0.25)
        end

        btn:Show()
    end

    -- Hide leftover buttons
    for i = count+1, #magicButtons do
        if magicButtons[i] then magicButtons[i]:Hide() end
    end
end



-- ===========================
-- SECURE WRAPPER + VISIBILITY
-- ===========================
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

if WORS_U_SpellBookFrame.CloseButton then WORS_U_SpellBookFrame.CloseButton:ClearAllPoints() end

local function UpdateButtonBackground()
    if WORS_U_SpellBook.frame:IsShown() then
        U_SpellMicroMenuButton:SetButtonState("PUSHED", true)
    else
        U_SpellMicroMenuButton:SetButtonState("NORMAL", true)
    end
end
WORS_U_SpellBook.frame:SetScript("OnShow", UpdateButtonBackground)
WORS_U_SpellBook.frame:SetScript("OnHide", UpdateButtonBackground)

-- =========================================
-- EVENTS
-- =========================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
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
-- SECURE CLOSE BUTTON
-- =========================
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

-- =========================
-- FILTER MENU UI
-- =========================
local filterMenu = CreateFrame("Frame", "WORS_U_SpellBookFilterMenu", WORS_U_SpellBook.frame, "OldSchoolFrameTemplate")
filterMenu:SetSize(160, 215)
filterMenu:SetPoint("CENTER", WORS_U_SpellBook.frame, "CENTER", 0, 0) -- open over spellbook
filterMenu:Hide()
filterMenu:SetFrameStrata("TOOLTIP")

-- Allow closing with Escape like normal frames
tinsert(UISpecialFrames, filterMenu:GetName())

-- Background texture (like spellbook frame)
local bg = filterMenu:CreateTexture(nil, "BACKGROUND")
filterMenu.Background = bg
bg:SetTexture("Interface\\WORS\\OldSchoolBackground1")
bg:SetAllPoints(filterMenu)
bg:SetHorizTile(true)
bg:SetVertTile(true)

-- =========================
-- HELPER: Create toggle buttons
-- =========================
local function CreateToggleButton(parent, key, label, anchor, isSetting)
    local btn = parent[key] or CreateFrame("Button", nil, parent, "OldSchoolButtonTemplate")
    parent[key] = btn
    btn:SetSize(120, 30)

    if anchor then
        btn:SetPoint("TOP", anchor, "BOTTOM", 0, -10)
    else
        btn:SetPoint("TOP", parent, "TOP", 0, -12)
    end

    btn:SetText(label)
    btn.Text:SetTextColor(1, 0.5, 0) -- orange text

    btn:SetScript("OnClick", function(self)
        if isSetting then
            -- toggle boolean setting
            WORS_U_SpellBookSettings[key] = not WORS_U_SpellBookSettings[key]
            self:SetSelected(WORS_U_SpellBookSettings[key])
        else
            -- toggle filter
            WORS_U_SpellBookSettings.activeFilters[key] = not WORS_U_SpellBookSettings.activeFilters[key]
            self:SetSelected(WORS_U_SpellBookSettings.activeFilters[key])
        end
        SetupMagicButtons()
    end)

    -- set initial visual state
    if isSetting then
        btn:SetSelected(WORS_U_SpellBookSettings[key])
    else
        btn:SetSelected(WORS_U_SpellBookSettings.activeFilters[key])
    end

    return btn
end

-- =========================
-- BUILD FILTER BUTTONS
-- =========================
local btnCombat   = CreateToggleButton(filterMenu, "Combat",   "Show Combat Spells")
local btnTeleport = CreateToggleButton(filterMenu, "Teleport", "Show Teleport Spells", btnCombat)
local btnUtility  = CreateToggleButton(filterMenu, "Utility",  "Show Utility Spells",  btnTeleport)

local btnHideAbove = CreateToggleButton(filterMenu, "hideAboveLevel", "Hide Above Level", btnUtility, true)
local btnScale     = CreateToggleButton(filterMenu, "scaleButtons",   "Scale Buttons",   btnHideAbove, true)

-- =========================
-- TOGGLE BUTTON (on Spellbook frame)
-- =========================
local filterToggle = CreateFrame("Button", nil, WORS_U_SpellBook.frame, "OldSchoolButtonTemplate")
filterToggle:SetSize(50, 20)
filterToggle:SetPoint("BOTTOM", WORS_U_SpellBook.frame, "BOTTOM", 0, 10)
filterToggle:SetText("Filters")
filterToggle.Text:SetTextColor(1, 0.5, 0) -- orange

-- Keep the toggle's visual state in sync with the menu
filterMenu:HookScript("OnShow", function()
    btnCombat:SetSelected(WORS_U_SpellBookSettings.activeFilters.Combat)
    btnTeleport:SetSelected(WORS_U_SpellBookSettings.activeFilters.Teleport)
    btnUtility:SetSelected(WORS_U_SpellBookSettings.activeFilters.Utility)
    btnHideAbove:SetSelected(WORS_U_SpellBookSettings.hideAboveLevel)
    btnScale:SetSelected(WORS_U_SpellBookSettings.scaleButtons)
end)
filterMenu:HookScript("OnHide", function()
    if filterToggle.SetSelected then
        filterToggle:SetSelected(false)
    end
end)
filterToggle:SetScript("OnClick", function(self)
    if filterMenu:IsShown() then
        filterMenu:Hide()
        -- OnHide hook will clear selection
    else
        filterMenu:Show()
        -- OnShow hook will set selection
    end
end)
WORS_U_SpellBook.frame:HookScript("OnHide", function()
    if filterMenu:IsShown() then
        filterMenu:Hide()
    end
end)


