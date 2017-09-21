local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_warlock_demonology";
		local desc = "LunaEclipse: Demonology Warlock";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.WARLOCK_DEMONOLOGY,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Imakki",
			GuideLink = "http://www.icy-veins.com/wow/demonology-warlock-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding"] = "3211022",
			["Dungeons / Mythic+"] = "3311031",
			["Solo / World Quests"] = "1331132",
			["Easy Mode"] = "1211022",
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
					OPT_DEMONWRATH = {
						type = "toggle",
						name = BINDING_NAME_OPT_DEMONWRATH,
						desc = functionsConfiguration:getAOETooltip("Demonwrath"),
						arg = "OPT_DEMONWRATH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_IMPLOSION = {
						type = "toggle",
						name = BINDING_NAME_OPT_IMPLOSION,
						desc = functionsConfiguration:getAOETooltip("Implosion"),
						arg = "OPT_IMPLOSION",
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
					OPT_DEMONIC_EMPOWERMENT = {
						type = "toggle",
						name = BINDING_NAME_OPT_DEMONIC_EMPOWERMENT,
						desc = functionsConfiguration:getCooldownTooltip("Demonic Empowerment"),
						arg = "OPT_DEMONIC_EMPOWERMENT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 10,
					},
					OPT_EMPOWERED_LIFE_TAP = {
						type = "toggle",
						name = BINDING_NAME_OPT_EMPOWERED_LIFE_TAP,
						desc = functionsConfiguration:getCooldownTooltip("Empowered Life Tap"),
						arg = "OPT_EMPOWERED_LIFE_TAP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
					OPT_GREATER_DEMONS = {
						type = "toggle",
						name = BINDING_NAME_OPT_GREATER_DEMONS,
						desc = functionsConfiguration:getCooldownTooltip("Summon Doomguard and Summon Infernal"),
						arg = "OPT_GREATER_DEMONS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_GRIMOIRE_SERVICE = {
						type = "toggle",
						name = BINDING_NAME_OPT_GRIMOIRE_SERVICE,
						desc = functionsConfiguration:getCooldownTooltip("Grimoire of Service"),
						arg = "OPT_GRIMOIRE_SERVICE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 40,
					},
					OPT_SHADOWFLAME = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHADOWFLAME,
						desc = functionsConfiguration:getCooldownTooltip("Shadowflame"),
						arg = "OPT_SHADOWFLAME",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_SOUL_HARVEST = {
						type = "toggle",
						name = BINDING_NAME_OPT_SOUL_HARVEST,
						desc = functionsConfiguration:getCooldownTooltip("Soul Harvest"),
						arg = "OPT_SOUL_HARVEST",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_SUMMON_DARKGLARE = {
						type = "toggle",
						name = BINDING_NAME_OPT_SUMMON_DARKGLARE,
						desc = functionsConfiguration:getCooldownTooltip("Summon Darkglare"),
						arg = "OPT_SUMMON_DARKGLARE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 70,
					},
					OPT_THALKIELS_CONSUMPTION = {
						type = "toggle",
						name = BINDING_NAME_OPT_THALKIELS_CONSUMPTION,
						desc = functionsConfiguration:getCooldownTooltip("Thalkiel's Consumption"),
						arg = "OPT_THALKIELS_CONSUMPTION",
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
			settingsPet = {
				type = "group",
				name = BINDING_HEADER_PET,
				inline = true,
				order = 50,
				args = {
					OPT_PET_FELSTORM = {
						type = "toggle",
						name = BINDING_NAME_OPT_PET_FELSTORM,
						desc = functionsConfiguration:getCooldownTooltip("Felguard's Felstorm"),
						arg = "OPT_PET_FELSTORM",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
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

			# Summoned Demons
			Define(creature_darkglare 103673)
			Define(creature_doomguard 11859)
			Define(creature_dreadstalker 98035)
			Define(creature_felguard 17252)
			Define(creature_felhunter 417)
			Define(creature_imp 416)
			Define(creature_infernal 89)
			Define(creature_succubus 1863)
			Define(creature_voidwalker 1860)
			Define(creature_wild_imp 55659)

			# Checkboxes
			AddCheckBox(opt_demonwrath "AOE: Demonwrath" default)
			AddCheckBox(opt_implosion "AOE CD: Implosion" default)
			AddCheckBox(opt_demonic_empowerment "Cooldown: Demonic Empowerment" default)
			AddCheckBox(opt_greater_demons "Cooldown: Greater Demons" default)
			AddCheckBox(opt_grimoire_service "Cooldown: Grimoire of Service" default)
			AddCheckBox(opt_shadowflame "Cooldown: Shadowflame" default)
			AddCheckBox(opt_soul_harvest "Cooldown: Soul Harvest" default)
			AddCheckBox(opt_summon_darkglare "Cooldown: Summon Darkglare" default)
			AddCheckBox(opt_thalkiels_consumption "Cooldown: Thalkiel's Consumption" default)
			AddCheckBox(opt_dark_pact "Defensive: Dark Pact" default)
			AddCheckBox(opt_unending_resolve "Defensive: Unending Resolve" default)
			AddCheckBox(opt_life_tap "Mana: Life Tap" default)
			AddCheckBox(opt_pet_felstorm "Pet: Felstorm" default)

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
			AddFunction MultiDot_Doom_Use
			{
					not Talent(hand_of_doom_talent)
				and not SpellCooldown(doom)
				and DOTTargetCount(doom_debuff) < MultiDOTTargets()
			}

			###
			### MultiDot Icon Rotations
			###
			AddFunction MultiDot
			{
				if MultiDot_Doom_Use() Spell(doom text=multi)
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
				if not Talent(grimoire_of_supremacy_talent) and { not pet.Present() or not pet.CreatureFamily(Felguard) } Spell(summon_felguard)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Summon pet if needed
				Rotation_SummonDemon()

				# Short Cooldown Spells
				if not CheckBoxOn(opt_implosion) and Main_Implosion_Use_HandOfGuldan() Spell(implosion)
				if not CheckBoxOn(opt_implosion) and Main_Implosion_Use() Spell(implosion)
				if not CheckBoxOn(opt_shadowflame) and Main_Shadowflame_Use_Expiring() Spell(shadowflame)
				if not CheckBoxOn(opt_summon_darkglare) and Main_Darkglare_Summon() Spell(summon_darkglare)
				if not CheckBoxOn(opt_summon_darkglare) and Main_Darkglare_Summon_NoDreadstalkers() Spell(summon_darkglare)
				if not CheckBoxOn(opt_summon_darkglare) and Main_Darkglare_Summon_Dreadstalkers() Spell(summon_darkglare)
				if not CheckBoxOn(opt_demonic_empowerment) and Main_DemonicEmpowerment_Use_PowerTrip() Spell(demonic_empowerment)
				if not CheckBoxOn(opt_demonic_empowerment) and Main_DemonicEmpowerment_Use() Spell(demonic_empowerment)
				if not CheckBoxOn(opt_shadowflame) and Main_Shadowflame_Use() Spell(shadowflame)
				if not CheckBoxOn(opt_thalkiels_consumption) and Main_ThalkielsConsumption_Use() Spell(thalkiels_consumption)
				if not CheckBoxOn(opt_pet_felstorm) and Main_Felstorm_Use() Spell(felguard_felstorm)
				if not CheckBoxOn(opt_demonwrath) and Main_Demonwrath_Use() Spell(demonwrath)
				if not CheckBoxOn(opt_demonwrath) and Main_Demonwrath_Use_Moving() Spell(demonwrath)

				# Mana Regen
				if not CheckBoxOn(opt_life_tap) and Main_LifeTap_Use_LowMana() Spell(life_tap)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_dark_pact) and ShortCD_DarkPact_Use() Spell(dark_pact)
			}

			AddFunction ShortCD_Precombat
			{
				# Summon pet if needed
				Rotation_SummonDemon()

				# Short Cooldown Spells
				if not CheckBoxOn(opt_demonic_empowerment) Spell(demonic_empowerment)
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_Darkglare_Summon
			{
					Talent(summon_darkglare_talent)
				and not SpellCooldown(summon_darkglare)
				and {
							{
									PreviousGCDSpell(hand_of_guldan)
								 or PreviousGCDSpell(call_dreadstalkers)
								 or Talent(power_trip_talent)
							}
					}
				and SoulShards() >= 1
			}

			AddFunction Main_Darkglare_Summon_NoDreadstalkers
			{
					Talent(summon_darkglare_talent)
				and not SpellCooldown(summon_darkglare)
				and SpellCooldown(call_dreadstalkers) > 5
				and SoulShards() < 3
				and SoulShards() >= 1
			}

			AddFunction Main_Darkglare_Summon_Dreadstalkers
			{
					Talent(summon_darkglare_talent)
				and not SpellCooldown(summon_darkglare)
				and SpellCooldown(call_dreadstalkers) <= CastTime(summon_darkglare)
				and {
							SoulShards() >= 3
						 or {
									SoulShards() >= 1
								and BuffPresent(demonic_calling_buff)
							}
					}
				and SoulShards() >= 1
			}

			AddFunction Main_DemonBolt_Use
			{
					Talent(demonbolt_talent)
				and not SpellCooldown(demonbolt)
			}

			AddFunction Main_DemonicEmpowerment_Use
			{
					not SpellCooldown(demonic_empowerment)
				and {
							RegularDemonCount(creature_dreadstalker) > 0
						 or RegularDemonCount(creature_darkglare) > 0
						 or RegularDemonCount(creature_doomguard) > 0
						 or RegularDemonCount(creature_infernal) > 0
						 or RegularDemonCount(creature_felguard) > 0
					}
			}	
				
			AddFunction Main_DemonicEmpowerment_Use_PowerTrip
			{
					not SpellCooldown(demonic_empowerment)
				and {
							{
									Talent(power_trip_talent)
								and {
											not Talent(implosion_talent)
										 or Enemies() <= 1
									}
							}
						 or not Talent(implosion_talent)
						 or {
									Talent(implosion_talent)
								and not Talent(soul_conduit_talent)
								and Enemies() <= 3
							}
					}
				and {
							RegularDemonCount(creature_wild_imp) > 3
						 or PreviousGCDSpell(hand_of_guldan)
					}
			}

			AddFunction Main_Demonwrath_Use
			{
					not SpellCooldown(demonwrath)
				and Enemies() >= 3
			}

			AddFunction Main_Demonwrath_Use_Moving
			{
					not SpellCooldown(demonwrath)
				and MovementCheck()
			}

			AddFunction Main_Doom_Use
			{
					not Talent(hand_of_doom_talent)
				and not SpellCooldown(doom)
				and target.TimeToDie() > target.DebuffRemaining(doom_debuff)
				and target.InPandemicRange(doom_debuff doom)
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
						 or LegendaryEquipped(wilfreds_sigil_of_superior_summoning)
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

			AddFunction Main_Dreadstalkers_Summon
			{
					not SpellCooldown(call_dreadstalkers)
				and {
							not Talent(summon_darkglare_talent)
						 or Talent(power_trip_talent)
					}
				and {
							Enemies() < 3
						 or not Talent(implosion_talent)
					}
				and {
							BuffPresent(demonic_calling_buff)							
						 or SoulShards() >= 2
					}
			}

			AddFunction Main_Dreadstalkers_Summon_Darkglare
			{
					not SpellCooldown(call_dreadstalkers)
				and Talent(summon_darkglare_talent)
				and {
							Enemies() < 3
						 or not Talent(implosion_talent)
					}
				and {
							SpellCooldown(summon_darkglare) > 2
						 or PreviousGCDSpell(summon_darkglare)
						 or {
									SpellCooldown(summon_darkglare) <= CastTime(call_dreadstalkers)
								and SoulShards() >= 3
							}
						 or {
									SpellCooldown(summon_darkglare) <= CastTime(call_dreadstalkers)
								and SoulShards() >= 1
								and BuffPresent(demonic_calling_buff)
							}
					}
				and {
							BuffPresent(demonic_calling_buff)							
						 or SoulShards() >= 2
					}
			}

			AddFunction Main_Felguard_Summon_Service
			{
					Talent(grimoire_of_service_talent)
				and not SpellCooldown(service_felguard)
				and SoulShards() >= 1
			}

			AddFunction Main_Felstorm_Use
			{
					pet.Present() 
				and pet.CreatureFamily(Felguard)
				and not PetSpellCooldown(felguard_felstorm)
			}

			AddFunction Main_HandOfGuldan_Use
			{
					not SpellCooldown(hand_of_guldan)
				and {
							{
									SoulShards() >= 3
								and PreviousGCDSpell(call_dreadstalkers)							
							}
						 or SoulShards() >= 5
						 or {
									SoulShards() >= 4
								and SpellCooldown(summon_darkglare) > 2
							}
					}
			}

			AddFunction Main_HandOfGuldan_Use_Shards
			{
					not SpellCooldown(hand_of_guldan)
				and SoulShards() >= 4
				and not Talent(summon_darkglare_talent)
			}

			AddFunction Main_Implosion_Use
			{
					Talent(implosion_talent)
				and not SpellCooldown(implosion)
				and TotalDemonCount(creature_wild_imp) > 0
				and FirstDemonDespawn(creature_wild_imp) < ExecuteTime(shadow_bolt)
				and {
							BuffPresent(demonic_synergy_buff)
						 or Talent(soul_conduit_talent)
						 or {
									not Talent(soul_conduit_talent)
								and Enemies() > 1
							}
						 or TotalDemonCount(creature_wild_imp) <= 4
					}								 
			}

			AddFunction Main_Implosion_Use_HandOfGuldan
			{
					Talent(implosion_talent)
				and not SpellCooldown(implosion)
				and TotalDemonCount(creature_wild_imp) > 0
				and PreviousGCDSpell(hand_of_guldan)
				and {
							{
									FirstDemonDespawn(creature_wild_imp) <= 3
								and BuffPresent(demonic_synergy_buff)
							}
						 or {
									FirstDemonDespawn(creature_wild_imp) <= 4
								and Enemies() > 2
							}
					}
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

			AddFunction Main_LifeTap_Use_LowMana
			{
					not SpellCooldown(life_tap)
				and ManaPercent() < 30
			}

			AddFunction Main_ShadowBolt_Use
			{
					not Talent(demonbolt_talent)
				and not SpellCooldown(shadow_bolt)
			}

			AddFunction Main_Shadowflame_Use
			{
					Talent(shadowflame_talent)
				and SpellCharges(shadowflame) == 2
				and Enemies() < 5
			}

			AddFunction Main_Shadowflame_Use_Expiring
			{
					Talent(shadowflame_talent)
				and SpellCharges(shadowflame) >= 1
				and {
							{
									target.DebuffStacks(shadowflame_debuff) > 0
								and target.DebuffRemaining(shadowflame_debuff) < CastTime(shadow_bolt) + TravelTime(shadowflame)
							}
						 or {
									SpellCharges(shadowflame) == 2
								and SoulShards() < 5
							}
					}
				and Enemies() < 5
			}

			AddFunction Main_SoulHarvest_Use
			{
					Talent(soul_harvest_talent)
				and not SpellCooldown(soul_harvest)
			}

			AddFunction Main_ThalkielsConsumption_Use
			{
					SpellKnown(thalkiels_consumption)
				and not SpellCooldown(thalkiels_consumption)
				and {
							LastDemonDespawn(creature_dreadstalker) > ExecuteTime(thalkiels_consumption)
						 or {
									Talent(implosion_talent)
								and Enemies() >= 3
							}
					}
				and TotalDemonCount(creature_wild_imp) > 3
				and LastDemonDespawn(creature_wild_imp) > ExecuteTime(thalkiels_consumption)
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				if CheckBoxOn(opt_implosion) and Main_Implosion_Use_HandOfGuldan() Spell(implosion)
				if CheckBoxOn(opt_implosion) and Main_Implosion_Use() Spell(implosion)
				if CheckBoxOn(opt_shadowflame) and Main_Shadowflame_Use_Expiring() Spell(shadowflame)
				if CheckBoxOn(opt_grimoire_service) and Main_Felguard_Summon_Service() Spell(service_felguard)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)
				if Main_Dreadstalkers_Summon() Spell(call_dreadstalkers)
				if Main_HandOfGuldan_Use_Shards() Spell(hand_of_guldan)
				if CheckBoxOn(opt_summon_darkglare) and Main_Darkglare_Summon() Spell(summon_darkglare)
				if CheckBoxOn(opt_summon_darkglare) and Main_Darkglare_Summon_NoDreadstalkers() Spell(summon_darkglare)
				if CheckBoxOn(opt_summon_darkglare) and Main_Darkglare_Summon_Dreadstalkers() Spell(summon_darkglare)
				if Main_Dreadstalkers_Summon_Darkglare() Spell(call_dreadstalkers)
				if Main_HandOfGuldan_Use() Spell(hand_of_guldan)
				if CheckBoxOn(opt_demonic_empowerment) and Main_DemonicEmpowerment_Use_PowerTrip() Spell(demonic_empowerment)
				if CheckBoxOn(opt_demonic_empowerment) and Main_DemonicEmpowerment_Use() Spell(demonic_empowerment)
				if Main_Doom_Use() Spell(doom)
				if CheckBoxOn(opt_soul_harvest) and Main_SoulHarvest_Use() Spell(soul_harvest)
				if CheckBoxOn(opt_shadowflame) and Main_Shadowflame_Use() Spell(shadowflame)
				if CheckBoxOn(opt_thalkiels_consumption) and Main_ThalkielsConsumption_Use() Spell(thalkiels_consumption)
				if CheckBoxOn(opt_life_tap) and Main_LifeTap_Use_LowMana() Spell(life_tap)
				if CheckBoxOn(opt_pet_felstorm) and Main_Felstorm_Use() Spell(felguard_felstorm)
				if CheckBoxOn(opt_demonwrath) and Main_Demonwrath_Use() Spell(demonwrath)
				if CheckBoxOn(opt_demonwrath) and Main_Demonwrath_Use_Moving() Spell(demonwrath)
				if Main_DemonBolt_Use() Spell(demonbolt)
				if Main_ShadowBolt_Use() Spell(shadow_bolt)
				if CheckBoxOn(opt_life_tap) and Main_LifeTap_Use() Spell(life_tap)
			}

			AddFunction Main_Precombat
			{
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)
				if CheckBoxOn(opt_demonic_empowerment) Spell(demonic_empowerment)
				
				Spell(demonbolt)
				Spell(shadow_bolt)
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
								 or BuffPresent(trinket_proc_any_buff)
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
				if not CheckBoxOn(opt_grimoire_service) and Main_Felguard_Summon_Service() Spell(service_felguard)
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

		OvaleScripts:RegisterScript("WARLOCK", "demonology", name, desc, code, "script");
	end
end