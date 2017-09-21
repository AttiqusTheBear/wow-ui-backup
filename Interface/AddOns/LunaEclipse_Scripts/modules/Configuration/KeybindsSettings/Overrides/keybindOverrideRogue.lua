local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_ROGUE then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementRogue = {
	};

	addonTable.commonRogue = {
		type = "group",
		name = KEYBIND_OVERRIDE_ROGUE_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.assassinationRogue = {
		type = "group",
		name = KEYBIND_OVERRIDE_ROGUE_ASSASSINATION,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.outlawRogue = {
		type = "group",
		name = KEYBIND_OVERRIDE_ROGUE_OUTLAW,
		inline = true,
		order = 40,
		args = {
		},
	};

	addonTable.subtletyRogue = {
		type = "group",
		name = KEYBIND_OVERRIDE_ROGUE_SUBTLETY,
		inline = true,
		order = 50,
		args = {
		},
	};
end