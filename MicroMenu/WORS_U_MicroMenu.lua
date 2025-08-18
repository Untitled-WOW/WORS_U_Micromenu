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

    hooksecurefunc(Backpack, "StopMovingOrSizing", SaveFramePosition)
    aBackpackHooked = true
	-- print("aBackpackHooked truess")

end

local function HookACombatStylePanel()
    if aCombatStyleHooked or not CombatStylePanel then return end

    local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
    if pos then
        local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
        CombatStylePanel:ClearAllPoints()
        CombatStylePanel:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
    end

    CombatStylePanel:HookScript("OnDragStop", SaveFramePosition)
    aCombatStyleHooked = true
	-- print("aCombatStyleHooked truess")
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
