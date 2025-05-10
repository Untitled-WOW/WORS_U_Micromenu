-- Initialize MicroMenu saved variables
WORS_U_MicroMenuSettings = WORS_U_MicroMenuSettings or {
    transparency = 1,  -- Default transparency value
	AutoCloseEnabled = true,
	MicroMenuPOS = { point = "CENTER", relativeTo = nil, relativePoint = "CENTER", xOfs = 0, yOfs = 0 }
}

-- WORS_U_SpellBook Data
WORS_U_SpellBook = {}
WORS_U_SpellBook.spells = {
    {level = 0, id = 99561},  -- Lumbridge Home Teleport
    {level = 1, id = 98952},  -- Wind Strike
    {level = 3, id = 99311},  -- Confuse
    -- {level = 4, id = nil},     -- Enchant Crossbow Bolt (Opal)
    {level = 5, id = 79535},  -- Water Strike
    {level = 7, id = 460022},     -- Lvl-1 Enchant
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
    {level = 27, id = 460023},     -- Lvl-2 Enchant
    -- {level = 27, id = nil},     -- Enchant Crossbow Bolt (Emerald)
    {level = 29, id = 79541},  -- Earth Bolt
    -- {level = 29, id = nil},     -- Enchant Crossbow Bolt (Red Topaz)
    {level = 31, id = 114196}, -- Lumbridge Teleport
    {level = 33, id = 114134},   -- Telekinetic Grab (Corpse)
	{level = 33, id = 1812},     -- Telekinetic Grab (Gameobject)
    {level = 35, id = 79546},  -- Fire Bolt
    {level = 37, id = 114194}, -- Falador Teleport
    {level = 39, id = 99317},  -- Crumble Undead
    -- {level = 40, id = nil},     -- Teleport to House
    {level = 41, id = 79532},  -- Wind Blast
    {level = 43, id = 99318},  -- Superheat Item
    {level = 45, id = 114197},     -- Camelot Teleport
    {level = 47, id = 79537},  -- Water Blast
    -- {level = 48, id = nil},     -- Kourend Castle Teleport
    {level = 49, id = 460024},     -- Lvl-3 Enchant
    -- {level = 49, id = nil},     -- Enchant Crossbow Bolt (Ruby)
    -- {level = 50, id = nil},     -- Iban Blast
    {level = 50, id = 99537},  -- Snare
    -- {level = 50, id = nil},     -- Magic Dart
    {level = 51, id = 114198},     -- Ardougne Teleport
    {level = 53, id = 79542},  -- Earth Blast
    -- {level = 54, id = nil},     -- Civitas illa Fortis Teleport
    {level = 55, id = 200090}, -- High Level Alchemy
    {level = 56, id = 99233},     -- Charge Water Orb
    {level = 57, id = 460025},     -- Lvl-4 Enchant
    -- {level = 57, id = nil},     -- Enchant Crossbow Bolt (Diamond)
    {level = 58, id = 114200},     -- Watchtower Teleport
    {level = 59, id = 79547},  -- Fire Blast
    {level = 60, id = 99234},     -- Charge Earth Orb
    -- {level = 60, id = nil},     -- Bones to Peaches
    -- {level = 60, id = nil},     -- Saradomin Strike
    -- {level = 60, id = nil},     -- Flames of Zamorak
    -- {level = 60, id = nil},     -- Claws of Guthix
    {level = 61, id = 114199},     -- Trollheim Teleport
    {level = 62, id = 79533},  -- Wind Wave
    {level = 63, id = 99235},     -- Charge Fire Orb
    -- {level = 64, id = nil},     -- Ape Atoll Teleport
    {level = 65, id = 79538},  -- Water Wave
    {level = 66, id = 99236},     -- Charge Air Orb
    -- {level = 66, id = nil},     -- Vulnerability
    {level = 68, id = 460026},     -- Lvl-5 Enchant
    -- {level = 68, id = nil},     -- Enchant Crossbow Bolt (Dragonstone)
    {level = 70, id = 79543},  -- Earth Wave
    -- {level = 73, id = nil},     -- Enfeeble
    -- {level = 74, id = nil},     -- Teleother Lumbridge
    {level = 75, id = 79548},  -- Fire Wave
    {level = 79, id = 99315},  -- Entangle
    -- {level = 80, id = nil},     -- Stun
    {level = 80, id = 707049},     -- Charge
    --{level = 81, id = 79534},     -- Wind Surge
    -- {level = 82, id = nil},     -- Teleother Falador
    --{level = 85, id = 79539},  -- Water Surge
    {level = 85, id = 99542},     -- Tele Block
    -- {level = 85, id = nil},     -- Teleport to Target
    -- {level = 87, id = nil},     -- Lvl-6 Enchant
    -- {level = 87, id = nil},     -- Enchant Crossbow Bolt (Onyx)
    -- {level = 90, id = nil},     -- Teleother Camelot
    --{level = 90, id = 79544},     -- Earth Surge
    -- {level = 93, id = nil},     -- Lvl-7 Enchant
    --{level = 95, id = 79549},     -- Fire Surge
}

-- WORS_U_PrayBook Data
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


-- WORS_U_EmoteBook Data
WORS_U_EmoteBook = {}
WORS_U_EmoteBook.emotes = {
    { name = "Yes", command = "nod" },			
    { name = "No", command = "no" },
	{ name = "Bow", command = "Bow" },
    { name = "Angry", command = "angry" }, --OSRS correct
    { name = "Think", command = "think" },
    { name = "Wave", command = "wave" },
	{ name = "Shrug", command = "shrug" },
    { name = "Cheer", command = "cheer" },--OsRS correcthey
    { name = "Beckon", command = "beckon" },	
    { name = "Laugh", command = "laugh" },
    { name = "Joy", command = "Bounce" },
	{ name = "Yawn", command = "Yawn" },--OSRS correct
    { name = "Dance", command = "dance" },
    { name = "Shake", command = "shake" },
	{ name = "Tease", command = "tease" },
	{ name = "Bonk", command = "Bonk" },--OSRS correct
    { name = "Cry", command = "cry" },
	{ name = "Blow", command = "kiss" },
	{ name = "Panic", command = "panic" },
	{ name = "Fart", command = "fart" },
	{ name = "Clap", command = "clap" },
	{ name = "Salute", command = "salute" },
}

-- WORS_U_MusicBook Data
WORS_U_MusicBook = {}
WORS_U_MusicBook.currentTrack = nil
WORS_U_MusicBook.tracks = {
    { name = "Sea Shanty", file = "Sound\\RuneScape\\Sea_Shanty_2.ogg" },
    { name = "Harmony", file = "Sound\\RuneScape\\Harmony.ogg" },
	{ name = "Harmony 2", file = "Sound\\RuneScape\\Harmony_2.ogg" },
	{ name = "Runescape Main", file = "Sound\\RuneScape\\Scape_Main.ogg" },
	{ name = "Runescape Theme", file = "Sound\\RuneScape\\Runescape_Theme.ogg" },
	{ name = "Wilderness", file = "Sound\\RuneScape\\Wilderness.ogg" },
	{ name = "Wilderness 2", file = "Sound\\RuneScape\\Wilderness_2.ogg" },

}

-- Experience Table used to calculate skills level from Reputaion
experienceTable = {
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
-- Function to GetLevelFromFactionReputation
function GetLevelFromFactionReputation(factionID)
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

-- Used to cycle thru transparancy levels on Alt clicking MicroMenuButtons
transparencyLevels = {1, 0.75, 0.5, 0.25}
currentTransparencyIndex = 1

-- Function to save transparency to saved variables
function SaveTransparency()
    WORS_U_MicroMenuSettings.transparency = transparencyLevels[currentTransparencyIndex]
    print("Transparency saved:", WORS_U_MicroMenuSettings.transparency * 100 .. "%")  -- Debug output
end

-- Function to load transparency from saved variables
function LoadTransparency()
    local savedAlpha = WORS_U_MicroMenuSettings.transparency or 1  -- Default to 1 (100%) if not saved
    -- Apply transparency to each frame in the list
	for _, frame in ipairs(MicroMenu_Frames) do
        if frame then
            frame:SetAlpha(savedAlpha)  -- Set transparency for the frame
        end
    end
    print("Transparency loaded:", savedAlpha * 100 .. "%")  -- Debug output
end