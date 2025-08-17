
-- === Magic button over PrayerMicroButton ===
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


-- === Prayer button over CompanionsMicroButton ===
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

-- === Equipment button over  CharacterMicroButton ===
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


-- === Emote button over  EmoteMicroButton===
U_EmoteMicroMenuButton = CreateFrame("Button", "U_EmoteBookMicroButtonCopy", EmotesMicroButton, "MicroMenuButtonTemplate", 1)
U_EmoteMicroMenuButton:ClearAllPoints()
U_EmoteMicroMenuButton:SetAllPoints()  
U_EmoteMicroMenuButton:SetFrameStrata("MEDIUM")
U_EmoteMicroMenuButton:SetFrameLevel(EmotesMicroButton:GetFrameLevel() + 5)
U_EmoteMicroMenuButton.Icon:SetTexture(EmotesMicroButton.Icon:GetTexture())
U_EmoteMicroMenuButton.Icon:SetTexture("Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\6_Wave_emote_icon.tga")
--U_EmoteMicroMenuButton.Icon:SetTexCoord(EmotesMicroButton.Icon:GetTexCoord())
U_EmoteMicroMenuButton.Icon:ClearAllPoints()
U_EmoteMicroMenuButton.Icon:SetPoint("CENTER", 0, 0)
U_EmoteMicroMenuButton.Icon:SetSize(24, 42)

U_EmoteMicroMenuButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Emotes", 1, 1, 1, 1, true)
	GameTooltip:AddLine("Choose different emote actions your character can preform", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	GameTooltip:Show()
end)
U_EmoteMicroMenuButton:SetScript("OnLeave", GameTooltip_Hide)


-- === Character Info button ===
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