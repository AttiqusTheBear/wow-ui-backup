local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_warlock_destruction";
		local desc = "LunaEclipse: Destruction Warlock";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.WARLOCK_DESTRUCTION,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Bangerz",
			GuideLink = "http://www.icy-veins.com/wow/destruction-warlock-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "1313022",
			["Raiding (AOE) / Dungeons"] = "1312032",
			["Solo / World Quests"] = "3112113",
			["Easy Mode"] = "1113132",
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
					OPT_RAIN_OF_FIRE = {
						type = "toggle",
						name = BINDING_NAME_OPT_RAIN_OF_FIRE,
						desc = functionsConfiguration:getAOETooltip("Rain of Fire"),
						arg = "OPT_RAIN_OF_FIRE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_CATACLYSM = {
						type = "toggle",
						name = BINDING_NAME_OPT_CATACLYSM,
						desc = functionsConfiguration:getAOETooltip("Cataclysm"),
						arg = "OPT_CATACLYSM",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_HAVOC = {
						type = "toggle",
						name = BINDING_NAME_OPT_HAVOC,
						desc = functionsConfiguration:getAOETooltip("Havoc"),
						arg = "OPT_HAVOC",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
				},
			},
			settingsCooldowns = {
				type = "group",
				name = BINDING_HEADER_COOLDOWNS,
				inline = true,
				order = 30,
				args = {
					OPT_CHANNEL_DEMONFIRE = {
						type = "toggle",
						name = BINDING_NAME_OPT_CHANNEL_DEMONFIRE,
						desc = functionsConfiguration:getCooldownTooltip("Channel Demonfire"),
						arg = "OPT_CHANNEL_DEMONFIRE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_DIMESNIONAL_RIFT = {
						type = "toggle",
						name = BINDING_NAME_OPT_DIMESNIONAL_RIFT,
						desc = functionsConfiguration:getCooldownTooltip("Dimensional Rift"),
						arg = "OPT_DIMESNIONAL_RIFT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_EMPOWERED_LIFE_TAP = {
						type = "toggle",
						name = BINDING_NAME_OPT_EMPOWERED_LIFE_TAP,
						desc = functionsConfiguration:getCooldownTooltip("Empowered Life Tap"),
						arg = "OPT_EMPOWERED_LIFE_TAP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 30,
					},
					OPT_GREATER_DEMONS = {
						type = "toggle",
						name = BINDING_NAME_OPT_GREATER_DEMONS,
						desc = functionsConfiguration:getCooldownTooltip("Summon Doomguard and Summon Infernal", "CD"),
						arg = "OPT_GREATER_DEMONS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_GRIMOIRE_SERVICE = {
						type = "toggle",
						name = BINDING_NAME_OPT_GRIMOIRE_SERVICE,
						desc = functionsConfiguration:getCooldownTooltip("Grimoire of Service", "CD"),
						arg = "OPT_GRIMOIRE_SERVICE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 50,
					},
					OPT_SHADOWBURN = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHADOWBURN,
						desc = functionsConfiguration:getCooldownTooltip("Shadowburn"),
						arg = "OPT_SHADOWBURN",
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
			AddCheckBox(opt_rain_of_fire "AOE: Rain of Fire" default)
			AddCheckBox(opt_cataclysm "AOE CD: Cataclysm" default)
			AddCheckBox(opt_havoc "AOE CD: Havoc" default)
			AddCheckBox(opt_channel_demonfire "Cooldown: Channel Demonfire" default)
			AddCheckBox(opt_dimesnional_rift "Show: Dimensional Rift" default)
			AddCheckBox(opt_empowered_life_tap "Cooldown: Empowered Life Tap" default)
			AddCheckBox(opt_greater_demons "Cooldown: Greater Demons" default)
			AddCheckBox(opt_grimoire_service "Cooldown: Grimoire of Service" default)
			AddCheckBox(opt_shadowburn "Cooldown: Shadowburn" default)
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
			AddFunction Immolate_MultiDot_Use_Other
			{
					not SpellCooldown(immolate)
				and DOTTargetCount(immolate_debuff) < MultiDOTTargets()
			}

			###
			### MultiDot Icon Rotations
			###
			AddFunction MultiDot
			{
				if Immolate_MultiDot_Use_Other() Spell(immolate text=multi)
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

			AddFunction ShortCD_LifeTap_Use
			{
					not SpellCooldown(life_tap)
				and ManaPercent() < 40
			}

			AddFunction Rotation_SummonDemon
			{
				if Talent(grimoire_of_supremacy_talent) and { not pet.Present() or not pet.CreatureFamily(Doomguard) } Spell(summon_doomguard)
				if Talent(grimoire_of_service_talent) and { not pet.Present() or not pet.CreatureFamily(Imp) } Spell(summon_imp)
				if Talent(grimoire_of_sacrifice_talent) and not BuffPresent(grimoire_of_sacrifice_buff) and pet.Present() and pet.CreatureFamily(Imp) Spell(grimoire_of_sacrifice)
				if Talent(grimoire_of_sacrifice_talent) and not BuffPresent(grimoire_of_sacrifice_buff) and { not pet.Present() or not pet.CreatureFamily(Imp) } Spell(summon_imp)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Summon pet if needed
				Rotation_SummonDemon()

				# Short Cooldown Spells
				if not CheckBoxOn(opt_havoc) and Main_Havoc_Use() Spell(havoc)
				if not CheckBoxOn(opt_dimesnional_rift) and Main_DimensionalRift_Use_FullCharges() Spell(dimensional_rift)
				if not CheckBoxOn(opt_shadowburn) and Main_Shadowburn_Use_ConflagrationOfChoas() Spell(shadowburn)
				if not CheckBoxOn(opt_shadowburn) and Main_Shadowburn_Use_Charges() Spell(shadowburn)
				if not CheckBoxOn(opt_empowered_life_tap) and Main_LifeTap_Use_Empowered_Expiring() Spell(life_tap)
				if not CheckBoxOn(opt_dimesnional_rift) and Main_DimensionalRift_Use_LessonsOfSpaceTime() Spell(dimensional_rift)
				if not CheckBoxOn(opt_channel_demonfire) and Main_ChannelDemonfire_Use() Spell(channel_demonfire)
				if not CheckBoxOn(opt_havoc) and Main_Havoc_Use_ShawlYmirjar() Spell(havoc)
				if not CheckBoxOn(opt_rain_of_fire) and Main_RainOfFire_Use() Spell(rain_of_fire)
				if not CheckBoxOn(opt_rain_of_fire) and Main_RainOfFire_Use_WreakHavoc() Spell(rain_of_fire)
				if not CheckBoxOn(opt_dimesnional_rift) and Main_DimensionalRift_Use() Spell(dimensional_rift)
				if not CheckBoxOn(opt_empowered_life_tap) and Main_LifeTap_Use_Empowered() Spell(life_tap)
				if not CheckBoxOn(opt_cataclysm) and Main_Cataclysm_Use() Spell(cataclysm)
				if not CheckBoxOn(opt_shadowburn) and Main_Shadowburn_Use() Spell(shadowburn)

				# Mana Regen
				if not CheckBoxOn(opt_life_tap) and ShortCD_LifeTap_Use() Spell(life_tap)

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
			AddFunction Main_Cataclysm_Use
			{
					Talent(cataclysm_talent)
				and not SpellCooldown(cataclysm)
			}

			AddFunction Main_ChaosBolt_Use
			{
					not SpellCooldown(chaos_bolt)
				and {
							SpellCooldown(havoc) > 12
						 or Enemies() < 3
						 or {
									Talent(wreak_havoc_talent)
								and Enemies() < 6
							}
					}
				and {
							not ArmorSetBonus(T19 4)
						 or not Talent(eradication_talent)
						 or BuffRemaining(embrace_chaos_buff) <= CastTime(chaos_bolt)
						 or SoulShards() >= 3
					}
				and SoulShards() >= 2
			}

			AddFunction Main_ChannelDemonfire_Use
			{
					Talent(channel_demonfire_talent)
				and not SpellCooldown(channel_demonfire)
				and target.DebuffRemaining(immolate_debuff) > CastTime(channel_demonfire)
			}

			AddFunction Main_Conflagrate_Use
			{
					not Talent(shadowburn_talent)
				and SpellCharges(conflagrate) >= 1
				and not Talent(roaring_blaze_talent)
				and BuffStacks(backdraft_buff)  < 3
			}

			AddFunction Main_Conflagrate_Use_Backdraft
			{
					not Talent(shadowburn_talent)
				and SpellCharges(conflagrate) >= 1
				and not Talent(roaring_blaze_talent)
				and BuffStacks(backdraft_buff) < 3
				and {
							{
									{
											{
													not ArmorSetBonus(T19 4)
												and SpellCharges(conflagrate) == 1
											}
										 or SpellCharges(conflagrate) == 2
									}
								and SpellCooldown(conflagrate) < CastTime(chaos_bolt)
							}
						 or {
									{
											not ArmorSetBonus(T19 4)
										and SpellCharges(conflagrate) == 2
									}
								 or SpellCharges(conflagrate) == 3
							}
					}
				and SoulShards() < 5
			}

			AddFunction Main_Conflagrate_Use_ConflagrationOfChoas
			{
					not Talent(shadowburn_talent)
				and SpellCharges(conflagrate) >= 1
				and not Talent(roaring_blaze_talent)
				and BuffStacks(backdraft_buff) < 3
				and BuffPresent(conflagration_of_chaos_buff)
				and BuffRemaining(conflagration_of_chaos_buff) <= CastTime(chaos_bolt)
			}

			AddFunction Main_Conflagrate_Use_RoaringBlaze
			{
					not Talent(shadowburn_talent)
				and SpellCharges(conflagrate) >= 1
				and Talent(roaring_blaze_talent)
				and RoaringBlazeStacks() > 0
				and not target.InPandemicRange(immolate_debuff immolate)
				and {
							Enemies() == 1
						 or SoulShards() < 3
					}
				and SoulShards() < 5
			}

			AddFunction Main_Conflagrate_Use_RoaringBlaze_MaxCharges
			{
					not Talent(shadowburn_talent)
				and SpellCharges(conflagrate) >= 1
				and Talent(roaring_blaze_talent)
				and {
							{
									{
											not ArmorSetBonus(T19 4)
										and SpellCharges(conflagrate) == 2
									}
								 or SpellCharges(conflagrate) == 3
							}
						 or {
									{
											{
													not ArmorSetBonus(T19 4)
												and SpellCharges(conflagrate) == 1
											}
										 or SpellCharges(conflagrate) == 2
									}
								and SpellCooldown(conflagrate) < GCD()
							}
						 or target.TimeToDie() < 24
					}
			}

			AddFunction Main_DimensionalRift_Use
			{
					SpellKnown(dimensional_rift)
				and SpellCharges(dimensional_rift) >= 1
				and {
							not LegendaryEquipped(lessons_of_space_time)
						 or SpellCharges(dimensional_rift) > 1
						 or {
									{
											not Talent(grimoire_of_service_talent)
										 or SpellCooldown(dimensional_rift) < SpellCooldown(service_imp)
									}
								and {
											not Talent(soul_harvest_talent)
										 or SpellCooldown(dimensional_rift) < SpellCooldown(soul_harvest)
									}
								and {
											not Talent(grimoire_of_supremacy_talent)
										 or SpellCooldown(dimensional_rift) < SpellCooldown(summon_doomguard)
									}
							}
					}
			}

			AddFunction Main_DimensionalRift_Use_FullCharges
			{
					SpellKnown(dimensional_rift)
				and SpellCharges(dimensional_rift) == 3
			}

			AddFunction Main_DimensionalRift_Use_LessonsOfSpaceTime
			{
					SpellKnown(dimensional_rift)
				and SpellCharges(dimensional_rift) >= 1
				and LegendaryEquipped(lessons_of_space_time)
				and not BuffPresent(lessons_of_space_time_buff)
				and {
							{
									not Talent(grimoire_of_supremacy_talent)
								and not SpellCooldown(summon_doomguard)
							}
						 or {
									Talent(grimoire_of_service_talent)
								and not SpellCooldown(service_imp)
							}
						 or {
									Talent(soul_harvest_talent)
								and not SpellCooldown(soul_harvest)
							}
					}
			}

			AddFunction Main_Doomguard_Summon
			{
					not Talent(grimoire_of_supremacy_talent)
				and not SpellCooldown(summon_doomguard)
				and Enemies() <= 2
				and {
							target.TimeToDie() > 180
						 or target.HealthPercent() <= 20
						 or target.TimeToDie() < 30
					}
				and SoulShards() >= 1
			}

			AddFunction Main_Doomguard_Summon_LordOfFlames
			{
					Talent(grimoire_of_supremacy_talent)
				and not SpellCooldown(summon_doomguard)
				and Enemies() == 1
				and HasArtifactTrait(lord_of_flames_trait)
				and LordOfFlamesCooldown()
				and not pet.CreatureFamily(Doomguard)
				and SoulShards() >= 1
			}

			AddFunction Main_Doomguard_Summon_SindoreiSpite
			{
					Talent(grimoire_of_supremacy_talent)
				and not SpellCooldown(summon_doomguard)
				and Enemies() == 1
				and LegendaryEquipped(sindorei_spite)
				and not SindoreiSpiteCooldown()
				and SoulShards() >= 1
			}

			AddFunction Main_Havoc_Use
			{
					not SpellCooldown(havoc)
				and Enemies() > 1
				and {
							Enemies() < 4
						 or {
									Talent(wreak_havoc_talent)
								and Enemies() < 6
							}
					}
				and DOTTargetCount(havoc_debuff) == 0
			}

			AddFunction Main_Havoc_Use_ShawlYmirjar
			{
					not SpellCooldown(havoc)
				and Enemies() == 1
				and Talent(wreak_havoc_talent)
				and LegendaryEquipped(odr_shawl_of_the_ymirjar)
				and DOTTargetCount(havoc_debuff) == 0
			}

			AddFunction Main_Immolate_Use
			{
					not SpellCooldown(immolate)
				and target.DebuffRemaining(immolate_debuff) <= TickTime(immolate_debuff)
				and {
							not Talent(roaring_blaze_talent)
						 or {
									not RoaringBlazeActive()
								and {
											{
													ArmorSetBonus(T19 4)
												and SpellCharges(conflagrate) < 3
											}
										 or SpellCharges(conflagrate) < 2
									}
							}
					}				
			}

			AddFunction Main_Immolate_Use_Expiring
			{
					not SpellCooldown(immolate)
				and target.DebuffRemaining(immolate_debuff) <= TickTime(immolate_debuff)
			}

			AddFunction Main_Immolate_Use_Refresh
			{
					not SpellCooldown(immolate)
				and not Talent(roaring_blaze_talent)
				and target.InPandemicRange(immolate_debuff immolate)
			}

			AddFunction Main_Immolate_Use_RoaringBlaze
			{
					not SpellCooldown(immolate)
				and Talent(roaring_blaze_talent)
				and RoaringBlazeTimeRemaining() <= target.DebuffRemaining(immolate_debuff) 
				and target.TimeToDie() > 10
				and {
							{
									{
											not ArmorSetBonus(T19 4)
										and SpellCharges(conflagrate) == 2
									}
								 or SpellCharges(conflagrate) == 3
							}
						 or {
									{
											{
													not ArmorSetBonus(T19 4)
												and SpellCharges(conflagrate) >= 1
											}
										 or SpellCharges(conflagrate) >= 2
									}
								and SpellCooldown(conflagrate) < CastTime(immolate) + GCD()
							}
						 or target.TimeToDie() < 24
					}
			}

			AddFunction Main_Imp_Summon_Service
			{
					Talent(grimoire_of_service_talent)
				and not SpellCooldown(service_imp)
				and SoulShards() >= 1
			}

			AddFunction Main_Incinerate_Use
			{
					not SpellCooldown(incinerate)
			}

			AddFunction Main_Infernal_Summon
			{
					not Talent(grimoire_of_supremacy_talent)
				and not SpellCooldown(summon_infernal)
				and Enemies() > 2
				and SoulShards() >= 1
			}

			AddFunction Main_Infernal_Summon_LordOfFlames
			{
					not SpellCooldown(summon_infernal)
				and HasArtifactTrait(lord_of_flames_trait)
				and not LordOfFlamesCooldown()
				and SoulShards() >= 1
			}

			AddFunction Main_Infernal_Summon_SindoreiSpite
			{
					Talent(grimoire_of_supremacy_talent)
				and not SpellCooldown(summon_infernal)
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
					Talent(empowered_life_tap_talent)
				and not SpellCooldown(life_tap)
				and InPandemicRange(empowered_life_tap_buff life_tap)
			}

			AddFunction Main_LifeTap_Use_Empowered_Expiring
			{
					Talent(empowered_life_tap_talent)
				and not SpellCooldown(life_tap)
				and BuffRemaining(empowered_life_tap_buff) <= GCD()
			}

			AddFunction Main_RainOfFire_Use
			{
					not SpellCooldown(rain_of_fire)
				and Enemies() >= 3
				and SpellCooldown(havoc) <= 12
				and not Talent(wreak_havoc_talent)
				and SoulShards() >= 3
			}

			AddFunction Main_RainOfFire_Use_WreakHavoc
			{
					not SpellCooldown(rain_of_fire)
				and Enemies() >= 6
				and Talent(wreak_havoc_talent)
				and SoulShards() >= 3
			}

			AddFunction Main_Shadowburn_Use
			{
					Talent(shadowburn_talent)
				and SpellCharges(shadowburn) >= 1
			}

			AddFunction Main_Shadowburn_Use_Charges
			{
					Talent(shadowburn_talent)
				and SpellCharges(shadowburn) >= 1
				and {
							{
									{
											{
													not ArmorSetBonus(T19 4)
												and SpellCharges(shadowburn) == 1
											}
										 or SpellCharges(shadowburn) == 2
									}
								and SpellCooldown(shadowburn) < CastTime(chaos_bolt)
							}	
						 or {
									{
											not ArmorSetBonus(T19 4)
										and SpellCharges(shadowburn) == 2
									}
								 or SpellCharges(shadowburn) == 3
							}
					}
				and SoulShards() < 5
			}

			AddFunction Main_Shadowburn_Use_ConflagrationOfChoas
			{
					Talent(shadowburn_talent)
				and SpellCharges(shadowburn) >= 1
				and BuffPresent(conflagration_of_chaos_buff)
				and BuffRemaining(conflagration_of_chaos_buff) <= CastTime(chaos_bolt)
			}

			AddFunction Main_SoulHarvest_Use
			{
					Talent(soul_harvest_talent)
				and not SpellCooldown(soul_harvest)
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				if CheckBoxOn(opt_havoc) and Main_Havoc_Use() Spell(havoc)
				if CheckBoxOn(opt_dimesnional_rift) and Main_DimensionalRift_Use_FullCharges() Spell(dimensional_rift)
				if Main_Immolate_Use_Expiring() Spell(immolate)
				if Main_Immolate_Use() Spell(immolate)
				if Main_Immolate_Use_RoaringBlaze() Spell(immolate)
				if CheckBoxOn(opt_shadowburn) and Main_Shadowburn_Use_ConflagrationOfChoas() Spell(shadowburn)
				if CheckBoxOn(opt_shadowburn) and Main_Shadowburn_Use_Charges() Spell(shadowburn)
				if Main_Conflagrate_Use_RoaringBlaze_MaxCharges() Spell(conflagrate)
				if Main_Conflagrate_Use_RoaringBlaze() Spell(conflagrate)
				if Main_Conflagrate_Use_ConflagrationOfChoas() Spell(conflagrate)
				if Main_Conflagrate_Use_Backdraft() Spell(conflagrate)
				if CheckBoxOn(opt_empowered_life_tap) and Main_LifeTap_Use_Empowered_Expiring() Spell(life_tap)
				if CheckBoxOn(opt_dimesnional_rift) and Main_DimensionalRift_Use_LessonsOfSpaceTime() Spell(dimensional_rift)
				if CheckBoxOn(opt_grimoire_service) and Main_Imp_Summon_Service() Spell(service_imp)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_LordOfFlames() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_LordOfFlames() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)
				if CheckBoxOn(opt_soul_harvest) and Main_SoulHarvest_Use() Spell(soul_harvest)
				if CheckBoxOn(opt_channel_demonfire) and Main_ChannelDemonfire_Use() Spell(channel_demonfire)
				if CheckBoxOn(opt_havoc) and Main_Havoc_Use_ShawlYmirjar() Spell(havoc)
				if CheckBoxOn(opt_rain_of_fire) and Main_RainOfFire_Use() Spell(rain_of_fire)
				if CheckBoxOn(opt_rain_of_fire) and Main_RainOfFire_Use_WreakHavoc() Spell(rain_of_fire)
				if CheckBoxOn(opt_dimesnional_rift) and Main_DimensionalRift_Use() Spell(dimensional_rift)
				if CheckBoxOn(opt_empowered_life_tap) and Main_LifeTap_Use_Empowered() Spell(life_tap)
				if CheckBoxOn(opt_cataclysm) and Main_Cataclysm_Use() Spell(cataclysm)
				if Main_ChaosBolt_Use() Spell(chaos_bolt)
				if CheckBoxOn(opt_shadowburn) and Main_Shadowburn_Use() Spell(shadowburn)
				if Main_Conflagrate_Use() Spell(conflagrate)
				if Main_Immolate_Use_Refresh() Spell(immolate)
				if Main_Incinerate_Use() Spell(incinerate)
				if CheckBoxOn(opt_life_tap) and Main_LifeTap_Use() Spell(life_tap)
			}

			AddFunction Main_Precombat
			{
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_LordOfFlames() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_LordOfFlames() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)
				if CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)

				Spell(chaos_bolt)
			}

			###
			### CD Rotations - Functions
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
			### CD Rotations
			###
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
				if not CheckBoxOn(opt_grimoire_service) and Main_Imp_Summon_Service() Spell(service_imp)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_LordOfFlames() Spell(summon_infernal)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_LordOfFlames() Spell(summon_doomguard)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)
				if not CheckBoxOn(opt_soul_harvest) and Main_SoulHarvest_Use() Spell(soul_harvest)
				
				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_deadly_grace)

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
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_LordOfFlames() Spell(summon_infernal)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_LordOfFlames() Spell(summon_doomguard)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon() Spell(summon_doomguard)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon() Spell(summon_infernal)
				if not CheckBoxOn(opt_greater_demons) and Main_Infernal_Summon_SindoreiSpite() Spell(summon_infernal)
				if not CheckBoxOn(opt_greater_demons) and Main_Doomguard_Summon_SindoreiSpite() Spell(summon_doomguard)

				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_deadly_grace)
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

		OvaleScripts:RegisterScript("WARLOCK", "destruction", name, desc, code, "script");
	end
end