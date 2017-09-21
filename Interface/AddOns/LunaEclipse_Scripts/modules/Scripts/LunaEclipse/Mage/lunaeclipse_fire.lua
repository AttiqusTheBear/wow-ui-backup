local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_mage_fire";
		local desc = "LunaEclipse: Fire Mage";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.MAGE_FIRE,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Rinoa",
			GuideLink = "http://www.icy-veins.com/wow/fire-mage-pve-dps-guide",
			WoWVersion = 70200,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding"] = "1022123",
			["Dungeons / Mythic+"] = "2021112",
			["Solo / World Quests"] = "2031122",
			["Easy Mode"] = "2132121",
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
					OPT_DRAGONS_BREATH = {
						type = "toggle",
						name = BINDING_NAME_OPT_DRAGONS_BREATH,
						desc = functionsConfiguration:getAOETooltip("Dragon's Breath"),
						arg = "OPT_DRAGONS_BREATH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_FLAMESTRIKE = {
						type = "toggle",
						name = BINDING_NAME_OPT_FLAMESTRIKE,
						desc = string.format("%s\n\n%s", functionsConfiguration:getAOETooltip("Flamestrike"), "If unselected Hot Streak will always be used on Pyroblast, no matter how many enemies you are fighting."),
						arg = "OPT_FLAMESTRIKE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_LIVING_BOMB = {
						type = "toggle",
						name = BINDING_NAME_OPT_LIVING_BOMB,
						desc = functionsConfiguration:getAOETooltip("Living Bomb"),
						arg = "OPT_LIVING_BOMB",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_BLAST_WAVE = {
						type = "toggle",
						name = BINDING_NAME_OPT_BLAST_WAVE,
						desc = functionsConfiguration:getAOETooltip("Blast Wave"),
						arg = "OPT_BLAST_WAVE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_CINDERSTORM = {
						type = "toggle",
						name = BINDING_NAME_OPT_CINDERSTORM,
						desc = functionsConfiguration:getAOETooltip("Cinderstorm"),
						arg = "OPT_CINDERSTORM",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_METEOR = {
						type = "toggle",
						name = BINDING_NAME_OPT_METEOR,
						desc = functionsConfiguration:getAOETooltip("Meteor"),
						arg = "OPT_METEOR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
				},
			},
			settingsCooldowns = {
				type = "group",
				name = BINDING_HEADER_COOLDOWNS,
				inline = true,
				order = 30,
				args = {
					OPT_COMBUSTION = {
						type = "toggle",
						name = BINDING_NAME_OPT_COMBUSTION,
						desc = functionsConfiguration:getCooldownTooltip("Combustion", "CD"),
						arg = "OPT_COMBUSTION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_MIRROR_IMAGE = {
						type = "toggle",
						name = BINDING_NAME_OPT_MIRROR_IMAGE,
						desc = functionsConfiguration:getCooldownTooltip("Mirror Image", "CD"),
						arg = "OPT_MIRROR_IMAGE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_PHOENIXS_FLAMES = {
						type = "toggle",
						name = BINDING_NAME_OPT_PHOENIXS_FLAMES,
						desc = functionsConfiguration:getCooldownTooltip("Phoenix's Flames"),
						arg = "OPT_PHOENIXS_FLAMES",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_POWER_RUNE = {
						type = "toggle",
						name = BINDING_NAME_OPT_POWER_RUNE,
						desc = functionsConfiguration:getCooldownTooltip("Rune of Power"),
						arg = "OPT_POWER_RUNE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_TIME_WARP = {
						type = "toggle",
						name = BINDING_NAME_OPT_TIME_WARP,
						desc = string.format("%s\n\n%s", functionsConfiguration:getCooldownTooltip("Time Warp", "CD"), "This is only applicable when using Shard of the Exodar legendary, and will only be recommended once at least half the group has the debuff."),
						arg = "OPT_TIME_WARP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
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
						desc = functionsConfiguration:getDefensiveTooltip("Blazing Barrier"),
						arg = "OPT_ICE_BARRIER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_ICE_BLOCK = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICE_BLOCK,
						desc = functionsConfiguration:getDefensiveTooltip("Ice Block", "CD", "40%"),
						arg = "OPT_ICE_BLOCK",
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
					OPT_FLAMESTRIKE_HOT_STREAK = {
						type = "toggle",
						name = BINDING_NAME_OPT_FLAMESTRIKE_HOT_STREAK,
						desc = string.format("%s\n\n%s", functionsConfiguration:getAOETooltip("Flamestrike"), "If checked, then Ovale will only suggest Flamestrike during Hot Streak, otherwise if it is unchecked it will suggest Flamestrike during heavy AOE with or without Hot Streak.", "Which icon Flamestrike is displayed on will depend on the AOE: Flamestrike setting!"),
						arg = "OPT_FLAMESTRIKE_HOT_STREAK",
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
			AddCheckBox(opt_dragons_breath "AOE: Dragon's Breath" default)
			AddCheckBox(opt_flamestrike "AOE: Flamestrike" default)
			AddCheckBox(opt_living_bomb "AOE: Living Bomb" default)
			AddCheckBox(opt_blast_wave "AOE CD: Blast Wave" default)
			AddCheckBox(opt_cinderstorm "AOE CD: Cinderstorm" default)
			AddCheckBox(opt_meteor "AOE CD: Meteor" default)
			AddCheckBox(opt_combustion "Cooldown: Combustion" default)
			AddCheckBox(opt_mirror_image "Cooldown: Mirror Image" default)
			AddCheckBox(opt_phoenixs_flames "Cooldown: Phoenix's Flames" default)
			AddCheckBox(opt_power_rune "Cooldown: Rune of Power" default)
			AddCheckBox(opt_time_warp "Cooldown: Time Warp" default)
			AddCheckBox(opt_barrier_spells "Defensive: Barrier Spells" default)
			AddCheckBox(opt_ice_block "Defensive: Ice Block" default)
			AddCheckBox(opt_flamestrike_hot_streak "Other: Flamestrike (Hot Streak Only)")

			###
			### Dragon's Breath Range
			###
			AddFunction DragonsBreath_Range asvalue=1
			{
				if LegendaryEquipped(darcklis_dragonfire_diadem) 25
				if not LegendaryEquipped(darcklis_dragonfire_diadem) 12
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
						if target.Distance() < DragonsBreath_Range() Spell(dragons_breath)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
					}
				}
			}

			###
			### ShortCD Icon Rotations - Functions
			###
			AddFunction ShortCD_BlazingBarrier_Use
			{
					not SpellCooldown(blazing_barrier)
				and Mana() >= ManaCost(blazing_barrier)
				and not BuffPresent(blazing_barrier_buff)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Short Cooldown Spells
				if not CheckBoxOn(opt_power_rune) and Main_RuneOfPower_Use() Spell(rune_of_power)

				if Rotation_Combustion_Use()
				{
					if not CheckBoxOn(opt_blast_wave) and ActiveTalents_BlastWave_Use() Spell(blast_wave)
					if not CheckBoxOn(opt_meteor) and ActiveTalents_Meteor_Use() Spell(meteor)
					if not CheckBoxOn(opt_cinderstorm) and ActiveTalents_Cinderstorm_Use() Spell(cinderstorm)
					if not CheckBoxOn(opt_dragons_breath) and ActiveTalents_DragonsBreath_Use() Spell(dragons_breath)
					if not CheckBoxOn(opt_living_bomb) and ActiveTalents_LivingBomb_Use() Spell(living_bomb)

					if not CheckBoxOn(opt_phoenixs_flames) and Combustion_PhoenixsFlames_Use() Spell(phoenixs_flames)
					if not CheckBoxOn(opt_dragons_breath) and Combustion_DragonsBreath_Use() Spell(dragons_breath)
				}

				if Rotation_RuneOfPower_Use() 
				{
					if not CheckBoxOn(opt_flamestrike) and RuneOfPower_Flamestrike_Use() Spell(flamestrike)

					if not CheckBoxOn(opt_blast_wave) and ActiveTalents_BlastWave_Use() Spell(blast_wave)
					if not CheckBoxOn(opt_meteor) and ActiveTalents_Meteor_Use() Spell(meteor)
					if not CheckBoxOn(opt_cinderstorm) and ActiveTalents_Cinderstorm_Use() Spell(cinderstorm)
					if not CheckBoxOn(opt_dragons_breath) and ActiveTalents_DragonsBreath_Use() Spell(dragons_breath)
					if not CheckBoxOn(opt_living_bomb) and ActiveTalents_LivingBomb_Use() Spell(living_bomb)

					if not CheckBoxOn(opt_phoenixs_flames) and RuneOfPower_PhoenixsFlames_Use() Spell(phoenixs_flames)
					if not CheckBoxOn(opt_dragons_breath) and RuneOfPower_DragonsBreath_Use() Spell(dragons_breath)
					if not CheckBoxOn(opt_flamestrike) and RuneOfPower_Flamestrike_Use_AOE() Spell(flamestrike)
				}

				if Rotation_Standard_Use() 
				{
					if not CheckBoxOn(opt_flamestrike) and Standard_Flamestrike_Use() Spell(flamestrike)
					if not CheckBoxOn(opt_phoenixs_flames) and Standard_PhoenixsFlames_Use_AOE() Spell(phoenixs_flames)

					if not CheckBoxOn(opt_blast_wave) and ActiveTalents_BlastWave_Use() Spell(blast_wave)
					if not CheckBoxOn(opt_meteor) and ActiveTalents_Meteor_Use() Spell(meteor)
					if not CheckBoxOn(opt_cinderstorm) and ActiveTalents_Cinderstorm_Use() Spell(cinderstorm)
					if not CheckBoxOn(opt_dragons_breath) and ActiveTalents_DragonsBreath_Use() Spell(dragons_breath)
					if not CheckBoxOn(opt_living_bomb) and ActiveTalents_LivingBomb_Use() Spell(living_bomb)

					if not CheckBoxOn(opt_phoenixs_flames) and Standard_PhoenixsFlames_Use_PhoenixReborn() Spell(phoenixs_flames)
					if not CheckBoxOn(opt_phoenixs_flames) and Standard_PhoenixsFlames_Use() Spell(phoenixs_flames)
					if not CheckBoxOn(opt_flamestrike) and Standard_Flamestrike_Use_AOE() Spell(flamestrike)
				}

				# Display Blazing Barrier on ShortCD only if option is checked
				if CheckBoxOn(opt_barrier_spells) and ShortCD_BlazingBarrier_Use() Spell(blazing_barrier)
			}

			AddFunction ShortCD_Precombat
			{
				# Display Blazing Barrier on ShortCD only if option is checked
				if CheckBoxOn(opt_barrier_spells) and ShortCD_BlazingBarrier_Use() Spell(blazing_barrier)
			}

			###
			### Active Talents Rotation - Functions
			###
			AddFunction ActiveTalents_BlastWave_Use
			{
					Talent(blast_wave_talent)
				and not SpellCooldown(blast_wave)
				and {
							not BuffPresent(combustion_buff)
						 or {
									BuffPresent(combustion_buff)
								and SpellCharges(fire_blast) < 1
								and SpellCharges(phoenixs_flames) < 1
							}
					}
			}

			AddFunction ActiveTalents_Cinderstorm_Use
			{
					Talent(cinderstorm_talent)
				and not SpellCooldown(cinderstorm)
				and Mana() >= ManaCost(cinderstorm)
				and not MovementCheck()
				and {
							SpellCooldown(combustion) < CastTime(cinderstorm)
						and {
									RuneOfPowerBuff()												
								 or not Talent(rune_of_power_talent)
							}
						 or SpellCooldown(combustion) > 10 * SpellHaste()
						and not BuffPresent(combustion_buff)
					}
			}

			AddFunction ActiveTalents_DragonsBreath_Use
			{
					not SpellCooldown(dragons_breath)
				and Mana() >= ManaCost(dragons_breath)
				and {
							LegendaryEquipped(darcklis_dragonfire_diadem)
						 or {
									Talent(alexstraszas_fury_talent)
								and not BuffPresent(hot_streak_buff)
							}
					}
			}

			AddFunction ActiveTalents_LivingBomb_Use
			{
					Talent(living_bomb_talent)
				and not SpellCooldown(living_bomb)
				and Mana() >= ManaCost(living_bomb)
				and target.RangeCheck(living_bomb)
				and Enemies() > 1
				and not BuffPresent(combustion_buff)
			}

			AddFunction ActiveTalents_Meteor_Use
			{
					Talent(meteor_talent)
				and not SpellCooldown(meteor)
				and Mana() >= ManaCost(meteor)
				and {
							SpellCooldown(combustion) > 15
						 or SpellCooldown(combustion) > target.TimeToDie()
						 or RuneOfPowerBuff()
					}
			}

			###
			### Active Talents Rotation
			###
			AddFunction Rotation_ActiveTalents
			{
				if CheckBoxOn(opt_blast_wave) and ActiveTalents_BlastWave_Use() Spell(blast_wave)
				if CheckBoxOn(opt_meteor) and ActiveTalents_Meteor_Use() Spell(meteor)
				if CheckBoxOn(opt_cinderstorm) and ActiveTalents_Cinderstorm_Use() Spell(cinderstorm)
				if CheckBoxOn(opt_dragons_breath) and ActiveTalents_DragonsBreath_Use() Spell(dragons_breath)
				if CheckBoxOn(opt_living_bomb) and ActiveTalents_LivingBomb_Use() Spell(living_bomb)
			}

			###
			### Combustion Rotation - Functions
			###
			AddFunction Combustion_DragonsBreath_Use
			{
					
					not SpellCooldown(dragons_breath)
				and Mana() >= ManaCost(dragons_breath)
				and BuffPresent(combustion_buff)
				and not BuffPresent(hot_streak_buff)
				and SpellCharges(fire_blast) < 1
				and SpellCharges(phoenixs_flames) < 1
			}

			AddFunction Combustion_FireBlast_Use
			{
					SpellCharges(fire_blast) >= 1
				and Mana() >= ManaCost(fire_blast)
				and target.RangeCheck(fire_blast)
				and BuffPresent(combustion_buff)
				and {
							BuffPresent(heating_up_buff)
						 or PreviousGCDSpell(pyroblast)
					}			
			}

			AddFunction Combustion_PhoenixsFlames_Use
			{
					SpellKnown(phoenixs_flames)
				and SpellCharges(phoenixs_flames) >= 1
				and target.RangeCheck(phoenixs_flames)
				and BuffPresent(combustion_buff)
			}

			AddFunction Combustion_Pyroblast_Use
			{
					not SpellCooldown(pyroblast)
				and Mana() >= ManaCost(pyroblast)
				and target.RangeCheck(pyroblast)
				and BuffPresent(combustion_buff)
				and BuffPresent(hot_streak_buff)
			}

			AddFunction Combustion_Pyroblast_Use_KaelthasUltimateAbility
			{
					not SpellCooldown(pyroblast)
				and Mana() >= ManaCost(pyroblast)
				and target.RangeCheck(pyroblast)
				and {
							not MovementCheck()
						 or BuffPresent(hot_streak_buff)
					}
				and BuffPresent(kaelthass_ultimate_ability_buff)
				and BuffRemaining(combustion_buff) > ExecuteTime(pyroblast)
			}

			AddFunction Combustion_Scorch_Use
			{
					not SpellCooldown(scorch)
				and Mana() >= ManaCost(scorch)
				and target.RangeCheck(scorch)
				and BuffRemaining(combustion_buff) > CastTime(scorch)
			}

			AddFunction Combustion_Scorch_Use_KoralonsBurningTouch
			{
					not SpellCooldown(scorch)
				and Mana() >= ManaCost(scorch)
				and target.RangeCheck(scorch)
				and target.HealthPercent() <= 30
				and LegendaryEquipped(koralons_burning_touch)
			}

			###
			### Combustion Rotation - Usage
			###
			AddFunction Rotation_Combustion_Use
			{
					BuffPresent(combustion_buff)
			}

			###
			### Combustion Rotation
			###
			AddFunction Rotation_Combustion
			{
				# Call the Active Abilities rotation for CD spells
				Rotation_ActiveTalents()

				if Combustion_Pyroblast_Use_KaelthasUltimateAbility() Spell(pyroblast)
				if Combustion_Pyroblast_Use() Spell(pyroblast)
				if Combustion_FireBlast_Use() Spell(fire_blast)
				if CheckBoxOn(opt_phoenixs_flames) and Combustion_PhoenixsFlames_Use() Spell(phoenixs_flames)
				if Combustion_Scorch_Use() Spell(scorch)
				if CheckBoxOn(opt_dragons_breath) and Combustion_DragonsBreath_Use() Spell(dragons_breath)
				if Combustion_Scorch_Use_KoralonsBurningTouch() Spell(scorch)
			}

			###
			### Rune of Power Rotation - Functions
			###
			AddFunction RuneOfPower_DragonsBreath_Use
			{
					not SpellCooldown(dragons_breath)
				and Mana() >= ManaCost(dragons_breath)
				and Enemies() > 2			
			}

			AddFunction RuneOfPower_Fireball_Use
			{
					not SpellCooldown(fireball)
				and Mana() >= ManaCost(fireball)
				and target.RangeCheck(fireball)
				and not MovementCheck()
			}

			AddFunction RuneOfPower_FireBlast_Use
			{
					SpellCharges(fire_blast) >= 1
				and Mana() >= ManaCost(fire_blast)
				and target.RangeCheck(fire_blast)
				and not PreviousOffGCDSpell(fire_blast)
			}

			AddFunction RuneOfPower_Flamestrike_Use
			{
					not SpellCooldown(flamestrike)
				and Mana() >= ManaCost(flamestrike)
				and {
							{
									Talent(flame_patch_talent)
								and Enemies() > 1
							}
						 or Enemies() > 3
					}
				and BuffPresent(hot_streak_buff)
			}

			AddFunction RuneOfPower_Flamestrike_Use_AOE
			{
					not CheckBoxOn(opt_flamestrike_hot_streak) 
				and not SpellCooldown(flamestrike)
				and Mana() >= ManaCost(flamestrike)
				and {
							not MovementCheck()
						 or BuffPresent(hot_streak_buff)
					}
				and {
							{
									Talent(flame_patch_talent)
								and Enemies() > 2
							}
						 or Enemies() > 5
					}
			}

			AddFunction RuneOfPower_PhoenixsFlames_Use
			{
					SpellKnown(phoenixs_flames)
				and SpellCharges(phoenixs_flames) >= 1
				and target.RangeCheck(phoenixs_flames)
				and not PreviousGCDSpell(phoenixs_flames)
			}

			AddFunction RuneOfPower_Pyroblast_Use
			{
					not SpellCooldown(pyroblast)
				and Mana() >= ManaCost(pyroblast)
				and target.RangeCheck(pyroblast)
				and BuffPresent(hot_streak_buff)
			}

			AddFunction RuneOfPower_Pyroblast_Use_KaelthasUltimateAbility
			{
					not SpellCooldown(pyroblast)
				and Mana() >= ManaCost(pyroblast)
				and target.RangeCheck(pyroblast)
				and {
							not MovementCheck()
						 or BuffPresent(hot_streak_buff)
					}
				and BuffPresent(kaelthass_ultimate_ability_buff)
				and ExecuteTime(pyroblast) < BuffRemaining(kaelthass_ultimate_ability_buff)
			}

			AddFunction RuneOfPower_Scorch_Use
			{
					not SpellCooldown(scorch)
				and Mana() >= ManaCost(scorch)
				and target.RangeCheck(scorch)
				and target.HealthPercent() <= 30
				and LegendaryEquipped(koralons_burning_touch)
			}

			###
			### Rune of Power Rotation - Usage
			###
			AddFunction Rotation_RuneOfPower_Use
			{
					RuneOfPowerBuff()
				and not BuffPresent(combustion_buff)
			}

			###
			### Rune of Power Rotation
			###
			AddFunction Rotation_RuneOfPower
			{
				if CheckBoxOn(opt_flamestrike) and RuneOfPower_Flamestrike_Use() Spell(flamestrike)
				if RuneOfPower_Pyroblast_Use() Spell(pyroblast)

				# Call the Active Abilities rotation for CD spells
				Rotation_ActiveTalents()

				if RuneOfPower_Pyroblast_Use_KaelthasUltimateAbility() Spell(pyroblast)
				if RuneOfPower_FireBlast_Use() Spell(fire_blast)
				if CheckBoxOn(opt_phoenixs_flames) and RuneOfPower_PhoenixsFlames_Use() Spell(phoenixs_flames)
				if RuneOfPower_Scorch_Use() Spell(scorch)
				if CheckBoxOn(opt_dragons_breath) and RuneOfPower_DragonsBreath_Use() Spell(dragons_breath)
				if CheckBoxOn(opt_flamestrike) and RuneOfPower_Flamestrike_Use_AOE() Spell(flamestrike)
				if RuneOfPower_Fireball_Use() Spell(fireball)
			}

			###
			### Standard Rotation - Functions
			###
			AddFunction Standard_Fireball_Use
			{
					not SpellCooldown(fireball)
				and Mana() >= ManaCost(fireball)
				and target.RangeCheck(fireball)
				and not MovementCheck()
			}

			AddFunction Standard_FireBlast_Use
			{
					SpellCharges(fire_blast) >= 1
				and Mana() >= ManaCost(fire_blast)
				and target.RangeCheck(fire_blast)
				and {
							not Talent(kindling_talent)
						and BuffPresent(heating_up_buff)
						and {
									not Talent(rune_of_power_talent)
								 or SpellCharges(fire_blast count=0) > 1.4
								 or SpellCooldown(combustion) < 40
							}
						and { 3 - SpellCharges(fire_blast count=0) } * { 12 * SpellHaste() } <  SpellCooldown(combustion) + 3
						 or target.TimeToDie() < 4
					}
			}

			AddFunction Standard_FireBlast_Use_Kindling
			{
					SpellCharges(fire_blast) >= 1
				and Mana() >= ManaCost(fire_blast)
				and target.RangeCheck(fire_blast)
				and {
							Talent(kindling_talent)
						and BuffPresent(heating_up_buff)
						and {
									not Talent(rune_of_power_talent)
								 or SpellCharges(fire_blast count=0) > 1.5
								 or SpellCooldown(combustion) < 40
							}
						and { 3 - SpellCharges(fire_blast count=0) } * { 18 * SpellHaste() } < SpellCooldown(combustion) + 3
						 or target.TimeToDie() < 4
					}
			}

			AddFunction Standard_Flamestrike_Use
			{
					not SpellCooldown(flamestrike)
				and Mana() >= ManaCost(flamestrike)
				and {
							{
									Talent(flame_patch_talent)
								and Enemies() > 1
							}
						 or Enemies() > 3
					}
				and BuffPresent(hot_streak_buff)
			}

			AddFunction Standard_Flamestrike_Use_AOE
			{
					not CheckBoxOn(opt_flamestrike_hot_streak) 
				and not SpellCooldown(flamestrike)
				and Mana() >= ManaCost(flamestrike)
				and {
							not MovementCheck()
						 or BuffPresent(hot_streak_buff)
					}
				and {
							{
									Talent(flame_patch_talent)
								and Enemies() > 1
							}
						 or Enemies() > 5
					}
			}

			AddFunction Standard_PhoenixsFlames_Use
			{
					SpellKnown(phoenixs_flames)
				and SpellCharges(phoenixs_flames) >= 1
				and target.RangeCheck(phoenixs_flames)
				and {
							BuffPresent(combustion_buff)
						 or RuneOfPowerBuff()
					}
				and { 4 - SpellCharges(phoenixs_flames count=0) } * 30 <  SpellCooldown(combustion) + 5	
			}

			AddFunction Standard_PhoenixsFlames_Use_AOE
			{
					SpellKnown(phoenixs_flames)
				and SpellCharges(phoenixs_flames count=0) >= 2.7
				and target.RangeCheck(phoenixs_flames)
				and Enemies() > 2
			}

			AddFunction Standard_PhoenixsFlames_Use_PhoenixReborn
			{
					SpellKnown(phoenixs_flames)
				and SpellCharges(phoenixs_flames) >= 1
				and target.RangeCheck(phoenixs_flames)
				and {
							BuffPresent(combustion_buff)
						 or RuneOfPowerBuff()
						 or BuffStacks(incanters_flow_buff) > 3
						 or Talent(mirror_image_talent)
					}
				and HasArtifactTrait(phoenix_reborn)
				and { 4 - SpellCharges(phoenixs_flames count=0) } * 13 < SpellCooldown(combustion) + 5
				 or target.TimeToDie() < 10
			}

			AddFunction Standard_Pyroblast_Use
			{
					not SpellCooldown(pyroblast)
				and Mana() >= ManaCost(pyroblast)
				and target.RangeCheck(pyroblast)
				and BuffPresent(hot_streak_buff)
				and not PreviousGCDSpell(pyroblast)
			}

			AddFunction Standard_Pyroblast_Use_HotStreak_Expiring
			{
					not SpellCooldown(pyroblast)
				and Mana() >= ManaCost(pyroblast)
				and target.RangeCheck(pyroblast)
				and BuffPresent(hot_streak_buff)
				and BuffRemaining(hot_streak_buff) < ExecuteTime(fireball)
			}

			AddFunction Standard_Pyroblast_Use_KaelthassUltimateAbility
			{
					not SpellCooldown(pyroblast)
				and Mana() >= ManaCost(pyroblast)
				and target.RangeCheck(pyroblast)
				and {
							not MovementCheck()
						 or BuffPresent(hot_streak_buff)
					}
				and BuffPresent(kaelthass_ultimate_ability_buff)
				and ExecuteTime(pyroblast) < BuffRemaining(kaelthass_ultimate_ability_buff)				
			}

			AddFunction Standard_Pyroblast_Use_KoralonsBurningTouch
			{
					not SpellCooldown(pyroblast)
				and Mana() >= ManaCost(pyroblast)
				and target.RangeCheck(pyroblast)
				and BuffPresent(hot_streak_buff)
				and target.HealthPercent() <= 30
				and LegendaryEquipped(koralons_burning_touch)
			}

			AddFunction Standard_Scorch_Use
			{
					not SpellCooldown(scorch)
				and Mana() >= ManaCost(scorch)
				and target.RangeCheck(scorch)
				and target.HealthPercent() <= 30
				and LegendaryEquipped(koralons_burning_touch)
			}

			###
			### Standard Rotation - Usage
			###
			AddFunction Rotation_Standard_Use
			{
					not BuffPresent(combustion_buff)
				and not RuneOfPowerBuff()
			}

			###
			### Standard Rotation
			###
			AddFunction Rotation_Standard
			{
				if CheckBoxOn(opt_flamestrike) and Standard_Flamestrike_Use() Spell(flamestrike)
				if Standard_Pyroblast_Use_HotStreak_Expiring() Spell(pyroblast)
				if CheckBoxOn(opt_phoenixs_flames) and Standard_PhoenixsFlames_Use_AOE() Spell(phoenixs_flames)
				if Standard_Pyroblast_Use() Spell(pyroblast)
				if Standard_Pyroblast_Use_KoralonsBurningTouch() Spell(pyroblast)
				if Standard_Pyroblast_Use_KaelthassUltimateAbility() Spell(pyroblast)

				# Call the Active Abilities rotation for CD spells
				Rotation_ActiveTalents()

				if Standard_FireBlast_Use() Spell(fire_blast)
				if Standard_FireBlast_Use_Kindling() Spell(fire_blast)
				if CheckBoxOn(opt_phoenixs_flames) and Standard_PhoenixsFlames_Use_PhoenixReborn() Spell(phoenixs_flames)
				if CheckBoxOn(opt_phoenixs_flames) and Standard_PhoenixsFlames_Use() Spell(phoenixs_flames)
				if CheckBoxOn(opt_flamestrike) and Standard_Flamestrike_Use_AOE() Spell(flamestrike)
				if Standard_Scorch_Use() Spell(scorch)
				if Standard_Fireball_Use() Spell(fireball)
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_Combustion_Use
			{
					not SpellCooldown(combustion)
				and Mana() >= ManaCost(combustion)
				and not BuffPresent(combustion_buff)
				and BuffPresent(hot_streak_buff)
			}

			AddFunction Main_MirrorImage_Use
			{
					Talent(mirror_image_talent)
				and Mana() >= ManaCost(mirror_image)
				and not SpellCooldown(mirror_image)
				and not BuffPresent(combustion_buff)
			}

			AddFunction Main_RuneOfPower_Use
			{
					Talent(rune_of_power_talent)
				and not MovementCheck()
				and not PreviousGCDSpell(rune_of_power)
				and SpellCharges(rune_of_power) >= 1
				and not RuneOfPowerBuff()
				and {
							{
									not BuffPresent(combustion_buff)
								and Main_Combustion_Use()
							}
						 or {
									SpellCooldown(combustion) > 40
								and not BuffPresent(combustion_buff)
								and not Talent(kindling_talent)
							}
						 or {
									target.IsBoss()		
								and target.TimeToDie() < 11
							}
						 or {
									Talent(kindling_talent)
								and {
											SpellCharges(rune_of_power count=0) > 1.8
										 or TimeInCombat() < 40
									}
								and SpellCooldown(combustion) > 40
							}
					}
			}

			AddFunction Main_Scorch_Use
			{
					not SpellCooldown(scorch)
				and Mana() >= ManaCost(scorch)
				and target.RangeCheck(scorch)
				and MovementCheck()
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
									SpellCooldown(combustion) < 1
								 or {
											target.IsBoss()
										and target.TimeToDie() < 50
									}
							}
					}
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				if CheckBoxOn(opt_time_warp) and Main_TimeWarp_Use() Spell(time_warp)
				if CheckBoxOn(opt_mirror_image) and Main_MirrorImage_Use() Spell(mirror_image)
				if CheckBoxOn(opt_power_rune) and Main_RuneOfPower_Use() Spell(rune_of_power)
				if CheckBoxOn(opt_combustion) and Main_Combustion_Use() Spell(combustion)
		
				# Call the Combustion rotation if combustion is active or should be cast
				if Rotation_Combustion_Use() Rotation_Combustion()
			
				# Call the Rune of Power rotation if Rune of Power is active and you are not in combustion
				if Rotation_RuneOfPower_Use() Rotation_RuneOfPower()

				# Call the Standard Rotation
				if Rotation_Standard_Use() Rotation_Standard()

				# Scorch if moving and there is nothing else that can be done
				if Main_Scorch_Use() Spell(scorch)

				# Show Forward Arrow if out of range of longest range ability
				if not target.RangeCheck(fireball) Texture(misc_arrowlup help="No Abilities in range")
			}

			AddFunction Main_Precombat
			{
				if CheckBoxOn(opt_mirror_image) and Main_MirrorImage_Use() Spell(mirror_image)
				if target.RangeCheck(pyroblast) and { not MovementCheck() or BuffPresent(hot_streak_buff) } Spell(pyroblast)
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
						and BuffPresent(combustion_buff)
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

				# Cooldown Spells
				if not CheckBoxOn(opt_time_warp) and Main_TimeWarp_Use() Spell(time_warp)
				if not CheckBoxOn(opt_mirror_image) and Main_MirrorImage_Use() Spell(mirror_image)
				if not CheckBoxOn(opt_combustion) and Main_Combustion_Use() Spell(combustion)

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_deadly_grace)

				# Display Ice Block only if option is checked
				if CheckBoxOn(opt_ice_block) and CD_IceBlock_Use() Spell(ice_block)

				# Standard Abilties
				if CD_BloodFury_Use() Spell(blood_fury_sp)
				if CD_Berserking_Use() Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_mana)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Short Cooldown Spells
				if not CheckBoxOn(opt_mirror_image) and Main_MirrorImage_Use() Spell(mirror_image)

				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_deadly_grace)
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

		OvaleScripts:RegisterScript("MAGE", "fire", name, desc, code, "script");
	end
end