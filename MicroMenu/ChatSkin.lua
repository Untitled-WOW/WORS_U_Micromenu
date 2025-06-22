OSRSChatSettings = OSRSChatSettings or {}  -- Ensure saved variable exists
OSRSChatSettings.hideChatButtons = OSRSChatSettings.hideChatButtons or false  -- Default to 'false'
OSRSChatSettings.savedThemes = OSRSChatSettings.savedThemes or {}
OSRSChatSettings.moveTabsBelowEditBox = OSRSChatSettings.moveTabsBelowEditBox or true

--****************************************************************************************************
--*****Code to add additional font sizes to blizzard option*******************************************
--****************************************************************************************************

--Define custom font sizes
CHAT_FONT_HEIGHTS = { 10, 12, 14, 16, 18, 20, 22 } -- Add more if desired

-- Hook into Blizzard's font size setter to make it safer
hooksecurefunc("FCF_SetChatWindowFontSize", function(_, chatFrame, fontSize)
    if chatFrame and fontSize then
        -- Set font with standard font path, or your own font if you're using a custom one
        chatFrame:SetFont("Fonts\\runescape.ttf", fontSize)
		chatFrame:SetShadowOffset(1, -1)      
		local header = _G[chatFrame:GetName().."EditBoxHeader"]
		if header then
			header:SetFont("Fonts\\runescape.ttf", fontSize)
			header:SetShadowOffset(1, -1) -- Match your desired shadow offset
        end	
		local inputBox = _G[chatFrame:GetName().."EditBox"]
		if inputBox then 
			inputBox:SetFont("Fonts\\runescape.ttf", fontSize)
			inputBox:SetShadowOffset(1, -1) 
		end	
	end
end)

-- Optional: Set default font size for all chat windows on load
local function ApplyDefaultChatFont()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame"..i]
        if chatFrame then
            -- Set to your preferred default size
            chatFrame:SetFont("Fonts\\runescape.ttf", 20 )
			chatFrame:SetShadowOffset(1, -1)

        end
    end
end

-- -- Run once at login
-- local f = CreateFrame("Frame")
-- f:RegisterEvent("PLAYER_LOGIN")
-- f:SetScript("OnEvent", function()
    -- ApplyDefaultChatFont()
-- end)




--****************************************************************************************************
--***** Function from LeatrixPlus to hide chat frame buttons *******************************************
--****************************************************************************************************
local function toggleHideChatButtons()
    local enabled = OSRSChatSettings.hideChatButtons  -- Use saved setting

    -- Enable mouse scrolling and prevent changes
    SetCVar("chatMouseScroll", "1")
    InterfaceOptionsSocialPanelChatMouseScroll:Disable()
    InterfaceOptionsSocialPanelChatMouseScrollText:SetAlpha(0.3)
    InterfaceOptionsSocialPanelChatMouseScroll_SetScrolling("1")

    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame" .. i]
        local buttonFrame = _G["ChatFrame" .. i .. "ButtonFrame"]
        local upButton = _G["ChatFrame" .. i .. "ButtonFrameUpButton"]
        local downButton = _G["ChatFrame" .. i .. "ButtonFrameDownButton"]
        local minimizeButton = _G["ChatFrame" .. i .. "ButtonFrameMinimizeButton"]
        local bottomButton = _G["ChatFrame" .. i .. "ButtonFrameBottomButton"]

        if enabled then
            -- Hide the buttons
            upButton:Hide()
            downButton:Hide()
            minimizeButton:Hide()
            bottomButton:Hide()
            buttonFrame:Hide()
            frame:SetClampedToScreen(false)  -- Allow dragging off screen
			--frame:SetClampRectInsets(-5, 35, 26, -40)
        else
            -- Show the buttons
            upButton:Show()
            downButton:Show()
            minimizeButton:Show()
            bottomButton:Show()
            buttonFrame:Show()
            --frame:SetClampRectInsets(-35, 35, 26, -40)
			frame:SetClampedToScreen(true)   -- Keep clamped when buttons shown
        end
    end

    -- Outer buttons (menu and social)
    if enabled then
        ChatFrameMenuButton:Hide()
        FriendsMicroButton:Hide()
    else
        ChatFrameMenuButton:Show()
        FriendsMicroButton:Show()
    end
end

local function enforceHiddenButtons()
    if OSRSChatSettings.hideChatButtons then
        ChatFrameMenuButton:Hide()
        FriendsMicroButton:Hide()
    end
end

-- Hook the Show method so even if it's shown again, we immediately hide it
hooksecurefunc(ChatFrameMenuButton, "Show", function()
    if OSRSChatSettings.hideChatButtons then
        ChatFrameMenuButton:Hide()
    end
end)

hooksecurefunc(FriendsMicroButton, "Show", function()
    if OSRSChatSettings.hideChatButtons then
        FriendsMicroButton:Hide()
    end
end)

-- Also hook window updates just in case
hooksecurefunc("FCF_UpdateButtonSide", enforceHiddenButtons)


-----------------------------------------------------------------------------------------





--****************************************************************************************************
--***** Start of ChatReskin **************************************************************************
--****************************************************************************************************
-- Function to reskin the chat frame
local function ReskinChatFrame(chatFrame)
    local frameID = chatFrame:GetID()
    local name, fontSize, r, g, b, alpha = GetChatWindowInfo(frameID)	
	
	-- Hide the default background textures of the chat frame
    for _, region in ipairs({chatFrame:GetRegions()}) do
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        end
    end
	
    -- Remove old background if it exists
    if chatFrame.WORS_CustomBackground then
        chatFrame.WORS_CustomBackground:Hide()
        chatFrame.WORS_CustomBackground:SetParent(nil)
        chatFrame.WORS_CustomBackground = nil
    end
	local inputBox = _G[chatFrame:GetName().."EditBox"]

	
	if inputBox.WORS_CustomBackground then
	    inputBox.WORS_CustomBackground:Hide()
        inputBox.WORS_CustomBackground:SetParent(nil)
        inputBox.WORS_CustomBackground = nil
	end
    -- Create custom background for the chat frame
    local bg = CreateFrame("Frame", nil, chatFrame)
    
	if OSRSChatSettings.moveTabsBelowEditBox then
		bg:SetPoint("TOPLEFT", -7, 7)
		bg:SetPoint("BOTTOMRIGHT", 10, -70)
    else
		bg:SetPoint("TOPLEFT", -7, 30)
		bg:SetPoint("BOTTOMRIGHT", 10, -7)
    end	
	--bg:SetPoint("TOPLEFT", -7, 30)
    --bg:SetPoint("BOTTOMRIGHT", 10, -7)
    bg:SetFrameStrata("BACKGROUND")
    bg:SetFrameLevel(0)
    --bg:SetAlpha(1) -- Fully opaque initially
    bg:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",  -- Plain white texture for easy coloring
        edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",  -- Border
        tile = false, edgeSize = 32,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    --bg:SetBackdropColor(0.694, 0.635, 0.51, 0.8) -- Initial color #B1A282 with transparency
	bg:SetBackdropColor(r, g, b, alpha)    -- Store the reference to the custom background for later color updates
	chatFrame.WORS_CustomBackground = bg

	if chatFrame.SetShadowOffset then chatFrame:SetShadowOffset(1, -1) end

    -- Create custom background for the input box (edit box)
    --local inputBox = _G[chatFrame:GetName().."EditBox"]
    if inputBox then
        -- Hide the default background and border of the input box
        for _, region in ipairs({inputBox:GetRegions()}) do
            if region:GetObjectType() == "Texture" then
                region:SetTexture(nil)
            end
        end

        -- Create custom background for the input box
        local inputBg = CreateFrame("Frame", nil, inputBox)
        inputBg:SetPoint("TOPLEFT", -3, 1)
        inputBg:SetPoint("BOTTOMRIGHT", 5, -5)
        inputBg:SetFrameStrata("BACKGROUND")
        inputBg:SetFrameLevel(0)
        inputBg:SetAlpha(1) -- Fully opaque initially
        inputBg:SetBackdrop({
            --bgFile = "Interface\\WORS\\OldSchool-Dialog-Background",
			bgFile = "Interface\\Buttons\\WHITE8x8",  -- Plain white texture for easy coloring
            edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",  -- Border
            tile = false, edgeSize = 32,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        })
		inputBg:SetBackdropColor(r, g, b, alpha)    -- Store the reference to the custom background for later color updates

		inputBox.WORS_CustomBackground = inputBg

        -- Adjust text position inside the input box using SetTextInsets
        inputBox:SetTextInsets(5, 5, 5, 10)  -- Adjust the bottom inset to move the text down
		if inputBox.SetShadowOffset then inputBox:SetShadowOffset(1, -1) end
		-- Fix shadow and position for the "Say:" label text
        local header = _G[chatFrame:GetName().."EditBoxHeader"]
        if header then
            if header.SetShadowOffset then header:SetShadowOffset(1, -1) end-- Match your desired shadow offset
        end	
	end	
end


--****************************************************************************************************
--***** Code to change chat channels set colour*******************************************
--****************************************************************************************************

local customChatColors = {
    -- Public
	CHANNEL1 = { r = 0, g = 0, b = 0 }, -- Global 1: General 	(black)
	CHANNEL2 = { r = 0, g = 0, b = 0 }, -- Global 2: N/a? 		(black)
	CHANNEL3 = { r = 0, g = 0, b = 0 }, -- Global 3: Gielinor   (black) Ascension
	CHANNEL4 = { r = 0, g = 0, b = 0 }, -- Global 4: Newcomers  (black)
	CHANNEL5 = { r = 0, g = 0, b = 0 }, -- Global 5: N/a? 		(black)
	-- Player communication
    SAY             = { r = 0, g = 0, b = 1 },          	-- Blue
    YELL            = { r = 1.0, g = 0, b = 0 },       		-- Red
    WHISPER         = { r = 0, g = 0.9, b = 1 },        	-- Cyan
    WHISPER_INFORM  = { r = 0, g = 0.9, b = 1 },         	-- Cyan
	GUILD           = { r = 0.2, g = 1.0, b = 0 },        	-- Green
    OFFICER         = { r = 0.1, g = 1.0, b = 0 },        	-- Green
    PARTY           = { r = 0.4627, g = 0.7843, b = 1.0 }, 	-- Cyan (#76C8FF)
    PARTY_LEADER    = { r = 0.4627, g = 0.7843, b = 1.0 }, 	-- Cyan
    RAID            = { r = 1.0, g = 0.5, b = 0 },       	-- Orange
    RAID_LEADER     = { r = 1.0, g = 0.28, b = 0.0 },   	-- Deep Orange
    RAID_WARNING    = { r = 1.0, g = 0.1, b = 0.1 },    	-- Red-Orange
    -- System
    SYSTEM          = { r = 1.0, g = 0, b = 0 },       -- Red
    -- Emotes
    EMOTE           = { r = 1.0, g = 0.28, b = 0.0 },    -- Orange
    TEXT_EMOTE      = { r = 1.0, g = 0.28, b = 0.0 },    -- Orange
    -- NPC
    MONSTER_SAY     = { r = 0, g = 0, b = 1 },     		-- Blue   (Same as player say)
    MONSTER_YELL    = { r = 1, g = 0, b = 0 },     		-- Red    (Same as player yell)	
    MONSTER_EMOTE   = { r = 1.0, g = 0.28, b = 0.0 }, 	-- Orange (Same as player emote)	
    -- Combat
    COMBAT_MISC_INFO        = { r = 1.0, g = 1.0, b = 1.0 }, -- White
    COMBAT_XP_GAIN          = { r = 0.1, g = 0.1, b = 1.0 }, -- Light Purple
    COMBAT_FACTION_CHANGE   = { r = 0.1, g = 0.1, b = 1.0 }, -- Blue
    -- Loot/Money
    LOOT            = { r = 0, g = 1.0, b = 0 },       -- Greenish
    MONEY           = { r = 1, g = 0.8, b = 0 },     -- Gold
}

local function ApplyCustomChatColors()
    for chatType, color in pairs(customChatColors) do
        ChangeChatColor(chatType, color.r, color.g, color.b)
        print("|cff00ff00[OSRSChatColours]|r Set color for " .. chatType)
    end
end


StaticPopupDialogs["CONFIRM_OSRS_CHAT_COLORS"] = {
    text = "Apply OSRS chat colors?\nThis will overwrite your current chat color settings.",
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        ApplyCustomChatColors()
        print("|cff00ff00[OSRSChatColours]|r Custom chat colors applied.")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}


local defaultChatColors = {
    -- Public
    CHANNEL1 = { r = 1.000000059138984, g = 0.752941220998764, b = 0.752941220998764 }, -- Global 1: General
    CHANNEL2 = { r = 1.000000059138984, g = 0.752941220998764, b = 0.752941220998764 }, -- Global 2
    CHANNEL3 = { r = 1.000000059138984, g = 0.752941220998764, b = 0.752941220998764 }, -- Global 3: Gielinor
    CHANNEL4 = { r = 1.000000059138984, g = 0.752941220998764, b = 0.752941220998764 }, -- Global 4: Newcomers
    CHANNEL5 = { r = 1.000000059138984, g = 0.752941220998764, b = 0.752941220998764 }, -- Global 5
	-- Player communication
	SAY = { r = 1.000000059138984, g = 1.000000059138984, b = 1.000000059138984 }, 
    YELL = { r = 1.000000059138984, g = 0.250980406999588, b = 0.250980406999588 },
    WHISPER = { r = 1.000000059138984, g = 0.501960813999176, b = 1.000000059138984 },
    WHISPER_INFORM = { r = 1.000000059138984, g = 0.501960813999176, b = 1.000000059138984 },
    GUILD = { r = 0.250980406999588, g = 1.000000059138984, b = 0.250980406999588 },
    OFFICER = { r = 0.250980406999588, g = 0.752941220998764, b = 0.250980406999588 },
    PARTY = { r = 0.6666667060926557, g = 0.6666667060926557, b = 1.000000059138984 },
    PARTY_LEADER = { r = 0.4627451254054904, g = 0.7843137718737125, b = 1.000000059138984 },
    RAID = { r = 1.000000059138984, g = 0.4980392451398075, b = 0 },
    RAID_LEADER = { r = 1.000000059138984, g = 0.2823529578745365, b = 0.03529411973431706 },
    RAID_WARNING = { r = 1.000000059138984, g = 0.2823529578745365, b = 0 },
    -- System
	SYSTEM = { r = 1.000000059138984, g = 1.000000059138984, b = 0 },
    -- Emotes    
	EMOTE = { r = 1.000000059138984, g = 0.501960813999176, b = 0.250980406999588 },
    TEXT_EMOTE = { r = 1.000000059138984, g = 0.501960813999176, b = 0.250980406999588 },
    -- NPC    
	MONSTER_SAY = { r = 1.000000059138984, g = 1.000000059138984, b = 0.6235294486396015 },
    MONSTER_YELL = { r = 1.000000059138984, g = 0.250980406999588, b = 0.250980406999588 },
    MONSTER_EMOTE = { r = 1.000000059138984, g = 0.501960813999176, b = 0.250980406999588 },
    -- Combat	
	COMBAT_MISC_INFO = { r = 0.501960813999176, g = 0.501960813999176, b = 1.000000059138984 },
    COMBAT_XP_GAIN = { r = 0.4352941433899105, g = 0.4352941433899105, b = 1.000000059138984 },
    COMBAT_FACTION_CHANGE = { r = 0.501960813999176, g = 0.501960813999176, b = 1.000000059138984 },
    -- Loot/Money    
	LOOT = { r = 0, g = 0.6666667060926557, b = 0 },
    MONEY = { r = 1.000000059138984, g = 1.000000059138984, b = 0 },
}

local function ApplyDefaultTextColors()
    for chatType, color in pairs(defaultChatColors) do
        ChangeChatColor(chatType, color.r, color.g, color.b)
        print("|cff00ff00[OSRSChatColours]|r Set color for " .. chatType)
    end
end


StaticPopupDialogs["CONFIRM_DEFAULT_CHAT_COLORS"] = {
    text = "Apply Default chat colors?\nThis will overwrite your current chat color settings.",
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        ApplyDefaultTextColors()
        print("|cff00ff00[OSRSChatColours]|r Default chat colors applied.")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

---------------------------------------------------------------
---------------Debug: confirm addon loaded---------------------
---------------------------------------------------------------
print("ChallengeModeChatIcons loaded")

-- Buff name to icon path mapping
local CHALLENGE_AURAS = {
    ["Ironman"] = "Interface\\Icons\\Ironman-mode",
    ["Group Ironman"] = "Interface\\Icons\\Groupironman-mode",
    ["Hardcore Ironman"] = "Interface\\Icons\\Hardcoreironman-mode",
    ["Group Hardcore Ironman"] = "Interface\\Icons\\Hardcoregroupironman-mode",
    ["Ultimate"] = "Interface\\Icons\\Ultimateironman-mode",
    ["Walking Man"] = "Interface\\Icons\\walkman-mode",
    ["Skiller"] = "Interface\\Icons\\skiller-mode",
    ["Nightmare Mode"] = "Interface\\Icons\\nightmare-mode",
}

-- Saved variable initialization
if not PlayerChallengeModes then
    PlayerChallengeModes = {}
end

-- Scan target or mouseover for buffs
local function ScanUnitForAuras(unit)
    local name = UnitName(unit)
    if not name then return end

    -- Track which buffs are currently active
    local currentBuffs = {}

    for i = 1, 40 do
        local buffName = UnitBuff(unit, i)
        if not buffName then break end

        currentBuffs[buffName] = true

        -- Add new challenge buffs
        local iconPath = CHALLENGE_AURAS[buffName]
        if iconPath then
            PlayerChallengeModes[name] = PlayerChallengeModes[name] or {}
            if not PlayerChallengeModes[name][buffName] then
                PlayerChallengeModes[name][buffName] = iconPath
                print("Stored icon for", name, ":", buffName)
            end
        end
    end

    -- Remove buffs that were cached but are no longer active
    if PlayerChallengeModes[name] then
        for buffName in pairs(PlayerChallengeModes[name]) do
            if not currentBuffs[buffName] then
                print("Removing expired icon for", name, ":", buffName)
                PlayerChallengeModes[name][buffName] = nil
            end
        end
        -- Clean up empty tables
        if next(PlayerChallengeModes[name]) == nil then
            PlayerChallengeModes[name] = nil
        end
    end
end


-- Event handler for buff detection
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_TARGET_CHANGED" then
        ScanUnitForAuras("target")
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        ScanUnitForAuras("mouseover")
    end
end)

-- Chat filter to inject icons
local function AddChallengeIconsToChat(self, event, msg, sender, ...)
    if not sender or sender == "" then return false end

    local iconString = ""
    local iconTable = PlayerChallengeModes[sender]

    if iconTable then
        for _, iconPath in pairs(iconTable) do
            iconString = iconString .. "|T" .. iconPath .. ":12:12:0:0|t"
        end
    end

    if iconString ~= "" then
        -- Prepend the icon(s) to the message (not the hyperlink to preserve right-click)
        local modifiedMsg = iconString .. " " .. msg
        return false, modifiedMsg, sender, ...
    end

    return false
end

-- Register chat filter
local chatEvents = {
    "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_GUILD",
    "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_WHISPER", "CHAT_MSG_CHANNEL", "CHAT_MSG_OFFICER",
}

for _, evt in ipairs(chatEvents) do
    ChatFrame_AddMessageEventFilter(evt, AddChallengeIconsToChat)
end

-----------------------------------------------------------------
--------Change Chat Theme from right click menu -----------------
-----------------------------------------------------------------

-- Built-in themes
local builtInThemes = {
	DARK = { r = 0.1, g = 0.1, b = 0.1, a = 0.85 },
	OSRS = { r = 0.694, g = 0.635, b = 0.51, a = 0.9 },
	OSRS_TRANSPARENT = { r = 0.694, g = 0.635, b = 0.51, a = 0.3 },
	OSRS_Light = { r = 0.796, g = 0.729, b = 0.584, a = 1 },
	OSRS_Dark = { r = 0.243, g = 0.208, b = 0.161, a = 1},
}

local chatColorTypes = { "CHANNEL1", "CHANNEL2", "CHANNEL3", "CHANNEL4", "CHANNEL5", "SAY", "YELL", "WHISPER", "WHISPER_INFORM", "GUILD", "OFFICER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "SYSTEM", "EMOTE", "TEXT_EMOTE", "MONSTER_SAY", "MONSTER_YELL", "MONSTER_EMOTE", "COMBAT_MISC_INFO", "COMBAT_XP_GAIN", "COMBAT_FACTION_CHANGE", "LOOT", "MONEY" }

local function GetCurrentChatColors()
    local colors = {}
    for _, chatType in ipairs(chatColorTypes) do
        local info = ChatTypeInfo[chatType]
        if info then
            colors[chatType] = { r = info.r, g = info.g, b = info.b }
        end
    end
    return colors
end

local function ApplyChatTextColors(colorTable)
    if not colorTable then return end
    for chatType, color in pairs(colorTable) do
        if ChatTypeInfo[chatType] and color.r and color.g and color.b then
			ChangeChatColor(chatType, color.r, color.g, color.b)
        end
    end
	-- clear old chat messages
	for i = 1, NUM_CHAT_WINDOWS do
        local cf = _G["ChatFrame"..i]
        if cf and cf:IsVisible() then
            cf:Clear()		
        end
    end
end


local function SetChatTheme(theme)
    local color = builtInThemes[theme] or OSRSChatSettings.savedThemes and OSRSChatSettings.savedThemes[theme]
    if not color then
        print("|cffFF0000[OSRSChat]|r Theme not found: " .. tostring(theme))
        return
    end
    for i = 1, NUM_CHAT_WINDOWS do
        local cf = _G["ChatFrame"..i]
        if cf then
            if cf.WORS_CustomBackground then
                cf.WORS_CustomBackground:SetBackdropColor(color.r, color.g, color.b, color.a)
                cf.WORS_CustomBackground:SetAlpha(color.a)
            end
            FCF_SetWindowColor(cf, color.r, color.g, color.b, color.a)
            FCF_SetWindowAlpha(cf, color.a)
			print("|cffFF961F[OSRSChat]|r Theme Background and Alpha applied: " .. theme)

        end
		if color.textColors then
			ApplyChatTextColors(color.textColors)
			print("|cffFF961F[OSRSChat]|r Theme Text Colours applied: " .. theme)
		end

	
	end
	
    print("|cffFF961F[OSRSChat]|r Theme applied: " .. theme)
end


local function SaveCurrentColorTheme(name)
    if not name or name == "" then return end
    local frameID = 1  -- Use ChatFrame1 as reference
    local _, _, r, g, b, alpha = GetChatWindowInfo(frameID)
    OSRSChatSettings.savedThemes = OSRSChatSettings.savedThemes or {}
    OSRSChatSettings.savedThemes[name] = {
        r = r,
        g = g,
        b = b,
        a = alpha,
		textColors = GetCurrentChatColors(),
    }
	SetChatTheme(name)
    print("|cff00FF00[OSRSChat]|r Theme saved as '" .. name .. "'")
end

StaticPopupDialogs["SAVE_OSRS_CHAT_COLOR_THEME"] = {
    text = "Enter a name for the new chat background theme:",
    button1 = "Save",
    button2 = "Cancel",
    hasEditBox = true,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnAccept = function(self)
        local name = self.editBox:GetText()
        SaveCurrentColorTheme(name)
    end,
}

local function DeleteColorTheme(name)
    OSRSChatSettings.savedThemes[name] = nil
    print("|cffFF961F[OSRSChat]|r Deleted theme: " .. name)
end

StaticPopupDialogs["OSRS_CONFIRM_DELETE_THEME"] = {
    text = "Are you sure you want to delete the theme '%s'?",
    button1 = YES,
    button2 = NO,
    OnAccept = function(self, data)
        DeleteColorTheme(data)
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}


-----------------------------------------------------------------
-------- Toggle Chat tab postion to bellow editbox -----------------
-----------------------------------------------------------------

-- Function to update tab positions based on setting
local function UpdateChatTabPositions()
    -- Just one dock manager to move: GeneralDockManager
    if not GeneralDockManager or not ChatFrame1 or not ChatFrame1.editBox then return end

    GeneralDockManager:ClearAllPoints()

    if OSRSChatSettings.moveTabsBelowEditBox then
        -- Move tabs below edit box
        GeneralDockManager:SetPoint("TOPLEFT", ChatFrame1.editBox, "BOTTOMLEFT", 0, 0)
        GeneralDockManager:SetPoint("TOPRIGHT", ChatFrame1.editBox, "BOTTOMRIGHT", 0, -5)
    else
        -- Default position above chat frame
        GeneralDockManager:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 0)
        GeneralDockManager:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 0, 0)
    end
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		if cf then
			-- Reskin chat frame
			ReskinChatFrame(cf)
		end
	end
	
	
	

end

-- Hook into Blizzard layout functions to maintain position
hooksecurefunc("FCF_DockUpdate", UpdateChatTabPositions)
hooksecurefunc("FCF_UpdateDockPosition", UpdateChatTabPositions)



-- Toggle function (call this via UI or slash command)
function ToggleMoveChatTabs()
    UpdateChatTabPositions()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		if cf then
			-- Reskin chat frame
			ReskinChatFrame(cf)
		end
	end	
end

-----------------------------------------------------------------
-------- Add reg background to selected chat tab -----------------
-----------------------------------------------------------------
local function UpdateSelectedTabRed()
    for i = 1, NUM_CHAT_WINDOWS do
        local tab = _G["ChatFrame"..i.."Tab"]
        if tab then
            -- Create a red background frame if it doesn't exist yet
            if not tab.redBackground then
                local bg = CreateFrame("Frame", nil, tab)
                bg:SetPoint("TOPLEFT", tab, 7, -15)
                bg:SetPoint("BOTTOMRIGHT", tab, -7, 0)
                bg:SetFrameLevel(0)
                bg:SetBackdrop({
                    bgFile = "Interface\\Buttons\\WHITE8x8",
                    edgeFile = nil,
                    tile = false,
                    edgeSize = 0,
                    insets = {left = 0, right = 0, top = 0, bottom = 0}
                })
                bg:SetBackdropColor(1, 0, 0, 0.3)  -- semi-transparent red background
                
                tab.redBackground = bg
            end

            if tab:IsShown() and tab:GetID() == SELECTED_CHAT_FRAME:GetID() then
                tab.redBackground:Show()
                -- Also keep selected textures bright red
                tab.leftSelectedTexture:SetBlendMode("ADD")
                tab.middleSelectedTexture:SetBlendMode("ADD")
                tab.rightSelectedTexture:SetBlendMode("ADD")

                tab.leftSelectedTexture:SetVertexColor(1, 0, 0, 1)
                tab.middleSelectedTexture:SetVertexColor(1, 0, 0, 1)
                tab.rightSelectedTexture:SetVertexColor(1, 0, 0, 1)
            else
                tab.redBackground:Hide()
                -- Reset the selected textures color to normal (white)
                tab.leftSelectedTexture:SetVertexColor(1, 1, 1, 1)
                tab.middleSelectedTexture:SetVertexColor(1, 1, 1, 1)
                tab.rightSelectedTexture:SetVertexColor(1, 1, 1, 1)
            end
        end		
    end
end

hooksecurefunc("FCF_SelectDockFrame", UpdateSelectedTabRed)
hooksecurefunc("FCF_Tab_OnClick", UpdateSelectedTabRed)

----------------------------------------------------------------------
--------------------------------------------------------------------

local originalSetAlpha = {}

local function SafeSetAlpha(self, alpha)
    if alpha < 1 then
        alpha = 1
    end
    -- Call the original SetAlpha only once with alpha forced to 1
    originalSetAlpha[self](self, alpha)
end

local function PreventTabDimming()
    for i = 1, NUM_CHAT_WINDOWS do
        local tab = _G["ChatFrame"..i.."Tab"]
        if tab and not originalSetAlpha[tab] then
            originalSetAlpha[tab] = tab.SetAlpha
            tab.SetAlpha = SafeSetAlpha
            tab:SetAlpha(1)
        end
    end
end

--PreventTabDimming()

hooksecurefunc("FCFTab_UpdateAlpha", PreventTabDimming)
hooksecurefunc("FCF_SelectDockFrame", PreventTabDimming)
hooksecurefunc("FCF_Tab_OnClick", PreventTabDimming)


------------------------------------------------------------------------------------
-----Hock into chat tab right click menus and add OSRS Chat Settings-------------------
------------------------------------------------------------------------------------
hooksecurefunc("FCF_Tab_OnClick", function(self)
    local tabID = self:GetID()
    local dropdown = _G["ChatFrame"..tabID.."TabDropDown"]
    if dropdown and not dropdown.osrsThemeHooked then
        local originalInit = dropdown.initialize
        -- Wrap Blizzard's initialize function
        dropdown.initialize = function(self, level)
            if originalInit then
                originalInit(self, level)
            end
            -- Inject our extra menu options
            if level == 1 then
                UIDropDownMenu_AddButton({
                    text = "|cffFF961FOSRS Chat Settings|r",
                    isTitle = true,
                    notCheckable = true,
                }, level)

                UIDropDownMenu_AddButton({
                    text = "Theme",
                    hasArrow = true,
                    notCheckable = true,
                    value = "OSRS_THEME_MENU"
                }, level)
				UIDropDownMenu_AddButton({
				text = "Apply OSRS Chat Text Colors",
				notCheckable = true,
				func = function()
						StaticPopup_Show("CONFIRM_OSRS_CHAT_COLORS")
					end,
				}, level)
				UIDropDownMenu_AddButton({
				text = "Apply Default Chat Text Colors",
				notCheckable = true,
				func = function()
						StaticPopup_Show("CONFIRM_DEFAULT_CHAT_COLORS")
					end,
				}, level)
				UIDropDownMenu_AddButton({
				text = "Hide Chat Buttons",
				isNotRadio = true,
				keepShownOnClick = true,
				checked = OSRSChatSettings.hideChatButtons,  -- Checked if it's enabled
				func = function(self)
					-- Toggle the hideChatButtons setting
					OSRSChatSettings.hideChatButtons = not OSRSChatSettings.hideChatButtons
					toggleHideChatButtons()  -- Reapply the new setting
					self.checked = OSRSChatSettings.hideChatButtons  -- Update the checkbox state
				end,
				}, level)
				--
				UIDropDownMenu_AddButton({
				text = "Chat Tabs under chat box",
				isNotRadio = true,
				keepShownOnClick = true,
				checked = OSRSChatSettings.moveTabsBelowEditBox,  -- Checked if it's enabled
				func = function(self)
					OSRSChatSettings.moveTabsBelowEditBox = not OSRSChatSettings.moveTabsBelowEditBox
					ToggleMoveChatTabs() -- Reapply the new setting
					self.checked = OSRSChatSettings.moveTabsBelowEditBox  -- Update the checkbox state
				end,
				}, level)

            elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == "OSRS_THEME_MENU" then
				-- Built-in themes
				UIDropDownMenu_AddButton({
					text = "Preset Themes",
					isTitle = true,
					notCheckable = true,
				}, level)
				for themeName in pairs(builtInThemes) do
					UIDropDownMenu_AddButton({
						text = themeName,
						func = function()
							SetChatTheme(themeName)
							ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
						end,
						notCheckable = true,
						tooltipTitle = "Click to apply",

					}, level)
				end
				-- Custom saved themes
				UIDropDownMenu_AddButton({
					text = "Custom Themes",
					isTitle = true,
					notCheckable = true,
				}, level)
				-- Save theme
				UIDropDownMenu_AddButton({
					text = "Save Current Theme",
					func = function()
						StaticPopup_Show("SAVE_OSRS_CHAT_COLOR_THEME")
					end,
					notCheckable = true,
					tooltipTitle = "Click to save theme",
				}, level)
				-- Custom saved themes
				for name in pairs(OSRSChatSettings.savedThemes) do
					UIDropDownMenu_AddButton({
						text = name,
						func = function()
							if IsShiftKeyDown() then
								StaticPopup_Show("OSRS_CONFIRM_DELETE_THEME", name, nil, name)
								--DeleteColorTheme(name)
							else
								SetChatTheme(name)
							end
							ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
						end,
						notCheckable = true,
						tooltipTitle = "Click to apply",
						tooltipText = "Shift-click to delete",
					}, level)
				end
			end
        end
        dropdown.osrsThemeHooked = true
        -- 🚨 Force menu to re-open on first click to apply changes immediately
        -- Close current dropdown and reopen it with new initialize function
        ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
		ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
    end
end)

--------------------------------------------------------------------------------------------------------------------------
---------Hook into Blizzard's color change for chat windows to apply the new color and transparency-----------------------
--------------------------------------------------------------------------------------------------------------------------

local function HookFCF_SetWindowColor()
    local orig_FCF_SetWindowColor = FCF_SetWindowColor
    -- Hook the function to capture the color changes in blizzard ui
    FCF_SetWindowColor = function(chatFrame, r, g, b)
        -- Call the original function to apply the color to the Blizzard chat frame
        orig_FCF_SetWindowColor(chatFrame, r, g, b)
        -- Now update your custom background frame with the new color
        if chatFrame.WORS_CustomBackground then
            chatFrame.WORS_CustomBackground:SetBackdropColor(r, g, b, a)  -- Fully opaque
        end
		local inputBox = _G[chatFrame:GetName().."EditBox"]
		if inputBox then
            inputBox.WORS_CustomBackground:SetBackdropColor(r, g, b, a)  -- Fully opaque
		end
    end
end

local function HookFCF_SetWindowAlpha()
    local orig_FCF_SetWindowAlpha = FCF_SetWindowAlpha

    -- Hook the function to capture the transparency changes  in blizzard ui
    FCF_SetWindowAlpha = function(chatFrame, a)
        -- Call the original function to apply the alpha to the Blizzard chat frame
        orig_FCF_SetWindowAlpha(chatFrame, a)
        -- Now update your custom background frame with the new transparency (alpha)
        if chatFrame.WORS_CustomBackground then
            chatFrame.WORS_CustomBackground:SetAlpha(a)
        end
		local inputBox = _G[chatFrame:GetName().."EditBox"]
		if inputBox then
            inputBox.WORS_CustomBackground:SetAlpha(a)  -- Fully opaque
		end
    end
end


------------------------------------------------------------------
--------- Initialize Addon settings on loggin  -------------------
------------------------------------------------------------------



local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	toggleHideChatButtons()
	UpdateChatTabPositions()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		if cf then
			-- Reskin chat frame
			ReskinChatFrame(cf)
		end
	end
	HookFCF_SetWindowColor()
	HookFCF_SetWindowAlpha()
	UpdateSelectedTabRed()
end)