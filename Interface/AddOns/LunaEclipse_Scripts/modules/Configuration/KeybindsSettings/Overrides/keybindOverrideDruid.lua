local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_DRUID then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementDruid = {
	};

	addonTable.commonDruid = {
		type = "group",
		name = KEYBIND_OVERRIDE_DRUID_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.balanceDruid = {
		type = "group",
		name = KEYBIND_OVERRIDE_DRUID_BALANCE,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.feralDruid = {
		type = "group",
		name = KEYBIND_OVERRIDE_DRUID_FERAL,
		inline = true,
		order = 40,
		args = {
		},
	};

	addonTable.guardianDruid = {
		type = "group",
		name = KEYBIND_OVERRIDE_DRUID_GUARDIAN,
		inline = true,
		order = 50,
		args = {
		},
	};

	addonTable.restorationDruid = {
		type = "group",
		name = KEYBIND_OVERRIDE_DRUID_RESTORATION,
		inline = true,
		order = 60,
		args = {
		},
	};
end