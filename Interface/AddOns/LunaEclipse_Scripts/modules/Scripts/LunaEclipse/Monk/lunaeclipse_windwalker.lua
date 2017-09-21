local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_monk_windwalker";
		local desc = "LunaEclipse: Windwalker Monk";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.MONK_WINDWALKER,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Babylonius",
			GuideLink = "http://www.icy-veins.com/wow/windwalker-monk-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "3013032",
			["Raiding (AOE)"] = "1013013",
			["Solo / Dungeons"] = "1012021",
			["Easy Mode"] = "2213032",
		};

		-- Store the settings for the configuration screen.
		-- Remove any unneeded groups, keep the order number the same.
		addonTable.scriptSettings[name] = {
			settingsAOE = {
				type = "group",
				name = BINDING_HEADER_AOE,
				inline = true,
				order = 10,
				args = {
					OPT_FISTS_OF_FURY = {
						type = "toggle",
						name = BINDING_NAME_OPT_FISTS_OF_FURY,
						desc = functionsConfiguration:getAOETooltip("Fists of Fury"),
						arg = "OPT_FISTS_OF_FURY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_RUSHING_JADE_WIND = {
						type = "toggle",
						name = BINDING_NAME_OPT_RUSHING_JADE_WIND,
						desc = functionsConfiguration:getAOETooltip("Rushing Jade Wind"),
						arg = "OPT_RUSHING_JADE_WIND",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_SPINNING_CRANE = {
						type = "toggle",
						name = BINDING_NAME_OPT_SPINNING_CRANE,
						desc = functionsConfiguration:getAOETooltip("Spinning Crane Kick"),
						arg = "OPT_SPINNING_CRANE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_CHI_BURST = {
						type = "toggle",
						name = BINDING_NAME_OPT_CHI_BURST,
						desc = functionsConfiguration:getAOETooltip("Chi Burst"),
						arg = "OPT_CHI_BURST",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
				},
			},
			settingsCooldowns = {
				type = "group",
				name = BINDING_HEADER_COOLDOWNS,
				inline = true,
				order = 30,
				args = {
					OPT_CHI_WAVE = {
						type = "toggle",
						name = BINDING_NAME_OPT_CHI_WAVE,
						desc = functionsConfiguration:getCooldownTooltip("Chi Wave"),
						arg = "OPT_CHI_WAVE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_ENERGIZING_ELIXIR = {
						type = "toggle",
						name = BINDING_NAME_OPT_ENERGIZING_ELIXIR,
						desc = functionsConfiguration:getCooldownTooltip("Energizing Elixir"),
						arg = "OPT_ENERGIZING_ELIXIR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_INVOKE_XUEN = {
						type = "toggle",
						name = BINDING_NAME_OPT_INVOKE_XUEN,
						desc = functionsConfiguration:getCooldownTooltip("Invoke Xuen", "CD"),
						arg = "OPT_INVOKE_XUEN",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_SERENITY = {
						type = "toggle",
						name = BINDING_NAME_OPT_SERENITY,
						desc = functionsConfiguration:getCooldownTooltip("Serenity", "CD"),
						arg = "OPT_SERENITY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_SEF = {
						type = "toggle",
						name = BINDING_NAME_OPT_SEF,
						desc = functionsConfiguration:getCooldownTooltip("Storm, Earth and Fire", "CD"),
						arg = "OPT_SEF",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 50,
					},
					OPT_STRIKE_WINDLORD = {
						type = "toggle",
						name = BINDING_NAME_OPT_STRIKE_WINDLORD,
						desc = functionsConfiguration:getCooldownTooltip("Strike of the Windlord"),
						arg = "OPT_STRIKE_WINDLORD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 60,
					},
					OPT_DEATH_TOUCH = {
						type = "toggle",
						name = BINDING_NAME_OPT_DEATH_TOUCH,
						desc = functionsConfiguration:getCooldownTooltip("Touch of Death", "CD"),
						arg = "OPT_DEATH_TOUCH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 70,
					},
					OPT_WHIRLING_DRAGON_PUNCH = {
						type = "toggle",
						name = BINDING_NAME_OPT_WHIRLING_DRAGON_PUNCH,
						desc = functionsConfiguration:getCooldownTooltip("Whirling Dragon Punch"),
						arg = "OPT_WHIRLING_DRAGON_PUNCH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 80,
					},
				},
			},
			settingsDefensive = {
				type = "group",
				name = BINDING_HEADER_DEFENSIVE,
				inline = true,
				order = 40,
				args = {
					OPT_TOUCH_OF_KARMA = {
						type = "toggle",
						name = BINDING_NAME_OPT_TOUCH_OF_KARMA,
						desc = functionsConfiguration:getDefensiveTooltip("Touch of Karma", "ShortCD", "40%"),
						arg = "OPT_TOUCH_OF_KARMA",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_HEALING_ELIXIR = {
						type = "toggle",
						name = BINDING_NAME_OPT_HEALING_ELIXIR,
						desc = functionsConfiguration:getDefensiveTooltip("Healing Elixir", "ShortCD", "40%"),
						arg = "OPT_HEALING_ELIXIR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(lunaeclipse_monk_spells)
			Include(lunaeclipse_global)

			# Legendary
			Define(drinking_horn_cover 137097)
			Define(the_emperors_capacitor 144239)
			Define(hidden_masters_forbidden_touch 137057)

			# Legendary Buffs
			Define(the_emperors_capacitor_buff 235054)
				SpellInfo(the_emperors_capacitor_buff max_stacks=20)

			# Artifact Traits
			Define(gale_burst_trait 195399)

			# Checkboxes
			AddCheckBox(opt_fists_of_fury "AOE: Fists of Fury" default)
			AddCheckBox(opt_rushing_jade_wind "AOE: Rushing Jade Wind" default)
			AddCheckBox(opt_spinning_crane "AOE: Spinning Crane Kick" default)
			AddCheckBox(opt_chi_burst "AOE CD: Chi Burst" default)
			AddCheckBox(opt_chi_wave "Cooldown: Chi Wave" default)
			AddCheckBox(opt_energizing_elixir "Cooldown: Energizing Elixir" default)
			AddCheckBox(opt_invoke_xuen "Cooldown: Invoke Xuen" default)
			AddCheckBox(opt_serenity "Cooldown: Serenity" default)
			AddCheckBox(opt_sef "Cooldown: Storm, Earth and Fire" default)
			AddCheckBox(opt_strike_windlord "Cooldown: Strike of the Windlord" default)
			AddCheckBox(opt_death_touch "Cooldown: Touch of Death" default)
			AddCheckBox(opt_whirling_dragon_punch "Cooldown: Whirling Dragon Punch" default)
			AddCheckBox(opt_touch_of_karma "Defensive: Touch of Karma" default)
			AddCheckBox(opt_healing_elixir "Heal: Healing Elixir" default)

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(spear_hand_strike) Spell(spear_hand_strike)
					if target.Distance() < 8 Spell(arcane_torrent_chi)

					if not target.IsRaidBoss()
					{
						if target.Distance() < 5 Spell(leg_sweep)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						if target.Distance() < 5 Spell(war_stomp)
						if target.RangeCheck(paralysis) Spell(paralysis)
					}
				}
			}

			###
			### MultiDot Icon Rotation - Functions
			###
			AddFunction MultiDot_RisingSunKick_Use
			{
					not SpellCooldown(rising_sun_kick)
				and DOTTargetCount(rising_sun_kick_debuff) < MultiDOTTargets()
				and {
							BuffPresent(serenity_buff)
						 or Chi() >= 2
					}
			}

			AddFunction MultiDot_TouchOfDeath_Use_GaleBurst
			{
					not SpellCooldown(touch_of_death)
				and HasArtifactTrait(gale_burst_trait)
				and LegendaryEquipped(hidden_masters_forbidden_touch)
				and SpellCooldown(strike_of_the_windlord) < 8
				and SpellCooldown(fists_of_fury) <= 4
				and SpellCooldown(rising_sun_kick) < 7
				and TimeSincePreviousSpell(touch_of_death) < 5
			}

			AddFunction MultiDot_TouchOfDeath_Use
			{
					not SpellCooldown(touch_of_death)
				and not HasArtifactTrait(gale_burst_trait)
				and LegendaryEquipped(hidden_masters_forbidden_touch)
				and TimeSincePreviousSpell(touch_of_death) < 5
				and Enemies() >= 2
			}

			###
			### MultiDot Icon Rotation
			###
			AddFunction MultiDot
			{
				if MultiDot_TouchOfDeath_Use() Spell(touch_of_death text=multi) 
				if MultiDot_TouchOfDeath_Use_GaleBurst() Spell(touch_of_death text=multi) 
				if MultiDot_RisingSunKick_Use() Spell(rising_sun_kick text=multi)
			}

			AddFunction MultiDot_Precombat
			{
			}

			###
			### ShortCD Icon Rotation - Functions
			###
			AddFunction ShortCD_HealingElixir_Use
			{
					Talent(healing_elixir_talent)
				and SpellCharges(healing_elixir) >= 1
				and HealthPercent() <= 40
			}

			AddFunction ShortCD_MeleeRange_Use
			{
					CheckBoxOn(opt_melee_range)
				and not target.RangeCheck(tiger_palm)
			}

			###
			### ShortCD Icon Rotation
			###
			AddFunction ShortCD
			{
				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))

				# Call Serenity Rotation
				if Rotation_Serenity_Use()
				{
					if not CheckBoxOn(opt_strike_windlord) and Serenity_StrikeOfTheWindlord_Use() Spell(strike_of_the_windlord)
					if not CheckBoxOn(opt_fists_of_fury) and Serenity_FistsOfFury_Use() Spell(fists_of_fury)
					if not CheckBoxOn(opt_spinning_crane) and Serenity_SpinningCraneKick_Use_AOE() Spell(spinning_crane_kick)
					if not CheckBoxOn(opt_spinning_crane) and Serenity_SpinningCraneKick_Use() Spell(spinning_crane_kick)
					if not CheckBoxOn(opt_rushing_jade_wind) and Serenity_RushingJadeWind_Use() Spell(rushing_jade_wind)
				}

				# Call Storm, Earth and Fire Rotation
				if Rotation_StormEarthFire_Use() or Rotation_StormEarthFire_Use_DrinkingHornCover()
				{
					if not CheckBoxOn(opt_fists_of_fury) and StormEarthFire_FistsOfFury_Use() Spell(fists_of_fury)
				}

				# Call Standard Rotation
				if Rotation_Standard_Use()
				{
					if not CheckBoxOn(opt_energizing_elixir) and EnergizingElixir_Standard_Use() Spell(energizing_elixir)
					if not CheckBoxOn(opt_strike_windlord) and StrikeOfTheWindlord_Standard_Use_ConvergenceOfFates_Serenity() Spell(strike_of_the_windlord)
					if not CheckBoxOn(opt_strike_windlord) and StrikeOfTheWindlord_Standard_Use_ConvergenceOfFates() Spell(strike_of_the_windlord)
					if not CheckBoxOn(opt_strike_windlord) and StrikeOfTheWindlord_Standard_Use() Spell(strike_of_the_windlord)
					if not CheckBoxOn(opt_fists_of_fury) and FistsOfFury_Standard_Use_ConvergenceOfFates_Serenity() Spell(fists_of_fury)
					if not CheckBoxOn(opt_fists_of_fury) and FistsOfFury_Standard_Use_ConvergenceOfFates() Spell(fists_of_fury)
					if not CheckBoxOn(opt_fists_of_fury) and FistsOfFury_Standard_Use() Spell(fists_of_fury)
					if not CheckBoxOn(opt_whirling_dragon_punch) and WhirlingDragonPunch_Standard_Use() Spell(whirling_dragon_punch)
					if not CheckBoxOn(opt_spinning_crane) and SpinningCraneKick_Standard_Use() Spell(spinning_crane_kick)
					if not CheckBoxOn(opt_rushing_jade_wind) and RushingJadeWind_Standard_Use() Spell(rushing_jade_wind)
					if not CheckBoxOn(opt_chi_wave) and ChiWave_Standard_Use() Spell(chi_wave)
					if not CheckBoxOn(opt_chi_burst) and ChiBurst_Standard_Use() Spell(chi_burst)
				}

				# Healing Spells, only show if enabled.
				if CheckBoxOn(opt_healing_elixir) and ShortCD_HealingElixir_Use() Spell(healing_elixir)
			}

			AddFunction ShortCD_Precombat
			{
				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))

				# Healing Spells, only show if enabled.
				if CheckBoxOn(opt_healing_elixir) and ShortCD_HealingElixir_Use() Spell(healing_elixir)
			}

			###
			### Cooldowns Rotation - Functions
			###
			AddFunction Cooldowns_DraughtOfSouls_Use
			{
					LegendaryEquipped(draught_of_souls)
				and not Talent(serenity_talent)
				and not BuffPresent(storm_earth_and_fire_buff)
			}

			AddFunction Cooldowns_DraughtOfSouls_Use_Serenity
			{
					LegendaryEquipped(draught_of_souls)
				and Talent(serenity_talent)
				and SpellCooldown(serenity) >= 20
				and not BuffPresent(serenity_buff)
			}

			AddFunction Cooldowns_InvokeXuen_Use
			{
					Talent(invoke_xuen_talent)
				and not SpellCooldown(invoke_xuen)
			}

			AddFunction Cooldowns_TouchOfDeath_Use
			{
					not SpellCooldown(touch_of_death)
				and not HasArtifactTrait(gale_burst_trait)
				and not LegendaryEquipped(hidden_masters_forbidden_touch)
			}

			AddFunction Cooldowns_TouchOfDeath_Use_GaleBurst
			{
					not SpellCooldown(touch_of_death)
				and HasArtifactTrait(gale_burst_trait)
				and not Talent(serenity_talent)
				and not LegendaryEquipped(hidden_masters_forbidden_touch)
				and SpellCooldown(strike_of_the_windlord) < 8
				and SpellCooldown(fists_of_fury) <= 4
				and SpellCooldown(rising_sun_kick) < 7
				and Chi() >= 2
			}

			AddFunction Cooldowns_TouchOfDeath_Use_GaleBurst_Serenity
			{
					not SpellCooldown(touch_of_death)
				and HasArtifactTrait(gale_burst_trait)
				and Talent(serenity_talent)
				and not LegendaryEquipped(hidden_masters_forbidden_touch)
				and SpellCooldown(strike_of_the_windlord) < 8
				and SpellCooldown(fists_of_fury) <= 4
				and SpellCooldown(rising_sun_kick) < 7
			}

			###
			### Cooldowns Rotation
			###
			AddFunction Rotation_Cooldowns
			{
				if CheckBoxOn(opt_invoke_xuen) and Cooldowns_InvokeXuen_Use() Spell(invoke_xuen)
				if CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use() Spell(touch_of_death)
				if CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use_GaleBurst() Spell(touch_of_death) 
				if CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use_GaleBurst_Serenity() Spell(touch_of_death) 	
				if CheckBoxOn(opt_draught_of_souls) and Cooldowns_DraughtOfSouls_Use_Serenity() Item(draught_of_souls)
				if CheckBoxOn(opt_draught_of_souls) and Cooldowns_DraughtOfSouls_Use() Item(draught_of_souls)
			}
			
			###
			### Serenity Rotation - Functions
			###
			AddFunction Serenity_BlackoutKick_Use
			{
					not SpellCooldown(blackout_kick)
				and BuffPresent(serenity_buff)
				and not LastHitComboSpell(blackout_kick) 
			}

			AddFunction Serenity_DraughtOfSouls_Use
			{
					LegendaryEquipped(draught_of_souls)
				and BuffPresent(serenity_buff)
			}

			AddFunction Serenity_FistsOfFury_Use
			{
					not SpellCooldown(fists_of_fury)
				and BuffPresent(serenity_buff)
			}

			AddFunction Serenity_RisingSunKick_Use_AOE
			{
					not SpellCooldown(rising_sun_kick)
				and BuffPresent(serenity_buff)
				and Enemies() >= 3
			}

			AddFunction Serenity_RisingSunKick_Use_Cleave
			{
					not SpellCooldown(rising_sun_kick)
				and BuffPresent(serenity_buff)
				and Enemies() < 3
			}

			AddFunction Serenity_RushingJadeWind_Use
			{
					Talent(rushing_jade_wind_talent)
				and not SpellCooldown(rushing_jade_wind)
				and BuffPresent(serenity_buff)
				and	not LastHitComboSpell(rushing_jade_wind)
			}

			AddFunction Serenity_SpinningCraneKick_Use
			{
					not SpellCooldown(spinning_crane_kick)
				and BuffPresent(serenity_buff)
				and not LastHitComboSpell(spinning_crane_kick)
			}

			AddFunction Serenity_SpinningCraneKick_Use_AOE
			{
					not SpellCooldown(spinning_crane_kick)
				and BuffPresent(serenity_buff)
				and Enemies() >= 3
				and not LastHitComboSpell(spinning_crane_kick)
			}

			AddFunction Serenity_StrikeOfTheWindlord_Use
			{
					SpellKnown(strike_of_the_windlord)
				and not SpellCooldown(strike_of_the_windlord)
				and BuffPresent(serenity_buff)
			}

			###
			### Serenity Rotation - Usage
			###
			AddFunction Rotation_Serenity_Use
			{
					BuffPresent(serenity_buff)
			}

			###
			### Serenity Rotation
			###
			AddFunction Rotation_Serenity
			{
				# Check the cooldowns to use.
				Rotation_Cooldowns()

				if CheckBoxOn(opt_strike_windlord) and Serenity_StrikeOfTheWindlord_Use() Spell(strike_of_the_windlord)
				if CheckBoxOn(opt_draught_of_souls) and Serenity_DraughtOfSouls_Use() Item(draught_of_souls)
				if Serenity_RisingSunKick_Use_Cleave() Spell(rising_sun_kick)
				if CheckBoxOn(opt_fists_of_fury) and Serenity_FistsOfFury_Use() Spell(fists_of_fury)
				if CheckBoxOn(opt_spinning_crane) and Serenity_SpinningCraneKick_Use_AOE() Spell(spinning_crane_kick)
				if Serenity_RisingSunKick_Use_AOE() Spell(rising_sun_kick)
				if CheckBoxOn(opt_spinning_crane) and Serenity_SpinningCraneKick_Use() Spell(spinning_crane_kick)
				if Serenity_BlackoutKick_Use() Spell(blackout_kick)
				if CheckBoxOn(opt_rushing_jade_wind) and Serenity_RushingJadeWind_Use() Spell(rushing_jade_wind)
			}

			###
			### Standard Rotation - Functions
			###
			AddFunction Standard_BlackoutKick_Use
			{
					not SpellCooldown(blackout_kick)
				and {
							Chi() > 1
						 or BuffPresent(bok_proc_buff)
					}
				and not LastHitComboSpell(blackout_kick) 
			}

			AddFunction ChiBurst_Standard_Use
			{
					Talent(chi_burst_talent)
				and not SpellCooldown(chi_burst)
				and TimeToMaxEnergy() >= 2.25
			}

			AddFunction ChiWave_Standard_Use
			{
					Talent(chi_wave_talent)
				and not SpellCooldown(chi_wave)
				and TimeToMaxEnergy() >= 2.25
			}

			AddFunction CracklingJadeLightning_Standard_Use_EmperorsCapacitor
			{
					not SpellCooldown(crackling_jade_lightning)
				and LegendaryEquipped(the_emperors_capacitor)
				and BuffStacks(the_emperors_capacitor_buff) >= 19
				and Energy() >= 20
			}

			AddFunction EnergizingElixir_Standard_Use
			{
					Talent(energizing_elixir_talent)		
				and not SpellCooldown(energizing_elixir)
				and Energy() < MaxEnergy()
				and Chi() <= 1
			}

			AddFunction FistsOfFury_Standard_Use
			{
					not SpellCooldown(fists_of_fury)
				and not LegendaryEquipped(convergence_of_fates)
				and Chi() >= 3
			}

			AddFunction FistsOfFury_Standard_Use_ConvergenceOfFates
			{
					not SpellCooldown(fists_of_fury)
				and LegendaryEquipped(convergence_of_fates)
				and not Talent(serenity_talent)
				and Chi() >= 3
			}

			AddFunction FistsOfFury_Standard_Use_ConvergenceOfFates_Serenity
			{
					not SpellCooldown(fists_of_fury)
				and LegendaryEquipped(convergence_of_fates)
				and Talent(serenity_talent)
				and SpellCooldown(serenity) >= 5
				and Chi() >= 3
			}

			AddFunction RisingSunKick_Standard_Use
			{
					not SpellCooldown(rising_sun_kick)
				and not LegendaryEquipped(convergence_of_fates)
				and Chi() >= 2
			}

			AddFunction RisingSunKick_Standard_Use_ConvergenceOfFates
			{
					not SpellCooldown(rising_sun_kick)
				and LegendaryEquipped(convergence_of_fates)
				and not Talent(serenity_talent)
				and Chi() >= 2
			}

			AddFunction RisingSunKick_Standard_Use_ConvergenceOfFates_Serenity
			{
					not SpellCooldown(rising_sun_kick)
				and LegendaryEquipped(convergence_of_fates)
				and Talent(serenity_talent)
				and SpellCooldown(serenity) >= 2
				and Chi() >= 2
			}

			AddFunction RushingJadeWind_Standard_Use
			{
					Talent(rushing_jade_wind_talent)
				and not SpellCooldown(rushing_jade_wind)
				and ChiDeficit() > 1
				and	not LastHitComboSpell(rushing_jade_wind)
				and Chi() >= 1
			}

			AddFunction SpinningCraneKick_Standard_Use
			{
					not SpellCooldown(spinning_crane_kick)
				and Enemies() >= 3
				and not LastHitComboSpell(spinning_crane_kick)
				and Chi() >= 1
			}

			AddFunction StrikeOfTheWindlord_Standard_Use
			{
					SpellKnown(strike_of_the_windlord)
				and not SpellCooldown(strike_of_the_windlord)
				and not LegendaryEquipped(convergence_of_fates)
				and Chi() >= 2
			}

			AddFunction StrikeOfTheWindlord_Standard_Use_ConvergenceOfFates
			{
					SpellKnown(strike_of_the_windlord)
				and not SpellCooldown(strike_of_the_windlord)
				and LegendaryEquipped(convergence_of_fates)
				and not Talent(serenity_talent)
				and Chi() >= 2
			}

			AddFunction StrikeOfTheWindlord_Standard_Use_ConvergenceOfFates_Serenity
			{
					SpellKnown(strike_of_the_windlord)
				and not SpellCooldown(strike_of_the_windlord)
				and LegendaryEquipped(convergence_of_fates)
				and Talent(serenity_talent)
				and SpellCooldown(serenity) >= 10
				and Chi() >= 2
			}

			AddFunction TigerPalm_Standard_Use
			{
					not SpellCooldown(tiger_palm)
				and not LastHitComboSpell(tiger_palm)
				and Energy() >= 50
			}

			AddFunction TigerPalm_Standard_Use_StormEarthFire
			{
					not SpellCooldown(tiger_palm)
				and not LastHitComboSpell(tiger_palm)
				and Energy() == MaxEnergy()
				and Chi() <= 3
				and BuffPresent(storm_earth_and_fire_buff)
			}

			AddFunction WhirlingDragonPunch_Standard_Use
			{
					Talent(whirling_dragon_punch_talent)
				and not SpellCooldown(whirling_dragon_punch)
				and SpellCooldown(fists_of_fury)
				and SpellCooldown(rising_sun_kick)
			}
			
			###
			### Standard Rotation - Usage
			###
			AddFunction Rotation_Standard_Use
			{
					not BuffPresent(serenity_buff)
			}

			###
			### Standard Rotation
			###
			AddFunction Rotation_Standard
			{
				# Check the cooldowns to use.
				Rotation_Cooldowns()

				if CheckBoxOn(opt_energizing_elixir) and EnergizingElixir_Standard_Use() Spell(energizing_elixir)
				if CheckBoxOn(opt_strike_windlord) and StrikeOfTheWindlord_Standard_Use_ConvergenceOfFates_Serenity() Spell(strike_of_the_windlord)
				if CheckBoxOn(opt_strike_windlord) and StrikeOfTheWindlord_Standard_Use_ConvergenceOfFates() Spell(strike_of_the_windlord)
				if CheckBoxOn(opt_strike_windlord) and StrikeOfTheWindlord_Standard_Use() Spell(strike_of_the_windlord)
				if CheckBoxOn(opt_fists_of_fury) and FistsOfFury_Standard_Use_ConvergenceOfFates_Serenity() Spell(fists_of_fury)
				if CheckBoxOn(opt_fists_of_fury) and FistsOfFury_Standard_Use_ConvergenceOfFates() Spell(fists_of_fury)
				if CheckBoxOn(opt_fists_of_fury) and FistsOfFury_Standard_Use() Spell(fists_of_fury)
				if TigerPalm_Standard_Use_StormEarthFire() Spell(tiger_palm)
				if RisingSunKick_Standard_Use_ConvergenceOfFates_Serenity() Spell(rising_sun_kick)
				if RisingSunKick_Standard_Use_ConvergenceOfFates() Spell(rising_sun_kick)
				if RisingSunKick_Standard_Use() Spell(rising_sun_kick)
				if CheckBoxOn(opt_whirling_dragon_punch) and WhirlingDragonPunch_Standard_Use() Spell(whirling_dragon_punch)
				if CracklingJadeLightning_Standard_Use_EmperorsCapacitor() Spell(crackling_jade_lightning)
				if CheckBoxOn(opt_spinning_crane) and SpinningCraneKick_Standard_Use() Spell(spinning_crane_kick)
				if CheckBoxOn(opt_rushing_jade_wind) and RushingJadeWind_Standard_Use() Spell(rushing_jade_wind)
				if Standard_BlackoutKick_Use() Spell(blackout_kick)
				if CheckBoxOn(opt_chi_wave) and ChiWave_Standard_Use() Spell(chi_wave)
				if CheckBoxOn(opt_chi_burst) and ChiBurst_Standard_Use() Spell(chi_burst)
				if TigerPalm_Standard_Use() Spell(tiger_palm)
			}
			
			###
			### Storm, Earth and Fire Rotation - Functions
			###
			AddFunction StormEarthFire_FistsOfFury_Use
			{
					not SpellCooldown(fists_of_fury)
				and BuffPresent(storm_earth_and_fire_buff)
				and Chi() >= 3
			}

			AddFunction StormEarthFire_RisingSunKick_Use
			{
					not SpellCooldown(rising_sun_kick)
				and BuffPresent(storm_earth_and_fire_buff)
				and Chi() == 2
				and Energy() < MaxEnergy()
			}

			AddFunction StormEathFire_StormEathFire_Use
			{
					not BuffPresent(storm_earth_and_fire_buff)
				and SpellCharges(storm_earth_and_fire) >= 1
				and target.TimeToDie() <= 25
			}

			AddFunction StormEathFire_StormEathFire_Use_FistsOfFury
			{
					not BuffPresent(storm_earth_and_fire_buff)
				and SpellCharges(storm_earth_and_fire) >= 1
				and SpellCooldown(fists_of_fury) <= 1
				and Chi() >= 3
			}

			AddFunction StormEathFire_StormEathFire_Use_FullCharges
			{
					not BuffPresent(storm_earth_and_fire_buff)
				and SpellCharges(storm_earth_and_fire) == 2
			}

			AddFunction StormEathFire_StormEathFire_Use_TouchOfDeath
			{
					not BuffPresent(storm_earth_and_fire_buff)
				and SpellCharges(storm_earth_and_fire) >= 1
				and	{		
							SpellCooldown(touch_of_death) <= 8			
						 or SpellCooldown(touch_of_death) > 85
					}
			}

			AddFunction StormEarthFire_TigerPalm_Use
			{
					not SpellCooldown(tiger_palm)
				and BuffPresent(storm_earth_and_fire_buff)
				and Energy() == MaxEnergy()
				and Chi() < 1
			}

			###
			### Storm, Earth and Fire Rotation - Usage
			###
			AddFunction Rotation_StormEarthFire_Use
			{
					not BuffPresent(serenity_buff)
				and not LegendaryEquipped(drinking_horn_cover)
				and {
							{
									SpellKnown(strike_of_the_windlord)
								and SpellCooldown(strike_of_the_windlord) <= 14
								and SpellCooldown(fists_of_fury) <= 6
								and SpellCooldown(rising_sun_kick) <= 6
							}
						 or BuffPresent(storm_earth_and_fire)
						 or SpellCharges(storm_earth_and_fire) >= 2
						 or target.TimeToDie() <= 25
						 or SpellCooldown(touch_of_death) >= 85
					}
			}

			AddFunction Rotation_StormEarthFire_Use_DrinkingHornCover
			{
					not BuffPresent(serenity_buff)
				and LegendaryEquipped(drinking_horn_cover)
				and {
							{
									SpellCooldown(fists_of_fury) <= 1
								and Chi() >= 3
							}
						 or BuffPresent(storm_earth_and_fire)
						 or SpellCharges(storm_earth_and_fire) >= 2
						 or target.TimeToDie() <= 25
						 or SpellCooldown(touch_of_death) >= 85
					}
			}

			###
			### Storm, Earth and Fire Rotation
			###
			AddFunction Rotation_StormEarthFire
			{
				if StormEarthFire_TigerPalm_Use() Spell(tiger_palm)

				# Check the cooldowns to use.
				Rotation_Cooldowns()

				if CheckBoxOn(opt_sef) and StormEathFire_StormEathFire_Use_TouchOfDeath() Spell(storm_earth_and_fire)
				if CheckBoxOn(opt_sef) and StormEathFire_StormEathFire_Use_FullCharges() Spell(storm_earth_and_fire)
				if CheckBoxOn(opt_sef) and StormEathFire_StormEathFire_Use() Spell(storm_earth_and_fire)
				if CheckBoxOn(opt_sef) and StormEathFire_StormEathFire_Use_FistsOfFury() Spell(storm_earth_and_fire)
				if CheckBoxOn(opt_fists_of_fury) and StormEarthFire_FistsOfFury_Use() Spell(fists_of_fury)
				if StormEarthFire_RisingSunKick_Use() Spell(rising_sun_kick)
			}

			###
			### Main Icon Rotation - Functions
			###
			AddFunction Main_Serenity_Use
			{
					Talent(serenity_talent)
				and not SpellCooldown(serenity)
			}

			AddFunction Main_TouchOfDeath_Use
			{
					not SpellCooldown(touch_of_death)
				and target.TimeToDie() <= 9
			}

			###
			### Main Icon Rotation
			##
			AddFunction Main
			{
				if CheckBoxOn(opt_death_touch) and Main_TouchOfDeath_Use() Spell(touch_of_death)
				if CheckBoxOn(opt_serenity) and Main_Serenity_Use() Spell(serenity)

				# Call Serenity Rotation
				if Rotation_Serenity_Use() Rotation_Serenity()

				# Call Storm, Earth and Fire Rotation
				if Rotation_StormEarthFire_Use() Rotation_StormEarthFire()
				if Rotation_StormEarthFire_Use_DrinkingHornCover() Rotation_StormEarthFire()

				# Call Standard Rotation
				if Rotation_Standard_Use() Rotation_Standard()
			}

			AddFunction Main_Precombat
			{
			}

			###
			### CD Icon Rotation - Functions
			###
			AddFunction CD_ArcaneTorrent_Use
			{
					ChiDeficit() >= 1
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and {
									BuffPresent(serenity_buff)
								 or BuffPresent(storm_earth_and_fire_buff)
								 or {
											not Talent(serenity_talent)
										and BuffPresent(trinket_proc_agility_buff)
									}
							}
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 60
			}

			AddFunction CD_TouchOfKarma_Use
			{
					not SpellCooldown(touch_of_karma)
				and not BuffPresent(touch_of_karma_buff)
				and HealthPercent() <= 40
			}

			###
			### CD Icon Rotation
			##
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
				if not CheckBoxOn(opt_death_touch) and Main_TouchOfDeath_Use() Spell(touch_of_death)
				if not CheckBoxOn(opt_serenity) and Main_Serenity_Use() Spell(serenity)

				# Call Serenity Rotation
				if Rotation_Serenity_Use()
				{
					if not CheckBoxOn(opt_invoke_xuen) and Cooldowns_InvokeXuen_Use() Spell(invoke_xuen)
					if not CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use() Spell(touch_of_death)
					if not CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use_GaleBurst() Spell(touch_of_death) 
					if not CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use_GaleBurst_Serenity() Spell(touch_of_death) 	
					if not CheckBoxOn(opt_draught_of_souls) and Cooldowns_DraughtOfSouls_Use_Serenity() Item(draught_of_souls)
					if not CheckBoxOn(opt_draught_of_souls) and Cooldowns_DraughtOfSouls_Use() Item(draught_of_souls)
					if not CheckBoxOn(opt_draught_of_souls) and Serenity_DraughtOfSouls_Use() Item(draught_of_souls)
				}

				# Call Storm, Earth and Fire Rotation
				if Rotation_StormEarthFire_Use() or Rotation_StormEarthFire_Use_DrinkingHornCover()
				{
					if  not CheckBoxOn(opt_invoke_xuen) and Cooldowns_InvokeXuen_Use() Spell(invoke_xuen)
					if not CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use() Spell(touch_of_death)
					if not CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use_GaleBurst() Spell(touch_of_death) 
					if not CheckBoxOn(opt_death_touch) and Cooldowns_TouchOfDeath_Use_GaleBurst_Serenity() Spell(touch_of_death) 	
					if not CheckBoxOn(opt_draught_of_souls) and Cooldowns_DraughtOfSouls_Use_Serenity() Item(draught_of_souls)
					if not CheckBoxOn(opt_draught_of_souls) and Cooldowns_DraughtOfSouls_Use() Item(draught_of_souls)
					if not CheckBoxOn(opt_sef) and StormEathFire_StormEathFire_Use_TouchOfDeath() Spell(storm_earth_and_fire)
					if not CheckBoxOn(opt_sef) and StormEathFire_StormEathFire_Use_FullCharges() Spell(storm_earth_and_fire)
					if not CheckBoxOn(opt_sef) and StormEathFire_StormEathFire_Use() Spell(storm_earth_and_fire)
					if not CheckBoxOn(opt_sef) and StormEathFire_StormEathFire_Use_FistsOfFury() Spell(storm_earth_and_fire)
				}

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() and Talent(serenity_talent) Item(potion_of_the_old_war)
				if LunaEclipse_Potion_Use() and CD_Potion_Use() and not Talent(serenity_talent) Item(potion_of_prolonged_power)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_touch_of_karma) and CD_TouchOfKarma_Use() Spell(touch_of_karma)

				# Standard Actions
				Spell(blood_fury_ap)
				Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_chi)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Potion
				if LunaEclipse_Potion_Use() and Talent(serenity_talent) Item(potion_of_the_old_war)
				if LunaEclipse_Potion_Use() and not Talent(serenity_talent) Item(potion_of_prolonged_power)
			}

			###
			### Rotation icons.
			###
			AddIcon checkbox=opt_multi_dot help=multidot
			{
				if not InCombat() MultiDot_Precombat()
				MultiDot()
			}

			AddIcon help=shortcd
			{
				if not InCombat() ShortCD_Precombat()
				ShortCD()
			}

			AddIcon checkbox=opt_single_target enemies=1 help=main
			{
				if not InCombat() Main_Precombat()
				Main()
			}

			AddIcon help=aoe
			{
				if not InCombat() Main_Precombat()
				Main()
			}

			AddIcon help=cd
			{
				if not InCombat() CD_Precombat()
				CD()
			}
		]];

		OvaleScripts:RegisterScript("MONK", "windwalker", name, desc, code, "script");
	end
end