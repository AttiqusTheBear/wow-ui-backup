local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_WARRIOR then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementWarrior = {
	};

	addonTable.commonWarrior = {
		type = "group",
		name = KEYBIND_OVERRIDE_WARRIOR_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.armsWarrior = {
		type = "group",
		name = KEYBIND_OVERRIDE_WARRIOR_ARMS,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.furyWarrior = {
		type = "group",
		name = KEYBIND_OVERRIDE_WARRIOR_FURY,
		inline = true,
		order = 40,
		args = {
		},
	};

	addonTable.protectionWarrior = {
		type = "group",
		name = KEYBIND_OVERRIDE_WARRIOR_PROTECTION,
		inline = true,
		order = 50,
		args = {
		},
	};
end