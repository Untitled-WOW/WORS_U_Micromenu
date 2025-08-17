-- Initialize MicroMenu saved variables
WORS_U_MicroMenuSettings = WORS_U_MicroMenuSettings or {
    transparency = 1,  -- Default transparency value
	AutoCloseEnabled = true,
}

local function GetMicroMenuFrames()
    return { _G["WORS_U_SpellBookFrame"], _G["WORS_U_PrayBookFrame"], _G["WORS_U_EmoteBookFrame"], _G["WORS_U_EquipmentBookFrame"], _G["CombatStylePanel"] }
end


WORS_U_SpellBook = {}
WORS_U_SpellBook.frame = CreateFrame("Frame", "WORS_U_SpellBookFrame", UIParent, "SecureHandlerStateTemplate,OldSchoolFrameTemplate")

WORS_U_SpellBook.spells = {
    {level = 0, name = "Lumbridge Home Teleport", id = 99561},
    {level = 1, name = "Wind Strike", id = 98952, runes = {["Air Rune"] = 1, ["Mind Rune"] = 1}},
    {level = 3, name = "Confuse", id = 99311, runes = {["Body Rune"] = 1, ["Earth Rune"] = 2, ["Water Rune"] = 3}},
 -- {level = 4, name = "Enchant Crossbow Bolt (Opal)", id = nil, runes = {["Cosmic Rune"] = 1, ["Fire Rune"] = 1}},
    {level = 5, name = "Water Strike", id = 79535, runes = {["Water Rune"] = 1, ["Mind Rune"] = 1}},
    {level = 7, name = "Lvl-1 Enchant", id = 460022, runes = {["Cosmic Rune"] = 1, ["Water Rune"] = 1}, openInv = true},
 -- {level = 7, name = "Enchant Crossbow Bolt (Sapphire)", id = nil, runes = {["Cosmic Rune"] = 1, ["Water Rune"] = 1}},
    {level = 9, name = "Earth Strike", id = 79540, runes = {["Earth Rune"] = 2, ["Mind Rune"] = 1}},
    {level = 11, name = "Weaken", id = 99312, runes = {["Body Rune"] = 1, ["Earth Rune"] = 3, ["Water Rune"] = 3}},
    {level = 13, name = "Fire Strike", id = 79545, runes = {["Fire Rune"] = 3, ["Mind Rune"] = 1}},
 -- {level = 14, name = "Enchant Crossbow Bolt (Jade)", id = nil, runes = {["Cosmic Rune"] = 1, ["Fire Rune"] = 1}},
    {level = 15, name = "Bones to Bananas", id = 99313, runes = {["Nature Rune"] = 1, ["Earth Rune"] = 2, ["Water Rune"] = 2, ["Bones"] = 1}, openInv = true},
    {level = 17, name = "Wind Bolt", id = 79531, runes = {["Air Rune"] = 2, ["Chaos Rune"] = 1}},
    {level = 19, name = "Curse", id = 99314, runes = {["Body Rune"] = 2, ["Earth Rune"] = 3, ["Water Rune"] = 3}},
    {level = 20, name = "Bind", id = 99316, runes = {["Nature Rune"] = 2, ["Earth Rune"] = 3, ["Water Rune"] = 3}},
    {level = 21, name = "Low Level Alchemy", id = 114135, runes = {["Nature Rune"] = 1, ["Fire Rune"] = 3}, openInv = true},
    {level = 23, name = "Water Bolt", id = 79536, runes = {["Water Rune"] = 2, ["Chaos Rune"] = 1}},
 -- {level = 24, name = "Enchant Crossbow Bolt (Pearl)", id = nil, runes = {["Cosmic Rune"] = 1, ["Water Rune"] = 1}},
    {level = 25, name = "Varrock Teleport", id = 114193, runes = {["Law Rune"] = 1, ["Fire Rune"] = 1, ["Air Rune"] = 3}},
    {level = 27, name = "Lvl-2 Enchant", id = 460023, runes = {["Cosmic Rune"] = 1, ["Earth Rune"] = 1}, openInv = true},
 -- {level = 27, name = "Enchant Crossbow Bolt (Emerald)", id = nil, runes = {["Cosmic Rune"] = 1, ["Earth Rune"] = 1}},
    {level = 29, name = "Earth Bolt", id = 79541, runes = {["Earth Rune"] = 2, ["Chaos Rune"] = 1}},
 -- {level = 29, name = "Enchant Crossbow Bolt (Red Topaz)", id = nil, runes = {["Cosmic Rune"] = 1, ["Fire Rune"] = 1}},
    {level = 31, name = "Lumbridge Teleport", id = 114196, runes = {["Law Rune"] = 1, ["Earth Rune"] = 1, ["Air Rune"] = 3}},
    {level = 33, name = "Telekinetic Grab (Corpse)", id = 114134, runes = {["Law Rune"] = 1, ["Air Rune"] = 1}},
    {level = 33, name = "Telekinetic Grab (Gameobject)", id = 1812, runes = {["Law Rune"] = 1, ["Air Rune"] = 1}},
    {level = 35, name = "Fire Bolt", id = 79546, runes = {["Fire Rune"] = 3, ["Chaos Rune"] = 1}},
    {level = 37, name = "Falador Teleport", id = 114194, runes = {["Law Rune"] = 1, ["Water Rune"] = 1, ["Air Rune"] = 3}},
    {level = 39, name = "Crumble Undead", id = 99317, runes = {["Earth Rune"] = 2, ["Air Rune"] = 2, ["Chaos Rune"] = 1}},
 -- {level = 40, name = "Teleport to House", id = nil, runes = {["Law Rune"] = 1, ["Earth Rune"] = 1, ["Air Rune"] = 1}},
    {level = 41, name = "Wind Blast", id = 79532, runes = {["Air Rune"] = 3, ["Death Rune"] = 1}},
    {level = 43, name = "Superheat Item", id = 99318, runes = {["Fire Rune"] = 4, ["Nature Rune"] = 1}, openInv = true},
    {level = 45, name = "Camelot Teleport", id = 114197, runes = {["Law Rune"] = 1, ["Air Rune"] = 5}},
    {level = 47, name = "Water Blast", id = 79537, runes = {["Water Rune"] = 3, ["Death Rune"] = 1}},
 -- {level = 48, name = "Kourend Castle Teleport", id = nil, runes = {["Law Rune"] = 2, ["Soul Rune"] = 2}},
    {level = 49, name = "Lvl-3 Enchant", id = 460024, runes = {["Cosmic Rune"] = 1, ["Fire Rune"] = 5}, openInv = true},
 -- {level = 49, name = "Enchant Crossbow Bolt (Ruby)", id = nil, runes = {["Cosmic Rune"] = 1, ["Fire Rune"] = 5}},
 -- {level = 50, name = "Iban Blast", id = nil, runes = {["Fire Rune"] = 5, ["Death Rune"] = 1}},
    {level = 50, name = "Snare", id = 99537, runes = {["Nature Rune"] = 2, ["Earth Rune"] = 4, ["Water Rune"] = 4}},
 -- {level = 50, name = "Magic Dart", id = nil, runes = {["Air Rune"] = 1, ["Death Rune"] = 1}},
    {level = 51, name = "Ardougne Teleport", id = 114198, runes = {["Law Rune"] = 2, ["Water Rune"] = 2}},
    {level = 53, name = "Earth Blast", id = 79542, runes = {["Earth Rune"] = 3, ["Death Rune"] = 1}},
 -- {level = 54, name = "Civitas illa Fortis Teleport", id = nil, runes = {["Law Rune"] = 2, ["Fire Rune"] = 2}},
    {level = 55, name = "High Level Alchemy", id = 200090, runes = {["Nature Rune"] = 1, ["Fire Rune"] = 5}, openInv = true},
    {level = 56, name = "Charge Water Orb", id = 99233, runes = {["Water Rune"] = 30, ["Cosmic Rune"] = 3, ["Unpowered Orb"] = 1}, openInv = true},
    {level = 57, name = "Lvl-4 Enchant", id = 460025, runes = {["Cosmic Rune"] = 1, ["Earth Rune"] = 10}, openInv = true},
 -- {level = 57, name = "Enchant Crossbow Bolt (Diamond)", id = nil, runes = {["Cosmic Rune"] = 1, ["Earth Rune"] = 10}},
    {level = 58, name = "Watchtower Teleport", id = 114200, runes = {["Law Rune"] = 2, ["Earth Rune"] = 2}},
    {level = 59, name = "Fire Blast", id = 79547, runes = {["Fire Rune"] = 4, ["Death Rune"] = 1}},
    {level = 60, name = "Charge Earth Orb", id = 99234, runes = {["Earth Rune"] = 30, ["Cosmic Rune"] = 3, ["Unpowered Orb"] = 1}, openInv = true},
 -- {level = 60, name = "Bones to Peaches", id = nil, runes = {["Nature Rune"] = 2, ["Earth Rune"] = 4, ["Water Rune"] = 4}},
 -- {level = 60, name = "Saradomin Strike", id = nil, runes = {["Fire Rune"] = 2, ["Blood Rune"] = 2}},
 -- {level = 60, name = "Flames of Zamorak", id = nil, runes = {["Fire Rune"] = 2, ["Blood Rune"] = 2}},
 -- {level = 60, name = "Claws of Guthix", id = nil, runes = {["Air Rune"] = 2, ["Blood Rune"] = 2}},
    {level = 61, name = "Trollheim Teleport", id = 114199, runes = {["Law Rune"] = 2, ["Fire Rune"] = 2}},
    {level = 62, name = "Wind Wave", id = 79533, runes = {["Air Rune"] = 5, ["Blood Rune"] = 1}},
    {level = 63, name = "Charge Fire Orb", id = 99235, runes = {["Fire Rune"] = 30, ["Cosmic Rune"] = 3, ["Unpowered Orb"] = 1}, openInv = true},
 -- {level = 64, name = "Ape Atoll Teleport", id = nil, runes = {["Law Rune"] = 2, ["Fire Rune"] = 3}},
    {level = 65, name = "Water Wave", id = 79538, runes = {["Water Rune"] = 7, ["Blood Rune"] = 1, ["Air Rune"] = 5}},
    {level = 66, name = "Charge Air Orb",id = 99236, runes = {["Air Rune"] = 30, ["Cosmic Rune"] = 3, ["Unpowered Orb"] = 1}, openInv = true},     -- Charge Air Orb
 -- {level = 66, name = "Vulnerability", id = nil, runes = {["Body Rune"] = 1, ["Earth Rune"] = 5, ["Water Rune"] = 5}},
    {level = 68, name = "Lvl-5 Enchant", id = 460026, runes = {["Cosmic Rune"] = 1, ["Earth Rune"] = 15}, openInv = true},
 -- {level = 68, name = "Enchant Crossbow Bolt (Dragonstone)", id = nil, runes = {["Cosmic Rune"] = 1, ["Earth Rune"] = 15}},
    {level = 70, name = "Earth Wave", id = 79543, runes = {["Earth Rune"] = 7, ["Blood Rune"] = 1}},
 -- {level = 73, name = "Enfeeble", id = nil, runes = {["Body Rune"] = 1, ["Earth Rune"] = 8, ["Water Rune"] = 8}},
 -- {level = 74, name = "Teleother Lumbridge", id = nil, runes = {["Law Rune"] = 1, ["Soul Rune"] = 1, ["Earth Rune"] = 1}},
    {level = 75, name = "Fire Wave", id = 79548, runes = {["Fire Rune"] = 7, ["Blood Rune"] = 1}},
    {level = 79, name = "Entangle", id = 99315, runes = {["Nature Rune"] = 3, ["Earth Rune"] = 5, ["Water Rune"] = 5}},
 -- {level = 80, name = "Stun", id = nil, runes = {["Body Rune"] = 1, ["Earth Rune"] = 12, ["Water Rune"] = 12}},
    {level = 80, name = "Charge", id = 707049, runes = {["Blood Rune"] = 3, ["Fire Rune"] = 3, ["Air Rune"] = 3}},
 -- {level = 81, name = "Wind Surge", id = 79534, runes = {["Air Rune"] = 7, ["Death Rune"] = 1}},
 -- {level = 82, name = "Teleother Falador", id = nil, runes = {["Law Rune"] = 1, ["Soul Rune"] = 1, ["Water Rune"] = 1}},
 -- {level = 85, name = "Water Surge", id = 79539, runes = {["Water Rune"] = 7, ["Death Rune"] = 1}},
    {level = 85, name = "Tele Block", id = 99542, runes = {["Law Rune"] = 1, ["Chaos Rune"] = 1, ["Death Rune"] = 1}},
 -- {level = 85, name = "Teleport to Target", id = nil, runes = {["Law Rune"] = 2, ["Soul Rune"] = 2}},
 -- {level = 87, name = "Lvl-6 Enchant", id = nil, runes = {["Cosmic Rune"] = 1, ["Soul Rune"] = 20}},
 -- {level = 87, name = "Enchant Crossbow Bolt (Onyx)", id = nil, runes = {["Cosmic Rune"] = 1, ["Soul Rune"] = 20}},
 -- {level = 90, name = "Teleother Camelot", id = nil, runes = {["Law Rune"] = 1, ["Soul Rune"] = 1, ["Fire Rune"] = 1}},
 -- {level = 90, name = "Earth Surge", id = 79544, runes = {["Earth Rune"] = 7, ["Death Rune"] = 1}},
 -- {level = 93, name = "Lvl-7 Enchant", id = nil, runes = {["Cosmic Rune"] = 1, ["Soul Rune"] = 20}},
 -- {level = 95, name = "Fire Surge", id = 79549, runes = {["Fire Rune"] = 10, ["Death Rune"] = 1}},
 -- {level = 102, name = "Wind Surge", id = 79534, runes = {["Air Rune"] = 7, ["Death Rune"] = 1}},
 -- {level = 103, name = "Water Surge", id = 79539, runes = {["Water Rune"] = 7, ["Death Rune"] = 1}},
 -- {level = 104, name = "Earth Surge", id = 79544, runes = {["Earth Rune"] = 7, ["Death Rune"] = 1}},
 -- {level = 105, name = "Fire Surge", id = 79549, runes = {["Fire Rune"] = 10, ["Death Rune"] = 1}},
}
WORS_U_SpellBook.runeInfo = {
    ["Air Rune"]    = { itemID = 90120, staffIDs = {90838, 90404} },
    ["Water Rune"]  = { itemID = 90107, staffIDs = {90837, 90533} },
    ["Earth Rune"]  = { itemID = 90067, staffIDs = {90839, 90433, 51348} },
    ["Fire Rune"]   = { itemID = 90070, staffIDs = {90836, 90439, 51348} },
    ["Mind Rune"]   = { itemID = 90090, staffIDs = {} },
    ["Chaos Rune"]  = { itemID = 90052, staffIDs = {} },
    ["Death Rune"]  = { itemID = 90133, staffIDs = {} },
    ["Blood Rune"]  = { itemID = 90125, staffIDs = {} },
	["Body Rune"]   = { itemID = 90038, staffIDs = {} },
    ["Cosmic Rune"] = { itemID = 90130, staffIDs = {} },
    ["Nature Rune"] = { itemID = 90091, staffIDs = {} },
    ["Law Rune"]    = { itemID = 90139, staffIDs = {} },
    ["Soul Rune"]   = { itemID = 566, staffIDs = {} },
    ["Astral Rune"] = { itemID = 90123, staffIDs = {} },
    ["Wrath Rune"]  = { itemID = 90109, staffIDs = {} },
	
	["Bones"] = { itemID = 90039, staffIDs = {} },
	--["Monkey Bones"] = { itemID = 90109, staffIDs = {} },
	["Big Bones"] = { itemID = 90036, staffIDs = {} },
	["Unpowered Orb"] = { itemID = 69420, staffIDs = {} },
}

function WORS_U_SpellBook:HasRequiredRunes(runeTable)
    if runeTable == nil then
        return true
    end
	
	for runeName, count in pairs(runeTable) do
        local runeData = self.runeInfo[runeName]
        if runeData then
            local hasRune = GetItemCount(runeData.itemID) >= count
            local hasStaff = false

            -- Check main hand and offhand slots
            for _, slot in ipairs({16, 17}) do
                local equippedID = GetInventoryItemID("player", slot)
                if equippedID then
                    for _, staffID in ipairs(runeData.staffIDs) do
                        if equippedID == staffID then
                            hasStaff = true
                            break
                        end
                    end
                end
                if hasStaff then break end
            end

            if not hasRune and not hasStaff then
                return false
            end

        else
			print("|cff00ff00MicroMenu: |r" .. "|cffff0000Error: |r" .. "|cff00ff00Missing rune data for:", runeName,"|r")
            return false
        end
    end
    return true
end



-- WORS_U_PrayBook Data
WORS_U_PrayBook = {}  -- Create the main table for the PrayBook
WORS_U_PrayBook.frame = CreateFrame("Frame", "WORS_U_PrayBookFrame", UIParent, "SecureHandlerStateTemplate,OldSchoolFrameTemplate")

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


-- WORS_U_EmoteBook.lua Data
WORS_U_EmoteBook = {}
WORS_U_EmoteBook.frame = CreateFrame("Frame", "WORS_U_EmoteBookFrame", UIParent, "OldSchoolFrameTemplate")
WORS_U_EmoteBook.emotes = {
    { name = "Yes",   		    	--[[using wow]]	command = "nod",   				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\1_Yes_emote_icon.tga" },
    { name = "No",    		    	--[[using wow]]	command = "no",    				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\2_No_emote_icon.tga" },
    { name = "Bow",   		    	--[[using wow]]	command = "Bow",   				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\3_Bow_emote_icon.tga" },
    { name = "Angry", 		    	--[[using wow]]	command = "angry", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\4_Angry_emote_icon.tga" },
    { name = "Think",		    	--[[using wow]]	command = "think", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\5_Think_emote_icon.tga" },
    { name = "Wave",		    	--[[using wow]]	command = "wave",  				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\6_Wave_emote_icon.tga" },
    { name = "Shrug",		    	--[[using wow]]	command = "shrug", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\7_Shrug_emote_icon.tga" },
    { name = "Cheer",		    	--[[using wow]]	command = "cheer", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\8_Cheer_emote_icon.tga" },
    { name = "Beckon",		    	--[[using wow]]	command = "beckon",				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\9_Beckon_emote_icon.tga" },
    { name = "Laugh", 		    	--[[using wow]]	command = "laugh", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\10_Laugh_emote_icon.tga" },
    { name = "Joy",        			--[[*_custom*]]	command = "_joy",				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\11_Jump_for_Joy_emote_icon.tga" },
    { name = "Yawn", 		    	--[[using wow]]	command = "Yawn",  				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\12_Yawn_emote_icon.tga" },
    { name = "Dance", 		    	--[[using wow]]	command = "dance", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\13_Dance_emote_icon.tga" },
    { name = "Shake", 		    	--[[using wow]]	command = "shake", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\14_Jig_emote_icon.tga" },
    { name = "Tease", 		    	--[[using wow]]	command = "tease", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\15_Spin_emote_icon.tga" },
    { name = "Bonk",  		    	--[[using wow]]	command = "Bonk",  				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\16_Headbang_emote_icon.tga" },
    { name = "Cry",   		    	--[[using wow]]	command = "cry",   				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\17_Cry_emote_icon.tga" },
    { name = "Blow",  		    	--[[using wow]]	command = "kiss",  				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\18_Blow_Kiss_emote_icon.tga" },
    { name = "Panic", 		    	--[[using wow]]	command = "panic", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\19_Panic_emote_icon.tga" },
    { name = "Fart",  		    	--[[using wow]]	command = "fart", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\20_Raspberry_emote_icon.tga" },
    { name = "Clap",  		    	--[[using wow]]	command = "clap",  				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\21_Clap_emote_icon.tga" },
    { name = "Salute",		    	--[[using wow]]	command = "salute",				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\22_Salute_emote_icon.tga" },
	{ name = "Goblin Bow", 			--[[*_custom*]]	command = "_goblinbow", 		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\23_Goblin_Bow_emote_icon.tga" },
    { name = "Goblin Salute",		--[[*_custom*]]	command = "_goblinsalute", 		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\24_Goblin_Salute_emote_icon.tga" },
	{ name = "Glass Box",  			--[[*_custom*]]	command = "_glassbox", 			icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\25_Glass_Box_emote_icon.tga" },
    { name = "Climb Rope",							command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\26_Climb_Rope_emote_icon.tga" },
    { name = "Lean",	   			--[[*_custom*]]	command = "_lean", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\27_Lean_emote_icon.tga" },
    { name = "Glass Wall",							command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\28_Glass_Wall_emote_icon.tga" },
	{ name = "Idea",								command = "",					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\29_Idea_emote_icon.tga" },
    { name = "Stamp",								command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\30_Stamp_emote_icon.tga" },
    { name = "Flap",	    		--[[*_custom*]]	command = "_flap", 			 	icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\31_Flap_emote_icon.tga" },
    { name = "Slap Head",    		--[[*_custom*]]	command = "_slaphead",			icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\32_Slap_Head_emote_icon.tga" },
	{ name = "Zombie Walk",  		--[[*_custom*]]	command = "_zombiewalk", 		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\33_Zombie_Walk_emote_icon.tga" },
    { name = "Zombie Dance",		--[[*_custom*]]	command = "_zombiedance", 		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\34_Zombie_Dance_emote_icon.tga" },
    { name = "Scared",				--[[using wow]]	command = "scared",				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\35_Scared_emote_icon.tga" },
    { name = "Rabbit Hop", 			--[[*_custom]] 	command = "_rabbithop",			icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\36_Rabbit_Hop_emote_icon.tga" },
    { name = "Sit Up",								command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\37_Sit_up_emote_icon.tga" },
    { name = "Push Up",				--[[*_custom*]]	command = "_pushup", 			icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\38_Push_up_emote_icon.tga" },
    { name = "Star Jump",			--[[*_custom*]]	command = "_starjump", 			icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\39_Star_jump_emote_icon.tga" },
    { name = "Jog",									command = "",					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\40_Jog_emote_icon.tga" },
    { name = "Flex",            	--[[using wow]] command = "flex", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\41_Flex_emote_icon.tga" },
    { name = "Zombie Hand",			--[[*_custom*]]	command = "_zombiehand", 		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\42_Zombie_Hand_emote_icon.tga" },
    { name = "Hypermobile Drinker",	--[[*_custom*]]	command = "_hypermobiledrinker",icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\43_Hypermobile_Drinker_emote_icon.tga" },
    { name = "Skill Cape",  						command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\44_Skill_Cape_emote_icon.tga" },
    { name = "Air Guitar",  		--[[*_custom*]]	command = "_airguitar", 		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\45_Air_Guitar_emote_icon.tga" },
    { name = "Uri Transform",     					command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\46_Uri_transform_emote_icon.tga" },
    { name = "Smooth Dance", 		--[[*_custom*]]	command = "_smoothdance",		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\47_Smooth_dance_emote_icon.tga" },
    { name = "Crazy Dance",  		--[[*_custom*]]	command = "_crazydance",		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\48_Crazy_dance_emote_icon.tga" },
    { name = "Premier Shield", 		--[[*_custom*]]	command = "_premiershield", 	icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\49_Premier_Shield_emote_icon.tga" },
    { name = "Explore",         	  				command = "",					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\50_Explore_emote_icon.tga" },
    { name = "Relic Unlock",    	  				command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\51_Relic_unlock_emote_icon.tga" },
    { name = "Party",           	  				command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\52_Party_emote_icon.tga" },
    { name = "Trick",           	  				command = "", 					icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\53_Trick_emote_icon.tga" },
    { name = "Fortis Salute",		--[[*_custom*]]	command = "_fortissalute", 		icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\54_Fortis_Salute_emote_icon.tga" },
    { name = "Sit Down",  			--[[using wow]]	command = "sit", 				icon = "Interface\\AddOns\\MicroMenu\\Textures\\EmoteIcon\\55_Sit_down_emote_icon.tga" },
}

WORS_U_EquipmentBook = {}

WORS_U_EquipmentBook.frame = CreateFrame("Frame", "WORS_U_EquipmentBookFrame", UIParent, "SecureHandlerStateTemplate,OldSchoolFrameTemplate")



function ResetMicroMenuPOSByAspect(frame)
    local res = GetCVar("gxResolution") 
    local w, h = res:match("(%d+)x(%d+)")
    w, h = tonumber(w), tonumber(h)
    if not (w and h) then return end
    local aspect = w / h
    frame:ClearAllPoints()
    if aspect > 1.5 then -- Widescreen        
        frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 90)
    else -- 4:3 Standard  
		if MultiBarRight:IsShown() then
			frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -95, 155)
		else
			frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -95, 15)
		end
    end
	SaveFramePosition(frame)
end


local reanchorPending = false

local function ApplySavedPosition()
    local pos = WORS_U_MicroMenuSettings and WORS_U_MicroMenuSettings.MicroMenuPOS
    if not pos then return end
    if InCombatLockdown() then
        reanchorPending = true
        return
    end

    local reference = (_G[pos.relativeTo] or UIParent)
    local bpOffsets = {
        RIGHT={0,0}, TOPRIGHT={0,0}, BOTTOMRIGHT={0,0},
        LEFT={0,0},  TOPLEFT={0,0},  BOTTOMLEFT={0,0},
        CENTER={0,0}, TOP={0,0}, BOTTOM={0,0},
    }

    for _, frame in ipairs(GetMicroMenuFrames()) do
        if frame then
            frame:ClearAllPoints()
            frame:SetPoint(pos.point, reference, pos.relativePoint, pos.xOfs, pos.yOfs)
            --frame:SetUserPlaced(false)
        end
    end

    if Backpack then
        local bpX, bpY = unpack(bpOffsets[pos.relativePoint] or {0,0})
        Backpack:ClearAllPoints()
        Backpack:SetPoint(pos.point, reference, pos.relativePoint, pos.xOfs + bpX, pos.yOfs + bpY)
        --Backpack:SetUserPlaced(false)
    end
end

function SaveFramePosition(self)
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    local relName = (relativeTo and relativeTo:GetName()) or "UIParent"

    WORS_U_MicroMenuSettings.MicroMenuPOS = {
        point = point, relativeTo = relName, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs
    }

    if InCombatLockdown() then
        reanchorPending = true
        return
    end

    ApplySavedPosition()
end

local reanchorWatcher = CreateFrame("Frame")
reanchorWatcher:RegisterEvent("PLAYER_REGEN_ENABLED")
reanchorWatcher:SetScript("OnEvent", function()
    if reanchorPending then
        reanchorPending = false
        ApplySavedPosition()
    end
end)



