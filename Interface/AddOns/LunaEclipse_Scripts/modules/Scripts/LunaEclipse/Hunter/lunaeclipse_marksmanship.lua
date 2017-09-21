local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_hunter_marksmanship";
		local desc = "LunaEclipse: Marksmanship Hunter";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.HUNTER_MARKSMANSHIP,
			ScriptAuthor = "LunaEclipse",
			ScriptCredits = "HuntsTheWind",
			GuideAuthor = "Azortharion",
			GuideLink = "http://www.icy-veins.com/wow/marksmanship-hunter-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding"] = "1313013",
			["Dungeons / Mythic+"] = "1111033",
			["Dungeons / Mythic+ (Heavy AOE)"] = "1111032",
			["Easy Mode"] = "1313033",
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
					OPT_MARKED_SHOT = {
						type = "toggle",
						name = BINDING_NAME_OPT_MARKED_SHOT,
						desc = functionsConfiguration:getAOETooltip("Marked Shot"),
						arg = "OPT_MARKED_SHOT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_SIDEWINDERS = {
						type = "toggle",
						name = BINDING_NAME_OPT_SIDEWINDERS,
						desc = functionsConfiguration:getAOETooltip("Sidewinders"),
						arg = "OPT_SIDEWINDERS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_BARRAGE = {
						type = "toggle",
						name = BINDING_NAME_OPT_BARRAGE,
						desc = functionsConfiguration:getAOETooltip("Barrage"),
						arg = "OPT_BARRAGE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
				},
			},
			settingsCooldowns = {
				type = "group",
				name = BINDING_HEADER_COOLDOWNS,
				inline = true,
				order = 30,
				args = {
					OPT_AMOC = {
						type = "toggle",
						name = BINDING_NAME_OPT_AMOC,
						desc = functionsConfiguration:getCooldownTooltip("A Murder of Crows"),
						arg = "OPT_AMOC",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_BURSTING_SHOT = {
						type = "toggle",
						name = BINDING_NAME_OPT_BURSTING_SHOT,
						desc = string.format("%s\n\n%s", functionsConfiguration:getCooldownTooltip("Bursting Shot"), "This is only applicable when using Magnetized Blasting Cap Launcher legendary."),
						arg = "OPT_BURSTING_SHOT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_EXPLOSIVE_SHOT = {
						type = "toggle",
						name = BINDING_NAME_OPT_EXPLOSIVE_SHOT,
						desc = functionsConfiguration:getCooldownTooltip("Explosive Shot"),
						arg = "OPT_EXPLOSIVE_SHOT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_EXPLOSIVE_SHOT_DETONATE = {
						type = "toggle",
						name = BINDING_NAME_OPT_EXPLOSIVE_SHOT_DETONATE,
						desc = functionsConfiguration:getCooldownTooltip("Explosive Shot (Detonate)"),
						arg = "OPT_EXPLOSIVE_SHOT_DETONATE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 40,
					},
					OPT_PIERCING_SHOT = {
						type = "toggle",
						name = BINDING_NAME_OPT_PIERCING_SHOT,
						desc = functionsConfiguration:getCooldownTooltip("Piercing Shot"),
						arg = "OPT_PIERCING_SHOT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_TRUESHOT = {
						type = "toggle",
						name = BINDING_NAME_OPT_TRUESHOT,
						desc = functionsConfiguration:getCooldownTooltip("Trueshot", "CD"),
						arg = "OPT_TRUESHOT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_WINDBURST = {
						type = "toggle",
						name = BINDING_NAME_OPT_WINDBURST,
						desc = functionsConfiguration:getCooldownTooltip("Windburst"),
						arg = "OPT_WINDBURST",
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
					OPT_ASPECT_TURTLE = {
						type = "toggle",
						name = BINDING_NAME_OPT_ASPECT_TURTLE,
						desc = functionsConfiguration:getDefensiveTooltip("Aspect of the Turtle", "CD", "40%"),
						arg = "OPT_ASPECT_TURTLE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 10,
					},
					OPT_FEIGN_DEATH = {
						type = "toggle",
						name = BINDING_NAME_OPT_FEIGN_DEATH,
						desc = functionsConfiguration:getDefensiveTooltip("Feign Death", "ShortCD", "40%"),
						arg = "OPT_FEIGN_DEATH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_EXHILARATION = {
						type = "toggle",
						name = BINDING_NAME_OPT_EXHILARATION,
						desc = functionsConfiguration:getDefensiveTooltip("Exhilaration", "ShortCD", "40%"),
						arg = "OPT_EXHILARATION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(ovale_hunter_spells)
			Include(lunaeclipse_global)

			# Talents
			Define(explosive_shot_talent 10)
			Define(barrage_talent 17)
			Define(piercing_shot_talent 20)
			Define(trick_shot_talent 21)

			# Spells
			Define(aspect_of_the_turtle 186265)
				SpellInfo(aspect_of_the_turtle cd=180 gcd=0 offgcd=1)
				SpellAddBuff(aspect_of_the_turtle aspect_of_the_turtle_buff=1)
			Define(bursting_shot 186387)
				SpellInfo(bursting_shot cd=30 gcd=1.5 focus=10)
			Define(counter_shot 147362)
				SpellInfo(counter_shot cd=24 gcd=0 offgcd=1 interrupt=1 specialization=beast_mastery,marksmanship)
			Define(exhilaration 109304)
				SpellInfo(exhilaration cd=120 gcd=0 offgcd=1)
			Define(explosive_shot 212431)
				SpellInfo(explosive_shot cd=30 focus=20)
			Define(explosive_shot_detonate 212679)
			Define(feign_death 5384)
				SpellInfo(feign_death cd=30 gcd=0)
				SpellAddBuff(feign_death feign_death_buff=1)

			# Buffs
			Define(aspect_of_the_turtle_buff 186265)
				SpellInfo(aspect_of_the_turtle_buff duration=6)
			Define(lock_and_load_buff 194594)
			Define(feign_death_buff 5384)
				SpellInfo(feign_death_buff duration=360)

			# Legendaries
			Define(magnetized_blasting_cap_launcher 141353)

			# Checkboxes
			AddCheckBox(opt_marked_shot "AOE: Marked Shot" default specialization=marksmanship)
			AddCheckBox(opt_sidewinders "AOE: Sidewinders" default specialization=marksmanship)
			AddCheckBox(opt_barrage "AOE CD: Barrage" default specialization=marksmanship)
			AddCheckBox(opt_volley "Buff: Volley" default specialization=marksmanship)
			AddCheckBox(opt_amoc "Cooldown: A Murder of Crows")
			AddCheckBox(opt_bursting_shot "Cooldown: Bursting Shot" default specialization=marksmanship)
			AddCheckBox(opt_explosive_shot "Cooldown: Explosive Shot" default specialization=marksmanship)
			AddCheckBox(opt_explosive_shot_detonate "Cooldown: Explosive Shot (Detonate)" default specialization=marksmanship)
			AddCheckBox(opt_piercing_shot "Cooldown: Piercing Shot" default specialization=marksmanship)
			AddCheckBox(opt_trueshot "Cooldown: Trueshot" default specialization=marksmanship)
			AddCheckBox(opt_windburst "Cooldown: Windburst" default specialization=marksmanship)
			AddCheckBox(opt_aspect_turtle "Defensive: Aspect of the Turtle")
			AddCheckBox(opt_feign_death "Defensive: Feign Death")
			AddCheckBox(opt_exhilaration "Heal: Exhilaration")

			###
			### Artifact Functions
			###
			AddFunction Windburst_Available
			{
					SpellKnown(windburst)
				and not SpellCooldown(windburst)
			}

			AddFunction Windburst_Use
			{
					Windburst_Available()
				and Focus() >= 20
			}

			AddFunction Windburst_Pure_Single_Target_Use
			{
					Windburst_Available()
                and {
                            not target.DebuffPresent(vulnerability_debuff)
                         or not {
										BuffPresent(lock_and_load_buff)
                                     or {
                                                target.DebuffRemaining(vulnerability_debuff) > ExecuteTime(aimed_shot)
                                            and Focus() >= 50
                                        }
								}
                    }
				and Focus() >= 20
			}

			###
			### Aimed Shot Functions
			###
			AddFunction AimedShot_Use
			{
				    not SpellCooldown(aimed_shot)
				and Focus() >= 95
			}

			AddFunction AimedShot_Use_Vulnerable
			{
					not SpellCooldown(aimed_shot)
				and target.DebuffPresent(vulnerability_debuff)
				and {
							BuffPresent(lock_and_load_buff)
						 or {
									target.DebuffRemaining(vulnerability_debuff) > ExecuteTime(aimed_shot)
								and Focus() >= 50
							}
					}
			}

			###
			### Arcane Shot Functions
			###
			AddFunction ArcaneShot_MarkingTargets_Use
			{
					not Talent(sidewinders_talent)
				and not SpellCooldown(arcane_shot)
 				and BuffPresent(marking_targets_buff)
 				and Enemies() == 1
			}

			AddFunction ArcaneShot_Use
			{
					not Talent(sidewinders_talent)
				and not SpellCooldown(arcane_shot)
 				and not BuffPresent(marking_targets_buff)
                and Enemies() <= 2
			}

			###
			### Arcane Torrent Functions
			###
			AddFunction ArcaneTorrent_Use
			{
                    SpellKnown(arcane_torrent_focus)
					and FocusDeficit() >= 30
			}

			###
			### Aspect of the Turtle Functions
			###
			AddFunction AspectOfTheTurtle_Use
			{
					not SpellCooldown(aspect_of_the_turtle)
				and not BuffPresent(aspect_of_the_turtle_buff)
				and HealthPercent() <= 40
			}
	
			###
			### Barrage Functions
			###
			AddFunction Barrage_Use
			{
					Talent(barrage_talent)
				and not SpellCooldown(barrage)
				and Enemies() >= 3
				and Focus() >= 60
			}

			###
			### Bursting Shot Functions
			###
			AddFunction BurstingShot_Use
			{
					LegendaryEquipped(magnetized_blasting_cap_launcher)
				and not SpellCooldown(bursting_shot)
                and not target.DebuffPresent(vulnerability_debuff)
				and Enemies() >= 2
				and Focus() >= 10
			}

			###
			### Exhilaration Functions
			###
			AddFunction Exhilaration_Use
			{
					not SpellCooldown(exhilaration)
				and HealthPercent() <= 40
			}

			###
			### Explosive Shot Functions
			###
			AddFunction Explosive_Shot_Use
			{
					Talent(explosive_shot_talent)
				and not SpellCooldown(explosive_shot)
				and Focus() >= 20
			}

			AddFunction Explosive_Shot_Detonate_Use
			{
					Talent(explosive_shot_talent)
				and not SpellCooldown(explosive_shot_detonate)
			}

			###
			### Feign Death Functions
			###
			AddFunction FeignDeath_Use
			{
					not SpellCooldown(feign_death)
				and not BuffPresent(feign_death_buff)
				and HealthPercent() <= 40
			}

			###
			### Marked Shot Functions
			###
			AddFunction MarkedShot_Use
			{
					not SpellCooldown(marked_shot)
				and Focus() >= 30
			}

			AddFunction MarkedShot_Pure_Single_Target_Use
			{
					not SpellCooldown(marked_shot)
                and {
                            not target.DebuffPresent(vulnerability_debuff)
                         or not {
                                        BuffPresent(lock_and_load_buff)
                                     or {
                                                target.DebuffRemaining(vulnerability_debuff) > ExecuteTime(aimed_shot)
                                            and Focus() >= 50
                                        }
								}
                    }
				and Focus() >= 25 
			}

			###
			### Multi Shot Functions
			###
			AddFunction Multishot_MarkingTargets_Use
			{
					not Talent(sidewinders_talent)
				and not SpellCooldown(multishot)
                and BuffPresent(marking_targets_buff)
                and Enemies() >= 2
				and Focus() >= 40
			}

			AddFunction Multishot_Use
			{
					not Talent(sidewinders_talent)
				and not SpellCooldown(multishot)
                and not BuffPresent(marking_targets_buff)
                and Enemies() >= 3
				and Focus() >= 40
			}

			###
			### Murder of Crows Functions
			###
			AddFunction MurderOfCrows_Use
			{
					Talent(a_murder_of_crows_talent)
				and not SpellCooldown(a_murder_of_crows)
                and {
                            target.HealthPercent() > 25
                         or target.HealthPercent() <= 20
                    }
				and Focus() >= 30
			}

			###
			### Piercing Shot Functions
			###
			AddFunction Piercing_Shot_Use
			{
					Talent(piercing_shot_talent)
				and not SpellCooldown(piercing_shot)
                and target.DebuffPresent(vulnerability_debuff)
				and Focus() >= 100
			}

			###
			### Sidewinders Functions
			###
			AddFunction Sidewinders_Use
			{
					Talent(sidewinders_talent)
				and not SpellCooldown(sidewinders)
				and {
							{
									BuffPresent(marking_targets_buff)
								and SpellCharges(sidewinders) >= 1
							}
						 or {
									SpellCharges(sidewinders) >= 2
				                and not target.DebuffPresent(vulnerability_debuff)
							}
					}
			}

			###
			### Volley Functions
			###
			AddFunction Volley_Use
			{
					Talent(volley_talent)
				and not SpellCooldown(volley)
				and not BuffPresent(volley_buff)
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
									BuffPresent(trueshot_buff)
								 or {
											BuffPresent(bullseye_buff)
										and BuffStacks(bullseye_buff) >= 23
									}
							}
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 40
			}

			###
			### Rotation Functions
			###
			AddFunction Meme_ShortCD
			{
				# Short Cooldown Abilities
				if not CheckBoxOn(opt_piercing_shot) and Piercing_Shot_Use() Spell(piercing_shot)
				if not CheckBoxOn(opt_explosive_shot_detonate) and Explosive_Shot_Detonate_Use() Spell(explosive_shot_detonate text=detonate)
				if not CheckBoxOn(opt_explosive_shot) and Explosive_Shot_Use() Spell(explosive_shot)
				if not CheckBoxOn(opt_amoc) and MurderOfCrows_Use() Spell(a_murder_of_crows)
				if not CheckBoxOn(opt_windburst) and Windburst_Use() Spell(windburst)
				if not CheckBoxOn(opt_marked_shot) and MarkedShot_Use() Spell(marked_shot)
				if not CheckBoxOn(opt_barrage) and Barrage_Use() Spell(barrage)
				if not CheckBoxOn(opt_bursting_shot) and BurstingShot_Use() Spell(bursting_shot)
				if not CheckBoxOn(opt_sidewinders) and Sidewinders_Use() Spell(sidewinders)
			}

			AddFunction Pure_Single_Target_ShortCD
			{
				# Short Cooldown Abilities
				if not CheckBoxOn(opt_amoc) and MurderOfCrows_Use() Spell(a_murder_of_crows)
				if not CheckBoxOn(opt_explosive_shot_detonate) and Explosive_Shot_Detonate_Use() Spell(explosive_shot_detonate text=detonate)
				if not CheckBoxOn(opt_explosive_shot) and Explosive_Shot_Use() Spell(explosive_shot)
				if not CheckBoxOn(opt_marked_shot) and MarkedShot_Pure_Single_Target_Use() Spell(marked_shot)
				if not CheckBoxOn(opt_windburst) and Windburst_Pure_Single_Target_Use() Spell(windburst)
				if not CheckBoxOn(opt_piercing_shot) and Piercing_Shot_Use() Spell(piercing_shot)
				if not CheckBoxOn(opt_barrage) and Barrage_Use() Spell(barrage)
			}

			AddFunction Meme_Main
			{
                if CheckBoxOn(opt_trueshot) Spell(trueshot)
                if CheckBoxOn(opt_piercing_shot) and Piercing_Shot_Use() Spell(piercing_shot)
                if CheckBoxOn(opt_explosive_shot_detonate) and Explosive_Shot_Detonate_Use() Spell(explosive_shot_detonate text=detonate)
                if CheckBoxOn(opt_explosive_shot) and Explosive_Shot_Use() Spell(explosive_shot)
                if CheckBoxOn(opt_amoc) and MurderOfCrows_Use() Spell(a_murder_of_crows)
                if CheckBoxOn(opt_windburst) and Windburst_Use() Spell(windburst)
                if CheckBoxOn(opt_marked_shot) and MarkedShot_Use() Spell(marked_shot)
                if CheckBoxOn(opt_barrage) and Barrage_Use() Spell(barrage)
                if CheckBoxOn(opt_bursting_shot) and BurstingShot_Use() Spell(bursting_shot)
                if ArcaneShot_MarkingTargets_Use() Spell(arcane_shot)
                if Multishot_MarkingTargets_Use() Spell(multishot)
                if AimedShot_Use_Vulnerable() Spell(aimed_shot)
                if CheckBoxOn(opt_sidewinders) and Sidewinders_Use() Spell(sidewinders)
				if AimedShot_Use() Spell(aimed_shot)
				if ArcaneShot_Use() Spell(arcane_shot)
                if Multishot_Use() Spell(multishot)
			}

			AddFunction Pure_Single_Target_Main
			{
                if CheckBoxOn(opt_trueshot) Spell(trueshot)
                if CheckBoxOn(opt_amoc) and MurderOfCrows_Use() Spell(a_murder_of_crows)
                if CheckBoxOn(opt_explosive_shot_detonate) and Explosive_Shot_Detonate_Use() Spell(explosive_shot_detonate text=detonate)
                if CheckBoxOn(opt_explosive_shot) and Explosive_Shot_Use() Spell(explosive_shot)
				if CheckBoxOn(opt_marked_shot) and MarkedShot_Pure_Single_Target_Use() Spell(marked_shot)
				if Windburst_Pure_Single_Target_Use() Spell(windburst)
                if CheckBoxOn(opt_piercing_shot) and Piercing_Shot_Use() Spell(piercing_shot)
                if CheckBoxOn(opt_barrage) and Barrage_Use() Spell(barrage)
                if AimedShot_Use_Vulnerable() Spell(aimed_shot)
                if ArcaneShot_MarkingTargets_Use() Spell(arcane_shot)
                if Multishot_MarkingTargets_Use() Spell(multishot)
				if AimedShot_Use() Spell(aimed_shot)
				if ArcaneShot_Use() Spell(arcane_shot)
                if Multishot_Use() Spell(multishot)
			}

			AddFunction Meme_ShortCD_Precombat
			{
				# Short Cooldown Abilities
				if not CheckBoxOn(opt_windburst) and Windburst_Use() Spell(windburst)
				if not CheckBoxOn(opt_piercing_shot) and Piercing_Shot_Use() Spell(piercing_shot)
				if not CheckBoxOn(opt_explosive_shot_detonate) and Explosive_Shot_Detonate_Use() Spell(explosive_shot_detonate text=detonate)
				if not CheckBoxOn(opt_explosive_shot) and Explosive_Shot_Use() Spell(explosive_shot)
				if not CheckBoxOn(opt_amoc) and MurderOfCrows_Use() Spell(a_murder_of_crows)
				if not CheckBoxOn(opt_marked_shot) and MarkedShot_Use() Spell(marked_shot)
				if not CheckBoxOn(opt_barrage) and Barrage_Use() Spell(barrage)
				if not CheckBoxOn(opt_bursting_shot) and BurstingShot_Use() Spell(bursting_shot)
				if not CheckBoxOn(opt_sidewinders) and Sidewinders_Use() Spell(sidewinders)
			}

			AddFunction Pure_Single_Target_ShortCD_Precombat
			{
				# Short Cooldown Abilities
				if not CheckBoxOn(opt_amoc) and MurderOfCrows_Use() Spell(a_murder_of_crows)
				if not CheckBoxOn(opt_explosive_shot_detonate) and Explosive_Shot_Detonate_Use() Spell(explosive_shot_detonate text=detonate)
				if not CheckBoxOn(opt_explosive_shot) and Explosive_Shot_Use() Spell(explosive_shot)
				if not CheckBoxOn(opt_marked_shot) and MarkedShot_Use() Spell(marked_shot)
				if not CheckBoxOn(opt_windburst) and Windburst_Use() Spell(windburst)
				if not CheckBoxOn(opt_piercing_shot) and Piercing_Shot_Use() Spell(piercing_shot)
				if not CheckBoxOn(opt_barrage) and Barrage_Use() Spell(barrage)
			}

			AddFunction Meme_Precombat
			{
				if CheckBoxOn(opt_windburst) Spell(windburst)
				if CheckBoxOn(opt_trueshot) Spell(trueshot)
				if CheckBoxOn(opt_explosive_shot) Spell(explosive_shot)
				if CheckBoxOn(opt_marked_shot) Spell(marked_shot)
				if CheckBoxOn(opt_amoc) Spell(a_murder_of_crows)
				if CheckBoxOn(opt_barrage) Spell(barrage)
				if CheckBoxOn(opt_sidewinders) Spell(sidewinders)
				Spell(aimed_shot)
			}

			AddFunction Pure_Single_Target_Precombat
			{
				if CheckBoxOn(opt_amoc) Spell(a_murder_of_crows)
				if CheckBoxOn(opt_windburst) Spell(windburst)
				if CheckBoxOn(opt_trueshot) Spell(trueshot)
				if CheckBoxOn(opt_explosive_shot) Spell(explosive_shot)
				if CheckBoxOn(opt_marked_shot) Spell(marked_shot)
				if CheckBoxOn(opt_barrage) Spell(barrage)
				Spell(aimed_shot)
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(counter_shot) Spell(counter_shot)
					if target.Distance() < 8 Spell(arcane_torrent_focus)

					if not target.IsRaidBoss()
					{
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						if target.Distance() < 5 Spell(war_stomp)
					}
				}
			}

			###
			### Marksmanship - Main
			###
			AddFunction ShortCD
			{
				# Show volley if required and enabled, otherwise doesn't recommend at all
				if CheckBoxOn(opt_volley) and Volley_Use() Spell(volley)

				# Use the proper short CD rotation for chosen build
				if not Talent(trick_shot_talent) Meme_ShortCD()
				if Talent(trick_shot_talent) Pure_Single_Target_ShortCD()

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_exhilaration) and Exhilaration_Use() Spell(exhilaration)
				if CheckBoxOn(opt_feign_death) and FeignDeath_Use() Spell(feign_death)
			}

			AddFunction Main
			{
				# Use the proper main rotation for chosen build
				if not Talent(trick_shot_talent) Meme_Main()
				if Talent(trick_shot_talent) Pure_Single_Target_Main()
			}

			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
                if not CheckBoxOn(opt_trueshot) Spell(trueshot)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_aspect_turtle) and AspectOfTheTurtle_Use() Spell(aspect_of_the_turtle)

				# Potion
				if LunaEclipse_Potion_Use() and Potion_Use() Item(potion_of_deadly_grace)

				# Standard Abilities
				Spell(blood_fury_ap)
				Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and ArcaneTorrent_Use() Spell(arcane_torrent_focus)
				Rotation_ItemActions()
			}

			###
			### Marksmanship - Main_Precombat
			###
			AddFunction ShortCD_Precombat
			{
				# Show volley if required and enabled, otherwise doesn't recommend at all
				if CheckBoxOn(opt_volley) and Volley_Use() Spell(volley)
			}

			AddFunction Main_Precombat
			{
				# Use the proper precombat rotation for chosen build
				if not Talent(trick_shot_talent) Meme_Precombat()
				if Talent(trick_shot_talent) Pure_Single_Target_Precombat()
			}

			AddFunction CD_Precombat
			{
				# Cooldown Spells
                if not CheckBoxOn(opt_trueshot) Spell(trueshot)

				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_deadly_grace)
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

		OvaleScripts:RegisterScript("HUNTER", "marksmanship", name, desc, code, "script");
	end
end
