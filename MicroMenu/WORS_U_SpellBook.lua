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

WORS_U_SpellBook = {}

WORS_U_SpellBook.spells = {
    {level = 0, name = "Lumbridge Home Teleport", id = 99561},
    {level = 1, name = "Wind Strike", id = 98952, },
    {level = 3, name = "Confuse", id = 99311, },
 -- {level = 4, name = "Enchant Crossbow Bolt (Opal)", id = nil, },
    {level = 5, name = "Water Strike", id = 79535, },
    {level = 7, name = "Lvl-1 Enchant", id = 460022, openInv = true},
 -- {level = 7, name = "Enchant Crossbow Bolt (Sapphire)", id = nil,},
    {level = 9, name = "Earth Strike", id = 79540, },
    {level = 11, name = "Weaken", id = 99312, },
    {level = 13, name = "Fire Strike", id = 79545, },
 -- {level = 14, name = "Enchant Crossbow Bolt (Jade)", id = nil, },
    {level = 15, name = "Bones to Bananas", id = 99313,  openInv = true},
    {level = 17, name = "Wind Bolt", id = 79531, },
    {level = 19, name = "Curse", id = 99314, },
    {level = 20, name = "Bind", id = 99316, },
    {level = 21, name = "Low Level Alchemy", id = 114135, openInv = true},
    {level = 23, name = "Water Bolt", id = 79536, },
 -- {level = 24, name = "Enchant Crossbow Bolt (Pearl)", id = nil, },
    {level = 25, name = "Varrock Teleport", id = 114193, },
    {level = 27, name = "Lvl-2 Enchant", id = 460023, openInv = true},
 -- {level = 27, name = "Enchant Crossbow Bolt (Emerald)", id = nil, },
    {level = 29, name = "Earth Bolt", id = 79541, },
 -- {level = 29, name = "Enchant Crossbow Bolt (Red Topaz)", id = nil, },
    {level = 31, name = "Lumbridge Teleport", id = 114196, },
    {level = 33, name = "Telekinetic Grab (Corpse)", id = 114134,},
    {level = 33, name = "Telekinetic Grab (Gameobject)", id = 1812, },
    {level = 35, name = "Fire Bolt", id = 79546, },
    {level = 37, name = "Falador Teleport", id = 114194, },
    {level = 39, name = "Crumble Undead", id = 99317,},
 -- {level = 40, name = "Teleport to House", id = nil, },
    {level = 41, name = "Wind Blast", id = 79532, },
    {level = 43, name = "Superheat Item", id = 99318, openInv = true},
    {level = 45, name = "Camelot Teleport", id = 114197, },
    {level = 47, name = "Water Blast", id = 79537, },
 -- {level = 48, name = "Kourend Castle Teleport", id = nil, },
    {level = 49, name = "Lvl-3 Enchant", id = 460024, openInv = true},
 -- {level = 49, name = "Enchant Crossbow Bolt (Ruby)", id = nil, },
 -- {level = 50, name = "Iban Blast", id = nil, },
    {level = 50, name = "Snare", id = 99537,},
 -- {level = 50, name = "Magic Dart", id = nil, },
    {level = 51, name = "Ardougne Teleport", id = 114198, },
    {level = 53, name = "Earth Blast", id = 79542, },
 -- {level = 54, name = "Civitas illa Fortis Teleport", id = nil, },
    {level = 55, name = "High Level Alchemy", id = 200090, openInv = true},
    {level = 56, name = "Charge Water Orb", id = 99233, openInv = true},
    {level = 57, name = "Lvl-4 Enchant", id = 460025, openInv = true},
 -- {level = 57, name = "Enchant Crossbow Bolt (Diamond)", id = nil, runes = {["Cosmic Rune"] = 1, ["Earth Rune"] = 10}},
    {level = 58, name = "Watchtower Teleport", id = 114200, },
    {level = 59, name = "Fire Blast", id = 79547, },
    {level = 60, name = "Charge Earth Orb", id = 99234, openInv = true},
 -- {level = 60, name = "Bones to Peaches", id = nil, },
 -- {level = 60, name = "Saradomin Strike", id = nil, },
 -- {level = 60, name = "Flames of Zamorak", id = nil,},
 -- {level = 60, name = "Claws of Guthix", id = nil, },
    {level = 61, name = "Trollheim Teleport", id = 114199, },
    {level = 62, name = "Wind Wave", id = 79533, },
    {level = 63, name = "Charge Fire Orb", id = 99235, openInv = true},
 -- {level = 64, name = "Ape Atoll Teleport", id = nil, },
    {level = 65, name = "Water Wave", id = 79538, },
    {level = 66, name = "Charge Air Orb",id = 99236, openInv = true},     -- Charge Air Orb
 -- {level = 66, name = "Vulnerability", id = nil, },
    {level = 68, name = "Lvl-5 Enchant", id = 460026, openInv = true},
 -- {level = 68, name = "Enchant Crossbow Bolt (Dragonstone)", id = nil, },
    {level = 70, name = "Earth Wave", id = 79543, },
 -- {level = 73, name = "Enfeeble", id = nil, },
 -- {level = 74, name = "Teleother Lumbridge", id = nil, },
    {level = 75, name = "Fire Wave", id = 79548, },
    {level = 79, name = "Entangle", id = 99315, },
 -- {level = 80, name = "Stun", id = nil, },
    {level = 80, name = "Charge", id = 707049, },
 -- {level = 81, name = "Wind Surge", id = 79534, },
 -- {level = 82, name = "Teleother Falador", id = nil, },
 -- {level = 85, name = "Water Surge", id = 79539, },
    {level = 85, name = "Tele Block", id = 99542, },
 -- {level = 85, name = "Teleport to Target", id = nil, },
 -- {level = 87, name = "Lvl-6 Enchant", id = nil, },
 -- {level = 87, name = "Enchant Crossbow Bolt (Onyx)", id = nil, },
 -- {level = 90, name = "Teleother Camelot", id = nil, },
 -- {level = 90, name = "Earth Surge", id = 79544, },
 -- {level = 93, name = "Lvl-7 Enchant", id = nil, },
 -- {level = 95, name = "Fire Surge", id = 79549, },
}

WORS_U_SpellBook.filterGroups = {
	["Teleport"] = { 99561, 114193, 114196, 114194, 114197, 114198, 114200, 114199,},
	["Utility"] = {460022, 99313, 114135, 460023, 114134, 1812, 99318, 460024, 200090, 99233, 460025, 99234, 99235, 99236, 460026,},
} 

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

-- Works with WORS 3.3.5 magic rune system (ignores mana)
function CanCastSpell(spellData)
    if not spellData or not spellData.id then
        return false
    end

    local name = GetSpellInfo(spellData.id)
    if not name then
        -- custom spell or missing entry in spellbook
        return false
    end

    local usable, nomana = IsUsableSpell(name)

    -- usable = true → player meets all rune/reagent requirements
    if usable then
        return true
    end

    -- usable = false, nomana = true → out of mana (ignore this)
    if not usable and not nomana then
        return false
    end

    return false
end



-- Main function
local function SetupMagicButtons()
    if InCombatLockdown() then return end

    -- Build filtered list of visible spells
    local visible = {}
    for _, data in ipairs(WORS_U_SpellBook.spells) do
        local cat = GetSpellCategory(data.id)
        if (WORS_U_SpellBookSettings.activeFilters[cat])
        and (not WORS_U_SpellBookSettings.hideAboveLevel or magicLevel >= data.level) then
            table.insert(visible, data)
        end
    end

    local count = #visible
    local buttonSize, colPad, rowPad, margin, columns = GetLayoutForCount(count)

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
        btn:SetAttribute("type", "spell")
        btn:SetAttribute("spell", spellID)
        btn.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")

        local row = math.floor((i-1)/columns)
        local col = (i-1)%columns

        btn:ClearAllPoints()
        btn:SetPoint(
            "TOPLEFT", WORS_U_SpellBook.frame, "TOPLEFT",
            startX + col * (buttonSize + colPad),
            -margin - row * (buttonSize + rowPad)
        )

        -- Initial color setup (before OnUpdate kicks in)
        if magicLevel < requiredLevel then
            btn.icon:SetVertexColor(0.1, 0.1, 0.1)
        elseif CanCastSpell(data) then
            btn.icon:SetVertexColor(1, 1, 1)
        else
            btn.icon:SetVertexColor(0.25, 0.25, 0.25)
        end

        -- Throttled OnUpdate to live-refresh rune usability
        btn:SetScript("OnUpdate", function(self, elapsed)
            self._throttle = (self._throttle or 0) + elapsed
            if self._throttle < 0.25 then return end
            self._throttle = 0

            local reqLvl = requiredLevel or 1
            if magicLevel < reqLvl then
                self.icon:SetVertexColor(0.1, 0.1, 0.1)
            elseif CanCastSpell(data) then
                self.icon:SetVertexColor(1, 1, 1)
            else
                self.icon:SetVertexColor(0.25, 0.25, 0.25)
            end
        end)

        btn:Show()
    end

    -- Hide leftover buttons
    for i = count + 1, #magicButtons do
        if magicButtons[i] then magicButtons[i]:Hide() end
    end
end



-- ===========================
-- SECURE WRAPPER + VISIBILITY
-- ===========================
WORS_U_SpellBook.frame = CreateFrame("Frame", "WORS_U_SpellBookFrame", UIParent, "SecureHandlerShowHideTemplate,SecureHandlerStateTemplate,OldSchoolFrameTemplate")
tinsert(UISpecialFrames, "WORS_U_SpellBookFrame")
--WORS_U_SpellBook.frame:SetSize(192, 304)

WORS_U_SpellBook.frame:SetSize(192, 355)
WORS_U_SpellBook.frame:SetFrameStrata("LOW")
WORS_U_SpellBook.frame:SetFrameLevel(15)
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
	if WORS_U_MicroMenuAutoClose.Magic then
		SaveMicroMenuFramePosition(self)
	else
		self:SetUserPlaced(true) 
	end
end)

if WORS_U_SpellBookFrame.CloseButton then WORS_U_SpellBookFrame.CloseButton:ClearAllPoints() end

local function UpdateButtonBackground()
    if WORS_U_SpellBook.frame:IsShown() then
        MagicMicroButton:SetButtonState("PUSHED", true)
    else
        MagicMicroButton:SetButtonState("NORMAL", true)
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
		if WORS_U_SpellBook.frame and not WORS_U_SpellBook.frame:IsUserPlaced() then
			-- if we have a saved position, apply it to all auto-close frames
			if WORS_U_MicroMenuAutoClose and WORS_U_MicroMenuAutoClose.AutoClosePOS then
				ApplyMicroMenuSavedPosition()
			else
				-- fallback default position
				WORS_U_SpellBook.frame:ClearAllPoints()
				WORS_U_SpellBook.frame:SetPoint("CENTER", UIParent, "CENTER", 300, 45)
				WORS_U_SpellBook.frame:SetUserPlaced(true)
			end
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
	uSpellBook:Hide()
]=])

-- =========================
-- Secure Toggle
-- =========================
local SpellMicroMenuToggle = CreateFrame("Button", "WORS_USpellBook_Toggle", UIParent, "SecureHandlerClickTemplate")
if MagicMicroButton then
	WORS_USpellBook_Toggle:ClearAllPoints()
	WORS_USpellBook_Toggle:SetParent(MagicMicroButton)
	WORS_USpellBook_Toggle:SetAllPoints(MagicMicroButton)
	WORS_USpellBook_Toggle:SetFrameStrata(MagicMicroButton:GetFrameStrata())
	WORS_USpellBook_Toggle:SetFrameLevel(MagicMicroButton:GetFrameLevel() + 1)
	WORS_USpellBook_Toggle:RegisterForClicks("AnyUp")
	if MagicMicroButton:GetScript("OnEnter") then
		WORS_USpellBook_Toggle:SetScript("OnEnter", function()
			MagicMicroButton:GetScript("OnEnter")(MagicMicroButton)
		end)
	end
	if MagicMicroButton:GetScript("OnLeave") then
		WORS_USpellBook_Toggle:SetScript("OnLeave", function()
			MagicMicroButton:GetScript("OnLeave")(MagicMicroButton)
		end)
	end
end

SpellMicroMenuToggle:RegisterForClicks("AnyUp")
SpellMicroMenuToggle:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
SpellMicroMenuToggle:SetAttribute("_onclick", [=[
	local f = self:GetFrameRef("uSpellBook")
	if not f then return end
	
	if not f:IsShown() then
		f:Show()
	else
		f:Hide()
	end
]=])

SpellMicroMenuToggle:SetScript("PostClick", function(self, button, down)
	if WORS_U_MicroMenuAutoClose.Magic then
		if WORS_U_MicroMenuAutoClose.Backpack and Backpack and Backpack:IsShown() then
			Backpack:Hide()
		end
		
		if WORS_U_MicroMenuAutoClose.CombatStyle and CombatStylePanel and CombatStylePanel:IsShown() then
			CombatStylePanel:Hide()
		end	
		
		if WORS_U_MicroMenuAutoClose.Prayer and WORS_U_PrayBookFrame and WORS_U_PrayBookFrame:IsShown() then
			WORS_U_PrayBookFrame:Hide()
		end

		if WORS_U_MicroMenuAutoClose.Equipment and WORS_U_EquipmentBookFrame and WORS_U_EquipmentBookFrame:IsShown() then
			WORS_U_EquipmentBookFrame:Hide()
		end

		if WORS_U_MicroMenuAutoClose.Skills and WORS_U_SkillsBookFrame and WORS_U_SkillsBookFrame:IsShown() then
			WORS_U_SkillsBookFrame:Hide()
		end

		if WORS_U_MicroMenuAutoClose.Emotes and EmoteBookFrame and EmoteBookFrame:IsShown() then
			EmoteBookFrame:Hide()
		end
	end
end)


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

	-- bind both keys for TOGGLEMAGIC
	local k1, k2 = GetBindingKey("TOGGLEMAGIC")
	if k1 then SetOverrideBindingClick(UIParent, true, k1, "WORS_USpellBook_Toggle", "LeftButton") end
	if k2 then SetOverrideBindingClick(UIParent, true, k2, "WORS_USpellBook_Toggle", "LeftButton") end

	if event == "PLAYER_REGEN_ENABLED" then
		self.need = nil
	end
end)




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


