local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_HUNTER then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementHunter = {
	};

	addonTable.commonHunter = {
		type = "group",
		name = KEYBIND_OVERRIDE_HUNTER_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.beastMasteryHunter = {
		type = "group",
		name = KEYBIND_OVERRIDE_HUNTER_BEAST_MASTERY,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.marksmanshipHunter = {
		type = "group",
		name = KEYBIND_OVERRIDE_HUNTER_MARKSMANSHIP,
		inline = true,
		order = 40,
		args = {
		},
	};

	addonTable.survivalHunter = {
		type = "group",
		name = KEYBIND_OVERRIDE_HUNTER_SURVIVAL,
		inline = true,
		order = 50,
		args = {
		},
	};
end