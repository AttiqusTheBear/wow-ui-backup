local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "profiler781_druid_balance";
		local desc = "Profiler781: Balance Druid";

		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DRUID_BALANCE,
			ScriptAuthor = "Profiler781",
			ScriptCredits = "LunaEclipse",
			GuideAuthor = "Vlad",
			GuideLink = "http://www.icy-veins.com/wow/balance-druid-pve-dps-guide",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "3330233",
			["Raiding (AOE)"] = "3330112",
			["Dungeons / Mythic+"] = "3330212",
			["Solo / World Quests"] = "1230233",
			["Easy Mode"] = "3230233",
		};

		local code = [[
			# Balance Druid rotation functions based on Guide written by Vlad: http://www.icy-veins.com/wow/balance-druid-pve-dps-guide

			Include(lunaeclipse_druid_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_stellar_flare "AOE: Stellar Flare" default)
			AddCheckBox(opt_blessing_ancients "Buff: Blessing of Elune" default)
			AddCheckBox(opt_moonkin_form "Buff: Moonkin Form" default)
			AddCheckBox(opt_astral_communion "Cooldown: Astral Communion" default)
			AddCheckBox(opt_celestial_alignment "Cooldown: Celestial Alignment" default)
			AddCheckBox(opt_force_of_nature "Cooldown: Force of Nature" default)
			AddCheckBox(opt_fury_of_elune "Cooldown: Fury of Elune" default)
			AddCheckBox(opt_warrior_of_elune "Cooldown: Warrior of Elune" default)
			AddCheckBox(opt_barkskin "Defensive: Barkskin" default)
			AddCheckBox(opt_renewal "Heal: Renewal" default)
			AddCheckBox(opt_scythe_spell_clipping "Other: Allow Clipping Scythe Spells")
			AddCheckBox(opt_major_cd "CD: Major CD for Bosses")

			###
			### Artifact Functions
			###
			AddFunction ScytheOfElune_Available
			{
					HasScytheOfElune()
				and ScytheOfEluneCharges() >= 1
			}

			AddFunction FullMoon_Use
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(full_moon)
				and BuffRemaining(starfall_buff) < ExecuteTime(lunar_strike_balance)
				and {
							AstralPowerDeficit() >= AstralPowerCost(full_moon) * -1
						 or {
									LegendaryEquipped(the_emerald_dreamcatcher)
								and AstralPowerDeficit() >= AstralPowerCost(full_moon) * -0.75
							}
					}
				and {
							not BuffPresent(the_emerald_dreamcatcher_buff)
						 or AstralPower() < AstralPowerCost(starsurge_moonkin)
					}
				and not IsMoving()
			}

			AddFunction FullMoon_Use_MaxCharges
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(full_moon)
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellChargeCooldown(full_moon) <= ExecuteTime(full_moon) + GCD() * 2
							}
					}
				and {
							AstralPowerDeficit() >= AstralPowerCost(full_moon) * -1
						 or {
									LegendaryEquipped(the_emerald_dreamcatcher)
								and AstralPowerDeficit() >= AstralPowerCost(full_moon) * -0.75
							}
					}
				and not IsMoving()
			}
			
			AddFunction FullMoon_EmeraldDreamcatcher_BuffActive
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(full_moon)
				and BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(full_moon)
			}

			AddFunction FullMoon_EmeraldDreamcatcher_Clip
			{
					BaseDuration(the_emerald_dreamcatcher_buff) >= ExecuteTime(full_moon) + GCD()
			}

			AddFunction HalfMoon_Use
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(half_moon)
				and BuffRemaining(starfall_buff) < ExecuteTime(lunar_strike_balance)
				and not IsMoving()
				and AstralPowerDeficit() >= AstralPowerCost(half_moon) * -1
				and {
							not BuffPresent(the_emerald_dreamcatcher_buff)
						 or AstralPower() < AstralPowerCost(starsurge_moonkin)
					}
			}

			AddFunction HalfMoon_Use_MaxCharges
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(half_moon)
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellChargeCooldown(half_moon) <= ExecuteTime(half_moon) + GCD() * 2
							}
					}
				and not IsMoving()
				and AstralPowerDeficit() >= AstralPowerCost(half_moon) * -1
			}
			
			AddFunction HalfMoon_EmeraldDreamcatcher_BuffActive
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(half_moon)
				and BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(half_moon)
			}

			AddFunction HalfMoon_EmeraldDreamcatcher_Clip
			{
					BaseDuration(the_emerald_dreamcatcher_buff) >= ExecuteTime(half_moon) + GCD()
			}

			AddFunction NewMoon_Use
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(new_moon)
				and BuffRemaining(starfall_buff) < ExecuteTime(lunar_strike_balance)
				and not IsMoving()
				and AstralPowerDeficit() >= AstralPowerCost(new_moon) * -1
				and {
							not BuffPresent(the_emerald_dreamcatcher_buff)
						 or AstralPower() < AstralPowerCost(starsurge_moonkin)
					}
			}

			AddFunction NewMoon_Use_MaxCharges
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(new_moon)
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellChargeCooldown(new_moon) <= ExecuteTime(new_moon) + GCD() * 2
							}
					}
				and not IsMoving()
				and AstralPowerDeficit() >= AstralPowerCost(new_moon) * -1
			}
			
			AddFunction NewMoon_EmeraldDreamcatcher_BuffActive
			{
					ScytheOfElune_Available()
				and ScytheOfEluneSpell(new_moon)
				and BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(new_moon)
			}

			AddFunction NewMoon_EmeraldDreamcatcher_Clip
			{
					BaseDuration(the_emerald_dreamcatcher_buff) >= ExecuteTime(new_moon) + GCD()
			}

			###
			### Astral Communion Functions
			###
			AddFunction AstralCommunion_Use
			{
					Talent(astral_communion_talent)
				and not SpellCooldown(astral_communion)
				and {
							not Talent(fury_of_elune_talent)
						 or {
									Talent(fury_of_elune_talent)
								and BuffPresent(fury_of_elune_up_buff)
							}
					}
				and AstralPowerDeficit() >= AstralPowerCost(astral_communion) * -1
			}

			###
			### Barkskin Functions
			###
			AddFunction Barkskin_Use
			{
					not SpellCooldown(barkskin)
				and HealthPercent() <= 40
			}

			###
			### Blessing Of The Ancients Functions
			###
			AddFunction BlessingOfElune_Use
			{
					not SpellCooldown(blessing_of_the_ancients)
				and not BuffPresent(blessing_of_elune_buff)
				and CheckBoxOn(opt_blessing_ancients)
				and Enemies() < 3
			}

			AddFunction BlessingOfAnshe_Use
			{
					not SpellCooldown(blessing_of_the_ancients)
				and not BuffPresent(blessing_of_anshe_buff)
				and CheckBoxOn(opt_blessing_ancients)
				and Enemies() > 2
			}

			###
			### Celestial Alignment Functions
			###
			AddFunction CelestialAlignment_Active
			{
					BuffPresent(incarnation_chosen_of_elune_buff)
				 or BuffPresent(celestial_alignment_buff)				
			}

			AddFunction CelestialAlignment_Use
			{
					not Talent(incarnation_talent)
				and not SpellCooldown(celestial_alignment)
				and target.DebuffPresent(moonfire_debuff)
				and target.DebuffPresent(sunfire_debuff)
				and {
							not Talent(fury_of_elune_talent)
						 or {
									Talent(fury_of_elune_talent)
								and not SpellCooldown(fury_of_elune)
							}
						 or Enemies() == 1
					}
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
			}

			AddFunction Incarnation_Use
			{
					Talent(incarnation_talent)
				and not SpellCooldown(incarnation_chosen_of_elune)
				and target.DebuffPresent(moonfire_debuff)
				and target.DebuffPresent(sunfire_debuff)
				and {
							not Talent(fury_of_elune_talent)
						 or {
									Talent(fury_of_elune_talent)
								and not SpellCooldown(fury_of_elune)
							}
						 or Enemies() == 1
					}
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
			}

			###
			### Force of Nature Functions
			###
			AddFunction ForceOfNature_Use
			{
					Talent(force_of_nature_talent)
				and not SpellCooldown(force_of_nature)
			}

			###
			### Fury of Elune Functions
			###
			AddFunction FuryOfElune_Active
			{
					BuffPresent(fury_of_elune_up_buff)
			}
			
			AddFunction FuryOfElune_Use
			{
					Talent(fury_of_elune_talent)
				and not SpellCooldown(fury_of_elune)
				and {
							{
									Talent(incarnation_talent)
								and {
											BuffPresent(incarnation_chosen_of_elune_buff)
										 or SpellCooldown(incarnation_chosen_of_elune) > 60
									}
							}
						 or {
									not Talent(incarnation_talent)
								and {
											not SpellCooldown(celestial_alignment)
										 or SpellCooldown(celestial_alignment) > 60
									}
							}
					}
				and {
							target.DebuffRemaining(moonfire_debuff) > 15
						and target.DebuffRemaining(sunfire_debuff) > 15
						and {
									not Talent(stellar_flare_talent)
								 or {
											Talent(stellar_flare_talent)
										and target.DebuffRemaining(stellar_flare_debuff) > 15
									}
							}
					}
				and Enemies() >= 2
				and AstralPower() >= 90
			}

			###
			### Lunar Strike Functions
			###
			AddFunction LunarStrike_Use
			{
					not SpellCooldown(lunar_strike_balance)
				and Enemies() >= 3
				and {
							not IsMoving()
						 or BuffPresent(owlkin_frenzy_buff)
					}
			}
			
			AddFunction LunarStrike_Use_Empowered
			{
					not SpellCooldown(lunar_strike_balance)
				and {
							not IsMoving()
						 or BuffPresent(owlkin_frenzy_buff)
					}
				and BuffStacks(lunar_empowerment_buff) >= 1
				and BuffStacks(lunar_empowerment_buff) >= BuffStacks(solar_empowerment_buff)
			}

			AddFunction LunarStrike_Use_MaxEmpowerment
			{
					not SpellCooldown(lunar_strike_balance)
				and {
							not IsMoving()
						or BuffPresent(owlkin_frenzy_buff)
					}
				and BuffStacks(lunar_empowerment_buff) == 3
			}
			
			AddFunction LunarStrike_Use_OwlkinFrenzy
			{
					not SpellCooldown(lunar_strike_balance)
				and BuffPresent(owlkin_frenzy_buff)
				and {
							BuffRemaining(owlkin_frenzy_buff) <= GCD()
						 or {
									BuffStacks(lunar_empowerment_buff) >= 1
								and AstralPowerDeficit() >= AstralPowerCost(lunar_strike_balance)
							}
					}
			}
			
			AddFunction LunarStrike_EmeraldDreamcatcher_BuffActive
			{
					BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(lunar_strike_balance)
			}

			###
			### Moonfire Functions
			###
			AddFunction Moonfire_Use
			{
					not SpellCooldown(moonfire)
				and {
							not target.DebuffPresent(moonfire_debuff)
						 or {
						 			Talent(natures_balance_talent)
						 		and target.DebuffRemaining(moonfire_debuff) <= BaseDuration(moonfire_debuff) * 0.15
						 	}
						 or {
						 			not Talent(natures_balance_talent)
						 		and target.InPandemicRange(moonfire_debuff moonfire)
							}
					}
				and Enemies() < 4
				and target.TimeToDie() >= 6 + target.DebuffRemaining(moonfire_debuff)
			}

			AddFunction Moonfire_Use_Other
			{
					not SpellCooldown(moonfire)
				and target.DebuffPresent(moonfire_debuff)
				and DOTTargetCount(moonfire_debuff) < MultiDOTTargets()
				and Enemies() < 4
				and not {
								Starfall_Use()
							 or {
							 			BuffPresent(the_emerald_dreamcatcher_buff)
							 		and Starsurge_Use_EmeraldDreamcatcher()
							 	}
						}
			}
			
			AddFunction Moonfire_EmeraldDreamcatcher_ExtendDuration
			{
					not SpellCooldown(moonfire)
				and target.InPandemicRange(moonfire_debuff moonfire)
				and Enemies() < 4
			}

			###
			### Renewal Functions
			###
			AddFunction Renewal_Use
			{
					Talent(renewal_talent)
				and not SpellCooldown(renewal)
				and HealthPercent() <= 40
			}

			###
			### Solar Wrath Functions
			###			
			AddFunction SolarWrath_Use
			{
					not SpellCooldown(solar_wrath)
				and Enemies() < 4
				and not IsMoving()
			}
			
			AddFunction SolarWrath_Use_Empowered
			{
					not SpellCooldown(solar_wrath)
				and BuffStacks(solar_empowerment_buff) >= 1
				and BuffStacks(solar_empowerment_buff) >= BuffStacks(lunar_empowerment_buff)
				and not IsMoving()
				and {
							Enemies() < 4
						 or BuffRemaining(the_emerald_dreamcatcher_buff) < ExecuteTime(lunar_strike_balance)
					}
			}

			AddFunction SolarWrath_Use_MaxEmpowerment
			{
					not SpellCooldown(solar_wrath)
				and BuffStacks(solar_empowerment_buff) == 3
				and not IsMoving()
				and {
							Enemies() < 4
						 or BuffRemaining(the_emerald_dreamcatcher_buff) < ExecuteTime(lunar_strike_balance)
					}
			}
			
			AddFunction SolarWrath_EmeraldDreamcatcher_PrepareDoubleCast
			{
					not SpellCooldown(lunar_strike_balance)
				and BuffRemaining(the_emerald_dreamcatcher_buff) >= 2 * ExecuteTime(solar_wrath)
				and BuffRemaining(the_emerald_dreamcatcher_buff) < ExecuteTime(solar_wrath) + ExecuteTime(lunar_strike_balance)
				and BuffStacks(solar_empowerment_buff) == 1
				and BuffStacks(lunar_empowerment_buff) >= 1
				and not IsMoving()
				and Enemies() < 4
			}
			
			AddFunction SolarWrath_EmeraldDreamcatcher_BuffActive
			{
					BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(solar_wrath)
			}

			###
			### Starfall Functions
			###
			AddFunction Starfall_Use
			{
					not SpellCooldown(starfall)
				and {
							BuffRemaining(starfall_buff) < GCD()
						 or AstralPower() >= AstralPowerCost(full_moon) * -1
					}
				and Enemies() >= 2
			}

			AddFunction Starfall_Use_OnethsOverconfidence
			{
					not SpellCooldown(starfall)
				and BuffPresent(oneths_overconfidence_buff)
			}

			AddFunction Starfall_Use_OnethsOverconfidence_Expire
			{
					not SpellCooldown(starfall)
				and BuffPresent(oneths_overconfidence_buff)
				and BuffRemaining(oneths_overconfidence_buff) <= GCD() * 3
			}

			###
			### Starsurge Functions
			###
			AddFunction Starsurge_Use
			{
					not SpellCooldown(starsurge_moonkin)
				and {
						{
								BuffStacks(lunar_empowerment_buff) < 3
							and BuffStacks(solar_empowerment_buff) < 3
						}
						or AstralPowerDeficit() <= AstralPowerCost(lunar_strike_balance) * -1
						or LegendaryEquipped(the_emerald_dreamcatcher)
					}
				and Enemies() < 3
			}

			AddFunction Starsurge_Use_EmeraldDreamcatcher
			{
					not SpellCooldown(starsurge_moonkin)
				and {
							{
									BuffPresent(the_emerald_dreamcatcher_buff)
								and BuffRemaining(the_emerald_dreamcatcher_buff) <= GCD()
							}
						 or AstralPowerDeficit() <= AstralPowerCost(lunar_strike_balance) * -1
					}
			}

			AddFunction Starsurge_Use_Dump
			{
					not SpellCooldown(starsurge_moonkin)
				and ScytheOfElune_Available()
				and {
							{
									ScytheOfEluneSpell(full_moon)
								and {
											ScytheOfEluneCharges() == 3
										 or {
													ScytheOfEluneCharges() == 2
												and SpellChargeCooldown(full_moon) <= ExecuteTime(full_moon) + GCD() * 2
											}
									}
								and AstralPowerDeficit() < AstralPowerCost(full_moon) * -1
							}
						 or {
									ScytheOfEluneSpell(half_moon)
								and {
											ScytheOfEluneCharges() == 3
										 or {
													ScytheOfEluneCharges() == 2
												and SpellChargeCooldown(half_moon) <= ExecuteTime(half_moon) + GCD() * 2
											}
									}
								and AstralPowerDeficit() < AstralPowerCost(half_moon) * -1
							}
						 or {
									ScytheOfEluneSpell(new_moon)
								and {
											ScytheOfEluneCharges() == 3
										 or {
													ScytheOfEluneCharges() == 2
												and SpellChargeCooldown(new_moon) <= ExecuteTime(new_moon) + GCD() * 2
											}
									}
								and AstralPowerDeficit() < AstralPowerCost(new_moon) * -1
							}
					}
			}

			###
			### Stellar Flare Functions
			###
			AddFunction StellarFlare_Use
			{
					Talent(stellar_flare_talent)
				and not SpellCooldown(stellar_flare)
				and not BuffPresent(celestial_alignment_buff)
				and target.InPandemicRange(stellar_flare_debuff stellar_flare)
				and target.TimeToDie() >= 12 + target.DebuffRemaining(stellar_flare_debuff)
				and Enemies() >= 2
				and not IsMoving()
			}

			AddFunction StellarFlare_Use_Other
			{
					Talent(stellar_flare_talent)
				and not SpellCooldown(stellar_flare)
				and target.DebuffPresent(stellar_flare_debuff)
				and DOTTargetCount(stellar_flare_debuff) < MultiDOTTargets()
				and not IsMoving()
				and not {
								Starfall_Use()
							 or {
							 			BuffPresent(the_emerald_dreamcatcher_buff)
							 		and Starsurge_Use_EmeraldDreamcatcher()
							 	}
						}
			}

			###
			### Sunfire Functions
			###
			AddFunction Sunfire_Use
			{
					not SpellCooldown(sunfire)
				and {
							not target.DebuffPresent(sunfire_debuff)
						 or {
						 			Talent(natures_balance_talent)
						 		and target.DebuffRemaining(sunfire_debuff) <= BaseDuration(sunfire_debuff) * 0.15
							}
						 or {
						 			not Talent(natures_balance_talent)
						 		and target.InPandemicRange(sunfire_debuff sunfire)
							}
					}
				and target.TimeToDie() >= 6 + target.DebuffRemaining(sunfire_debuff)
			}

			AddFunction Sunfire_Use_Other
			{
					not SpellCooldown(sunfire)
				and target.DebuffPresent(sunfire_debuff)
				and DOTTargetCount(sunfire_debuff) < Enemies() * 0.7
				and not {
								Starfall_Use()
							 or {
							 			BuffPresent(the_emerald_dreamcatcher_buff)
							 		and Starsurge_Use_EmeraldDreamcatcher()
							 	}
						}
			}

			AddFunction Sunfire_EmeraldDreamcatcher_ExtendDuration
			{
					not SpellCooldown(sunfire)
				and target.InPandemicRange(sunfire_debuff sunfire)
			}

			###
			### Warrior Of Elune Functions
			###
			AddFunction WarriorOfElune_Use
			{
					Talent(warrior_of_elune_talent)
				and not SpellCooldown(warrior_of_elune)
				and Enemies() >= 3
			}

			###
			### Movement Functions
			###
			AddFunction IsMoving
			{
					MovementCheck()
				and {
							not Talent(stellar_drift_talent)
						 or not BuffPresent(starfall_buff)
					}
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

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					if target.RangeCheck(solar_beam) Spell(solar_beam)

					if not target.Classification(worldboss)
					{
						if target.RangeCheck(mighty_bash) Spell(mighty_bash)
						Spell(typhoon)
						Spell(war_stomp)
					}
				}
			}

			###
			### Balance - Rotations
			###
			AddFunction Rotation_NewMoon
			{
				if CheckBoxOn(opt_scythe_spell_clipping) Texture(artifactability_balancedruid_newmoon) Spell(new_moon)
			}

			AddFunction Rotation_HalfMoon
			{
				if CheckBoxOn(opt_scythe_spell_clipping) Texture(artifactability_balancedruid_halfmoon) Spell(half_moon)
			}

			AddFunction Rotation_FullMoon
			{
				if CheckBoxOn(opt_scythe_spell_clipping) Texture(artifactability_balancedruid_fullmoon) Spell(full_moon)
			}

			###
			### Emerald Dreamcatcher Rotation
			AddFunction Rotation_EmeraldDreamcatcher
			{			
				if Starfall_Use() Spell(starfall)

				if CheckBoxOn(opt_celestial_alignment) and Incarnation_Use() Spell(incarnation_chosen_of_elune)
				if CheckBoxOn(opt_celestial_alignment) and CelestialAlignment_Use() Spell(celestial_alignment)

				#Rotation with ED buff present
				if BuffPresent(the_emerald_dreamcatcher_buff)
				{
					if Starsurge_Use_EmeraldDreamcatcher() Spell(starsurge_moonkin)
					
					if Moonfire_Use() Spell(moonfire)
					if Sunfire_Use() Spell(sunfire)

					if Starfall_Use_OnethsOverconfidence_Expire() Spell(starfall)

					if Starsurge_Use_Dump() Spell(starsurge_moonkin)
					
					if SolarWrath_EmeraldDreamcatcher_PrepareDoubleCast() Spell(lunar_strike_balance)

					if LunarStrike_Use_OwlkinFrenzy() and LunarStrike_Use_Empowered() Spell(lunar_strike_balance)

					if LunarStrike_Use_Empowered() and LunarStrike_EmeraldDreamcatcher_BuffActive() and Moonfire_EmeraldDreamcatcher_ExtendDuration() Spell(lunar_strike_balance)
					if SolarWrath_Use_Empowered() and SolarWrath_EmeraldDreamcatcher_BuffActive() and Sunfire_EmeraldDreamcatcher_ExtendDuration() Spell(solar_wrath)

					if FullMoon_Use_MaxCharges() and FullMoon_EmeraldDreamcatcher_BuffActive() Rotation_FullMoon()
					if HalfMoon_Use_MaxCharges() and HalfMoon_EmeraldDreamcatcher_BuffActive() Rotation_HalfMoon()
					if NewMoon_Use_MaxCharges() and NewMoon_EmeraldDreamcatcher_BuffActive() Rotation_NewMoon()

					if SolarWrath_EmeraldDreamcatcher_BuffActive() and SolarWrath_Use_MaxEmpowerment() Spell(solar_wrath)
					if LunarStrike_EmeraldDreamcatcher_BuffActive() and LunarStrike_Use_MaxEmpowerment() Spell(lunar_strike_balance)

					if SolarWrath_Use_Empowered() and SolarWrath_EmeraldDreamcatcher_BuffActive() Spell(solar_wrath)
					if LunarStrike_Use_Empowered() and LunarStrike_EmeraldDreamcatcher_BuffActive() Spell(lunar_strike_balance)

					if Starfall_Use_OnethsOverconfidence() Spell(starfall)

					if FullMoon_Use() and FullMoon_EmeraldDreamcatcher_BuffActive() Rotation_FullMoon()
					if HalfMoon_Use() and HalfMoon_EmeraldDreamcatcher_BuffActive() Rotation_HalfMoon()
					if NewMoon_Use() and NewMoon_EmeraldDreamcatcher_BuffActive() Rotation_NewMoon()
					
					Spell(starsurge_moonkin)
				}
				
				if Starfall_Use_OnethsOverconfidence() Spell(starfall)

				#Rotation without ED buff present or fading soon
				if Starsurge_Use_EmeraldDreamcatcher() Spell(starsurge_moonkin)
				
				if Moonfire_Use() Spell(moonfire)
				if Sunfire_Use() Spell(sunfire)
				if CheckBoxOn(opt_stellar_flare) and StellarFlare_Use() Spell(stellar_flare)
				
				if Starsurge_Use_Dump() Spell(starsurge_moonkin)
				
				if FullMoon_Use_MaxCharges() Rotation_FullMoon()
				if HalfMoon_Use_MaxCharges() Rotation_HalfMoon()
				if NewMoon_Use_MaxCharges() Rotation_NewMoon()

				if FullMoon_Use() and not FullMoon_EmeraldDreamcatcher_Clip() Rotation_FullMoon()
				if HalfMoon_Use() and not HalfMoon_EmeraldDreamcatcher_Clip() Rotation_HalfMoon()
				if NewMoon_Use() and not NewMoon_EmeraldDreamcatcher_Clip() Rotation_NewMoon()
				
				if CheckBoxOn(opt_force_of_nature) and ForceOfNature_Use() Spell(force_of_nature)
				
				if LunarStrike_Use_OwlkinFrenzy() and LunarStrike_Use_Empowered() Spell(lunar_strike_balance)

				if SolarWrath_Use_MaxEmpowerment() Spell(solar_wrath)
				if LunarStrike_Use_MaxEmpowerment() Spell(lunar_strike_balance)
				
				if SolarWrath_Use_Empowered() Spell(solar_wrath)
				if LunarStrike_Use_Empowered() Spell(lunar_strike_balance)
				
				if FullMoon_Use() Rotation_FullMoon()
				if HalfMoon_Use() Rotation_HalfMoon()
				if NewMoon_Use() Rotation_NewMoon()
				
				if LunarStrike_Use_OwlkinFrenzy() Spell(lunar_strike_balance)

				if Moonfire_Use() Spell(moonfire)
				if SolarWrath_Use() Spell(solar_wrath)
				if Sunfire_Use() Spell(sunfire)
				if LunarStrike_Use() Spell(lunar_strike_balance)

				Spell(moonfire)
			}

			###
			### Standard Rotations
			###
			AddFunction Rotation_Standard
			{
				if Moonfire_Use() Spell(moonfire)
				if Sunfire_Use() Spell(sunfire)
				if CheckBoxOn(opt_stellar_flare) and StellarFlare_Use() Spell(stellar_flare)
				
				if Starfall_Use() Spell(starfall)
				if Starfall_Use_OnethsOverconfidence() Spell(starfall)
				
				if Starsurge_Use_Dump() Spell(starsurge_moonkin)
				if Starsurge_Use() Spell(starsurge_moonkin)
				
				if FullMoon_Use_MaxCharges() Rotation_FullMoon()
				if HalfMoon_Use_MaxCharges() Rotation_HalfMoon()
				if NewMoon_Use_MaxCharges() Rotation_NewMoon()
				
				if CheckBoxOn(opt_astral_communion) and AstralCommunion_Use() Spell(astral_communion)
				if CheckBoxOn(opt_warrior_of_elune) and WarriorOfElune_Use() Spell(warrior_of_elune)
				if CheckBoxOn(opt_force_of_nature) and ForceOfNature_Use() Spell(force_of_nature)

				if LunarStrike_Use_OwlkinFrenzy() Spell(lunar_strike_balance)

				if SolarWrath_Use_MaxEmpowerment() Spell(solar_wrath)
				if LunarStrike_Use_MaxEmpowerment() Spell(lunar_strike_balance)

				if SolarWrath_Use_Empowered() Spell(solar_wrath)
				if LunarStrike_Use_Empowered() Spell(lunar_strike_balance)

				if FullMoon_Use() Rotation_FullMoon()
				if HalfMoon_Use() Rotation_HalfMoon()
				if NewMoon_Use() Rotation_NewMoon()

				if LunarStrike_Use_OwlkinFrenzy() Spell(lunar_strike_balance)

				if Moonfire_Use() Spell(moonfire)
				if SolarWrath_Use() Spell(solar_wrath)
				if Sunfire_Use() Spell(sunfire)
				if LunarStrike_Use() Spell(lunar_strike_balance)

				Spell(moonfire)
			}

			###
			### Balance - Main
			###
			AddFunction ShortCD
			{
				# Make sure that the player is in Moonkin form
				if CheckBoxOn(opt_moonkin_form) and not Stance(druid_moonkin_form) Spell(moonkin_form)

				# Make sure player has the correct Blessings of the Ancient Buff
				if BlessingOfElune_Use() or BlessingOfAnshe_Use() Spell(blessing_of_the_ancients)

				# Short Cooldown Spells
				if not CheckBoxOn(opt_stellar_flare) and StellarFlare_Use() Spell(stellar_flare)
				if CheckBoxOn(opt_multi_dot_druid) and not CheckBoxOn(opt_stellar_flare) and StellarFlare_Use_Other() Spell(stellar_flare text=other)

				if FuryOfElune_Use() Spell(fury_of_elune)
				if AstralCommunion_Use() Spell(astral_communion)
				if WarriorOfElune_Use() Spell(warrior_of_elune)
				if ForceOfNature_Use() Spell(force_of_nature)

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_renewal) and Renewal_Use() Spell(renewal)
				if CheckBoxOn(opt_barkskin) and Barkskin_Use() Spell(barkskin)
			}
			
			AddFunction Main
			{
					if LegendaryEquipped(the_emerald_dreamcatcher) Rotation_EmeraldDreamcatcher()
					Rotation_Standard()
			}

			AddFunction MultiDot
			{
					if Moonfire_Use_Other() Spell(moonfire text=other)
					if Sunfire_Use_Other() Spell(sunfire text=other)
					if StellarFlare_Use_Other() Spell(stellar_flare text=other)
			}
			
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
				if Incarnation_Use() Spell(incarnation_chosen_of_elune)
				if CelestialAlignment_Use() Spell(celestial_alignment)

				# Standard Actions
				if CelestialAlignment_Active()
				{
					if LunaEclipse_Potion_Use() and Potion_Use() Item(potion_of_prolonged_power)
					Spell(blood_fury_sp)
					Spell(berserking)
					Rotation_ItemActions()
				}
			}

			###
			### Balance - Main_Precombat
			###
			AddFunction ShortCD_Precombat
			{		
				# Make sure that the player is in Moonkin form
				if CheckBoxOn(opt_moonkin_form) and not Stance(druid_moonkin_form) Spell(moonkin_form)

				# Make sure player has the correct Blessings of the Ancient Buff
				if CheckBoxOn(opt_blessing_ancients) and not BuffPresent(blessing_of_elune_buff) Spell(blessing_of_the_ancients)

				# Short Cooldown Spells
				if not CheckBoxOn(opt_stellar_flare) and StellarFlare_Use() Spell(stellar_flare)
				if CheckBoxOn(opt_multi_dot_druid) and not CheckBoxOn(opt_stellar_flare) and StellarFlare_Use_Other() Spell(stellar_flare text=other)

				if FuryOfElune_Use() Spell(fury_of_elune)
				if AstralCommunion_Use() Spell(astral_communion)
				if WarriorOfElune_Use() Spell(warrior_of_elune)
				if ForceOfNature_Use() Spell(force_of_nature)

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_renewal) and Renewal_Use() Spell(renewal)
				if CheckBoxOn(opt_barkskin) and Barkskin_Use() Spell(barkskin)
			}

			AddFunction Main_Precombat
			{
				if SolarWrath_Use() and LegendaryEquipped(the_emerald_dreamcatcher) Spell(solar_wrath)
				if FullMoon_Use() Rotation_FullMoon()
				if HalfMoon_Use() Rotation_HalfMoon()
				if NewMoon_Use() Rotation_NewMoon()
				if SolarWrath_Use() Spell(solar_wrath)
				Spell(moonfire)
			}

			AddFunction MultiDot_Precombat
			{

			}

			AddFunction CD_Precombat
			{
				# Cooldown Spells
				if Incarnation_Use() Spell(incarnation_chosen_of_elune)
				if CelestialAlignment_Use() Spell(celestial_alignment)

				# Standard Actions
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
				if not InCombat() Main_Precombat()
				Main()
			}

			AddIcon help=aoe
			{
				if not InCombat() Main_Precombat()
				Main()
			}

			AddIcon checkbox=opt_multi_dot help=multidot
			{
				if not InCombat() MultiDot_Precombat()
				MultiDot()
			}

			AddIcon help=cd
			{
				if not InCombat() CD_Precombat()
				CD()
			}
		]];

		OvaleScripts:RegisterScript("DRUID", "balance", name, desc, code, "script");
	end
end