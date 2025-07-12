-- WORS_U_MagicPrayer.lua
MicroMenu_Frames = {WORS_U_SpellBookFrame, WORS_U_PrayBookFrame, WORS_U_EmoteBookFrame, WORS_U_MusicPlayerFrame, CombatStylePanel} -- MicroMenu frames AND CombatStylePanel

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
	    if  WORS_U_MicroMenuSettings.AutoCloseEnabled then 
			MicroMenu_HideAll()
		end
		targetFrame:Show()		
        AttachMicroButtonsTo(targetFrame)
    end	
end

-- Hook Backpack and CombatStylePanels functions
local function HookAFrames()
    if not WORS_U_MicroMenuSettings.AutoCloseEnabled then return end
    if Backpack then
        local pos = WORS_U_MicroMenuSettings.MicroMenuPOS
        if pos then
            local ref = pos.relativeTo and _G[pos.relativeTo] or UIParent
            Backpack:ClearAllPoints()
            Backpack:SetPoint(pos.point, ref, pos.relativePoint, pos.xOfs, pos.yOfs)
            Backpack:SetUserPlaced(false)
        end
		--Backpack:SetWidth( Backpack:GetWidth() +  12 )

		-- Hock onShow to auto close Micromenu and CombatStylePannel
		Backpack:HookScript("OnShow", function()
            if WORS_U_MicroMenuSettings.AutoCloseEnabled then
                WORS_U_SpellBook.frame:Hide()
				WORS_U_PrayBook.frame:Hide()
				WORS_U_EmoteBook.frame:Hide()
                WORS_U_MusicBook.musicPlayer:Hide()
                CombatStylePanel:Hide()
            end
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

		CombatStylePanel:SetFrameStrata("HIGH")
		CombatStylePanel:SetFrameLevel(50)
		CombatStylePanel:Raise()
		CombatStylePanel:SetSize(180, 330)		

		-- Hock onShow to auto close Micromenu and Backpack
		CombatStylePanel:HookScript("OnShow", function()
			CombatStylePanel:SetFrameStrata("HIGH")
			CombatStylePanel:SetFrameLevel(50)
			CombatStylePanel:Raise()			
			if WORS_U_MicroMenuSettings.AutoCloseEnabled then
                WORS_U_SpellBook.frame:Hide()
				WORS_U_PrayBook.frame:Hide()
				WORS_U_EmoteBook.frame:Hide()
                WORS_U_MusicBook.musicPlayer:Hide()
                CloseBackpack()
            end
			AttachMicroButtonsTo(CombatStylePanel)
        end)
		
		-- Hock OnHide to Restore MicroButtonsFromMicroMenu and update spell and prayer micromenu button
		CombatStylePanel:HookScript("OnHide", function()
			RestoreMicroButtonsFromMicroMenu()
        end)
		

		
		-- Hock OnDragStop to save new postion to all frames
		CombatStylePanel:HookScript("OnDragStop", function(self)
			if not WORS_U_MicroMenuSettings.AutoCloseEnabled then return end
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
    if not WORS_U_MicroMenuSettings.AutoCloseEnabled then
        for _, frame in ipairs(MicroMenu_Frames) do
            if frame then frame:SetUserPlaced(true) end
        end
        return
    end
    for _, frame in ipairs(MicroMenu_Frames) do
        if frame then -- Skip Spell, Prayer and CombatStylePanel frames these handle this individually
			
			frame:HookScript("OnDragStop", function(self)
				if not WORS_U_MicroMenuSettings.AutoCloseEnabled then return end
				AttachMicroButtonsTo(frame)	
				SaveFramePosition(self)
			end)
			
			-- hock OnShow to stelth load Magic and Prayer frames and attach AttachMicroButtonsTo
			frame:HookScript("OnShow", function(self)
				AttachMicroButtonsTo(frame)	
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

function WORS_U_TOGGLE_MUSIC()
  MicroMenu_ToggleFrame(WORS_U_MusicBook.musicPlayer)
end



-- 1) Grab your toggle‐buttons and assign the binding names:
local toggles = {
--{ btn = CombatStyleMicroButton,  		binding = "TOGGLECOMBATSTYLE" },
  { btn = CombatStyleMicroButton,  		binding = "Toggle Combat Style" },
  { btn = SkillsMicroButton,  			binding = "TOGGLECHARACTER2" 	},
  { btn = QuestsMicroButton,  			binding = "TOGGLEQUESTLOG" 		},
  { btn = InventoryMicroButton,  		binding = "TOGGLEBACKPACK" 		},
  { btn = CharacterMicroButton,  		binding = "TOGGLECHARACTER0" 	},
  { btn = PrayerMicroButton,    		binding = "Toggle Prayer"    	},
  { btn = U_SpellBookMicroButtonCopy,   binding = "Toggle Magic"     	},

  { btn = SpellbookMicroButton,   		binding = "TOGGLESPELLBOOK"  	},
  { btn = SocialMicroButton,   			binding = "TOGGLESOCIAL"     	},
  { btn = IgnoreMicroButton,   			binding = ""     	},
  { btn = AchievementsMicroButton,   	binding = "TOGGLEACHIEVEMENT"   },
  { btn = GameMenuMicroButton,   		binding = "TOGGLEGAMEMENU"     	},
  { btn = CompanionsMicroButton,   		binding = "TOGGLECHARACTER3"    },
  { btn = EmotesMicroButton,   			binding = "Toggle Emote"     	},
  { btn = MusicMicroButton,   			binding = "Toggle Music"     	},
}

for _, info in ipairs(toggles) do
  info.btn.bindingName = info.binding

  -- 2) Create a small HotKey text in the top‐right corner:
  local hk = info.btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  hk:SetPoint("TOPRIGHT", info.btn, "TOPRIGHT", -2, 0)
  info.btn.hotkey = hk
end



local function UpdateToggleHotkeys()
  for _, info in ipairs(toggles) do
    local key = GetBindingKey(info.btn.bindingName)
    if key then
      local t = GetBindingText(key, "KEY_")
      -- inline abbreviations, then change “-” to “+”
      t = t
        :gsub("CTRL", "C")
        :gsub("ALT",  "A")
        :gsub("SHIFT","S")
        :gsub("Escape","ESC")
        
      info.btn.hotkey:SetText(t)
    else
      info.btn.hotkey:SetText("")
    end
  end
end


-- 4) Hook into login and binding‐updates:
local evt = CreateFrame("Frame")
evt:RegisterEvent("PLAYER_LOGIN")
evt:RegisterEvent("UPDATE_BINDINGS")
evt:SetScript("OnEvent", UpdateToggleHotkeys)





------------------------------------------------------------------------
---------------- Interface Addon Options -------------------------------
------------------------------------------------------------------------

local optionsFrame = CreateFrame("Frame", "MicroMenuOptionsFrame", InterfaceOptionsFramePanelContainer)
optionsFrame.name = "MicroMenu"
-- Create a scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "MicroMenuOptionsScrollFrame", optionsFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(550, 540) -- Set the desired size of the scroll frame
scrollFrame:SetPoint("TOPLEFT", 16, -16)
local contentFrame = CreateFrame("Frame", "MicroMenuOptionsContentFrame", scrollFrame)
contentFrame:SetSize(400, 500) -- Set size based on the expected total content height
scrollFrame:SetScrollChild(contentFrame)
-- Create a title
local title = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 0, 0)
title:SetText("Micro Menu Options")

-- Create checkbox for pinToBackpack
local autoCloseEnabledCheckbox = CreateFrame("CheckButton", "MicroMenuAutoCloseEnabledCheckbox", contentFrame, "InterfaceOptionsCheckButtonTemplate")
autoCloseEnabledCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 10, -10)
autoCloseEnabledCheckbox.text = autoCloseEnabledCheckbox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
autoCloseEnabledCheckbox.text:SetPoint("LEFT", autoCloseEnabledCheckbox, "RIGHT", 5, 0)
autoCloseEnabledCheckbox.text:SetText("Enable Auto Close *Not recommended to change not tested much after recent changes likely to be removed*") -- Set the checkbox label
autoCloseEnabledCheckbox:SetScript("OnShow", function(self)
    if WORS_U_MicroMenuSettings.AutoCloseEnabled == true then
        self:SetChecked(true)
    else
        self:SetChecked(false)
    end
end)
autoCloseEnabledCheckbox:SetScript("OnClick", function(self)
	WORS_U_MicroMenuSettings.AutoCloseEnabled = self:GetChecked() == 1 and true or false
	HookAFrames()
	HookMicroMenuFrames()
end)

-- Register the options frame
InterfaceOptions_AddCategory(optionsFrame)
