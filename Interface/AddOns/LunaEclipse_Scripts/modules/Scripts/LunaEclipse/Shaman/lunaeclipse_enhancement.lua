local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_shaman_enhancement";
		local desc = "LunaEclipse: Enhancement Shaman";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.SHAMAN_ENHANCEMENT,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Wordup",
			GuideLink = "http://www.icy-veins.com/wow/enhancement-shaman-pve-dps-guide",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raid"] = "3002111",
			["Dungeons / Mythic+"] = "3002331",
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
					OPT_CRASH_LIGHTNING = {
						type = "toggle",
						name = BINDING_NAME_OPT_CRASH_LIGHTNING,
						desc = functionsConfiguration:getAOETooltip("Crash Lightning"),
						arg = "OPT_CRASH_LIGHTNING",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
				},
			},
			settingsBuff = {
				type = "group",
				name = BINDING_HEADER_BUFFS_DEBUFFS,
				inline = true,
				order = 20,
				args = {
					OPT_LIGHTNING_SHIELD = {
						type = "toggle",
						name = BINDING_NAME_OPT_LIGHTNING_SHIELD,
						desc = functionsConfiguration:getBuffTooltip("Lightning Shield"),
						arg = "OPT_LIGHTNING_SHIELD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
				},
			},
			settingsCooldowns = {
				type = "group",
				name = BINDING_HEADER_COOLDOWNS,
				inline = true,
				order = 30,
				args = {
					OPT_ASCENDANCE = {
						type = "toggle",
						name = BINDING_NAME_OPT_ASCENDANCE,
						desc = functionsConfiguration:getCooldownTooltip("Ascendance", "CD"),
						arg = "OPT_ASCENDANCE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_DOOM_WINDS = {
						type = "toggle",
						name = BINDING_NAME_OPT_DOOM_WINDS,
						desc = functionsConfiguration:getCooldownTooltip("Doom Winds"),
						arg = "OPT_DOOM_WINDS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_EARTHEN_SPIKE = {
						type = "toggle",
						name = BINDING_NAME_OPT_EARTHEN_SPIKE,
						desc = functionsConfiguration:getCooldownTooltip("Earthen Spike"),
						arg = "OPT_EARTHEN_SPIKE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_FERAL_SPIRIT = {
						type = "toggle",
						name = BINDING_NAME_OPT_FERAL_SPIRIT,
						desc = functionsConfiguration:getCooldownTooltip("Feral Spirit", "CD"),
						arg = "OPT_FERAL_SPIRIT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_FURY_OF_AIR = {
						type = "toggle",
						name = BINDING_NAME_OPT_FURY_OF_AIR,
						desc = functionsConfiguration:getCooldownTooltip("Fury of Air"),
						arg = "OPT_FURY_OF_AIR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_SUNDERING = {
						type = "toggle",
						name = BINDING_NAME_OPT_SUNDERING,
						desc = functionsConfiguration:getCooldownTooltip("Sundering"),
						arg = "OPT_SUNDERING",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_WINDSONG = {
						type = "toggle",
						name = BINDING_NAME_OPT_WINDSONG,
						desc = functionsConfiguration:getCooldownTooltip("Windsong"),
						arg = "OPT_WINDSONG",
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
					OPT_ASTRAL_SHIFT = {
						type = "toggle",
						name = BINDING_NAME_OPT_ASTRAL_SHIFT,
						desc = functionsConfiguration:getDefensiveTooltip("Astral Shift", "ShortCD", "40%"),
						arg = "OPT_ASTRAL_SHIFT",
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
			Include(ovale_shaman_spells)
			Include(lunaeclipse_global)

			# Talents
			Define(windsong_talent 1)
			Define(hot_hand_talent 2)
			Define(landslide_talent 3)
			Define(rainfall_talent 4)
			Define(feral_lunge_talent 5)
			Define(wind_rush_totem_talent 6)
			Define(lightning_surge_totem_talent 7)
			Define(earthgrab_totem_talent 8)
			Define(voodoo_totem_talent 9)
			Define(lightning_shield_talent 10)
			Define(ancestral_swiftness_talent 11)
			Define(hailstorm_talent 12)
			Define(tempest_talent 13)
			Define(overcharge_talent 14)
			Define(empowered_stormlash_talent 15)
			Define(crashing_storm_talent 16)
			Define(fury_of_air_talent 17)
			Define(sundering_talent 18)
			Define(ascendance_talent 19)
			Define(boulderfist_talent 20)
			Define(earthen_spike_talent 21)

			# Spells
			Define(astral_shift 108271)
				SpellInfo(astral_shift cd=90 gcd=0)
				SpellAddBuff(astral_shift astral_shift_buff=1)				

			# Buffs
			Define(astral_shift_buff 108271)
				SpellInfo(astral_shift_buff duration=8)
			Define(frostbrand_buff 196834)
				SpellInfo(frostbrand_buff duration=15)

			# Debuffs
			Define(earthen_spike_debuff 188089)
				SpellInfo(earthen_spike_debuff duration=10)

			# Artifact
			Define(alpha_wolf_trait 198434)

			# Legendaries
			Define(akainus_absolute_justice 137084)
			Define(smoldering_heart 151819)

			# Checkboxes
			AddCheckBox(opt_crash_lightning "AOE: Crash Lightning" default)
			AddCheckBox(opt_lightning_shield "Buff: Lightning Shield" default)
			AddCheckBox(opt_ascendance "Cooldown: Ascendance" default)		
			AddCheckBox(opt_doom_winds "Cooldown: Doom Winds" default)
			AddCheckBox(opt_earthen_spike "Cooldown: Earthen Spike" default)
			AddCheckBox(opt_feral_spirit "Cooldown: Feral Spirit" default)
			AddCheckBox(opt_fury_of_air "Cooldown: Fury of Air" default)
			AddCheckBox(opt_sundering "Cooldown: Sundering" default)
			AddCheckBox(opt_windsong "Cooldown: Windsong" default)
			AddCheckBox(opt_astral_shift "Defensive: Astral Shift" default)

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(wind_shear) Spell(wind_shear)
					if target.Distance() < 8 Spell(arcane_torrent_mana)

					if not target.IsRaidBoss()
					{
						if target.Distance() < 5 Spell(sundering)
						if target.RemainingCastTime() > 2 Spell(lightning_surge_totem)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						if target.Distance() < 5 Spell(war_stomp)
						if target.RangeCheck(hex) and target.RemainingCastTime() > ExecuteTime(hex) and target.CreatureType(Humanoid Beast) Spell(hex)
					}
				}
			}

			###
			### ShortCD Icon Rotations - Functions
			###
			AddFunction ShortCD_AstralShift_Use
			{
					not SpellCooldown(astral_shift)
				and HealthPercent() <= 40
			}

			AddFunction ShortCD_LightningShield_Use
			{
					Talent(lightning_shield_talent)
				and not SpellCooldown(lightning_shield)
				and not BuffPresent(lightning_shield_buff)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Lightning Shield Buff, only show if enabled.
				if CheckBoxOn(opt_lightning_shield) and ShortCD_LightningShield_Use() Spell(lightning_shield)

				# ShortCD Abilities
				if not CheckBoxOn(opt_fury_of_air) and Buffs_FuryOfAir_Use() Spell(fury_of_air)
				if not CheckBoxOn(opt_crash_lightning) and Buffs_CrashLighting_Use() Spell(crash_lightning)

				if not CheckBoxOn(opt_doom_winds) and Cooldowns_DoomWinds_Use() Spell(doom_winds)

				if not CheckBoxOn(opt_earthen_spike) and Core_EarthenSpike_Use() Spell(earthen_spike)
				if not CheckBoxOn(opt_crash_lightning) and Core_CrashLighting_Use() Spell(crash_lightning)
				if not CheckBoxOn(opt_windsong) and Core_Windsong_Use() Spell(windsong)
				if not CheckBoxOn(opt_crash_lightning) and Core_CrashLighting_Use_AOE() Spell(crash_lightning)
				if not CheckBoxOn(opt_crash_lightning) and Core_CrashLighting_Use_Cleave() Spell(crash_lightning)
				if not CheckBoxOn(opt_sundering) and Core_Sundering_Use() Spell(sundering)
				if not CheckBoxOn(opt_crash_lightning) and Core_CrashLighting_Use_AlphaWolf() Spell(crash_lightning)

				if not CheckBoxOn(opt_crash_lightning) and Filler_CrashLighting_Use_EarthenSpike() Spell(crash_lightning)
				if not CheckBoxOn(opt_sundering) and Filler_Sundering_Use() Spell(sundering)
				if not CheckBoxOn(opt_crash_lightning) and Filler_CrashLighting_Use() Spell(crash_lightning)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_astral_shift) and ShortCD_AstralShift_Use() Spell(astral_shift)
			}

			AddFunction ShortCD_Precombat
			{
			}

			###
			### Buffs Rotation - Functions
			###
			AddFunction Buffs_CrashLighting_Use
			{
					not SpellCooldown(crash_lightning)
				and HasArtifactTrait(alpha_wolf_trait)
				and PreviousGCDSpell(feral_spirit)
				and Maelstrom() >= 20
			}

			AddFunction Buffs_Flametongue_Use
			{
					not SpellCooldown(flametongue)
				and not BuffPresent(flametongue_buff)
			}

			AddFunction Buffs_Flametongue_Use_Refresh
			{
					not SpellCooldown(flametongue)
				and BuffRemaining(flametongue_buff) < 6 + GCD()
				and {
							not SpellKnown(doom_winds)
						 or SpellCooldown(doom_winds) < GCD() * 2
					}
			}

			AddFunction Buffs_Frostbrand_Use
			{
					not SpellCooldown(frostbrand)
				and Talent(hailstorm_talent)
				and not BuffPresent(frostbrand_buff)
				and {
							not Talent(fury_of_air_talent)
						 or {
									Talent(fury_of_air_talent)
								and Maelstrom() > 45
							}
					}
				and Maelstrom() >= 20
			}

			AddFunction Buffs_Frostbrand_Use_Refresh
			{
					not SpellCooldown(frostbrand)
				and Talent(hailstorm_talent)
				and BuffRemaining(frostbrand_buff) < 6 + GCD()
				and {
							not SpellKnown(doom_winds)
						 or SpellCooldown(doom_winds) < GCD() * 2
					}
				and Maelstrom() >= 20
			}

			AddFunction Buffs_FuryOfAir_Use
			{
					Talent(fury_of_air_talent)
				and not SpellCooldown(fury_of_air)
				and {
							BuffPresent(ascendance_enhancement_buff)
						 or TimeSincePreviousSpell(feral_spirit) < 10
						 or not SpellKnown(doom_winds)
					}
			}

			AddFunction Buffs_Rockbitter_Use
			{
					SpellCharges(rockbiter) >= 1
				and Talent(landslide_talent)
				and not BuffPresent(landslide_buff)
			}

			###
			### Buffs Rotation
			###
			AddFunction Rotation_Buffs
			{
				if Buffs_Rockbitter_Use() Spell(rockbiter)
				if CheckBoxOn(opt_fury_of_air) and Buffs_FuryOfAir_Use() Spell(fury_of_air)
				if CheckBoxOn(opt_crash_lightning) and Buffs_CrashLighting_Use() Spell(crash_lightning)
				if Buffs_Flametongue_Use() Spell(flametongue)
				if Buffs_Frostbrand_Use() Spell(frostbrand)
				if Buffs_Flametongue_Use_Refresh() Spell(flametongue)
				if Buffs_Frostbrand_Use_Refresh() Spell(frostbrand text=buff)
			}

			###
			### Cooldowns Rotation - Functions
			###
			AddFunction Cooldowns_Ascendance_Use
			{
					Talent(ascendance_talent)
				and {
							BuffPresent(doom_winds_buff)
						 or not SpellKnown(doom_winds)
					}
			}

			AddFunction Cooldowns_DoomWinds_Use
			{
					SpellKnown(doom_winds)
				and not SpellCooldown(doom_winds)
				and {
							{
									target.DebuffPresent(earthen_spike_debuff)
								and Talent(earthen_spike_talent)
							}
						 or not Talent(earthen_spike_talent)
					}
			}

			AddFunction Cooldowns_FeralSpirit_Use
			{
					not SpellCooldown(feral_spirit)
			}

			###
			### Cooldowns Rotation
			###
			AddFunction Rotation_Cooldowns
			{
				if CheckBoxOn(opt_feral_spirit) and Cooldowns_FeralSpirit_Use() Spell(feral_spirit)
				if CheckBoxOn(opt_doom_winds) and Cooldowns_DoomWinds_Use() Spell(doom_winds)
				if CheckBoxOn(opt_ascendance) and Cooldowns_Ascendance_Use() Spell(ascendance_enhancement)
			}

			###
			### Core Rotation - Functions
			###
			AddFunction Core_CrashLighting_Use
			{
					not SpellCooldown(crash_lightning)
				and not BuffPresent(crash_lightning_buff)
				and Enemies() >= 2
				and Maelstrom() >= 20
			}

			AddFunction Core_CrashLighting_Use_AlphaWolf
			{
					not SpellCooldown(crash_lightning)
				and {
							Enemies() >= 2
						 or {
									not BuffPresent(crash_lightning_buff)
								and ArmorSetBonus(T20 2)
							}
						 or TimeSincePreviousSpell(feral_spirit) < 11
					}
				and Maelstrom() >= 20
			}
# actions.core+=/crash_lightning,if=|((pet.frost_wolf.buff.alpha_wolf.remains<2&pet.fiery_wolf.buff.alpha_wolf.remains<2&pet.lightning_wolf.buff.alpha_wolf.remains<2)&feral_spirit.remains>4)

			AddFunction Core_CrashLighting_Use_AOE
			{
					not SpellCooldown(crash_lightning)
				and {
							Enemies() >= 8
						 or {
									Enemies() >= 6
								and Talent(crashing_storm_talent)
							}
					}
				and Maelstrom() >= 20
			}

			AddFunction Core_CrashLighting_Use_Cleave
			{
					not SpellCooldown(crash_lightning)
				and {
							Enemies() >= 4
						 or {
									Enemies() >= 2
								and Talent(crashing_storm_talent)
							}
					}
				and Maelstrom() >= 20
			}

			AddFunction Core_EarthenSpike_Use
			{
					Talent(earthen_spike_talent)
				and not SpellCooldown(earthen_spike)
				and {
							not Talent(fury_of_air_talent)
						 or {
									Talent(fury_of_air_talent)
								and Maelstrom() > 25
							}
					}
				and Maelstrom() >= 20
			}

			AddFunction Core_Frostbrand_Use
			{
					not SpellCooldown(frostbrand)
				and LegendaryEquipped(akainus_absolute_justice)
				and BuffPresent(hot_hand_buff)
				and not BuffPresent(frostbrand_buff)
				and Maelstrom() >= 20
			}

			AddFunction Core_LavaLash_Use
			{
					not SpellCooldown(lava_lash)
				and BuffPresent(hot_hand_buff)
				and {
							{
									LegendaryEquipped(akainus_absolute_justice)
								and BuffPresent(frostbrand_buff)
							}
						 or not LegendaryEquipped(akainus_absolute_justice)
					}		
				and Maelstrom() >= 30
			}

			AddFunction Core_LightningBolt_Use
			{
					not SpellCooldown(lightning_bolt_enhancement)
				and Talent(overcharge_talent)
				and {
							not Talent(fury_of_air_talent)
						 or {
									Talent(fury_of_air_talent)
								and Maelstrom() > 45
							}
					}
				and Maelstrom() >= 40
			}

			AddFunction Core_Stormstrike_Use
			{
					not SpellCooldown(stormstrike)
				and not BuffPresent(ascendance_enhancement_buff)
				and {
							{
									not Talent(overcharge_talent)
								and {
											not Talent(fury_of_air_talent)
										 or {
													Talent(fury_of_air_talent)
												and Maelstrom() > 45
											}
									}
							}
						 or {
									Talent(overcharge_talent)
								and {
											not Talent(fury_of_air_talent)
										 or {
													Talent(fury_of_air_talent)
												and Maelstrom() > 80
											}
									}
							}
					}
				and {
							{
									BuffPresent(stormbringer_buff)
								and Maelstrom() >= 20
							}
						 or Maelstrom() >= 40			
					}
			}

			AddFunction Core_Stormstrike_Use_Stormbringer
			{
					not SpellCooldown(stormstrike)
				and not BuffPresent(ascendance_enhancement_buff)
				and BuffPresent(stormbringer_buff)
				and {
							not Talent(fury_of_air_talent)
						 or {
									Talent(fury_of_air_talent)
								and Maelstrom() > 25
							}
					}
				and Maelstrom() >= 20
			}

			AddFunction Core_Sundering_Use
			{
					Talent(sundering_talent)
				and not SpellCooldown(sundering)
				and Enemies() >= 3
				and Maelstrom() >= 20
			}

			AddFunction Core_Windsong_Use
			{
					Talent(windsong_talent)
				and not SpellCooldown(windsong)
			}

			AddFunction Core_Windstrike_Use
			{
					not SpellCooldown(windstrike)
				and BuffPresent(ascendance_enhancement_buff)
				and {
							{
									BuffPresent(stormbringer_buff)
								and Maelstrom() >= 20
							}
						 or Maelstrom() >= 40			
					}
			}

			###
			### Core Rotation
			###
			AddFunction Rotation_Core
			{
				if CheckBoxOn(opt_earthen_spike) and Core_EarthenSpike_Use() Spell(earthen_spike)
				if CheckBoxOn(opt_crash_lightning) and Core_CrashLighting_Use() Spell(crash_lightning)
				if CheckBoxOn(opt_windsong) and Core_Windsong_Use() Spell(windsong)
				if CheckBoxOn(opt_crash_lightning) and Core_CrashLighting_Use_AOE() Spell(crash_lightning)
				if Core_Windstrike_Use() Spell(windstrike)
				if Core_Stormstrike_Use_Stormbringer() Spell(stormstrike)
				if CheckBoxOn(opt_crash_lightning) and Core_CrashLighting_Use_Cleave() Spell(crash_lightning)
				if Core_LightningBolt_Use() Spell(lightning_bolt_enhancement)
				if Core_Stormstrike_Use() Spell(stormstrike)
				if Core_Frostbrand_Use() Spell(frostbrand)
				if Core_LavaLash_Use() Spell(lava_lash)
				if CheckBoxOn(opt_sundering) and Core_Sundering_Use() Spell(sundering)
				if CheckBoxOn(opt_crash_lightning) and Core_CrashLighting_Use_AlphaWolf() Spell(crash_lightning)
			}

			###
			### Filler Rotation - Functions
			###
			AddFunction Filler_CrashLighting_Use
			{
					not SpellCooldown(crash_lightning)
				and {
							Maelstrom() >= 65
						 or Enemies() >= 2
					}
				and {
							not Talent(overcharge_talent)
						 or {
									Talent(overcharge_talent)
								and Maelstrom() > 60
							}
					}
				and {
							not Talent(fury_of_air_talent)
						 or {
									Talent(fury_of_air_talent)
								and Maelstrom() > 45
							}
					}
				and Maelstrom() >= 20
			}

			AddFunction Filler_CrashLighting_Use_EarthenSpike
			{
					not SpellCooldown(crash_lightning)
				and {
							Talent(crashing_storm_talent)
						 or Enemies() >= 2
					}
				and target.DebuffPresent(earthen_spike_debuff)
				and Maelstrom() >= 40
				and {
							not Talent(overcharge_talent)
						 or {
									Talent(overcharge_talent)
								and Maelstrom() > 60
							}
					}
			}

			AddFunction Filler_Flametongue_Use
			{
					not SpellCooldown(flametongue)
				and not BuffPresent(flametongue_buff)
			}

			AddFunction Filler_Flametongue_Use_Refresh
			{
					not SpellCooldown(flametongue)
				and {
							not BuffPresent(flametongue_buff)
						 or InPandemicRange(flametongue_buff flametongue)
					}
			}

			AddFunction Filler_Frostbrand_Use_AkainusAbsoluteJustice
			{
					not SpellCooldown(frostbrand)
				and LegendaryEquipped(akainus_absolute_justice)
				and not BuffPresent(frostbrand_buff)
				and Maelstrom() >= 75
			}

			AddFunction Filler_Frostbrand_Use_Hailstorm
			{
					not SpellCooldown(frostbrand)
				and Talent(hailstorm_talent)
				and {
							not BuffPresent(frostbrand_buff)
						 or InPandemicRange(frostbrand_buff frostbrand)
					}
				and Maelstrom() > 40
			}

			AddFunction Filler_LavaLash_Use
			{
					not SpellCooldown(lava_lash)
				and Maelstrom() >= 50
				and {
							not Talent(overcharge_talent)
						 or {
									Talent(overcharge_talent)
								and Maelstrom() > 70
							}
					}
				and {
							not Talent(fury_of_air_talent)
						 or {
									Talent(fury_of_air_talent)
								and Maelstrom() > 80
							}
					}
			}

			AddFunction Filler_Rockbitter_Use
			{
					SpellCharges(rockbiter) >= 1
			}

			AddFunction Filler_Rockbitter_Use_Maelstrom_High
			{
					SpellCharges(rockbiter) >= 1
				and Maelstrom() < 120
			}

			AddFunction Filler_Rockbitter_Use_Maelstrom_Low
			{
					SpellCharges(rockbiter) >= 1
				and Maelstrom() <= 40
			}

			AddFunction Filler_Sundering_Use
			{
					Talent(sundering_talent)
				and not SpellCooldown(sundering)
				and Maelstrom() >= 20
			}

			###
			### Filler Rotation
			###
			AddFunction Rotation_Filler
			{
				if Filler_Rockbitter_Use_Maelstrom_High() Spell(rockbiter)
				if Filler_Flametongue_Use_Refresh() Spell(flametongue)
				if Filler_Rockbitter_Use_Maelstrom_Low() Spell(rockbiter)
				if CheckBoxOn(opt_crash_lightning) and Filler_CrashLighting_Use_EarthenSpike() Spell(crash_lightning)
				if Filler_Frostbrand_Use_Hailstorm() Spell(frostbrand)
				if Filler_Frostbrand_Use_AkainusAbsoluteJustice() Spell(frostbrand)
				if CheckBoxOn(opt_sundering) and Filler_Sundering_Use() Spell(sundering)
				if Filler_LavaLash_Use() Spell(lava_lash)
				if Filler_Rockbitter_Use() Spell(rockbiter)
				if CheckBoxOn(opt_crash_lightning) and Filler_CrashLighting_Use() Spell(crash_lightning)
				if Filler_Flametongue_Use() Spell(flametongue)
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_Rockbiter_Use
			{
					not SpellCooldown(rockbiter)
				and Maelstrom() < 10
				and TimeInCombat() < 2
			}

			AddFunction Main_Windstrike_Use
			{
					not SpellCooldown(windstrike)
				and {
							LegendaryEquipped(smoldering_heart)
						 or ArmorSetBonus(T19 2)
					}
				and {
							not Talent(earthen_spike_talent)
						 or {
									SpellCooldown(earthen_spike) > 1
								and {
											not SpellKnown(doom_winds)
										 or SpellCooldown(doom_winds) > 1
									}
							}
						 or target.DebuffPresent(earthen_spike)
					}
				and {
							{
									BuffPresent(stormbringer_buff)
								and Maelstrom() >= 20
							}
						 or Maelstrom() >= 40
					}
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				if Main_Rockbiter_Use() Spell(rockbiter)
				if Main_Windstrike_Use() Spell(windstrike)

				# Use any appropriate Buffs
				Rotation_Buffs()
				
				# Use any appropriate Cooldowns
				Rotation_Cooldowns()

				# Perform the core rotation
				Rotation_Core()

				# Perform any fillers when nothing else to do
				Rotation_Filler()
			}

			AddFunction Precombat
			{
			}

			###
			### CD Icon Rotations - Functions
			###
			AddFunction CD_Berserking_Use
			{
					Race(Troll)
				and not SpellCooldown(berserking)
				and {
							BuffPresent(ascendance_enhancement_buff)
						 or TimeSincePreviousSpell(feral_spirit) < 10
						 or not SpellKnown(doom_winds)
					}
			}

			AddFunction CD_BloodFury_Use
			{
					Race(Orc)
				and not SpellCooldown(blood_fury_sp)
				and {
							BuffPresent(ascendance_enhancement_buff)
						 or TimeSincePreviousSpell(feral_spirit) < 10
						 or not SpellKnown(doom_winds)
					}
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and {
									BuffPresent(ascendance_enhancement_buff)
								 or {
											not Talent(ascendance_talent)
										and TimeSincePreviousSpell(feral_spirit) < 10
									}
							}
					}
				 or target.HealthPercent() <= 25
				 or target.TimeToDie() <= 60
			}

			###
			### CD Icon Rotations
			###
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# CD Actions
				if not CheckBoxOn(opt_feral_spirit) and Cooldowns_FeralSpirit_Use() Spell(feral_spirit)
				if not CheckBoxOn(opt_ascendance) and Cooldowns_Ascendance_Use() Spell(ascendance_enhancement)

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_prolonged_power)

				# Stardard Actions
				if CD_BloodFury_Use() Spell(blood_fury_ap)
				if CD_Berserking_Use() Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) Spell(arcane_torrent_mana)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_prolonged_power)
			}

			###
			### Rotation icons.
			###
			AddIcon help=shortcd
			{
				if not InCombat() ShortCD_Precombat()
				ShortCD()
			}

			AddIcon checkbox=opt_single_target enemies=1 help=main
			{
				if not InCombat() Precombat()
				Main()
			}

			AddIcon help=aoe
			{
				if not InCombat() Precombat()
				Main()
			}

			AddIcon help=cd
			{
				if not InCombat() CD_Precombat()
				CD()
			}
		]];

		OvaleScripts:RegisterScript("SHAMAN", "enhancement", name, desc, code, "script");
	end
end