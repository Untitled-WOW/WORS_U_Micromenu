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

-- ----------------------------------------------------------------
-- -- === Emote button over  EmoteMicroButton===
-- ----------------------------------------------------------------
U_EmoteMicroMenuButton = CreateFrame("Button", "U_EmoteBookMicroButtonCopy", UIParent, "SecureActionButtonTemplate,SecureHandlerClickTemplate")
U_EmoteMicroMenuButton:SetAllPoints(EmotesMicroButton)
U_EmoteMicroMenuButton:SetFrameStrata(EmotesMicroButton:GetFrameStrata())
U_EmoteMicroMenuButton:SetFrameLevel(EmotesMicroButton:GetFrameLevel() + 1)
-- Tooltip
U_EmoteMicroMenuButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Emotes", 1, 1, 1, 1, true)
	GameTooltip:AddLine("Choose different emote actions your character can preform", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	GameTooltip:Show()
end)
U_EmoteMicroMenuButton:SetScript("OnLeave", GameTooltip_Hide)

-- Pass refs you want to close
U_EmoteMicroMenuButton:SetFrameRef("uSpellBook", WORS_U_SpellBook.frame)
U_EmoteMicroMenuButton:SetFrameRef("uPrayerBook", WORS_U_PrayBook.frame)
U_EmoteMicroMenuButton:SetFrameRef("uEquipmentBook", WORS_U_EquipmentBook.frame)
U_EmoteMicroMenuButton:SetFrameRef("aCombatStyle", CombatStylePanel)

-- Secure snippet runs on the SAME hardware click, even in combat
U_EmoteMicroMenuButton:SetAttribute("_onclick", [=[ 
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

U_EmoteMicroMenuButton:SetScript("OnMouseUp", function(self)
	Backpack:Hide()
	WORS_U_SkillsBookFrame:Hide()
	if WORS_U_EmoteBookFrame:IsShown() then 
		WORS_U_EmoteBookFrame:Hide()
	else
		WORS_U_EmoteBookFrame:Show()	
	end
    if IsShiftKeyDown() and not InCombatLockdown() then
        ResetMicroMenuPOSByAspect(Backpack)
        print("|cff00ff00[MicroMenu]|r position reset.")
    end
end)






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
    WORS_U_EmoteBookFrame:Hide()
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

U_CombatStyleMicroMenuButton:SetScript("OnMouseUp", function(self)
	ToggleBackpack()
    WORS_U_EmoteBookFrame:Hide()
    if IsShiftKeyDown() and not InCombatLockdown() then
        ResetMicroMenuPOSByAspect(Backpack)
        print("|cff00ff00[MicroMenu]|r position reset.")
    end
end)







-- ----------------------------------------------------------------
-- === Skills button over SkillsMicroButton (like Emotes one) ====
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
	WORS_U_EmoteBookFrame:Hide()
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
