local aBackpackHooked, aCombatStyleHooked

local function HookABackpack()
	--ToggleBackpack()
    if aBackpackHooked or not Backpack then return end

    local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
    if pos then
        local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
        Backpack:ClearAllPoints()
        Backpack:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
    end

    Backpack:HookScript("OnShow", function()
        WORS_U_EmoteBook.frame:Hide()
		WORS_U_SkillsBook.frame:Hide()
        if InCombatLockdown() then return end
        CombatStylePanel:Hide()
        WORS_U_SpellBook.frame:Hide();     WORS_U_SpellBook.frame:SetAttribute("userToggle", nil)
        WORS_U_PrayBook.frame:Hide();      WORS_U_PrayBook.frame:SetAttribute("userToggle", nil)
        WORS_U_EquipmentBook.frame:Hide(); WORS_U_EquipmentBook.frame:SetAttribute("userToggle", nil)
    end)

    hooksecurefunc(Backpack, "StopMovingOrSizing", SaveFramePosition)
    aBackpackHooked = true
	print("aBackpackHooked truess")

end

local function HookACombatStylePanel()
    if aCombatStyleHooked or not CombatStylePanel then return end

    local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
    if pos then
        local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
        CombatStylePanel:ClearAllPoints()
        CombatStylePanel:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
    end

    CombatStylePanel:HookScript("OnShow", function()
        WORS_U_EmoteBook.frame:Hide()
		WORS_U_SkillsBook.frame:Hide()
        Backpack:Hide()
        if InCombatLockdown() then return end
        WORS_U_SpellBook.frame:Hide();     WORS_U_SpellBook.frame:SetAttribute("userToggle", nil)
        WORS_U_PrayBook.frame:Hide();      WORS_U_PrayBook.frame:SetAttribute("userToggle", nil)
        WORS_U_EquipmentBook.frame:Hide(); WORS_U_EquipmentBook.frame:SetAttribute("userToggle", nil)
    end)	

    CombatStylePanel:HookScript("OnDragStop", SaveFramePosition)
    aCombatStyleHooked = true
	print("aCombatStyleHooked truess")
end

local function HookAFrames()
    HookABackpack()
    HookACombatStylePanel()
end


local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_ENABLED")   -- also try after combat
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        HookAFrames()
        ResetMicroMenuPOSByAspect(WORS_U_EmoteBook.frame)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    elseif event == "PLAYER_REGEN_ENABLED" then
		if aCombatStyleHooked and aBackpackHooked then
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		else
			HookAFrames()
		end			
	end	
end)




