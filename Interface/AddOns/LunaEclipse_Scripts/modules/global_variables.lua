local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.

-- Current WoW Version
addonTable.CURRENT_WOW_VERSION = math.max(select(4, GetBuildInfo()), 70205);

-- WoW Version Constraints
addonTable.WOW_VERSION_MIN = 70000;
addonTable.WOW_VERSION_MAX = 79999;

-- Required Ovale Version
addonTable.REQUIRED_OVALE_VERSION = "7.2.3.1";

-- Base Mana by level for all classes, casters is multiplied by 5.
addonTable.BASE_MANA = { 31, 34, 36, 42, 71, 101, 104, 137, 140, 173, 176, 212, 220, 252, 256, 292, 298, 334, 362, 400, 420, 460, 480, 520, 580, 620, 620, 660, 740, 780, 780, 840, 880, 940, 980, 1020, 1040, 1080, 1180, 1240, 1240, 1300, 1360, 1420, 1480, 1540, 1600, 1660, 1720, 1780, 1840, 1920, 1940, 2040, 2060, 2140, 2200, 2280, 2360, 2420, 2600, 2760, 2920, 2940, 3020, 3020, 3080, 3100, 3260, 3380, 3520, 3700, 3860, 3880, 4060, 4180, 4360, 4600, 4680, 4880, 5100, 5280, 5520, 5780, 6000, 6400, 6600, 6800, 7200, 7400, 10200, 13000, 15600, 19400, 24000, 27600, 28800, 30000, 31000, 32000, 76000, 86000, 100000, 114000, 128000, 140000, 160000, 180000, 200000, 220000 };

-- Code for debugging Enemies
addonTable.DEBUG_ENEMIES = false;

-- Global Cooldown SpellID
addonTable.SPELLID_GLOBAL_COOLDOWN = 61304;

-- ClassID's
addonTable.CLASS_WARRIOR = 1;
addonTable.CLASS_PALADIN = 2;
addonTable.CLASS_HUNTER = 3;
addonTable.CLASS_ROGUE = 4;
addonTable.CLASS_PRIEST = 5;
addonTable.CLASS_DEATHKNIGHT = 6;
addonTable.CLASS_SHAMAN = 7;
addonTable.CLASS_MAGE = 8;
addonTable.CLASS_WARLOCK = 9;
addonTable.CLASS_MONK = 10;
addonTable.CLASS_DRUID = 11;
addonTable.CLASS_DEMONHUNTER = 12;

-- SpecID's
addonTable.DEATHKNIGHT_BLOOD = 250;
addonTable.DEATHKNIGHT_FROST = 251;
addonTable.DEATHKNIGHT_UNHOLY = 252;

addonTable.DEMONHUNTER_HAVOC = 577;
addonTable.DEMONHUNTER_VENGEANCE = 581;

addonTable.DRUID_BALANCE = 102;
addonTable.DRUID_FERAL = 103;
addonTable.DRUID_GUARDIAN = 104;
addonTable.DRUID_RESTORATION = 105;

addonTable.HUNTER_BEASTMASTERY = 253;
addonTable.HUNTER_MARKSMANSHIP = 254;
addonTable.HUNTER_SURVIVAL = 255;

addonTable.MAGE_ARCANE = 62;
addonTable.MAGE_FIRE = 63;
addonTable.MAGE_FROST = 64;

addonTable.MONK_BREWMASTER = 268;
addonTable.MONK_MISTWEAVER = 270;
addonTable.MONK_WINDWALKER = 269;

addonTable.PALADIN_HOLY = 65;
addonTable.PALADIN_PROTECTION = 66;
addonTable.PALADIN_RETRIBUTION = 70;

addonTable.PRIEST_DISCIPLINE = 256;
addonTable.PRIEST_HOLY = 257;
addonTable.PRIEST_SHADOW = 258;

addonTable.ROGUE_ASSASSINATION = 259;
addonTable.ROGUE_OUTLAW = 260;
addonTable.ROGUE_SUBTLETY = 261;

addonTable.SHAMAN_ELEMENTAL = 262;
addonTable.SHAMAN_ENHANCEMENT = 263;
addonTable.SHAMAN_RESTORATION = 264;

addonTable.WARLOCK_AFFLICTION = 265;
addonTable.WARLOCK_DEMONOLOGY = 266;
addonTable.WARLOCK_DESTRUCTION = 267;

addonTable.WARRIOR_ARMS = 71;
addonTable.WARRIOR_FURY = 72;
addonTable.WARRIOR_PROTECTION = 73;

-- Table forholding details about scripts.
addonTable.scriptInfo = {};

-- Table for holding preset builds.
addonTable.presetBuilds = {};

-- Table for holding Script configuration settings.
addonTable.scriptSettings = {};

-- Table for storing the script to load for each specialization.
addonTable.DEFAULT_SCRIPT = {};

-- GUID Type Constants.
addonTable.GUID_GAMEOBJECT = "GameObject";
addonTable.GUID_NPC = "Creature";
addonTable.GUID_PET = "Pet";
addonTable.GUID_PLAYER = "Player";
addonTable.GUID_VEHICLE = "Vehicle";
addonTable.GUID_VIGNETTE = "Vignette";

-- Color Variables
addonTable.TEXT_COLOR_TAG_ACTIVE = string.format("%s%s%s%s%s", "|c", "FF", "00", "FF", "00");
addonTable.TEXT_COLOR_TAG_INACTIVE = string.format("%s%s%s%s%s", "|c", "FF", "FF", "00", "00");	
addonTable.TEXT_COLOR_TAG_DEFAULT = string.format("%s%s%s%s%s", "|c","FF", "7F", "CC", "FF");
addonTable.TEXT_COLOR_TAG_HIGHLIGHT = string.format("%s%s%s%s%s", "|c", "FF", "17", "84", "D1");
addonTable.TEXT_COLOR_TAG_MESSAGE = string.format("%s%s%s%s%s", "|c", "FF", "FF", "FF", "00");
addonTable.TEXT_COLOR_TAG_END = "|r";

-- Class Colours
addonTable.CLASS_COLOUR_CODES = {
	[addonTable.CLASS_WARRIOR] = string.format("%s%s%s%s%s", "|c", "FF", "C7", "9C", "6E"),
	[addonTable.CLASS_PALADIN] = string.format("%s%s%s%s%s", "|c", "FF", "F5", "8C", "BA"),
	[addonTable.CLASS_HUNTER] = string.format("%s%s%s%s%s", "|c", "FF", "AB", "D4", "73"),
	[addonTable.CLASS_ROGUE] = string.format("%s%s%s%s%s", "|c", "FF", "FF", "F5", "69"),
	[addonTable.CLASS_PRIEST] = string.format("%s%s%s%s%s", "|c", "FF", "FF", "FF", "FF"),
	[addonTable.CLASS_DEATHKNIGHT] = string.format("%s%s%s%s%s", "|c", "FF", "C4", "1F", "3B"),
	[addonTable.CLASS_SHAMAN] = string.format("%s%s%s%s%s", "|c", "FF", "00", "70", "DE"),
	[addonTable.CLASS_MAGE] = string.format("%s%s%s%s%s", "|c", "FF", "69", "CC", "F0"),
	[addonTable.CLASS_WARLOCK] = string.format("%s%s%s%s%s", "|c", "FF", "94", "82", "C9"),
	[addonTable.CLASS_MONK] = string.format("%s%s%s%s%s", "|c", "FF", "00", "FF", "96"),
	[addonTable.CLASS_DRUID] = string.format("%s%s%s%s%s", "|c", "FF", "FF", "7D", "0A"),
	[addonTable.CLASS_DEMONHUNTER] = string.format("%s%s%s%s%s", "|c", "FF", "A3", "30", "C9"),
};

-- Build Constants
addonTable.CUSTOM_BUILD = "Custom Build";

-- Ovale Custom Script Constants
addonTable.CUSTOM_NAME = "custom"
addonTable.CUSTOM_DESCRIPTION = "Custom Script";

-- Message Constants
addonTable.MESSAGE_INDENT = "     ";

-- Addon Messages
addonTable.LECS_DEBUG = "LE_DEBUG";
addonTable.LECS_MINIMAP_TOGGLE = "LECS_MINIMAP_TOGGLE";

addonTable.OVALE_ALPHA = 1;
addonTable.OVALE_BETA = 2;
addonTable.OVALE_RELEASE = 3;

-- Popup Dialog Boxes
StaticPopupDialogs["LECS_TALENT_CHANGES_NO_TALENT_BUILD"] = {
	text = "No talent build specified!",
	button1 = "OK",
	timeout = 15,
	whileDead = true,
	hideOnEscape = true,
};

StaticPopupDialogs["LECS_TALENT_CHANGES_NOT_PERMITTED"] = {
	text = "Talent changes are not currently permitted!",
	button1 = "OK",
	timeout = 15,
	whileDead = true,
	hideOnEscape = true,
};

StaticPopupDialogs["LECS_TALENT_CHANGES_TALENT_BUILD_UNAVAILABLE"] = {
	text = "Talent build not available!",
	button1 = "OK",
	timeout = 15,
	whileDead = true,
	hideOnEscape = true,
};

StaticPopupDialogs["LECS_TALENT_CHANGES_FAILED"] = {
	text = string.join("", "Unable to apply the %s build as the following talents, %s were locked.", "\n\n", "This is most likely because a ", addonTable.TEXT_COLOR_TAG_ACTIVE, "related spell is on cooldown", addonTable.TEXT_COLOR_TAG_END, ".", "\n\n", "Please try again later!"),
	button1 = "OK",
	timeout = 15,
	whileDead = true,
	hideOnEscape = true,
};

StaticPopupDialogs["LECS_TOGGLE_MINIMAP"] = {
    text = string.format("%s%s%s%s", "A Reload UI is required for the icon to become visible when using MiniMap icon manager addons.", "\n\n", "Do you wish to reload now?", "\n\n"),
    button1	= "Yes",
    button2	= "No",
    OnAccept = function(self) 
					ReloadUI(); 
				end,
    timeout	= 15,
    whileDead = true,
    hideOnEscape = true,
};