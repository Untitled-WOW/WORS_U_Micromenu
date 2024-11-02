local WORS_U_SpellBook = {}
local magicLevel = 0  -- Set the player's current magic level

-- Define custom spells by ID
WORS_U_SpellBook.spells = {
    {level = 0, id = 99561},  -- Lumbridge Home Teleport
    {level = 1, id = 98952},  -- Wind Strike
    {level = 3, id = 99311},  -- Confuse
    -- {level = 4, id = nil},     -- Enchant Crossbow Bolt (Opal)
    {level = 5, id = 79535},  -- Water Strike
    -- {level = 7, id = nil},     -- Lvl-1 Enchant
    -- {level = 7, id = nil},     -- Enchant Crossbow Bolt (Sapphire)
    {level = 9, id = 79540},  -- Earth Strike
    {level = 11, id = 99312},  -- Weaken
    {level = 13, id = 79545},  -- Fire Strike
    -- {level = 14, id = nil},     -- Enchant Crossbow Bolt (Jade)
    {level = 15, id = 99313},  -- Bones to Bananas
    {level = 17, id = 79531},  -- Wind Bolt
    {level = 19, id = 99314},  -- Curse
    {level = 20, id = 99316},  -- Bind
    {level = 21, id = 114135}, -- Low Level Alchemy
    {level = 23, id = 79536},  -- Water Bolt
    -- {level = 24, id = nil},     -- Enchant Crossbow Bolt (Pearl)
    {level = 25, id = 114193}, -- Varrock Teleport
    -- {level = 27, id = nil},     -- Lvl-2 Enchant
    -- {level = 27, id = nil},     -- Enchant Crossbow Bolt (Emerald)
    {level = 29, id = 79541},  -- Earth Bolt
    -- {level = 29, id = nil},     -- Enchant Crossbow Bolt (Red Topaz)
    {level = 31, id = 114196}, -- Lumbridge Teleport
    -- {level = 33, id = nil},     -- Telekinetic Grab
    {level = 35, id = 79546},  -- Fire Bolt
    {level = 37, id = 114194}, -- Falador Teleport
    {level = 39, id = 99317},  -- Crumble Undead
    -- {level = 40, id = nil},     -- Teleport to House
    {level = 41, id = 79532},  -- Wind Blast
    {level = 43, id = 99318},  -- Superheat Item
    -- {level = 45, id = nil},     -- Camelot Teleport
    {level = 47, id = 79537},  -- Water Blast
    -- {level = 48, id = nil},     -- Kourend Castle Teleport
    -- {level = 49, id = nil},     -- Lvl-3 Enchant
    -- {level = 49, id = nil},     -- Enchant Crossbow Bolt (Ruby)
    -- {level = 50, id = nil},     -- Iban Blast
    {level = 50, id = 99537},  -- Snare
    -- {level = 50, id = nil},     -- Magic Dart
    -- {level = 51, id = nil},     -- Ardougne Teleport
    {level = 53, id = 79542},  -- Earth Blast
    -- {level = 54, id = nil},     -- Civitas illa Fortis Teleport
    {level = 55, id = 200090}, -- High Level Alchemy
    -- {level = 56, id = nil},     -- Charge Water Orb
    -- {level = 57, id = nil},     -- Lvl-4 Enchant
    -- {level = 57, id = nil},     -- Enchant Crossbow Bolt (Diamond)
    -- {level = 58, id = nil},     -- Watchtower Teleport
    {level = 59, id = 79547},  -- Fire Blast
    -- {level = 60, id = nil},     -- Charge Earth Orb
    -- {level = 60, id = nil},     -- Bones to Peaches
    -- {level = 60, id = nil},     -- Saradomin Strike
    -- {level = 60, id = nil},     -- Flames of Zamorak
    -- {level = 60, id = nil},     -- Claws of Guthix
    -- {level = 61, id = nil},     -- Trollheim Teleport
    {level = 62, id = 79533},  -- Wind Wave
    -- {level = 63, id = nil},     -- Charge Fire Orb
    -- {level = 64, id = nil},     -- Ape Atoll Teleport
    {level = 65, id = 79538},  -- Water Wave
    -- {level = 66, id = nil},     -- Charge Air Orb
    -- {level = 66, id = nil},     -- Vulnerability
    -- {level = 68, id = nil},     -- Lvl-5 Enchant
    -- {level = 68, id = nil},     -- Enchant Crossbow Bolt (Dragonstone)
    {level = 70, id = 79543},  -- Earth Wave
    -- {level = 73, id = nil},     -- Enfeeble
    -- {level = 74, id = nil},     -- Teleother Lumbridge
    {level = 75, id = 79548},  -- Fire Wave
    {level = 79, id = 99315},  -- Entangle
    -- {level = 80, id = nil},     -- Stun
    -- {level = 80, id = nil},     -- Charge
    --{level = 81, id = 79534},     -- Wind Surge
    -- {level = 82, id = nil},     -- Teleother Falador
    --{level = 85, id = 79539},  -- Water Surge
    -- {level = 85, id = nil},     -- Tele Block
    -- {level = 85, id = nil},     -- Teleport to Target
    -- {level = 87, id = nil},     -- Lvl-6 Enchant
    -- {level = 87, id = nil},     -- Enchant Crossbow Bolt (Onyx)
    -- {level = 90, id = nil},     -- Teleother Camelot
    --{level = 90, id = 79544},     -- Earth Surge
    -- {level = 93, id = nil},     -- Lvl-7 Enchant
    --{level = 95, id = 79549},     -- Fire Surge
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
-- Consolidated function to retrieve reputation and calculate level based on faction ID
-- Function to get level based on reputation value

local factionID = 1169
local magicLevel = 1
local magicButtons = {}

-- OnClick to toggle the spell book and update the button's background
local transparencyLevels = {1, 0.75, 0.5, 0.25}
local currentTransparencyIndex = 1


-- Initialize saved variables for transparency
WORS_U_SpellBookSettings = WORS_U_SpellBookSettings or {
    transparency = 1,  -- Default transparency value
}

-- Function to save transparency on change or logout
local function SaveTransparency()
    WORS_U_SpellBookSettings.transparency = WORS_U_SpellBook.frame:GetAlpha()
    print("Transparency saved:", WORS_U_SpellBookSettings.transparency)  -- Debug output
end

-- Function to load transparency from saved variables
local function LoadTransparency()
    local savedAlpha = WORS_U_SpellBookSettings.transparency
    WORS_U_SpellBook.frame:SetAlpha(savedAlpha)  -- Load the transparency value
    print("Transparency loaded:", savedAlpha)  -- Debug output
end

-- Function to get level based on reputation value
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

-- Function to initialize magic level
local function InitializeMagicLevel()
    magicLevel = GetLevelFromFactionReputation(factionID)
    print("Magic Level:", magicLevel)
end

-- Function to set up magic buttons dynamically
local function SetupMagicButtons()
    -- Clear existing buttons before creating new ones
    for _, button in pairs(magicButtons) do
        button:Hide()
        button:SetParent(nil)
    end
    wipe(magicButtons)

    local buttonSize = 25
    local padding = 10
    local columns = 5

    for i, spellData in ipairs(WORS_U_SpellBook.spells) do
        local spellID = spellData.id
        local requiredLevel = spellData.level
        local spellName, _, spellIcon = GetSpellInfo(spellID)

        local spellButton = CreateFrame("Button", nil, WORS_U_SpellBook.frame, "SecureActionButtonTemplate")
        spellButton:SetSize(buttonSize, buttonSize)

        -- Calculate position
        local row = math.floor((i - 1) / columns)
        local column = (i - 1) % columns
        spellButton:SetPoint("TOPLEFT", padding + (buttonSize + padding) * column, -padding - (buttonSize + padding) * row)

        -- Set up the button icon
        local icon = spellButton:CreateTexture(nil, "BACKGROUND")
        icon:SetAllPoints()
        icon:SetTexture(spellIcon)

        -- Check if player's level meets the spell's required level
        if magicLevel < requiredLevel then
            icon:SetDesaturated(true)
            spellButton:SetAlpha(0.5)
        else
            icon:SetDesaturated(false)
            spellButton:SetAlpha(1)
        end

        -- Set up secure attributes for spell button
        spellButton:SetAttribute("type", "spell")
        spellButton:SetAttribute("spell", spellID)

        -- Tooltip
        spellButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(spellButton, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(spellID)
            GameTooltip:Show()
        end)
        spellButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        -- Allow dragging the spell button to the action bar
        spellButton:RegisterForDrag("LeftButton")
        spellButton:SetScript("OnDragStart", function()
            if not InCombatLockdown() and magicLevel >= requiredLevel then
                PickupSpell(spellID)
            end
        end)

        table.insert(magicButtons, spellButton)
    end

    -- Load the saved variable transparency value when the frame is created
    LoadTransparency()
end

-- Create the main frame for the custom spell book
WORS_U_SpellBook.frame = CreateFrame("Frame", "WORS_U_SpellBookFrame", UIParent)
WORS_U_SpellBook.frame:SetSize(190, 260)
WORS_U_SpellBook.frame:SetPoint("CENTER")
WORS_U_SpellBook.frame:SetBackdrop({
    bgFile = "Interface\\WORS\\OldSchoolBackground2",
    edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    tile = false, tileSize = 32, edgeSize = 32,
    insets = { left = 5, right = 6, top = 6, bottom = 5 }
})

WORS_U_SpellBook.frame:Hide()
WORS_U_SpellBook.frame:SetMovable(true)
WORS_U_SpellBook.frame:EnableMouse(true)
WORS_U_SpellBook.frame:RegisterForDrag("LeftButton")
WORS_U_SpellBook.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
WORS_U_SpellBook.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Save settings on logout
local function OnLogout()
    SaveTransparency()
end

-- Register the logout event
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", OnLogout)



-- Function to update the button's background color
local function UpdateButtonBackground()
    if WORS_U_SpellBook.frame:IsShown() then
        --WORS_U_SpellBook.toggleButton:SetBackdropColor(1, 0, 0, 1)  -- Red background when open
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 0, 0) -- Set the color to red
	else
        --WORS_U_SpellBook.toggleButton:SetBackdropColor(1, 1, 1, 1)  -- Default white background when closed
		SpellbookMicroButton:GetNormalTexture():SetVertexColor(1, 1, 1) -- Set the color to red
	end
end

-- Function to handle MagicMicroButton clicks
local function OnMagicClick(self)
    print("MagicMicroButton has been clicked!")  -- Debug statement
    if InCombatLockdown() then
        print("Cannot open Spell Book during combat.")  -- Debug combat check
        C_Timer.After(1, function()
            print("Re-checking click logic after 1 second.")  -- Debug after delay
            WORS_U_SpellBook.toggleButton:GetScript("OnClick")(self)  -- Re-check the click logic after 1 second
        end)
        return
    end
    if IsAltKeyDown() then
        print("Alt key is down.")  -- Debug statement for Alt key
        -- Cycle through transparency levels
        WORS_U_SpellBook.frame:Show()
        currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        WORS_U_SpellBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
        SaveTransparency()
        print("Spell Book Transparency:", transparencyLevels[currentTransparencyIndex] * 100, "%")
		
    elseif IsShiftKeyDown() then
        print("Shift key is down. Open normal Spellbook")  -- Debug statement for Shift key
        AscensionSpellbookFrame:Show()
    else
        print("Toggling Mini Spell Book visibility.")  -- Debug statement for standard toggle
        -- Standard toggle functionality
        if WORS_U_SpellBook.frame:IsShown() then
            WORS_U_SpellBook.frame:Hide()
            print("Spell Book hidden.")  -- Debug statement for hiding
        else
            InitializeMagicLevel()
            SetupMagicButtons()
            WORS_U_SpellBook.frame:Show()
            print("Spell Book shown.")  -- Debug statement for showing
        end
    end
	UpdateButtonBackground()
end


-- Register the click event for the SpellbookMicroButton
SpellbookMicroButton:SetScript("OnClick", OnMagicClick)


-- Slash command to toggle the custom spell book
SLASH_WORSUSPELLBOOK1 = "/worsuspellbook"
SlashCmdList["WORSUSPELLBOOK"] = function()
    if WORS_U_SpellBook.frame:IsShown() then
        WORS_U_SpellBook.frame:Hide()
    else
        InitializeMagicLevel()  -- Refresh magic level before showing frame
        SetupMagicButtons()      -- Ensure buttons are set up based on current magic level
        WORS_U_SpellBook.frame:Show()
    end
end


-- **********************************************************************
-- **********************************************************************
-- ************************OLD CODE FOR TOGGLE BUTTON *******************
-- **********************************************************************
-- **********************************************************************


-- -- Movable button to toggle spell book
-- local function SaveButtonPosition()
    -- WORS_U_SpellBookButtonPosition = { WORS_U_SpellBook.toggleButton:GetPoint() }
-- end

-- WORS_U_SpellBook.toggleButton = CreateFrame("Button", "WORS_U_SpellBookToggleButton", UIParent)
-- WORS_U_SpellBook.toggleButton:SetSize(30, 35)
-- WORS_U_SpellBook.toggleButton:SetMovable(true)
-- WORS_U_SpellBook.toggleButton:SetClampedToScreen(true)
-- WORS_U_SpellBook.toggleButton:EnableMouse(true)
-- WORS_U_SpellBook.toggleButton:RegisterForDrag("LeftButton")
-- WORS_U_SpellBook.toggleButton:SetScript("OnDragStart", function(self) self:StartMoving() end)
-- WORS_U_SpellBook.toggleButton:SetScript("OnDragStop", function(self)
    -- self:StopMovingOrSizing()
    -- SaveButtonPosition()
-- end)

-- -- Custom background texture for the toggle button
-- local bg = WORS_U_SpellBook.toggleButton:CreateTexture(nil, "BACKGROUND")
-- WORS_U_SpellBook.toggleButton:SetBackdrop({
    -- bgFile = "Interface\\WORS\\OldSchoolBackground2",
    -- edgeFile = "Interface\\WORS\\OldSchool-Dialog-Border",
    -- tile = false, tileSize = 32, edgeSize = 16,
    -- insets = { left = 1, right = 1, top = 1, bottom = 1 }
-- })

-- -- Icon texture for the toggle button
-- local icon = WORS_U_SpellBook.toggleButton:CreateTexture(nil, "ARTWORK")
-- icon:SetSize(25, 25)
-- icon:SetPoint("CENTER")
-- icon:SetTexture("Interface\\Icons\\magicicon")  -- Replace with your spell icon


-- WORS_U_SpellBook.toggleButton:SetScript("OnClick", function(self)
    -- if InCombatLockdown() then
        -- print("Cannot open Spell Book during combat. Will check again in 1 second.")
        -- C_Timer.After(1, function()
            -- WORS_U_SpellBook.toggleButton:GetScript("OnClick")(self)  -- Re-check the click logic after 1 second
        -- end)
        -- return
    -- end
    -- if IsAltKeyDown() then
        -- -- Cycle through transparency levels
        -- WORS_U_SpellBook.frame:Show()
        -- currentTransparencyIndex = currentTransparencyIndex % #transparencyLevels + 1
        -- WORS_U_SpellBook.frame:SetAlpha(transparencyLevels[currentTransparencyIndex])
        -- SaveTransparency()  -- Save transparency after change
        -- print("Spell Book Transparency:", transparencyLevels[currentTransparencyIndex] * 100, "%")
    -- else
        -- -- Standard toggle functionality
        -- if WORS_U_SpellBook.frame:IsShown() then
            -- WORS_U_SpellBook.frame:Hide()
        -- else
            -- InitializeMagicLevel()  -- Refresh magic level before showing frame
            -- SetupMagicButtons()      -- Ensure buttons are set up based on current magic level
            -- WORS_U_SpellBook.frame:Show()
        -- end
        -- UpdateButtonBackground()
    -- end
-- end)

-- -- Initial highlight update
-- --SpellbookMicroButton:Hide()
-- UpdateButtonBackground()
-- WORS_U_SpellBook.toggleButton:SetPoint(unpack(WORS_U_SpellBookButtonPosition or {"CENTER"}))
