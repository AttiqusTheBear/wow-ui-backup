local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_MONK then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementMonk = {
	};

	addonTable.commonMonk = {
		type = "group",
		name = KEYBIND_OVERRIDE_MONK_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.brewmasterMonk = {
		type = "group",
		name = KEYBIND_OVERRIDE_MONK_BREWMASTER,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.mistweaverMonk = {
		type = "group",
		name = KEYBIND_OVERRIDE_MONK_MISTWEAVER,
		inline = true,
		order = 40,
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
		},
	};

	addonTable.windwalkerMonk = {
		type = "group",
		name = KEYBIND_OVERRIDE_MONK_WINDWALKER,
		inline = true,
		order = 50,
		args = {
		},
	};
end