----------------------------------------------------------------
-- === Magic button over PrayerMicroButton ===
----------------------------------------------------------------
U_SpellMicroMenuButton = CreateFrame("Button", "U_SpellBookMicroButtonCopy", PrayerMicroButton, "MicroMenuButtonTemplate", 1)
U_SpellMicroMenuButton:ClearAllPoints()
U_SpellMicroMenuButton:SetAllPoints()  -- overlay on PrayerMicroButton
U_SpellMicroMenuButton:SetFrameStrata("MEDIUM")
U_SpellMicroMenuButton:SetFrameLevel(PrayerMicroButton:GetFrameLevel() + 5)
U_SpellMicroMenuButton.Icon:SetTexture("Interface\\Icons\\magicicon")
U_SpellMicroMenuButton.Icon:ClearAllPoints()
U_SpellMicroMenuButton.Icon:SetPoint("CENTER", 0, 0)
U_SpellMicroMenuButton.Icon:SetSize(24, 24)
U_SpellMicroMenuButton.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
-- Keep a secure "desired visibility" attribute (no drivers; we allow in-combat show)
WORS_U_SpellBook.frame:SetAttribute("userToggle", nil) -- hidden by default

local SpellMicroMenuToggle = CreateFrame("Button", "WORS_USpellBook_Toggle", UIParent, "SecureHandlerClickTemplate")
--SpellMicroMenuToggle:SetAllPoints(SpellbookMicroButton)
--SpellMicroMenuToggle:SetFrameStrata("HIGH")
--SpellMicroMenuToggle:SetFrameLevel(SpellbookMicroButton:GetFrameLevel() + 1)

SpellMicroMenuToggle:SetAllPoints(U_SpellMicroMenuButton)
SpellMicroMenuToggle:SetFrameStrata("HIGH")
SpellMicroMenuToggle:SetFrameLevel(U_SpellMicroMenuButton:GetFrameLevel() + 1)

SpellMicroMenuToggle:RegisterForClicks("AnyUp")

-- before: after you create CombatStylePanel and WORS_U_SpellBook.frame
-- Pass references into secure environment

SpellMicroMenuToggle:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
SpellMicroMenuToggle:SetFrameRef("uPrayerBook", WORS_U_PrayBook.frame)
SpellMicroMenuToggle:SetFrameRef("uEquipmentBook", WORS_U_EquipmentBook.frame)
SpellMicroMenuToggle:SetFrameRef("aCombatStyle", CombatStylePanel)  

-- Secure click snippet
SpellMicroMenuToggle:SetAttribute("_onclick", [=[
	local uSpellBook = self:GetFrameRef("uSpellBook")
	local uPrayerBook = self:GetFrameRef("uPrayerBook")
	local uEquipmentBook = self:GetFrameRef("uEquipmentBook")
	local aCombatStyle = self:GetFrameRef("aCombatStyle")
	
	local isShown = uSpellBook:GetAttribute("userToggle")
	if isShown then
		uSpellBook:SetAttribute("userToggle", nil)
		uSpellBook:Hide()
	else
		if uPrayerBook and uPrayerBook:IsShown() then 
			uPrayerBook:Hide()
			uPrayerBook:SetAttribute("userToggle", nil)
		end
		if uEquipmentBook and uEquipmentBook:IsShown() then
			uEquipmentBook:Hide()
			uEquipmentBook:SetAttribute("userToggle", nil)
		end
		if aCombatStyle and aCombatStyle:IsShown() then aCombatStyle:Hide() end

		uSpellBook:SetAttribute("userToggle", true)
		uSpellBook:Show()
	end
]=])

-- Shift+Click to reset position 
SpellMicroMenuToggle:SetScript("OnMouseUp", function(self)
    Backpack:Hide()
	WORS_U_SkillsBook.frame:Hide()
	EmoteBookFrame:Hide()
	if IsShiftKeyDown() and not InCombatLockdown() then
		ResetMicroMenuPOSByAspect(WORS_U_SpellBook.frame)
		print("|cff00ff00[MicroMenu]|r position reset.")
	end
end)

-- Tooltip on hover
SpellMicroMenuToggle:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Magic", 1, 1, 1, 1, true)
    GameTooltip:AddLine("Open Magic menu for spells.\nTo open WoW Spellbook click Spellbook & Abilities", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
    GameTooltip:Show()
end)
SpellMicroMenuToggle:SetScript("OnLeave", function() GameTooltip:Hide() end)







----------------------------------------------------------------
-- === Prayer button over CompanionsMicroButton ===
----------------------------------------------------------------
U_PrayerMicroMenuButton = CreateFrame("Button", "U_PrayerBookMicroButtonCopy", CompanionsMicroButton, "MicroMenuButtonTemplate", 1)
U_PrayerMicroMenuButton:ClearAllPoints()
U_PrayerMicroMenuButton:SetAllPoints()  -- overlay on CompanionsMicroButton
U_PrayerMicroMenuButton:SetFrameStrata("MEDIUM")
U_PrayerMicroMenuButton:SetFrameLevel(CompanionsMicroButton:GetFrameLevel() + 5)
U_PrayerMicroMenuButton.Icon:SetTexture("Interface\\Icons\\prayer")
U_PrayerMicroMenuButton.Icon:ClearAllPoints()
U_PrayerMicroMenuButton.Icon:SetPoint("CENTER", 0, 0)
U_PrayerMicroMenuButton.Icon:SetSize(24, 24)
U_PrayerMicroMenuButton.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

-- SECURE TOGGLE + CLOSE UI
-- Keep a secure "desired visibility" attribute (no drivers; we allow in-combat show)
WORS_U_PrayBook.frame:SetAttribute("userToggle", nil) -- hidden by default

-- Secure TOGGLE overlay on the SpellbookMicroButton
local PrayerMicroMenuToggle = CreateFrame("Button", "WORS_UPrayBook_Toggle", UIParent, "SecureHandlerClickTemplate")
-- PrayerMicroMenuToggle:SetAllPoints(PrayerMicroButton)
-- PrayerMicroMenuToggle:SetFrameStrata("HIGH")
-- PrayerMicroMenuToggle:SetFrameLevel(PrayerMicroButton:GetFrameLevel() + 1)

PrayerMicroMenuToggle:SetAllPoints(U_PrayerMicroMenuButton)
PrayerMicroMenuToggle:SetFrameStrata("HIGH")
PrayerMicroMenuToggle:SetFrameLevel(U_PrayerMicroMenuButton:GetFrameLevel() + 1)

PrayerMicroMenuToggle:RegisterForClicks("AnyUp")

-- before: after you create CombatStylePanel and WORS_U_SpellBook.frame
-- Pass references into secure environment
PrayerMicroMenuToggle:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
PrayerMicroMenuToggle:SetFrameRef("uPrayerBook", WORS_U_PrayBook.frame)
PrayerMicroMenuToggle:SetFrameRef("uEquipmentBook", WORS_U_EquipmentBook.frame)
PrayerMicroMenuToggle:SetFrameRef("aCombatStyle", CombatStylePanel)  

-- Secure click snippet
PrayerMicroMenuToggle:SetAttribute("_onclick", [=[
	local uSpellBook = self:GetFrameRef("uSpellBook")
	local uPrayerBook = self:GetFrameRef("uPrayerBook")
	local uEquipmentBook = self:GetFrameRef("uEquipmentBook")
	local aCombatStyle = self:GetFrameRef("aCombatStyle")
	
	local isShown = uPrayerBook:GetAttribute("userToggle")
	if isShown then
		uPrayerBook:SetAttribute("userToggle", nil)
		uPrayerBook:Hide()
	else
		if uSpellBook and uSpellBook:IsShown() then 
			uSpellBook:Hide()
			uSpellBook:SetAttribute("userToggle", nil)
		end
		if uEquipmentBook and uEquipmentBook:IsShown() then
			uEquipmentBook:Hide()
			uEquipmentBook:SetAttribute("userToggle", nil)
		end
		if aCombatStyle and aCombatStyle:IsShown() then aCombatStyle:Hide() end

		uPrayerBook:SetAttribute("userToggle", true)
		uPrayerBook:Show()
	end
]=])

-- Shift+Click to reset position 
PrayerMicroMenuToggle:SetScript("OnMouseUp", function(self)
	Backpack:Hide()
	WORS_U_SkillsBook.frame:Hide()
	EmoteBookFrame:Hide()
	if IsShiftKeyDown() and not InCombatLockdown() then
		ResetMicroMenuPOSByAspect(WORS_U_PrayBook.frame)
		print("|cff00ff00[MicroMenu]|r position reset.")
	end
end)

-- Tooltip on hover
PrayerMicroMenuToggle:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Prayer", 1, 1, 1, 1, true)
    GameTooltip:AddLine("Open Prayer menu for spells.\nTo open WoW Spellbook click Spellbook & Abilities", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
    GameTooltip:Show()
end)
PrayerMicroMenuToggle:SetScript("OnLeave", function() GameTooltip:Hide() end)





----------------------------------------------------------------
-- === Equipment button over  CharacterMicroButton ===
----------------------------------------------------------------
U_EquipmentMicroMenuButton = CreateFrame("Button", "U_EquipmentBookMicroButtonCopy", CharacterMicroButton, "MicroMenuButtonTemplate", 1)
U_EquipmentMicroMenuButton:ClearAllPoints()
U_EquipmentMicroMenuButton:SetAllPoints()  -- overlay on CharacterMicroButton
U_EquipmentMicroMenuButton:SetFrameStrata("MEDIUM")
U_EquipmentMicroMenuButton:SetFrameLevel(CharacterMicroButton:GetFrameLevel() + 5)
U_EquipmentMicroMenuButton.Icon:SetTexture(CharacterMicroButton.Icon:GetTexture())
U_EquipmentMicroMenuButton.Icon:SetTexCoord(CharacterMicroButton.Icon:GetTexCoord())
U_EquipmentMicroMenuButton.Icon:ClearAllPoints()
U_EquipmentMicroMenuButton.Icon:SetPoint("CENTER", 0, 0)
U_EquipmentMicroMenuButton.Icon:SetSize(28, 28)

-- SECURE TOGGLE + CLOSE UI
WORS_U_EquipmentBook.frame:SetAttribute("userToggle", nil) -- hidden by default

local EquipmentMicroMenuToggle = CreateFrame("Button", "WORS_UPEquipmentBook_Toggle", UIParent, "SecureHandlerClickTemplate")
EquipmentMicroMenuToggle:SetAllPoints(U_EquipmentMicroMenuButton)
EquipmentMicroMenuToggle:SetFrameStrata("HIGH")
EquipmentMicroMenuToggle:SetFrameLevel(U_EquipmentMicroMenuButton:GetFrameLevel() + 1)
EquipmentMicroMenuToggle:RegisterForClicks("AnyUp")

EquipmentMicroMenuToggle:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
EquipmentMicroMenuToggle:SetFrameRef("uPrayerBook", WORS_U_PrayBook.frame)
EquipmentMicroMenuToggle:SetFrameRef("uEquipmentBook", WORS_U_EquipmentBook.frame)
EquipmentMicroMenuToggle:SetFrameRef("aCombatStyle", CombatStylePanel)

EquipmentMicroMenuToggle:SetAttribute("_onclick", [=[
    local uSpellBook     = self:GetFrameRef("uSpellBook")
    local uPrayerBook    = self:GetFrameRef("uPrayerBook")
    local uEquipmentBook = self:GetFrameRef("uEquipmentBook")
    local aCombatStyle   = self:GetFrameRef("aCombatStyle")

    local isShown = uEquipmentBook:GetAttribute("userToggle")
    if isShown then
        uEquipmentBook:SetAttribute("userToggle", nil)
        uEquipmentBook:Hide()
    else
        if uSpellBook and uSpellBook:IsShown() then
            uSpellBook:Hide()
            uSpellBook:SetAttribute("userToggle", nil)
        end
        if uPrayerBook and uPrayerBook:IsShown() then
            uPrayerBook:Hide()
            uPrayerBook:SetAttribute("userToggle", nil)
        end
        if aCombatStyle and aCombatStyle:IsShown() then aCombatStyle:Hide() end

        uEquipmentBook:SetAttribute("userToggle", true)
        uEquipmentBook:Show()
    end
]=])

EquipmentMicroMenuToggle:SetScript("OnMouseUp", function(self)
    Backpack:Hide()
    WORS_U_SkillsBook.frame:Hide()
    EmoteBookFrame:Hide()
    if IsShiftKeyDown() and not InCombatLockdown() then
        ResetMicroMenuPOSByAspect(WORS_U_EquipmentBook.frame)
        print("|cff00ff00[MicroMenu]|r position reset.")
    end
end)

EquipmentMicroMenuToggle:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Equipment", 1, 1, 1, 1, true)
    GameTooltip:AddLine("Open equipment menu", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
    GameTooltip:Show()
end)
EquipmentMicroMenuToggle:SetScript("OnLeave", GameTooltip_Hide)


----------------------------------------------------------------
-- === Character Info button ===
----------------------------------------------------------------
U_CharacterMicroMenuButton = CreateFrame("Button", "U_CharacterMicroMenuButton", AchievementsMicroButton:GetParent(), "MicroMenuButtonTemplate", 1)
U_CharacterMicroMenuButton:SetScale(AchievementsMicroButton:GetScale())
U_CharacterMicroMenuButton:SetFrameStrata(AchievementsMicroButton:GetFrameStrata())
U_CharacterMicroMenuButton:SetFrameLevel(AchievementsMicroButton:GetFrameLevel() + 1)

-- Match size and clickable area
U_CharacterMicroMenuButton:SetSize(AchievementsMicroButton:GetWidth(), AchievementsMicroButton:GetHeight())
local l, r, t, b = AchievementsMicroButton:GetHitRectInsets()
if l then U_CharacterMicroMenuButton:SetHitRectInsets(l, r, t, b) end
-- === Your original icon handling (restored) ===
U_CharacterMicroMenuButton.Icon:SetTexture("Interface\\AddOns\\MicroMenu\\Textures\\Btn\\Equipment_Stats_Icon.blp")
U_CharacterMicroMenuButton.Icon:ClearAllPoints()
U_CharacterMicroMenuButton.Icon:SetPoint("CENTER", 0, 0)
U_CharacterMicroMenuButton.Icon:SetSize(28, 28)

-- Positioning: left of Achievements on widescreen, above it otherwise
local function PositionCharacterMicroButton()
	U_CharacterMicroMenuButton:ClearAllPoints()
	local res = GetCVar("gxResolution") 
	local w, h = res:match("(%d+)x(%d+)")
	w, h = tonumber(w), tonumber(h)
	if not (w and h) then return end
	local aspect = w / h
	U_CharacterMicroMenuButton:ClearAllPoints()
	if aspect > 1.5 then -- Widescreen   
		U_CharacterMicroMenuButton:SetPoint("RIGHT", AchievementsMicroButton, "LEFT", -2, 0)
	else
		U_CharacterMicroMenuButton:SetPoint("BOTTOM", AchievementsMicroButton, "TOP", 0, 2)
	end
end

PositionCharacterMicroButton()
U_CharacterMicroMenuButton:RegisterEvent("UI_SCALE_CHANGED")
U_CharacterMicroMenuButton:SetScript("OnEvent", PositionCharacterMicroButton)

-- Tooltip
U_CharacterMicroMenuButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Character Info", 1, 1, 1, 1, true)
	GameTooltip:AddLine("Infomation about your character, including equipment, combat statistics and skills", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	GameTooltip:Show()
end)
U_CharacterMicroMenuButton:SetScript("OnLeave", GameTooltip_Hide)

-- Click behavior (open character panel)
U_CharacterMicroMenuButton:SetScript("OnClick", function()
	if AscensionCharacterFrame:IsShown() then	
		AscensionCharacterFrame:Hide()
	else
		AscensionCharacterFrame:Show()
	end
end)

-- Sync button pressed state with PaperDollFrame visibility
local function UpdateCharacterButtonState()
    if AscensionCharacterFrame and AscensionCharacterFrame:IsShown() then
        U_CharacterMicroMenuButton:SetButtonState("PUSHED", true)
    else
        U_CharacterMicroMenuButton:SetButtonState("NORMAL")
    end
end


AscensionCharacterFrame:HookScript("OnShow", UpdateCharacterButtonState)
AscensionCharacterFrame:HookScript("OnHide", UpdateCharacterButtonState)

-- ----------------------------------------------------------------
-- === Skills button over SkillsMicroButton ====
-- ----------------------------------------------------------------
U_SkillMicroMenuButton = CreateFrame("Button", "U_SkillBookMicroButtonCopy", UIParent, "SecureActionButtonTemplate,SecureHandlerClickTemplate")
U_SkillMicroMenuButton:SetAllPoints(SkillsMicroButton)
U_SkillMicroMenuButton:SetFrameStrata(SkillsMicroButton:GetFrameStrata())
U_SkillMicroMenuButton:SetFrameLevel(SkillsMicroButton:GetFrameLevel() + 1)

-- Tooltip
U_SkillMicroMenuButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Skills", 1, 1, 1, 1, true)
	GameTooltip:AddLine("View your individual skills, levels, and total level.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	GameTooltip:Show()
end)
U_SkillMicroMenuButton:SetScript("OnLeave", GameTooltip_Hide)

-- Pass refs you want to close
U_SkillMicroMenuButton:SetFrameRef("uSpellBook",     WORS_U_SpellBook and WORS_U_SpellBook.frame)
U_SkillMicroMenuButton:SetFrameRef("uPrayerBook",    WORS_U_PrayBook and WORS_U_PrayBook.frame)
U_SkillMicroMenuButton:SetFrameRef("uEquipmentBook", WORS_U_EquipmentBook and WORS_U_EquipmentBook.frame)
U_SkillMicroMenuButton:SetFrameRef("aCombatStyle",   CombatStylePanel)

-- Secure snippet runs on the SAME hardware click, even in combat
U_SkillMicroMenuButton:SetAttribute("_onclick", [=[ 
  local uSpellBook     = self:GetFrameRef("uSpellBook")
  local uPrayerBook    = self:GetFrameRef("uPrayerBook")
  local uEquipmentBook = self:GetFrameRef("uEquipmentBook")
  local aCombatStyle   = self:GetFrameRef("aCombatStyle")

  if uSpellBook and uSpellBook:GetAttribute("userToggle") then
    uSpellBook:SetAttribute("userToggle", nil)
    uSpellBook:Hide()
  end
  if uPrayerBook and uPrayerBook:GetAttribute("userToggle") then
    uPrayerBook:SetAttribute("userToggle", nil)
    uPrayerBook:Hide()
  end
  if uEquipmentBook and uEquipmentBook:GetAttribute("userToggle") then
    uEquipmentBook:SetAttribute("userToggle", nil)
    uEquipmentBook:Hide()
  end
  if aCombatStyle and aCombatStyle:IsShown() then
    aCombatStyle:Hide()
  end
]=]) 

-- Click: toggle Skills frame; Shift+Click resets its position
U_SkillMicroMenuButton:SetScript("OnMouseUp", function(self)
	Backpack:Hide()
	EmoteBookFrame:Hide()
	if WORS_U_SkillsBookFrame:IsShown() then
		WORS_U_SkillsBookFrame:Hide()
	else
		WORS_U_SkillsBookFrame:Show()
	end
	if IsShiftKeyDown() and not InCombatLockdown() then
		ResetMicroMenuPOSByAspect(WORS_U_SkillsBookFrame)
		print("|cff00ff00[MicroMenu]|r position reset.")
	end
end)



----------------------------------------------------------------
-- Inventory Overlay InventoryMicroButton
--------------------------------------------------------------------------------

U_InventoryMicroMenuButton = CreateFrame("Button", "U_InventoryMicroMenuButtonCopy", UIParent, "SecureActionButtonTemplate,SecureHandlerClickTemplate")
U_InventoryMicroMenuButton:SetAllPoints(InventoryMicroButton)
U_InventoryMicroMenuButton:SetFrameStrata(InventoryMicroButton:GetFrameStrata())
U_InventoryMicroMenuButton:SetFrameLevel(InventoryMicroButton:GetFrameLevel() + 1)
-- Tooltip
U_InventoryMicroMenuButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Bags", 1, 1, 1, 1, true)
	GameTooltip:AddLine("Your bags contain all the items you are currently carrying. You may carry up to 28 items.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	GameTooltip:Show()
end)
U_InventoryMicroMenuButton:SetScript("OnLeave", GameTooltip_Hide)

-- Pass refs you want to close
U_InventoryMicroMenuButton:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
U_InventoryMicroMenuButton:SetFrameRef("uPrayerBook", WORS_U_PrayBook.frame)
U_InventoryMicroMenuButton:SetFrameRef("uEquipmentBook", WORS_U_EquipmentBook.frame)
U_InventoryMicroMenuButton:SetFrameRef("aCombatStyle", CombatStylePanel)

-- Secure snippet runs on the SAME hardware click, even in combat
U_InventoryMicroMenuButton:SetAttribute("_onclick", [=[ 
  local uSpellBook     = self:GetFrameRef("uSpellBook")
  local uPrayerBook    = self:GetFrameRef("uPrayerBook")
  local uEquipmentBook = self:GetFrameRef("uEquipmentBook")
  local aCombatStyle   = self:GetFrameRef("aCombatStyle")


  if uSpellBook and uSpellBook:GetAttribute("userToggle") then
    uSpellBook:SetAttribute("userToggle", nil)
    uSpellBook:Hide()
  end
  if uPrayerBook and uPrayerBook:GetAttribute("userToggle") then
    uPrayerBook:SetAttribute("userToggle", nil)
    uPrayerBook:Hide()
  end
  if uEquipmentBook and uEquipmentBook:GetAttribute("userToggle") then
    uEquipmentBook:SetAttribute("userToggle", nil)
    uEquipmentBook:Hide()
  end
  if aCombatStyle and aCombatStyle:IsShown() then aCombatStyle:Hide() end
  
  
]=])

U_InventoryMicroMenuButton:SetScript("OnMouseUp", function(self)
	ToggleBackpack()
    EmoteBookFrame:Hide()
	WORS_U_SkillsBookFrame:Hide()
    if IsShiftKeyDown() and not InCombatLockdown() then
        ResetMicroMenuPOSByAspect(Backpack)
        print("|cff00ff00[MicroMenu]|r position reset.")
    end
end)





----------------------------------------------------------------
-- CombatStyle Overlay CombatStyleMicroButton
--------------------------------------------------------------------------------

U_CombatStyleMicroMenuButton = CreateFrame("Button", "U_CombatStyleMicroMenuButtonCopy", UIParent, "SecureActionButtonTemplate,SecureHandlerClickTemplate")
U_CombatStyleMicroMenuButton:SetAllPoints(CombatStyleMicroButton)
U_CombatStyleMicroMenuButton:SetFrameStrata(CombatStyleMicroButton:GetFrameStrata())
U_CombatStyleMicroMenuButton:SetFrameLevel(CombatStyleMicroButton:GetFrameLevel() + 1)
-- Tooltip
U_CombatStyleMicroMenuButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Combat Options", 1, 1, 1, 1, true)
	GameTooltip:AddLine("Choose different attack styles to use in Combat, which in turn affects what type of experience you receive. Available combat options are determined by the weapon category.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	GameTooltip:Show()
end)
U_CombatStyleMicroMenuButton:SetScript("OnLeave", GameTooltip_Hide)

-- Pass refs you want to close
U_CombatStyleMicroMenuButton:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
U_CombatStyleMicroMenuButton:SetFrameRef("uPrayerBook", WORS_U_PrayBook.frame)
U_CombatStyleMicroMenuButton:SetFrameRef("uEquipmentBook", WORS_U_EquipmentBook.frame)
U_CombatStyleMicroMenuButton:SetFrameRef("aCombatStyle", CombatStylePanel)

-- Secure snippet runs on the SAME hardware click, even in combat
U_CombatStyleMicroMenuButton:SetAttribute("_onclick", [=[ 
  local uSpellBook     = self:GetFrameRef("uSpellBook")
  local uPrayerBook    = self:GetFrameRef("uPrayerBook")
  local uEquipmentBook = self:GetFrameRef("uEquipmentBook")
  local aCombatStyle   = self:GetFrameRef("aCombatStyle")


  if uSpellBook and uSpellBook:GetAttribute("userToggle") then
    uSpellBook:SetAttribute("userToggle", nil)
    uSpellBook:Hide()
  end
  if uPrayerBook and uPrayerBook:GetAttribute("userToggle") then
    uPrayerBook:SetAttribute("userToggle", nil)
    uPrayerBook:Hide()
  end
  if uEquipmentBook and uEquipmentBook:GetAttribute("userToggle") then
    uEquipmentBook:SetAttribute("userToggle", nil)
    uEquipmentBook:Hide()
  end
  if aCombatStyle and aCombatStyle:IsShown() then 
	aCombatStyle:Hide() 
  else
	  aCombatStyle:Show() 	
  end
  
  
]=])

U_CombatStyleMicroMenuButton:SetScript("PostClick", function(self)
	CloseBackpack()
    EmoteBookFrame:Hide()
	WORS_U_SkillsBookFrame:Hide()
    if IsShiftKeyDown() and not InCombatLockdown() then
        ResetMicroMenuPOSByAspect(CombatStylePanel)
        print("|cff00ff00[MicroMenu]|r position reset.")
    end
end)



---------------------------------------------------
-- Override Backpack and Combat Style bind to click secure buttons
---------------------------------------------------

-- helper: bind up to 2 keys for one action id to click a secure button
local function BindAction(bindingId, ownerButton, clickButtonName)
    if not ownerButton or not clickButtonName then return end
    local k1, k2 = GetBindingKey(bindingId)
    if k1 then SetOverrideBindingClick(ownerButton, true, k1, clickButtonName, "LeftButton") end
    if k2 then SetOverrideBindingClick(ownerButton, true, k2, clickButtonName, "LeftButton") end
end


-- Bind every key assigned to `bindingId` to click `clickButtonName`.
-- We use UIParent as the owner so the override is always active.
local function BindActionAll(bindingId, clickButtonName)
    if not clickButtonName then return end
    local i = 1
    while true do
        local key = GetBindingKey(bindingId, i)
        if not key then break end
        SetOverrideBindingClick(UIParent, true, key, clickButtonName, "LeftButton")
        i = i + 1
    end
end

-- Re-apply Blizzard micro binds
local function ApplyMicroMenuOverrideBindings()
    -- Do NOT ClearOverrideBindings(UIParent) (would wipe everything).
    BindActionAll("TOGGLEBACKPACK",    "U_InventoryMicroMenuButtonCopy")
    BindActionAll("TOGGLECOMBATSTYLE", "U_CombatStyleMicroMenuButtonCopy")
end

-- Re-apply your custom binds
local function ApplyCustomMenuOverrideBindings()
    BindActionAll("TOGGLEMAGIC",     "WORS_USpellBook_Toggle")
    BindActionAll("TOGGLEPRAYER",    "WORS_UPrayBook_Toggle")
    BindActionAll("TOGGLEEQUIPMENT", "WORS_UPEquipmentBook_Toggle")
    BindActionAll("TOGGLESKILLS",    "U_SkillBookMicroButtonCopy")
end


local function RebindAll()
	-- if InCombatLockdown() then return end
	ApplyMicroMenuOverrideBindings()
	ApplyCustomMenuOverrideBindings()
end

local kb = CreateFrame("Frame")
kb:RegisterEvent("PLAYER_LOGIN")
kb:RegisterEvent("UPDATE_BINDINGS")
kb:RegisterEvent("PLAYER_REGEN_ENABLED")
kb:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" and InCombatLockdown() then
		self.needUpdate = true
		return
	elseif event == "UPDATE_BINDINGS" and InCombatLockdown() then 
		return
	elseif event == "PLAYER_REGEN_ENABLED" and self.needUpdate then 
		RebindAll()
		self.needUpdate = nil
	else
		RebindAll()
		self.needUpdate = nil
	end
end)
