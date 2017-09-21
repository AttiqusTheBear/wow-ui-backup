local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "profiler781_warrior_arms";
		local desc = "Profiler781: Arms Warrior";

		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.WARRIOR_ARMS,
			ScriptAuthor = "Profiler781",
			GuideAuthor = "Wordup",
			GuideLink = "https://www.icy-veins.com/wow/arms-warrior-pve-dps-guide",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding/Mythic+ (Single Target)"] = "1322322",
			["Raiding/Mythic+ (AOE)"] = "3312122",
			["Solo"] = "3311122",
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
					OPT_BLADESTORM = {
						type = "toggle",
						name = BINDING_NAME_OPT_BLADESTORM,
						desc = functionsConfiguration:getAOETooltip("Bladestorm"),
						arg = "OPT_BLADESTORM",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_RAVAGER = {
						type = "toggle",
						name = BINDING_NAME_OPT_RAVAGER,
						desc = functionsConfiguration:getAOETooltip("Ravager"),
						arg = "OPT_RAVAGER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_SHOCKWAVE = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHOCKWAVE,
						desc = functionsConfiguration:getAOETooltip("Shockwave"),
						arg = "OPT_SHOCKWAVE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_WARBREAKER = {
						type = "toggle",
						name = BINDING_NAME_OPT_WARBREAKER,
						desc = functionsConfiguration:getAOETooltip("Warbreaker"),
						arg = "OPT_WARBREAKER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
				},
			},
			settingsBuff = {
				type = "group",
				name = BINDING_HEADER_BUFFS_DEBUFFS,
				inline = true,
				order = 20,
				args = {
					OPT_WARBREAKER_DEBUFF = {
						type = "toggle",
						name = BINDING_NAME_OPT_WARBREAKER_DEBUFF,
						desc = functionsConfiguration:getDebuffTooltip("Warbreaker", "Colossus Smash"),
						arg = "OPT_WARBREAKER_DEBUFF",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_WEIGHT_OF_THE_EARTH_DEBUFF = {
						type = "toggle",
						name = BINDING_NAME_OPT_WEIGHT_OF_THE_EARTH_DEBUFF,
						desc = string.format("%s\n\n%s", functionsConfiguration:getDebuffTooltip("Heroic Leap", "Colossus Smash"), "This only applies if you are wearing the Weight of the Earth legendary!"),
						arg = "OPT_WEIGHT_OF_THE_EARTH_DEBUFF",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
					OPT_HEROIC_THROW = {
						type = "toggle",
						name = BINDING_NAME_OPT_HEROIC_THROW,
						desc = functionsConfiguration:getDebuffTooltip("Heroic Throw"),
						arg = "OPT_HEROIC_THROW",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
				},
			},
			settingsDefensive = {
				type = "group",
				name = BINDING_HEADER_DEFENSIVE,
				inline = true,
				order = 40,
				args = {
					OPT_VICTORY_RUSH_HEAL = {
						type = "toggle",
						name = BINDING_NAME_OPT_VICTORY_RUSH_HEAL,
						desc = functionsConfiguration:getDefensiveTooltip("Victory Rush", "Short Cooldown", "70%", "Victorious"),
						arg = "OPT_VICTORY_RUSH_HEAL",
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
					OPT_MORTAL_STRIKE_DELAY = {
						type = "toggle",
						name = BINDING_NAME_OPT_MORTAL_STRIKE_DELAY,
						desc = "Delay suggesting Mortal Strike until Battle Cry is active.\n\nIf this is unchecked it will suggest Mortal Strike when all other requirements are met!",
						arg = "OPT_MORTAL_STRIKE_DELAY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 10,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		-- This custom script has this because there is no default script provided by the package.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			# Arms Warrior rotation functions based on Guide written by Archimtiros: http://www.icy-veins.com/wow/arms-warrior-pve-dps-guide

			Include(lunaeclipse_warrior_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_bladestorm "AOE CD: Bladestorm" default)
			AddCheckBox(opt_ravager "AOE CD: Ravager" default)
			AddCheckBox(opt_shockwave "AOE CD: Shockwave")
			AddCheckBox(opt_warbreaker "AOE CD: Warbreaker" default)
			AddCheckBox(opt_warbreaker_debuff "Debuff: Warbreaker" default)
			AddCheckBox(opt_weight_of_the_earth_debuff "Debuff: Weight Of The Earth" default)
			AddCheckBox(opt_mortal_strike_delay "Delay: Mortal Strike for Battle Cry")
			AddCheckBox(opt_heroic_throw "Display: Heroic Throw" default)
			AddCheckBox(opt_victory_rush_heal "Heal: Victory Rush" default)
			AddCheckBox(opt_range_check "Display: Range Check")

			###
			### Artifact Functions
			###
			AddFunction Warbreaker_Available
			{
					SpellKnown(warbreaker)
				and not SpellCooldown(warbreaker)
				and {
							target.Distance() <= 8
						 or CheckBoxOff(opt_range_check)
					}
			}

			AddFunction Warbreaker_Use_Debuff
			{
					Warbreaker_Available()
				and not BuffPresent(shattered_defenses_buff)
				and not target.DebuffPresent(colossus_smash_debuff)
				and SpellCooldown(colossus_smash) >= GCD()
				and SpellCooldown(battle_cry) <= GCD()
			}

			AddFunction Warbreaker_Use
			{
					Warbreaker_Available()
				and SpellCooldown(bladestorm) < GCD()
				and Enemies() > 3
			}

			###
			### Avatar Functions
			###
			AddFunction Avatar_Use
			{
					not SpellCooldown(avatar)
				and Talent(avatar_talent)
				and target.DebuffRemaining(colossus_smash_debuff) >= BaseDuration(battle_cry_buff)
				and not BuffPresent(avatar_buff)
				and {
							not SpellCooldown(battle_cry)
						 or BuffPresent(battle_cry_buff)
						 or isRooted()
					}
			}

			###
			### Battle Cry Functions
			###
			AddFunction BattleCry_Use
			{
					not SpellCooldown(battle_cry)
				and not BuffPresent(battle_cry_buff)
				and target.DebuffRemaining(colossus_smash_debuff) >= BaseDuration(battle_cry_buff)
				and {
							not SpellCooldown(mortal_strike)
						 or not CheckBoxOn(opt_mortal_strike_delay)
						 or Talent(fervor_of_battle_talent)
					}
				and {
							not Talent(rend_talent)
						 or target.DebuffRemaining(rend_debuff) >= BaseDuration(battle_cry_buff)
					}
			}

			###
			### Bladestorm Functions
			###
			AddFunction Bladestorm_Use
			{
					not SpellCooldown(bladestorm)
				and {
							target.Distance() <= 8
						 or CheckBoxOff(opt_range_check)
					}
				and target.DebuffPresent(colossus_smash_debuff)
				and BuffPresent(battle_cry_buff)
				and {
							Enemies() > 3
						 or ArmorSetBonus(T20 4) == 1
					}
			}

			###
			### Charge Functions
			###
			AddFunction Charge_Use
			{
					not SpellCooldown(charge)
				and target.RangeCheck(charge)
			}

			###
			### Cleave Functions
			###
			AddFunction Cleave_Use
			{
					not SpellCooldown(cleave)
				and {
							Enemies() > 2
						 or {
						 			Enemies() > 1
						 		and not Talent(sweeping_strikes_talent)
							}
					}
			}

			###
			### Colossus Smash Functions
			###
			AddFunction ColossusSmash_Use
			{
					not SpellCooldown(colossus_smash)
				and not BuffPresent(shattered_defenses_buff)
			}

			###
			### Execute Functions
			###
			AddFunction Execute_Use
			{
					not SpellCooldown(execute_arms)
				and target.HealthPercent() < 20
			}

			AddFunction Execute_Use_Ayala
			{
					not SpellCooldown(execute_arms)
				and BuffPresent(stone_heart_buff)
			}

			###
			### Focused Rage Functions
			###
			AddFunction FocusedRage_Use_BattleCry
			{
					not SpellCooldown(focused_rage)
				and BuffPresent(battle_cry_buff)
				and Talent(deadly_calm_talent)
			}

			AddFunction FocusedRage_Use_ColossusSmash_Clip
			{
					not SpellCooldown(focused_rage)
				and target.HealthPercent() > 20
				and BuffStacks(focused_rage_buff) < 3
				and SpellCooldown(colossus_smash) < GCD()
			}

			AddFunction FocusedRage_Use_DumpRage
			{
					not SpellCooldown(focused_rage)
				and target.HealthPercent() > 20
				and RageDeficit() < 25
			}

			AddFunction FocusedRage_Use_Precombat
			{
					not SpellCooldown(focused_rage)
				and BuffStacks(focused_rage_buff) < 3
				and target.IsRaidBoss()
			}

			AddFunction FocusedRage_Use_BattleCry_Prepare
			{
					not SpellCooldown(focused_rage)
				and target.HealthPercent() > 20
				and BuffStacks(focused_rage_buff) < 3
				and {
						{
								SpellCooldown(battle_cry) < (2 - BuffStacks(focused_rage_buff)) * (SpellCooldownDuration(focused_rage) + RageCost(focused_rage) / 10)
							and Talent(focused_rage_talent)
						} or {
								SpellCooldown(battle_cry) < (2 - BuffStacks(focused_rage_buff)) * SpellCooldownDuration(focused_rage)
							and not Talent(focused_rage_talent)
						}
					}
			}

			###
			### Heroic Leap Functions
			###
			AddFunction HeroicLeap_Use
			{
					not SpellCooldown(heroic_leap)
				and target.Distance() >= 8
				and SpellCooldownDuration(charge) > SpellCooldown(charge) + 1
			}

			AddFunction HeroicLeap_Use_WeightOfTheEarth
			{
					not SpellCooldown(heroic_leap)
				and LegendaryEquipped(weight_of_the_earth)
				and not target.DebuffPresent(colossus_smash_debuff)
				and SpellCooldownDuration(charge) > SpellCooldown(charge) + 1
			}

			###
			### Heroic Throw Functions
			###
			AddFunction HeroicThrow_Use
			{
					not SpellCooldown(heroic_throw)
				and target.RangeCheck(heroic_throw)
				and SpellCooldownDuration(charge) > SpellCooldown(charge) + 1
			}

			###
			### Mortal Strike Functions
			###
			AddFunction MortalStrike_Use
			{
					not SpellCooldown(mortal_strike)
				and {
							{
									target.HealthPercent() >= 20
								and {
											{
													SpellCooldown(battle_cry) > ( GCD() + RageCost(focused_rage) / 10 ) * 2
												and Talent(focused_rage_talent)
											} 
										 or not Talent(focused_rage_talent)
										 or CheckBoxOff(opt_mortal_strike_delay)
									}
							}
						 or {
					 				target.HealthPercent() < 20
					 			and {
					 						BuffStacks(focused_rage_buff) == 3
					 					 or not Talent(focused_rage_talent)
					 				}
					 		}
					}
			}

			AddFunction MortalStrike_Buffed_Use
			{
					not SpellCooldown(mortal_strike)
				and {
							target.HealthPercent() < 20
						and BuffPresent(shattered_defenses_buff)
						and BuffStacks(executioners_precision_buff) == 2
					}
			}

			###
			### Overpower Functions
			###
			AddFunction Overpower_Use
			{
					not SpellCooldown(overpower)
				and Talent(overpower_talent)
			}

			###
			### Ravager Functions
			###
			AddFunction Ravager_Use
			{
					not SpellCooldown(ravager)
				and Talent(ravager_talent)
				and BuffPresent(battle_cry_buff)
				and target.DebuffRemaining(colossus_smash_debuff) >= BaseDuration(ravager_buff)
				and {
							Enemies() > 3
						 or ArmorSetBonus(T20 4) == 1
					}
			}

			###
			### Rend Functions
			###
			AddFunction Rend_Use
			{
					not SpellCooldown(rend)
				and Talent(rend_talent)
				and not target.DebuffPresent(rend_debuff)
			}

			AddFunction Rend_Pandemic_Use
			{
					not SpellCooldown(rend)
				and Talent(rend_talent)
				and {
							target.InPandemicRange(rend_debuff rend)
						 or {
						 			SpellCooldown(battle_cry) <= GCD()
						 		and target.DebuffRemaining(rend_debuff) <= BaseDuration(battle_cry_buff)
							}
					}
			}

			###
			### Shockwave Functions
			###
			AddFunction Shockwave_Use
			{
					not SpellCooldown(shockwave)
				and Talent(shockwave_talent)
				and {
							target.Distance() <= 10
						 or CheckBoxOff(opt_range_check)
					}
				and Enemies() >= 4
			}

			###
			### Slam Functions
			###
			AddFunction Slam_Use
			{
					not SpellCooldown(slam)
				and {
							target.HealthPercent() >= 20
						and {
									BuffStacks(focused_rage_buff) == 3
								 or not Talent(focused_rage_talent)
								 or BuffPresent(battle_cry_buff)
								 or Rage() > 32
							}
					}
				and Enemies() == 1
				and not Talent(fervor_of_battle_talent)
			}

			###
			### Victory Rush Functions
			###
			AddFunction VictoryRush_Use
			{
					not SpellCooldown(victory_rush)
				and BuffPresent(victorious_buff)
			}

			AddFunction VictoryRush_Use_Heal
			{
					not SpellCooldown(victory_rush)
				and BuffPresent(victorious_buff)
				and HealthPercent() <= 70
			}

			###
			### Whirlwind Functions
			###
			AddFunction Whirlwind_Use
			{
					not SpellCooldown(whirlwind)
				and Enemies() > 1
			}

			AddFunction Whirlwind_Use_FervorOfBattle
			{
					not SpellCooldown(whirlwind)
				and Talent(fervor_of_battle_talent)
				and {
							BuffStacks(focused_rage_buff) == 3
						 or not Talent(focused_rage_talent)
						 or BuffPresent(battle_cry_buff)
						 or Rage() > 32
					}
			}

			###
			### General Functions
			###
			AddFunction ArcaneTorrent_Use
			{
					RageDeficit() >= 30
			}

			AddFunction MeleeRange_Use
			{
					CheckBoxOn(opt_melee_range)
				and not target.RangeCheck(mortal_strike)
			}

			###
			### Item Functions
			###
			AddFunction Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and {
									{
											BuffPresent(trinket_stat_any_buff)
										 or BuffPresent(legendary_ring_buff) 
										 or BuffStacks(trinket_stacking_proc_any_buff) > 6
									}
								 or {
											target.HealthPercent() <= 20
										 or target.TimeToDie() <= 25
									}
							}
					}
				 or {
							not BloodlustDebuff()
						and target.TimeToDie() <= 25
					}
			}

			AddFunction DraughtOfSouls_Use
			{
					HasEquippedItem(draught_of_souls)
				and BuffPresent(battle_cry_buff)
				and {
							target.Distance() <= 10
						 or CheckBoxOff(opt_range_check)
					}
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					if target.RangeCheck(pummel) Spell(pummel)
					if target.RangeCheck(arcane_torrent_rage) Spell(arcane_torrent_rage)

					if not target.Classification(worldboss)
					{
						if target.RangeCheck(storm_bolt) and Talent(storm_bolt_talent) Spell(storm_bolt)
						if target.RangeCheck(shockwave) and Talent(shockwave_talent) Spell(shockwave)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						Spell(war_stomp)
					}
				}
			}

			###
			### Arms - Main
			###
			AddFunction ShortCD
			{
				# Actions performed at range
				if Charge_Use() Spell(charge)
				if HeroicLeap_Use() Spell(heroic_leap)
				
				# Move to melee range if not in melee range, only if checkbox is enabled
				if MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}

			AddFunction FocusedRage
			{
				if FocusedRage_Use_DumpRage() Spell(focused_rage)
				if FocusedRage_Use_BattleCry() Spell(focused_rage)
				if FocusedRage_Use_BattleCry_Prepare() Spell(focused_rage)
				if FocusedRage_Use_ColossusSmash_Clip() Spell(focused_rage)
			}
			
			AddFunction Main
			{
				if CheckBoxOn(opt_ravager) and Ravager_Use() Spell(ravager)
				if CheckBoxOn(opt_heroic_throw) and HeroicThrow_Use() Spell(heroic_throw)
				if CheckBoxOn(opt_warbreaker) and Warbreaker_Use() Spell(warbreaker)
				if CheckBoxOn(opt_bladestorm) and Bladestorm_Use() Spell(bladestorm)
				if Cleave_Use() Spell(cleave)
				if Whirlwind_Use() Spell(whirlwind)
				if CheckBoxOn(opt_shockwave) and Shockwave_Use() Spell(shockwave)
				if Rend_Use() Spell(rend)
				if ColossusSmash_Use() Spell(colossus_smash)
				if CheckBoxOn(opt_weight_of_the_earth_debuff) and HeroicLeap_Use_WeightOfTheEarth() Spell(heroic_leap)
				if CheckBoxOn(opt_warbreaker_debuff) and Warbreaker_Use_Debuff() Spell(warbreaker)
				if Execute_Use_Ayala() Spell(execute_arms)
				if Rend_Pandemic_Use() Spell(rend)
				if Overpower_Use() Spell(overpower)
				if MortalStrike_Buffed_Use() Spell(mortal_strike)
				if Execute_Use() Spell(execute_arms)
				if MortalStrike_Use() Spell(mortal_strike)
				if Whirlwind_Use_FervorOfBattle() Spell(whirlwind)
				if Slam_Use() Spell(slam)
				if VictoryRush_Use() Spell(victory_rush)
			}
			
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Use Victory Rush for healing, only if checkbox is enabled
				if CheckBoxOn(opt_victory_rush_heal) and VictoryRush_Use_Heal() Spell(victory_rush)

				# CD Abilities
				if BattleCry_Use() Spell(battle_cry)
				if Avatar_Use() Spell(avatar)
				if Ravager_Use() Spell(ravager)
				if Warbreaker_Use() Spell(warbreaker)
				if BuffPresent(battle_cry_buff)
				{
					Spell(blood_fury_ap)
					Spell(berserking)
					if not CheckBoxOn(opt_arcane_torrent_interrupt) and ArcaneTorrent_Use() Spell(arcane_torrent_rage)
					if DraughtOfSouls_Use() Item(draught_of_souls)
					Rotation_ItemActions()
					if LunaEclipse_Potion_Use() and Potion_Use() Item(potion_of_prolonged_power)
				}
				if Bladestorm_Use() Spell(bladestorm)
				if Shockwave_Use() Spell(shockwave)
			}

			###
			### Arms - Main_Precombat
			###
			AddFunction ShortCD_Precombat
			{		

			}

			AddFunction PrecombatFocusedRage
			{
				if FocusedRage_Use_Precombat() Spell(focused_rage)
			}

			AddFunction Main_Precombat
			{
				
			}

			AddFunction CD_Precombat
			{
				# Standard Actions
				if LunaEclipse_Potion_Use() Item(potion_of_prolonged_power)
			}

			###
			### Rotation icons.
			###
			AddIcon help=shortcd checkbox=opt_range_check
			{
				if not InCombat() ShortCD_Precombat()
				ShortCD()
			}

			AddIcon help=offgcd talent=focused_rage_talent
			{
				if not InCombat() PrecombatFocusedRage()
				FocusedRage()
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

		OvaleScripts:RegisterScript("WARRIOR", "arms", name, desc, code, "script");
	end
end