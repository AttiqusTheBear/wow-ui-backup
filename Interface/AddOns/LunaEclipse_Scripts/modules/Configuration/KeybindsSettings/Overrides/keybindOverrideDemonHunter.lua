local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:GetClass() == addonTable.CLASS_DEMONHUNTER then
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.replacementDemonHunter = {
	}

	addonTable.commonDemonHunter = {
		type = "group",
		name = KEYBIND_OVERRIDE_DEMON_HUNTER_COMMON,
		inline = true,
		order = 20,
		args = {
		},
	};

	addonTable.havocDemonHunter = {
		type = "group",
		name = KEYBIND_OVERRIDE_DEMON_HUNTER_HAVOC,
		inline = true,
		order = 30,
		args = {
		},
	};

	addonTable.vangeanceDemonHunter = {
		type = "group",
		name = KEYBIND_OVERRIDE_DEMON_HUNTER_VENGEANCE,
		inline = true,
		order = 40,
		args = {
		},
	};
end