local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "profiler781_warrior_protection";
		local desc = "Profiler781: Protection Warrior";

		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.WARRIOR_PROTECTION,
			ScriptAuthor = "Profiler781",
			GuideAuthor = "Vlad",
			GuideLink = "http://www.icy-veins.com/wow/protection-warrior-pve-tank-guide",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "2212112",
			["Raiding (AOE)"] = "1223112",
			["Raiding (DPS oriented)"] = "1233131",
			["Mythic+"] = "3333112",
			["Easy Mode"] = "1213322",
 		};

		local code = [[
			Include(lunaeclipse_warrior_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_avatar "Cooldown: Avatar" default)
			AddCheckBox(opt_battle_cry "Cooldown: Battle Cry" default)
			AddCheckBox(opt_ravager "Cooldown: Ravager" default)
			AddCheckBox(opt_victory_rush_heal "Heal: Victory Rush" default)
			AddCheckBox(opt_heroic_throw "Display: Heroic Throw" default)
			AddCheckBox(opt_shield_block "Display: Shield Block" default)
			AddCheckBox(opt_off_gcd "Icon: Off GCD" default)
			AddCheckBox(opt_defensive_cd "Icon: Defensive CD" default)
			AddCheckBox(opt_offensive_cd "Icon: Offensive CD" default)
			AddCheckBox(opt_major_cd "CD: Major CD for Bosses")
			AddCheckBox(opt_range_check "Display: Range Check")

			###
			### Artifact Functions
			###
			AddFunction NeltharionsAvailable
			{
					SpellKnown(neltharions_fury)
				and not SpellCooldown(neltharions_fury)
			}

			AddFunction Neltharions_Use
			{
					NeltharionsAvailable()
				and BuffRemaining(shield_block_buff) < GCD()
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
						 or isRooted()
						 or BuffPresent(battle_cry_buff)
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
			### Demoralizing Shout Functions
			###
			AddFunction DemoralizingShout_Use
			{
					not SpellCooldown(demoralizing_shout)
			}

			###
			### Devastate Functions
			###
			AddFunction Devastate_Use
			{
					not SpellCooldown(devastate)
				and not Talent(devastator_talent)
			}

			###
			### Ignore Pain Functions
			###
			AddFunction IgnorePain_Use
			{
					not SpellCooldown(ignore_pain)
				and {
							not Talent(vengeance_talent)
						 or {
						 			BuffPresent(vengeance_ignore_pain_buff)
						 		and {
						 					Rage() >= 60 * 0.65
						 				 or BuffRemaining(vengeance_ignore_pain_buff) <= 3
						 			}
						 	}
						 or {
						 			Talent(vengeance_talent)
						 		and not BuffPresent(vengeance_ignore_pain_buff)
						 		and not BuffPresent(vengeance_revenge_buff)
							}
					}
			}

			###
			### Impending Victory Functions
			###
			AddFunction ImpendingVictory_Use_Heal
			{
					not SpellCooldown(impending_victory)
				and HealthPercent() <= 85
				and Talent(impending_victory_talent)
			}

			###
			### Intercept Functions
			###
			AddFunction Intercept_Use
			{
					not SpellCooldown(intercept)
				and target.Distance() <= 25
				and {
							{
									target.IsFriend()
								and RageDeficit() >= 35
							}
						 or {
									not target.IsFriend()
								and target.Distance() >= 8
							}
					}
			}

			AddFunction Intercept_Use_Focus
			{
					not SpellCooldown(intercept)
				and focus.Distance() <= 25
				and focus.IsFriend()
				and RageDeficit() >= 35
			}

			AddFunction Intercept_Use_Other
			{
					not SpellCooldown(intercept)
				and RageDeficit() >= 35
			}

			###
			### Heroic Throw Functions
			###
			AddFunction HeroicThrow_Use
			{
					not SpellCooldown(heroic_throw)
				and target.RangeCheck(heroic_throw)
				and SpellCooldownDuration(intercept) > SpellCooldown(intercept) + 1
			}

			###
			### Heroic Leap Functions
			###
			AddFunction HeroicLeap_Use
			{
					not SpellCooldown(heroic_leap)
				and target.Distance() >= 8
				and SpellCooldownDuration(intercept) > SpellCooldown(intercept) + 1
			}


			###
			### Last Stand Functions
			###
			AddFunction LastStand_Use
			{
					not SpellCooldown(last_stand)
				and HealthPercent() <= 30
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
			}

			###
			### Ravager Functions
			###
			AddFunction Ravager_Use
			{
					not SpellCooldown(ravager)
				and {
							not SpellCooldown(battle_cry)
						 or BuffPresent(battle_cry_buff)
					}
			}

			###
			### Revenge Functions
			###
			AddFunction Revenge_Use
			{
					not SpellCooldown(revenge)
				and RageCost(revenge) <= Rage()
				and {
							RageCost(revenge) == 0
						 or {
					 				{
					 						{
													BuffRemaining(vengeance_revenge_buff) <= 3
												and BuffPresent(vengeance_revenge_buff)
											}
										 or {
										 			BuffPresent(vengeance_revenge_buff)
										 		and Rage() >= (60 + RageCost(revenge)) * 0.65
											}
									}
								and not BuffPresent(vengeance_ignore_pain_buff)
							}
					}
			}

			AddFunction Revenge_Use_AOE
			{
					not SpellCooldown(revenge)
				and RageCost(revenge) <= Rage()
				and Enemies() >= 3
			}

			###
			### Shield Block Functions
			###
			AddFunction ShieldBlock_Use
			{
					not SpellCooldown(shield_block)
				and BuffRemaining(shield_block_buff) <= 3
			}

			###
			### Shield Slam Functions
			###
			AddFunction ShieldSlam_Use
			{
					not SpellCooldown(shield_slam)
			}

			###
			### Shield Wall Functions
			###
			AddFunction ShieldWall_Use
			{
					not SpellCooldown(shield_wall)
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
			}

			###
			### Thunder Clap Functions
			###
			AddFunction ThunderClap_Use
			{
					not SpellCooldown(thunder_clap)
			}

			AddFunction ThunderClap_Use_AOE
			{
					not SpellCooldown(thunder_clap)
				and Enemies() >= 3
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
			### General Functions
			###
			AddFunction ArcaneTorrent_Use
			{
					RageDeficit() >= 30
			}

			AddFunction MeleeRange_Use
			{
					CheckBoxOn(opt_melee_range)
				and not target.RangeCheck(shield_slam)
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
				and BuffRemaining(battle_cry_buff) <= BaseDuration(felcrazed_rage_buff) + GCD()
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
						if target.RangeCheck(shockwave) and Talent(shockwave_talent) Spell(shockwave)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						Spell(war_stomp)
					}
				}
			}

			###
			### Protection - Main
			###
			AddFunction ShortCD
			{
				# Actions performed at range
				if Intercept_Use() Spell(intercept)
				if HeroicLeap_Use() Spell(heroic_leap)
				
				# Move to melee range if not in melee range, only if checkbox is enabled
				if MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}

			AddFunction OffGCD
			{
				if ShieldBlock_Use() and CheckBoxOn(opt_shield_block) Spell(shield_block)
				if IgnorePain_Use() Spell(ignore_pain)
				if Intercept_Use() Spell(intercept)
				if Intercept_Use_Focus() Spell(intercept text=focus)
				if Intercept_Use_Other() Spell(intercept text=other)
			}

			AddFunction Main
			{
				if CheckBoxOn(opt_heroic_throw) and HeroicThrow_Use() Spell(heroic_throw)
				if Avatar_Use() and CheckBoxOn(opt_avatar) Spell(avatar)
				if Ravager_Use() and CheckBoxOn(opt_ravager) Spell(ravager)
				if BattleCry_Use() and CheckBoxOn(opt_battle_cry) Spell(battle_cry)
				if Revenge_Use_AOE() Spell(revenge)
				if ThunderClap_Use_AOE() Spell(thunder_clap)
				if ShieldSlam_Use() Spell(shield_slam)
				if CheckBoxOn(opt_victory_rush_heal) and VictoryRush_Use_Heal() Spell(victory_rush)
				if CheckBoxOn(opt_victory_rush_heal) and ImpendingVictory_Use_Heal() Spell(impending_victory)
				if Revenge_Use() Spell(revenge)
				if ThunderClap_Use() Spell(thunder_clap)
				if Devastate_Use() Spell(devastate)
				if VictoryRush_Use() Spell(victory_rush)
			}

			AddFunction DefensiveCD
			{
				if LastStand_Use() Spell(last_stand)
				if DemoralizingShout_Use() Spell(demoralizing_shout)
				if Neltharions_Use() Spell(neltharions_fury)
				if ShieldWall_Use() Spell(shield_wall)
			}

			AddFunction OffensiveCD
			{
				# Standard Actions
				Rotation_Interrupt()

				# CD Abilities
				if Avatar_Use() Spell(avatar)
				if Ravager_Use() Spell(ravager)
				if BattleCry_Use() Spell(battle_cry)

				if BuffPresent(battle_cry_buff)
				{
					Spell(blood_fury_ap)
					Spell(berserking)
					if not CheckBoxOn(opt_arcane_torrent_interrupt) and ArcaneTorrent_Use() Spell(arcane_torrent_rage)
					Rotation_ItemActions()
					if LunaEclipse_Potion_Use() and Potion_Use() Item(potion_of_prolonged_power)
					if DraughtOfSouls_Use() Item(draught_of_souls)
				}
			}

			###
			### Protection - Main_Precombat
			###
			AddFunction ShortCD_Precombat
			{
				# Actions performed at range
				if Intercept_Use() Spell(intercept)
				if HeroicLeap_Use() Spell(heroic_leap)
				
				# Move to melee range if not in melee range, only if checkbox is enabled
				if MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}

			AddFunction Main_Precombat
			{
			}

			AddFunction DefensiveCD_Precombat
			{
			}

			AddFunction OffensiveCD_Precombat
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

			AddIcon checkbox=opt_off_gcd help=offgcd
			{
				OffGCD()
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

			AddIcon help=cd checkbox=opt_defensive_cd
			{
				if not InCombat() DefensiveCD_Precombat()
				DefensiveCD()
			}

			AddIcon help=cd checkbox=opt_offensive_cd
			{
				if not InCombat() OffensiveCD_Precombat()
				OffensiveCD()
			}
		]];

		OvaleScripts:RegisterScript("WARRIOR", "protection", name, desc, code, "script");
	end
end