local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_mage_frost";
		local desc = "LunaEclipse: Frost Mage";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.MAGE_FROST,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Kuni",
			GuideLink = "http://www.icy-veins.com/wow/frost-mage-pve-dps-guide",
			WoWVersion = 70200,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding"] = "3012321",
			["Dungeons / Mythic+"] = "3033331",
			["Solo / World Quests"] = "3033312",
			["Easy Mode"] = "3132111",
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
					OPT_BLIZZARD = {
						type = "toggle",
						name = BINDING_NAME_OPT_BLIZZARD,
						desc = functionsConfiguration:getAOETooltip("Blizzard"),
						arg = "OPT_BLIZZARD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_FROST_BOMB = {
						type = "toggle",
						name = BINDING_NAME_OPT_FROST_BOMB,
						desc = functionsConfiguration:getAOETooltip("Frost Bomb"),
						arg = "OPT_FROST_BOMB",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_ICE_NOVA = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICE_NOVA,
						desc = functionsConfiguration:getAOETooltip("Ice Nova"),
						arg = "OPT_ICE_NOVA",
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
					OPT_COMET_STORM = {
						type = "toggle",
						name = BINDING_NAME_OPT_COMET_STORM,
						desc = functionsConfiguration:getCooldownTooltip("Comet Storm"),
						arg = "OPT_COMET_STORM",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_EBONBOLT = {
						type = "toggle",
						name = BINDING_NAME_OPT_EBONBOLT,
						desc = functionsConfiguration:getCooldownTooltip("Ebonbolt"),
						arg = "OPT_EBONBOLT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_FROZEN_ORB = {
						type = "toggle",
						name = BINDING_NAME_OPT_FROZEN_ORB,
						desc = functionsConfiguration:getCooldownTooltip("Frozen Orb"),
						arg = "OPT_FROZEN_ORB",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_GLACIAL_SPIKE = {
						type = "toggle",
						name = BINDING_NAME_OPT_GLACIAL_SPIKE,
						desc = functionsConfiguration:getCooldownTooltip("Glacial Spike"),
						arg = "OPT_GLACIAL_SPIKE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_ICY_VEINS = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICY_VEINS,
						desc = functionsConfiguration:getCooldownTooltip("Icy Veins", "CD"),
						arg = "OPT_ICY_VEINS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_MIRROR_IMAGE = {
						type = "toggle",
						name = BINDING_NAME_OPT_MIRROR_IMAGE,
						desc = functionsConfiguration:getCooldownTooltip("Mirror Image"),
						arg = "OPT_MIRROR_IMAGE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_RAY_OF_FROST = {
						type = "toggle",
						name = BINDING_NAME_OPT_RAY_OF_FROST,
						desc = functionsConfiguration:getCooldownTooltip("Ray of Frost"),
						arg = "OPT_RAY_OF_FROST",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 70,
					},
					OPT_POWER_RUNE = {
						type = "toggle",
						name = BINDING_NAME_OPT_POWER_RUNE,
						desc = functionsConfiguration:getCooldownTooltip("Rune of Power"),
						arg = "OPT_POWER_RUNE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 80,
					},
					OPT_TIME_WARP = {
						type = "toggle",
						name = BINDING_NAME_OPT_TIME_WARP,
						desc = string.format("%s\n\n%s", functionsConfiguration:getCooldownTooltip("Time Warp", "CD"), "This is only applicable when using Shard of the Exodar legendary, and will only be recommended once at least half the group has the debuff."),
						arg = "OPT_TIME_WARP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 90,
					},
				},
			},
			settingsDefensive = {
				type = "group",
				name = BINDING_HEADER_DEFENSIVE,
				inline = true,
				order = 40,
				args = {
					OPT_ICE_BARRIER = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICE_BARRIER,
						desc = functionsConfiguration:getDefensiveTooltip("Ice Barrier"),
						arg = "OPT_ICE_BARRIER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_ICE_BLOCK = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICE_BLOCK,
						desc = functionsConfiguration:getDefensiveTooltip("Ice Block", "CD", "40%"),
						arg = "OPT_ICE_BLOCK",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
				},
			},
			settingsPet = {
				type = "group",
				name = BINDING_HEADER_PET,
				inline = true,
				order = 50,
				args = {
					OPT_WATER_JET = {
						type = "toggle",
						name = BINDING_NAME_OPT_WATER_JET,
						desc = functionsConfiguration:getCooldownTooltip("Water Elemental's Water Jet"),
						arg = "OPT_WATER_JET",
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
					OPT_BLIZZARD_FREEZING_RAIN = {
						type = "toggle",
						name = BINDING_NAME_OPT_BLIZZARD_FREEZING_RAIN,
						desc = string.format("%s\n\n%s", functionsConfiguration:getAOETooltip("Blizzard"), "If checked, then Ovale will only suggest Blizzard during Freezing Rain on the main rotation icons even if Blizzard is set to display on the ShortCD Icon.", "This setting only affects the display of instant cast Blizzard's, the icon which all other Blizzard casts are displayed on will depend on the AOE: Blizzard setting!"),
						arg = "OPT_BLIZZARD_FREEZING_RAIN",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 10,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(lunaeclipse_mage_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_blizzard "AOE: Blizzard" default)
			AddCheckBox(opt_frost_bomb "AOE: Frost Bomb" default)
			AddCheckBox(opt_ice_nova "AOE CD: Ice Nova" default)
			AddCheckBox(opt_comet_storm "Cooldown: Comet Storm" default)
			AddCheckBox(opt_ebonbolt "Cooldown: Ebonbolt" default)
			AddCheckBox(opt_frozen_orb "Cooldown: Frozen Orb" default)
			AddCheckBox(opt_glacial_spike "Cooldown: Glacial Spike" default)
			AddCheckBox(opt_icy_veins "Cooldown: Icy Veins" default)
			AddCheckBox(opt_mirror_image "Cooldown: Mirror Image" default)
			AddCheckBox(opt_ray_of_frost "Cooldown: Ray of Frost" default)
			AddCheckBox(opt_power_rune "Cooldown: Rune of Power" default)
			AddCheckBox(opt_time_warp "Cooldown: Time Warp" default)
			AddCheckBox(opt_barrier_spells "Defensive: Barrier Spells" default)
			AddCheckBox(opt_ice_block "Defensive: Ice Block" default)
			AddCheckBox(opt_blizzard_freezing_rain "Other: Blizzard (Freezing Rain Only)")
			AddCheckBox(opt_water_jet "Pet: Water Jet" default)
			
			###
			### Fingers of Frost React
			###
			AddFunction FingersOfFrost_React
			{
					{
							BuffReact(fingers_of_frost_buff)
						 or {
									BuffPresent(icy_veins_buff)
								and LadyVashjGraspActive()
								and LadyVashjGraspNextFoF() > 9
							}
					}
				and BuffStacks(fingers_of_frost_buff) >= 1
			}

			###
			### IsMoving Function
			###
			AddFunction IsMoving
			{
					MovementCheck()
				and not BuffPresent(ice_floes_buff)
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(counterspell) Spell(counterspell)
					if target.Distance() < 8 Spell(arcane_torrent_mana)

					if not target.IsRaidBoss()
					{
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
					}
				}
			}

			###
			### ShortCD Icon Rotations - Functions
			###
			AddFunction ShortCD_IceBarrier_Use
			{
					not SpellCooldown(ice_barrier)
				and Mana() >= ManaCost(ice_barrier)
				and not BuffPresent(ice_barrier_buff)
			}

			AddFunction ShortCD_WaterElemental_Summon
			{
					not Talent(lonely_winter_talent)
				and not SpellCooldown(water_elemental)
				and Mana() >= ManaCost(water_elemental)
				and not IsMoving()
				and not pet.Present()
			}


			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Summon Water Elemental if needed
				if ShortCD_WaterElemental_Summon() Spell(water_elemental)	
			
				# Short Cooldown Abilities
				if not CheckBoxOn(opt_power_rune) and Cooldowns_RuneOfPower_Use() Spell(rune_of_power)
				if not CheckBoxOn(opt_mirror_image) and Cooldowns_MirrorImage_Use() Spell(mirror_image)				

				# Use the AOE rotation when fighting 4 or more enemies.
				if Rotation_AOE_Use()
				{
					if not CheckBoxOn(opt_blizzard_freezing_rain) and Standard_Blizzard_Use_FreezingRain() Spell(blizzard)
					if not CheckBoxOn(opt_frozen_orb) and AOE_FrozenOrb_Use() Spell(frozen_orb)
					if not CheckBoxOn(opt_blizzard) and AOE_Blizzard_Use() Spell(blizzard)
					if not CheckBoxOn(opt_comet_storm) and AOE_CometStorm_Use() Spell(comet_storm)
					if not CheckBoxOn(opt_ice_nova) and AOE_IceNova_Use() Spell(ice_nova)
					if not CheckBoxOn(opt_water_jet) and AOE_WaterJet_Use() Spell(water_elemental_water_jet)
					if not CheckBoxOn(opt_frost_bomb) and AOE_FrostBomb_Use() Spell(frost_bomb)
					if not CheckBoxOn(opt_ebonbolt) and AOE_Ebonbolt_Use() Spell(ebonbolt)
					if not CheckBoxOn(opt_glacial_spike) and AOE_GlacialSpike_Use() Spell(glacial_spike)
				}
				
				# Use the Standard rotation when fighting less then 4 enemies.
				if not Rotation_AOE_Use()
				{
					if not CheckBoxOn(opt_ice_nova) and Standard_IceNova_Use_WintersChill() Spell(ice_nova)
					if not CheckBoxOn(opt_water_jet) and Standard_WaterJet_Use() Spell(water_elemental_water_jet)
					if not CheckBoxOn(opt_ray_of_frost) and Standard_RayOfFrost_Use() Spell(ray_of_frost)
					if not CheckBoxOn(opt_blizzard_freezing_rain) and Standard_Blizzard_Use_FreezingRain() Spell(blizzard)
					if not CheckBoxOn(opt_frost_bomb) and Standard_FrostBomb_Use() Spell(frost_bomb)
					if not CheckBoxOn(opt_frozen_orb) and Standard_FrozenOrb_Use() Spell(frozen_orb)
					if not CheckBoxOn(opt_ice_nova) and Standard_IceNova_Use() Spell(ice_nova)
					if not CheckBoxOn(opt_comet_storm) and Standard_CometStorm_Use() Spell(comet_storm)
					if not CheckBoxOn(opt_blizzard) and Standard_Blizzard_Use() Spell(blizzard)
					if not CheckBoxOn(opt_ebonbolt) and Standard_Ebonbolt_Use() Spell(ebonbolt)
					if not CheckBoxOn(opt_glacial_spike) and Standard_GlacialSpike_Use() Spell(glacial_spike)
				}

				# Use Ice Flows if moving so spells can be cast
				if Main_IceFlows_Use() Spell(ice_floes)

				# Display Ice Barrier on ShortCD only if option is checked
				if CheckBoxOn(opt_barrier_spells) and ShortCD_IceBarrier_Use() Spell(ice_barrier)
			}

			AddFunction ShortCD_Precombat
			{
				# Summon Water Elemental if needed
				if ShortCD_WaterElemental_Summon() Spell(water_elemental)	
			
				# Short Cooldown Abilities
				if Cooldowns_MirrorImage_Use() Spell(mirror_image)

				# Display Ice Barrier on ShortCD only if option is checked
				if CheckBoxOn(opt_barrier_spells) and ShortCD_IceBarrier_Use() Spell(ice_barrier)
			}

			###
			### AOE Rotation - Functions
			###
			AddFunction AOE_Blizzard_Use
			{
					not SpellCooldown(blizzard)
				and Mana() >= ManaCost(blizzard)
				and {
							not IsMoving()
						 or BuffPresent(freezing_rain_buff)
					}
			}

			AddFunction AOE_Blizzard_Use_FreezingRain
			{
					not SpellCooldown(blizzard)
				and Mana() >= ManaCost(blizzard)
				and BuffPresent(freezing_rain_buff)
				and BuffStacks(fingers_of_frost_buff) < 3
			}

			AddFunction AOE_CometStorm_Use
			{
					Talent(comet_storm_talent)
				and not SpellCooldown(comet_storm)
				and Mana() >= ManaCost(comet_storm)
				and target.RangeCheck(comet_storm)
			}

			AddFunction AOE_Ebonbolt_Use
			{
					SpellKnown(ebonbolt)
				and not SpellCooldown(ebonbolt)
				and target.RangeCheck(ebonbolt)
				and not IsMoving()
				and not BuffPresent(brain_freeze_buff)
				and not FingersOfFrost_React()
			}

			AddFunction AOE_Flurry_Use
			{
					not SpellCooldown(flurry)
				and target.RangeCheck(flurry)
				and {
							not IsMoving()
						 or BuffPresent(brain_freeze_buff)
					}
				and PreviousGCDSpell(ebonbolt)
			}

			AddFunction AOE_Flurry_Use_BrainFreeze
			{
					not SpellCooldown(flurry)
				and target.RangeCheck(flurry)
				and BuffPresent(brain_freeze_buff)
				and not FingersOfFrost_React()
				and {
							not BuffPresent(icy_veins_buff)
						 or LadyVashjGraspNextFoF() > GCD()
					}
			}

			AddFunction AOE_Flurry_Use_Ebonbolt
			{
					not SpellCooldown(flurry)
				and target.RangeCheck(flurry)
				and PreviousGCDSpell(ebonbolt)
				and not FingersOfFrost_React()
				and {
							not BuffPresent(icy_veins_buff)
						 or LadyVashjGraspNextFoF() > GCD()
					}
			}

			AddFunction AOE_Frostbolt_Use
			{
					not SpellCooldown(frostbolt)
				and Mana() >= ManaCost(frostbolt)
				and target.RangeCheck(frostbolt)
				and not IsMoving()
			}

			AddFunction AOE_Frostbolt_Use_WaterJet
			{
					not SpellCooldown(frostbolt)
				and Mana() >= ManaCost(frostbolt)
				and target.RangeCheck(frostbolt)
				and not IsMoving()
				and PreviousOffGCDSpell(water_elemental_water_jet)
				and CastTime(frostbolt) + TravelTime(frostbolt) < target.DebuffRemaining(water_elemental_water_jet_debuff)
			}

			AddFunction AOE_FrostBomb_Use
			{
					Talent(frost_bomb_talent)
				and not SpellCooldown(frost_bomb)
				and Mana() >= ManaCost(frost_bomb)
				and target.RangeCheck(frost_bomb)
				and not IsMoving()
				and target.DebuffRemaining(frost_bomb_debuff) < TravelTime(ice_lance)
				and FingersOfFrost_React()
			}

			AddFunction AOE_FrozenOrb_Use
			{
					not SpellCooldown(frozen_orb)
				and Mana() >= ManaCost(frozen_orb)
			}

			AddFunction AOE_GlacialSpike_Use
			{
					Talent(glacial_spike_talent)
				and not SpellCooldown(glacial_spike)
				and Mana() >= ManaCost(glacial_spike)
				and target.RangeCheck(glacial_spike)
				and not IsMoving()
			}

			AddFunction AOE_IceLance_Use
			{
					not SpellCooldown(ice_lance)
				and Mana() >= ManaCost(ice_lance)
				and target.RangeCheck(ice_lance)
				and FingersOfFrost_React()
			}

			AddFunction AOE_IceNova_Use
			{
					Talent(ice_nova_talent)
				and not SpellCooldown(ice_nova)
				and target.RangeCheck(ice_nova)
			}
			
			AddFunction AOE_WaterJet_Use
			{
					pet.Present()
				and not PetSpellCooldown(water_elemental_water_jet)
				and target.RangeCheck(water_elemental_water_jet)
				and {
							IsCasting(frostbolt)
						 or target.Distance() < 15
					}
				and {
							{
									not FingersOfFrost_React()
								and target.Distance() < 15
							}
						 or {
									{
											{
													HasArtifactTrait(icy_hand)
												and BuffStacks(fingers_of_frost_buff) < 3
											}
										 or BuffStacks(fingers_of_frost_buff) < 2
									}
								and target.Distance() >= 15
							}
					}
				and not BuffPresent(brain_freeze_buff)
			}

			###
			### AOE Rotation - Usage
			###
			AddFunction Rotation_AOE_Use
			{
					Enemies() >= 4
			}

			###
			### AOE Rotation
			###
			AddFunction Rotation_AOE
			{
				if AOE_Frostbolt_Use_WaterJet() Spell(frostbolt)
				if CheckBoxOn(opt_blizzard_freezing_rain) and Standard_Blizzard_Use_FreezingRain() Spell(blizzard)
				if CheckBoxOn(opt_frozen_orb) and AOE_FrozenOrb_Use() Spell(frozen_orb)
				if CheckBoxOn(opt_blizzard) and AOE_Blizzard_Use() Spell(blizzard)
				if CheckBoxOn(opt_comet_storm) and AOE_CometStorm_Use() Spell(comet_storm)
				if CheckBoxOn(opt_ice_nova) and AOE_IceNova_Use() Spell(ice_nova)
				if CheckBoxOn(opt_water_jet) and AOE_WaterJet_Use() Spell(water_elemental_water_jet)
				if AOE_Flurry_Use_BrainFreeze() Spell(flurry)
				if AOE_Flurry_Use_Ebonbolt() Spell(flurry)
				if AOE_Flurry_Use() Spell(flurry)
				if CheckBoxOn(opt_frost_bomb) and AOE_FrostBomb_Use() Spell(frost_bomb)
				if AOE_IceLance_Use() Spell(ice_lance)
				if CheckBoxOn(opt_ebonbolt) and AOE_Ebonbolt_Use() Spell(ebonbolt)
				if CheckBoxOn(opt_glacial_spike) and AOE_GlacialSpike_Use() Spell(glacial_spike)
				if AOE_Frostbolt_Use() Spell(frostbolt)				
			}

			###
			### Cooldowns Rotation - Functions
			###
			AddFunction Cooldowns_IcyVeins_Use
			{
					not SpellCooldown(icy_veins)
				and not BuffPresent(icy_veins_buff)
			}

			AddFunction Cooldowns_MirrorImage_Use
			{
					Talent(mirror_image_talent)
				and not SpellCooldown(mirror_image)
				and Mana() >= ManaCost(mirror_image)
			}

			AddFunction Cooldowns_RuneOfPower_Use
			{
					Talent(rune_of_power_talent)
				and SpellCharges(rune_of_power) >= 1
				and not IsMoving()
				and not PreviousGCDSpell(rune_of_power)
				and not RuneOfPowerBuff()
				and {
							{
									SpellCooldown(icy_veins) < CastTime(rune_of_power)
								 or Charges(rune_of_power count=0) > 1.9
							}
						and {
									SpellCooldown(icy_veins) > 10
								 or BuffPresent(icy_veins_buff)
								 or target.TimeToDie() + 5 < Charges(rune_of_power count=0) * 10
							}
					}
			}

			###
			### Cooldowns Rotation
			###
			AddFunction Rotation_Cooldowns
			{
				if CheckBoxOn(opt_power_rune) and Cooldowns_RuneOfPower_Use() Spell(rune_of_power)
				if CheckBoxOn(opt_icy_veins) and Cooldowns_IcyVeins_Use() Spell(icy_veins)
				if CheckBoxOn(opt_mirror_image) and Cooldowns_MirrorImage_Use() Spell(mirror_image)				
			}

			###
			### Standard Rotation - Functions
			###
			AddFunction Standard_Blizzard_Use
			{
					not SpellCooldown(blizzard)
				and Mana() >= ManaCost(blizzard)
				and {
							not IsMoving()
						 or BuffPresent(freezing_rain_buff)
					}
				and {
							Enemies() > 1
						 or {
									BuffStacks(zannesu_journey_buff) == 5
								and BuffRemaining(zannesu_journey_buff) > CastTime(blizzard)
							}
					}
			}

			AddFunction Standard_Blizzard_Use_FreezingRain
			{
					not SpellCooldown(blizzard)
				and Mana() >= ManaCost(blizzard)
				and BuffPresent(freezing_rain_buff)
				and Enemies() > 1
				and BuffStacks(fingers_of_frost_buff) < 3
			}

			AddFunction Standard_CometStorm_Use
			{
					Talent(comet_storm_talent)
				and not SpellCooldown(comet_storm)
				and Mana() >= ManaCost(comet_storm)
				and target.RangeCheck(comet_storm)
			}

			AddFunction Standard_Ebonbolt_Use
			{
					SpellKnown(ebonbolt)
				and not SpellCooldown(ebonbolt)
				and target.RangeCheck(ebonbolt)
				and not IsMoving()
				and not BuffPresent(brain_freeze_buff)
				and not FingersOfFrost_React()
			}

			AddFunction Standard_Flurry_Use
			{
					not SpellCooldown(flurry)
				and target.RangeCheck(flurry)
				and {
							not IsMoving()
						 or BuffPresent(brain_freeze_buff)
					}
				and PreviousGCDSpell(ebonbolt)
			}

			AddFunction Standard_Flurry_Use_Ebonbolt
			{
					not SpellCooldown(flurry)
				and target.RangeCheck(flurry)
				and PreviousGCDSpell(ebonbolt)
				and not FingersOfFrost_React()
				and {
							not BuffPresent(icy_veins_buff)
						 or LadyVashjGraspNextFoF() > GCD()
					}
			}

			AddFunction Standard_Flurry_Use_Frostbolt
			{
					not SpellCooldown(flurry)
				and target.RangeCheck(flurry)
				and BuffPresent(brain_freeze_buff)
				and PreviousGCDSpell(frostbolt)
				and not BuffPresent(icy_veins_buff)
			}

			AddFunction Standard_Flurry_Use_Frostbolt_LadyVashjGrasp
			{
					not SpellCooldown(flurry)
				and target.RangeCheck(flurry)
				and BuffPresent(brain_freeze_buff)
				and not FingersOfFrost_React()
				and PreviousGCDSpell(frostbolt)
				and LadyVashjGraspNextFoF() > GCD()
			}

			AddFunction Standard_Flurry_Use_LadyVashjGrasp
			{
					not SpellCooldown(flurry)
				and target.RangeCheck(flurry)
				and BuffPresent(brain_freeze_buff)
				and not FingersOfFrost_React()
				and BuffRemaining(icy_veins_buff) > GCD()
				and LadyVashjGraspNextFoF() > GCD()
				and LadyVashjGraspNextFoF() < ExecuteTime(frostbolt) + GCD()
			}

			AddFunction Standard_Frostbolt_Use
			{
					not SpellCooldown(frostbolt)
				and Mana() >= ManaCost(frostbolt)
				and target.RangeCheck(frostbolt)
				and not IsMoving()
			}

			AddFunction Standard_Frostbolt_Use_WaterJet
			{
					not SpellCooldown(frostbolt)
				and Mana() >= ManaCost(frostbolt)
				and target.RangeCheck(frostbolt)
				and not IsMoving()
				and PreviousOffGCDSpell(water_elemental_water_jet)
				and CastTime(frostbolt) + TravelTime(frostbolt) < target.DebuffRemaining(water_elemental_water_jet_debuff)
			}

			AddFunction Standard_FrostBomb_Use
			{
					Talent(frost_bomb_talent)
				and not SpellCooldown(frost_bomb)
				and Mana() >= ManaCost(frost_bomb)
				and target.RangeCheck(frost_bomb)
				and not IsMoving()
				and target.DebuffRemains(frost_bomb_debuff) < TravelTime(ice_lance)
				and FingersOfFrost_React()
			}

			AddFunction Standard_FrozenOrb_Use
			{
					not SpellCooldown(frozen_orb)
				and Mana() >= ManaCost(frozen_orb)
				and {
							Enemies() > 1
						 or BuffRemaining(icy_veins_buff) > 6
						 or SpellCooldown(icy_veins) < 1
						 or SpellCooldown(icy_veins) > 25
					}
			}

			AddFunction Standard_GlacialSpike_Use
			{
					Talent(glacial_spike_talent)
				and not SpellCooldown(glacial_spike)
				and Mana() >= ManaCost(glacial_spike)
				and target.RangeCheck(glacial_spike)
				and not IsMoving()
			}

			AddFunction Standard_IceLance_Use
			{
					not SpellCooldown(ice_lance)
				and Mana() >= ManaCost(ice_lance)
				and target.RangeCheck(ice_lance)
				and FingersOfFrost_React()
			}

			AddFunction Standard_IceNova_Use
			{
					Talent(ice_nova_talent)
				and not SpellCooldown(ice_nova)
				and target.RangeCheck(ice_nova)
			}

			AddFunction Standard_IceNova_Use_WintersChill
			{
					Talent(ice_nova_talent)
				and not SpellCooldown(ice_nova)
				and target.RangeCheck(ice_nova)
				and target.DebuffPresent(winters_chill_debuff)
			}

			AddFunction Standard_RayOfFrost_Use
			{
					Talent(ray_of_frost_talent)
				and not SpellCooldown(ray_of_frost)
				and not PreviousSpell(ray_of_frost)
				and target.RangeCheck(ray_of_frost)
				and not IsMoving()
				and {
							BuffPresent(icy_veins_buff)
						 or {
									SpellCooldown(icy_veins) > SpellCooldown(ray_of_frost)
								and not RuneOfPowerBuff()
							}
					}
			}

			AddFunction Standard_WaterJet_Use
			{
					pet.Present()
				and not PetSpellCooldown(water_elemental_water_jet)
				and target.RangeCheck(water_elemental_water_jet)
				and {
							IsCasting(frostbolt)
						 or target.Distance() < 15
					}
				and {
							{
									not FingersOfFrost_React()
								and target.Distance() < 15
							}
						 or {
									{
											{
													HasArtifactTrait(icy_hand)
												and BuffStacks(fingers_of_frost_buff) < 3
											}
										 or BuffStacks(fingers_of_frost_buff) < 2
									}
								and target.Distance() >= 15
							}
					}
				and not BuffPresent(brain_freeze_buff)
			}

			###
			### Standard Rotation
			###
			AddFunction Rotation_Standard
			{
				if CheckBoxOn(opt_ice_nova) and Standard_IceNova_Use_WintersChill() Spell(ice_nova)
				if Standard_Frostbolt_Use_WaterJet() Spell(frostbolt)
				if CheckBoxOn(opt_water_jet) and Standard_WaterJet_Use() Spell(water_elemental_water_jet)
				if CheckBoxOn(opt_ray_of_frost) and Standard_RayOfFrost_Use() Spell(ray_of_frost)
				if Standard_Flurry_Use_Frostbolt() Spell(flurry)
				if Standard_Flurry_Use_LadyVashjGrasp() Spell(flurry)
				if Standard_Flurry_Use_Frostbolt_LadyVashjGrasp() Spell(flurry)
				if Standard_Flurry_Use_Ebonbolt() Spell(flurry)
				if Standard_Flurry_Use() Spell(flurry)
				if CheckBoxOn(opt_blizzard_freezing_rain) and Standard_Blizzard_Use_FreezingRain() Spell(blizzard)
				if CheckBoxOn(opt_frost_bomb) and Standard_FrostBomb_Use() Spell(frost_bomb)
				if Standard_IceLance_Use() Spell(ice_lance)
				if CheckBoxOn(opt_frozen_orb) and Standard_FrozenOrb_Use() Spell(frozen_orb)
				if CheckBoxOn(opt_ice_nova) and Standard_IceNova_Use() Spell(ice_nova)
				if CheckBoxOn(opt_comet_storm) and Standard_CometStorm_Use() Spell(comet_storm)
				if CheckBoxOn(opt_blizzard) and Standard_Blizzard_Use() Spell(blizzard)
				if CheckBoxOn(opt_ebonbolt) and Standard_Ebonbolt_Use() Spell(ebonbolt)
				if CheckBoxOn(opt_glacial_spike) and Standard_GlacialSpike_Use() Spell(glacial_spike)
				if Standard_Frostbolt_Use() Spell(frostbolt)				
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_IceFlows_Use
			{
					Talent(ice_floes_talent)
				and not BuffPresent(ice_floes_buff)
				and SpellCharges(ice_floes) >= 1
				and MovementCheck()
			}

			AddFunction Main_IceLance_Use_Flurry
			{
					not SpellCooldown(ice_lance)
				and Mana() > ManaCost(ice_lance)
				and target.RangeCheck(ice_lance)
				and PreviousGCDSpell(flurry)
			}

			AddFunction Main_IceLance_Use_WintersChill
			{
					not SpellCooldown(ice_lance)
				and Mana() > ManaCost(ice_lance)
				and target.RangeCheck(ice_lance)
				and not FingersOfFrost_React()
				and target.DebuffRemaining(winters_chill_debuff) > TravelTime(ice_lance)
			}

			AddFunction Main_IceLance_Use_Moving
			{
					not SpellCooldown(ice_lance)
				and Mana() > ManaCost(ice_lance)
				and target.RangeCheck(ice_lance)
				and IsMoving()
			}

			AddFunction Main_TimeWarp_Use
			{
					not SpellCooldown(time_warp)
				and Mana() >= ManaCost(time_warp)
				and IsBossFight()
				and {
							{
									not BloodlustActive()
								and {
											LunaEclipse_Bloodlust_Used()
										 or GroupMembers() == 1
									}
							}
						and LegendaryEquipped(shard_of_the_exodar)
						and {
									SpellCooldown(icy_veins) < 1
								 or target.TimeToDie() < 50
							}
					}
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				# Use Ice Flows if moving so spells can be cast
				if CheckBoxOn(opt_ice_floes) and Main_IceFlows_Use() Spell(ice_floes)

				if Main_IceLance_Use_WintersChill() Spell(ice_lance)
				if Main_IceLance_Use_Flurry() Spell(ice_lance)

				# Use Time Warp if Shard of Exodar is equipped and Time Warp has already been used.
				if CheckBoxOn(opt_time_warp) and Main_TimeWarp_Use() Spell(time_warp)

				# Show the major cooldowns rotation.
				Rotation_Cooldowns()

				# Use the AOE rotation when fighting 4 or more enemies.
				if Rotation_AOE_Use() Rotation_AOE()

				# Use the Standard rotation when fighting less then 4 enemies.
				if not Rotation_AOE_Use() Rotation_Standard()

				# Ice Lance if moving and there is nothing else that can be done
				if Main_IceLance_Use_Moving() Spell(ice_lance)

				# Show Forward Arrow if out of range of longest range ability
				if not target.RangeCheck(frostbolt) Texture(misc_arrowlup help="No Abilities in range")
			}

			AddFunction Main_Precombat
			{
				if CheckBoxOn(opt_mirror_image) and Cooldowns_MirrorImage_Use() Spell(mirror_image)
				if target.RangeCheck(frostbolt) and not IsMoving() Spell(frostbolt)
			}

			###
			### CD Icon Rotations - Functions
			###
			AddFunction CD_ArcaneTorrent_Use
			{
					Race(BloodElf)
				and not SpellCooldown(arcane_torrent_mana)
			}

			AddFunction CD_Berserking_Use
			{
					Race(Troll)
				and not SpellCooldown(berserking)
			}

			AddFunction CD_BloodFury_Use
			{
					Race(Orc)
				and not SpellCooldown(blood_fury_sp)
			}

			AddFunction CD_IceBlock_Use
			{
					not SpellCooldown(ice_block)
				and Mana() >= ManaCost(ice_block)
				and not BuffPresent(ice_block_buff)
				and not player.DebuffPresent(hypothermia_debuff)
				and HealthPercent() <= 40
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and {
									BuffPresent(icy_veins_buff)
								 or SpellCooldown(icy_veins) < 1
							}
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 40
			}

			###
			### CD Icon Rotations
			###
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Abilities
				if not CheckBoxOn(opt_time_warp) and Main_TimeWarp_Use() Spell(time_warp)
				if not CheckBoxOn(opt_icy_veins) and Cooldowns_IcyVeins_Use() Spell(icy_veins)

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_prolonged_power)

				# Display Ice Block only if option is checked
				if CheckBoxOn(opt_ice_block) and CD_IceBlock_Use() Spell(ice_block)

				# Standard Actions
				if CD_BloodFury_Use() Spell(blood_fury_sp)
				if CD_Berserking_Use() Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_mana)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_prolonged_power)
			}

			###
			### Rotation Icons.
			###
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

		OvaleScripts:RegisterScript("MAGE", "frost", name, desc, code, "script");
	end
end