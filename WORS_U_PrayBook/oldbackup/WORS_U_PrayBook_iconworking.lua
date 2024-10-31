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
    -- {level = 19, id = nil, buffIcon = nil},    -- Rapid Restore
    {level = 22, id = 79521, buffIcon = "Interface\\Icons\\active_rapidheal.blp"},    -- Rapid Heal
    -- {level = 25, id = nil},    -- Protect Item
    -- {level = 26, id = nil},    -- Hawk Eye
    -- {level = 27, id = nil},    -- Mystic Lore
    -- {level = 28, id = nil},    -- Steel Skin
    -- {level = 31, id = nil},    -- Ultimate Strength
    -- {level = 34, id = nil},    -- Incredible Reflexes
    -- {level = 37, id = nil},    -- Protect from Magic
    -- {level = 40, id = nil},    -- Protect from Missiles
    -- {level = 43, id = nil},    -- Protect from Melee
    -- {level = 44, id = nil},    -- Eagle Eye
    -- {level = 45, id = nil},    -- Mystic Might
    -- {level = 46, id = nil},    -- Retribution
    -- {level = 49, id = nil},    -- Redemption
    -- {level = 52, id = nil},    -- Smite
    -- {level = 55, id = nil},    -- Preserve
    -- {level = 60, id = nil},    -- Chivalry
    -- {level = 70, id = nil},    -- Piety
    -- {level = 74, id = nil},    -- Rigour
    -- {level = 77, id = nil},    -- Augury
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


-- Function to get level based on reputation value
-- Function to get level based on reputation value
local function GetLevelFromReputation(repValue)
    local adjustedXP = repValue - 43000
    for level = #experienceTable, 1, -1 do
        if adjustedXP >= experienceTable[level] then
            return level
        end
    end
    return 1
end

-- Usage example with faction ID 1170
local factionID = 1170
local _, _, _, _, _, repValue = GetFactionInfoByID(factionID)
local magicLevel = 1  -- Default magic level

if repValue then
    magicLevel = GetLevelFromReputation(repValue)
    print("Reputation:", repValue, "Level:", magicLevel)
else
    print("Faction ID", factionID, "not found.")
end

-- Create the main frame for the custom prayer book
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

-- Create each prayer button with dynamic icon, tooltip, and functionality
-- Create each prayer button with dynamic icon, tooltip, and functionality
local buttonSize = 35
local outerPadding = 3  -- Padding from the frame edges
local buttonSpacing = 2  -- Space between buttons
local columns = 5

for i, prayerData in ipairs(WORS_U_PrayBook.prayers) do
    local prayerID = prayerData.id
    local requiredLevel = prayerData.level
    local prayerName, _, prayerIcon = GetSpellInfo(prayerID)

    -- Create the prayer button
    local prayerButton = CreateFrame("Button", nil, WORS_U_PrayBook.frame, "SecureActionButtonTemplate")
    prayerButton:SetSize(buttonSize, buttonSize)

    -- Calculate position with outer padding and button spacing
    local row = math.floor((i - 1) / columns)
    local column = (i - 1) % columns
    prayerButton:SetPoint("TOPLEFT", outerPadding + (buttonSize + buttonSpacing) * column, -outerPadding - (buttonSize + buttonSpacing) * row)

    -- Set up the button icon
    local icon = prayerButton:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints()
    icon:SetTexture(prayerIcon)

    -- Check if player's level meets the prayer's required level
    if magicLevel < requiredLevel then
        icon:SetDesaturated(true)  -- Gray out the icon
        prayerButton:SetAlpha(0.5)  -- Reduce transparency
    else
        icon:SetDesaturated(false)
        prayerButton:SetAlpha(1)
    end

    -- Set up secure attributes for prayer button
    prayerButton:SetAttribute("type", "spell")
    prayerButton:SetAttribute("spell", prayerID)

    -- Tooltip
    prayerButton:SetScript("OnEnter", function()
        GameTooltip:SetOwner(prayerButton, "ANCHOR_RIGHT")
        GameTooltip:SetSpellByID(prayerID)
        GameTooltip:Show()
    end)
    prayerButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Allow dragging the prayer button to the action bar
    prayerButton:RegisterForDrag("LeftButton")
    prayerButton:SetScript("OnDragStart", function()
        if not InCombatLockdown() and magicLevel >= requiredLevel then
            PickupSpell(prayerID)
        end
    end)

    -- Update icon based on active buff
    prayerButton:SetScript("OnUpdate", function(self)
        if UnitBuff("player", prayerName) then
            icon:SetTexture(prayerData.buffIcon)  -- Use buff icon if the prayer is active
        else
            icon:SetTexture(prayerIcon)  -- Use default prayer icon
        end
    end)
end


-- Slash command to toggle the custom prayer book
SLASH_WORSUPRAYBOOK1 = "/worsupraybook"
SlashCmdList["WORSUPRAYBOOK"] = function()
    if WORS_U_PrayBook.frame:IsShown() then
        WORS_U_PrayBook.frame:Hide()
    else
        WORS_U_PrayBook.frame:Show()
    end
end