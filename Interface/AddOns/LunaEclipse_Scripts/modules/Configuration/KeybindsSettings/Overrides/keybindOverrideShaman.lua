local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_SHAMAN then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementShaman = {
	};

	addonTable.commonShaman = {
		type = "group",
		name = KEYBIND_OVERRIDE_SHAMAN_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.elementalShaman = {
		type = "group",
		name = KEYBIND_OVERRIDE_SHAMAN_ELEMENTAL,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.enhancementShaman = {
		type = "group",
		name = KEYBIND_OVERRIDE_SHAMAN_ENHANCEMENT,
		inline = true,
		order = 40,
		args = {
		},
	};

	addonTable.restorationShaman = {
		type = "group",
		name = KEYBIND_OVERRIDE_SHAMAN_RESTORATION,
		inline = true,
		order = 50,
		args = {
		},
	};
end