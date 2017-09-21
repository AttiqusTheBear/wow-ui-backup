local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "profiler781_mage_frost";
		local desc = "Profiler781: Frost Mage";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.MAGE_FROST,
			ScriptAuthor = "Profiler781",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding"] = "3012321",
			["Dungeons / Mythic+"] = "3033331",
			["Solo / World Quests"] = "3033312",
			["Easy Mode"] = "3132111",
		};

		local code = [[
			Include(lunaeclipse_mage_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_barrier_spells "Defensive: Barrier Spells")
			AddCheckBox(opt_rune_of_power "CD: Rune of Power" default)
			AddCheckBox(opt_icy_veins "CD: Icy Veins" default)
			AddCheckBox(opt_ray_of_frost "CD: Ray of Frost" default)
			AddCheckBox(opt_frozen_orb "CD: Frozen Orb" default)
			AddCheckBox(opt_mirror_image "CD: Mirror Image" default)
			AddCheckBox(opt_time_warp "CD: Time Warp" default)
			AddCheckBox(opt_time_warp_on "CD: Suggest Time Warp" default)
			AddCheckBox(opt_movement_fight "Tactic: Movement Fight")

			###
			### Artifact Functions
			###
			AddFunction Ebonchill_Available
			{
					SpellKnown(ebonbolt)
				and not SpellCooldown(ebonbolt)
			}

			AddFunction Ebonbolt_Use
			{
					Ebonchill_Available()
				and not IsMoving()
				and not BuffPresent(brain_freeze_buff)
			}

			###
			### Blizzard
			###
			AddFunction Blizzard_Use
			{
					not SpellCooldown(blizzard)
				and {
							Talent(arctic_gale_talent)
						 or Enemies() > 2
						 or BuffStacks(zannesu_journey_buff) == 5
						 or {
						 			BuffRemaining(zannesu_journey_buff) <= ExecuteTime(blizzard) + GCD() * 3
						 		and BuffPresent(zannesu_journey_buff)
						 	}
					}
				and not IsMoving()
			}

			AddFunction Blizzard_FreezingRain_Use
			{
					not SpellCooldown(blizzard)
				and BuffPresent(freezing_rain)
			}

			###
			### Comet Storm
			###
			AddFunction CometStorm_Use
			{
					not SpellCooldown(comet_storm)
				and Talent(comet_storm_talent)
			}

			###
			### Flurry
			###
			AddFunction Flurry_Use
			{
					not SpellCooldown(flurry)
				and BuffPresent(brain_freeze_buff)
			}

			###
			### Freeze
			###
			AddFunction Freeze_Use
			{
					not PetSpellCooldown(water_elemental_freeze)
				and pet.Present()
				and not target.Classification(worldboss)
				and Enemies() > 1
				and {
							not BuffPresent(fingers_of_frost_buff)
						 or Enemies() <= SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand) - BuffStacks(fingers_of_frost_buff)
					}
				and {
							BuffPresent(icy_veins_buff)
						 or SpellCooldown(icy_veins) >= Talent(thermal_void_talent) * 5
					}
				and SpellCooldown(frozen_orb) <= SpellCooldownDuration(frozen_orb) - TravelTime(frozen_orb)
			}

			###
			### Frost Bomb
			###
			AddFunction FrostBomb_Use
			{
					not SpellCooldown(frost_bomb)
				and Talent(frost_bomb_talent)
				and not target.DebuffPresent(frost_bomb_debuff)
				and {
							IceLance_Dump_Use()
						 or {
						 			Flurry_Use()
						 		and target.DebuffRemaining(frost_bomb_debuff) < GCD()
						 	}
						 or IceLance_Use()
						 or {
						 			target.DebuffRemaining(frost_bomb_debuff) < GCD() * 3
						 		and {
						 					not SpellCooldown(frozen_orb)
						 				 or SpellCooldown(frozen_orb) <= ExecuteTime(frost_bomb)
						 			}
						 	}
					}
				and not IsMoving()
			}

			###
			### Frostbolt
			###
			AddFunction Frostbolt_Use
			{
					not SpellCooldown(frostbolt)
				and not IsMoving()
			}

			AddFunction Frostbolt_WaterJet_Use
			{
					not SpellCooldown(frostbolt)
				and PetSpellCooldown(water_elemental_water_jet) >= SpellCooldownDuration(water_elemental_water_jet) - BaseDuration(water_elemental_water_jet_debuff)
				and {
							{
									isCasting(frostbolt)
								and BuffStacks(fingers_of_frost_buff) < SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand) - 1
							} or {
									not isCasting(frostbolt)
								and BuffStacks(fingers_of_frost_buff) < SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand)
							}
					}
				and not IsMoving()
			}

			###
			### Frozen Orb
			###
			AddFunction FrozenOrb_Use
			{
					not SpellCooldown(frozen_orb)
				and {
							BuffPresent(icy_veins_buff)
						 or SpellCooldown(icy_veins) >= Talent(thermal_void_talent) * 15
						 or not SpellCooldown(icy_veins)
					}
			}

			###
			### Glacial Spike
			###
			AddFunction GlacialSpike_Use
			{
					not SpellCooldown(glacial_spike)
				and Talent(glacial_spike_talent)
				and BuffStacks(icicles_buff) == 5
				and not IsMoving()
			}

			###
			### Ice Barrier
			###
			AddFunction IceBarrier_Use
			{
					not SpellCooldown(ice_barrier)
				and not BuffPresent(ice_barrier_buff)
			}

			###
			### Ice Flows
			###
			AddFunction IceFlows_Use
			{
					not SpellCooldown(ice_floes)
				and Talent(ice_floes_talent)
				and SpellCharges(ice_floes) > 0
			}

			###
			### Ice Lance
			###
			AddFunction IceLance_WintersChill_Use
			{
					not SpellCooldown(ice_lance)
				and {
							PreviousGCDSPell(flurry)
						 or GCD() <= 1
					}
				and target.DebuffPresent(winters_chill_debuff)
			}

			AddFunction IceLance_Dump_Use
			{
					not SpellCooldown(ice_lance)
				and BuffPresent(fingers_of_frost_buff)
				and {
							{
									{
											not SpellCooldown(water_elemental_water_jet)
										 or SpellCooldown(water_elemental_water_jet) <= GCD() * BuffStacks(fingers_of_frost_buff)
									}
								and pet.Present()
								and BuffStacks(fingers_of_frost_buff) > SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand) - 3.5 / ExecuteTime(frostbolt)
							}
						 or {
									{
											not SpellCooldown(water_elemental_freeze)
										 or SpellCooldown(water_elemental_freeze) <= GCD() * BuffStacks(fingers_of_frost_buff)
									}
								and pet.Present()
								and not target.Classification(worldboss)
								and Enemies() > 1
								and Enemies() > SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand) - BuffStacks(fingers_of_frost_buff)
							}
						 or {
									SpellKnown(ebonbolt)
								and {
											not SpellCooldown(ebonbolt)
										 or SpellCooldown(ebonbolt) <= GCD() * BuffStacks(fingers_of_frost_buff)
									}
								and not IsMoving()
							}
						 or Flurry_Use()
						 or BuffStacks(fingers_of_frost_buff) == SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand)
					}
			}

			AddFunction IceLance_Use
			{
					not SpellCooldown(ice_lance)
				and BuffPresent(fingers_of_frost_buff)
				and {
							Speed() > 0
						 or {
						 			CheckBoxOff(opt_movement_fight)
						 		and not Talent(frost_bomb_talent)
						 		and {
						 					BuffPresent(icy_veins_buff)
						 				 or SpellCooldown(icy_veins) >= Talent(thermal_void_talent) * 7 * GCD()
						 			}
						 	}
						 or target.DebuffPresent(frost_bomb_debuff)
						 or BuffRemaining(fingers_of_frost_buff) < GCD() * 3
						 or {
						 			BuffRemaining(magtheridons_might_buff) <= GCD()
						 		and BuffPresent(magtheridons_might_buff)
						 	}
					}
			}

			AddFunction IceLance_WaterJet_Use
			{
					not SpellCooldown(ice_lance)
				and {
							BuffStacks(fingers_of_frost_buff) == SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand)
						 or {
						 			BuffStacks(fingers_of_frost_buff) == SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand) - 1
						 		and isCasting(Frostbolt)
							}
					}
				and PetSpellCooldown(water_elemental_water_jet) >= SpellCooldownDuration(water_elemental_water_jet) - BaseDuration(water_elemental_water_jet_debuff) + GCD() + ExecuteTime(frostbolt)
			}

			AddFunction IceLance_Moving_Use
			{
					not SpellCooldown(ice_lance)
			}

			###
			### Ice Nova
			###
			AddFunction IceNova_Use
			{
					not SpellCooldown(ice_nova)
				and Talent(ice_nova_talent)
			}

			###
			### Icy Veins
			###
			AddFunction IcyVeins_Use
			{
					not SpellCooldown(icy_veins)
				and not BuffPresent(icy_veins_buff)
				and {
							BuffPresent(fingers_of_frost_buff)
						 or BuffPresent(brain_freeze_buff)
						 or target.DebuffPresent(winters_chill_debuff)
					}
			}

			###
			### Mirror Image
			###
			AddFunction MirrorImage_Use
			{
					not SpellCooldown(mirror_image)
			}

			###
			### Ray Of Frost
			###
			AddFunction RayOfFrost_Use
			{
					not SpellCooldown(ray_of_frost)
				and Talent(ray_of_frost_talent)
				and {
							not Talent(rune_of_power_talent)
						 or {
						 			Talent(rune_of_power_talent)
						 		and SpellCharges(rune_of_power) == 0
						 	}
					}
				and not isCasting(ray_of_frost)
				and not IsMoving()
			}

			###
			### Rune Of Power
			###
			AddFunction RuneOfPower_Use
			{
					not SpellCooldown(rune_of_power)
				and Talent(rune_of_power_talent)
				and not BuffPresent(rune_of_power_buff)
				and {
							SpellCooldown(icy_veins) <= ExecuteTime(rune_of_power)
						 or {
						 			Talent(ray_of_frost_talent)
						 		and SpellCooldown(ray_of_frost) <= ExecuteTime(rune_of_power)
						 	}
						 or {
						 			SpellCooldown(frozen_orb) <= ExecuteTime(rune_of_power)
						 		and {
											BuffPresent(icy_veins_buff)
										 or SpellCooldown(icy_veins) >= Talent(thermal_void_talent) * 30
									}
							}
						 or {
						 			Ebonchill_Available()
								and not BuffPresent(brain_freeze_buff)
								and SpellCooldown(ebonbolt) <= ExecuteTime(rune_of_power)
							}
						 or Waterjet_Use()
						 or Freeze_Use()
					}
				and not IsMoving()
			}

			AddFunction RuneOfPower_Max_Use
			{
					not SpellCooldown(rune_of_power)
				and Talent(rune_of_power_talent)
				and not BuffPresent(rune_of_power_buff)
				and {
							SpellCharges(rune_of_power) == 2
						 or {
						 			SpellCharges(rune_of_power) == 1
						 		and SpellChargeCooldown(rune_of_power) <= GCD()
							}
					}
				and not IsMoving()
			}

			###
			### Time Warp Functions
			###
			AddFunction TimeWarp_Use_ShardOfExodar
			{
					not SpellCooldown(time_warp)
				and IsBossFight()
				and LegendaryEquipped(shard_of_the_exodar)
				and not BloodlustActive()
				and {
							LunaEclipse_Bloodlust_Used()
						 or GroupMembers() == 1
					}
			}

			AddFunction TimeWarp_Use
			{
					not SpellCooldown(time_warp)
				and IsBossFight()
				and not BloodlustActive()
				and not LunaEclipse_Bloodlust_Used()
			}

			###
			### Water Elemental
			###
			AddFunction WaterElemental_Use
			{
					not SpellCooldown(water_elemental)
				and not pet.Present()
				and not Talent(lonely_winter_talent)
				and not IsMoving()
			}

			###
			### Water Jet
			###
			AddFunction Waterjet_Use
			{
					not PetSpellCooldown(water_elemental_water_jet)
				and pet.Present()
				and {
							not BuffPresent(fingers_of_frost_buff)
						 or BuffStacks(fingers_of_frost_buff) <= SpellData(fingers_of_frost_buff max_stacks) + HasArtifactTrait(icy_hand) - 3.5 / ExecuteTime(frostbolt)
					}
				and isCasting(frostbolt)
				and {
							BuffPresent(icy_veins_buff)
						 or SpellCooldown(icy_veins) >= Talent(thermal_void_talent) * 5
					}
				and SpellCooldown(frozen_orb) <= SpellCooldownDuration(frozen_orb) - TravelTime(frozen_orb)
			}

			###
			### IsMoving Function
			###
			AddFunction IsMoving
			{
					MovementCheck()
				and {
							not Talent(ice_floes_talent)
						 or {
						 			not BuffPresent(ice_floes_buff)
								and SpellCharges(ice_floes) == 0
							}
						 or isCasting(ray_of_frost)
					}
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					Spell(counterspell)

					if not target.Classification(worldboss)
					{
						Spell(arcane_torrent_mana)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						Spell(war_stomp)
					}
				}
			}

			###
			### Frost - Main
			###
			AddFunction ShortCD
			{
				if IceFlows_Use() Spell(ice_floes)
				if WaterElemental_Use() Spell(water_elemental)
				if Freeze_Use() Spell(water_elemental_freeze)
				if Waterjet_Use() Spell(water_elemental_water_jet)
				if CheckBoxOn(opt_barrier_spells) and IceBarrier_Use() Spell(ice_barrier)
			}

			AddFunction Main
			{
				if IceLance_WintersChill_Use() Spell(ice_lance)
				if Frostbolt_WaterJet_Use() Spell(frostbolt)
				if IceLance_WaterJet_Use() Spell(ice_lance)
				if CheckBoxOn(opt_rune_of_power) and RuneOfPower_Max_Use() Spell(rune_of_power)
				if CheckBoxOn(opt_mirror_image) and MirrorImage_Use() Spell(mirror_image)
				if CheckBoxOn(opt_rune_of_power) and RuneOfPower_Use() Spell(rune_of_power)
				if CheckBoxOn(opt_icy_veins) and IcyVeins_Use() Spell(icy_veins)
				if CheckBoxOn(opt_time_warp) and CheckBoxOn(opt_time_warp_on) and TimeWarp_Use_ShardOfExodar() Spell(time_warp text=shard)
				if CheckBoxOn(opt_time_warp) and CheckBoxOn(opt_time_warp_on) and TimeWarp_Use() Spell(time_warp)
				if Blizzard_FreezingRain_Use() Spell(blizzard)
				if Ebonbolt_Use() Spell(ebonbolt)
				if FrostBomb_Use() Spell(frost_bomb)
				if IceLance_Dump_Use() Spell(ice_lance)
				if Flurry_Use() Spell(flurry)
				if CheckBoxOn(opt_ray_of_frost) and RayOfFrost_Use() Spell(ray_of_frost)
				if CheckBoxOn(opt_frozen_orb) and FrozenOrb_Use() Spell(frozen_orb)
				if IceNova_Use() Spell(ice_nova)
				if CometStorm_Use() Spell(comet_storm)
				if Blizzard_Use() Spell(blizzard)
				if IceLance_Use() Spell(ice_lance)
				if GlacialSpike_Use() Spell(glacial_spike)
				if Frostbolt_Use() Spell(frostbolt)
				if IceLance_Moving_Use() Spell(ice_lance)
			}

			AddFunction CD
			{
				Rotation_Interrupt()

				if CheckBoxOff(opt_rune_of_power) and RuneOfPower_Max_Use() Spell(rune_of_power)
				if CheckBoxOff(opt_mirror_image) and MirrorImage_Use() Spell(mirror_image)
				if CheckBoxOff(opt_rune_of_power) and RuneOfPower_Use() Spell(rune_of_power)
				if CheckBoxOff(opt_icy_veins) and IcyVeins_Use() Spell(icy_veins)
				if BuffPresent(icy_veins_buff)
				{
					Spell(blood_fury_sp)
					Spell(berserking)
					Rotation_ItemActions()
					if LunaEclipse_Potion_Use() Item(draenic_intellect_potion)
				}
				if CheckBoxOff(opt_time_warp) and CheckBoxOn(opt_time_warp_on) and TimeWarp_Use_ShardOfExodar() Spell(time_warp text=shard)
				if CheckBoxOff(opt_time_warp) and CheckBoxOn(opt_time_warp_on) and TimeWarp_Use() Spell(time_warp)
				if CheckBoxOff(opt_ray_of_frost) and RayOfFrost_Use() Spell(ray_of_frost)
				if CheckBoxOff(opt_frozen_orb) and FrozenOrb_Use() Spell(frozen_orb)
			}

			###
			### Frost - Precombat
			###
			AddFunction ShortCD_Precombat
			{
				if WaterElemental_Use() Spell(water_elemental)
				if CheckBoxOn(opt_barrier_spells) and IceBarrier_Use() Spell(ice_barrier)
			}

			AddFunction Main_Precombat
			{
				if CheckBoxOn(opt_rune_of_power) and RuneOfPower_Max_Use() Spell(rune_of_power)
				if CheckBoxOn(opt_mirror_image) and MirrorImage_Use() Spell(mirror_image)
				if CheckBoxOn(opt_rune_of_power) and RuneOfPower_Use() Spell(rune_of_power)
				if Ebonbolt_Use() Spell(ebonbolt)
			}

			AddFunction CD_Precombat
			{
				if CheckBoxOff(opt_rune_of_power) and RuneOfPower_Max_Use() Spell(rune_of_power)
				if CheckBoxOff(opt_mirror_image) and MirrorImage_Use() Spell(mirror_image)
				if CheckBoxOff(opt_rune_of_power) and RuneOfPower_Use() Spell(rune_of_power)
				if LunaEclipse_Potion_Use() Item(potion_of_prolonged_power)
			}

			###
			### Rotation Icons
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