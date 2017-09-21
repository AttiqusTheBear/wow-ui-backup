local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.

if LunaEclipse_Scripts:isCompatableWOWVersion() then
	local functionsConfiguration = addonTable.functionsConfiguration;

	-- Racial SpellIDs
	local STONEFORM = 20594;
	local ESCAPE_ARTIST = 20589;
	local EVERY_MAN_FOR_HIMSELF = 59752;
	local SHADOWMELD = 58984;
	local GIFT_OF_THE_NAARU = 28880;
	local DARKFLIGHT = 68992;
	local TWO_FORMS = 68996;
	local RUNNING_WILD = 87840;
	local QUAKING_PALM = 107079;
	local BLOOD_FURY = 33697;
	local BLOOD_FURY_AP = 20572;
	local BLOOD_FURY_SP = 33702;
	local WAR_STOMP = 20549;
	local BERSERKING = 26297;
	local WILL_OF_THE_FORSAKEN = 7744;
	local CANNIBALIZE = 20577;
	local ARCANE_TORRENT = 28730;
	local ARCANE_TORRENT_ENERGY = 25046;
	local ARCANE_TORRENT_RUNIC_POWER = 50613;
	local ARCANE_TORRENT_RAGE = 69179;
	local ARCANE_TORRENT_FOCUS = 80483;
	local ARCANE_TORRENT_CHI = 129597;
	local ROCKET_JUMP = 69070;
	local ROCKET_BARRAGE = 69041;
	local PACK_HOBGOBLIN = 69046;

	addonTable.replacementRacial = {
		[BLOOD_FURY_AP] = BLOOD_FURY,
		[BLOOD_FURY_SP] = BLOOD_FURY,
		[ARCANE_TORRENT_ENERGY] = ARCANE_TORRENT,
		[ARCANE_TORRENT_RUNIC_POWER] = ARCANE_TORRENT,
		[ARCANE_TORRENT_RAGE] = ARCANE_TORRENT,
		[ARCANE_TORRENT_FOCUS] = ARCANE_TORRENT,
		[ARCANE_TORRENT_CHI] = ARCANE_TORRENT,
	};

	addonTable.commonRacial = {
		type = "group",
		name = KEYBIND_OVERRIDE_RACIAL,
		inline = true,
		order = 10,
		args = {
			STONEFORM = {
				type = "keybinding",
				name = "Stoneform",
				desc = functionsConfiguration:getKeybindTooltip("Stoneform"),
				arg = STONEFORM,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 10,
			},
			ESCAPE_ARTIST = {
				type = "keybinding",
				name = "Escape Artist",
				desc = functionsConfiguration:getKeybindTooltip("Escape Artist"),
				arg = ESCAPE_ARTIST,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 20,
			},
			EVERY_MAN_FOR_HIMSELF = {
				type = "keybinding",
				name = "Every Man for Himself",
				desc = functionsConfiguration:getKeybindTooltip("Every Man for Himself"),
				arg = EVERY_MAN_FOR_HIMSELF,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 30,
			},
			SHADOWMELD = {
				type = "keybinding",
				name = "Shadowmeld",
				desc = functionsConfiguration:getKeybindTooltip("Shadowmeld"),
				arg = SHADOWMELD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 40,
			},
			GIFT_OF_THE_NAARU = {
				type = "keybinding",
				name = "Gift of the Naaru",
				desc = functionsConfiguration:getKeybindTooltip("Gift of the Naaru"),
				arg = GIFT_OF_THE_NAARU,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 50,
			},
			DARKFLIGHT = {
				type = "keybinding",
				name = "Darkflight",
				desc = functionsConfiguration:getKeybindTooltip("Darkflight"),
				arg = DARKFLIGHT,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 60,
			},
			TWO_FORMS = {
				type = "keybinding",
				name = "Two Forms",
				desc = functionsConfiguration:getKeybindTooltip("Two Forms"),
				arg = TWO_FORMS,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 70,
			},
			RUNNING_WILD = {
				type = "keybinding",
				name = "Running Wild",
				desc = functionsConfiguration:getKeybindTooltip("Running Wild"),
				arg = RUNNING_WILD,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 80,
			},
			QUAKING_PALM = {
				type = "keybinding",
				name = "Quaking Palm",
				desc = functionsConfiguration:getKeybindTooltip("Quaking Palm"),
				arg = QUAKING_PALM,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 90,
			},
			BLOOD_FURY = {
				type = "keybinding",
				name = "Blood Fury",
				desc = functionsConfiguration:getKeybindTooltip("Blood Fury"),
				arg = BLOOD_FURY,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 100,
			},
			WAR_STOMP = {
				type = "keybinding",
				name = "War Stomp",
				desc = functionsConfiguration:getKeybindTooltip("War Stomp"),
				arg = WAR_STOMP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 110,
			},
			BERSERKING = {
				type = "keybinding",
				name = "Berserking",
				desc = functionsConfiguration:getKeybindTooltip("Berserking"),
				arg = BERSERKING,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 120,
			},
			WILL_OF_THE_FORSAKEN = {
				type = "keybinding",
				name = "Will of the Forsaken",
				desc = functionsConfiguration:getKeybindTooltip("Will of the Forsaken"),
				arg = WILL_OF_THE_FORSAKEN,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 130,
			},
			CANNIBALIZE = {
				type = "keybinding",
				name = "Cannibalize",
				desc = functionsConfiguration:getKeybindTooltip("Cannibalize"),
				arg = CANNIBALIZE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 140,
			},
			ARCANE_TORRENT = {
				type = "keybinding",
				name = "Arcane Torrent",
				desc = functionsConfiguration:getKeybindTooltip("Arcane Torrent"),
				arg = ARCANE_TORRENT,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 150,
			},
			ROCKET_JUMP = {
				type = "keybinding",
				name = "Rocket Jump",
				desc = functionsConfiguration:getKeybindTooltip("Rocket Jump"),
				arg = ROCKET_JUMP,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 160,
			},
			ROCKET_BARRAGE = {
				type = "keybinding",
				name = "Rocket Barrage",
				desc = functionsConfiguration:getKeybindTooltip("Rocket Barrage"),
				arg = ROCKET_BARRAGE,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 170,
			},
			PACK_HOBGOBLIN = {
				type = "keybinding",
				name = "Pack Hobgoblin",
				desc = functionsConfiguration:getKeybindTooltip("Pack Hobgoblin"),
				arg = PACK_HOBGOBLIN,
				get = "getKeybindValue",
				set = "setKeybindValue",
				order = 180,
			},
		},
	};
end