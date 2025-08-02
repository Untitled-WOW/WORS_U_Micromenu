-- Initialize MicroMenu saved variables
WORS_U_MicroMenuSettings = WORS_U_MicroMenuSettings or {}
WORS_U_MicroMenuSettings.MicroMenuPOS = WORS_U_MicroMenuSettings.MicroMenuPOS or {point = "CENTER", relativeTo = nil, relativePoint = "CENTER", xOfs = 0, yOfs = 0}

-- All MicroMenu frames and CombatStylePanel
MicroMenu_Frames = {WORS_U_SpellBookFrame, WORS_U_PrayBookFrame, WORS_U_EmoteBookFrame, WORS_U_MusicPlayerFrame, WORS_U_EquipmentBookFrame, CombatStylePanel}


-- WORS_U_SpellBook.lua Data
WORS_U_SpellBook = {}
WORS_U_SpellBook.spells = {
    {level = 0,  name = "Lumbridge Home Teleport",     		id = 99561,		icon = "Interface\\Icons\\hometele.blp"},
    {level = 1,  name = "Wind Strike",                 		id = 98952,		icon = "Interface\\Icons\\windstrike.blp"},
    {level = 3,  name = "Confuse",                     		id = 99311,		icon = "Interface\\Icons\\confuseicon.blp"},
 -- {level = 4,  name = "Enchant Crossbow Bolt (Opal)",		id = nil,		icon = "Interface\\Icons\\enchantcrossbow.blp"},
    {level = 5,  name = "Water Strike",                		id = 79535,		icon = "Interface\\Icons\\waterstrike.blp"},
    {level = 7,  name = "Lvl-1 Enchant",               		id = 460022,	icon = "Interface\\Icons\\sapphireenchanting.blp", 		openInv=true,},
 -- {level = 7,  name = "Enchant Crossbow Bolt (Sapphire)", id = nil,		icon = "Interface\\Icons\\enchantcrossbow.blp"},	
    {level = 9,  name = "Earth Strike",                		id = 79540,		icon = "Interface\\Icons\\earthstrike.blp"},	
    {level = 11, name = "Weaken",                      		id = 99312,		icon = "Interface\\Icons\\weakenicon.blp"},	
    {level = 13, name = "Fire Strike",                 		id = 79545,		icon = "Interface\\Icons\\firestrike.blp"},	
 -- {level = 14, name = "Enchant Crossbow Bolt (Jade)",		id = nil,		icon = "Interface\\Icons\\enchantdragonstone.blp"},	
    {level = 15, name = "Bones to Bananas",            		id = 99313,		icon = "Interface\\Icons\\bonestobananas.blp", 			openInv=true,},
    {level = 17, name = "Wind Bolt",                   		id = 79531,		icon = "Interface\\Icons\\windbolt.blp"},	
    {level = 19, name = "Curse",                       		id = 99314,  	icon = "Interface\\Icons\\curseicon.blp"},	
    {level = 20, name = "Bind",                        		id = 99316,  	icon = "Interface\\Icons\\bindicon.blp"},	
    {level = 21, name = "Low Level Alchemy",           		id = 114135, 	icon = "Interface\\Icons\\lowalch.blp", 				openInv=true,},
    {level = 23, name = "Water Bolt",                  		id = 79536,  	icon = "Interface\\Icons\\waterbolt.blp"},	
 -- {level = 24, name = "Enchant Crossbow Bolt (Pearl)",	id = nil,    	icon = "Interface\\Icons\\enchantcrossbow.blp"},	
    {level = 25, name = "Varrock Teleport",            		id = 114193, 	icon = "Interface\\Icons\\varrocktele.blp"},	
    {level = 27, name = "Lvl-2 Enchant",               		id = 460023, 	icon = "Interface\\Icons\\emeraldenchanting.blp", 		openInv=true,},
 -- {level = 27, name = "Enchant Crossbow Bolt (Emerald)",  id = nil,    	icon = "Interface\\Icons\\enchantcrossbow.blp"},
    {level = 29, name = "Earth Bolt",                  		id = 79541,  	icon = "Interface\\Icons\\earthbolt.blp"},
 -- {level = 29, name = "Enchant Crossbow Bolt (Red Topaz)",id = nil,    	icon = "Interface\\Icons\\enchantcrossbow.blp"},
    {level = 31, name = "Lumbridge Teleport",          		id = 114196, 	icon = "Interface\\Icons\\lumbridgetele.blp"},
    {level = 33, name = "Telekinetic Grab (Corpse)",   		id = 114134, 	icon = "Interface\\Icons\\telegrab.blp"},
    {level = 33, name = "Telekinetic Grab (Gameobject)",	id = 1812,   	icon = "Interface\\Icons\\telegrab.blp"},
    {level = 35, name = "Fire Bolt",                   		id = 79546,  	icon = "Interface\\Icons\\firebolt.blp"},
    {level = 37, name = "Falador Teleport",            		id = 114194, 	icon = "Interface\\Icons\\faladortele.blp"},
    {level = 39, name = "Crumble Undead",              		id = 99317,  	icon = "Interface\\Icons\\crumbleundead.blp"},
 -- {level = 40, name = "Teleport to House",           		id = nil,    	icon = "Interface\\Icons\\teleporttohouse.blp"},
    {level = 41, name = "Wind Blast",                  		id = 79532,  	icon = "Interface\\Icons\\windblast.blp"},
    {level = 43, name = "Superheat Item",              		id = 99318,  	icon = "Interface\\Icons\\superheaticon.blp", 			openInv=true,},
    {level = 45, name = "Camelot Teleport",            		id = 114197, 	icon = "Interface\\Icons\\camelottele.blp"},
    {level = 47, name = "Water Blast",                 		id = 79537,  	icon = "Interface\\Icons\\waterblast.blp"},
 -- {level = 48, name = "Kourend Castle Teleport",     		id = nil,    	icon = "Interface\\Icons\\kourendcastletele.blp"},
    {level = 49, name = "Lvl-3 Enchant",               		id = 460024, 	icon = "Interface\\Icons\\rubyenchanting.blp",			openInv=true,},
 -- {level = 49, name = "Enchant Crossbow Bolt (Ruby)", 	id = nil,    	icon = "Interface\\Icons\\enchantcrossbow.blp"},
 -- {level = 50, name = "Iban Blast",                  		id = nil,    	icon = "Interface\\Icons\\ibanblast.blp"},
    {level = 50, name = "Snare",                       		id = 99537,  	icon = "Interface\\Icons\\snareicon.blp"},
 -- {level = 50, name = "Magic Dart",                  		id = nil,    	icon = "Interface\\Icons\\magicdart.blp"},
    {level = 51, name = "Ardougne Teleport",           		id = 114198, 	icon = "Interface\\Icons\\ardytele.blp"},
    {level = 53, name = "Earth Blast",                 		id = 79542,  	icon = "Interface\\Icons\\earthblast.blp"},
 -- {level = 54, name = "Civitas illa Fortis Teleport", 	id = nil,    	icon = "Interface\\Icons\\civitasilafortistele.blp"},
    {level = 55, name = "High Level Alchemy",          		id = 200090, 	icon = "Interface\\Icons\\highalch.blp", 				openInv=true,},
    {level = 56, name = "Charge Water Orb",            		id = 99233,  	icon = "Interface\\Icons\\chargewaterorb.blp", 			openInv=true,},
    {level = 57, name = "Lvl-4 Enchant",               		id = 460025, 	icon = "Interface\\Icons\\diamondenchanting.blp", 		openInv=true,},  
 -- {level = 57, name = "Enchant Crossbow Bolt (Diamond)", id = nil,        icon = "Interface\\Icons\\enchantcrossbow.blp"},
    {level = 58, name = "Watchtower Teleport",         		id = 114200, 	icon = "Interface\\Icons\\watchtowertele.blp"},
    {level = 59, name = "Fire Blast",                  		id = 79547,  	icon = "Interface\\Icons\\fireblast.blp"},
    {level = 60, name = "Charge Earth Orb",            		id = 99234,  	icon = "Interface\\Icons\\chargeearthorb.blp", 			openInv=true,},
 -- {level = 60, name = "Bones to Peaches",            		id = nil,    	icon = "Interface\\Icons\\bonestopeaches.blp"},
 -- {level = 60, name = "Saradomin Strike",            		id = nil,    	icon = "Interface\\Icons\\saradominstrike.blp"},
 -- {level = 60, name = "Flames of Zamorak",           		id = nil,    	icon = "Interface\\Icons\\flamesofzamorak.blp"},
 -- {level = 60, name = "Claws of Guthix",             		id = nil,    	icon = "Interface\\Icons\\clawsofguthix.blp"},
    {level = 61, name = "Trollheim Teleport",          		id = 114199, 	icon = "Interface\\Icons\\trollheimtele.blp"},
    {level = 62, name = "Wind Wave",                   		id = 79533,  	icon = "Interface\\Icons\\windwave.blp"},
    {level = 63, name = "Charge Fire Orb",             		id = 99235,  	icon = "Interface\\Icons\\chargefireorb.blp", 			openInv=true,},
 -- {level = 64, name = "Ape Atoll Teleport",         		id = nil,    	icon = "Interface\\Icons\\apeatolltele.blp"},
    {level = 65, name = "Water Wave",                 		id = 79538,  	icon = "Interface\\Icons\\waterwave.blp"},
    {level = 66, name = "Charge Air Orb",              		id = 99236,  	icon = "Interface\\Icons\\chargeairorb.blp", 			openInv=true,},
 -- {level = 66, name = "Vulnerability",              		id = nil,    	icon = "Interface\\Icons\\vulnerability.blp"},
    {level = 68, name = "Lvl-5 Enchant",               		id = 460026, 	icon = "Interface\\Icons\\dragonstoneenchanting.blp", 	openInv=true,}, 
 -- {level = 68, name = "Enchant Crossbow Bolt (Dragonstone)", id = nil,    icon = "Interface\\Icons\\enchantdragonstone.blp"},
    {level = 70, name = "Earth Wave",                  		id = 79543,  	icon = "Interface\\Icons\\earthwave.blp"},
 -- {level = 73, name = "Enfeeble",                   		id = nil,    	icon = "Interface\\Icons\\enfeeble.blp"},
 -- {level = 74, name = "Teleother Lumbridge",        		id = nil,    	icon = "Interface\\Icons\\teleotherlumbridge.blp"},
    {level = 75, name = "Fire Wave",                  		id = 79548,  	icon = "Interface\\Icons\\firewave.blp"},
    {level = 79, name = "Entangle",                    		id = 99315,  	icon = "Interface\\Icons\\entangleicon.blp"},
 -- {level = 80, name = "Stun",                       		id = nil,    	icon = "Interface\\Icons\\stunicon.blp"},
    {level = 80, name = "Charge",                      		id = 707049, 	icon = "Interface\\Icons\\chargeicon.blp"},
 -- {level = 81, name = "Wind Surge",                 		id = nil,    	icon = "Interface\\Icons\\windsurge.blp"},
 -- {level = 82, name = "Teleother Falador",          		id = nil,    	icon = "Interface\\Icons\\teleotherfalador.blp"},
 -- {level = 85, name = "Water Surge",                		id = nil,    	icon = "Interface\\Icons\\watersurge.blp"},
    {level = 85, name = "Tele Block",                  		id = 99542,  	icon = "Interface\\Icons\\teleblockicon.blp"},
 -- {level = 85, name = "Teleport to Target",         		id = nil,    	icon = "Interface\\Icons\\teleporttotarget.blp"},
 -- {level = 87, name = "Lvl-6 Enchant",               		id = nil,    	icon = "Interface\\Icons\\lvl6enchant.blp"},
 -- {level = 87, name = "Enchant Crossbow Bolt (Onyx)", 	id = nil,    	icon = "Interface\\Icons\\enchantonyx.blp"},
 -- {level = 90, name = "Teleother Camelot",          		id = nil,    	icon = "Interface\\Icons\\teleothercamelot.blp"},
 -- {level = 90, name = "Earth Surge",                		id = nil,    	icon = "Interface\\Icons\\earthsurge.blp"},
 -- {level = 93, name = "Lvl-7 Enchant",               		id = nil,    	icon = "Interface\\Icons\\lvl7enchant.blp"},
 -- {level = 95, name = "Fire Surge",                 		id = nil,    	icon = "Interface\\Icons\\firesurge.blp"},
 -- {level = 102, name = "Wind Surge",                 		id = 79534,  	icon = "Interface\\Icons\\windsurge.blp"},
 -- {level = 103, name = "Water Surge",                		id = 79539,  	icon = "Interface\\Icons\\watersurge.blp"},
 -- {level = 104, name = "Earth Surge",                		id = 79544,  	icon = "Interface\\Icons\\earthsurge.blp"},
 -- {level = 105, name = "Fire Surge",                 		id = 79549,  	icon = "Interface\\Icons\\firesurge.blp"},
}                                                                           



-- check if player has runes required to cast spell 
function WORS_U_SpellBook:HasRequiredRunes(runeTable)
    if runeTable == nil then return true end
	
	for runeName, count in pairs(runeTable) do
        local runeData = self.runeInfo[runeName]
        if runeData then
            local hasRune = GetItemCount(runeData.itemID) >= count
            local hasStaff = false
            -- Check main hand and offhand slot for items that give unlimited runes
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
			--print("|cff00ff00MicroMenu: |r" .. "|cffff0000Error: |r" .. "|cff00ff00Missing rune data for:", runeName,"|r")
            return false
        end
    end
    return true
end

-- WORS_U_PrayBook.lua Data
WORS_U_PrayBook = {}  -- Create the main table for the PrayBook
WORS_U_PrayBook.prayers = {
    {level=1,  id=79502,  icon="Interface\\Icons\\thickskin.blp",            buffIcon="Interface\\Icons\\active_thickskin.blp"},           -- Thick Skin
    {level=4,  id=79506,  icon="Interface\\Icons\\burststrength.blp",        buffIcon="Interface\\Icons\\active_burststrength.blp"},       -- Burst of Strength
    {level=7,  id=79508,  icon="Interface\\Icons\\claritythought.blp",       buffIcon="Interface\\Icons\\active_claritythought.blp"},      -- Clarity of Thought
    {level=8,  id=79512,  icon="Interface\\Icons\\sharpeye.blp",             buffIcon="Interface\\Icons\\active_sharpeye.blp"},            -- Sharp Eye
    {level=9,  id=79514,  icon="Interface\\Icons\\mysticwill.blp",           buffIcon="Interface\\Icons\\active_mysticwill.blp"},          -- Mystic Will
    {level=10, id=79503,  icon="Interface\\Icons\\rockskin.blp",             buffIcon="Interface\\Icons\\active_rockskin.blp"},            -- Rock Skin
    {level=13, id=79505,  icon="Interface\\Icons\\superhumanstrength.blp",   buffIcon="Interface\\Icons\\active_superhumanstrength.blp"},  -- Superhuman Strength
    {level=16, id=79509,  icon="Interface\\Icons\\improvedreflexes.blp",     buffIcon="Interface\\Icons\\active_improvedreflexes.blp"},    -- Improved Reflexes
    {level=19, id=80019,  icon="Interface\\Icons\\rapidrestore.blp",         buffIcon="Interface\\Icons\\active_rapidrestore.blp"},        -- Rapid Restore
    {level=22, id=79521,  icon="Interface\\Icons\\rapidheal.blp",            buffIcon="Interface\\Icons\\active_rapidheal.blp"},           -- Rapid Heal
    {level=25, id=114131, icon="Interface\\Icons\\protectitem.blp",          buffIcon="Interface\\Icons\\active_protectitem.blp"},         -- Protect Item
    {level=26, id=79511,  icon="Interface\\Icons\\hawkeye.blp",              buffIcon="Interface\\Icons\\active_hawkeye.blp"},             -- Hawk Eye
    {level=27, id=79516,  icon="Interface\\Icons\\mysticlore.blp",           buffIcon="Interface\\Icons\\active_mysticlore.blp"},          -- Mystic Lore
    {level=28, id=79504,  icon="Interface\\Icons\\steelskin.blp",            buffIcon="Interface\\Icons\\active_steelskin.blp"},           -- Steel Skin
    {level=31, id=79507,  icon="Interface\\Icons\\ultimatestrength.blp",     buffIcon="Interface\\Icons\\active_ultimatestrength.blp"},    -- Ultimate Strength
    {level=34, id=79510,  icon="Interface\\Icons\\incrediblereflexes.blp",   buffIcon="Interface\\Icons\\active_incrediblereflexes.blp"},  -- Incredible Reflexes
    {level=37, id=79501,  icon="Interface\\Icons\\magicpray.blp",            buffIcon="Interface\\Icons\\active_magicpray.blp"},           -- Protect from Magic
    {level=40, id=79500,  icon="Interface\\Icons\\rangepray.blp",            buffIcon="Interface\\Icons\\active_rangepray.blp"},           -- Protect from Missiles
    {level=43, id=465,    icon="Interface\\Icons\\meleepray.blp",            buffIcon="Interface\\Icons\\active_meleepray.blp"},           -- Protect from Melee
    {level=44, id=79513,  icon="Interface\\Icons\\eagleeye.blp",             buffIcon="Interface\\Icons\\active_eagleeye.blp"},           -- Eagle Eye
    {level=45, id=79515,  icon="Interface\\Icons\\mysticmight.blp",          buffIcon="Interface\\Icons\\active_mysticmight.blp"}          -- Mystic Might
}



-- Global table for the Equipment Book
WORS_U_EquipmentBook = {}



-- WORS_U_EmoteBook.lua Data
WORS_U_EmoteBook = {}
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

-- WORS_U_MusicBook.lua Data
WORS_U_MusicBook = {}
WORS_U_MusicBook.currentTrack = nil
WORS_U_MusicBook.tracks = {
    { name = "Sea Shanty", 		file = "Sound\\RuneScape\\Sea_Shanty_2.ogg" },
    { name = "Harmony", 		file = "Sound\\RuneScape\\Harmony.ogg" },
	{ name = "Harmony 2", 		file = "Sound\\RuneScape\\Harmony_2.ogg" },
	{ name = "Runescape Main", 	file = "Sound\\RuneScape\\Scape_Main.ogg" },
	{ name = "Runescape Theme", file = "Sound\\RuneScape\\Runescape_Theme.ogg" },
	{ name = "Wilderness", 		file = "Sound\\RuneScape\\Wilderness.ogg" },
	{ name = "Wilderness 2", 	file = "Sound\\RuneScape\\Wilderness_2.ogg" },
}

-- Experience Table used to calculate skills level from Reputaion
experienceTable = {
    [1]  = 0,
    [2]  = 83,
    [3]  = 174,
    [4]  = 276,
    [5]  = 388,
    [6]  = 512,
    [7]  = 650,
    [8]  = 801,
    [9]  = 969,
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
        print("|cff00ff00MicroMenu: |r" .. "|cffff0000Error D1 Message Untitled: |r" .. "|cff00ff00 GetFactionInfoByIDFaction Failed. factionID: ", factionID, " not found.|r")
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

-- function used to save frame postion of all frames when one is moved offsets used to adjust backpack / micro menu and combat style frames
function SaveFramePosition(self)
    -- 1) raw anchor
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    local relName = relativeTo and relativeTo:GetName() or "UIParent"
    
	-- 2) persist
    WORS_U_MicroMenuSettings.MicroMenuPOS = {point = point, relativeTo = relName, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
    local reference = _G[relName] or UIParent

    -- 3) two offset tables
    -- local bpOffsets = { -- bp ofsets for when Micromenu frames or combatstylepannel is moved to apply to backpack
        -- RIGHT       = { -6, -25 }, TOPRIGHT     = { -6, 0 }, BOTTOMRIGHT = { -6, -50 },
        -- LEFT        = {  6, -25 }, TOPLEFT      = {  6, 0 }, BOTTOMLEFT  = {  6, -50 },
        -- CENTER      = {  0, -25 }, TOP          = {  0, 0 }, BOTTOM      = {  0, -50 },
    -- }
    -- local mmOffsets = { -- mm ofsets for when backpack is moved to apply to Micromenu frames
        -- RIGHT       = {  6, 25 },   TOPRIGHT    = {  6, 0 }, BOTTOMRIGHT = {  6, 50 },
        -- LEFT        = { -6, 25 },   TOPLEFT     = { -6, 0 }, BOTTOMLEFT  = { -6, 50 },
        -- CENTER      = {  0, 25 },   TOP         = {  0, 0 }, BOTTOM      = {  0, 50 },
    -- }
	
	-- 3) two offset tables
    local bpOffsets = { -- bp ofsets for when Micromenu frames or combatstylepannel is moved to apply to backpack
        RIGHT       = { 0, 0 }, TOPRIGHT     = { 0, 0 }, BOTTOMRIGHT = { 0, 0 },
        LEFT        = { 0, 0 }, TOPLEFT      = { 0, 0 }, BOTTOMLEFT  = { 0, 0 },
        CENTER      = { 0, 0 }, TOP          = { 0, 0 }, BOTTOM      = { 0, 0 },
    }
    local mmOffsets = { -- mm ofsets for when backpack is moved to apply to Micromenu frames
        RIGHT       = { 0, 0 },   TOPRIGHT    = { 0, 0 }, BOTTOMRIGHT = { 0, 0 },
        LEFT        = { 0, 0 },   TOPLEFT     = { 0, 0 }, BOTTOMLEFT  = { 0, 0 },
        CENTER      = { 0, 0 },   TOP         = { 0, 0 }, BOTTOM      = { 0, 0 },
    }
	
    local bpX, bpY = unpack(bpOffsets[relativePoint] or { xOfs, yOfs })
    local mmX, mmY = unpack(mmOffsets[relativePoint] or { xOfs, yOfs })

    -- 4a) you dragged the Backpack → move all micro-menu frames with mmOffsets
    if self == Backpack then
        for _, frame in ipairs(MicroMenu_Frames) do
            local fx, fy = mmX, mmY
            frame:ClearAllPoints()
            frame:SetPoint(point, Backpack, relativePoint, fx, fy)
            frame:SetUserPlaced(false)
        end
		Backpack:ClearAllPoints()
        Backpack:SetPoint(point, reference, relativePoint, xOfs, yOfs)
        Backpack:SetUserPlaced(false)
        return
    
	-- 4b) you dragged a MicroMenu frame → snap peers raw, then move Backpack with bpOffsets
    else
        for _, frame in ipairs(MicroMenu_Frames) do
            if frame ~= self then
                frame:ClearAllPoints()
                frame:SetPoint(point, reference, relativePoint, xOfs, yOfs)
                frame:SetUserPlaced(false)
            end
        end
        if Backpack then
            local bx, by = xOfs + bpX, yOfs + bpY
            Backpack:ClearAllPoints()
            Backpack:SetPoint(point, reference, relativePoint, bx, by)
            Backpack:SetUserPlaced(false)
        end
    end
end