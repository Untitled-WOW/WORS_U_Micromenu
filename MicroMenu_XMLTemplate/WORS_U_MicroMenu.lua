-- WORS_U_MagicPrayer.lua
MicroMenu_Frames = {WORS_U_SpellBookFrame, WORS_U_PrayBookFrame, WORS_U_EmoteBookFrame, WORS_U_EquipmentBookFrame, CombatStylePanel} 

-- function to hide all Micromenu, CombatStylePanel and Backpack frames
function MicroMenu_HideAll()
    for _, frame in ipairs(MicroMenu_Frames) do
        frame:Hide()
    end
    CloseBackpack()
end

-- function used to toggle between Micromenu, CombatStylePanel and Backpack frames
function MicroMenu_ToggleFrame(targetFrame)
    if targetFrame:IsShown() then
		targetFrame:Hide()	
	else	    
		MicroMenu_HideAll()		
		targetFrame:Show()		
        AttachMicroButtonsTo(targetFrame)
    end	
end

-- Hook Backpack and CombatStylePanels functions
local function HookAFrames()
    if Backpack then
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
            Backpack:ClearAllPoints()
            Backpack:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
            Backpack:SetUserPlaced(false)
        end
		--Backpack:SetWidth( Backpack:GetWidth() +  12 )
		-- Hide backpack textures 
		for _, r in ipairs({Backpack:GetRegions()}) do if r:GetObjectType()=="Texture" then r:Hide() end end
		-- Hock onShow to auto close Micromenu and CombatStylePannel
		Backpack:HookScript("OnShow", function()
			WORS_U_SpellBook.frame:Hide()
			WORS_U_PrayBook.frame:Hide()
			WORS_U_EmoteBook.frame:Hide()
			WORS_U_EquipmentBook.frame:Hide()
			CombatStylePanel:Hide()
			AttachMicroButtonsTo(Backpack)
        end)
		
		-- Hock OnHide to Restore MicroButtonsFromMicroMenu and update spell and prayer micromenu button
		Backpack:HookScript("OnHide", function()
			RestoreMicroButtonsFromMicroMenu()
        end)
		
		-- Hock StopMovingOrSizing to save new postion to all frames
		hooksecurefunc(Backpack, "StopMovingOrSizing", function(self)
			if not WORS_U_MicroMenuSettings.AutoCloseEnabled then return end
			SaveFramePosition(self)
		end)
		
    end
    if CombatStylePanel then
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
            CombatStylePanel:ClearAllPoints()
            CombatStylePanel:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
            CombatStylePanel:SetUserPlaced(false)
        end		
		-- 1) Hide combatstylebg one line for loop
		for _, r in ipairs({CombatStylePanel:GetRegions()}) do if r:GetObjectType()=="Texture" then r:Hide() end end


		-- Hock onShow to auto close Micromenu and Backpack
		CombatStylePanel:HookScript("OnShow", function()
			CombatStylePanel:SetFrameStrata("HIGH")
			CombatStylePanel:SetFrameLevel(50)
			CombatStylePanel:Raise()			
			WORS_U_SpellBook.frame:Hide()
			WORS_U_PrayBook.frame:Hide()
			WORS_U_EmoteBook.frame:Hide()
			WORS_U_EquipmentBook.frame:Hide()
			CloseBackpack()
			AttachMicroButtonsTo(CombatStylePanel)
        end)
		
		-- Hock OnHide to Restore MicroButtonsFromMicroMenu and update spell and prayer micromenu button
		CombatStylePanel:HookScript("OnHide", function()
			RestoreMicroButtonsFromMicroMenu()
        end)
		
		-- Hock OnDragStop to save new postion to all frames
		CombatStylePanel:HookScript("OnDragStop", function(self)
			SaveFramePosition(self)			
			AttachMicroButtonsTo(CombatStylePanel)
		end)		
    end
    
	-- retrys until both A frames are hooked
	if not Backpack and not CombatStylePanel then
        C_Timer.After(0.1, HookAFrames)
    end
end




-- Hook drag-stop on micro-menu frames for saving positions
local function HookMicroMenuFrames()
    for _, frame in ipairs(MicroMenu_Frames) do
        if frame then 			
			frame:SetFrameStrata("HIGH")
			frame:SetFrameLevel(50)
			frame:Raise()
			
			frame:HookScript("OnDragStop", function(self)
				AttachMicroButtonsTo(frame)	
				SaveFramePosition(self)
			end)
			
			-- hock OnShow to stelth load Magic and Prayer frames and attach AttachMicroButtonsTo
			frame:HookScript("OnShow", function(self)
				AttachMicroButtonsTo(frame)	
				local alpha = tonumber(C_CVar.GetNumber and C_CVar.GetNumber("transparentInterface")) or 1
				frame:SetBackdropColor(1, 1, 1, alpha)
			end)
			
			
			-- hock OnHide on ALL Micromenu frames to restore micromenu buttons
			frame:HookScript("OnHide", RestoreMicroButtonsFromMicroMenu) 
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
            HookMicroMenuFrames()	
        end)
		WORS_U_SpellBookFrame:Show()
		SaveFramePosition(WORS_U_SpellBookFrame)		
		WORS_U_SpellBookFrame:Hide()
		RestoreMicroButtonsFromMicroMenu()		
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)

----------------------------------
------- MicroMenuKeyBinds --------
----------------------------------

BINDING_HEADER_WORSMICROMENU = "WORS MicroMenu"


function WORS_U_TOGGLE_SPELL()
  MicroMenu_ToggleFrame(WORS_U_SpellBook.frame)
end

function WORS_U_TOGGLE_EMOTE()
  MicroMenu_ToggleFrame(WORS_U_EmoteBook.frame)
end

function WORS_U_TOGGLE_PRAY()
  MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)
end

function WORS_U_TOGGLE_COMBATSTYLE()
  MicroMenu_ToggleFrame(CombatStylePanel)
end





-- 1) Define your micro-buttons with a list of binding-names (in priority order):
local toggles = {
  { btn = CombatStyleMicroButton,   bindings = { "Toggle Combat Style", "TOGGLECOMBATSTYLE" } },
  { btn = SkillsMicroButton,        bindings = { "TOGGLECHARACTER2" } },
  { btn = QuestsMicroButton,        bindings = { "TOGGLEQUESTLOG" } },
  { btn = InventoryMicroButton,     bindings = { "TOGGLEBACKPACK", "TOGGLEBAG1", "OPENALLBAGS","TOGGLEBAG2", "TOGGLEBAG3", "TOGGLEBAG4"} },
  { btn = CharacterMicroButton,     bindings = { "TOGGLECHARACTER0" } },
  { btn = PrayerMicroButton,        bindings = { "Toggle Prayer" } },
  { btn = U_SpellBookMicroButtonCopy, bindings = { "Toggle Magic" } },
  { btn = SpellbookMicroButton,     bindings = { "TOGGLESPELLBOOK" } },
  { btn = SocialMicroButton,        bindings = { "TOGGLESOCIAL", "TOGGLEGUILDTAB" } },
  { btn = IgnoreMicroButton,        bindings = { } },           -- no binding
  { btn = AchievementsMicroButton,  bindings = { "TOGGLEACHIEVEMENT" } },
  { btn = GameMenuMicroButton,      bindings = { "TOGGLEGAMEMENU" } },
  { btn = CompanionsMicroButton,    bindings = { "TOGGLECHARACTER3" } },
  { btn = EmotesMicroButton,        bindings = { "Toggle Emote" } },
}

-- 2) Create your hotkey FontString once:
for _, info in ipairs(toggles) do
  local btn = info.btn
  btn.bindingNames = info.bindings
  if not btn.hotkey then
    local hk = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hk:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -2, 0)
    btn.hotkey = hk
  end
end

-- 3) Update both the secure-click binding *and* the hotkey text:
local function UpdateToggleHotkeys()
  -- clear any old override-bindings on all these buttons
	for _, info in ipairs(toggles) do
		if not InCombatLockdown() then
			ClearOverrideBindings(info.btn)
		end		
	end

  for _, info in ipairs(toggles) do
    local btn = info.btn
    local key, bindingName

    -- pick the first binding name that actually has a key bound
    for _, name in ipairs(btn.bindingNames) do
      local k = GetBindingKey(name)
      if k then
        key, bindingName = k, name
        break
      end
    end

    if key then
      -- 3a) Make the button *clickable* via that key (in a secure environment)
		if not InCombatLockdown() then
			SetOverrideBindingClick(
			btn,                -- owner frame
			false,              -- local override block
			key,                -- e.g. "B" or "CTRL-B"
			btn:GetName()       -- the named frame to “Click”
			)
		end
      -- 3b) Show the hotkey text
      local text = GetBindingText(key, "KEY_")
        :gsub("CTRL", "C")
        :gsub("ALT",  "A")
        :gsub("SHIFT","S")
        :gsub("Escape","ESC")
      btn.hotkey:SetText(text)

    else
      -- nothing bound → clear both
      btn.hotkey:SetText("")
    end
  end
end

-- 4) Wire it up on login & whenever the player rebinds:
local evt = CreateFrame("Frame")
evt:RegisterEvent("PLAYER_LOGIN")
evt:RegisterEvent("UPDATE_BINDINGS")
evt:SetScript("OnEvent", UpdateToggleHotkeys)


