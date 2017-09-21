local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "optionsConfiguration";
    local optionsConfiguration = LunaEclipse_Scripts:NewModule(moduleName, "AceConsole-3.0", "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.addonOptions = {
		type = "group",
		name = "LunaEclipse: Custom Ovale Script Settings",
		handler = functionsConfiguration,
		args = {
			addonOptions = {
				type = "group",
				name = "Addon Options",
				inline = true,
				order = 10,
				args = {
					toggleMinimapIcon = {
						type = "toggle",
						name = "Show Minimap Icon.",
						desc = "Shows or hides the minimap icon.\n\nPlease be warned that the preset builds can only be accessed from the minimap icon, if you hide it you are removing the ability to use the preset builds!",
						arg = "toggleMinimapIcon",
						get = "getMinimapIcon",
						set = "setMinimapIcon",
						order = 10,
					},
					switchUseNamplates = {
						type = "toggle",
						name = "Show Nameplates in combat.",
						desc = "Shows enemy nameplates when in combat, resets your settings when you leave combat.\n\nThis is used for Aura Tracking with DOT Counter!\n\nIt is recommended to have this checked!",
						arg = "switchUseNamplates",
						get = "getAddonValue",
						set = "setAddonValue",
						order = 20,
					},
				},
			},
			scriptChangeOptions = {
				type = "group",
				name = "Auto Script Change Options",
				inline = true,
				order = 20,
				args = {
					switchNoScript = {
						type = "toggle",
						name = "Switch when there is no script.",
						desc = "Switches Ovale to use the default Ovale script if there is not an addon script for that specialization.",
						arg = "switchNoScript",
						get = "getAddonValue",
						set = "setAddonValue",
						width = "double",
						order = 10,
					},
					switchOldScript = {
						type = "toggle",
						name = "Switch when script is out of date.",
						desc = "Switches Ovale to use the default Ovale script if the addon script is out of date.",
						arg = "switchOldScript",
						get = "getAddonValue",
						set = "setAddonValue",
						width = "double",
						order = 20,
					},
				},
			},
			displayOptions = {
				type = "group",
				name = "Display Options",
				inline = true,
				order = 30,
				args = {
					OPT_SINGLE_TARGET = {
						type = "toggle",
						name = BINDING_NAME_OPT_SINGLE_TARGET,
						desc = "Add and extra rotation icon which will display single target rotation no matter how many enemies you are fighting.",
						arg = "OPT_SINGLE_TARGET",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_MULTI_DOT = {
						type = "toggle",
						name = BINDING_NAME_OPT_MULTI_DOT,
						desc = "If this option is checked, then an icon will be used to the left of the ShortCD icon to suggest when to multi-dot.\n\nThis will have no effect on classes and specializations that do not have multi-dot options.",
						arg = "OPT_MULTI_DOT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_MULTI_DOT_TARGETS = {
						type = "select",
						name = "",
						desc = "Select the max number of enemies to DOT when Multi-DOTing.",
						values = {
							["mdt_2"] = "Mult-DOT up to 2 Targets",
							["mdt_3"] = "Mult-DOT up to 3 Targets",
							["mdt_4"] = "Mult-DOT up to 4 Targets",
							["mdt_5"] = "Mult-DOT up to 5 Targets",
							["mdt_6"] = "Mult-DOT up to 6 Targets",
							["mdt_7"] = "Mult-DOT up to 7 Targets",
							["mdt_8"] = "Mult-DOT up to 8 Targets",
						},
						arg = "OPT_MULTI_DOT_TARGETS",
						get = "getScriptValue",
						set = "setScriptValue",
						order = 30,
					},
				},
			},
			scriptOptions = {
				type = "group",
				name = "Script Options (Depends on script, not all scripts use these options)",
				inline = true,
				order = 40,
				args = {
					OPT_ENEMIES_TAGGED = {
						type = "toggle",
						name = BINDING_NAME_OPT_ENEMIES_TAGGED,
						desc = "Only count tagged enemies when counting enemies.",
						arg = "OPT_ENEMIES_TAGGED",
						get = "getScriptValue",
						set = "setScriptValue",
						width = "full",
						order = 10,
					},
					OPT_MELEE_RANGE = {
						type = "toggle",
						name = BINDING_NAME_OPT_MELEE_RANGE,
						desc = "Shows an arrow icon to move to melee range on the short cooldown icon if you are not in melee range.\n\nRanged specializations will ignore this setting!",
						arg = "OPT_MELEE_RANGE",
						get = "getScriptValue",
						set = "setScriptValue",
						order = 20,
					},
					OPT_MOVING = {
						type = "toggle",
						name = BINDING_NAME_OPT_MOVING,
						desc = "Using this option will enable an extra check to see if you are moving and only recommend spells that can be cast while moving!\n\nNot all scripts have been updated to use this option yet!",
						arg = "OPT_MOVING",
						get = "getScriptValue",
						set = "setScriptValue",
						order = 30,
					},
					OPT_RANGE_CHECK = {
						type = "toggle",
						name = BINDING_NAME_OPT_RANGE_CHECK,
						desc = "Using this option will only show spells where the current enemy is in range.\n\nUnchecking this option will show the recommended spell based on priority regards of whether the target is in range or not!\n\nNot all scripts have been updated to use this option yet!",
						arg = "OPT_RANGE_CHECK",
						get = "getScriptValue",
						set = "setScriptValue",
						order = 40,
					},
					OPT_INTERRUPT = {
						type = "toggle",
						name = BINDING_NAME_OPT_INTERRUPT,
						desc = "Suggests when to use interrupts on the long cooldown icon.",
						arg = "OPT_INTERRUPT",
						get = "getScriptValue",
						set = "setScriptValue",
						order = 50,
					},
					OPT_ARCANE_TORRENT_INTERRUPT = {
						type = "toggle",
						name = BINDING_NAME_OPT_ARCANE_TORRENT_INTERRUPT,
						desc = "If this option is checked Ovale will only suggest Arcane Torrent (Blood Elf Racial Ability) to interrupt spell casting and not to regain resources such as mana, focus, rage etc...\n\nThis will obviously only have an effect if your character is a Blood Elf!",
						arg = "OPT_ARCANE_TORRENT_INTERRUPT",
						get = "getScriptValue",
						set = "setScriptValue",
						width = "double",
						order = 60,
					},
				},
			},
			cooldownOptions = {
				type = "group",
				name = "Script Cooldown Options (Depends on script, not all scripts use these options)",
				inline = true,
				order = 50,
				args = {
					OPT_MAJOR_CDS_RAID_ONLY = {
						type = "toggle",
						name = BINDING_NAME_OPT_MAJOR_CDS_RAID_ONLY,
						desc = "If this option is checked, then major cooldowns will only be recommended on Raid Bosses.\n\nHowever if this option is unchecked then major cooldowns will be shown on both Dungeon and Raid bosses.",
						arg = "OPT_MAJOR_CDS_RAID_ONLY",
						get = "getScriptValue",
						set = "setScriptValue",
						order = 10,
					},
					OPT_POTION = {
						type = "toggle",
						name = BINDING_NAME_OPT_POTION,
						desc = "Suggests when to use potions on the long cooldown icon.",
						arg = "OPT_POTION",
						get = "getScriptValue",
						set = "setScriptValue",
						order = 20,
					},
					OPT_DRAUGHT_OF_SOULS = {
						type = "toggle",
						name = BINDING_NAME_OPT_DRAUGHT_OF_SOULS,
						desc = functionsConfiguration:getCooldownTooltip("Draught of Souls", "CD"),
						arg = "OPT_DRAUGHT_OF_SOULS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
				},
			},
		},
	};

	addonTable.scriptOptions = {
		type = "group",
		name = "Script Settings",
		handler = functionsConfiguration,
		args = {},
	};

	function optionsConfiguration:OnInitialize()
		LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, addonTable.addonOptions);
		LibStub("AceConfig-3.0"):RegisterOptionsTable("LECS_ScriptSettings", addonTable.scriptOptions);

		addonTable.addonSettingsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, "LunaEclipse: Ovale Scripts");
		addonTable.scriptSettingsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LECS_ScriptSettings", "Script Settings", "LunaEclipse: Ovale Scripts");
	end
end