local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_warlock_affliction";
		local desc = "LunaEclipse: Affliction Warlock";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.WARLOCK_AFFLICTION,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Preciousyipz",
			GuideLink = "http://www.icy-veins.com/wow/affliction-warlock-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "3101013",
			["Raiding (AOE)"] = "2201011",
			["Dungeons / Mythic+"] = "3102033",
			["Easy Mode"] = "3201013",
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
					OPT_SEED_CORRUPTION = {
						type = "toggle",
						name = BINDING_NAME_OPT_SEED_CORRUPTION,
						desc = functionsConfiguration:getAOETooltip("Seed of Corruption"),
						arg = "OPT_SEED_CORRUPTION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_PHANTOM_SINGULARITY = {
						type = "toggle",
						name = BINDING_NAME_OPT_PHANTOM_SINGULARITY,
						desc = functionsConfiguration:getAOETooltip("Phantom Singularity"),
						arg = "OPT_PHANTOM_SINGULARITY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
				},
			},
			settingsCooldowns = {
				type = "group",
				name = BINDING_HEADER_COOLDOWNS,
				inline = true,
				order = 30,
				args = {
					OPT_EMPOWERED_LIFE_TAP = {
						type = "toggle",
						name = BINDING_NAME_OPT_EMPOWERED_LIFE_TAP,
						desc = functionsConfiguration:getCooldownTooltip("Empowered Life Tap"),
						arg = "OPT_EMPOWERED_LIFE_TAP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 10,
					},
					OPT_GREATER_DEMONS = {
						type = "toggle",
						name = BINDING_NAME_OPT_GREATER_DEMONS,
						desc = functionsConfiguration:getCooldownTooltip("Summon Doomguard and Summon Infernal", "CD"),
						arg = "OPT_GREATER_DEMONS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_GRIMOIRE_SERVICE = {
						type = "toggle",
						name = BINDING_NAME_OPT_GRIMOIRE_SERVICE,
						desc = functionsConfiguration:getCooldownTooltip("Grimoire of Service", "CD"),
						arg = "OPT_GRIMOIRE_SERVICE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 30,
					},
					OPT_HAUNT = {
						type = "toggle",
						name = BINDING_NAME_OPT_HAUNT,
						desc = functionsConfiguration:getCooldownTooltip("Haunt"),
						arg = "OPT_HAUNT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_REAP_SOULS = {
						type = "toggle",
						name = BINDING_NAME_OPT_REAP_SOULS,
						desc = functionsConfiguration:getCooldownTooltip("Reap Souls"),
						arg = "OPT_REAP_SOULS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_SOUL_EFFIGY = {
						type = "toggle",
						name = BINDING_NAME_OPT_SOUL_EFFIGY,
						desc = functionsConfiguration:getCooldownTooltip("Soul Effigy"),
						arg = "OPT_SOUL_EFFIGY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_SOUL_HARVEST = {
						type = "toggle",
						name = BINDING_NAME_OPT_SOUL_HARVEST,
						desc = functionsConfiguration:getCooldownTooltip("Soul Harvest", "CD"),
						arg = "OPT_SOUL_HARVEST",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 70,
					},
				},
			},
			settingsDefensive = {
				type = "group",
				name = BINDING_HEADER_DEFENSIVE,
				inline = true,
				order = 40,
				args = {
					OPT_DARK_PACT = {
						type = "toggle",
						name = BINDING_NAME_OPT_DARK_PACT,
						desc = functionsConfiguration:getDefensiveTooltip("Dark Pact", "ShortCD", "40%"),
						arg = "OPT_DARK_PACT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_UNENDING_RESOLVE = {
						type = "toggle",
						name = BINDING_NAME_OPT_UNENDING_RESOLVE,
						desc = functionsConfiguration:getDefensiveTooltip("Unending Resolve", "CD", "40%"),
						arg = "OPT_UNENDING_RESOLVE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
				},
			},
			settingSpecial = {
				type = "group",
				name = BINDING_HEADER_SPECIAL,
				inline = true,
				order = 60,
				args = {
					OPT_LIFE_TAP = {
						type = "toggle",
						name = BINDING_NAME_OPT_LIFE_TAP,
						desc = string.format("%s\n\n%s", functionsConfiguration:getBuffTooltip("Life Tap"), "This will only be suggested if you are below 40% mana!"),
						arg = "OPT_LIFE_TAP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(lunaeclipse_warlock_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_seed_corruption "AOE: Seed of Corruption" default)
			AddCheckBox(opt_phantom_singularity "AOE CD: Phantom Singularity" default)
			AddCheckBox(opt_empowered_life_tap "Cooldown: Empowered Life Tap" default)
			AddCheckBox(opt_greater_demons "Cooldown: Greater Demons" default)
			AddCheckBox(opt_grimoire_service "Cooldown: Grimoire of Service" default)
			AddCheckBox(opt_haunt "Cooldown: Haunt" default)			
			AddCheckBox(opt_reap_souls "Cooldown: Reap Souls" default)
			AddCheckBox(opt_soul_effigy "Cooldown: Soul Effigy" default)
			AddCheckBox(opt_soul_harvest "Cooldown: Soul Harvest" default)
			AddCheckBox(opt_dark_pact "Defensive: Dark Pact" default)
			AddCheckBox(opt_unending_resolve "Defensive: Unending Resolve" default)
			AddCheckBox(opt_life_tap "Mana: Life Tap" default)

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible() and target.Distance() < 8 Spell(arcane_torrent_mana)
			}

			###
			### MultiDot Icon Rotations - Functions
			###
			AddFunction MultiDot_Agony_Use
			{
					not SpellCooldown(agony)
				and DOTTargetCount(agony_debuff) < MultiDOTTargets()
			}

			AddFunction MultiDot_Corruption_Use
			{
					not SpellCooldown(corruption)
				and DOTTargetCount(corruption_debuff) < MultiDOTTargets()
			}

			AddFunction MultiDot_SiphonLife_Use
			{
					Talent(siphon_life_talent)
				and not SpellCooldown(siphon_life)
				and DOTTargetCount(siphon_life_debuff) <  MultiDOTTargets()
			}

			###
			### MultiDot Icon Rotations
			###
			AddFunction MultiDot
			{
				if MultiDot_Agony_Use() Spell(agony text=multi)
				if MultiDot_Corruption_Use() Spell(corruption text=multi)
				if MultiDot_SiphonLife_Use() Spell(siphon_life text=multi)
			}

			AddFunction MultiDot_Precombat
			{
			}

			###
			### ShortCD Icon Rotations - Functions
			###
			AddFunction ShortCD_DarkPact_Use
			{
					Talent(dark_pact_talent)
				and not SpellCooldown(dark_pact)
				and HealthPercent() <= 40
			}

			AddFunction Rotation_SummonDemon
			{
				if Talent(grimoire_of_supremacy_talent) and { not pet.Present() or not pet.CreatureFamily(Doomguard) } Spell(summon_doomguard)
				if Talent(grimoire_of_service_talent) and { not pet.Present() or not pet.CreatureFamily(Felhunter) } Spell(summon_felhunter)
				if Talent(grimoire_of_sacrifice_talent) and not BuffPresent(grimoire_of_sacrifice_buff) and pet.Present() and pet.CreatureFamily(Felhunter) Spell(grimoire_of_sacrifice)
				if Talent(grimoire_of_sacrifice_talent) and not BuffPresent(grimoire_of_sacrifice_buff) and { not pet.Present() or not pet.CreatureFamily(Felhunter) } Spell(summon_felhunter)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Summon pet if needed
				Rotation_SummonDemon()

				# Short Cooldown Spells
				if not CheckBoxOn(opt_reap_souls) and Main_ReapSouls_Use() Spell(reap_souls)
				if not CheckBoxOn(opt_empowered_life_tap) and Main_LifeTap_Use_Empowered_Expiring() Spell(life_tap)
				if not CheckBoxOn(opt_phantom_singularity) and Main_PhantomSingularity_Use() Spell(phantom_singularity)
				if not CheckBoxOn(opt_haunt) and Main_Haunt_Use() Spell(haunt)
				if not CheckBoxOn(opt_empowered_life_tap) and Main_LifeTap_Use_Empowered() Spell(life_tap)
				if not CheckBoxOn(opt_seed_corruption) and Main_SeedOfCorruption_Use() Spell(seed_of_corruption)
				if not CheckBoxOn(opt_reap_souls) and Main_ReapSouls_Use_MaleficGrasp() Spell(reap_souls)
				if not CheckBoxOn(opt_reap_souls) and Main_ReapSouls_Use_UnstableAffliction() Spell(reap_souls)
				
				# Mana Regen
				if not CheckBoxOn(opt_life_tap) and Main_LifeTap_Use_LowMana() Spell(life_tap)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_dark_pact) and ShortCD_DarkPact_Use() Spell(dark_pact)
			}

			AddFunction ShortCD_Precombat
			{
				# Summon pet if needed
				Rotation_SummonDemon()
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_Agony_Use
			{
					not SpellCooldown(agony)
				and not Talent(malefic_grasp_talent)
				and target.InPandemicRange(agony_debuff agony)
				and target.TimeToDie() >= target.DebuffRemaining(agony_debuff)
			}

			AddFunction Main_Agony_Use_Expiring
			{
					not SpellCooldown(agony)
				and target.DebuffRemaining(agony_debuff) <= TickTime(agony_debuff) + GCD()
			}

			AddFunction Main_Agony_Use_NoUnstableAffliction
			{
					not SpellCooldown(agony)
				and target.InPandemicRange(agony_debuff agony)
				and target.TimeToDie() >= target.DebuffRemaining(agony_debuff)
				and not target.DebuffPresent(unstable_affliction_debuff)
			}

			AddFunction Main_Corruption_Use
			{
					not SpellCooldown(corruption)
				and not Talent(malefic_grasp_talent)
				and target.InPandemicRange(corruption_debuff corruption)
				and target.TimeToDie() >= target.DebuffRemaining(corruption_debuff)
			}

			AddFunction Main_Corruption_Use_Expiring
			{
					not SpellCooldown(corruption)
				and target.DebuffRemaining(corruption_debuff) <= TickTime(corruption_debuff) + GCD()
				and {
							{
									Enemies() < 3
								and Talent(sow_the_seeds_talent)
							}
						 or Enemies() < 4
					}
				and {
							{
									target.DebuffStacks(unstable_affliction_debuff) < 2
								and SoulShards() == 0
							}
						 or not Talent(malefic_grasp_talent)
					}
			}

			AddFunction Main_Corruption_Use_Expiring_AOE
			{
					not SpellCooldown(corruption)
				and {
							Talent(absolute_corruption_talent)
						 or not Talent(malefic_grasp_talent)
						 or not Talent(soul_effigy_talent)
					}
				and Enemies() > 1
				and target.DebuffRemaining(corruption_debuff) <= TickTime(corruption_debuff) + GCD()
				and {
							{
									Enemies() < 3
								and Talent(sow_the_seeds_talent)
							}
						 or Enemies() < 4
					}
			}

			AddFunction Main_Corruption_Use_NoUnstableAffliction
			{
					not SpellCooldown(corruption)
				and target.InPandemicRange(corruption_debuff corruption)
				and target.TimeToDie() >= target.DebuffRemaining(corruption_debuff)
				and not target.DebuffPresent(unstable_affliction_debuff)
			}

			AddFunction Main_Corruption_Use_Refresh
			{
					not SpellCooldown(corruption)
				and {
							Talent(absolute_corruption_talent)
						 or not Talent(malefic_grasp_talent)
						 or not Talent(soul_effigy_talent)
					}
				and target.InPandemicRange(corruption_debuff corruption)
				and target.TimeToDie() >= target.DebuffRemaining(corruption_debuff)
			}
			
			AddFunction Main_Doomguard_Summon
			{
					not SpellCooldown(summon_doomguard)
				and not Talent(grimoire_of_supremacy_talent)
				and Enemies() <= 2
				and {
							target.TimeToDie() > 180
						 or target.HealthPercent() <= 20
						 or target.TimeToDie() < 30
					}
				and SoulShards() >= 1
			}

			AddFunction Main_Doomguard_Summon_SindoreiSpite
			{
					not SpellCooldown(summon_doomguard)
				and Talent(grimoire_of_supremacy_talent)
				and Enemies() == 1
				and LegendaryEquipped(sindorei_spite)
				and not SindoreiSpiteCooldown()
				and SoulShards() >= 1
			}

			AddFunction Main_DrainSoul_Use
			{
					not SpellCooldown(drain_soul)
			}

			AddFunction Main_Felhunter_Summon_Service
			{
					Talent(grimoire_of_service_talent)
				and not SpellCooldown(service_felhunter)
				and target.DebuffPresent(corruption_debuff)
				and target.DebuffPresent(agony_debuff)
				and SoulShards() >= 1
			}

			AddFunction Main_Haunt_Use
			{
					Talent(haunt_talent)
				and not SpellCooldown(haunt)
			}

			AddFunction Main_Infernal_Summon
			{
					not SpellCooldown(summon_infernal)
				and not Talent(grimoire_of_supremacy_talent)
				and Enemies() > 2
				and SoulShards() >= 1
			}

			AddFunction Main_Infernal_Summon_SindoreiSpite
			{
					not SpellCooldown(summon_infernal)
				and Talent(grimoire_of_supremacy_talent)
				and Enemies() > 1
				and LegendaryEquipped(sindorei_spite)
				and not SindoreiSpiteCooldown()
				and SoulShards() >= 1
			}

			AddFunction Main_LifeTap_Use
			{
					not SpellCooldown(life_tap)
			}

			AddFunction Main_LifeTap_Use_Empowered
			{
					not SpellCooldown(life_tap)
				and Talent(empowered_life_tap_talent)
				and {
							InPandemicRange(empowered_life_tap_buff life_tap)
						 or {
									Talent(malefic_grasp_talent)
								and target.TimeToDie() > 15
								and ManaPercent() < 10
							}
					}
			}

			AddFunction Main_LifeTap_Use_Empowered_Expiring
			{
					not SpellCooldown(life_tap)
				and Talent(empowered_life_tap_talent)
				and BuffRemaining(empowered_life_tap_buff) <= GCD()
			}

			AddFunction Main_LifeTap_Use_LowMana
			{
					not SpellCooldown(life_tap)
				and ManaPercent() < 10
			}

			AddFunction Main_PhantomSingularity_Use
			{
					Talent(phantom_singularity_talent)
				and not SpellCooldown(phantom_singularity)
			}

			AddFunction Main_ReapSouls_Use
			{
					SpellKnown(reap_souls)
				and not SpellCooldown(reap_souls)
				and not BuffPresent(deadwind_harvester_buff)
				and {
							{
									{
											{
													not LegendaryEquipped(reap_and_sow)
												and BuffRemaining(soul_harvest_buff) > 5
											}
										 or {
													LegendaryEquipped(reap_and_sow)
												and	BuffRemaining(soul_harvest_buff) > 5 + 1.5
											}
									} 
								 and not Talent(malefic_grasp_talent)
								 and target.DebuffStacks(unstable_affliction_debuff) > 1
							}
						 or BuffStacks(tormented_souls) >= 8
						 or {
									{
											not LegendaryEquipped(reap_and_sow)
										and target.TimeToDie() <= BuffStacks(tormented_souls_buff) * 5
									}
								 or {
											LegendaryEquipped(reap_and_sow)
										and target.TimeToDie() <= BuffStacks(tormented_souls_buff) * 5 + 1.5
									}
							}
						 or {
									not Talent(malefic_grasp_talent)
								and {
											BuffPresent(trinket_stat_any_buff)
										 or BuffPresent(trinket_stacking_proc_any_buff)
									}
							}
					}
			}

			AddFunction Main_ReapSouls_Use_MaleficGrasp
			{
					SpellKnown(reap_souls)
				and not SpellCooldown(reap_souls)
				and not BuffPresent(deadwind_harvester_buff)
				and target.DebuffStacks(unstable_affliction_debuff) > 1
				and {
							{
									not BuffPresent(trinket_stacking_proc_any_buff)
								and not BuffPresent(trinket_stat_any_buff)
							}
						 or Talent(malefic_grasp_talent)
					}
			}

			AddFunction Main_ReapSouls_Use_UnstableAffliction
			{
					SpellKnown(reap_souls)
				and not SpellCooldown(reap_souls)
				and not BuffPresent(deadwind_harvester_buff)
				and PreviousGCDSpell(unstable_affliction)
				and {
							{
									not BuffPresent(trinket_stacking_proc_any_buff)
								and not BuffPresent(trinket_stat_any_buff)
							}
						 or Talent(malefic_grasp_talent)
					}
				and BuffStacks(tormented_souls_buff) > 1
			}

			AddFunction Main_SeedOfCorruption_Use
			{
					not SpellCooldown(seed_of_corruption)
				and {
							{
									Talent(sow_the_seeds_talent)
								and Enemies() >= 3
							}
						 or Enemies() >= 4
						 or {
									Enemies() - DOTTargetCount(corruption_debuff) >= 3
								and target.DebuffRemaining(corruption_debuff) <= CastTime(seed_of_corruption) + TravelTime(seed_of_corruption)
							}
					}
			}

			AddFunction Main_SiphonLife_Use
			{
					Talent(siphon_life_talent)
				and not SpellCooldown(siphon_life)
				and not Talent(malefic_grasp_talent)
				and target.InPandemicRange(siphon_life_debuff siphon_life)
				and target.TimeToDie() >= target.DebuffRemaining(siphon_life_debuff)
			}

			AddFunction Main_SiphonLife_Use_Expiring
			{
					Talent(siphon_life_talent)
				and not SpellCooldown(siphon_life)
				and target.DebuffRemaining(siphon_life_debuff) <= TickTime(siphon_life_debuff) + GCD()
				and {
							{
									target.DebuffStacks(unstable_affliction_debuff) < 2
								and SoulShards() == 0
							}
						 or not Talent(malefic_grasp_talent)
					}
			}

			AddFunction Main_SiphonLife_Use_Expiring_AOE
			{
					Talent(siphon_life_talent)
				and not SpellCooldown(siphon_life)
				and {
							not Talent(malefic_grasp_talent)
						 or not Talent(soul_effigy_talent)
					}
				and Enemies() > 1
				and target.DebuffRemaining(siphon_life_debuff) <= TickTime(siphon_life_debuff) + GCD()
			}

			AddFunction Main_SiphonLife_Use_NoUnstableAffliction
			{
					Talent(siphon_life_talent)
				and not SpellCooldown(siphon_life)
				and target.InPandemicRange(siphon_life_debuff siphon_life)
				and target.TimeToDie() >= target.DebuffRemaining(siphon_life_debuff)
				and not target.DebuffPresent(unstable_affliction_debuff)
			}

			AddFunction Main_SiphonLife_Use_Refresh
			{
					Talent(siphon_life_talent)
				and not SpellCooldown(siphon_life)
				and {
							not Talent(malefic_grasp_talent)					
						 or not Talent(soul_effigy_talent)
					}
				and target.InPandemicRange(siphon_life_debuff siphon_life)
				and target.TimeToDie() >= target.DebuffRemaining(siphon_life_debuff)
			}

			AddFunction Main_SoulEffigy_Use
			{
					Talent(soul_effigy_talent)
				and not SpellCooldown(soul_effigy)
				and not EffigyActive()
			}

			AddFunction Main_SoulHarvest_Use
			{
					Talent(soul_harvest_talent)
				and not SpellCooldown(soul_harvest)
				and {
							target.DebuffStacks(unstable_affliction_debuff) >= 3
						 or {
									not LegendaryEquipped(hood_of_eternal_disdain)
								and not LegendaryEquipped(power_cord_of_lethtendris)
								and {
											target.DebuffPresent(haunt_debuff)
										 or Talent(writhe_in_agony_talent)
									}
							}
					}
			}

			AddFunction Main_UnstableAffliction_Use
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Enemies() < 4
				and Talent(malefic_grasp_talent)
				and not Talent(soul_effigy_talent)
				and not LegendaryEquipped(power_cord_of_lethtendris)
				and not PreviousGCDSpell(unstable_affliction count=3)
				and target.DebuffRemaining(agony_debuff) > CastTime(unstable_affliction) * 3 + 6.5
				and {
							target.DebuffRemaining(corruption_debuff) > CastTime(unstable_affliction) * 3 + 6.5
						 or Talent(absolute_corruption_talent)
					}
				and SoulShards() >= 1
			}

			AddFunction Main_UnstableAffliction_Use_Contagion
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Enemies() < 4
				and Talent(writhe_in_agony_talent)
				and Talent(contagion_talent)
				and target.DebuffRemaining(unstable_affliction_debuff) < CastTime(unstable_affliction)
				and SoulShards() >= 1
			}

			AddFunction Main_UnstableAffliction_Use_Dying
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Enemies() < 4
				and Talent(malefic_grasp_talent)
				and {
							target.TimeToDie() < 30
						 or {
									PreviousGCDSpell(unstable_affliction)
								and SoulShards() >= 4
							}
					}
				and SoulShards() >= 1
			}

			AddFunction Main_UnstableAffliction_Use_Haunt
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Talent(haunt_talent)
				and {
							SoulShards() >= 4
						 or target.DebuffRemaining(haunt_debuff) > 6.5
						 or target.TimeToDie() < 30
					}
				and SoulShards() >= 1
			}

			AddFunction Main_UnstableAffliction_Use_PowerCordLethtendris
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Enemies() < 4
				and Talent(malefic_grasp_talent)
				and LegendaryEquipped(power_cord_of_lethtendris)
				and not target.DebuffPresent(unstable_affliction_debuff)
				and SoulShards() >= 1
			}

			AddFunction Main_UnstableAffliction_Use_PowerCordLethtendris_SoulEffigy
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Enemies() < 4
				and Talent(malefic_grasp_talent)
				and {
							Talent(soul_effigy_talent)
						 or LegendaryEquipped(power_cord_of_lethtendris)
					}
				and not PreviousGCDSpell(unstable_affliction count=3)
				and PreviousGCDSpell(unstable_affliction)
				and SoulShards() >= 1
			}

			AddFunction Main_UnstableAffliction_Use_SoulEffigy
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Enemies() < 4
				and Talent(malefic_grasp_talent)
				and Talent(soul_effigy_talent)
				and not LegendaryEquipped(power_cord_of_lethtendris)
				and not target.DebuffPresent(unstable_affliction_debuff)
				and target.DebuffRemaining(agony_debuff) > CastTime(unstable_affliction) * 3 + 6.5
				and EffigyDOTRemaining(agony_debuff) > CastTime(unstable_affliction) * 3 + 6.5
				and SoulShards() >= 1
			}

			AddFunction Main_UnstableAffliction_Use_SoulShards
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Enemies() < 4
				and Talent(malefic_grasp_talent)
				and {
							SoulShards() == 5
						 or {
									Talent(contagion_talent)
								and SoulShards() >=4
							}
					}
				and SoulShards() >= 1
			}

			AddFunction Main_UnstableAffliction_Use_WriteInAgony
			{
					not SpellCooldown(unstable_affliction)
				and {
							not Talent(sow_the_seeds_talent)
						 or Enemies() < 3
					}
				and Enemies() < 4
				and Talent(writhe_in_agony_talent)
				and {
							SoulShards() >= 4
						 or BuffPresent(trinket_proc_intellect_buff)
						 or BuffPresent(trinket_stacking_proc_mastery_buff)	
						 or BuffPresent(trinket_proc_mastery_buff)
						 or BuffPresent(trinket_proc_crit_buff)
						 or BuffPresent(trinket_proc_versatility_buff)
						 or BuffPresent(soul_harvest_buff)
						 or BuffPresent(deadwind_harvester_buff)
						 or BuffStacks(compounding_horror_buff) == 5
						 or target.TimeToDie() <= 20
					}
				and SoulShards() >= 1
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				if CheckBoxOn(opt_reap_souls) and Main_ReapSouls_Use() Spell(reap_souls)
				if CheckBoxOn(opt_soul_effigy) and Main_SoulEffigy_Use() Spell(soul_effigy)
				if Main_Agony_Use_Expiring() Spell(agony)
				if CheckBoxOn(opt_grimoire_service) and Main_Felhunter_Summon_Service() Spell(service_felhunter)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)
				if CheckBoxOn(opt_soul_harvest) and Main_SoulHarvest_Use() Spell(soul_harvest)
				if Main_Corruption_Use_Expiring() Spell(corruption)
				if Main_Corruption_Use_Expiring_AOE() Spell(corruption)
				if Main_SiphonLife_Use_Expiring() Spell(siphon_life)
				if Main_SiphonLife_Use_Expiring_AOE() Spell(siphon_life)
				if CheckBoxOn(opt_empowered_life_tap) and Main_LifeTap_Use_Empowered_Expiring() Spell(life_tap)
				if CheckBoxOn(opt_phantom_singularity) and Main_PhantomSingularity_Use() Spell(phantom_singularity)
				if CheckBoxOn(opt_haunt) and Main_Haunt_Use() Spell(haunt)
				if Main_Agony_Use() Spell(agony)
				if Main_Agony_Use_NoUnstableAffliction() Spell(agony)
				if CheckBoxOn(opt_empowered_life_tap) and Main_LifeTap_Use_Empowered() Spell(life_tap)
				if CheckBoxOn(opt_seed_corruption) and Main_SeedOfCorruption_Use() Spell(seed_of_corruption)
				if Main_Corruption_Use() Spell(corruption)
				if Main_Corruption_Use_NoUnstableAffliction() Spell(corruption)
				if Main_Corruption_Use_Refresh() Spell(corruption)
				if Main_SiphonLife_Use() Spell(siphon_life)
				if Main_SiphonLife_Use_NoUnstableAffliction() Spell(siphon_life)
				if Main_SiphonLife_Use_Refresh() Spell(siphon_life)
				if Main_UnstableAffliction_Use_Haunt() Spell(unstable_affliction)
				if Main_UnstableAffliction_Use_Contagion() Spell(unstable_affliction)
				if Main_UnstableAffliction_Use_WriteInAgony() Spell(unstable_affliction)
				if Main_UnstableAffliction_Use_Dying() Spell(unstable_affliction)
				if Main_UnstableAffliction_Use_SoulShards() Spell(unstable_affliction)
				if Main_UnstableAffliction_Use_PowerCordLethtendris_SoulEffigy() Spell(unstable_affliction)
				if Main_UnstableAffliction_Use_PowerCordLethtendris() Spell(unstable_affliction)
				if Main_UnstableAffliction_Use_SoulEffigy() Spell(unstable_affliction)
				if Main_UnstableAffliction_Use() Spell(unstable_affliction)
				if CheckBoxOn(opt_reap_souls) and Main_ReapSouls_Use_MaleficGrasp() Spell(reap_souls)
				if CheckBoxOn(opt_reap_souls) and Main_ReapSouls_Use_UnstableAffliction() Spell(reap_souls)
				if CheckBoxOn(opt_life_tap) and Main_LifeTap_Use_LowMana() Spell(life_tap)
				if Main_DrainSoul_Use() Spell(drain_soul)
				if CheckBoxOn(opt_life_tap) and Main_LifeTap_Use() Spell(life_tap)
			}

			AddFunction Main_Precombat
			{
			}

			###
			### CD Icon Rotations - Functions
			###
			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and {
									not Talent(soul_harvest_talent)
								 or BuffPresent(soul_harvest_buff)
							}
						and {
									BuffPresent(trinket_proc_any_buff)
								 or BuffPresent(trinket_stacking_proc_any_buff)
								 or {
											Talent(haunt_talent)
										and not SpellCooldown(haunt)
									}
								 or target.DebuffStacks(unstable_affliction_debuff) >= 3
							}
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 40
			}

			AddFunction CD_UnendingResolve_Use
			{
					not SpellCooldown(unending_resolve)
				and HealthPercent() <= 40
			}

			###
			### CD Icon Rotations
			###
			AddFunction CD
			{				
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
				if not CheckBoxOn(opt_grimoire_service) and Main_Felhunter_Summon_Service() Spell(service_felhunter)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)
				if not CheckBoxOn(opt_soul_harvest) and Main_SoulHarvest_Use() Spell(soul_harvest)

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_prolonged_power)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_unending_resolve) and CD_UnendingResolve_Use() Spell(unending_resolve)

				# Standard Actions
				Spell(blood_fury_sp)
				Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) Spell(arcane_torrent_mana)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Cooldown Spells
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)

				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_prolonged_power)
			}

			###
			### Effigy Icon Rotations - Functions
			###
			AddFunction Effigy_Agony_Use
			{
					EffigyActive()
				and not SpellCooldown(agony)
				and EffigyInPandemicRange(agony_debuff agony)
			}

			AddFunction Effigy_Corruption_Use
			{
					EffigyActive()
				and not SpellCooldown(corruption)
				and EffigyInPandemicRange(corruption_debuff corruption)
			}

			AddFunction Effigy_SiphonLife_Use
			{
					Talent(siphon_life_talent)
				and EffigyActive()
				and not SpellCooldown(siphon_life)
				and EffigyInPandemicRange(siphon_life_debuff siphon_life)
			}

			###
			### Effigy Icon Rotations
			###
			AddFunction Effigy
			{
				if Main_SoulEffigy_Use() Spell(soul_effigy)
				if Effigy_Agony_Use() Spell(agony text=effigy)
				if Effigy_Corruption_Use() Spell(corruption text=effigy)
				if Effigy_SiphonLife_Use() Spell(siphon_life text=effigy)
			}

			AddFunction Effigy_Precombat
			{
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

			AddIcon talent=soul_effigy_talent help=effigy
			{
				if not InCombat() Effigy_Precombat()
				Effigy()
			}
		]];

		OvaleScripts:RegisterScript("WARLOCK", "affliction", name, desc, code, "script");
	end
end