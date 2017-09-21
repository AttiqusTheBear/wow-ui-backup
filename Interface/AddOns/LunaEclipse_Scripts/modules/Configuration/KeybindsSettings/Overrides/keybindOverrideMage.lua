local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_MAGE then
	local functionsConfiguration = addonTable.functionsConfiguration;

	-- Common Mage SpellIDs
	local BLINK = 1953;
	local CONJURE_REFRESHMENT = 190336;
	local COUNTERSPELL = 2139;
	local FROST_NOVA = 122;
	local GREATER_INVISIBILITY = 110959;  -- Replacement
	local ICE_BLOCK = 45438;
	local INVISIBILITY = 66;
	local MIRROR_IMAGE = 55342;
	local POLYMORPH = 118;
	local POLYMORPH_BLACK_CAT = 61305;  -- Replacement
	local POLYMORPH_MONKEY = 161354;  -- Replacement
	local POLYMORPH_PEACOCK = 161372;  -- Replacement
	local POLYMORPH_PENGUIN = 161355;  -- Replacement
	local POLYMORPH_PIG = 28272;  -- Replacement
	local POLYMORPH_POLAR_BEAR_CUB = 161353;  -- Replacement
	local POLYMORPH_PORCUPINE = 126819;  -- Replacement
	local POLYMORPH_RABBIT = 61721;  -- Replacement
	local POLYMORPH_TURTLE = 28271;  -- Replacement
	local RING_OF_FROST = 113724;
	local RUNE_OF_POWER = 116011;
	local SHIMMER = 212653;  -- Replacement
	local SLOW_FALL = 130;
	local SPELLSTEAL = 30449;
	local TIME_WARP = 80353;

	-- Arcane Mage SpellIDs
	local ARCANE_BARRAGE = 44425;
	local ARCANE_BLAST = 30451;
	local ARCANE_EXPLOSION = 1449;
	local ARCANE_FAMILIAR = 205022;
	local ARCANE_MISSILES = 5143;
	local ARCANE_ORB = 153626;
	local ARCANE_POWER = 12042;
	local CHARGED_UP = 205032;
	local DISPLACEMENT = 195676;
	local EVOCATION = 12051;
	local MARK_OF_ALUNETH = 224968;
	local NETHER_TEMPEST = 114923;
	local PRESENCE_OF_MIND = 205025;
	local PRISMATIC_BARRIER = 235450;
	local SLOW = 31589;
	local SUPERNOVA = 157980;

	-- Fire Mage SpellIDs
	local BLAST_WAVE = 157981;
	local BLAZING_BARRIER = 235313;
	local CINDERSTORM = 198929;
	local COMBUSTION = 29977;
	local DRAGONS_BREATH = 31661;
	local FLAMESTRIKE = 2120;
	local FIRE_BLAST = 108853;
	local FIREBALL = 133;
	local LIVING_BOMB = 44457;
	local METEOR = 153561;
	local PHOENIXS_FLAMES = 194466;
	local PYROBLAST = 11366;
	local SCORCH = 2948;

	-- Frost Mage SpellIDs
	local BLIZZARD = 190356;
	local COLD_SNAP = 235219;
	local COMET_STORM = 153595;
	local CONE_OF_COLD = 120;
	local EBONBOLT = 214634;
	local FLURRY = 44614;
	local FROST_BOMB = 112948;
	local FROSTBOLT = 116;
	local FROZEN_ORB = 84714;
	local FROZEN_TOUCH = 205030;
	local GLACIAL_SPIKE = 199786;
	local ICE_BARRIER = 11426;
	local ICE_FLOES = 108839;
	local ICE_LANCE = 30455;
	local ICE_NOVA = 157997;
	local ICY_VEINS = 12472;
	local RAY_OF_FROST = 205021;
	local SUMMON_WATER_ELEMENTAL = 31687;
	local WATER_JET = 135029;
	local FREEZE = 33395;

	addonTable.replacementMage = {
		[SHIMMER] = BLINK,
		[POLYMORPH_BLACK_CAT] = POLYMORPH,
		[POLYMORPH_MONKEY] = POLYMORPH,
		[POLYMORPH_PEACOCK] = POLYMORPH,
		[POLYMORPH_PENGUIN] = POLYMORPH,
		[POLYMORPH_PIG] = POLYMORPH,
		[POLYMORPH_POLAR_BEAR_CUB] = POLYMORPH,
		[POLYMORPH_PORCUPINE] = POLYMORPH,
		[POLYMORPH_RABBIT] = POLYMORPH,
		[POLYMORPH_TURTLE] = POLYMORPH,
		[GREATER_INVISIBILITY] = INVISIBILITY,
	};

	addonTable.commonMage = {
		type = "group",
		name = KEYBIND_OVERRIDE_MAGE_COMMON,
		inline = true,
		order = 20,
		args = {
			BLINK = {
				type = "keybinding",
				name = "Blink",
				desc = functionsConfiguration:getKeybindTooltip("Blink"),
				arg = BLINK,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			CONJURE_REFRESHMENT = {
				type = "keybinding",
				name = "Conjure Refreshment",
				desc = functionsConfiguration:getKeybindTooltip("Conjure Refreshment"),
				arg = CONJURE_REFRESHMENT,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			COUNTERSPELL = {
				type = "keybinding",
				name = "Counterspell",
				desc = functionsConfiguration:getKeybindTooltip("Counterspell"),
				arg = COUNTERSPELL,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			FROST_NOVA = {
				type = "keybinding",
				name = "Frost Nova",
				desc = functionsConfiguration:getKeybindTooltip("Frost Nova"),
				arg = FROST_NOVA,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			ICE_BLOCK = {
				type = "keybinding",
				name = "Ice Block",
				desc = functionsConfiguration:getKeybindTooltip("Ice Block"),
				arg = ICE_BLOCK,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			INVISIBILITY = {
				type = "keybinding",
				name = "Invisibility",
				desc = functionsConfiguration:getKeybindTooltip("Invisibility"),
				arg = INVISIBILITY,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			MIRROR_IMAGE = {
				type = "keybinding",
				name = "Mirror Image",
				desc = functionsConfiguration:getKeybindTooltip("Mirror Image"),
				arg = MIRROR_IMAGE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			POLYMORPH = {
				type = "keybinding",
				name = "Polymorph",
				desc = functionsConfiguration:getKeybindTooltip("Polymorph"),
				arg = POLYMORPH,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			RING_OF_FROST = {
				type = "keybinding",
				name = "Ring of Frost",
				desc = functionsConfiguration:getKeybindTooltip("Ring of Frost"),
				arg = RING_OF_FROST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			RUNE_OF_POWER = {
				type = "keybinding",
				name = "Rune of Power",
				desc = functionsConfiguration:getKeybindTooltip("Rune of Power"),
				arg = RUNE_OF_POWER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			SLOW_FALL = {
				type = "keybinding",
				name = "Slow Fall",
				desc = functionsConfiguration:getKeybindTooltip("Slow Fall"),
				arg = SLOW_FALL,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			SPELLSTEAL = {
				type = "keybinding",
				name = "Spellsteal",
				desc = functionsConfiguration:getKeybindTooltip("Spellsteal"),
				arg = SPELLSTEAL,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
			TIME_WARP = {
				type = "keybinding",
				name = "Time Warp",
				desc = functionsConfiguration:getKeybindTooltip("Time Warp"),
				arg = TIME_WARP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 170,
			},
		},
	};

	addonTable.arcaneMage = {
		type = "group",
		name = KEYBIND_OVERRIDE_MAGE_ARCANE,
		inline = true,
		order = 30,
		args = {
			ARCANE_BARRAGE = {
				type = "keybinding",
				name = "Arcane Barrage",
				desc = functionsConfiguration:getKeybindTooltip("Arcane Barrage"),
				arg = ARCANE_BARRAGE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			ARCANE_BLAST = {
				type = "keybinding",
				name = "Arcane Blast",
				desc = functionsConfiguration:getKeybindTooltip("Arcane Blast"),
				arg = ARCANE_BLAST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			ARCANE_EXPLOSION = {
				type = "keybinding",
				name = "Arcane Explosion",
				desc = functionsConfiguration:getKeybindTooltip("Arcane Explosion"),
				arg = ARCANE_EXPLOSION,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			ARCANE_FAMILIAR = {
				type = "keybinding",
				name = "Arcane Familar",
				desc = functionsConfiguration:getKeybindTooltip("Arcane Familar"),
				arg = ARCANE_FAMILIAR,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			ARCANE_MISSILES = {
				type = "keybinding",
				name = "Arcane Missiles",
				desc = functionsConfiguration:getKeybindTooltip("Arcane Missiles"),
				arg = ARCANE_MISSILES,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			ARCANE_ORB = {
				type = "keybinding",
				name = "Arcane Orb",
				desc = functionsConfiguration:getKeybindTooltip("Arcane Orb"),
				arg = ARCANE_ORB,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			ARCANE_POWER = {
				type = "keybinding",
				name = "Arcane Power",
				desc = functionsConfiguration:getKeybindTooltip("Arcane Power"),
				arg = ARCANE_POWER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			CHARGED_UP = {
				type = "keybinding",
				name = "Charged Up",
				desc = functionsConfiguration:getKeybindTooltip("Charged Up"),
				arg = CHARGED_UP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			DISPLACEMENT = {
				type = "keybinding",
				name = "Displacement",
				desc = functionsConfiguration:getKeybindTooltip("Displacement"),
				arg = DISPLACEMENT,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			EVOCATION = {
				type = "keybinding",
				name = "Evocation",
				desc = functionsConfiguration:getKeybindTooltip("Evocation"),
				arg = EVOCATION,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			MARK_OF_ALUNETH = {
				type = "keybinding",
				name = "Mark of Aluneth",
				desc = functionsConfiguration:getKeybindTooltip("Mark of Aluneth"),
				arg = MARK_OF_ALUNETH,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			NETHER_TEMPEST = {
				type = "keybinding",
				name = "Nether Tempest",
				desc = functionsConfiguration:getKeybindTooltip("Nether Tempest"),
				arg = NETHER_TEMPEST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
			PRESENCE_OF_MIND = {
				type = "keybinding",
				name = "Presence of Mind",
				desc = functionsConfiguration:getKeybindTooltip("Presence of Mind"),
				arg = PRESENCE_OF_MIND,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 130,
			},
			PRISMATIC_BARRIER = {
				type = "keybinding",
				name = "Prismatic Barrier",
				desc = functionsConfiguration:getKeybindTooltip("Prismatic Barrier"),
				arg = PRISMATIC_BARRIER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 140,
			},
			SLOW = {
				type = "keybinding",
				name = "Slow",
				desc = functionsConfiguration:getKeybindTooltip("Slow"),
				arg = SLOW,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 150,
			},
			SUPERNOVA = {
				type = "keybinding",
				name = "Supernova",
				desc = functionsConfiguration:getKeybindTooltip("Supernova"),
				arg = SUPERNOVA,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 160,
			},
		},
	};

	addonTable.fireMage = {
		type = "group",
		name = KEYBIND_OVERRIDE_MAGE_FIRE,
		inline = true,
		order = 40,
		args = {
			BLAST_WAVE = {
				type = "keybinding",
				name = "Blast Wave",
				desc = functionsConfiguration:getKeybindTooltip("Blast Wave"),
				arg = BLAST_WAVE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			BLAZING_BARRIER = {
				type = "keybinding",
				name = "Blazing Barrier",
				desc = functionsConfiguration:getKeybindTooltip("Blazing Barrier"),
				arg = BLAZING_BARRIER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			CINDERSTORM = {
				type = "keybinding",
				name = "Cinderstorm",
				desc = functionsConfiguration:getKeybindTooltip("Cinderstorm"),
				arg = CINDERSTORM,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			COMBUSTION = {
				type = "keybinding",
				name = "Combustion",
				desc = functionsConfiguration:getKeybindTooltip("Combustion"),
				arg = COMBUSTION,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			DRAGONS_BREATH = {
				type = "keybinding",
				name = "Dragon's Breath",
				desc = functionsConfiguration:getKeybindTooltip("Dragon's Breath"),
				arg = DRAGONS_BREATH,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			FLAMESTRIKE = {
				type = "keybinding",
				name = "Flamestrike",
				desc = functionsConfiguration:getKeybindTooltip("Flamestrike"),
				arg = FLAMESTRIKE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			FIRE_BLAST = {
				type = "keybinding",
				name = "Fire Blast",
				desc = functionsConfiguration:getKeybindTooltip("Fire Blast"),
				arg = FIRE_BLAST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			FIREBALL = {
				type = "keybinding",
				name = "Fireball",
				desc = functionsConfiguration:getKeybindTooltip("Fireball"),
				arg = FIREBALL,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			LIVING_BOMB = {
				type = "keybinding",
				name = "Living Bomb",
				desc = functionsConfiguration:getKeybindTooltip("Living Bomb"),
				arg = LIVING_BOMB,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			METEOR = {
				type = "keybinding",
				name = "Meteor",
				desc = functionsConfiguration:getKeybindTooltip("Meteor"),
				arg = METEOR,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			PHOENIXS_FLAMES = {
				type = "keybinding",
				name = "Phoenix's Flames",
				desc = functionsConfiguration:getKeybindTooltip("Phoenix's Flames"),
				arg = PHOENIXS_FLAMES,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			PYROBLAST = {
				type = "keybinding",
				name = "Pyroblast",
				desc = functionsConfiguration:getKeybindTooltip("Pyroblast"),
				arg = PYROBLAST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
			SCORCH = {
				type = "keybinding",
				name = "Scorch",
				desc = functionsConfiguration:getKeybindTooltip("Scorch"),
				arg = SCORCH,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 130,
			},
		},
	};

	addonTable.frostMage = {
		type = "group",
		name = KEYBIND_OVERRIDE_MAGE_FROST,
		inline = true,
		order = 50,
		args = {
			BLIZZARD = {
				type = "keybinding",
				name = "Blizzard",
				desc = functionsConfiguration:getKeybindTooltip("Blizzard"),
				arg = BLIZZARD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			COLD_SNAP = {
				type = "keybinding",
				name = "Cold Snap",
				desc = functionsConfiguration:getKeybindTooltip("Cold Snap"),
				arg = COLD_SNAP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			COMET_STORM = {
				type = "keybinding",
				name = "Comet Storm",
				desc = functionsConfiguration:getKeybindTooltip("Comet Storm"),
				arg = COMET_STORM,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			CONE_OF_COLD = {
				type = "keybinding",
				name = "Cone of Cold",
				desc = functionsConfiguration:getKeybindTooltip("Cone of Cold"),
				arg = CONE_OF_COLD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			EBONBOLT = {
				type = "keybinding",
				name = "Ebonbolt",
				desc = functionsConfiguration:getKeybindTooltip("Ebonbolt"),
				arg = EBONBOLT,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			FLURRY = {
				type = "keybinding",
				name = "Flurry",
				desc = functionsConfiguration:getKeybindTooltip("Flurry"),
				arg = FLURRY,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			FROST_BOMB = {
				type = "keybinding",
				name = "Frost Bomb",
				desc = functionsConfiguration:getKeybindTooltip("Frost Bomb"),
				arg = FROST_BOMB,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			FROSTBOLT = {
				type = "keybinding",
				name = "Frostbolt",
				desc = functionsConfiguration:getKeybindTooltip("Frostbolt"),
				arg = FROSTBOLT,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			FROZEN_ORB = {
				type = "keybinding",
				name = "Frozen Orb",
				desc = functionsConfiguration:getKeybindTooltip("Frozen Orb"),
				arg = FROZEN_ORB,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			FROZEN_TOUCH = {
				type = "keybinding",
				name = "Frozen Touch",
				desc = functionsConfiguration:getKeybindTooltip("Frozen Touch"),
				arg = FROZEN_TOUCH,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			GLACIAL_SPIKE = {
				type = "keybinding",
				name = "Glacial Spike",
				desc = functionsConfiguration:getKeybindTooltip("Glacial Spike"),
				arg = GLACIAL_SPIKE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			ICE_BARRIER = {
				type = "keybinding",
				name = "Ice Barrier",
				desc = functionsConfiguration:getKeybindTooltip("Ice Barrier"),
				arg = ICE_BARRIER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
			ICE_FLOES = {
				type = "keybinding",
				name = "Ice Floes",
				desc = functionsConfiguration:getKeybindTooltip("Ice Floes"),
				arg = ICE_FLOES,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 130,
			},
			ICE_LANCE = {
				type = "keybinding",
				name = "Ice Lance",
				desc = functionsConfiguration:getKeybindTooltip("Ice Lance"),
				arg = ICE_LANCE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 140,
			},
			ICE_NOVA = {
				type = "keybinding",
				name = "Ice Nova",
				desc = functionsConfiguration:getKeybindTooltip("Ice Nova"),
				arg = ICE_NOVA,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 150,
			},
			ICY_VEINS = {
				type = "keybinding",
				name = "Icy Veins",
				desc = functionsConfiguration:getKeybindTooltip("Icy Veins"),
				arg = ICY_VEINS,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 160,
			},
			RAY_OF_FROST = {
				type = "keybinding",
				name = "Ray pf Frost",
				desc = functionsConfiguration:getKeybindTooltip("Ray of Frost"),
				arg = RAY_OF_FROST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 170,
			},
			SUMMON_WATER_ELEMENTAL = {
				type = "keybinding",
				name = "Summon Water Elemental",
				desc = functionsConfiguration:getKeybindTooltip("Summon Water Elemental"),
				arg = SUMMON_WATER_ELEMENTAL,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 180,
			},
			FREEZE = {
				type = "keybinding",
				name = "Water Elemental - Freeze",
				desc = functionsConfiguration:getKeybindTooltip("Water Elemental - Freeze"),
				arg = FREEZE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 190,
			},
			WATER_JET = {
				type = "keybinding",
				name = "Water Elemental - Water Jet",
				desc = functionsConfiguration:getKeybindTooltip("Water Elemental - Water Jet"),
				arg = WATER_JET,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 200,
			},
		},
	};
end