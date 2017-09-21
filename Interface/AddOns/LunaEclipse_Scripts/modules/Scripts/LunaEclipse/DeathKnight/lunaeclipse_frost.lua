local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_deathknight_frost";
		local desc = "LunaEclipse: Frost Death Knight";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DEATHKNIGHT_FROST,
			ScriptAuthor = "LunaEclipse",
			ScriptCredits = "Crystal",
			GuideAuthor = "Totemlord",
			GuideLink = "http://www.icy-veins.com/wow/frost-death-knight-pve-dps-guide",
			WoWVersion = 70200,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Breath of Sindragosa"] = "3320032",
			["Machine Gun"] = "2230013",
			["Solo"] = "2213013",
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
					OPT_FROSTSCYTHE = {
						type = "toggle",
						name = BINDING_NAME_OPT_FROSTSCYTHE,
						desc = functionsConfiguration:getAOETooltip("Frostscythe"),
						arg = "OPT_FROSTSCYTHE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_REMORSELESS_WINTER = {
						type = "toggle",
						name = BINDING_NAME_OPT_REMORSELESS_WINTER,
						desc = functionsConfiguration:getAOETooltip("Remorseless Winter"),
						arg = "OPT_REMORSELESS_WINTER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
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
					OPT_GLACIAL_ADVANCE = {
						type = "toggle",
						name = BINDING_NAME_OPT_GLACIAL_ADVANCE,
						desc = functionsConfiguration:getCooldownTooltip("Glacial Advance"),
						arg = "OPT_GLACIAL_ADVANCE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_BREATH_OF_SINDRAGOSA = {
						type = "toggle",
						name = BINDING_NAME_OPT_BREATH_OF_SINDRAGOSA,
						desc = functionsConfiguration:getCooldownTooltip("Breath of Sindragosa"),
						arg = "OPT_BREATH_OF_SINDRAGOSA",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
					OPT_HORN_OF_WINTER = {
						type = "toggle",
						name = BINDING_NAME_OPT_HORN_OF_WINTER,
						desc = functionsConfiguration:getCooldownTooltip("Horn of Winter"),
						arg = "OPT_HORN_OF_WINTER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_EMPOWER_RUNE_WEAPON = {
						type = "toggle",
						name = BINDING_NAME_OPT_EMPOWER_RUNE_WEAPON,
						desc = functionsConfiguration:getCooldownTooltip("Empower Rune Weapon and Hungering Rune Weapon", "CD"),
						arg = "OPT_EMPOWER_RUNE_WEAPON",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 40,
					},
					OPT_OBLITERATION = {
						type = "toggle",
						name = BINDING_NAME_OPT_OBLITERATION,
						desc = functionsConfiguration:getCooldownTooltip("Obliteration"),
						arg = "OPT_OBLITERATION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_PILLAR_OF_FROST = {
						type = "toggle",
						name = BINDING_NAME_OPT_PILLAR_OF_FROST,
						desc = functionsConfiguration:getCooldownTooltip("Pillar of Frost"),
						arg = "OPT_PILLAR_OF_FROST",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_SINDRAGOSA_FURY = {
						type = "toggle",
						name = BINDING_NAME_OPT_SINDRAGOSA_FURY,
						desc = functionsConfiguration:getCooldownTooltip("Sindragosa's Fury", "CD"),
						arg = "OPT_SINDRAGOSA_FURY",
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
					OPT_ANTI_MAGIC_SHELL = {
						type = "toggle",
						name = BINDING_NAME_OPT_ANTI_MAGIC_SHELL,
						desc = functionsConfiguration:getDefensiveTooltip("Anti-Magic Shell", "ShortCD", "40%"),
						arg = "OPT_ANTI_MAGIC_SHELL",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_ICEBOUND_FORTITUDE = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICEBOUND_FORTITUDE,
						desc = functionsConfiguration:getDefensiveTooltip("Icebound Fortitude", "CD", "40%"),
						arg = "OPT_ICEBOUND_FORTITUDE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
					OPT_DEATH_STRIKE_SUCCOR = {
						type = "toggle",
						name = BINDING_NAME_OPT_DEATH_STRIKE_SUCCOR,
						desc = functionsConfiguration:getDefensiveTooltip("Death Strike", "ShortCD", "40%", "Dark Succor"),
						arg = "OPT_DEATH_STRIKE_SUCCOR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 30,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(ovale_deathknight_spells)
			Include(lunaeclipse_global)

			# Talents
			Define(shattering_strikes_talent 1)
			Define(icy_talons_talent 2)
			Define(murderous_efficiency_talent 3)
			Define(frozen_pulse_talent 5)
			Define(horn_of_winter_talent 6)
			Define(hungering_rune_weapon_talent 8)
			Define(avalanche_talent 9)
			Define(frostscythe_talent 16)
			Define(runic_attenuation_talent 17)
			Define(gathering_storm_talent 18)
			Define(obliteration_talent 19)
			Define(breath_of_sindragosa_talent 20)
			Define(glacial_advance_talent 21)

			# Spells
			Define(blinding_sleet 207167)
				SpellInfo(blinding_sleet cd=60 gcd=1.5)
			Define(hungering_rune_weapon 207127)
				SpellInfo(hungering_rune_weapon cd=180)
				SpellAddBuff(hungering_rune_weapon hungering_rune_weapon_buff=1)

			# Buffs
			Define(gathering_storm_buff 211805)
			Define(hungering_rune_weapon_buff 207127)
				SpellInfo(hungering_rune_weapon_buff duration=12)
			Define(remorseless_winter_buff 196770)
				SpellInfo(remorseless_winter_buff duration=8)

			# Debuffs
			Define(razor_ice_debuff 51714)

			# Artifact
			Define(over_powered_trait 189097)

			# Checkboxes
			AddCheckBox(opt_frostscythe "AOE: Frostscythe")
			AddCheckBox(opt_remorseless_winter "AOE: Remorseless Winter")
			AddCheckBox(opt_breath_of_sindragosa "Cooldown: Breath of Sindragosa")
			AddCheckBox(opt_empower_rune_weapon "Cooldown: Empower Rune Weapon")
			AddCheckBox(opt_glacial_advance "Cooldown: Glacial Advance")
			AddCheckBox(opt_horn_of_winter "Cooldown: Horn of Winter")
			AddCheckBox(opt_obliteration "Cooldown: Obliteration" default)
			AddCheckBox(opt_pillar_of_frost "Cooldown: Pillar of Frost" default)
			AddCheckBox(opt_sindragosa_fury "Cooldown: Sindragosa's Fury" default)
			AddCheckBox(opt_anti_magic_shell "Defensive: Anti-Magic Shell")
			AddCheckBox(opt_icebound_fortitude "Defensive: Icebound Fortitude")
			AddCheckBox(opt_death_strike_succor "Heal: Death Strike (Dark Succor)")

			###
			### Breath of Sindragosa Status
			###
			AddFunction BreathOfSindragosa_Active
			{
					Talent(breath_of_sindragosa_talent)
				and BuffPresent(breath_of_sindragosa_buff)
			}

			###
			### Gathering Storm Status
			###
			AddFunction GatheringStorm_Active
			{
					Talent(gathering_storm_talent)
				and BuffPresent(remorseless_winter_buff)
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(mind_freeze) Spell(mind_freeze)
					if target.Distance() < 8 Spell(arcane_torrent_runicpower)

					if not target.IsRaidBoss()
					{
						if target.Distance() < 12 Spell(blinding_sleet)
						if target.Distance() < 5 Spell(war_stomp)
					}
				}
			}

			###
			### ShortCD Icon Rotations - Functions
			###
			AddFunction ShortCD_AntiMagicShell_Use
			{
					not SpellCooldown(antimagic_shell)
				and HealthPercent() <= 40
			}

			AddFunction ShortCD_DeathStrike_Use_Succor
			{
					not SpellCooldown(death_strike)
				and BuffPresent(dark_succor_buff)
				and HealthPercent() <= 40
			}

			AddFunction ShortCD_MeleeRange_Use
			{
					CheckBoxOn(opt_melee_range)
				and not target.RangeCheck(obliterate)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))

				# Short Cooldown Spells
				if not CheckBoxOn(opt_pillar_of_frost) and Main_PillarOfFrost_Use() Spell(pillar_of_frost)
				if not CheckBoxOn(opt_pillar_of_frost) and Main_PillarOfFrost_Use_ConvergenceOfFates() Spell(pillar_of_frost)
				if not CheckBoxOn(opt_obliteration) and Main_Obliteration_Use() Spell(obliteration)

				# Breath of Sindragosa Active Rotation
				if Rotation_BoSActive_Use()
				{
					if not CheckBoxOn(opt_remorseless_winter) and BoSActive_RemorselessWinter_Use_EbonMartyr() Spell(remorseless_winter)
					if not CheckBoxOn(opt_remorseless_winter) and BoSActive_RemorselessWinter_Use_Rime() Spell(remorseless_winter)
					if not CheckBoxOn(opt_horn_of_winter) and BoSActive_HornOfWinter_Use() Spell(horn_of_winter)
					if not CheckBoxOn(opt_remorseless_winter) and BoSActive_RemorselessWinter_Use() Spell(remorseless_winter)
				}

				# Breath of Sindragosa Inactive Rotation
				if Rotation_BoS_Use()
				{
					if not CheckBoxOn(opt_remorseless_winter) and BoS_RemorselessWinter_Use_GatheringStorm() Spell(remorseless_winter)
					if not CheckBoxOn(opt_breath_of_sindragosa) and BoS_BreathOfSindragosa_Use() Spell(breath_of_sindragosa)
					if not CheckBoxOn(opt_remorseless_winter) and BoS_RemorselessWinter_Use_Rime() Spell(remorseless_winter)
					if not CheckBoxOn(opt_horn_of_winter) and BoS_HornOfWinter_Use() Spell(horn_of_winter)
					if not CheckBoxOn(opt_remorseless_winter) and BoS_RemorselessWinter_Use() Spell(remorseless_winter)
				}
			
				# Gathering Storm - Remorseless Winter Active Rotation
				if Rotation_GatheringStorm_Use()
				{
					if not CheckBoxOn(opt_remorseless_winter) and GatheringStorm_RemorselessWinter_Use() Spell(remorseless_winter)
					if not CheckBoxOn(opt_obliteration) and GatheringStorm_Obliteration_Use() Spell(obliteration)
					if not CheckBoxOn(opt_horn_of_winter) and GatheringStorm_HornOfWinter_Use() Spell(horn_of_winter)
					if not CheckBoxOn(opt_glacial_advance) and GatheringStorm_GlacialAdvance_Use() Spell(glacial_advance)
				}

				# Standard Rotation
				if Rotation_Standard_Use() 
				{
					if not CheckBoxOn(opt_remorseless_winter) and Standard_RemorselessWinter_Use_Rime() Spell(remorseless_winter)
					if not CheckBoxOn(opt_remorseless_winter) and Standard_RemorselessWinter_Use_AOE() Spell(remorseless_winter)
					if not CheckBoxOn(opt_frostscythe) and Standard_Frostscythe_Use_KillingMachine() Spell(frostscythe)
					if not CheckBoxOn(opt_glacial_advance) and Standard_GlacialAdvance_Use_AOE() Spell(glacial_advance)
					if not CheckBoxOn(opt_frostscythe) and Standard_Frostscythe_Use() Spell(frostscythe)
					if not CheckBoxOn(opt_glacial_advance) and Standard_GlacialAdvance_Use() Spell(glacial_advance)
					if not CheckBoxOn(opt_horn_of_winter) and Standard_HornOfWinter_Use() Spell(horn_of_winter)
					if not CheckBoxOn(opt_remorseless_winter) and Standard_RemorselessWinter_Use() Spell(remorseless_winter)
				}

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_death_strike_succor) and ShortCD_DeathStrike_Use_Succor() Spell(death_strike)
				if CheckBoxOn(opt_anti_magic_shell) and ShortCD_AntiMagicShell_Use() Spell(antimagic_shell)
			}

			AddFunction ShortCD_Precombat
			{
				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}

			###
			### Breath of Sindragosa Rotation - Functions
			###
			AddFunction BoS_BreathOfSindragosa_Use
			{
					Talent(breath_of_sindragosa_talent)
				and not SpellCooldown(breath_of_sindragosa)
				and RunicPower() >= 60
				and {
							not LegendaryEquipped(convergence_of_fates)
						 or SpellCooldown(hungering_rune_weapon) < 10
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(hungering_rune_weapon) >= 1
							}
					}
				and Rune() >= 2
			}

			AddFunction BoS_FrostStrike_Use
			{
					not SpellCooldown(frost_strike)
				and SpellCooldown(breath_of_sindragosa) > 15
				and RunicPower() >= 25
			}

			AddFunction BoS_FrostStrike_Use_IcyTalons
			{
					not SpellCooldown(frost_strike)
				and Talent(icy_talons_talent)
				and BuffRemaining(icy_talons_buff) < 1.5
				and SpellCooldown(breath_of_sindragosa) > 6
				and RunicPower() >= 25
			}

			AddFunction BoS_FrostStrike_Use_RunicPower
			{
					not SpellCooldown(frost_strike)
				and	{ 
							RunicPower() >= 70
						 or {
									{
											Talent(gathering_storm_talent)
										and SpellCooldown(remorseless_winter) < 3
										and SpellCooldown(breath_of_sindragosa) > 10
									}
								and Rune() < 5
							}
						 or {
									BuffStacks(gathering_storm_buff) == 10
								and SpellCooldown(breath_of_sindragosa) > 15
							}
					}
				and RunicPower() >= 25
			}

			AddFunction BoS_FrostStrike_Use_Tier19
			{
					not SpellCooldown(frost_strike)
				and RunicPower() >= 90
				and ArmorSetBonus(T19 4)
			}

			AddFunction BoS_HornOfWinter_Use
			{
					Talent(horn_of_winter_talent)
				and not SpellCooldown(horn_of_winter)
				and SpellCooldown(breath_of_sindragosa) > 15
				and RunicPower() <= 70
				and Rune() < 4
			}

			AddFunction BoS_HowlingBlast_Use_Diseases
			{
					not SpellCooldown(howling_blast)
				and not target.DebuffPresent(frost_fever_debuff)
				and {
							BuffPresent(rime_buff)
						 or Rune() >= 1
					}
			}

			AddFunction BoS_HowlingBlast_Use_Rime
			{
					not SpellCooldown(howling_blast)
				and BuffPresent(rime_buff)
				and {
							BuffPresent(remorseless_winter_buff)
						 or SpellCooldown(remorseless_winter) > 1.5
						 or {
									not LegendaryEquipped(perseverance_of_the_ebon_martyr)
								and not Talent(gathering_storm_talent)
							}
					}
			}

			AddFunction BoS_Obliterate_Use
			{
					not SpellCooldown(obliterate)
				and not BuffPresent(rime_buff)
				and {
							not Talent(gathering_storm_talent)
						 or {
									SpellCooldown(remorseless_winter) > 2
								 or Rune() > 4
							}
					}
				and Rune() >= 2
			}

			AddFunction BoS_Obliterate_Use_Runes
			{
					not SpellCooldown(obliterate)
				and not BuffPresent(rime_buff)
				and not {
								Talent(gathering_storm_talent)
							and not {
											SpellCooldown(remorseless_winter) > 2
										 or Rune() > 4
									}
						}
				and Rune() > 3
			}

			AddFunction BoS_RemorselessWinter_Use
			{
					not SpellCooldown(remorseless_winter)
				and SpellCooldown(breath_of_sindragosa) > 10
			}

			AddFunction BoS_RemorselessWinter_Use_GatheringStorm
			{
					not SpellCooldown(remorseless_winter)
				and Talent(gathering_storm_talent)
			}

			AddFunction BoS_RemorselessWinter_Use_Rime
			{
					not SpellCooldown(remorseless_winter)
				and BuffPresent(rime_buff)
				and LegendaryEquipped(perseverance_of_the_ebon_martyr)
			}

			###
			### Breath of Sindragosa Rotation - Usage
			###
			AddFunction Rotation_BoS_Use
			{
					Talent(breath_of_sindragosa_talent)
				and not BreathOfSindragosa_Active()
			}

			###
			### Breath of Sindragosa Rotation
			###
			AddFunction Rotation_BoS
			{
				if BoS_FrostStrike_Use_IcyTalons() Spell(frost_strike)
				if CheckBoxOn(opt_remorseless_winter) and BoS_RemorselessWinter_Use_GatheringStorm() Spell(remorseless_winter)
				if BoS_HowlingBlast_Use_Diseases() Spell(howling_blast)
				if CheckBoxOn(opt_breath_of_sindragosa) and BoS_BreathOfSindragosa_Use() Spell(breath_of_sindragosa)
				if BoS_FrostStrike_Use_Tier19() Spell(frost_strike)
				if CheckBoxOn(opt_remorseless_winter) and BoS_RemorselessWinter_Use_Rime() Spell(remorseless_winter)
				if BoS_HowlingBlast_Use_Rime() Spell(howling_blast)
				if BoS_Obliterate_Use_Runes() Spell(obliterate)
				if BoS_FrostStrike_Use_RunicPower() Spell(frost_strike)
				if BoS_Obliterate_Use() Spell(obliterate)
				if CheckBoxOn(opt_horn_of_winter) and BoS_HornOfWinter_Use() Spell(horn_of_winter)
				if BoS_FrostStrike_Use() Spell(frost_strike)
				if CheckBoxOn(opt_remorseless_winter) and BoS_RemorselessWinter_Use() Spell(remorseless_winter)
			}

			###
			### BoSActive Rotation - Functions
			###
			AddFunction BoSActive_EmpowerRuneWeapon_Use
			{
					not Talent(hungering_rune_weapon_talent)
				and {
							not SpellCooldown(empower_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(empower_rune_weapon) >= 1
							}
					}
				and RunicPower() < 20
			}

			AddFunction BoSActive_HornOfWinter_Use
			{
					Talent(horn_of_winter_talent)
				and not SpellCooldown(horn_of_winter)
				and RunicPower() < 70
				and not BuffPresent(hungering_rune_weapon_buff)
				and Rune() < 5
			}

			AddFunction BoSActive_HowlingBlast_Use_Diseases
			{
					not SpellCooldown(howling_blast)
				and not target.DebuffPresent(frost_fever_debuff)
				and {
							BuffPresent(rime_buff)
						 or Rune() >= 1
					}
			}

			AddFunction BoSActive_HowlingBlast_Use_Rime
			{
					not SpellCooldown(howling_blast)
				and BuffPresent(rime_buff)
			}

			AddFunction BoSActive_HowlingBlast_Use_Tier19
			{
					not SpellCooldown(howling_blast)
				and {
							{
									RunicPower() >= 20
								and ArmorSetBonus(T19 4)
							}
						 or RunicPower() >= 30
					}
				and BuffPresent(rime_buff)
			}

			AddFunction BoSActive_HungeringRuneWeapon_Use
			{
					Talent(hungering_rune_weapon_talent)
				and {
							not SpellCooldown(hungering_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(hungering_rune_weapon) >= 1
							}
					}
				and RunicPower() < 35
				and not BuffPresent(hungering_rune_weapon_buff)
				and Rune() < 1
			}

			AddFunction BoSActive_HungeringRuneWeapon_Use_ConvergenceOfFates
			{
					Talent(hungering_rune_weapon_talent)
				and {
							not SpellCooldown(hungering_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(hungering_rune_weapon) >= 1
							}
					}
				and LegendaryEquipped(convergence_of_fates)
				and {
							RunicPower() < 30
						 or {
									RunicPower() < 70
								and Talent(gathering_storm_talent)
							}
						 or {
									Talent(horn_of_winter_talent)
								and Talent(gathering_storm_talent)
								and RunicPower() < 55
							}
					}
				and not BuffPresent(hungering_rune_weapon_buff)
				and Rune() < 2
			}

			AddFunction BoSActive_HungeringRuneWeapon_Use_RunicAttenuation
			{
					Talent(hungering_rune_weapon_talent)
				and {
							not SpellCooldown(hungering_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(hungering_rune_weapon) >= 1
							}
					}
				and Talent(runic_attenuation_talent)
				and RunicPower() < 30
				and not BuffPresent(hungering_rune_weapon_buff)
				and Rune() < 2
			}

			AddFunction BoSActive_HungeringRuneWeapon_Use_Starved
			{
					Talent(hungering_rune_weapon_talent)
				and {
							not SpellCooldown(hungering_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(hungering_rune_weapon) >= 1
							}
					}
				and RunicPower() < 25
				and not BuffPresent(hungering_rune_weapon_buff)
				and Rune() < 2
			}

			AddFunction BoSActive_Obliterate_Use
			{
					not SpellCooldown(obliterate)
				and {
							RunicPower() <= 75
						 or Rune() > 3
					}
				and Rune() >= 2
			}

			AddFunction BoSActive_RemorselessWinter_Use
			{
					not SpellCooldown(remorseless_winter)
				and {
							Talent(gathering_storm_talent)
						 or not ArmorSetBonus(T19 4)
						 or RunicPower() < 30
					}
			}

			AddFunction BoSActive_RemorselessWinter_Use_EbonMartyr
			{
					not SpellCooldown(remorseless_winter)
				and RunicPower() >= 30
				and {
							{
									BuffPresent(rime_buff)
								and LegendaryEquipped(perseverance_of_the_ebon_martyr)
							}
						 or {
									Talent(gathering_storm_talent)
								and {
											BuffRemaining(remorseless_winter_buff) < GCD()
										 or not BuffPresent(remorseless_winter_buff)
									}
							}
					}
			}

			AddFunction BoSActive_RemorselessWinter_Use_Rime
			{
					not SpellCooldown(remorseless_winter)
				and {
							{
									BuffPresent(rime_buff)
								and LegendaryEquipped(perseverance_of_the_ebon_martyr)
							}
						 or {
									Talent(gathering_storm_talent)
								and {
											BuffRemaining(remorseless_winter_buff) < GCD()
										 or not BuffPresent(remorseless_winter_buff)
									}
							}
					}
			}

			###
			### BoSActive Rotation - Usage
			###
			AddFunction Rotation_BoSActive_Use
			{
					Talent(breath_of_sindragosa_talent)
				and BreathOfSindragosa_Active()
			}

			###
			### BoSActive Rotation
			###
			AddFunction Rotation_BoSActive
			{
				if BoSActive_HowlingBlast_Use_Diseases() Spell(howling_blast)
				if CheckBoxOn(opt_remorseless_winter) and BoSActive_RemorselessWinter_Use_EbonMartyr() Spell(remorseless_winter)
				if BoSActive_HowlingBlast_Use_Tier19() Spell(howling_blast)
				if BoSActive_Obliterate_Use() Spell(obliterate)
				if CheckBoxOn(opt_remorseless_winter) and BoSActive_RemorselessWinter_Use_Rime() Spell(remorseless_winter)
				if BoSActive_HowlingBlast_Use_Rime() Spell(howling_blast)
				if CheckBoxOn(opt_horn_of_winter) and BoSActive_HornOfWinter_Use() Spell(horn_of_winter)
				if CheckBoxOn(opt_empower_rune_weapon) and BoSActive_HungeringRuneWeapon_Use_ConvergenceOfFates() Spell(hungering_rune_weapon)
				if CheckBoxOn(opt_empower_rune_weapon) and BoSActive_HungeringRuneWeapon_Use_RunicAttenuation() Spell(hungering_rune_weapon)
				if CheckBoxOn(opt_empower_rune_weapon) and BoSActive_HungeringRuneWeapon_Use() Spell(hungering_rune_weapon)
				if CheckBoxOn(opt_empower_rune_weapon) and BoSActive_HungeringRuneWeapon_Use_Starved() Spell(hungering_rune_weapon)
				if CheckBoxOn(opt_empower_rune_weapon) and BoSActive_EmpowerRuneWeapon_Use() Spell(empower_rune_weapon)
				if CheckBoxOn(opt_remorseless_winter) and BoSActive_RemorselessWinter_Use() Spell(remorseless_winter)
			}

			###
			### Gathering Storm Rotation - Functions
			###
			AddFunction GatheringStorm_EmpowerRuneWeapon_Use
			{
					not Talent(hungering_rune_weapon_talent)
				and {
							not SpellCooldown(empower_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(empower_rune_weapon) >= 1
							}
					}
			}

			AddFunction GatheringStorm_FrostStrike_Use
			{
					not SpellCooldown(frost_strike)
				and RunicPower() >= 25
			}

			AddFunction GatheringStorm_FrostStrike_Use_IcyTalons
			{
					not SpellCooldown(frost_strike)
				and BuffRemaining(icy_talons_buff) < 1.5
				and Talent(icy_talons_talent)
				and RunicPower() >= 25
			}

			AddFunction GatheringStorm_FrostStrike_Use_RunicPower
			{
					not SpellCooldown(frost_strike)
				and {
							RunicPower() > 80
						 or {
									BuffPresent(obliteration_buff)
								and not BuffPresent(killing_machine_buff)
							}
					}
				and RunicPower() >= 25
			}

			AddFunction GatheringStorm_GlacialAdvance_Use
			{
					Talent(glacial_advance_talent)
				and not SpellCooldown(glacial_advance)
			}

			AddFunction GatheringStorm_HornOfWinter_Use
			{
					Talent(horn_of_winter_talent)
				and not SpellCooldown(horn_of_winter)
				and RunicPower() < 70
				and not BuffPresent(hungering_rune_weapon_buff)
				and Rune() <= 4
			}

			AddFunction GatheringStorm_HowlingBlast_Use_Diseases
			{
					not SpellCooldown(howling_blast)
				and not target.DebuffPresent(frost_fever_debuff)
				and {
							BuffPresent(rime_buff)
						 or Rune() >= 1
					}
			}

			AddFunction GatheringStorm_HowlingBlast_Use_Rime
			{
					not SpellCooldown(howling_blast)
				and BuffPresent(rime_buff)
				and not {
								BuffPresent(obliteration_buff)
							and Enemies() < 2
						}	
			}

			AddFunction GatheringStorm_HungeringRuneWeapon_Use
			{
					Talent(hungering_rune_weapon_talent)
				and not BuffPresent(hungering_rune_weapon_buff)
				and {
							not SpellCooldown(hungering_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(hungering_rune_weapon) >= 1
							}
					}
			}

			AddFunction GatheringStorm_Obliterate_Use
			{
					not SpellCooldown(obliterate)
				and {
							{
									BuffPresent(obliteration_buff)
								and Rune() >= 1
							}
						 or Rune() >= 2
					}
			}

			AddFunction GatheringStorm_Obliterate_Use_KillingMachine
			{
					not SpellCooldown(obliterate)
				and {
							Rune() > 3
						 or BuffPresent(killing_machine_buff)
						 or BuffPresent(obliteration_buff)
					}
				and {
							{
									BuffPresent(obliteration_buff)
								and Rune() >= 1
							}
						 or Rune() >= 2
					}
			}

			AddFunction GatheringStorm_Obliteration_Use
			{
					Talent(obliteration_talent)
				and not SpellCooldown(obliteration)
				and {
							not Talent(frozen_pulse_talent)
						 or {
									Rune() >= 2
								and RunicPower() > 25
							}
					}
			}

			AddFunction GatheringStorm_RemorselessWinter_Use
			{
					not SpellCooldown(remorseless_winter)
			}

			###
			### Gathering Storm Rotation - Usage
			###
			AddFunction Rotation_GatheringStorm_Use
			{
					not Talent(breath_of_sindragosa_talent)
				and GatheringStorm_Active()
			}

			###
			### Gathering Storm Rotation
			###
			AddFunction Rotation_GatheringStorm
			{
				if GatheringStorm_FrostStrike_Use_IcyTalons() Spell(frost_strike)
				if CheckBoxOn(opt_remorseless_winter) and GatheringStorm_RemorselessWinter_Use() Spell(remorseless_winter)
				if GatheringStorm_HowlingBlast_Use_Diseases() Spell(howling_blast)
				if GatheringStorm_HowlingBlast_Use_Rime() Spell(howling_blast)
				if CheckBoxOn(opt_obliteration) and GatheringStorm_Obliteration_Use() Spell(obliteration)
				if GatheringStorm_Obliterate_Use_KillingMachine() Spell(obliterate)
				if GatheringStorm_FrostStrike_Use_RunicPower() Spell(frost_strike)
				if GatheringStorm_Obliterate_Use() Spell(obliterate)
				if CheckBoxOn(opt_horn_of_winter) and GatheringStorm_HornOfWinter_Use() Spell(horn_of_winter)
				if CheckBoxOn(opt_glacial_advance) and GatheringStorm_GlacialAdvance_Use() Spell(glacial_advance)
				if GatheringStorm_FrostStrike_Use() Spell(frost_strike)
				if CheckBoxOn(opt_empower_rune_weapon) and GatheringStorm_HungeringRuneWeapon_Use() Spell(hungering_rune_weapon)
				if CheckBoxOn(opt_empower_rune_weapon) and GatheringStorm_EmpowerRuneWeapon_Use() Spell(empower_rune_weapon)
			}

			###
			### Standard Rotation - Functions
			###
			AddFunction Standard_EmpowerRuneWeapon_Use
			{
					not Talent(hungering_rune_weapon_talent)
				and {
							not SpellCooldown(empower_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(empower_rune_weapon) >= 1
							}
					}
			}

			AddFunction Standard_Frostscythe_Use
			{
					Talent(frostscythe_talent)
				and not SpellCooldown(frostscythe)
				and Enemies() >= 3
				and Rune() >= 1
			}

			AddFunction Standard_Frostscythe_Use_KillingMachine
			{
					Talent(frostscythe_talent)
				and not SpellCooldown(frostscythe)
				and {
							BuffPresent(killing_machine_buff)
						and Enemies() >= 2
					}
				and Rune() >= 1
			}

			AddFunction Standard_FrostStrike_Use
			{
					not SpellCooldown(frost_strike)
				and RunicPower() >= 25
			}

			AddFunction Standard_FrostStrike_Use_GatheringStorm
			{
					not SpellCooldown(frost_strike)
				and Talent(gathering_storm_talent)
				and Talent(murderous_efficiency_talent)
				and {
							ArmorSetBonus(T19 2)
						 or ArmorSetBonus(T19 4)
					}
				and RunicPower() >= 25
			}

			AddFunction Standard_FrostStrike_Use_IcyTalons
			{
					not SpellCooldown(frost_strike)
				and not Talent(shattering_strikes_talent)
				and {
							BuffRemaining(icy_talons_buff) < 1.5
						and Talent(icy_talons_talent)
					}
				and RunicPower() >= 25
			}

			AddFunction Standard_FrostStrike_Use_Obliteration
			{
					not SpellCooldown(frost_strike)
				and BuffPresent(obliteration_buff)
				and not BuffPresent(killing_machine_buff)
				and RunicPower() >= 25
			}

			AddFunction Standard_FrostStrike_Use_RunicPower
			{
					not SpellCooldown(frost_strike)
				and RunicPowerDeficit() <= 10
			}

			AddFunction Standard_FrostStrike_Use_ShatteringStrikes
			{
					not SpellCooldown(frost_strike)
				and Talent(shattering_strikes_talent)
				and target.DebuffStacks(razor_ice_debuff) == 5
				and RunicPower() >= 25
			}

			AddFunction Standard_FrostStrike_Use_Tier19
			{
					not SpellCooldown(frost_strike)
				and {
							Talent(horn_of_winter_talent)
						 or Talent(hungering_rune_weapon_talent)
					}
				and {
							ArmorSetBonus(T19 2)
						 or ArmorSetBonus(T19 4)
					}
				and RunicPower() >= 25
			}

			AddFunction Standard_GlacialAdvance_Use
			{
					Talent(glacial_advance_talent)
				and not SpellCooldown(glacial_advance)
			}

			AddFunction Standard_GlacialAdvance_Use_AOE
			{
					Talent(glacial_advance_talent)
				and not SpellCooldown(glacial_advance)
				and Enemies() >= 2
			}

			AddFunction Standard_HornOfWinter_Use
			{
					Talent(horn_of_winter_talent)
				and not SpellCooldown(horn_of_winter)
				and not BuffPresent(hungering_rune_weapon_buff)
				and RunicPower() <= 80
				and Rune() <= 4
			}

			AddFunction Standard_HowlingBlast_Use_Diseases
			{
					not SpellCooldown(howling_blast)
				and not target.DebuffPresent(frost_fever_debuff)
				and {
							BuffPresent(rime_buff)
						 or Rune() >= 1
					}
			}

			AddFunction Standard_HowlingBlast_Use_Rime
			{
					not SpellCooldown(howling_blast)
				and BuffPresent(rime_buff)
				and not {
								BuffPresent(obliteration_buff)
							and Enemies() < 2
						}
				and not {
								LegendaryEquipped(perseverance_of_the_ebon_martyr)
							and Talent(gathering_storm_talent)
						}
			}

			AddFunction Standard_HowlingBlast_Use_Rime_EbonMartyr
			{
					not SpellCooldown(howling_blast)
				and BuffPresent(rime_buff)
				and not {
								BuffPresent(obliteration_buff)
							and Enemies() < 2
						}
				and LegendaryEquipped(perseverance_of_the_ebon_martyr)
				and Talent(gathering_storm_talent)
				and {
							target.DebuffPresent(perseverance_of_the_ebon_martyr_debuff)
						or SpellCooldown(remorseless_winter) > 3
					}
			}

			AddFunction Standard_HungeringRuneWeapon_Use
			{
					Talent(hungering_rune_weapon_talent)
				and {
							not SpellCooldown(hungering_rune_weapon)
						 or {
									LegendaryEquipped(seal_of_necrofantasia)
								and SpellCharges(hungering_rune_weapon) >= 1
							}
					}
				and not BuffPresent(hungering_rune_weapon_buff)
			}

			AddFunction Standard_Obliterate_Use
			{
					not SpellCooldown(obliterate)
				and {
							{
									BuffPresent(obliteration_buff)
								and Rune() >= 1
							}
						 or Rune() >= 2
					}
			}

			AddFunction Standard_Obliterate_Use_KillingMachine
			{
					not SpellCooldown(obliterate)
				and BuffPresent(killing_machine_buff)
				and {
							{
									BuffPresent(obliteration_buff)
								and Rune() >= 1
							}
						 or Rune() >= 2
					}
			}

			AddFunction Standard_Obliterate_Use_KoltirasNewfoundWill
			{
					not SpellCooldown(obliterate)
				and not BuffPresent(obliteration_buff)
				and {
							LegendaryEquipped(koltiras_newfound_will)
						and Talent(frozen_pulse_talent)
						and {
									ArmorSetBonus(T19 2)
								 or ArmorSetBonus(T19 4)
							}
					}
				and Rune() >= 2
			}

			AddFunction Standard_RemorselessWinter_Use
			{
					not SpellCooldown(remorseless_winter)
				and Talent(frozen_pulse_talent)
			}

			AddFunction Standard_RemorselessWinter_Use_AOE
			{
					not SpellCooldown(remorseless_winter)
				and Enemies() >= 2
				and not {
								Talent(frostscythe_talent)
							and BuffPresent(killing_machine_buff)
							and Enemies() >= 2
						}
			}

			AddFunction Standard_RemorselessWinter_Use_Rime
			{
					not SpellCooldown(remorseless_winter)
				and {
							{
									BuffPresent(rime_buff)
								and LegendaryEquipped(perseverance_of_the_ebon_martyr)
								and not {
												BuffPresent(obliteration_buff)
											and Enemies() < 2
										}
							}
						 or Talent(gathering_storm_talent)
					}
			}

			###
			### Standard Rotation - Usage
			###
			AddFunction Rotation_Standard_Use
			{
					not Talent(breath_of_sindragosa_talent)
				and not GatheringStorm_Active()
			}

			###
			### Standard Rotation
			###
			AddFunction Rotation_Standard
			{
				if Standard_FrostStrike_Use_IcyTalons() Spell(frost_strike)
				if Standard_FrostStrike_Use_ShatteringStrikes() Spell(frost_strike)
				if Standard_HowlingBlast_Use_Diseases() Spell(howling_blast)
				if CheckBoxOn(opt_remorseless_winter) and Standard_RemorselessWinter_Use_Rime() Spell(remorseless_winter)
				if Standard_HowlingBlast_Use_Rime() Spell(howling_blast)
				if Standard_HowlingBlast_Use_Rime_EbonMartyr() Spell(howling_blast)
				if Standard_Obliterate_Use_KoltirasNewfoundWill() Spell(obliterate)
				if Standard_FrostStrike_Use_RunicPower() Spell(frost_strike)
				if Standard_FrostStrike_Use_Obliteration() Spell(frost_strike)
				if CheckBoxOn(opt_remorseless_winter) and Standard_RemorselessWinter_Use_AOE() Spell(remorseless_winter)
				if CheckBoxOn(opt_frostscythe) and Standard_Frostscythe_Use_KillingMachine() Spell(frostscythe)
				if CheckBoxOn(opt_glacial_advance) and Standard_GlacialAdvance_Use_AOE() Spell(glacial_advance)
				if CheckBoxOn(opt_frostscythe) and Standard_Frostscythe_Use() Spell(frostscythe)
				if Standard_Obliterate_Use_KillingMachine() Spell(obliterate)
				if Standard_FrostStrike_Use_GatheringStorm() Spell(frost_strike)
				if Standard_FrostStrike_Use_Tier19() Spell(frost_strike)
				if Standard_Obliterate_Use() Spell(obliterate)
				if CheckBoxOn(opt_glacial_advance) and Standard_GlacialAdvance_Use() Spell(glacial_advance)
				if CheckBoxOn(opt_horn_of_winter) and Standard_HornOfWinter_Use() Spell(horn_of_winter)
				if Standard_FrostStrike_Use() Spell(frost_strike)
				if CheckBoxOn(opt_remorseless_winter) and Standard_RemorselessWinter_Use() Spell(remorseless_winter)
				if CheckBoxOn(opt_empower_rune_weapon) and Standard_EmpowerRuneWeapon_Use() Spell(empower_rune_weapon)
				if CheckBoxOn(opt_empower_rune_weapon) and Standard_HungeringRuneWeapon_Use() Spell(hungering_rune_weapon)
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_DraughtOfSouls_Use
			{
					LegendaryEquipped(draught_of_souls)
			}

			AddFunction Main_Obliteration_Use
			{
					Talent(obliteration_talent)
				and not SpellCooldown(obliteration)
				and {
							not Talent(frozen_pulse_talent)
						 or {
									Rune() >= 2
								and RunicPower() > 25
							}
					}
				and not Talent(gathering_storm_talent)
			}

			AddFunction Main_PillarOfFrost_Use
			{
					not SpellCooldown(pillar_of_frost)
				and {
							not LegendaryEquipped(convergence_of_fates)
						 or not Talent(breath_of_sindragosa_talent)
					}
			}

			AddFunction Main_PillarOfFrost_Use_ConvergenceOfFates
			{
					not SpellCooldown(pillar_of_frost)
				and LegendaryEquipped(convergence_of_fates)
				and Talent(breath_of_sindragosa_talent)
				and {
							{
									RunicPower() >= 50
								and {
											SpellCharges(hungering_rune_weapon) >= 1
										 or SpellCooldown(hungering_rune_weapon) < 10
									}
							}
						 or SpellCooldown(breath_of_sindragosa) > 20
					}
			}

			AddFunction Main_SindragosasFury_Use
			{
					SpellKnown(sindragosas_fury)
				and not SpellCooldown(sindragosas_fury)
				and not LegendaryEquipped(consorts_cold_core)
				and BuffPresent(pillar_of_frost_buff)
				and {
							BuffPresent(unholy_strength_buff)
						 or {
									BuffRemaining(pillar_of_frost_buff) < 3
								and target.TimeToDie() < 60
							}
					}
				and target.DebuffStacks(razor_ice_debuff) == 5
				and not BuffPresent(obliteration_buff)
			}

			AddFunction Main_SindragosasFury_Use_ConsortsColdCore
			{
					SpellKnown(sindragosas_fury)
				and not SpellCooldown(sindragosas_fury)
				and LegendaryEquipped(consorts_cold_core)
				and BuffPresent(unholy_strength_buff)
				and SpellCooldown(pillar_of_frost) > 20
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				if CheckBoxOn(opt_pillar_of_frost) and Main_PillarOfFrost_Use() Spell(pillar_of_frost)
				if CheckBoxOn(opt_pillar_of_frost) and Main_PillarOfFrost_Use_ConvergenceOfFates() Spell(pillar_of_frost)
				if CheckBoxOn(opt_draught_of_souls) and Main_DraughtOfSouls_Use() Item(draught_of_souls)
				if CheckBoxOn(opt_sindragosa_fury) and Main_SindragosasFury_Use() Spell(sindragosas_fury)
				if CheckBoxOn(opt_sindragosa_fury) and Main_SindragosasFury_Use_ConsortsColdCore() Spell(sindragosas_fury)
				if CheckBoxOn(opt_obliteration) and Main_Obliteration_Use() Spell(obliteration)

				# Breath of Sindragosa Active Rotation
				if Rotation_BoSActive_Use() Rotation_BoSActive()

				# Breath of Sindragosa Inactive Rotation
				if Rotation_BoS_Use() Rotation_BoS()

				# Gathering Storm - Remorseless Winter Active Rotation
				if Rotation_GatheringStorm_Use() Rotation_GatheringStorm()

				# Standard Rotation
				if Rotation_Standard_Use() Rotation_Standard()
			}

			AddFunction Main_Precombat
			{
			}

			###
			### CD Icon Rotations - Functions
			###
			AddFunction CD_ArcaneTorrent_Use
			{
					Race(BloodElf)
				and not SpellCooldown(arcane_torrent_runicpower)
				and RunicPowerDeficit() > 20
				and not Talent(breath_of_sindragosa_talent)
			}

			AddFunction CD_ArcaneTorrent_Use_BreathOfSindragosa
			{
					Race(BloodElf)
				and not SpellCooldown(arcane_torrent_runicpower)
				and Talent(breath_of_sindragosa_talent)
				and BreathOfSindragosa_Active()
				and RunicPower() < 30
				and Rune() < 2
			}

			AddFunction CD_Berserking_Use
			{
					Race(Troll)
				and not SpellCooldown(berserking)
				and BuffPresent(pillar_of_frost_buff)
			}

			AddFunction CD_BloodFury_Use
			{
					Race(Orc)
				and not SpellCooldown(blood_fury_ap)
				and BuffPresent(pillar_of_frost_buff)
			}

			AddFunction CD_IceboundFortitude_Use
			{
					not SpellCooldown(icebound_fortitude)
				and HealthPercent() <= 40
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and BuffPresent(pillar_of_frost_buff)
						and {
									not Talent(breath_of_sindragosa_talent)
								 or not SpellCooldown(breath_of_sindragosa)
							}
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 60
			}

			###
			### CD Icon Rotations
			###
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
				if not CheckBoxOn(opt_draught_of_souls) and Main_DraughtOfSouls_Use() Item(draught_of_souls)
				if not CheckBoxOn(opt_sindragosa_fury) and Main_SindragosasFury_Use() Spell(sindragosas_fury)
				if not CheckBoxOn(opt_sindragosa_fury) and Main_SindragosasFury_Use_ConsortsColdCore() Spell(sindragosas_fury)

				# Breath of Sindragosa Active Rotation
				if Rotation_BoSActive_Use()
				{
					if not CheckBoxOn(opt_empower_rune_weapon) and BoSActive_HungeringRuneWeapon_Use_ConvergenceOfFates() Spell(hungering_rune_weapon)
					if not CheckBoxOn(opt_empower_rune_weapon) and BoSActive_HungeringRuneWeapon_Use_RunicAttenuation() Spell(hungering_rune_weapon)
					if not CheckBoxOn(opt_empower_rune_weapon) and BoSActive_HungeringRuneWeapon_Use() Spell(hungering_rune_weapon)
					if not CheckBoxOn(opt_empower_rune_weapon) and BoSActive_HungeringRuneWeapon_Use_Starved() Spell(hungering_rune_weapon)
					if not CheckBoxOn(opt_empower_rune_weapon) and BoSActive_EmpowerRuneWeapon_Use() Spell(empower_rune_weapon)
				}

				# Gathering Storm - Remorseless Winter Active Rotation
				if Rotation_GatheringStorm_Use()
				{
					if not CheckBoxOn(opt_empower_rune_weapon) and GatheringStorm_HungeringRuneWeapon_Use() Spell(hungering_rune_weapon)
					if not CheckBoxOn(opt_empower_rune_weapon) and GatheringStorm_EmpowerRuneWeapon_Use() Spell(empower_rune_weapon)
				}

				# Standard Rotation
				if Rotation_Standard_Use()
				{
					if not CheckBoxOn(opt_empower_rune_weapon) and Standard_EmpowerRuneWeapon_Use() Spell(empower_rune_weapon)
					if not CheckBoxOn(opt_empower_rune_weapon) and Standard_HungeringRuneWeapon_Use() Spell(hungering_rune_weapon)
				}

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() and Talent(breath_of_sindragosa_talent) Item(potion_of_prolonged_power)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_icebound_fortitude) and CD_IceboundFortitude_Use() Spell(icebound_fortitude)

				# Standard Actions
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_runicpower)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use_BreathOfSindragosa() Spell(arcane_torrent_runicpower)
				if CD_BloodFury_Use() Spell(blood_fury_ap)
				if CD_Berserking_Use() Spell(berserking)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Potion
				if LunaEclipse_Potion_Use() and Talent(breath_of_sindragosa_talent) Item(potion_of_prolonged_power)
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

			AddIcon help=cd
			{
				if not InCombat() CD_Precombat()
				CD()
			}
		]];

		OvaleScripts:RegisterScript("DEATHKNIGHT", "frost", name, desc, code, "script");
	end
end