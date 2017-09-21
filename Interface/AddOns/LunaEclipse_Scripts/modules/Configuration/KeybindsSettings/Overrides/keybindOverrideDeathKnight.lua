local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_DEATHKNIGHT then
	local functionsConfiguration = addonTable.functionsConfiguration;

	-- Common Death Knight SpellIDs
	local ANTI_MAGIC_SHELL = 48707;
	local ASPHYXIATE = 221562;
	local ASPHYXIATE_UNHOLY = 108194;  -- Replacement
	local CHAINS_OF_ICE = 45524;
	local CONTROL_UNDEAD = 111673;
	local DARK_COMMAND = 56222;
	local DEATH_AND_DECAY = 43265;
	local DEATH_GRIP = 49576;
	local DEATH_STRIKE = 49998;
	local ICEBOUND_FORTITUDE = 48792;
	local MIND_FREEZE = 47528;
	local PATH_OF_FROST = 3714;
	local RAISE_ALLY = 61999;
	local WRAITH_WALK = 212552;

	-- Blood Death Knight SpellIDs
	local BLOOD_BOIL = 50842;
	local BLOOD_MIRROR = 206977;
	local BLOOD_TAP = 221699;
	local BLOODDRINKER = 206931;
	local BONESTORM = 194844;
	local CONSUMPTION = 205223;
	local DANCING_RUNE_WEAPON = 49028;
	local DEATHS_CARESS = 195292;
	local GOREFIENDS_GRASP = 108199;
	local HEART_STRIKE = 206930;
	local MARK_OF_BLOOD = 206940;
	local MARROWREND = 195182;
	local RUNE_TAP = 194679;
	local SOULGORGE = 212744;
	local TOMBSTONE = 219809;
	local VAMPIRIC_BLOOD = 55233;

	-- Frost Death Knight SpellIDs
	local BLINDING_SLEET = 207167;
	local BREATH_OF_SINDRAGOSA = 152279;
	local EMPOWER_RUNE_WEAPON = 47568;
	local FROST_STRIKE = 49143;
	local FROSTSCYTHE = 207230;
	local GLACIAL_ADVANCE = 194913;
	local HORN_OF_WINTER = 57330;
	local HOWLING_BLAST = 49184;
	local HUNGERING_RUNE_WEAPON = 207127;  -- Replacement
	local OBLITERATE = 49020;
	local OBLITERATION = 207256;
	local PILLAR_OF_FROST = 51271;
	local REMORSELESS_WINTER = 196770;
	local SINDRAGOSAS_FURY = 190778;

	-- Unholy Death Knight SpellIDs
	local APOCALYPSE = 220143;
	local ARMY_OF_THE_DEAD = 42650;
	local BLIGHTED_RUNE_WEAPON = 194918;
	local CLAWING_SHADOWS = 207311;  -- Replacement
	local CORPSE_SHIELD = 207319;
	local DARK_ARBITER = 207349;  -- Replacement
	local DARK_TRANSFORMATION = 63560;
	local DEATH_COIL = 47541;
	local DEFILE = 152280;  -- Replacement
	local EPIDEMIC = 207317;
	local FESTERING_STRIKE = 85948;
	local OUTBREAK = 77575;
	local RAISE_DEAD = 46584;
	local SCOURGE_STRIKE = 55090;
	local SOUL_REAPER = 130736;
	local SUMMON_GARGOYLE = 49206;

	addonTable.replacementDeathKnight = {
		[ASPHYXIATE_UNHOLY] = ASPHYXIATE,
		[CLAWING_SHADOWS] = SCOURGE_STRIKE,
		[DARK_ARBITER] = SUMMON_GARGOYLE,
		[DEFILE] = DEATH_AND_DECAY,
		[HUNGERING_RUNE_WEAPON] = EMPOWER_RUNE_WEAPON,
	};

	addonTable.commonDeathKnight = {
		type = "group",
		name = KEYBIND_OVERRIDE_DEATH_KNIGHT_COMMON,
		inline = true,
		order = 20,
		args = {
			ANTI_MAGIC_SHELL = {
				type = "keybinding",
				name = "Anti-Magic Shell",
				desc = functionsConfiguration:getKeybindTooltip("Anti-Magic Shell"),
				arg = ANTI_MAGIC_SHELL,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			ASPHYXIATE = {
				type = "keybinding",
				name = "Asphyxiate",
				desc = functionsConfiguration:getKeybindTooltip("Asphyxiate"),
				arg = ASPHYXIATE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			CHAINS_OF_ICE = {
				type = "keybinding",
				name = "Chains of Ice",
				desc = functionsConfiguration:getKeybindTooltip("Chains of Ice"),
				arg = CHAINS_OF_ICE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			DARK_COMMAND = {
				type = "keybinding",
				name = "Dark Command",
				desc = functionsConfiguration:getKeybindTooltip("Dark Command"),
				arg = DARK_COMMAND,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			DEATH_AND_DECAY = {
				type = "keybinding",
				name = "Death and Decay",
				desc = functionsConfiguration:getKeybindTooltip("Death and Decay"),
				arg = DEATH_AND_DECAY,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			DEATH_GRIP = {
				type = "keybinding",
				name = "Death Grip",
				desc = functionsConfiguration:getKeybindTooltip("Death Grip"),
				arg = DEATH_GRIP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			DEATH_STRIKE = {
				type = "keybinding",
				name = "Death Strike",
				desc = functionsConfiguration:getKeybindTooltip("Death Strike"),
				arg = DEATH_STRIKE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			ICEBOUND_FORTITUDE = {
				type = "keybinding",
				name = "Icebound Fortitude",
				desc = functionsConfiguration:getKeybindTooltip("Icebound Fortitude"),
				arg = ICEBOUND_FORTITUDE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			MIND_FREEZE = {
				type = "keybinding",
				name = "Mind Freeze",
				desc = functionsConfiguration:getKeybindTooltip("Mind Freeze"),
				arg = MIND_FREEZE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			PATH_OF_FROST = {
				type = "keybinding",
				name = "Path of Frost",
				desc = functionsConfiguration:getKeybindTooltip("Path of Frost"),
				arg = PATH_OF_FROST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			RAISE_ALLY = {
				type = "keybinding",
				name = "Raise Ally",
				desc = functionsConfiguration:getKeybindTooltip("Raise Ally"),
				arg = RAISE_ALLY,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			WRAITH_WALK = {
				type = "keybinding",
				name = "Wraith Walk",
				desc = functionsConfiguration:getKeybindTooltip("Wraith Walk"),
				arg = WRAITH_WALK,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
		},
	};

	addonTable.bloodDeathKnight = {
		type = "group",
		name = KEYBIND_OVERRIDE_DEATH_KNIGHT_BLOOD,
		inline = true,
		order = 30,
		args = {
			BLOOD_BOIL = {
				type = "keybinding",
				name = "Blood Boil",
				desc = functionsConfiguration:getKeybindTooltip("Blood Boil"),
				arg = BLOOD_BOIL,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			BLOOD_MIRROR = {
				type = "keybinding",
				name = "Blood Mirror",
				desc = functionsConfiguration:getKeybindTooltip("Blood Mirror"),
				arg = BLOOD_MIRROR,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			BLOOD_TAP = {
				type = "keybinding",
				name = "Blood Tap",
				desc = functionsConfiguration:getKeybindTooltip("Blood Tap"),
				arg = BLOOD_TAP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			BLOODDRINKER = {
				type = "keybinding",
				name = "Blooddrinker",
				desc = functionsConfiguration:getKeybindTooltip("Blooddrinker"),
				arg = BLOODDRINKER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			BONESTORM = {
				type = "keybinding",
				name = "Bonestorm",
				desc = functionsConfiguration:getKeybindTooltip("Bonestorm"),
				arg = BONESTORM,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			CONSUMPTION = {
				type = "keybinding",
				name = "Consumption",
				desc = functionsConfiguration:getKeybindTooltip("Consumption"),
				arg = CONSUMPTION,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			DANCING_RUNE_WEAPON = {
				type = "keybinding",
				name = "Dancing Rune Weapon",
				desc = functionsConfiguration:getKeybindTooltip("Dancing Rune Weapon"),
				arg = DANCING_RUNE_WEAPON,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			DEATHS_CARESS = {
				type = "keybinding",
				name = "Death's Caress",
				desc = functionsConfiguration:getKeybindTooltip("Death's Caress"),
				arg = DEATHS_CARESS,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			GOREFIENDS_GRASP = {
				type = "keybinding",
				name = "Gorefiend's Grasp",
				desc = functionsConfiguration:getKeybindTooltip("Gorefiend's Grasp"),
				arg = GOREFIENDS_GRASP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			HEART_STRIKE = {
				type = "keybinding",
				name = "Heart Strike",
				desc = functionsConfiguration:getKeybindTooltip("Heart Strike"),
				arg = HEART_STRIKE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			MARK_OF_BLOOD = {
				type = "keybinding",
				name = "Mark of Blood",
				desc = functionsConfiguration:getKeybindTooltip("Mark of Blood"),
				arg = MARK_OF_BLOOD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			MARROWREND = {
				type = "keybinding",
				name = "Marrowrend",
				desc = functionsConfiguration:getKeybindTooltip("Marrowrend"),
				arg = MARROWREND,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
			RUNE_TAP = {
				type = "keybinding",
				name = "Rune Tap",
				desc = functionsConfiguration:getKeybindTooltip("Rune Tap"),
				arg = RUNE_TAP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 130,
			},
			SOULGORGE = {
				type = "keybinding",
				name = "Soulgorge",
				desc = functionsConfiguration:getKeybindTooltip("Soulgorge"),
				arg = SOULGORGE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 140,
			},
			TOMBSTONE = {
				type = "keybinding",
				name = "Tombstone",
				desc = functionsConfiguration:getKeybindTooltip("Tombstone"),
				arg = TOMBSTONE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 150,
			},
			VAMPIRIC_BLOOD = {
				type = "keybinding",
				name = "Vampiric Blood",
				desc = functionsConfiguration:getKeybindTooltip("Vampiric Blood"),
				arg = VAMPIRIC_BLOOD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 160,
			},
		},
	};

	addonTable.frostDeathKnight = {
		type = "group",
		name = KEYBIND_OVERRIDE_DEATH_KNIGHT_FROST,
		inline = true,
		order = 40,
		args = {
			BLINDING_SLEET = {
				type = "keybinding",
				name = "Blinding Sleet",
				desc = functionsConfiguration:getKeybindTooltip("Blinding Sleet"),
				arg = BLINDING_SLEET,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			BREATH_OF_SINDRAGOSA = {
				type = "keybinding",
				name = "Breath of Sindragosa",
				desc = functionsConfiguration:getKeybindTooltip("Breath of Sindragosa"),
				arg = BREATH_OF_SINDRAGOSA,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			EMPOWER_RUNE_WEAPON = {
				type = "keybinding",
				name = "Empower Rune Weapon",
				desc = functionsConfiguration:getKeybindTooltip("Empower Rune Weapon"),
				arg = EMPOWER_RUNE_WEAPON,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			FROST_STRIKE = {
				type = "keybinding",
				name = "Frost Strike",
				desc = functionsConfiguration:getKeybindTooltip("Frost Strike"),
				arg = FROST_STRIKE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			FROSTSCYTHE = {
				type = "keybinding",
				name = "Frostscythe",
				desc = functionsConfiguration:getKeybindTooltip("Frostscythe"),
				arg = FROSTSCYTHE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			GLACIAL_ADVANCE = {
				type = "keybinding",
				name = "Glacial Advance",
				desc = functionsConfiguration:getKeybindTooltip("Glacial Advance"),
				arg = GLACIAL_ADVANCE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			HORN_OF_WINTER = {
				type = "keybinding",
				name = "Horn of Winter",
				desc = functionsConfiguration:getKeybindTooltip("Horn of Winter"),
				arg = HORN_OF_WINTER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			HOWLING_BLAST = {
				type = "keybinding",
				name = "Howling Blast",
				desc = functionsConfiguration:getKeybindTooltip("Howling Blast"),
				arg = HOWLING_BLAST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			OBLITERATE = {
				type = "keybinding",
				name = "Obliterate",
				desc = functionsConfiguration:getKeybindTooltip("Obliterate"),
				arg = OBLITERATE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			OBLITERATION = {
				type = "keybinding",
				name = "Obliteration",
				desc = functionsConfiguration:getKeybindTooltip("Obliteration"),
				arg = OBLITERATION,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			PILLAR_OF_FROST = {
				type = "keybinding",
				name = "Pillar of Frost",
				desc = functionsConfiguration:getKeybindTooltip("Pillar of Frost"),
				arg = PILLAR_OF_FROST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			REMORSELESS_WINTER = {
				type = "keybinding",
				name = "Remorseless Winter",
				desc = functionsConfiguration:getKeybindTooltip("Remorseless Winter"),
				arg = REMORSELESS_WINTER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
			SINDRAGOSAS_FURY = {
				type = "keybinding",
				name = "Sindragosa's Fury",
				desc = functionsConfiguration:getKeybindTooltip("Sindragosa's Fury"),
				arg = SINDRAGOSAS_FURY,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 130,
			},
		},
	};

	addonTable.unholyDeathKnight = {
		type = "group",
		name = KEYBIND_OVERRIDE_DEATH_KNIGHT_UNHOLY,
		inline = true,
		order = 50,
		args = {
			APOCALYPSE = {
				type = "keybinding",
				name = "Apocalypse",
				desc = functionsConfiguration:getKeybindTooltip("Apocalypse"),
				arg = APOCALYPSE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			ARMY_OF_THE_DEAD = {
				type = "keybinding",
				name = "Army of the Dead",
				desc = functionsConfiguration:getKeybindTooltip("Army of the Dead"),
				arg = ARMY_OF_THE_DEAD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			BLIGHTED_RUNE_WEAPON = {
				type = "keybinding",
				name = "Blighted Rune Weapon",
				desc = functionsConfiguration:getKeybindTooltip("Blighted Rune Weapon"),
				arg = BLIGHTED_RUNE_WEAPON,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			CORPSE_SHIELD = {
				type = "keybinding",
				name = "Corpse Shield",
				desc = functionsConfiguration:getKeybindTooltip("Corpse Shield"),
				arg = CORPSE_SHIELD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			DARK_TRANSFORMATION = {
				type = "keybinding",
				name = "Dark Transformation",
				desc = functionsConfiguration:getKeybindTooltip("Dark Transformation"),
				arg = DARK_TRANSFORMATION,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			DEATH_COIL = {
				type = "keybinding",
				name = "Death Coil",
				desc = functionsConfiguration:getKeybindTooltip("Death Coil"),
				arg = DEATH_COIL,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			EPIDEMIC = {
				type = "keybinding",
				name = "Epidemic",
				desc = functionsConfiguration:getKeybindTooltip("Epidemic"),
				arg = EPIDEMIC,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			FESTERING_STRIKE = {
				type = "keybinding",
				name = "Festering Strike",
				desc = functionsConfiguration:getKeybindTooltip("Festering Strike"),
				arg = FESTERING_STRIKE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			OUTBREAK = {
				type = "keybinding",
				name = "Outbreak",
				desc = functionsConfiguration:getKeybindTooltip("Outbreak"),
				arg = OUTBREAK,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			RAISE_DEAD = {
				type = "keybinding",
				name = "Raise Dead",
				desc = functionsConfiguration:getKeybindTooltip("Raise Dead"),
				arg = RAISE_DEAD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			SCOURGE_STRIKE = {
				type = "keybinding",
				name = "Scourge Strike",
				desc = functionsConfiguration:getKeybindTooltip("Scourge Strike"),
				arg = SCOURGE_STRIKE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			SOUL_REAPER = {
				type = "keybinding",
				name = "Soul Reaper",
				desc = functionsConfiguration:getKeybindTooltip("Soul Reaper"),
				arg = SOUL_REAPER,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
			SUMMON_GARGOYLE = {
				type = "keybinding",
				name = "Summon Gargoyle",
				desc = functionsConfiguration:getKeybindTooltip("Summon Gargoyle"),
				arg = SUMMON_GARGOYLE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 130,
			},
		},
	};
end