local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_shaman_elemental";
		local desc = "LunaEclipse: Elemental Shaman";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.SHAMAN_ELEMENTAL,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Stormy,  Sadozai, and Gistwiki",
			GuideLink = "http://www.icy-veins.com/wow/elemental-shaman-pve-dps-guide",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Ascendence"] = "3002331",
			["Ice Fury"] = "3002333",
			["Lightning Rod"] = "3002332",
			["Dungeons / Mythic+"] = "3002313",
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
					OPT_EARTHQUAKE = {
						type = "toggle",
						name = BINDING_NAME_OPT_EARTHQUAKE,
						desc = functionsConfiguration:getAOETooltip("Earthquake"),
						arg = "OPT_EARTHQUAKE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_LIQUID_MAGMA_TOTEM = {
						type = "toggle",
						name = BINDING_NAME_OPT_LIQUID_MAGMA_TOTEM,
						desc = functionsConfiguration:getAOETooltip("Liquid Magma Totem"),
						arg = "OPT_LIQUID_MAGMA_TOTEM",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
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
					OPT_ASCENDANCE = {
						type = "toggle",
						name = BINDING_NAME_OPT_ASCENDANCE,
						desc = functionsConfiguration:getCooldownTooltip("Ascendance", "CD"),
						arg = "OPT_ASCENDANCE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_ASCOPT_ELEMENTAL_BLASTENDANCE = {
						type = "toggle",
						name = BINDING_NAME_OPT_ELEMENTAL_BLAST,
						desc = functionsConfiguration:getCooldownTooltip("Elemental Blast"),
						arg = "OPT_ELEMENTAL_BLAST",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_ELEMENTAL_MASTERY = {
						type = "toggle",
						name = BINDING_NAME_OPT_ELEMENTAL_MASTERY,
						desc = functionsConfiguration:getCooldownTooltip("Elemental Mastery", "CD"),
						arg = "OPT_ELEMENTAL_MASTERY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_GNAWED_THUMB_RING = {
						type = "toggle",
						name = BINDING_NAME_OPT_GNAWED_THUMB_RING,
						desc = functionsConfiguration:getCooldownTooltip("Gnawed Thumb Ring", "CD"),
						arg = "OPT_GNAWED_THUMB_RING",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 40,
					},
					OPT_ICEFURY = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICEFURY,
						desc = functionsConfiguration:getCooldownTooltip("Icefury"),
						arg = "OPT_ICEFURY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_STORMKEEPER = {
						type = "toggle",
						name = BINDING_NAME_OPT_STORMKEEPER,
						desc = functionsConfiguration:getCooldownTooltip("Stormkeeper"),
						arg = "OPT_STORMKEEPER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_SUMMON_ELEMENTAL = {
						type = "toggle",
						name = BINDING_NAME_OPT_SUMMON_ELEMENTAL,
						desc = functionsConfiguration:getCooldownTooltip("Summon Fire Elemental and Summon Storm Elemental", "CD"),
						arg = "OPT_SUMMON_ELEMENTAL",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 70,
					},
					OPT_TOTEM_MASTERY = {
						type = "toggle",
						name = BINDING_NAME_OPT_TOTEM_MASTERY,
						desc = functionsConfiguration:getCooldownTooltip("Totem Mastery"),
						arg = "OPT_TOTEM_MASTERY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
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
			Define(totem_mastery_talent 3)
			Define(gust_of_wind_talent 4)
			Define(ancestral_guidance_talent 5)
			Define(wind_rush_totem_talent 6)
			Define(lightning_surge_totem_talent 7)
			Define(earthgrab_totem_talent 8)
			Define(voodoo_totem_talent 9)
			Define(aftershock_talent 10)
			Define(elemental_mastery_talent 12)
			Define(elemental_blast_talent 15)
			Define(liquid_magma_totem_talent 16)
			Define(storm_elemental_talent 17)
			Define(ascendance_talent 19)
			Define(lightning_rod_talent 20)
			Define(icefury_talent 21)

			# Spells
			Define(astral_shift 108271)
				SpellInfo(astral_shift cd=90 gcd=0)
				SpellAddBuff(astral_shift astral_shift_buff=1)				

			# Buffs
			Define(astral_shift_buff 108271)
				SpellInfo(astral_shift_buff duration=8)

			# Artifact
			Define(swelling_maelstrom_trait 238105)

			# Legendaries
			Define(echoes_of_the_great_sundering 137074)
			Define(smoldering_heart 151819)
			Define(the_deceivers_blood_pact 137035)

			# Legendaries Buffs
			Define(echoes_of_the_great_sundering_buff 208722)
				SpellRequire(earthquake Maelstrom 0=buff,echoes_of_the_great_sundering_buff)

			# Checkboxes
			AddCheckBox(opt_earthquake "AOE: Earthquake" default)
			AddCheckBox(opt_liquid_magma_totem "AOE CD: Liquid Magma Totem" default)			
			AddCheckBox(opt_ascendance "Cooldown: Ascendance" default)
			AddCheckBox(opt_elemental_blast "Cooldown: Elemental Blast" default)
			AddCheckBox(opt_elemental_mastery "Cooldown: Elemental Mastery" default)
			AddCheckBox(opt_gnawed_thumb_ring "Cooldown: Gnawed Thumb Ring" default)
			AddCheckBox(opt_icefury "Cooldown: Icefury" default)
			AddCheckBox(opt_stormkeeper "Cooldown: Stormkeeper" default)
			AddCheckBox(opt_summon_elemental "Cooldown: Summon Elemental" default)
			AddCheckBox(opt_totem_mastery "Cooldown: Totem Mastery" default)
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

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# ShortCD Actions
				if not CheckBoxOn(opt_totem_mastery) and Main_TotemMastery_Use() Spell(totem_mastery)

				# AOE ShortCD Spells
				if Rotation_AOE_Use()
				{
					if not CheckBoxOn(opt_stormkeeper) and AOE_StormKeeper_Use() Spell(stormkeeper)
					if not CheckBoxOn(opt_liquid_magma_totem) and AOE_LiquidMagmaTotem_Use() Spell(liquid_magma_totem)
					if not CheckBoxOn(opt_earthquake) and AOE_Earthquake_Use() Spell(earthquake)
					if not CheckBoxOn(opt_elemental_blast) and AOE_ElementalBlast_Use() Spell(elemental_blast)
				}
				
				# Ascendance Cooldown Spells.
				if Rotation_Ascendance_Use()
				{
					if not CheckBoxOn(opt_elemental_blast) and Ascendance_ElementalBlast_Use() Spell(elemental_blast)
					if not CheckBoxOn(opt_earthquake) and Ascendance_Earthquake_Use() Spell(earthquake)
					if not CheckBoxOn(opt_stormkeeper) and Ascendance_StormKeeper_Use() Spell(stormkeeper)
					if not CheckBoxOn(opt_totem_mastery) and Ascendance_TotemMastery_Use() Spell(totem_mastery)
				}

				# Ice Fury ShortCD Spells.
				if Rotation_Icefury_Use()
				{
					if not CheckBoxOn(opt_earthquake) and Icefury_Earthquake_Use_EchoesOfSundering() Spell(earthquake)
					if not CheckBoxOn(opt_elemental_blast) and Icefury_ElementalBlast_Use() Spell(elemental_blast)
					if not CheckBoxOn(opt_stormkeeper) and Icefury_StormKeeper_Use() Spell(stormkeeper)
					if not CheckBoxOn(opt_icefury) and Icefury_Icefury_Use() Spell(icefury)
					if not CheckBoxOn(opt_totem_mastery) and Icefury_TotemMastery_Use() Spell(totem_mastery)
					if not CheckBoxOn(opt_earthquake) and Icefury_Earthquake_Use() Spell(earthquake)
				}

				# Lightning Rod/Default ShortCD Spells.
				if Rotation_LightningRod_Use()
				{
					if not CheckBoxOn(opt_elemental_blast) and LightningRod_ElementalBlast_Use() Spell(elemental_blast)
					if not CheckBoxOn(opt_earthquake) and LightningRod_Earthquake_Use() Spell(earthquake)
					if not CheckBoxOn(opt_stormkeeper) and LightningRod_StormKeeper_Use() Spell(stormkeeper)
					if not CheckBoxOn(opt_totem_mastery) and LightningRod_TotemMastery_Use() Spell(totem_mastery)				
				}

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_astral_shift) and ShortCD_AstralShift_Use() Spell(astral_shift)
			}

			AddFunction ShortCD_Precombat
			{
			}

			###
			### AOE Rotation - Functions
			###
			AddFunction AOE_Ascendance_Use
			{
					Talent(ascendance_talent)
				and not SpellCooldown(ascendance_elemental)
			}

			AddFunction AOE_ChainLighting_Use
			{
					not SpellCooldown(chain_lightning)
				and not BuffPresent(ascendance_elemental_buff)
			}

			AddFunction AOE_ChainLighting_Use_LightningRod
			{
					not SpellCooldown(chain_lightning)
				and not BuffPresent(ascendance_elemental_buff)
				and Talent(lightning_rod_talent)
				and not target.DebuffPresent(lightning_rod_debuff)
			}

			AddFunction AOE_Earthquake_Use
			{
					not SpellCooldown(earthquake)
				and {
							BuffPresent(echoes_of_the_great_sundering_buff)
						 or Maelstrom() >= 50
					}
			}

			AddFunction AOE_ElementalBlast_Use
			{
					Talent(elemental_blast_talent)
				and not SpellCooldown(elemental_blast)
				and {
							{
									not Talent(lightning_rod_talent)
								and Enemies() < 5
							}
						 or {
									Talent(lightning_rod_talent)
								and Enemies() < 4
							}
					}
			}

			AddFunction AOE_FlameShock_Use
			{
					not SpellCooldown(flame_shock)
				and Enemies() < 4
				and Maelstrom() >= 20
				and target.InPandemicRange(flame_shock_debuff flame_shock)
			}

			AddFunction AOE_FlameShock_Use_Moving
			{
					not SpellCooldown(flame_shock)
				and Speed() > 0
				and target.InPandemicRange(flame_shock_debuff flame_shock)
			}

			AddFunction AOE_LavaBeam_Use
			{
					not SpellCooldown(lava_beam)
				and BuffPresent(ascendance_elemental_buff)
			}

			AddFunction AOE_LavaBurst_Use
			{
					SpellCharges(lava_burst) >= 1
				and target.DebuffRemaining(flame_shock_debuff) > CastTime(lava_burst)
				and BuffPresent(lava_surge_buff)
				and not Talent(lightning_rod_talent)
				and Enemies() < 4
				and Mana() >= ManaCost(lava_burst)
			}

			AddFunction AOE_LavaBurst_Use_Moving
			{
					SpellCharges(lava_burst) >= 1
				and Speed() > 0
				and Mana() >= ManaCost(lava_burst)
			}

			AddFunction AOE_LiquidMagmaTotem_Use
			{
					Talent(liquid_magma_totem_talent)
				and not SpellCooldown(liquid_magma_totem)
			}

			AddFunction AOE_StormKeeper_Use
			{
					SpellKnown(stormkeeper)
				and not SpellCooldown(stormkeeper)
			}

			###
			### AOE Rotation - Usage
			###
			AddFunction Rotation_AOE_Use
			{
					Enemies() > 2
			}

			###
			### AOE Rotation
			###
			AddFunction Rotation_AOE
			{
				if CheckBoxOn(opt_stormkeeper) and AOE_StormKeeper_Use() Spell(stormkeeper)
				if CheckBoxOn(opt_ascendance) and AOE_Ascendance_Use() Spell(ascendance_elemental)
				if CheckBoxOn(opt_liquid_magma_totem) and AOE_LiquidMagmaTotem_Use() Spell(liquid_magma_totem)
				if AOE_FlameShock_Use() Spell(flame_shock)
				if CheckBoxOn(opt_earthquake) and AOE_Earthquake_Use() Spell(earthquake)
				if AOE_LavaBurst_Use() Spell(lava_burst)
				if CheckBoxOn(opt_elemental_blast) and AOE_ElementalBlast_Use() Spell(elemental_blast)
				if AOE_LavaBeam_Use() Spell(lava_beam)
				if AOE_ChainLighting_Use_LightningRod() Spell(chain_lightning)
				if AOE_ChainLighting_Use() Spell(chain_lightning)
				if AOE_LavaBurst_Use_Moving() Spell(lava_burst)
				if AOE_FlameShock_Use_Moving() Spell(flame_shock)
			}

			###
			### Ascendance Rotation - Functions
			###
			AddFunction Ascendance_Ascendance_Use
			{
					Talent(ascendance_talent)
				and not SpellCooldown(ascendance_elemental)
				and {
							target.DebuffRemaining(flame_shock_debuff) > BaseDuration(ascendance_elemental_buff)
						and {
									TimeInCombat() >= 60
								 or BloodlustActive()
							}
						and SpellCooldown(lava_burst)
						and not BuffPresent(stormkeeper_buff)
					}
			}

			AddFunction Ascendance_ChainLighting_Use
			{
					not SpellCooldown(chain_lightning)
				and not BuffPresent(ascendance_elemental_buff)
				and Enemies() > 1
			}

			AddFunction Ascendance_EarthShock_Use
			{
					not SpellCooldown(earth_shock)
				and {
							Maelstrom() >= 111
						 or {
									not HasArtifactTrait(swelling_maelstrom_trait)
								and Maelstrom() >= 86
							}
						 or {
									LegendaryEquipped(smoldering_heart)
								and LegendaryEquipped(the_deceivers_blood_pact)
								and Maelstrom() > 70
								and Talent(aftershock_talent)
							}
					}
			}

			AddFunction Ascendance_EarthShock_Use_Maelstrom
			{
					not SpellCooldown(earth_shock)
				and {
							Maelstrom() >= 117
						 or {
									not HasArtifactTrait(swelling_maelstrom_trait)
								and Maelstrom() >= 92
							}
					}
			}

			AddFunction Ascendance_EarthShock_Use_Moving
			{
					not SpellCooldown(earth_shock)
				and Speed() > 0
				and Maelstrom() >= 10
			}

			AddFunction Ascendance_Earthquake_Use
			{
					not SpellCooldown(earthquake)
				and BuffPresent(echoes_of_the_great_sundering_buff)
				and not BuffPresent(ascendance_elemental_buff)
				and Maelstrom() >= 86
			}

			AddFunction Ascendance_ElementalBlast_Use
			{
					Talent(elemental_blast_talent)
				and not SpellCooldown(elemental_blast)
			}

			AddFunction Ascendance_FlameShock_Use
			{
					not SpellCooldown(flame_shock)
				and Maelstrom() >= 20
				and BuffPresent(elemental_focus_buff)
				and target.InPandemicRange(flame_shock_debuff flame_shock)
			}

			AddFunction Ascendance_FlameShock_Use_Ascendance

			{
					not SpellCooldown(flame_shock)
				and Maelstrom() >= 20
				and target.DebuffRemaining(flame_shock_debuff) <= BaseDuration(ascendance_elemental_buff)
				and SpellCooldown(ascendance_elemental) + BaseDuration(ascendance_elemental_buff) <= BaseDuration(flame_shock_debuff)
			}

			AddFunction Ascendance_FlameShock_Use_Expiring
			{
					not SpellCooldown(flame_shock)
				and {
							not target.DebuffPresent(flame_shock_debuff)
						 or target.DebuffRemaining(flame_shock_debuff) <= GCD()
					}
			}

			AddFunction Ascendance_FlameShock_Use_Moving
			{
					not SpellCooldown(flame_shock)
				and Speed() > 0
				and target.InPandemicRange(flame_shock_debuff flame_shock)
			}

			AddFunction Ascendance_LavaBeam_Use
			{
					not SpellCooldown(lava_beam)
				and BuffPresent(ascendance_elemental_buff)
				and Enemies() > 1
			}

			AddFunction Ascendance_LavaBurst_Use
			{
					SpellCharges(lava_burst) >= 1
				and target.DebuffRemaining(flame_shock_debuff) > CastTime(lava_burst)
				and {
							BuffPresent(lava_surge_buff)
						 or SpellCharges(lava_burst) == 2
						 or BuffPresent(ascendance_elemental_buff)
					}
				and Mana() >= ManaCost(lava_burst)
			}

			AddFunction Ascendance_LightningBolt_Use
			{
					not SpellCooldown(lightning_bolt_elemental)
			}
			
			AddFunction Ascendance_LightningBolt_Use_PowerOfTheMaelstrom
			{
					not SpellCooldown(lightning_bolt_elemental)
				and BuffPresent(power_of_the_maelstrom_buff)
				and Enemies() < 3
			}
			
			AddFunction Ascendance_LightningBolt_Use_Stormkeeper
			{
					not SpellCooldown(lightning_bolt_elemental)
				and BuffPresent(power_of_the_maelstrom_buff)
				and BuffPresent(stormkeeper_buff)
				and Enemies() < 3
			}
			
			AddFunction Ascendance_StormKeeper_Use
			{
					SpellKnown(stormkeeper)
				and not SpellCooldown(stormkeeper)
			}

			AddFunction Ascendance_TotemMastery_Use
			{
					Talent(totem_mastery_talent)
				and not SpellCooldown(totem_mastery)
				and TotemsBuff()
				and {
							TotemsTimeRemaining() < 10
						 or {
									TotemsTimeRemaining() < BaseDuration(ascendance_elemental_buff) + SpellCooldown(ascendance_elemental)
								and SpellCooldown(ascendance_elemental) < 15
							}
					}
			}

			###
			### Ascendance Rotation - Usage
			###
			AddFunction Rotation_Ascendance_Use
			{
					Enemies() <= 2
				and Talent(ascendance_talent)
			}

			###
			### Ascendance Rotation
			###
			AddFunction Rotation_Ascendance
			{
				if CheckBoxOn(opt_ascendance) and Ascendance_Ascendance_Use() Spell(ascendance_elemental)
				if Ascendance_FlameShock_Use_Expiring() Spell(flame_shock)
				if Ascendance_FlameShock_Use_Ascendance() Spell(flame_shock)
				if CheckBoxOn(opt_elemental_blast) and Ascendance_ElementalBlast_Use() Spell(elemental_blast)
				if CheckBoxOn(opt_earthquake) and Ascendance_Earthquake_Use() Spell(earthquake)
				if Ascendance_EarthShock_Use_Maelstrom() Spell(earth_shock)
				if CheckBoxOn(opt_stormkeeper) and Ascendance_StormKeeper_Use() Spell(stormkeeper)
				if Ascendance_LightningBolt_Use_Stormkeeper() Spell(lightning_bolt_elemental)
				if Ascendance_LavaBurst_Use() Spell(lava_burst)
				if Ascendance_FlameShock_Use() Spell(flame_shock)
				if Ascendance_EarthShock_Use() Spell(earth_shock)
				if CheckBoxOn(opt_totem_mastery) and Ascendance_TotemMastery_Use() Spell(totem_mastery)
				if Ascendance_LavaBeam_Use() Spell(lava_beam)
				if Ascendance_LightningBolt_Use_PowerOfTheMaelstrom() Spell(lightning_bolt_elemental)
				if Ascendance_ChainLighting_Use() Spell(chain_lightning)
				if Ascendance_LightningBolt_Use() Spell(lightning_bolt_elemental)
				if Ascendance_FlameShock_Use_Moving() Spell(flame_shock)
				if Ascendance_EarthShock_Use_Moving() Spell(earth_shock)
			}

			###
			### Icefury Rotation - Functions
			###
			AddFunction Icefury_ChainLighting_Use
			{
					not SpellCooldown(chain_lightning)
				and Enemies() > 1
			}

			AddFunction Icefury_EarthShock_Use
			{
					not SpellCooldown(earth_shock)
				and {
							Maelstrom() >= 111
						 or {
									not HasArtifactTrait(swelling_maelstrom_trait)
								and Maelstrom() >= 86
							}
						 or {
									LegendaryEquipped(smoldering_heart)
								and LegendaryEquipped(the_deceivers_blood_pact)
								and Maelstrom() > 70
								and Talent(aftershock_talent)
							}
					}
			}

			AddFunction Icefury_EarthShock_Use_Maelstrom
			{
					not SpellCooldown(earth_shock)
				and {
							Maelstrom() >= 117
						 or {
									not HasArtifactTrait(swelling_maelstrom_trait)
								and Maelstrom() >= 92
							}
					}
			}

			AddFunction Icefury_EarthShock_Use_Moving
			{
					not SpellCooldown(earth_shock)
				and Speed() > 0
				and Maelstrom() >= 10
			}

			AddFunction Icefury_Earthquake_Use
			{
					not SpellCooldown(earthquake)
				and BuffPresent(echoes_of_the_great_sundering_buff)
			}

			AddFunction Icefury_Earthquake_Use_EchoesOfSundering
			{
					not SpellCooldown(earthquake)
				and BuffPresent(echoes_of_the_great_sundering_buff)
				and Maelstrom() >= 86
			}

			AddFunction Icefury_ElementalBlast_Use
			{
					Talent(elemental_blast_talent)
				and not SpellCooldown(elemental_blast)
			}

			AddFunction Icefury_FlameShock_Use
			{
					not SpellCooldown(flame_shock)
				and Maelstrom() >= 20
				and BuffPresent(elemental_focus_buff)
				and target.InPandemicRange(flame_shock_debuff flame_shock)
			}

			AddFunction Icefury_FlameShock_Use_Expiring
			{
					not SpellCooldown(flame_shock)
				and {
							not target.DebuffPresent(flame_shock_debuff)
						 or target.DebuffRemaining(flame_shock_debuff) <= GCD()
					}
			}

			AddFunction Icefury_FlameShock_Use_Moving
			{
					not SpellCooldown(flame_shock)
				and Speed() > 0
				and target.InPandemicRange(flame_shock_debuff flame_shock)
			}

			AddFunction Icefury_FrostShock_Use
			{
					not SpellCooldown(frost_shock)
				and BuffPresent(icefury_buff)
				and {
							Maelstrom() >= 20
						 or BuffRemaining(icefury_buff) < 1.5 * SpellHaste() * BuffStacks(icefury_buff) + 1
					}
			}

			AddFunction Icefury_FrostShock_Use_Maelstrom
			{
					not SpellCooldown(frost_shock)
				and BuffPresent(icefury_buff)
				and Maelstrom() >= 111
			}

			AddFunction Icefury_FrostShock_Use_Moving
			{
					not SpellCooldown(frost_shock)
				and Speed() > 0
				and BuffPresent(icefury_buff)
			}

			AddFunction Icefury_Icefury_Use
			{
					Talent(icefury_talent)
				and not SpellCooldown(icefury)
				and not PreviousGCDSpell(icefury)
				and {
							{
									Maelstrom() <= 101
								and HasArtifactTrait(swelling_maelstrom_trait)
							}
						 or {
									not HasArtifactTrait(swelling_maelstrom_trait)
								and Maelstrom() <= 76
							}
					}
			}
			
			AddFunction Icefury_LavaBurst_Use
			{
					SpellCharges(lava_burst) >= 1
				and target.DebuffRemaining(flame_shock_debuff) > CastTime(lava_burst)
				and {
							BuffPresent(lava_surge_buff)
						 or SpellCharges(lava_burst) == 2
					}
				and Mana() >= ManaCost(lava_burst)
			}

			AddFunction Icefury_LightningBolt_Use
			{
					not SpellCooldown(lightning_bolt_elemental)
			}
			
			AddFunction Icefury_LightningBolt_Use_PowerOfTheMaelstrom
			{
					not SpellCooldown(lightning_bolt_elemental)
				and BuffPresent(power_of_the_maelstrom_buff)
				and Enemies() < 3
			}
			
			AddFunction Icefury_LightningBolt_Use_Stormkeeper
			{
					not SpellCooldown(lightning_bolt_elemental)
				and BuffPresent(power_of_the_maelstrom_buff)
				and not BuffPresent(icefury_buff)
				and BuffPresent(stormkeeper_buff)
				and Enemies() < 3
			}
			
			AddFunction Icefury_StormKeeper_Use
			{
					SpellKnown(stormkeeper)
				and not SpellCooldown(stormkeeper)
			}

			AddFunction Icefury_TotemMastery_Use
			{
					Talent(totem_mastery_talent)
				and not SpellCooldown(totem_mastery)
				and TotemsBuff()
				and TotemsTimeRemaining() < 10
			}

			###
			### Icefury Rotation - Usage
			###
			AddFunction Rotation_Icefury_Use
			{
					Enemies() <= 2
				and Talent(icefury_talent)
			}

			###
			### Icefury Rotation
			###
			AddFunction Rotation_Icefury
			{
				if Icefury_FlameShock_Use_Expiring() Spell(flame_shock)
				if CheckBoxOn(opt_earthquake) and Icefury_Earthquake_Use_EchoesOfSundering() Spell(earthquake)
				if Icefury_FrostShock_Use_Maelstrom() Spell(frost_shock)
				if CheckBoxOn(opt_elemental_blast) and Icefury_ElementalBlast_Use() Spell(elemental_blast)
				if Icefury_EarthShock_Use_Maelstrom() Spell(earth_shock)
				if CheckBoxOn(opt_stormkeeper) and Icefury_StormKeeper_Use() Spell(stormkeeper)
				if CheckBoxOn(opt_icefury) and Icefury_Icefury_Use() Spell(icefury)
				if Icefury_LightningBolt_Use_Stormkeeper() Spell(lightning_bolt_elemental)
				if Icefury_LavaBurst_Use() Spell(lava_burst)
				if Icefury_FrostShock_Use() Spell(frost_shock)
				if Icefury_FlameShock_Use() Spell(flame_shock)
				if Icefury_FrostShock_Use_Moving() Spell(frost_shock)
				if Icefury_EarthShock_Use() Spell(earth_shock)
				if CheckBoxOn(opt_totem_mastery) and Icefury_TotemMastery_Use() Spell(totem_mastery)
				if CheckBoxOn(opt_earthquake) and Icefury_Earthquake_Use() Spell(earthquake)
				if Icefury_LightningBolt_Use_PowerOfTheMaelstrom() Spell(lightning_bolt_elemental)
				if Icefury_ChainLighting_Use() Spell(chain_lightning)
				if Icefury_LightningBolt_Use() Spell(lightning_bolt_elemental)
				if Icefury_FlameShock_Use_Moving() Spell(flame_shock)
				if Icefury_EarthShock_Use_Moving() Spell(earth_shock)
			}

			###
			### Lightning Rod Rotation - Functions
			###
			AddFunction LightningRod_ChainLighting_Use
			{
					not SpellCooldown(chain_lightning)
				and Enemies() > 1
			}

			AddFunction LightningRod_ChainLighting_Use_NoLightningRod
			{
					not SpellCooldown(chain_lightning)
				and Enemies() > 1
				and Talent(lightning_rod_talent)
				and not target.DebuffPresent(lightning_rod_debuff)
			}

			AddFunction LightningRod_EarthShock_Use
			{
					not SpellCooldown(earth_shock)
				and {
							Maelstrom() >= 111
						 or {
									not HasArtifactTrait(swelling_maelstrom_trait)
								and Maelstrom() >= 86
							}
						 or {
									LegendaryEquipped(smoldering_heart)
								and LegendaryEquipped(the_deceivers_blood_pact)
								and Maelstrom() > 70
								and Talent(aftershock_talent)
							}
					}
			}

			AddFunction LightningRod_EarthShock_Use_Maelstrom
			{
					not SpellCooldown(earth_shock)
				and {
							Maelstrom() >= 117
						 or {
									not HasArtifactTrait(swelling_maelstrom_trait)
								and Maelstrom() >= 92
							}
					}
			}

			AddFunction LightningRod_EarthShock_Use_Moving
			{
					not SpellCooldown(earth_shock)
				and Speed() > 0
				and Maelstrom() >= 10
			}

			AddFunction LightningRod_Earthquake_Use
			{
					not SpellCooldown(earthquake)
				and BuffPresent(echoes_of_the_great_sundering_buff)
			}

			AddFunction LightningRod_ElementalBlast_Use
			{
					Talent(elemental_blast_talent)
				and not SpellCooldown(elemental_blast)
			}

			AddFunction LightningRod_FlameShock_Use
			{
					not SpellCooldown(flame_shock)
				and Maelstrom() >= 20
				and BuffPresent(elemental_focus_buff)
				and target.InPandemicRange(flame_shock_debuff flame_shock)
			}

			AddFunction LightningRod_FlameShock_Use_Expiring
			{
					not SpellCooldown(flame_shock)
				and {
							not target.DebuffPresent(flame_shock_debuff)
						 or target.DebuffRemaining(flame_shock_debuff) <= GCD()
					}
			}

			AddFunction LightningRod_FlameShock_Use_Moving
			{
					not SpellCooldown(flame_shock)
				and Speed() > 0
				and target.InPandemicRange(flame_shock_debuff flame_shock)
			}

			AddFunction LightningRod_LavaBurst_Use
			{
					SpellCharges(lava_burst) >= 1
				and target.DebuffRemaining(flame_shock_debuff) > CastTime(lava_burst)
				and {
							BuffPresent(lava_surge_buff)
						 or SpellCharges(lava_burst) == 2
					}
				and Mana() >= ManaCost(lava_burst)
			}

			AddFunction LightningRod_LightningBolt_Use
			{
					not SpellCooldown(lightning_bolt_elemental)
			}
			
			AddFunction LightningRod_LightningBolt_Use_NoLightningRod
			{
					not SpellCooldown(lightning_bolt_elemental)
				and Talent(lightning_rod_talent)
				and not target.DebuffPresent(lightning_rod_debuff)
			}
			
			AddFunction LightningRod_LightningBolt_Use_PowerOfTheMaelstrom
			{
					not SpellCooldown(lightning_bolt_elemental)
				and BuffPresent(power_of_the_maelstrom_buff)
				and Enemies() < 3
			}
			
			AddFunction LightningRod_LightningBolt_Use_PowerOfTheMaelstrom_NoLightningRod
			{
					not SpellCooldown(lightning_bolt_elemental)
				and BuffPresent(power_of_the_maelstrom_buff)
				and Enemies() < 3
				and Talent(lightning_rod_talent)
				and not target.DebuffPresent(lightning_rod_debuff)
			}
			
			AddFunction LightningRod_StormKeeper_Use
			{
					SpellKnown(stormkeeper)
				and not SpellCooldown(stormkeeper)
			}

			AddFunction LightningRod_TotemMastery_Use
			{
					Talent(totem_mastery_talent)
				and not SpellCooldown(totem_mastery)
				and TotemsBuff()
				and {
							TotemsTimeRemaining() < 10
						 or {
									TotemsTimeRemaining() < BaseDuration(ascendance_elemental_buff) + SpellCooldown(ascendance_elemental)
								and SpellCooldown(ascendance_elemental) < 15
							}
					}
			}

			###
			### Lightning Rod Rotation - Usage
			###
			AddFunction Rotation_LightningRod_Use
			{
					Enemies() <= 2
				and {
							Talent(lightning_rod_talent)
						 or {
									not Talent(ascendence_talent)
								and not Talent(icefury_talent)
							}
					}
			}

			###
			### Lightning Rod Rotation
			###
			AddFunction Rotation_LightningRod
			{
				if LightningRod_FlameShock_Use_Expiring() Spell(flame_shock)
				if CheckBoxOn(opt_elemental_blast) and LightningRod_ElementalBlast_Use() Spell(elemental_blast)
				if CheckBoxOn(opt_earthquake) and LightningRod_Earthquake_Use() Spell(earthquake)
				if LightningRod_EarthShock_Use_Maelstrom() Spell(earth_shock)
				if CheckBoxOn(opt_stormkeeper) and LightningRod_StormKeeper_Use() Spell(stormkeeper)
				if LightningRod_LavaBurst_Use() Spell(lava_burst)
				if LightningRod_FlameShock_Use() Spell(flame_shock)
				if LightningRod_EarthShock_Use() Spell(earth_shock)
				if CheckBoxOn(opt_totem_mastery) and LightningRod_TotemMastery_Use() Spell(totem_mastery)				
				if LightningRod_LightningBolt_Use_PowerOfTheMaelstrom_NoLightningRod() Spell(lightning_bolt_elemental)
				if LightningRod_LightningBolt_Use_PowerOfTheMaelstrom() Spell(lightning_bolt_elemental)
				if LightningRod_ChainLighting_Use_NoLightningRod() Spell(chain_lightning)
				if LightningRod_ChainLighting_Use() Spell(chain_lightning)
				if LightningRod_LightningBolt_Use_NoLightningRod() Spell(lightning_bolt_elemental)
				if LightningRod_LightningBolt_Use() Spell(lightning_bolt_elemental)
				if LightningRod_FlameShock_Use_Moving() Spell(flame_shock)
				if LightningRod_EarthShock_Use_Moving() Spell(earth_shock)
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_ElementalMastery_Use
			{
					Talent(elemental_mastery_talent)
				and not SpellCooldown(elemental_mastery)
			}

			AddFunction Main_FireElemental_Summon
			{
					not Talent(storm_elemental_talent)
				and not SpellCooldown(fire_elemental)
			}

			AddFunction Main_GnawedThumbRing_Use
			{
					LegendaryEquipped(gnawed_thumb_ring)
				and {
							{
									Talent(ascendence_talent)
								and not BuffPresent(ascendance_elemental_buff)
							}
						 or not Talent(ascendence_talent)
					}
			}

			AddFunction Main_StormElemental_Summon
			{
					Talent(storm_elemental_talent)
				and not SpellCooldown(storm_elemental)
			}

			AddFunction Main_TotemMastery_Use
			{
					Talent(totem_mastery_talent)
				and not SpellCooldown(totem_mastery)
				and {
							not TotemsBuff()
						 or TotemsTimeRemaining() < 2
					}
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				if CheckBoxOn(opt_totem_mastery) and Main_TotemMastery_Use() Spell(totem_mastery)
				if CheckBoxOn(opt_summon_elemental) and Main_FireElemental_Summon() Spell(fire_elemental)
				if CheckBoxOn(opt_summon_elemental) and Main_StormElemental_Summon() Spell(storm_elemental)
				if CheckBoxOn(opt_elemental_mastery) and Main_ElementalMastery_Use() Spell(elemental_mastery)
				if CheckBoxOn(opt_gnawed_thumb_ring) and Main_GnawedThumbRing_Use() Item(gnawed_thumb_ring)

				# Call the AOE rotation if fighting multiple enemies.
				if Rotation_AOE_Use() Rotation_AOE()

				# Call the Ascendance rotation if required.
				if Rotation_Ascendance_Use() Rotation_Ascendance()

				# Call the Ice Fury rotation if required.
				if Rotation_Icefury_Use() Rotation_Icefury()

				# Call the Lightning Rod rotation if required, default rotaion if no tier 7 talent is chosen.
				if Rotation_LightningRod_Use() Rotation_LightningRod()
			}

			AddFunction Precombat
			{
				if CheckBoxOn(opt_totem_mastery) and Main_TotemMastery_Use() Spell(totem_mastery)
				Spell(flame_shock)
			}

			###
			### CD Icon Rotations - Functions
			###
			AddFunction CD_Berserking_Use
			{
					Race(Troll)
				and not SpellCooldown(berserking)
				and {
							BuffPresent(ascendance_elemental_buff)
						 or not Talent(ascendance_talent)
					}
			}

			AddFunction CD_BloodFury_Use
			{
					Race(Orc)
				and not SpellCooldown(blood_fury_sp)
				and {
							not Talent(ascendance_talent)
						 or BuffPresent(ascendance_elemental_buff)
						 or SpellCooldown(ascendance_elemental) > 50
					}
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and SpellCooldown(fire_elemental) > 280
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
				if not CheckBoxOn(opt_summon_elemental) and Main_FireElemental_Summon() Spell(fire_elemental)
				if not CheckBoxOn(opt_summon_elemental) and Main_StormElemental_Summon() Spell(storm_elemental)
				if not CheckBoxOn(opt_elemental_mastery) and Main_ElementalMastery_Use() Spell(elemental_mastery)
				if not CheckBoxOn(opt_gnawed_thumb_ring) and Main_GnawedThumbRing_Use() Item(gnawed_thumb_ring)
				
				if Rotation_AOE_Use()
				{
					if not CheckBoxOn(opt_ascendance) and AOE_Ascendance_Use() Spell(ascendance_elemental)
				}

				if Rotation_Ascendance_Use() 
				{
					if not CheckBoxOn(opt_ascendance) and Ascendance_Ascendance_Use() Spell(ascendance_elemental)
				}

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_prolonged_power)

				# Stardard Actions
				if CD_BloodFury_Use() Spell(blood_fury_sp)
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

		OvaleScripts:RegisterScript("SHAMAN", "elemental", name, desc, code, "script");
	end
end