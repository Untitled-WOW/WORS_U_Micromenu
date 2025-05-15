WORS_U_PrayBook = {}  -- Create the main table for the PrayBook

WORS_U_PrayBook.prayers = {
    {level = 1, id = 79502, buffIcon = "Interface\\Icons\\active_thickskin.blp"},  -- Thick Skin
    {level = 4, id = 79506, buffIcon = "Interface\\Icons\\active_burststrength.blp"},  -- Burst of Strength
    {level = 7, id = 79508, buffIcon = "Interface\\Icons\\active_claritythought.blp"},  -- Clarity of Thought
    {level = 8, id = 79512, buffIcon = "Interface\\Icons\\active_sharpeye.blp"},  -- Sharp Eye
    {level = 9, id = 79514, buffIcon = "Interface\\Icons\\active_mysticwill.blp"},  -- Mystic Will
    {level = 10, id = 79503, buffIcon = "Interface\\Icons\\active_rockskin.blp"},  -- Rock Skin
    {level = 13, id = 79505, buffIcon = "Interface\\Icons\\active_superhumanstrength.blp"},  -- Superhuman Strength
    {level = 16, id = 79509, buffIcon = "Interface\\Icons\\active_improvedreflexes.blp"},  -- Improved Reflexes
	-- ***************CHANGE TO RESTORE CURRENTLY ***rapidheal***
    {level = 19, id = 79521, buffIcon = "Interface\\Icons\\active_rapidrestore.blp"},    -- Rapid Restore  CHANGE TO RESTORE CURRENTLY DOUBLE HEAL
    {level = 22, id = 79521, buffIcon = "Interface\\Icons\\active_rapidheal.blp"},    -- Rapid Heal
    {level = 25, id = 114131, buffIcon = "Interface\\Icons\\active_protectitem.blp"},    -- Protect Item
    {level = 26, id = 79511, buffIcon = "Interface\\Icons\\active_hawkeye.blp"},    -- Hawk Eye
    {level = 27, id = 79516, buffIcon = "Interface\\Icons\\active_mysticlore.blp"},    -- Mystic Lore
    {level = 28, id = 79504, buffIcon = "Interface\\Icons\\active_steelskin.blp"},    -- Steel Skin
    {level = 31, id = 79507, buffIcon = "Interface\\Icons\\active_ultimatestrength.blp"},    -- Ultimate Strength
    {level = 34, id = 79510, buffIcon = "Interface\\Icons\\active_incrediblereflexes.blp"},    -- Incredible Reflexes
    {level = 37, id = 79501, buffIcon = "Interface\\Icons\\active_magicpray.blp"},    -- Protect from Magic
    {level = 40, id = 79500, buffIcon = "Interface\\Icons\\active_rangepray.blp"},    -- Protect from Missiles
    {level = 43, id = 465, buffIcon = "Interface\\Icons\\active_meleepray.blp"},    -- Protect from Melee
    {level = 44, id = 79513, buffIcon = "Interface\\Icons\\active_eagleeye.blp"},    -- Eagle Eye
    {level = 45, id = 79515, buffIcon = "Interface\\Icons\\active_mysticmight.blp"},    -- Mystic Might
    --{level = 46, id = nil, buffIcon = "Interface\\Icons\\active_.blp"},    -- Retribution
    --{level = 49, id = nil, buffIcon = "Interface\\Icons\\active_.blp"},    -- Redemption
    --{level = 52, id = nil, buffIcon = "Interface\\Icons\\active_.blp"},    -- Smite
    --{level = 55, id = nil, buffIcon = "Interface\\Icons\\active_.blp"},    -- Preserve
    --{level = 60, id = 79517, buffIcon = "Interface\\Icons\\active_chivalry.blp"},    -- Chivalry
    --{level = 70, id = 79518, buffIcon = "Interface\\Icons\\active_piety.blp"},    -- Piety
    --{level = 74, id = 79519, buffIcon = "Interface\\Icons\\active_rigour.blp"},    -- Rigour
    --{level = 77, id = 79520, buffIcon = "Interface\\Icons\\active_augury.blp"},    -- Augury
	
}



local experienceTable = {
    [1] = 0,
    [2] = 83,
    [3] = 174,
    [4] = 276,
    [5] = 388,
    [6] = 512,
    [7] = 650,
    [8] = 801,
    [9] = 969,
    [10] = 1154,
    [11] = 1358,
    [12] = 1584,
    [13] = 1833,
    [14] = 2107,
    [15] = 2411,
    [16] = 2746,
    [17] = 3115,
    [18] = 3523,
    [19] = 3973,
    [20] = 4470,
    [21] = 5018,
    [22] = 5624,
    [23] = 6291,
    [24] = 7028,
    [25] = 7842,
    [26] = 8740,
    [27] = 9730,
    [28] = 10824,
    [29] = 12031,
    [30] = 13363,
    [31] = 14833,
    [32] = 16456,
    [33] = 18247,
    [34] = 20224,
    [35] = 22406,
    [36] = 24815,
    [37] = 27473,
    [38] = 30408,
    [39] = 33648,
    [40] = 37224,
    [41] = 41171,
    [42] = 45529,
    [43] = 50339,
    [44] = 55649,
    [45] = 61512,
    [46] = 67983,
    [47] = 75127,
    [48] = 83014,
    [49] = 91721,
    [50] = 101333,
    [51] = 111945,
    [52] = 123660,
    [53] = 136594,
    [54] = 150872,
    [55] = 166636,
    [56] = 184040,
    [57] = 203254,
    [58] = 224466,
    [59] = 247886,
    [60] = 273742,
    [61] = 302288,
    [62] = 333804,
    [63] = 368599,
    [64] = 407015,
    [65] = 449428,
    [66] = 496254,
    [67] = 547953,
    [68] = 605032,
    [69] = 668051,
    [70] = 737627,
    [71] = 814445,
    [72] = 899257,
    [73] = 992895,
    [74] = 1096278,
    [75] = 1210421,
    [76] = 1336443,
    [77] = 1475581,
    [78] = 1629200,
    [79] = 1798808,
    [80] = 1986068,
    [81] = 2192818,
    [82] = 2421087,
    [83] = 2673114,
    [84] = 2951373,
    [85] = 3258594,
    [86] = 3597792,
    [87] = 3972294,
    [88] = 4385776,
    [89] = 4842295,
    [90] = 5346332,
    [91] = 5902831,
    [92] = 6517253,
    [93] = 7195629,
    [94] = 7944614,
    [95] = 8771558,
    [96] = 9684577,
    [97] = 10692629,
    [98] = 11805606,
    [99] = 13034431,
	}
    -- Add other levels as needed...

-- Transparency levels and initial index
local transparencyLevels = {1, 0.75, 0.5, 0.25}
local transparencyIndex = 1

-- Initialize saved variables
-- Initialize saved variables
WORS_U_MicroMenuSettings = WORS_U_MicroMenuSettings or {
    transparency = 1,  -- Default transparency value
	AutoCloseEnabled = true,
}

-- Function to save transparency on change or logout
local function SaveTransparency()
    WORS_U_MicroMenuSettings.transparency = transparencyLevels[currentTransparencyIndex]
    print("Transparency saved:", WORS_U_MicroMenuSettings.transparency)  -- Debug output
end

-- Function to load transparency from saved variables
local function LoadTransparency()
    local savedAlpha = WORS_U_MicroMenuSettings.transparency
    WORS_U_PrayBook.frame:SetAlpha(savedAlpha)  -- Load the transparency value
    print("Transparency loaded:", savedAlpha)  -- Debug output
end

local function GetLevelFromFactionReputation(factionID)
    local _, _, _, _, _, repValue = GetFactionInfoByID(factionID)
    if not repValue then
        print("Faction ID", factionID, "not found.")
        return 1
    end

    local adjustedXP = repValue - 43000
    for level = #experienceTable, 1, -1 do
        if adjustedXP >= experienceTable[level] then
            return level
        end
    end
    return 1
end

local factionID = 1170
local prayerLevel = 1
local prayerButtons = {}  -- Table to hold button references for clearing/re-creation

local function InitializePrayerLevel()
    prayerLevel = GetLevelFromFactionReputation(factionID)
    print("Prayer Level:", prayerLevel)
end

local function SetupPrayerButtons()
    for _, button in pairs(prayerButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    wipe(prayerButtons)
    local buttonSize = 35
    local outerPadding = 3
    local buttonSpacing = 2
    local columns = 5
    for i, prayerData in ipairs(WORS_U_PrayBook.prayers) do
        local prayerID = prayerData.id
        local requiredLevel = prayerData.level
        local prayerName, _, prayerIcon = GetSpellInfo(prayerID)

        local prayerButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame, "SecureActionButtonTemplate")
        prayerButton:SetSize(buttonSize, buttonSize)
        local row = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        prayerButton:SetPoint("TOPLEFT", outerPadding + (buttonSize + buttonSpacing) * column, -outerPadding - (buttonSize + buttonSpacing) * row)

        local icon = prayerButton:CreateTexture(nil, "BACKGROUND")
        icon:SetAllPoints()
        icon:SetTexture(prayerIcon)

        if prayerLevel < requiredLevel then
            icon:SetDesaturated(true)
            prayerButton:SetAlpha(0.5)
        else
            icon:SetDesaturated(false)
            prayerButton:SetAlpha(1)
        end

        prayerButton:SetScript("PreClick", function(self)
            if UnitBuff("player", prayerName) then
                self:SetAttribute("type", "macro")
                self:SetAttribute("macrotext", "/cancelaura " .. prayerName)
            else
                self:SetAttribute("type", "spell")
                self:SetAttribute("spell", prayerID)
            end
        end)

        prayerButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(prayerButton, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(prayerID)
            GameTooltip:Show()
        end)
        prayerButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        prayerButton:SetScript("OnUpdate", function(self)
            if UnitBuff("player", prayerName) then
                icon:SetTexture(prayerData.buffIcon)
            else
                icon:SetTexture(prayerIcon)
            end
        end)

        table.insert(prayerButtons, prayerButton)
    end
	
	-- Load the saved variable transparency value when the frame is created
	LoadTransparency()
end

-- Create the prayer book frame
WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent)
WORS_U_PrayBook.frame:SetSize(190, 260)
WORS_U_PrayBook.frame:SetPoint("CENTER")
WORS_U_PrayBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground2",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 6, top = 6, bottom = 5 }
})
WORS_U_PrayBook.frame:Hide()
WORS_U_PrayBook.frame:SetMovable(true)
WORS_U_PrayBook.frame:EnableMouse(true)
WORS_U_PrayBook.frame:RegisterForDrag("LeftButton")
WORS_U_PrayBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_PrayBook.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)





-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_PrayBook.frame:IsShown() then
        --WORS_U_PrayBook.toggleButton:SetBackdropColor(1, 0, 0, 1)  -- Red background when open
		PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- Set the color to red	
	else
        --WORS_U_PrayBook.toggleButton:SetBackdropColor(1, 1, 1, 1)  -- Default white background when closed
		PrayerMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Default	
	end
end

-- Function to handle PrayerMicroButton clicks
local function OnPrayerClick(self)
    if InCombatLockdown() then
        print("Cannot open Prayer Book while in combat. Retrying...")
        -- Wait 1 second and try again
        C_Timer.After(1, function()
            WORS_U_PrayBook.toggleButton:GetScript("OnClick")(self, button) -- Reinvoke the OnClick
        end)
        return
	elseif IsShiftKeyDown() then
        print("Shift key is down. Open normal Spellbook")  -- Debug statement for Shift key
        --AscensionSpellbookFrame:Show()
		ToggleSpellBook(BOOKTYPE_SPELL)
    elseif IsAltKeyDown() then
        -- Cycle through transparency levels
        WORS_U_PrayBook.frame:Show()
        transparencyIndex = transparencyIndex % #transparencyLevels + 1
        local alpha = transparencyLevels[transparencyIndex]
        WORS_U_PrayBook.frame:SetAlpha(alpha)
        SaveTransparency()  -- Save transparency after change
        print("Prayer Book Transparency set to:", alpha * 100 .. "%")  -- Debug output
    else
        -- Regular toggle functionality
        if WORS_U_PrayBook.frame:IsShown() then
            WORS_U_PrayBook.frame:Hide()
        else
            InitializePrayerLevel()
            SetupPrayerButtons()
			
            MicroMenu_ToggleFrame(WORS_U_PrayBook.frame)--:Show()
        end
    end
	UpdateButtonBackground()
end

PrayerMicroButton:SetScript("OnClick", OnPrayerClick)




SLASH_WORSUPRAYBOOK1 = "/worsupraybook"
SlashCmdList["WORSUPRAYBOOK"] = function()
    if WORS_U_PrayBook.frame:IsShown() then
        WORS_U_PrayBook.frame:Hide()
    else
        InitializePrayerLevel()
        SetupPrayerButtons()
        WORS_U_PrayBook.frame:Show()
    end
end


-- **********************************************************************
-- **********************************************************************
-- ************************OLD CODE FOR TOGGLE BUTTON *******************
-- **********************************************************************
-- **********************************************************************




-- -- Movable button to toggle prayer book
-- local function SaveButtonPosition()
    -- WORS_U_PrayBookButtonPosition = { WORS_U_PrayBook.toggleButton:GetPoint() }
-- end

-- WORS_U_PrayBook.toggleButton = CreateFrame("Button", "WORS_U_PrayBookToggleButton", UIParent)
-- WORS_U_PrayBook.toggleButton:SetSize(30, 35)
-- WORS_U_PrayBook.toggleButton:SetMovable(true)
-- WORS_U_PrayBook.toggleButton:SetClampedToScreen(true)
-- WORS_U_PrayBook.toggleButton:EnableMouse(true)
-- WORS_U_PrayBook.toggleButton:RegisterForDrag("LeftButton")
-- WORS_U_PrayBook.toggleButton:SetScript("OnDragStart", function(self) self:StartMoving() end)
-- WORS_U_PrayBook.toggleButton:SetScript("OnDragStop", function(self)
    -- self:StopMovingOrSizing()
    -- SaveButtonPosition()
-- end)

-- -- Custom background texture
-- local bg = WORS_U_PrayBook.toggleButton:CreateTexture(nil, "BACKGROUND")
-- WORS_U_PrayBook.toggleButton:SetBackdrop({
    -- bgFile = "Interface\\WORS\\OldSchoolBackground2",          -- Background texture
    -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",      -- Border texture
    -- tile = false, tileSize = 32, edgeSize = 16,                 -- Adjust edgeSize as needed for your border
    -- insets = { left = 1, right = 1, top = 1, bottom = 1 }       -- Adjust insets to control border thickness
-- })

-- -- Icon texture instead of text
-- local icon = WORS_U_PrayBook.toggleButton:CreateTexture(nil, "ARTWORK")
-- icon:SetSize(25, 25)
-- icon:SetPoint("CENTER")
-- icon:SetTexture("Interface\\Icons\\prayer.blp")


-- -- OnClick to toggle the prayer book and update transparency when Alt is held
-- WORS_U_PrayBook.toggleButton:SetScript("OnClick", function(self, button)
    -- if InCombatLockdown() then
        -- print("Cannot open Prayer Book while in combat. Retrying...")
        -- -- Wait 1 second and try again
        -- C_Timer.After(1, function()
            -- WORS_U_PrayBook.toggleButton:GetScript("OnClick")(self, button) -- Reinvoke the OnClick
        -- end)
        -- return
    -- end
    -- if IsAltKeyDown() then
        -- -- Cycle through transparency levels
        -- WORS_U_PrayBook.frame:Show()
        -- transparencyIndex = transparencyIndex % #transparencyLevels + 1
        -- local alpha = transparencyLevels[transparencyIndex]
        -- WORS_U_PrayBook.frame:SetAlpha(alpha)
        -- SaveTransparency()  -- Save transparency after change
        -- print("Prayer Book Transparency set to:", alpha * 100 .. "%")  -- Debug output
    -- else
        -- -- Regular toggle functionality
        -- if WORS_U_PrayBook.frame:IsShown() then
            -- WORS_U_PrayBook.frame:Hide()
        -- else
            -- InitializePrayerLevel()
            -- SetupPrayerButtons()
            -- WORS_U_PrayBook.frame:Show()
        -- end
    -- end
	-- UpdateButtonBackground()
-- end)

-- -- Initial highlight update
-- --PrayerMicroButton:Hide()
-- UpdateButtonBackground()
-- WORS_U_PrayBook.toggleButton:SetPoint(unpack(WORS_U_PrayBookButtonPosition or {"CENTER"}))
