local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "profiler781_warrior_fury";
		local desc = "Profiler781: Fury Warrior";

		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.WARRIOR_FURY,
			ScriptAuthor = "Profiler781",
			GuideAuthor = "Wordup",
			GuideLink = "http://www.icy-veins.com/wow/fury-warrior-pve-dps-guide",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target) / Easy Mode"] = "2333132",
			["Raiding (AOE)"] = "1112232",
			["Solo"] = "1311231",
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
					OPT_DRAGON_ROAR = {
						type = "toggle",
						name = BINDING_NAME_OPT_DRAGON_ROAR,
						desc = functionsConfiguration:getAOETooltip("Dragon Roar"),
						arg = "OPT_DRAGON_ROAR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
				},
			},
			settingsBuff = {
				type = "group",
				name = BINDING_HEADER_BUFFS_DEBUFFS,
				inline = true,
				order = 20,
				args = {
					OPT_HEROIC_THROW = {
						type = "toggle",
						name = BINDING_NAME_OPT_HEROIC_THROW,
						desc = functionsConfiguration:getDebuffTooltip("Heroic Throw"),
						arg = "OPT_HEROIC_THROW",
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
					OPT_AVATAR = {
						type = "toggle",
						name = BINDING_NAME_OPT_AVATAR,
						desc = functionsConfiguration:getCooldownTooltip("Avatar", "CD"),
						arg = "OPT_AVATAR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_BATTLE_CRY = {
						type = "toggle",
						name = BINDING_NAME_OPT_BATTLE_CRY,
						desc = functionsConfiguration:getCooldownTooltip("Battle Cry", "CD"),
						arg = "OPT_BATTLE_CRY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_BLOODBATH = {
						type = "toggle",
						name = BINDING_NAME_OPT_BLOODBATH,
						desc = functionsConfiguration:getCooldownTooltip("Bloodbath", "CD"),
						arg = "OPT_BLOODBATH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		-- This custom script has this because there is no default script provided by the package.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			# Fury Warrior rotation functions based on Guide written by Archimtiros: http://www.icy-veins.com/wow/fury-warrior-pve-dps-guide

			Include(lunaeclipse_warrior_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_bladestorm "AOE CD: Bladestorm" default)
			AddCheckBox(opt_dragon_roar "AOE CD: Dragon Roar" default)
			AddCheckBox(opt_avatar "Cooldown: Avatar" default)
			AddCheckBox(opt_bloodbath "Cooldown: Bloodbath" default)
			AddCheckBox(opt_battle_cry "Cooldown: Battle Cry" default)
			AddCheckBox(opt_odyns_fury "Cooldown: Odyn's Fury" default)
			AddCheckBox(opt_heroic_throw "Display: Heroic Throw" default)
			AddCheckBox(opt_range_check "Display: Range Check")

			###
			### Artifact Functions
			###
			AddFunction OdynsAvailable
			{
					SpellKnown(odyns_fury)
				and not SpellCooldown(odyns_fury)
			}

			AddFunction OdynsFury_Use
			{
					OdynsAvailable()
				and {
							BuffPresent(battle_cry_buff)
						 or Enemies() > 3
					}
			}

			###
			### Avatar Functions
			###
			AddFunction Avatar_Use
			{
					not SpellCooldown(avatar)
				and Talent(avatar_talent)
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
			}

			###
			### Berserker Rage Functions
			###
			AddFunction BerserkerRage_Use
			{
					not SpellCooldown(berserker_rage)
				and Talent(outburst_talent)
				and not BuffPresent(enrage_buff)
				and {
							BuffPresent(battle_cry_buff)
						 or DragonRoar_Use()
					}
			}

			###
			### Bladestorm Functions
			###
			AddFunction Bladestorm_Use
			{
					not SpellCooldown(bladestorm)
				and Enemies() > 1
			}

			###
			### Bloodbath Functions
			###
			AddFunction Bloodbath_Use
			{
					not SpellCooldown(bloodbath)
				and Talent(bloodbath_talent)
				and {
							not SpellCooldown(battle_cry)
						 or BuffPresent(battle_cry_buff)
					}
			}

			###
			### Bloodthirst Functions
			###
			AddFunction Bloodthirst_Use
			{
					not SpellCooldown(bloodthirst)
				and {
							Enemies() == 1
						 or BuffPresent(meat_cleaver_buff)
					}
				and not BuffPresent(enrage_buff)
			}

			AddFunction Bloodthirst_Use_Dump
			{
					not SpellCooldown(bloodthirst)
			}

			AddFunction Bloodthirst_Use_Fujiedas
			{
					not SpellCooldown(bloodthirst)
				and LegendaryEquipped(fujiedas_fury)
				and {
							BuffRemaining(fujiedas_fury_buff) <= GCD() * 1.2
						 or {
						 			BuffRemaining(fujiedas_fury_buff) <= GCD() * 2.2
						 		and BuffRemaining(juggernaut_buff) <= GCD() * 2.2
							}
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
			### Dragon Roar Functions
			###
			AddFunction DragonRoar_Use
			{
					not SpellCooldown(dragon_roar)
				and Talent(dragon_roar_talent)
				and {
							not SpellCooldown(battle_cry)
						 or BuffPresent(battle_cry_buff)
						 or Rampage_Use()
					}
			}

			###
			### Execute Functions
			###
			AddFunction Execute_Use
			{
					not SpellCooldown(execute)
				and target.HealthPercent() < 20
				and {
							Rage() >= 100
						 or BuffPresent(enrage_buff)
						 or {
						 			Talent(massacre_talent)
						 		and not BuffPresent(massacre_buff)
							}
					}
				and {
							not Talent(frothing_berserker_talent)
						 or target.TimeToDie() < 6
						 or {
						 			SpellCooldown(battle_cry) < GCD() * 7
						 		and Talent(reckless_abandon_talent)
						 		and BuffPresent(enrage_buff)
							}
						 or BuffRemaining(frothing_berserker_buff) >= RageDeficit() / 25 * GCD()
						 or {
						 			not BuffPresent(frothing_berserker_buff)
						 		and Talent(frothing_berserker_talent)
						 		and Rage() >= 100
							}
						 or BuffPresent(sense_death_buff)
					}
				and Enemies() < 4
			}

			AddFunction Execute_Use_Juggernaut
			{
					not SpellCooldown(execute)
				and target.HealthPercent() < 20
				and BuffPresent(juggernaut_buff)
				and BuffRemaining(juggernaut_buff) <= GCD() * 1.2
				and {
							Enemies() < 4
						 or target.Classification(worldboss)
					}
			}

			AddFunction Execute_Use_Alaya
			{
					not SpellCooldown(execute)
				and BuffPresent(stone_heart_buff)
				and Enemies() < 4
			}

			###
			### Furious Slash Functions
			###
			AddFunction FuriousSlash_Use
			{
					not SpellCooldown(furious_slash)
			}

			AddFunction FuriousSlash_Use_Frenzy
			{
					not SpellCooldown(furious_slash)
				and Talent(frenzy_talent)
				and BuffPresent(frenzy_buff)
				and {
							BuffRemaining(frenzy_buff) <= GCD() * 1.2
						 or {
						 			BuffRemaining(frenzy_buff) <= GCD() * 2.2
						 		and {
						 					BuffRemaining(juggernaut_buff) <= GCD() * 2.2
						 				 or {
						 				 			BuffRemaining(fujiedas_fury_buff) <= GCD() * 2.2
						 				 		and LegendaryEquipped(fujiedas_fury)
						 				 	}
						 			}
							}
						 or {
						 			BuffRemaining(frenzy_buff) <= GCD() * 3.2
						 		and BuffRemaining(fujiedas_fury_buff) <= GCD() * 3.2
						 		and BuffRemaining(juggernaut_buff) <= GCD() * 3.2
						 		and LegendaryEquipped(fujiedas_fury)
							}
					}
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
			### Heroic Leap Functions
			###
			AddFunction HeroicLeap_Use
			{
					not SpellCooldown(heroic_leap)
				and target.Distance() >= 8
				and SpellCooldownDuration(charge) > SpellCooldown(charge) + 1
			}

			###
			### Raging Blow Functions
			###
			AddFunction RagingBlow_Use
			{
					not SpellCooldown(raging_blow)
				and Enemies() == 1
				and BuffPresent(enrage_buff)
			}

			AddFunction RagingBlow_Use_InnerRage
			{
					not SpellCooldown(raging_blow)
				and Talent(inner_rage_talent)
				and Enemies() < 4
			}

			###
			### Rampage Functions
			###
			AddFunction Rampage_Use
			{
					not SpellCooldown(rampage)
				and {
							{
									BuffPresent(meat_cleaver_buff)
								and Enemies() > 2
							}
						 or {
						 			Enemies() < 4
						 		and {
											BuffPresent(massacre_buff)
										 or target.HealthPercent() >= 20
						 			}
						 	}
					}
				and {
							Rage() >= 100
						 or {
						 			not Talent(frothing_berserker_talent)
						 		and {
							 				{
										 			BuffPresent(massacre_buff)
										 		and {
										 					not BuffPresent(enrage_buff)
										 				 or BuffRemaining(enrage_buff) > GCD()
										 			}
										 	}
										 	 or not BuffPresent(enrage_buff)
									}
						 	}
					}
			}

			###
			### Whirlwind Functions
			###
			AddFunction Whirlwind_Use
			{
					not SpellCooldown(whirlwind)
				and Enemies() > 1
			}

			AddFunction Whirlwind_Use_WreckingBall
			{
					not SpellCooldown(whirlwind)
				and Talent(wrecking_ball_talent)
				and BuffPresent(wrecking_ball_buff)
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
				and not target.RangeCheck(bloodthirst)
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
							BuffRemaining(battle_cry_buff) <= BaseDuration(felcrazed_rage_buff) + GCD()
						 or BuffRemaining(enrage_buff) >= BaseDuration(felcrazed_rage_buff)
					}
				and target.Distance() <= 10
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
						if Talent(shockwave_talent) Spell(shockwave)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						Spell(war_stomp)
					}
				}
			}

			###
			### Fury - Main
			###
			AddFunction ShortCD
			{
				# Actions performed at range
				if Charge_Use() Spell(charge)
				if HeroicLeap_Use() Spell(heroic_leap)
				
				# Move to melee range if not in melee range, only if checkbox is enabled
				if MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}

			AddFunction Main
			{
				if CheckBoxOn(opt_heroic_throw) and HeroicThrow_Use() Spell(heroic_throw)
				if Execute_Use_Juggernaut() Spell(execute)
				if Bloodthirst_Use_Fujiedas() Spell(bloodthirst)
				if FuriousSlash_Use_Frenzy() Spell(furious_slash)
				if Rampage_Use() Spell(rampage)
				if Bloodthirst_Use() Spell(bloodthirst)
				if BerserkerRage_Use() Spell(berserker_rage)
				if Execute_Use_Alaya() Spell(execute)
				if CheckBoxOn(opt_avatar) and Avatar_Use() Spell(avatar)
				if CheckBoxOn(opt_bloodbath) and Bloodbath_Use() Spell(bloodbath)
				if CheckBoxOn(opt_dragon_roar) and DragonRoar_Use() Spell(dragon_roar)
				if CheckBoxOn(opt_battle_cry) and BattleCry_Use() Spell(battle_cry)
				if CheckBoxOn(opt_bladestorm) and Bladestorm_Use() Spell(bladestorm)
				if Execute_Use() Spell(execute)
				if CheckBoxOn(opt_odyns_fury) and OdynsFury_Use() Spell(odyns_fury)
				if RagingBlow_Use_InnerRage() Spell(raging_blow)
				if Whirlwind_Use_WreckingBall() Spell(whirlwind)
				if RagingBlow_Use() Spell(raging_blow)
				if Whirlwind_Use() Spell(whirlwind)
				if Bloodthirst_Use_Dump() Spell(bloodthirst)
				if FuriousSlash_Use() Spell(furious_slash)
			}

			AddFunction CD
			{
				# Standard Actions
				Rotation_Interrupt()

				# CD Abilities
				if Avatar_Use() Spell(avatar)
				if Bloodbath_Use() Spell(bloodbath)
				if DragonRoar_Use() Spell(dragon_roar)
				if BattleCry_Use() Spell(battle_cry)
				if BuffPresent(battle_cry_buff)
				{
					Spell(blood_fury_ap)
					Spell(berserking)
					if not CheckBoxOn(opt_arcane_torrent_interrupt) and ArcaneTorrent_Use() Spell(arcane_torrent_rage)
					if DraughtOfSouls_Use() Item(draught_of_souls)
					Rotation_ItemActions()
					if LunaEclipse_Potion_Use() and Potion_Use() Item(potion_of_prolonged_power)
				}
				if OdynsFury_Use() Spell(odyns_fury)
			}

			###
			### Fury - Main_Precombat
			###
			AddFunction ShortCD_Precombat
			{
				# Actions performed at range
				if Charge_Use() Spell(charge)
				if HeroicLeap_Use() Spell(heroic_leap)
				
				# Move to melee range if not in melee range, only if checkbox is enabled
				if MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
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

		OvaleScripts:RegisterScript("WARRIOR", "fury", name, desc, code, "script");
	end
end