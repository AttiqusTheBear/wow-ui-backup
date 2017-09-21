local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_PRIEST then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementPriest = {
	};

	addonTable.commonPriest = {
		type = "group",
		name = KEYBIND_OVERRIDE_PRIEST_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.disciplinePriest = {
		type = "group",
		name = KEYBIND_OVERRIDE_PRIEST_DISCIPLINE,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.holyPriest = {
		type = "group",
		name = KEYBIND_OVERRIDE_PRIEST_HOLY,
		inline = true,
		order = 40,
		args = {
		},
	};

	addonTable.shadowPriest = {
		type = "group",
		name = KEYBIND_OVERRIDE_PRIEST_SHADOW,
		inline = true,
		order = 50,
		args = {
		},
	};
end