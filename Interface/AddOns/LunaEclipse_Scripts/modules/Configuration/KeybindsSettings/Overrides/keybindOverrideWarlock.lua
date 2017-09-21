local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_WARLOCK then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementWarlock = {
	};

	addonTable.commonWarlock = {
		type = "group",
		name = KEYBIND_OVERRIDE_WARLOCK_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.afflictionWarlock = {
		type = "group",
		name = KEYBIND_OVERRIDE_WARLOCK_AFFLICTION,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.demonologyWarlock = {
		type = "group",
		name = KEYBIND_OVERRIDE_WARLOCK_DEMONOLOGY,
		inline = true,
		order = 40,
		args = {
		},
	};

	addonTable.destructionWarlock = {
		type = "group",
		name = KEYBIND_OVERRIDE_WARLOCK_DESTRUCTION,
		inline = true,
		order = 50,
		args = {
		},
	};
end