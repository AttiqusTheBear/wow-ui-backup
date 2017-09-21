local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.

-- Internal function to format the Keybind Display Title
local function formatKeybind(group, ability)
	local returnValue = "";

	if group and ability then
		returnValue = string.format("%s%s:%s %s", addonTable.TEXT_COLOR_TAG_HIGHLIGHT, group, addonTable.TEXT_COLOR_TAG_END, ability);
	end

	return returnValue;
end

-- Keybind Headings
BINDING_HEADER_ADDON = string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_HIGHLIGHT, "LunaEclipse", addonTable.TEXT_COLOR_TAG_END);
BINDING_HEADER_GENERAL = "Script Options (Common to all classes)";

-- Death Knight Headings
BINDING_HEADER_DEATH_KNIGHT_COMMON = "Common Death Knight Options";
BINDING_HEADER_DEATH_KNIGHT_BLOOD = "Blood Death Knight Options";
BINDING_HEADER_DEATH_KNIGHT_FROST = "Frost Death Knight Options";
BINDING_HEADER_DEATH_KNIGHT_UNHOLY = "Unholy Death Knight Options";

-- Demon Hunter Headings
BINDING_HEADER_DEMON_HUNTER_COMMON = "Common Demon Hunter Options";
BINDING_HEADER_DEMON_HUNTER_HAVOC = "Havoc Demon Hunter Options";
BINDING_HEADER_DEMON_HUNTER_VENGEANCE = "Vengeance Demon Hunter Options";

-- Druid Headings
BINDING_HEADER_DRUID_COMMON = "Common Druid Options";
BINDING_HEADER_DRUID_BALANCE = "Balance Druid Options";
BINDING_HEADER_DRUID_FERAL = "Feral Druid Options";
BINDING_HEADER_DRUID_GUARDIAN = "Guardian Druid Options";
BINDING_HEADER_DRUID_RESTORATION = "Restoration Druid Options";

-- Hunter Headings
BINDING_HEADER_HUNTER_COMMON = "Common Hunter Options";
BINDING_HEADER_HUNTER_BEAST_MASTERY = "Beast Mastery Hunter Options";
BINDING_HEADER_HUNTER_MARKSMANSHIP = "Marksmanship Hunter Options";
BINDING_HEADER_HUNTER_SURVIVAL = "Survival Hunter Options";

-- Mage Headings
BINDING_HEADER_MAGE_COMMON = "Common Mage Options";
BINDING_HEADER_MAGE_ARCANE = "Arcane Mage Options";
BINDING_HEADER_MAGE_FIRE = "Fire Mage Options";
BINDING_HEADER_MAGE_FROST = "Frost Mage Options";

-- Monk Headings
BINDING_HEADER_MONK_COMMON = "Common Monk Options";
BINDING_HEADER_MONK_BREWMASTER = "Brewmaster Monk Options";
BINDING_HEADER_MONK_MISTWEAVER = "Mistweaver Monk Options";
BINDING_HEADER_MONK_WINDWALKER = "Windwalker Monk Options";

-- Paladin Headings
BINDING_HEADER_PALADIN_COMMON = "Common Paladin Options";
BINDING_HEADER_PALADIN_HOLY = "Holy Paladin Options";
BINDING_HEADER_PALADIN_PROTECTION = "Protection Paladin Options";
BINDING_HEADER_PALADIN_RETRIBUTION = "Retribution Paladin Options";

-- Priest Headings
BINDING_HEADER_PRIEST_COMMON = "Common Priest Options";
BINDING_HEADER_PRIEST_DISCIPLINE = "Discipline Priest Options";
BINDING_HEADER_PRIEST_HOLY = "Holy Priest Options";
BINDING_HEADER_PRIEST_SHADOW = "Shadow Priest Options";

-- Rogue Headings
BINDING_HEADER_ROGUE_COMMON = "Common Rogue Options";
BINDING_HEADER_ROGUE_ASSASSINATION = "Assassination Rogue Options";
BINDING_HEADER_ROGUE_OUTLAW = "Outlaw Rogue Options";
BINDING_HEADER_ROGUE_SUBTLETY = "Subelty Rogue Options";

-- Shaman Headings
BINDING_HEADER_SHAMAN_COMMON = "Common Shaman Options";
BINDING_HEADER_SHAMAN_ELEMENTAL = "Elemental Shaman Options";
BINDING_HEADER_SHAMAN_ENHANCEMENT = "Enhancement Shaman Options";
BINDING_HEADER_SHAMAN_RESTORATION = "Restoration Shaman Options";

-- Warlock Headings
BINDING_HEADER_WARLOCK_COMMON = "Common Warlock Options";
BINDING_HEADER_WARLOCK_AFFLICTION = "Affliction Warlock Options";
BINDING_HEADER_WARLOCK_DEMONOLOGY = "Demonology Warlock Options";
BINDING_HEADER_WARLOCK_DESTRUCTION = "Destruction Warlock Options";

-- Warrior Headings
BINDING_HEADER_WARRIOR_COMMON = "Common Warrior Options";
BINDING_HEADER_WARRIOR_ARMS = "Arms Warrior Options";
BINDING_HEADER_WARRIOR_FURY = "Fury Warrior Options";
BINDING_HEADER_WARRIOR_PROTECTION = "Protection Warrior Options";

-- Configuration Screen Group Headings
BINDING_HEADER_AOE = "AOE Settings";
BINDING_HEADER_BUFFS_DEBUFFS = "Buff and Debuff Settings";
BINDING_HEADER_COOLDOWNS = "Cooldown Settings";
BINDING_HEADER_DEFENSIVE = "Defensive Settings";
BINDING_HEADER_PET = "Pet Settings";
BINDING_HEADER_SPECIAL = "Special Settings";

-- General Keybind Labels
BINDING_NAME_OPT_MAJOR_CDS_RAID_ONLY = formatKeybind("Major CDs", "Raid Bosses Only");
BINDING_NAME_OPT_POTION = formatKeybind("Show", "Potions");
BINDING_NAME_OPT_DRAUGHT_OF_SOULS = formatKeybind("Cooldown", "Draught of Souls");

BINDING_NAME_OPT_SINGLE_TARGET = formatKeybind("Display", "Single Target Icon");
BINDING_NAME_OPT_MULTI_DOT = formatKeybind("Display", "Show Multi-DOT Icon");

BINDING_NAME_OPT_ENEMIES_TAGGED = formatKeybind("Enemies", "Tagged Only");
BINDING_NAME_OPT_MELEE_RANGE = formatKeybind("Show", "Not in Melee Range");
BINDING_NAME_OPT_MOVING = formatKeybind("Other", "Movement Check");
BINDING_NAME_OPT_RANGE_CHECK = formatKeybind("Other", "Range Check");
BINDING_NAME_OPT_INTERRUPT = formatKeybind("Show", "Interrupts");
BINDING_NAME_OPT_ARCANE_TORRENT_INTERRUPT = formatKeybind("Other", "Arcane Torrent (Interrupt Only)");

-- Death Knight Keybind Labels
BINDING_NAME_OPT_ANTI_MAGIC_SHELL = formatKeybind("Defensive", "Anti-Magic Shell");
BINDING_NAME_OPT_ICEBOUND_FORTITUDE = formatKeybind("Defensive", "Icebound Fortitude");
BINDING_NAME_OPT_DEATH_STRIKE_SUCCOR = formatKeybind("Heal", "Death Strike (Dark Succor)");

BINDING_NAME_OPT_FROSTSCYTHE = formatKeybind("AOE", "Frostscythe");
BINDING_NAME_OPT_REMORSELESS_WINTER = formatKeybind("AOE", "Remorseless Winter");
BINDING_NAME_OPT_BREATH_OF_SINDRAGOSA = formatKeybind("Cooldown", "Breath of Sindragosa");
BINDING_NAME_OPT_EMPOWER_RUNE_WEAPON = formatKeybind("Cooldown", "Empower Rune Weapon");
BINDING_NAME_OPT_GLACIAL_ADVANCE = formatKeybind("Cooldown", "Glacial Advance");
BINDING_NAME_OPT_HORN_OF_WINTER = formatKeybind("Cooldown", "Horn of Winter");
BINDING_NAME_OPT_OBLITERATION = formatKeybind("Cooldown", "Obliteration");
BINDING_NAME_OPT_PILLAR_OF_FROST = formatKeybind("Cooldown", "Pillar of Frost");
BINDING_NAME_OPT_SINDRAGOSA_FURY = formatKeybind("Cooldown", "Sindragosa's Fury");

BINDING_NAME_OPT_DND = formatKeybind("AOE", "Death and Decay");
BINDING_NAME_OPT_EPIDEMIC = formatKeybind("AOE CD", "Epidemic");
BINDING_NAME_OPT_APOCALYPSE = formatKeybind("Cooldown", "Apocalypse");
BINDING_NAME_OPT_ARMY_OF_THE_DEAD = formatKeybind("Cooldown", "Army of the Dead");
BINDING_NAME_OPT_BLIGHTED_RUNE_WEAPON = formatKeybind("Cooldown", "Blighted Rune Weapon");
BINDING_NAME_OPT_DARK_TRANSFORMATION = formatKeybind("Cooldown", "Dark Transformation");
BINDING_NAME_OPT_GARGOYLE = formatKeybind("Cooldown", "Gargoyle");
BINDING_NAME_OPT_SOUL_REAPER = formatKeybind("Cooldown", "Soul Reaper");
BINDING_NAME_OPT_CORPSE_SHIELD = formatKeybind("Defensive", "Corpse Shield");

-- Druid Keybind Labels
BINDING_NAME_OPT_RENEWAL = formatKeybind("Heal", "Renewal");

BINDING_NAME_OPT_STARFALL = formatKeybind("AOE", "Starfall");
BINDING_NAME_OPT_STELLAR_FLARE = formatKeybind("AOE", "Stellar Flare");
BINDING_NAME_OPT_BLESSING_ANCIENTS = formatKeybind("Buff", "Blessing of Elune");
BINDING_NAME_OPT_MOONKIN_FORM = formatKeybind("Buff", "Moonkin Form");
BINDING_NAME_OPT_ASTRAL_COMMUNION = formatKeybind("Cooldown", "Astral Communion");
BINDING_NAME_OPT_CELESTIAL_ALIGNMENT = formatKeybind("Cooldown", "Celestial Alignment");
BINDING_NAME_OPT_FORCE_OF_NATURE = formatKeybind("Cooldown", "Force of Nature");
BINDING_NAME_OPT_FURY_OF_ELUNE = formatKeybind("Cooldown", "Fury of Elune");
BINDING_NAME_OPT_WARRIOR_OF_ELUNE = formatKeybind("Cooldown", "Warrior of Elune");
BINDING_NAME_OPT_BARKSKIN = formatKeybind("Defensive", "Barkskin");
BINDING_NAME_OPT_SCYTHE_SPELL_CLIPPING = formatKeybind("Other", "Allow Clipping Scythe Spells");

BINDING_NAME_OPT_MOONFIRE_LUNAR = formatKeybind("AOE", "Moonfire");
BINDING_NAME_OPT_SWIPE = formatKeybind("AOE", "Swipe");
BINDING_NAME_OPT_THRASH = formatKeybind("AOE", "Thrash");
BINDING_NAME_OPT_BRUTAL_SLASH = formatKeybind("AOE CD", "Brutal Slash");
BINDING_NAME_OPT_CAT_FORM = formatKeybind("Buff", "Cat Form");
BINDING_NAME_OPT_ASHAMANES_FRENZY = formatKeybind("Cooldown", "Ashamane's Frenzy");
BINDING_NAME_OPT_BERSERK = formatKeybind("Cooldown", "Berserk");
BINDING_NAME_OPT_ELUNES_GUIDANCE = formatKeybind("Cooldown", "Elune's Guidance");
BINDING_NAME_OPT_REGROWTH_BLOODTALONS = formatKeybind("Cooldown", "Regrowth");
BINDING_NAME_OPT_SAVAGE_ROAR = formatKeybind("Cooldown", "Savage Roar");
BINDING_NAME_OPT_SHADOWMELD = formatKeybind("Cooldown", "Shadowmeld");
BINDING_NAME_OPT_SURVIVAL_INSTINCTS = formatKeybind("Defensive", "Survival Instincts");

-- Hunter Keybind Labels
BINDING_NAME_OPT_BARRAGE = formatKeybind("AOE CD", "Barrage");
BINDING_NAME_OPT_AMOC = formatKeybind("Cooldown", "A Murder of Crows");
BINDING_NAME_OPT_ASPECT_TURTLE = formatKeybind("Defensive", "Aspect of the Turtle");
BINDING_NAME_OPT_FEIGN_DEATH = formatKeybind("Defensive", "Feign Death");
BINDING_NAME_OPT_EXHILARATION = formatKeybind("Heal", "Exhilaration");

BINDING_NAME_OPT_VOLLEY = formatKeybind("Buff", "Volley");
BINDING_NAME_OPT_ASPECT_WILD = formatKeybind("Cooldown", "Aspect of the Wild");
BINDING_NAME_OPT_BEASTIAL_WRATH = formatKeybind("Cooldown", "Beastial Wrath");
BINDING_NAME_OPT_CHIMAERA_SHOT = formatKeybind("Cooldown", "Chimaera Shot");
BINDING_NAME_OPT_DIRE_BEAST = formatKeybind("Cooldown", "Dire Beast");
BINDING_NAME_OPT_STAMPEDE = formatKeybind("Cooldown", "Stampede");
BINDING_NAME_OPT_TITANS_THUNDER = formatKeybind("Cooldown", "Titan's Thunder");

BINDING_NAME_OPT_MARKED_SHOT = formatKeybind("AOE", "Marked Shot");
BINDING_NAME_OPT_SIDEWINDERS = formatKeybind("AOE", "Sidewinders");
BINDING_NAME_OPT_BURSTING_SHOT = formatKeybind("Cooldown", "Bursting Shot");
BINDING_NAME_OPT_EXPLOSIVE_SHOT = formatKeybind("Cooldown", "Explosive Shot");
BINDING_NAME_OPT_EXPLOSIVE_SHOT_DETONATE = formatKeybind("Cooldown", "Explosive Shot (Detonate)");
BINDING_NAME_OPT_PIERCING_SHOT = formatKeybind("Cooldown", "Piercing Shot");
BINDING_NAME_OPT_TRUESHOT = formatKeybind("Cooldown", "Trueshot");
BINDING_NAME_OPT_WINDBURST = formatKeybind("Cooldown", "Windburst");

BINDING_NAME_OPT_CARVE = formatKeybind("AOE", "Carve");
BINDING_NAME_OPT_CALTROPS = formatKeybind("AOE CD", "Caltrops");
BINDING_NAME_OPT_DRAGONSFIRE_GRENADE = formatKeybind("AOE CD", "Dragonsfire Grenade");
BINDING_NAME_OPT_EXPLOSIVE_TRAP = formatKeybind("AOE CD", "Explosive Trap");
BINDING_NAME_OPT_EAGLE_ASPECT = formatKeybind("Cooldown", "Aspect of the Eagle");
BINDING_NAME_OPT_BUTCHERY = formatKeybind("Cooldown", "Butchery");
BINDING_NAME_OPT_FURY_OF_THE_EAGLE = formatKeybind("Cooldown", "Fury of the Eagle");
BINDING_NAME_OPT_SNAKE_HUNTER = formatKeybind("Cooldown", "Snake Hunter");
BINDING_NAME_OPT_SPITTING_COBRA = formatKeybind("Cooldown", "Spitting Cobra");
BINDING_NAME_OPT_STEEL_TRAP = formatKeybind("Cooldown", "Steel Trap");
BINDING_NAME_OPT_THROWING_AXES = formatKeybind("Cooldown", "Throwing Axes");

-- Mage Keybind Lables
BINDING_NAME_OPT_MIRROR_IMAGE = formatKeybind("Cooldown", "Mirror Image");
BINDING_NAME_OPT_POWER_RUNE = formatKeybind("Cooldown", "Rune of Power");
BINDING_NAME_OPT_TIME_WARP = formatKeybind("Cooldown", "Time Warp");
BINDING_NAME_OPT_ICE_BARRIER = formatKeybind("Defensive", "Barrier Spells");
BINDING_NAME_OPT_ICE_BLOCK = formatKeybind("Defensive", "Ice Block");

BINDING_NAME_OPT_ARCANE_EXPLOSION = formatKeybind("AOE", "Arcane Explosion");
BINDING_NAME_OPT_ARCANE_FAMILIAR = formatKeybind("Buff", "Arcane Familiar");
BINDING_NAME_OPT_ARCANE_ORB = formatKeybind("Cooldown", "Arcane Orb");
BINDING_NAME_OPT_ARCANE_POWER = formatKeybind("Cooldown", "Arcane Power");
BINDING_NAME_OPT_CHARGED_UP = formatKeybind("Cooldown", "Charged Up");
BINDING_NAME_OPT_EVOCATION = formatKeybind("Cooldown", "Evocation");
BINDING_NAME_OPT_MARK_OF_ALUNETH = formatKeybind("Cooldown", "Mark of Aluneth");
BINDING_NAME_OPT_NETHER_TEMPEST = formatKeybind("Cooldown", "Nether Tempest");
BINDING_NAME_OPT_PRESENCE_OF_MIND = formatKeybind("Cooldown", "Presence of Mind");
BINDING_NAME_OPT_SUPERNOVA = formatKeybind("Cooldown", "Supernova");

BINDING_NAME_OPT_DRAGONS_BREATH = formatKeybind("AOE", "Dragon's Breath");
BINDING_NAME_OPT_FLAMESTRIKE = formatKeybind("AOE", "Flamestrike");
BINDING_NAME_OPT_LIVING_BOMB = formatKeybind("AOE", "Living Bomb");
BINDING_NAME_OPT_BLAST_WAVE = formatKeybind("AOE CD", "Blast Wave");
BINDING_NAME_OPT_CINDERSTORM = formatKeybind("AOE CD", "Cinderstorm");
BINDING_NAME_OPT_METEOR = formatKeybind("AOE CD", "Meteor");
BINDING_NAME_OPT_COMBUSTION = formatKeybind("Cooldown", "Combustion");
BINDING_NAME_OPT_PHOENIXS_FLAMES = formatKeybind("Cooldown", "Phoenix's Flames");
BINDING_NAME_OPT_FLAMESTRIKE_HOT_STREAK = formatKeybind("Other", "Flamestrike (Hot Streak Only)");

BINDING_NAME_OPT_BLIZZARD = formatKeybind("AOE", "Blizzard");
BINDING_NAME_OPT_FROST_BOMB = formatKeybind("AOE", "Frost Bomb");
BINDING_NAME_OPT_ICE_NOVA = formatKeybind("AOE CD", "Ice Nova");
BINDING_NAME_OPT_COMET_STORM = formatKeybind("Cooldown", "Comet Storm");
BINDING_NAME_OPT_EBONBOLT = formatKeybind("Cooldown", "Ebonbolt");
BINDING_NAME_OPT_FROZEN_ORB = formatKeybind("Cooldown", "Frozen Orb");
BINDING_NAME_OPT_GLACIAL_SPIKE = formatKeybind("Cooldown", "Glacial Spike");
BINDING_NAME_OPT_ICY_VEINS = formatKeybind("Cooldown", "Icy Veins");
BINDING_NAME_OPT_RAY_OF_FROST = formatKeybind("Cooldown", "Ray of Frost");
BINDING_NAME_OPT_BLIZZARD_FREEZING_RAIN = formatKeybind("Other", "Blizzard (Freezing Rain Only)");
BINDING_NAME_OPT_WATER_JET = formatKeybind("Pet", "Water Jet");

-- Monk Keybind Labels
BINDING_NAME_OPT_FISTS_OF_FURY = formatKeybind("AOE", "Fists of Fury");
BINDING_NAME_OPT_RUSHING_JADE_WIND = formatKeybind("AOE", "Rushing Jade Wind");
BINDING_NAME_OPT_SPINNING_CRANE = formatKeybind("AOE", "Spinning Crane Kick");
BINDING_NAME_OPT_CHI_BURST = formatKeybind("AOE CD", "Chi Burst");
BINDING_NAME_OPT_CHI_WAVE = formatKeybind("Cooldown", "Chi Wave");
BINDING_NAME_OPT_ENERGIZING_ELIXIR = formatKeybind("Cooldown", "Energizing Elixir");
BINDING_NAME_OPT_INVOKE_XUEN = formatKeybind("Cooldown", "Invoke Xuen");
BINDING_NAME_OPT_SERENITY = formatKeybind("Cooldown", "Serenity");
BINDING_NAME_OPT_SEF = formatKeybind("Cooldown", "Storm, Earth and Fire");
BINDING_NAME_OPT_STRIKE_WINDLORD = formatKeybind("Cooldown", "Strike of the Windlord");
BINDING_NAME_OPT_DEATH_TOUCH = formatKeybind("Cooldown", "Touch of Death");
BINDING_NAME_OPT_WHIRLING_DRAGON_PUNCH = formatKeybind("Cooldown", "Whirling Dragon Punch");
BINDING_NAME_OPT_TOUCH_OF_KARMA = formatKeybind("Defensive", "Touch of Karma");
BINDING_NAME_OPT_HEALING_ELIXIR = formatKeybind("Heal", "Healing Elixir");

-- Paladin Keybind Labels
BINDING_NAME_OPT_CONSECRATION = formatKeybind("AOE", "Consecration");
BINDING_NAME_OPT_DIVINE_HAMMER = formatKeybind("AOE", "Divine Hammer");
BINDING_NAME_OPT_DIVINE_STORM = formatKeybind("AOE", "Divine Storm");
BINDING_NAME_OPT_HOLY_WRATH = formatKeybind("AOE CD", "Holy Wrath");
BINDING_NAME_OPT_AVENGING_WRATH = formatKeybind("Cooldown", "Avenging Wrath");
BINDING_NAME_OPT_EXECUTION_SENTENCE = formatKeybind("Cooldown", "Execution Sentence");
BINDING_NAME_OPT_WAKE_OF_ASHES = formatKeybind("Cooldown", "Wake of Ashes");
BINDING_NAME_OPT_DIVINE_SHIELD = formatKeybind("Defensive", "Divine Shield");
BINDING_NAME_OPT_EYE_FOR_AN_EYE = formatKeybind("Defensive", "Eye for an Eye");
BINDING_NAME_OPT_SHIELD_OF_VENGEANCE = formatKeybind("Defensive", "Shield of Vengeance");
BINDING_NAME_OPT_LAY_ON_HANDS = formatKeybind("Heal", "Lay on Hands");
BINDING_NAME_OPT_WORD_OF_GLORY = formatKeybind("Heal", "Word of Glory");

-- Priest Keybind Labels
BINDING_NAME_OPT_SHADOW_CRASH = formatKeybind("AOE CD", "Shadow Crash");
BINDING_NAME_OPT_SHADOWFORM = formatKeybind("Buff", "Shadowform");
BINDING_NAME_OPT_DISPERSION_SURRENDER = formatKeybind("Cooldown", "Dispersion (Surrender to Madness)");
BINDING_NAME_OPT_POWER_INFUSION = formatKeybind("Cooldown", "Power Infustion");
BINDING_NAME_OPT_SHADOW_WORD_VOID = formatKeybind("Cooldown", "Shadow Word Void");
BINDING_NAME_OPT_SHADOWFIEND = formatKeybind("Cooldown", "Shadowfiend");
BINDING_NAME_OPT_SURRENDER = formatKeybind("Cooldown", "Surrender to Madness");
BINDING_NAME_OPT_VOID_ERRUPTION = formatKeybind("Cooldown", "Void Erruption");
BINDING_NAME_OPT_VOID_TORRENT = formatKeybind("Cooldown", "Void Torrent");
BINDING_NAME_OPT_DISPERSION = formatKeybind("Defensive", "Dispersion");
BINDING_NAME_OPT_POWER_WORD_SHIELD = formatKeybind("Defensive", "Power Word Shield");

-- Shaman Keybind Labels
BINDING_NAME_OPT_ASCENDANCE = formatKeybind("Cooldown", "Ascendance");
BINDING_NAME_OPT_ASTRAL_SHIFT = formatKeybind("Defensive", "Astral Shift");

BINDING_NAME_OPT_EARTHQUAKE = formatKeybind("AOE", "Earthquake");
BINDING_NAME_OPT_LIQUID_MAGMA_TOTEM = formatKeybind("AOE CD", "Liquid Magma Totem");
BINDING_NAME_OPT_ELEMENTAL_BLAST = formatKeybind("Cooldown", "Elemental Blast");
BINDING_NAME_OPT_ELEMENTAL_MASTERY = formatKeybind("Cooldown", "Elemental Mastery");
BINDING_NAME_OPT_GNAWED_THUMB_RING = formatKeybind("Cooldown", "Gnawed Thumb Ring");
BINDING_NAME_OPT_ICEFURY = formatKeybind("Cooldown", "Icefury");
BINDING_NAME_OPT_STORMKEEPER = formatKeybind("Cooldown", "Stormkeeper");
BINDING_NAME_OPT_SUMMON_ELEMENTAL = formatKeybind("Cooldown", "Summon Elemental");
BINDING_NAME_OPT_TOTEM_MASTERY = formatKeybind("Cooldown", "Totem Mastery");

BINDING_NAME_OPT_CRASH_LIGHTNING = formatKeybind("AOE", "Crash Lightning");
BINDING_NAME_OPT_LIGHTNING_SHIELD = formatKeybind("Buff", "Lightning Shield");
BINDING_NAME_OPT_DOOM_WINDS = formatKeybind("Cooldown", "Doom Winds");
BINDING_NAME_OPT_EARTHEN_SPIKE = formatKeybind("Cooldown", "Earthen Spike");
BINDING_NAME_OPT_FERAL_SPIRIT = formatKeybind("Cooldown", "Feral Spirit");
BINDING_NAME_OPT_FURY_OF_AIR = formatKeybind("Cooldown", "Fury of Air");
BINDING_NAME_OPT_SUNDERING = formatKeybind("Cooldown", "Sundering");
BINDING_NAME_OPT_WINDSONG = formatKeybind("Cooldown", "Windsong");

-- Warlock Keybind Labels
BINDING_NAME_OPT_EMPOWERED_LIFE_TAP = formatKeybind("Cooldown", "Empowered Life Tap");
BINDING_NAME_OPT_GREATER_DEMONS = formatKeybind("Cooldown", "Greater Demons");
BINDING_NAME_OPT_GRIMOIRE_SERVICE = formatKeybind("Cooldown", "Grimoire of Service");
BINDING_NAME_OPT_SOUL_HARVEST = formatKeybind("Cooldown", "Soul Harvest");
BINDING_NAME_OPT_DARK_PACT = formatKeybind("Defensive", "Dark Pact");
BINDING_NAME_OPT_UNENDING_RESOLVE = formatKeybind("Defensive", "Unending Resolve");
BINDING_NAME_OPT_LIFE_TAP= formatKeybind("Mana", "Life Tap");

BINDING_NAME_OPT_SEED_CORRUPTION = formatKeybind("AOE", "Seed of Corruption");
BINDING_NAME_OPT_PHANTOM_SINGULARITY = formatKeybind("AOE CD", "Phantom Singularity");
BINDING_NAME_OPT_HAUNT = formatKeybind("Cooldown", "Haunt");
BINDING_NAME_OPT_REAP_SOULS = formatKeybind("Cooldown", "Reap Souls");
BINDING_NAME_OPT_SOUL_EFFIGY = formatKeybind("Cooldown", "Soul Effigy");

BINDING_NAME_OPT_DEMONWRATH = formatKeybind("AOE", "Demonwrath");
BINDING_NAME_OPT_IMPLOSION = formatKeybind("AOE CD", "Implosion");
BINDING_NAME_OPT_DEMONIC_EMPOWERMENT = formatKeybind("Cooldown", "Demonic Empowerment");
BINDING_NAME_OPT_SHADOWFLAME = formatKeybind("Cooldown", "Shadowflame");
BINDING_NAME_OPT_SUMMON_DARKGLARE = formatKeybind("Cooldown", "Summon Darkglare");
BINDING_NAME_OPT_THALKIELS_CONSUMPTION = formatKeybind("Cooldown", "Thalkiel's Consumption");
BINDING_NAME_OPT_PET_FELSTORM = formatKeybind("Pet", "Felstorm");

BINDING_NAME_OPT_RAIN_OF_FIRE = formatKeybind("AOE", "Rain of Fire");
BINDING_NAME_OPT_CATACLYSM = formatKeybind("AOE CD", "Cataclysm");
BINDING_NAME_OPT_HAVOC = formatKeybind("AOE CD", "Havoc");
BINDING_NAME_OPT_CHANNEL_DEMONFIRE = formatKeybind("Cooldown", "Channel Demonfire");
BINDING_NAME_OPT_DIMESNIONAL_RIFT = formatKeybind("Cooldown", "Dimensional Rift");
BINDING_NAME_OPT_SHADOWBURN = formatKeybind("Cooldown", "Shadowburn");

-- Common Warrior Keybind Labels
BINDING_NAME_OPT_BLADESTORM = formatKeybind("AOE CD", "Bladestorm");
BINDING_NAME_OPT_HEROIC_THROW = formatKeybind("Display", "Heroic Throw");

-- Warrior Keybind Labels
BINDING_NAME_OPT_RAVAGER = formatKeybind("AOE CD", "Ravager");
BINDING_NAME_OPT_SHOCKWAVE = formatKeybind("AOE CD", "Shockwave");
BINDING_NAME_OPT_WARBREAKER = formatKeybind("AOE CD", "Warbreaker");
BINDING_NAME_OPT_WARBREAKER_DEBUFF = formatKeybind("Debuff", "Warbreaker");
BINDING_NAME_OPT_WEIGHT_OF_THE_EARTH_DEBUFF = formatKeybind("Debuff", "Weight Of The Earth");
BINDING_NAME_OPT_MORTAL_STRIKE_DELAY = formatKeybind("Delay", "Mortal Strike for Battle Cry");
BINDING_NAME_OPT_VICTORY_RUSH_HEAL = formatKeybind("Heal", "Victory Rush");

BINDING_NAME_OPT_DRAGON_ROAR = formatKeybind("AOE CD", "Dragon Roar");
BINDING_NAME_OPT_AVATAR = formatKeybind("Cooldown", "Avatar");
BINDING_NAME_OPT_BATTLE_CRY = formatKeybind("Cooldown", "Battle Cry");
BINDING_NAME_OPT_BLOODBATH = formatKeybind("Cooldown", "Bloodbath");