local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_PALADIN then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementPaladin = {
	};

	addonTable.commonPaladin = {
		type = "group",
		name = KEYBIND_OVERRIDE_PALADIN_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.holyPaladin = {
		type = "group",
		name = KEYBIND_OVERRIDE_PALADIN_HOLY,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.protectionPaladin = {
		type = "group",
		name = KEYBIND_OVERRIDE_PALADIN_PROTECTION,
		inline = true,
		order = 40,
		args = {
		},
	};

	addonTable.retributionPaladin = {
		type = "group",
		name = KEYBIND_OVERRIDE_PALADIN_RETRIBUTION,
		inline = true,
		order = 50,
		args = {
		},
	};
end