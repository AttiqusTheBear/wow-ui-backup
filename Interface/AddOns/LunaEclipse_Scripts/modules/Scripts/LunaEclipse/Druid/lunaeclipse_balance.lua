local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_druid_balance";
		local desc = "LunaEclipse: Balance Druid";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DRUID_BALANCE,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Xirips",
			GuideLink = "http://www.icy-veins.com/wow/balance-druid-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "3330233",
			["Raiding (AOE)"] = "2330112",
			["Dungeons / Mythic+"] = "3330212",
			["Solo / World Quests"] = "1230233",
			["Easy Mode"] = "3230233",
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
					OPT_STARFALL = {
						type = "toggle",
						name = BINDING_NAME_OPT_STARFALL,
						desc = functionsConfiguration:getAOETooltip("Starfall"),
						arg = "OPT_STARFALL",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_STELLAR_FLARE = {
						type = "toggle",
						name = BINDING_NAME_OPT_STELLAR_FLARE,
						desc = functionsConfiguration:getAOETooltip("Stellar Flare"),
						arg = "OPT_STELLAR_FLARE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
				},
			},
			settingsBuffs = {
				type = "group",
				name = BINDING_HEADER_BUFFS_DEBUFFS,
				inline = true,
				order = 20,
				args = {
					OPT_BLESSING_ANCIENTS = {
						type = "toggle",
						name = BINDING_NAME_OPT_BLESSING_ANCIENTS,
						desc = functionsConfiguration:getBuffTooltip("Blessing of Elune"),
						arg = "OPT_BLESSING_ANCIENTS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_MOONKIN_FORM = {
						type = "toggle",
						name = BINDING_NAME_OPT_MOONKIN_FORM,
						desc = functionsConfiguration:getBuffTooltip("Moonkin Form"),
						arg = "OPT_MOONKIN_FORM",
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
					OPT_ASTRAL_COMMUNION = {
						type = "toggle",
						name = BINDING_NAME_OPT_ASTRAL_COMMUNION,
						desc = functionsConfiguration:getCooldownTooltip("Astral Communion"),
						arg = "OPT_ASTRAL_COMMUNION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_CELESTIAL_ALIGNMENT = {
						type = "toggle",
						name = BINDING_NAME_OPT_CELESTIAL_ALIGNMENT,
						desc = functionsConfiguration:getCooldownTooltip("Celestial Alignment and Incarnation: Chosen of Elune", "CD"),
						arg = "OPT_CELESTIAL_ALIGNMENT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
					OPT_FORCE_OF_NATURE = {
						type = "toggle",
						name = BINDING_NAME_OPT_FORCE_OF_NATURE,
						desc = functionsConfiguration:getCooldownTooltip("Force of Nature"),
						arg = "OPT_FORCE_OF_NATURE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_FURY_OF_ELUNE = {
						type = "toggle",
						name = BINDING_NAME_OPT_FURY_OF_ELUNE,
						desc = functionsConfiguration:getCooldownTooltip("Fury of Elune"),
						arg = "OPT_FURY_OF_ELUNE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_WARRIOR_OF_ELUNE = {
						type = "toggle",
						name = BINDING_NAME_OPT_WARRIOR_OF_ELUNE,
						desc = functionsConfiguration:getCooldownTooltip("Warrior of Elune"),
						arg = "OPT_WARRIOR_OF_ELUNE",
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
					OPT_BARKSKIN = {
						type = "toggle",
						name = BINDING_NAME_OPT_BARKSKIN,
						desc = functionsConfiguration:getDefensiveTooltip("Barkskin", "ShortCD", "40%"),
						arg = "OPT_BARKSKIN",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_RENEWAL = {
						type = "toggle",
						name = BINDING_NAME_OPT_RENEWAL,
						desc = functionsConfiguration:getDefensiveTooltip("Renewal", "ShortCD", "40%"),
						arg = "OPT_RENEWAL",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
				},
			},
			settingsSpecial = {
				type = "group",
				name = BINDING_HEADER_SPECIAL,
				inline = true,
				order = 60,
				args = {
					OPT_SCYTHE_SPELL_CLIPPING = {
						type = "toggle",
						name = BINDING_NAME_OPT_SCYTHE_SPELL_CLIPPING,
						desc = string.format("%s%s%s%s%s", "This allows Ovale to show the next Scythe of Elune spell to cast after the current is finished casting, this allows the player to clip the spell.", "\n\n", "This is primarily needed for players using the Emerald Dreamcatcher legendary, however this option will work whether you have the legendary or not.", "\n\n",  "Please note that Ovale will not show Keybinds, Range Indicator or Spell Cooldown information for the Scythe of Elune Spells if this option is enabled!"),
						arg = "OPT_SCYTHE_SPELL_CLIPPING",
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
			Include(lunaeclipse_druid_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_starfall "AOE: Starfall" default)
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

			###
			### Artifact Functions
			###
			AddFunction ScytheOfElune_Available
			{
					HasScytheOfElune()
				and ScytheOfEluneCharges() >= 1
			}

			###
			### Astral Communion Functions
			###
			AddFunction AstralCommunion_Use
			{
					Talent(astral_communion_talent)
				and not SpellCooldown(astral_communion)
				and AstralPowerDeficit() >= 75			
			}

			AddFunction AstralCommunion_Use_EmeraldDreamcatcher
			{
					Talent(astral_communion_talent)
				and not SpellCooldown(astral_communion)
				and BuffPresent(the_emerald_dreamcatcher_buff)
				and AstralPowerDeficit() >= 75			
			}

			AddFunction AstralCommunion_Use_FuryOfElune
			{
					Talent(astral_communion_talent)
				and not SpellCooldown(astral_communion)
				and BuffPresent(fury_of_elune_buff)
				and AstralPowerDeficit() >= 75			
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
			### Celestial Alignment Functions
			###
			AddFunction CelestialAlignment_Active
			{
					BuffPresent(celestial_alignment_buff)
				 or BuffPresent(incarnation_chosen_of_elune_buff)
			}

			AddFunction CelestialAlignment_Use
			{
					not Talent(incarnation_talent)
				and not SpellCooldown(celestial_alignment)
				and AstralPower() >= 40
			}

			AddFunction CelestialAlignment_Use_EmeraldDreamcatcher
			{
					not Talent(incarnation_talent)
				and not SpellCooldown(celestial_alignment)
				and not BuffPresent(the_emerald_dreamcatcher_buff)
				and AstralPower() >= 85
			}

			###
			### Force of Nature Functions
			###
			AddFunction ForceOfNature_Use
			{
					Talent(force_of_nature_talent)
				and not SpellCooldown(force_of_nature)
			}

			AddFunction ForceOfNature_Use_FuryOfElune
			{
					Talent(force_of_nature_talent)
				and not SpellCooldown(force_of_nature)
				and {
							BuffPresent(fury_of_elune_buff)
						 or {
									Talent(fury_of_elune_talent)
								and SpellCooldown(fury_of_elune) >= 35
							}
					}
			}

			###
			### Full Moon Functions
			###
			AddFunction FullMoon_Use
			{
					ScytheOfEluneSpell(full_moon)
				and ScytheOfElune_Available()
				and not CelestialAlignment_Active()
				and AstralPower() <= 60
			}

			AddFunction FullMoon_Use_EmeraldDreamcatcher
			{
					ScytheOfEluneSpell(full_moon)
				and ScytheOfElune_Available()
				and BuffPresent(the_emerald_dreamcatcher_buff)
				and BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(full_moon)
				and not CelestialAlignment_Active()
				and AstralPower() <= 60
			}

			AddFunction FullMoon_Use_EmeraldDreamcatcher_NoIncarnation
			{
					ScytheOfEluneSpell(full_moon)
				and ScytheOfElune_Available()
				and not BuffPresent(incarnation_chosen_of_elune_buff)
				and {
							SpellCooldown(incarnation_chosen_of_elune) > 65
						 or {
									SpellCooldown(incarnation_chosen_of_elune) > 50
								and ScytheOfEluneCharges() >= 2
							}
						 or {
									SpellCooldown(incarnation_chosen_of_elune) > 25
								and ScytheOfEluneCharges() >= 3
							}
					}
				and AstralPower() <= 60
			}

			AddFunction FullMoon_Use_FullCharges
			{
					ScytheOfEluneSpell(full_moon)
				and ScytheOfElune_Available()
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellCooldown(full_moon) < 5
							}
						 or target.TimeToDie() < 15
					}
			}

			AddFunction FullMoon_Use_FullCharges_FuryOfElune
			{
					ScytheOfEluneSpell(full_moon)
				and ScytheOfElune_Available()
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellCooldown(full_moon) < 5
							}
					}
				and {
							BuffPresent(fury_of_elune_buff)
						 or {
									SpellCooldown(fury_of_elune) > GCD() * 3
								and AstralPower() <= 60
							}
					}
			}

			AddFunction FullMoon_Use_FuryOfElune
			{
					ScytheOfEluneSpell(full_moon)
				and ScytheOfElune_Available()
				and BuffPresent(fury_of_elune_buff)
				and AstralPower() <= 60
				and AstralPower() > CastTime(full_moon) * 12
			}

			###
			### Fury of Elune Functions
			###
			AddFunction FuryOfElune_Use
			{
					Talent(fury_of_elune_talent)
				and not SpellCooldown(fury_of_elune)
				and AstralPower() >= 95
			}

			###
			### Incarnation Functions
			###
			AddFunction Incarnation_Use
			{
					Talent(incarnation_talent)
				and not SpellCooldown(incarnation_chosen_of_elune)
				and AstralPower() >= 40
			}

			AddFunction Incarnation_Use_EmeraldDreamcatcher
			{
					Talent(incarnation_talent)
				and not SpellCooldown(incarnation_chosen_of_elune)
				and {
							not BuffPresent(the_emerald_dreamcatcher_buff)
						 or BloodlustActive()
					}
				and AstralPower() >= 85
			}

			AddFunction Incarnation_Use_FuryOfElune
			{
					Talent(incarnation_talent)
				and not SpellCooldown(incarnation_chosen_of_elune)
				and SpellCooldown(fury_of_elune) <= GCD()
				and AstralPower() >= 95
			}

			###
			### Half Moon Functions
			###
			AddFunction HalfMoon_Use
			{
					ScytheOfEluneSpell(half_moon)
				and ScytheOfElune_Available()
				and not CelestialAlignment_Active()
				and AstralPower() <= 80
			}

			AddFunction HalfMoon_Use_EmeraldDreamcatcher
			{
					ScytheOfEluneSpell(half_moon)
				and ScytheOfElune_Available()
				and BuffPresent(the_emerald_dreamcatcher_buff)
				and BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(half_moon)
				and AstralPower() <= 80
				and AstralPower() >= 6
			}

			AddFunction HalfMoon_Use_FullCharges
			{
					ScytheOfEluneSpell(half_moon)
				and ScytheOfElune_Available()
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellCooldown(full_moon) < 5
							}
						 or target.TimeToDie() < 15
					}
			}

			AddFunction HalfMoon_Use_FullCharges_FuryOfElune
			{
					ScytheOfEluneSpell(half_moon)
				and ScytheOfElune_Available()
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellCooldown(half_moon) < 5
							}
					}
				and {
							BuffPresent(fury_of_elune_buff)
						 or {
									SpellCooldown(fury_of_elune) > GCD() * 3
								and AstralPower() <= 80
							}
					}
			}

			AddFunction HalfMoon_Use_FuryOfElune
			{
					ScytheOfEluneSpell(half_moon)
				and ScytheOfElune_Available()
				and BuffPresent(fury_of_elune_buff)
				and AstralPower() <= 80
				and AstralPower() > CastTime(half_moon) * 12
			}

			###
			### Lunar Strike Functions
			###
			AddFunction LunarStrike_Use
			{
					not SpellCooldown(lunar_strike)
				and Enemies() >= 2
			}

			AddFunction LunarStrike_Use_Charges
			{
					not SpellCooldown(lunar_strike)
				and BuffPresent(lunar_empowerment_buff)
			}

			AddFunction LunarStrike_Use_Charges_EmeraldDreamcatcher
			{
					not SpellCooldown(lunar_strike)
				and BuffPresent(lunar_empowerment_buff)
				and BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(lunar_strike)
				and AstralPower() >= 11
				and {
							{
									not CelestialAlignment_Active()
								and AstralPower() <= 85
							}
						 or {
									CelestialAlignment_Active()
								and AstralPower() <= 77.5
							}
					}
			}

			AddFunction LunarStrike_Use_MaxStacks_FuryOfElune
			{
					not SpellCooldown(lunar_strike)
				and {
							BuffStacks(lunar_empowerment_buff) >= 3
						 or {
									BuffPresent(lunar_empowerment_buff)
								and BuffRemaining(lunar_empowerment_buff) < 5
							}
					}
			}

			AddFunction LunarStrike_Use_MaxStacks
			{
					not SpellCooldown(lunar_strike)
				and BuffStacks(lunar_empowerment_buff) >= 3
			}

			AddFunction LunarStrike_Use_Moonfire_Refresh
			{
					not SpellCooldown(lunar_strike)
				and Talent(natures_balance_talent)
				and target.DebuffPresent(moonfire_debuff)
				and target.DebuffRemaining(moonfire_debuff) < 5
				and target.DebuffRemaining(moonfire_debuff) > ExecuteTime(lunar_strike) 
			}

			AddFunction LunarStrike_Use_WarriorOfElune
			{
					not SpellCooldown(lunar_strike)
				and BuffPresent(warrior_of_elune_buff)
			}

			AddFunction LunarStrike_Use_WarriorOfElune_FuryOfElune
			{
					not SpellCooldown(lunar_strike)
				and BuffPresent(warrior_of_elune_buff)
				and {
							{
									not BuffPresent(incarnation_chosen_of_elune_buff)
								and AstralPower() <= 90
							}
						 or AstralPower() <= 85
					}
			}

			###
			### Moonfire Functions
			###
			AddFunction Moonfire_Use
			{
					not SpellCooldown(moonfire)
				and {
							{
									not Talent(natures_balance_talent)
								and target.InPandemicRange(moonfire_debuff moonfire)
							}
						 or target.DebuffRemaining(moonfire_debuff) < 3
					}
				and Mana() >= ManaCost(moonfire)
			}

			AddFunction Moonfire_Use_EmeraldDreamcatcher
			{
					not SpellCooldown(moonfire)
				and {
							{
									not Talent(natures_balance_talent)
								and target.InPandemicRange(moonfire_debuff moonfire)
							}
						 or target.DebuffRemaining(moonfire_debuff) < 3
					}
				and {
							not BuffPresent(the_emerald_dreamcatcher_buff)
						 or BuffRemaining(the_emerald_dreamcatcher_buff) > GCD()
					}
				and Mana() >= ManaCost(moonfire)
			}

			AddFunction Moonfire_Use_Other
			{
					not SpellCooldown(moonfire)
				and DOTTargetCount(moonfire_debuff) < MultiDOTTargets()
				and Mana() >= ManaCost(moonfire)
			}

			###
			### New Moon Functions
			###
			AddFunction NewMoon_Use
			{
					ScytheOfEluneSpell(new_moon)
				and ScytheOfElune_Available()
				and not CelestialAlignment_Active()
				and AstralPower() <= 90
			}

			AddFunction NewMoon_Use_FullCharges
			{
					ScytheOfEluneSpell(new_moon)
				and ScytheOfElune_Available()
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellCooldown(new_moon) < 5
							}
					}
			}

			AddFunction NewMoon_Use_FullCharges_FuryOfElune
			{
					ScytheOfEluneSpell(new_moon)
				and ScytheOfElune_Available()
				and {
							ScytheOfEluneCharges() == 3
						 or {
									ScytheOfEluneCharges() == 2
								and SpellCooldown(new_moon) < 5
							}
					}
				and {
							BuffPresent(fury_of_elune_buff)
						 or {
									SpellCooldown(fury_of_elune) > GCD() * 3
								and AstralPower() <= 90
							}
					}
			}

			AddFunction NewMoon_Use_FuryOfElune
			{
					ScytheOfEluneSpell(new_moon)
				and ScytheOfElune_Available()
				and BuffPresent(fury_of_elune_buff)
				and AstralPower() <= 90
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
			}

			AddFunction SolarWrath_Use_Charges
			{
					not SpellCooldown(solar_wrath)
				and BuffPresent(solar_empowerment_buff)
			}

			AddFunction SolarWrath_Use_Charges_EmeraldDreamcatcher
			{
					not SpellCooldown(solar_wrath)
				and BuffPresent(solar_empowerment_buff)
				and BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(solar_wrath)
				and AstralPower() >= 16
				and {
							{
									not CelestialAlignment_Active()
								and AstralPower() <= 90
							}
						 or {
									CelestialAlignment_Active()
								and AstralPower() <= 85
							}
					}
			}

			AddFunction SolarWrath_Use_MaxStacks
			{
					not SpellCooldown(solar_wrath)
				and BuffStacks(solar_empowerment_buff) >= 3
			}

			AddFunction SolarWrath_Use_EmeraldDreamcatcher_DoubleCast
			{
					not SpellCooldown(solar_wrath)
				and BuffPresent(solar_empowerment_buff)
				and BuffStacks(solar_empowerment_buff) >= 2
				and BuffRemaining(the_emerald_dreamcatcher_buff) > 2 * ExecuteTime(solar_wrath)
				and AstralPower() >= 6
				and {
							{
									target.DebuffRemaining(moonfire_debuff) > 5
								 or {
											target.DebuffPresent(sunfire_debuff)
										and target.DebuffRemaining(sunfire_debuff) < 5.4
										and target.DebuffRemaining(moonfire_debuff) > 6.6
									}
							}
						and {
									{
											not CelestialAlignment_Active()
										and AstralPower() <= 90
									}
								 or {
											CelestialAlignment_Active()
										and AstralPower() <= 85
									}
							}
					}
			}

			AddFunction SolarWrath_Use_Sunfire_Refresh
			{
					not SpellCooldown(solar_wrath)
				and Talent(natures_balance_talent)
				and target.DebuffPresent(sunfire_debuff)
				and target.DebuffRemaining(sunfire_debuff) < 5
				and target.DebuffRemaining(sunfire_debuff) > ExecuteTime(solar_wrath) 
			}

			###
			### Starfall Functions
			###
			AddFunction Starfall_Use
			{
					not SpellCooldown(starfall)
				and {
							{
									Talent(stellar_drift_talent)
								and Enemies() >= 2
							}
						 or Enemies() >= 3
					}
				and {
							BuffPresent(oneths_overconfidence_buff)
						 or AstralPower() >= 60
					}
			}

			AddFunction Starfall_Use_EmeraldDreamcatcher
			{
					not SpellCooldown(starfall)
				and BuffPresent(oneths_overconfidence_buff)
				and BuffRemaining(oneths_overconfidence_buff) < 2
			}

			AddFunction Starfall_Use_FuryOfElune
			{
					not SpellCooldown(starfall)
				and {
							{
									Talent(stellar_drift_talent)
								and Enemies() >= 2
							}
						 or Enemies() >= 3
					}
				and {
							not BuffPresent(fury_of_elune_buff)
						and SpellCooldown(fury_of_elune) > 10
					}
				and {
							BuffPresent(oneths_overconfidence_buff)
						 or AstralPower() >= 60
					}
			}

			AddFunction Starfall_Use_OnethsOverconfidence
			{
					not SpellCooldown(starfall)
				and BuffPresent(oneths_overconfidence_buff)
			}

			AddFunction Starfall_Use_OnethsOverconfidence_EmeraldDreamcatcher
			{
					not SpellCooldown(starfall)
				and BuffPresent(the_emerald_dreamcatcher_buff)
				and BuffRemaining(the_emerald_dreamcatcher_buff) > ExecuteTime(starfall)
				and BuffPresent(oneths_overconfidence_buff)
				and BuffRemaining(oneths_overconfidence_buff) < 2
			}

			###
			### Starsurge Functions
			###
			AddFunction Starsurge_Use
			{
					not SpellCooldown(starsurge)
				and {
							not CheckBoxOn(opt_starfall)
						 or Enemies() <= 2
					}
				and {
							BuffPresent(oneths_overconfidence_buff)
						 or AstralPower() >= 40
					}
			}

			AddFunction Starsurge_Use_AstralPower_EmeraldDreamcatcher
			{
					not SpellCooldown(starsurge)
				and {
							{
									BuffPresent(the_emerald_dreamcatcher_buff)
								and BuffRemaining(the_emerald_dreamcatcher_buff) < GCD()
							}
                         or {
									BuffPresent(the_emerald_dreamcatcher_buff)
								and CelestialAlignment_Active()
								and AstralPower() >= 77.5
							}												
						 or {
									CelestialAlignment_Active()
								and AstralPower() >= 85
							}
 						 or AstralPower() > 90
					}
				and {
							BuffPresent(oneths_overconfidence_buff)
						 or AstralPower() >= 40
					}
			}

			AddFunction Starsurge_Use_EmeraldDreamcatcher
			{
					not SpellCooldown(starsurge)
				and {
							{
									BuffPresent(celestial_alignment_buff)
								and BuffRemaining(celestial_alignment_buff) < 10
							}
						 or {
									BuffPresent(incarnation_chosen_of_elune_buff)
								and BuffRemaining(incarnation_chosen_of_elune_buff) < ExecuteTime(starsurge) * 3
								and AstralPower() >= 80
							}
						 or {
									BuffPresent(incarnation_chosen_of_elune_buff)
								and BuffRemaining(incarnation_chosen_of_elune_buff) < ExecuteTime(starsurge) * 2
								and AstralPower() >= 55
							}
						 or {
									BuffPresent(incarnation_chosen_of_elune_buff)
								and BuffRemaining(incarnation_chosen_of_elune_buff) < ExecuteTime(starsurge)
								and AstralPower() >= 30
							}
					}
				and {
							BuffPresent(oneths_overconfidence_buff)
						 or AstralPower() >= 40
					}
			}

			AddFunction Starsurge_Use_FuryOfElune
			{
					not SpellCooldown(starsurge)
				and {
							{
									{
											not CheckBoxOn(opt_starfall)
										 or Enemies() <= 2
									}
								and {
											not BuffPresent(fury_of_elune_buff)
										and SpellCooldown(fury_of_elune) > 7
									}
							}
						 or {
									not not BuffPresent(fury_of_elune_buff)
								and {
											{
													AstralPower() >= 92
												and SpellCooldown(fury_of_elune) > GCD() * 3
											}
										 or {
													Talent(warrior_of_elune_talent)
												and SpellCooldown(warrior_of_elune) <= 5
												and SpellCooldown(fury_of_elune) >= 35
												and BuffStacks(lunar_empowerment_buff) < 2
											}
									}
							}
					}
				and {
							BuffPresent(oneths_overconfidence_buff)
						 or AstralPower() >= 40
					}
			}

			###
			### Stellar Flare Functions
			###
			AddFunction StellarFlare_Use
			{
					Talent(stellar_flare_talent)
				and not SpellCooldown(stellar_flare)
				and target.InPandemicRange(stellar_flare_debuff stellar_flare)
				and AstralPower() >= 15
			}

			AddFunction StellarFlare_Use_EmeraldDreamcatcher
			{
					Talent(stellar_flare_talent)
				and not SpellCooldown(stellar_flare)
				and target.InPandemicRange(stellar_flare_debuff stellar_flare)
				and Enemies() < 4
				and AstralPower() >= 15
			}

			AddFunction StellarFlare_Use_FuryOfElune
			{
					Talent(stellar_flare_talent)
				and not SpellCooldown(stellar_flare)
				and target.InPandemicRange(stellar_flare_debuff stellar_flare)
				and Enemies() == 1
				and AstralPower() >= 15
			}

			AddFunction StellarFlare_Use_Other
			{
					Talent(stellar_flare_talent)
				and not SpellCooldown(stellar_flare)
				and DOTTargetCount(stellar_flare_debuff) < MultiDOTTargets(4)
				and AstralPower() >= 15
			}

			###
			### Sunfire Functions
			###
			AddFunction Sunfire_Use
			{
					not SpellCooldown(sunfire)
				and {
							{
									not Talent(natures_balance_talent)
								and target.InPandemicRange(sunfire_debuff sunfire)
							}
						 or target.DebuffRemaining(sunfire_debuff) < 3
					}
				and Mana() >= ManaCost(sunfire)
			}

			AddFunction Sunfire_Use_EmeraldDreamcatcher
			{
					not SpellCooldown(sunfire)
				and {
							{
									not Talent(natures_balance_talent)
								and target.InPandemicRange(sunfire_debuff sunfire)
							}
						 or target.DebuffRemaining(sunfire_debuff) < 3
					}
				and {
							not BuffPresent(the_emerald_dreamcatcher_buff)
						 or BuffRemaining(the_emerald_dreamcatcher_buff) > GCD()
					}
				and Mana() >= ManaCost(sunfire)
			}

			AddFunction Sunfire_Use_Other
			{
					not SpellCooldown(sunfire)
				and DOTTargetCount(sunfire_debuff) < MultiDOTTargets()
				and Mana() >= ManaCost(sunfire)
			}

			###
			### Warrior of Elune Functions
			###
			AddFunction WarriorOfElune_Use
			{
					Talent(warrior_of_elune_talent)
				and not SpellCooldown(warrior_of_elune)
			}

			AddFunction WarriorOfElune_Use_FuryOfElune
			{
					Talent(warrior_of_elune_talent)
				and not SpellCooldown(warrior_of_elune)
				and {
							BuffPresent(fury_of_elune_buff)
						 or {
									Talent(fury_of_elune_talent)
								and SpellCooldown(fury_of_elune) >= 35
								and BuffPresent(lunar_empowerment_buff)
							}
					}
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
									BuffPresent(celestial_alignment_buff)
								 or BuffPresent(incarnation_chosen_of_elune_buff)
							}
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 40
			}

			###
			### Scythe of Elune Clipping - Rotations
			###
			AddFunction NewMoon_Clipping
			{
				if CheckBoxOn(opt_scythe_spell_clipping) Texture(artifactability_balancedruid_newmoon) Spell(new_moon)
			}

			AddFunction HalfMoon_Clipping
			{
				if CheckBoxOn(opt_scythe_spell_clipping) Texture(artifactability_balancedruid_halfmoon) Spell(half_moon)
			}

			AddFunction FullMoon_Clipping
			{
				if CheckBoxOn(opt_scythe_spell_clipping) Texture(artifactability_balancedruid_fullmoon) Spell(full_moon)
			}

			###
			### Rotation Functions
			###
			AddFunction Rotation_EmeraldDreamcatcher_Use
			{
					not Rotation_FuryOfElune_Use()
				and LegendaryEquipped(the_emerald_dreamcatcher)
				and Enemies() <= 2
			}

			AddFunction Rotation_FuryOfElune_Use
			{
					Talent(fury_of_elune_talent)
				and SpellCooldown(fury_of_elune) < target.TimeToDie()
			}

			AddFunction Rotation_Standard_Use
			{
					not Rotation_FuryOfElune_Use()
				and not Rotation_EmeraldDreamcatcher_Use()
			}

			###
			### Emerald Dreamcatcher Rotation
			###
			AddFunction Rotation_EmeraldDreamcatcher
			{
				if CheckBoxOn(opt_astral_communion) and AstralCommunion_Use_EmeraldDreamcatcher() Spell(astral_communion)
				if CheckBoxOn(opt_celestial_alignment) and Incarnation_Use_EmeraldDreamcatcher() Spell(incarnation_chosen_of_elune)
				if CheckBoxOn(opt_celestial_alignment) and CelestialAlignment_Use_EmeraldDreamcatcher() Spell(celestial_alignment)

				if Starsurge_Use_EmeraldDreamcatcher() Spell(starsurge)

				if CheckBoxOn(opt_stellar_flare) and StellarFlare_Use_EmeraldDreamcatcher() Spell(stellar_flare)
				if Moonfire_Use_EmeraldDreamcatcher() Spell(moonfire)
				if Sunfire_Use_EmeraldDreamcatcher() Spell(sunfire)

				if CheckBoxOn(opt_starfall) and Starfall_Use_OnethsOverconfidence_EmeraldDreamcatcher() Spell(starfall)

				if HalfMoon_Use_EmeraldDreamcatcher() HalfMoon_Clipping()
				if FullMoon_Use_EmeraldDreamcatcher() FullMoon_Clipping()

				if SolarWrath_Use_EmeraldDreamcatcher_DoubleCast() Spell(solar_wrath)
				if LunarStrike_Use_Charges_EmeraldDreamcatcher() Spell(lunar_strike)
				if SolarWrath_Use_Charges_EmeraldDreamcatcher() Spell(solar_wrath)

				if Starsurge_Use_AstralPower_EmeraldDreamcatcher() Spell(starsurge)
				if CheckBoxOn(opt_starfall) and Starfall_Use_EmeraldDreamcatcher() Spell(starfall)

				if NewMoon_Use() NewMoon_Clipping()
				if HalfMoon_Use() HalfMoon_Clipping()
				if FullMoon_Use_EmeraldDreamcatcher_NoIncarnation() FullMoon_Clipping()

				if SolarWrath_Use_Charges() Spell(solar_wrath)
				if LunarStrike_Use_Charges() Spell(lunar_strike)
				if SolarWrath_Use() Spell(solar_wrath)
			}

			###
			### Fury of Elune Rotations
			###
			AddFunction Rotation_FuryOfElune
			{
				if CheckBoxOn(opt_celestial_alignment) and Incarnation_Use_FuryOfElune() Spell(incarnation_chosen_of_elune)
				if CheckBoxOn(opt_fury_of_elune) and FuryOfElune_Use() Spell(fury_of_elune)
				
				if NewMoon_Use_FullCharges_FuryOfElune() NewMoon_Clipping()
				if HalfMoon_Use_FullCharges_FuryOfElune() HalfMoon_Clipping()
				if FullMoon_Use_FullCharges_FuryOfElune() FullMoon_Clipping()

				if CheckBoxOn(opt_astral_communion) and AstralCommunion_Use_FuryOfElune() Spell(astral_communion)
				if CheckBoxOn(opt_warrior_of_elune) and WarriorOfElune_Use_FuryOfElune() Spell(warrior_of_elune)
				if CheckBoxOn(opt_force_of_nature) and ForceOfNature_Use_FuryOfElune() Spell(force_of_nature)

				if LunarStrike_Use_WarriorOfElune_FuryOfElune() Spell(lunar_strike)

				if NewMoon_Use_FuryOfElune() NewMoon_Clipping()
				if HalfMoon_Use_FuryOfElune() HalfMoon_Clipping()
				if FullMoon_Use_FuryOfElune() FullMoon_Clipping()

				if Moonfire_Use() Spell(moonfire)
				if Sunfire_Use() Spell(sunfire)
				if CheckBoxOn(opt_stellar_flare) and StellarFlare_Use_FuryOfElune() Spell(stellar_flare)

				if CheckBoxOn(opt_starfall) and Starfall_Use_FuryOfElune() Spell(starfall)
				if Starsurge_Use_FuryOfElune() Spell(starsurge)

				if SolarWrath_Use_Charges() Spell(solar_wrath)
				if LunarStrike_Use_MaxStacks_FuryOfElune() Spell(lunar_strike)
				if LunarStrike_Use() Spell(lunar_strike)
				if SolarWrath_Use() Spell(solar_wrath)
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(solar_beam) Spell(solar_beam)
					if target.Distance() < 8 Spell(arcane_torrent_mana)

					if not target.IsRaidBoss()
					{
						if target.RangeCheck(mighty_bash) Spell(mighty_bash)
						if target.Distance() < 5 Spell(war_stomp)
						if target.Distance() < 15 Spell(typhoon)
					}
				}
			}

			###
			### Standard Rotation
			###
			AddFunction Rotation_Standard
			{
				if NewMoon_Use() NewMoon_Clipping()
				if HalfMoon_Use() HalfMoon_Clipping()
				if FullMoon_Use() FullMoon_Clipping()

				if CheckBoxOn(opt_starfall) and Starfall_Use() Spell(starfall)
				if Starsurge_Use() Spell(starsurge)

				if CheckBoxOn(opt_warrior_of_elune) and WarriorOfElune_Use() Spell(warrior_of_elune)
				if CheckBoxOn(opt_force_of_nature) and ForceOfNature_Use() Spell(force_of_nature)

				if LunarStrike_Use_WarriorOfElune() Spell(lunar_strike)
				if SolarWrath_Use_Charges() Spell(solar_wrath)
				if LunarStrike_Use_Charges() Spell(lunar_strike)
				if SolarWrath_Use_Sunfire_Refresh() Spell(solar_wrath)
				if LunarStrike_Use_Moonfire_Refresh() Spell(lunar_strike)
				if LunarStrike_Use() Spell(lunar_strike)
				if SolarWrath_Use() Spell(solar_wrath)
			}

			###
			### Main
			###
			AddFunction MultiDot
			{
				if Rotation_EmeraldDreamcatcher_Use() 
				{
					if StellarFlare_Use_Other() Spell(stellar_flare text=multi)
				}

				if Rotation_Standard_Use()
				{
					if StellarFlare_Use_Other() Spell(stellar_flare text=multi)
					if Moonfire_Use_Other() Spell(moonfire text=multi)
					if Sunfire_Use_Other() Spell(sunfire text=multi)
				}
			}

			AddFunction ShortCD
			{
				# Make sure that the player is in Moonkin form
				if CheckBoxOn(opt_moonkin_form) and not Stance(druid_moonkin_form) Spell(moonkin_form)

				# Make sure player has the correct Blessings of the Ancient Buff
				if CheckBoxOn(opt_blessing_ancients) and not BuffPresent(blessing_of_elune_buff) Spell(blessing_of_the_ancients)

				# Short Cooldown Spells
				if Rotation_FuryOfElune_Use()
				{
					if not CheckBoxOn(opt_fury_of_elune) and FuryOfElune_Use() Spell(fury_of_elune)
					if not CheckBoxOn(opt_astral_communion) and AstralCommunion_Use_FuryOfElune() Spell(astral_communion)
					if not CheckBoxOn(opt_warrior_of_elune) and WarriorOfElune_Use_FuryOfElune() Spell(warrior_of_elune)
					if not CheckBoxOn(opt_force_of_nature) and ForceOfNature_Use_FuryOfElune() Spell(force_of_nature)
					if not CheckBoxOn(opt_stellar_flare) and StellarFlare_Use_FuryOfElune() Spell(stellar_flare)
					if not CheckBoxOn(opt_starfall) and Starfall_Use_FuryOfElune() Spell(starfall)
				}			

				# Use the Emerald Dreamcatcher rotation.
				if Rotation_EmeraldDreamcatcher_Use()
				{
					if not CheckBoxOn(opt_astral_communion) and AstralCommunion_Use_EmeraldDreamcatcher() Spell(astral_communion)
					if not CheckBoxOn(opt_stellar_flare) and StellarFlare_Use_EmeraldDreamcatcher() Spell(stellar_flare)
					if not CheckBoxOn(opt_starfall) and Starfall_Use_OnethsOverconfidence_EmeraldDreamcatcher() Spell(starfall)
					if not CheckBoxOn(opt_starfall) and Starfall_Use_EmeraldDreamcatcher() Spell(starfall)
				}

				if not CheckBoxOn(opt_stellar_flare) and StellarFlare_Use() Spell(stellar_flare)
				if not CheckBoxOn(opt_astral_communion) and AstralCommunion_Use() Spell(astral_communion)
				if not CheckBoxOn(opt_starfall) and Starfall_Use_OnethsOverconfidence() Spell(starfall)

				if Rotation_Standard_Use()
				{
					if not CheckBoxOn(opt_starfall) and Starfall_Use() Spell(starfall)
					if not CheckBoxOn(opt_warrior_of_elune) and WarriorOfElune_Use() Spell(warrior_of_elune)
					if not CheckBoxOn(opt_force_of_nature) and ForceOfNature_Use() Spell(force_of_nature)
				}

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_renewal) and Renewal_Use() Spell(renewal)
				if CheckBoxOn(opt_barkskin) and Barkskin_Use() Spell(barkskin)
			}

			AddFunction Main
			{
				# Use the Fury of Elune rotation.
				if Rotation_FuryOfElune_Use() Rotation_FuryOfElune()				

				# Use the Emerald Dreamcatcher rotation.
				if Rotation_EmeraldDreamcatcher_Use() Rotation_EmeraldDreamcatcher()

				if NewMoon_Use_FullCharges() NewMoon_Clipping()
				if HalfMoon_Use_FullCharges() HalfMoon_Clipping()
				if FullMoon_Use_FullCharges() FullMoon_Clipping()

				if CheckBoxOn(opt_stellar_flare) and StellarFlare_Use() Spell(stellar_flare)
				if Moonfire_Use() Spell(moonfire)
				if Sunfire_Use() Spell(sunfire)

				if CheckBoxOn(opt_astral_communion) and AstralCommunion_Use() Spell(astral_communion)
				if CheckBoxOn(opt_celestial_alignment) and Incarnation_Use() Spell(incarnation_chosen_of_elune)
				if CheckBoxOn(opt_celestial_alignment) and CelestialAlignment_Use() Spell(celestial_alignment)

				if CheckBoxOn(opt_starfall) and Starfall_Use_OnethsOverconfidence() Spell(starfall)
				if SolarWrath_Use_MaxStacks() Spell(solar_wrath)
				if LunarStrike_Use_MaxStacks() Spell(lunar_strike)

				# Use the Standard rotation.
				if Rotation_Standard_Use() Rotation_Standard()
			}

			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
				if Rotation_FuryOfElune_Use()
				{
					if not CheckBoxOn(opt_celestial_alignment) and Incarnation_Use_FuryOfElune() Spell(incarnation_chosen_of_elune)
				}			

				# Use the Emerald Dreamcatcher rotation.
				if Rotation_EmeraldDreamcatcher_Use()
				{
					if not CheckBoxOn(opt_celestial_alignment) and Incarnation_Use_EmeraldDreamcatcher() Spell(incarnation_chosen_of_elune)
					if not CheckBoxOn(opt_celestial_alignment) and CelestialAlignment_Use_EmeraldDreamcatcher() Spell(celestial_alignment)
				}

				if not CheckBoxOn(opt_celestial_alignment) and Incarnation_Use() Spell(incarnation_chosen_of_elune)
				if not CheckBoxOn(opt_celestial_alignment) and CelestialAlignment_Use() Spell(celestial_alignment)

				# Potion
				if LunaEclipse_Potion_Use() and Potion_Use() Item(potion_of_prolonged_power)

				# Standard Actions
				Spell(blood_fury_sp)
				Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) Spell(arcane_torrent_mana)
				Rotation_ItemActions()
			}

			###
			### Main_Precombat
			###
			AddFunction MultiDot_Precombat
			{
			}

			AddFunction ShortCD_Precombat
			{
				# Make sure that the player is in Moonkin form
				if CheckBoxOn(opt_moonkin_form) and not Stance(druid_moonkin_form) Spell(moonkin_form)

				# Make sure player has the correct Blessings of the Ancient Buff
				if CheckBoxOn(opt_blessing_ancients) and not BuffPresent(blessing_of_elune_buff) Spell(blessing_of_the_ancients)

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_renewal) and Renewal_Use() Spell(renewal)
				if CheckBoxOn(opt_barkskin) and Barkskin_Use() Spell(barkskin)
			}

			AddFunction Main_Precombat
			{
				if NewMoon_Use() NewMoon_Clipping()
			}

			AddFunction CD_Precombat
			{
				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_prolonged_power)
			}

			###
			### Rotation icons.
			###
			AddIcon checkbox=opt_multi_dot help=multidot
			{
				if not InCombat() MultiDot_Precombat()
				MultiDot()
			}

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

		OvaleScripts:RegisterScript("DRUID", "balance", name, desc, code, "script");
	end
end