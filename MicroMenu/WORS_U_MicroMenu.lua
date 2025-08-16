-- Hook Backpack and CombatStylePanels functions
local aBackpackHocked
local aCombatStyleHocked

local function HookAFrames()
    if Backpack then
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
            Backpack:ClearAllPoints()
            Backpack:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
        end
		
		-- Hock onShow to auto close Micromenu and CombatStylePannel
		Backpack:HookScript("OnShow", function()
			WORS_U_EmoteBook.frame:Hide()			
			if InCombatLockdown() then return end
			CombatStylePanel:Hide()
			WORS_U_SpellBook.frame:Hide()
			WORS_U_SpellBook.frame:SetAttribute("userToggle", nil)
			WORS_U_PrayBook.frame:Hide()	
			WORS_U_PrayBook.frame:SetAttribute("userToggle", nil)	
        end)
				
		-- Hock StopMovingOrSizing to save new postion to all frames
		hooksecurefunc(Backpack, "StopMovingOrSizing", function(self)
			SaveFramePosition(self)
		end)
		aBackpackHocked = true
    end
    if CombatStylePanel then
		if InCombatLockdown() then return end

        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
            CombatStylePanel:ClearAllPoints()
            CombatStylePanel:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
        end		

		-- Hock onShow to auto close Micromenu and Backpack
		CombatStylePanel:HookScript("OnShow", function()
			WORS_U_EmoteBook.frame:Hide()
			CloseBackpack()
			if InCombatLockdown() then return end
			WORS_U_SpellBook.frame:Hide()
			WORS_U_SpellBook.frame:SetAttribute("userToggle", nil)
			WORS_U_PrayBook.frame:Hide()	
			WORS_U_PrayBook.frame:SetAttribute("userToggle", nil)			
        end)
		
		-- Hock OnDragStop to save new postion to all frames
		CombatStylePanel:HookScript("OnDragStop", function(self)
			SaveFramePosition(self)			
		end)

		aCombatStyleHocked = trues
    end
    
	-- retrys until both A frames are hooked
	if not Backpack and not CombatStylePanel then
		if not aBackpackHocked and not aCombatStyleHocked then
			C_Timer.After(0.1, HookAFrames)
		end
    end
end

-- Main initialization event
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0.5, function()
            HookAFrames()
            --HookMicroMenuFrames()	
        end)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)