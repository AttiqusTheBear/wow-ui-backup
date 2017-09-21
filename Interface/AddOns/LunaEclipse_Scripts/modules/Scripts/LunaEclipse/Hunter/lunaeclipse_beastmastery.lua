local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_hunter_beastmastery";
		local desc = "LunaEclipse: Beast Mastery Hunter";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.HUNTER_BEASTMASTERY,
			ScriptAuthor = "LunaEclipse",
			ScriptCredits = "HuntsTheWind",
			GuideAuthor = "Azortharion",
			GuideLink = "http://www.icy-veins.com/wow/beast-mastery-hunter-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding"] = "3113012",
			["Dungeons / Mythic+"] = "3112111",
			["Easy Mode"] = "3113133",
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
					OPT_BARRAGE = {
						type = "toggle",
						name = BINDING_NAME_OPT_BARRAGE,
						desc = functionsConfiguration:getAOETooltip("Barrage"),
						arg = "OPT_BARRAGE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
				},
			},
			settingsBuffs = {
				type = "group",
				name = BINDING_HEADER_BUFFS_DEBUFFS,
				inline = true,
				order = 20,
				args = {
					OPT_VOLLEY = {
						type = "toggle",
						name = BINDING_NAME_OPT_VOLLEY,
						desc = functionsConfiguration:getBuffTooltip("Volley"),
						arg = "OPT_VOLLEY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "full",
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
					OPT_AMOC = {
						type = "toggle",
						name = BINDING_NAME_OPT_AMOC,
						desc = functionsConfiguration:getCooldownTooltip("A Murder of Crows"),
						arg = "OPT_AMOC",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_ASPECT_WILD = {
						type = "toggle",
						name = BINDING_NAME_OPT_ASPECT_WILD,
						desc = functionsConfiguration:getCooldownTooltip("Aspect of the Wild"),
						arg = "OPT_ASPECT_WILD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_BEASTIAL_WRATH = {
						type = "toggle",
						name = BINDING_NAME_OPT_BEASTIAL_WRATH,
						desc = functionsConfiguration:getCooldownTooltip("Beastial Wrath"),
						arg = "OPT_BEASTIAL_WRATH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_CHIMAERA_SHOT = {
						type = "toggle",
						name = BINDING_NAME_OPT_CHIMAERA_SHOT,
						desc = functionsConfiguration:getCooldownTooltip("Chimaera Shot"),
						arg = "OPT_CHIMAERA_SHOT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_DIRE_BEAST = {
						type = "toggle",
						name = BINDING_NAME_OPT_DIRE_BEAST,
						desc = functionsConfiguration:getCooldownTooltip("Dire Beast and Dire Frenzy"),
						arg = "OPT_DIRE_BEAST",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_STAMPEDE = {
						type = "toggle",
						name = BINDING_NAME_OPT_STAMPEDE,
						desc = functionsConfiguration:getCooldownTooltip("Stampede", "CD"),
						arg = "OPT_STAMPEDE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_TITANS_THUNDER = {
						type = "toggle",
						name = BINDING_NAME_OPT_TITANS_THUNDER,
						desc = functionsConfiguration:getCooldownTooltip("Titan's Thunder"),
						arg = "OPT_TITANS_THUNDER",
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
			Define(dire_frenzy_talent 5)
			Define(chimaera_shot_talent 6)
			Define(volley_talent 18)

			# Spells
			Define(aspect_of_the_turtle 186265)
				SpellInfo(aspect_of_the_turtle cd=180 gcd=0 offgcd=1)
				SpellAddBuff(aspect_of_the_turtle aspect_of_the_turtle_buff=1)
			Define(counter_shot 147362)
				SpellInfo(counter_shot cd=24 gcd=0 offgcd=1 interrupt=1,marksmanship)
			Define(exhilaration 109304)
				SpellInfo(exhilaration cd=120 gcd=0 offgcd=1)
			Define(feign_death 5384)
				SpellInfo(feign_death cd=30 gcd=0)
				SpellAddBuff(feign_death feign_death_buff=1)

			# Buffs
			Define(aspect_of_the_turtle_buff 186265)
				SpellInfo(aspect_of_the_turtle_buff duration=6)
			Define(dire_beast_buff 120694)
				SpellInfo(dire_beast_buff duration=8)
				SpellInfo(dire_beast unusable=1 talent=dire_frenzy_talent)
			Define(feign_death_buff 5384)
				SpellInfo(feign_death_buff duration=360)
			Define(pet_beast_cleave_buff 118455)

			# Artifact
			Define(surge_of_the_stormgod_trait 197354)

			# Checkboxes
			AddCheckBox(opt_barrage "AOE CD: Barrage" default)
			AddCheckBox(opt_volley "Buff: Volley" default)
			AddCheckBox(opt_amoc "Cooldown: A Murder of Crows")
			AddCheckBox(opt_aspect_wild "Cooldown: Aspect of the Wild" default)
			AddCheckBox(opt_beastial_wrath "Cooldown: Beastial Wrath" default)
			AddCheckBox(opt_chimaera_shot "Cooldown: Chimaera Shot" default)
			AddCheckBox(opt_dire_beast "Cooldown: Dire Beast" default)
			AddCheckBox(opt_stampede "Cooldown: Stampede" default)
			AddCheckBox(opt_titans_thunder "Cooldown: Titan's Thunder" default)
			AddCheckBox(opt_aspect_turtle "Defensive: Aspect of the Turtle")
			AddCheckBox(opt_feign_death "Defensive: Feign Death")
			AddCheckBox(opt_exhilaration "Heal: Exhilaration")

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					Spell(counter_shot)

					if not target.Classification(worldboss)
					{
						Spell(arcane_torrent_focus)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						Spell(war_stomp)
					}
				}
			}

			###
			### ShortCD Icon Rotations - Functions
			###
			AddFunction ShortCD_Exhilaration_Use
			{
					not SpellCooldown(exhilaration)
				and HealthPercent() <= 40
			}

			AddFunction ShortCD_FeignDeath_Use
			{
					not SpellCooldown(feign_death)
				and not BuffPresent(feign_death_buff)
				and HealthPercent() <= 40
			}

			AddFunction ShortCD_SummonPet
			{
    			if pet.IsDead()
    			{
            		if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
            		Spell(revive_pet)
				}
    			
				if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
			}

			AddFunction ShortCD_Volley_Use
			{
					Talent(volley_talent)
				and not SpellCooldown(volley)
				and not BuffPresent(volley_buff)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Summon pet if needed	
				ShortCD_SummonPet()

				# Show volley if required and enabled, otherwise doesn't recommend at all
				if CheckBoxOn(opt_volley) and ShortCD_Volley_Use() Spell(volley)

				# Short Cooldown Abilities
                if not CheckBoxOn(opt_beastial_wrath) and Main_BestialWrath_Use() Spell(bestial_wrath)
                if not CheckBoxOn(opt_aspect_wild) and Main_AspectOfTheWild_Use() Spell(aspect_of_the_wild)
                if not CheckBoxOn(opt_amoc) and Main_MurderOfCrows_Use() Spell(a_murder_of_crows)
                if not CheckBoxOn(opt_titans_thunder) and Main_TitansThunder_Use() Spell(titans_thunder)
				if not CheckBoxOn(opt_dire_beast) and Main_DireBeast_Use() Spell(dire_beast)
                if not CheckBoxOn(opt_dire_beast) and Main_DireFrenzy_Use() Spell(dire_frenzy)
                if not CheckBoxOn(opt_barrage) and Main_Barrage_Use() Spell(barrage)
                if not CheckBoxOn(opt_chimaera_shot) and Main_ChimaeraShot_Use() Spell(chimaera_shot)

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_exhilaration) and ShortCD_Exhilaration_Use() Spell(exhilaration)
				if CheckBoxOn(opt_feign_death) and ShortCD_FeignDeath_Use() Spell(feign_death)
			}

			AddFunction ShortCD_Precombat
			{
				# Summon pet if needed	
				ShortCD_SummonPet()

				# Show volley if required and enabled, otherwise doesn't recommend at all
				if CheckBoxOn(opt_volley) and ShortCD_Volley_Use() Spell(volley)
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_AspectOfTheWild_Use
			{
					not SpellCooldown(aspect_of_the_wild)
 				and {
							BuffPresent(bestial_wrath_buff)
						 or {
                                    target.TimeToDie() < 12
                                and target.Classification(worldboss)
                            }
					}
               and pet.Present()
			}
			
			AddFunction Main_Barrage_Use
			{
					Talent(barrage_talent)
				and not SpellCooldown(barrage)
                and Enemies() > 1
                and not SpellCooldown(bestial_wrath) < 3
				and Focus() >= 60
			}

			AddFunction Main_BestialWrath_Use
			{
					not SpellCooldown(bestial_wrath)
				and pet.Present()
                and SpellCooldown(kill_command) <= 3
				and Focus() >= 90
			}

			AddFunction Main_ChimaeraShot_Use
			{
					Talent(chimaera_shot_talent)
				and not SpellCooldown(chimaera_shot)
				and Focus() < 100 - Enemies() * 10
			}

			AddFunction Main_CobraShot_Use
			{
					not SpellCooldown(cobra_shot)
				and {
							{
									SpellCooldown(kill_command) > TimeToMaxFocus()
								and SpellCooldown(bestial_wrath) > TimeToMaxFocus()
							}
						 or {
									BuffPresent(bestial_wrath_buff)
                                and Enemies() == 1
                                and not Talent(killer_cobra_talent)
								and FocusRegenRate() * SpellCooldown(kill_command) > 30
							}
						 or {
                                    BuffPresent(bestial_wrath_buff)
                                and Enemies() == 1
                                and Talent(killer_cobra_talent)
                                and Focus() - 40 + FocusRegenRate() * BuffRemaining(beastial_wrath_buff) >= 30
							}
						 or {
                                    BuffPresent(bestial_wrath_buff)
                                and Enemies() > 1
                                and Talent(killer_cobra_talent)
                                and Focus() - 40 + FocusRegenRate() * BuffRemaining(beastial_wrath_buff) >= 30
                                and Focus() - 70 + FocusRegenRate() * pet.BuffRemaining(pet_beast_cleave_buff) >= 40
							}
						 or target.TimeToDie() < SpellCooldown(kill_command)
					}
				and Focus() >= 40
			}

			AddFunction Main_DireBeast_Use
			{
					not Talent(dire_frenzy_talent)
				and not SpellCooldown(dire_beast)
                and {
                            not SpellCooldown(bestial_wrath)
                        or SpellCooldown(bestial_wrath) > 2
                    }
			}

			AddFunction Main_DireFrenzy_Use
			{
					Talent(dire_frenzy_talent)
				and not SpellCooldown(dire_frenzy)
				and {
                            not SpellCooldown(bestial_wrath)
						 or SpellCooldown(bestial_wrath) > 6
						 or {
                                    target.TimeToDie() < 9
                                and target.Classification(worldboss)
                            }
					}
			}

			AddFunction Main_KillCommand_Use
			{
					not SpellCooldown(kill_command)
                and {
                            Enemies() == 1
                         or Focus() - 30 + FocusRegenRate() * pet.BuffRemaining(pet_beast_cleave_buff) >= 40
                    }
				and Focus() >= 30
			}

			AddFunction Main_MultiShot_Use
			{
					not SpellCooldown(multishot)
				and {
							Enemies() > 1
						and {
									pet.BuffRemaining(pet_beast_cleave_buff) <= GCD() * 2
								 or not pet.BuffPresent(pet_beast_cleave_buff)
							}
					}
				and Focus() >= 40
			}

			AddFunction Main_MultiShot_Use_BeastCleave
			{
					not SpellCooldown(multishot)
				and {
							Enemies() > 4
						and {
									pet.BuffRemaining(pet_beast_cleave_buff) <= GCD()
								 or not pet.BuffPresent(pet_beast_cleave_buff)
							}
					}
				and Focus() >= 40
			}

			AddFunction Main_MurderOfCrows_Use
			{
					Talent(a_murder_of_crows_talent)
				and not SpellCooldown(a_murder_of_crows)
                and target.TimeToDie() > 2
                and {
                            BuffPresent(bestial_wrath_buff)
						 or SpellCooldown(bestial_wrath) > 2
                    }
				and Focus() >= 30
			}

			AddFunction Main_Stampede_Use
			{
					Talent(stampede_talent)
				and not SpellCooldown(stampede)
				and {
							BloodlustActive()
						 or BuffPresent(bestial_wrath_buff)
						 or SpellCooldown(bestial_wrath) <= 2
						 or {
                                    target.TimeToDie() <= 14
                                and target.IsBoss()
                            }
					}
			}

			AddFunction Main_TitansThunder_Use
			{
					SpellKnown(titans_thunder)
				and not SpellCooldown(titans_thunder)
				and {
							{
                                    not Talent(dire_frenzy_talent)
								and	BuffPresent(dire_beast_buff)
								and BuffRemaining(dire_beast_buff) >= 6
							}
						 or Talent(dire_frenzy_talent)
					}
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
                if Main_MultiShot_Use_BeastCleave() Spell(multishot)
                if CheckBoxOn(opt_beastial_wrath) and Main_BestialWrath_Use() Spell(bestial_wrath)
                if CheckBoxOn(opt_aspect_wild) and Main_AspectOfTheWild_Use() Spell(aspect_of_the_wild)
                if CheckBoxOn(opt_amoc) and Main_MurderOfCrows_Use() Spell(a_murder_of_crows)
                if CheckBoxOn(opt_stampede) and Main_Stampede_Use() Spell(stampede)
                if CheckBoxOn(opt_titans_thunder) and Main_TitansThunder_Use() Spell(titans_thunder)
				if CheckBoxOn(opt_dire_beast) and Main_DireBeast_Use() Spell(dire_beast)
                if CheckBoxOn(opt_dire_beast) and Main_DireFrenzy_Use() Spell(dire_frenzy)
                if CheckBoxOn(opt_barrage) and Main_Barrage_Use() Spell(barrage)
                if Main_KillCommand_Use() Spell(kill_command)
                if Main_MultiShot_Use() Spell(multishot)
                if CheckBoxOn(opt_chimaera_shot) and Main_ChimaeraShot_Use() Spell(chimaera_shot)
                if Main_CobraShot_Use() Spell(cobra_shot)
			}

			AddFunction Main_Precombat
			{
			}

			###
			### CD Icon Rotations - Functions
			###
			AddFunction CD_ArcaneTorrent_Use
			{
                    SpellKnown(arcane_torrent_focus)
				and FocusDeficit() >= 30
			}

			AddFunction CD_AspectOfTheTurtle_Use
			{
					not SpellCooldown(aspect_of_the_turtle)
				and not BuffPresent(aspect_of_the_turtle_buff)
				and HealthPercent() <= 40
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and {
									BuffPresent(bestial_wrath_buff)
								 or not SpellCooldown(bestial_wrath)
							}
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

				# Cooldown Abilities
                if not CheckBoxOn(opt_stampede) and Main_Stampede_Use() Spell(stampede)
				
				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_prolonged_power)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_aspect_turtle) and CD_AspectOfTheTurtle_Use() Spell(aspect_of_the_turtle)

				# Standard Abilities
				Spell(blood_fury_ap)
				Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_focus)
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

		OvaleScripts:RegisterScript("HUNTER", "beast_mastery", name, desc, code, "script");
	end
end
