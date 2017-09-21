local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_paladin_retribution";
		local desc = "LunaEclipse: Retribution Paladin";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.PALADIN_RETRIBUTION,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Fardion",
			GuideLink = "http://www.icy-veins.com/wow/retribution-paladin-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Single Target"] = "2102012",
			["Cleave"] = "3203012",
			["AOE"] = "3303012",
			["Easy Mode"] = "3133212",
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
					OPT_CONSECRATION = {
						type = "toggle",
						name = BINDING_NAME_OPT_CONSECRATION,
						desc = functionsConfiguration:getAOETooltip("Consecration"),
						arg = "OPT_CONSECRATION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_DIVINE_HAMMER = {
						type = "toggle",
						name = BINDING_NAME_OPT_DIVINE_HAMMER,
						desc = functionsConfiguration:getAOETooltip("Divine Hammer"),
						arg = "OPT_DIVINE_HAMMER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_DIVINE_STORM = {
						type = "toggle",
						name = BINDING_NAME_OPT_DIVINE_STORM,
						desc = functionsConfiguration:getAOETooltip("Divine Storm"),
						arg = "OPT_DIVINE_STORM",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_HOLY_WRATH = {
						type = "toggle",
						name = BINDING_NAME_OPT_HOLY_WRATH,
						desc = string.format("%s\n\n%s", functionsConfiguration:getAOETooltip("Holy Wrath"), "This ability will only be suggested when you are below 40% health for maximum benefit!"),
						arg = "OPT_HOLY_WRATH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
				},
			},
			settingsCooldowns = {
				type = "group",
				name = BINDING_HEADER_COOLDOWNS,
				inline = true,
				order = 30,
				args = {
					OPT_AVENGING_WRATH = {
						type = "toggle",
						name = BINDING_NAME_OPT_AVENGING_WRATH,
						desc = functionsConfiguration:getCooldownTooltip("Avenging Wrath and Crusade", "CD"),
						arg = "OPT_AVENGING_WRATH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_EXECUTION_SENTENCE = {
						type = "toggle",
						name = BINDING_NAME_OPT_EXECUTION_SENTENCE,
						desc = functionsConfiguration:getCooldownTooltip("Execution Sentence"),
						arg = "OPT_EXECUTION_SENTENCE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
					OPT_WAKE_OF_ASHES = {
						type = "toggle",
						name = BINDING_NAME_OPT_WAKE_OF_ASHES,
						desc = functionsConfiguration:getCooldownTooltip("Wake of Ashes"),
						arg = "OPT_WAKE_OF_ASHES",
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
					OPT_DIVINE_SHIELD = {
						type = "toggle",
						name = BINDING_NAME_OPT_DIVINE_SHIELD,
						desc = functionsConfiguration:getDefensiveTooltip("Divine Shield", "CD", "40%"),
						arg = "OPT_DIVINE_SHIELD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_EYE_FOR_AN_EYE = {
						type = "toggle",
						name = BINDING_NAME_OPT_EYE_FOR_AN_EYE,
						desc = functionsConfiguration:getDefensiveTooltip("Eye for an Eye", "ShortCD", "95%"),
						arg = "OPT_EYE_FOR_AN_EYE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_SHIELD_OF_VENGEANCE = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHIELD_OF_VENGEANCE,
						desc = functionsConfiguration:getDefensiveTooltip("Shield of Vengeance", "CD", "95%"),
						arg = "OPT_SHIELD_OF_VENGEANCE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 30,
					},
					OPT_LAY_ON_HANDS = {
						type = "toggle",
						name = BINDING_NAME_OPT_LAY_ON_HANDS,
						desc = functionsConfiguration:getDefensiveTooltip("Lay on Hands", "CD", "40%"),
						arg = "OPT_LAY_ON_HANDS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_WORD_OF_GLORY = {
						type = "toggle",
						name = BINDING_NAME_OPT_WORD_OF_GLORY,
						desc = functionsConfiguration:getDefensiveTooltip("Word of Glory", "ShortCD", "40%"),
						arg = "OPT_WORD_OF_GLORY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(ovale_paladin_spells)
			Include(lunaeclipse_global)

			# Talents
			Define(execution_sentence_talent 2)
			Define(consecration_talent 3)
			Define(justicars_vengence_talent 13)
			Define(eye_for_an_eye_talent 14)
			Define(word_of_glory_talent 15)
			Define(holy_wrath_talent 21)

			# Spells
			Define(eye_for_an_eye 205191)
				SpellInfo(eye_for_an_eye cd=60 gcd=1.5)
				SpellAddBuff(eye_for_an_eye eye_for_an_eye_buff=1)
			Define(word_of_glory 210191)
				SpellInfo(word_of_glory cd=1 holy=finisher max_holy=3)
				SpellInfo(word_of_glory gcd=0 offgcd=1)
				SpellRequire(word_of_glory holy 0=buff,word_of_glory_no_holy_buff)
				SpellAddBuff(word_of_glory bastion_of_glory_buff=0 if_spell=shield_of_the_righteous)
				SpellAddBuff(word_of_glory bastion_of_power_buff=0 if_spell=shield_of_the_righteous itemset=T16_tank itemcount=4)
				SpellAddBuff(word_of_glory divine_purpose_buff=0 if_spell=divine_purpose)
				SpellAddBuff(word_of_glory lawful_words_buff=0 itemset=T17 itemcount=4 specialization=holy)

			# Buffs
			Define(eye_for_an_eye_buff 205191)
				SpellInfo(eye_for_an_eye_buff duration=10)

			# Legendaries
			Define(liadrins_fury_unleashed 137048)
			Define(whisper_of_the_nathrezim 137020)

			# Legendaries Buffs
			Define(liadrins_fury_unleashed_buff 208410)
			Define(whisper_of_the_nathrezim_buff 207633)
				SpellInfo(whisper_of_the_nathrezim_buff duration=4)

			# Artifact
			Define(ashes_to_ashes_trait 179546)
			Define(echo_of_the_highlord_trait 186788)

			# Checkboxes
			AddCheckBox(opt_consecration "AOE: Consecration" default)
			AddCheckBox(opt_divine_hammer "AOE: Divine Hammer" default)
			AddCheckBox(opt_divine_storm "AOE: Divine Storm" default)
			AddCheckBox(opt_holy_wrath "AOE CD: Holy Wrath" default)
			AddCheckBox(opt_avenging_wrath "Cooldown: Avenging Wrath" default)
			AddCheckBox(opt_execution_sentence "Cooldown: Eye for an Eye" default)
			AddCheckBox(opt_wake_of_ashes "Cooldown: Wake of Ashes" default)
			AddCheckBox(opt_divine_shield "Defensive: Divine Shield" default)		
			AddCheckBox(opt_eye_for_an_eye "Defensive: Eye for an Eye" default)
			AddCheckBox(opt_shield_of_vengeance "Defensive: Shield of Vengeance" default)		
			AddCheckBox(opt_lay_on_hands "Heal: Lay on Hands" default)
			AddCheckBox(opt_word_of_glory "Heal: Word of Glory" default)

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(rebuke) Spell(rebuke)
					if target.Distance() < 8 Spell(arcane_torrent_holy)

					if not target.IsRaidBoss()
					{
						if target.RangeCheck(hammer_of_justice) Spell(hammer_of_justice)
						if target.Distance() < 5 Spell(war_stomp)
					}
				}
			}

			###
			### ShortCD Icon Rotation - Functions
			###
			AddFunction ShortCD_EyeForAnEye_Use
			{
					Talent(eye_for_an_eye_talent)
				and not SpellCooldown(eye_for_an_eye)
				and not BuffPresent(eye_for_an_eye_buff)
				and player.HealthPercent() <= 95
			}
			
			AddFunction ShortCD_MeleeRange_Use
			{
					CheckBoxOn(opt_melee_range) 
				and not target.RangeCheck(crusader_strike)
			}

			AddFunction ShortCD_WordOfGlory_Use
			{
					Talent(word_of_glory_talent)
				and SpellCharges(word_of_glory) >= 1
				and HealthPercent() <= 40
				and HolyPower() >= 3
			}

			###
			### ShortCD Icon Rotation
			###
			AddFunction ShortCD
			{
				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
				
				# Short CD Spells
				if not CheckBoxOn(opt_execution_sentence) and Main_ExecutionSentence_Use() Spell(execution_sentence)
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_DivinePurpose_Expiring() Spell(divine_storm)
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_DivinePurpose_HolyPower_Max() Spell(divine_storm)				
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_Crusade() Spell(divine_storm)				
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_HolyPower_Max() Spell(divine_storm)				
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_WhisperOfNathrezim() Spell(divine_storm)		
				if not CheckBoxOn(opt_wake_of_ashes) and Main_WakeOfAshes_Use() Spell(wake_of_ashes)
				if not CheckBoxOn(opt_divine_hammer) and Main_DivineHammer_Use_WhisperOfNathrezim() Spell(divine_hammer)
				if not CheckBoxOn(opt_divine_hammer) and Main_DivineHammer_Use() Spell(divine_hammer)
				if not CheckBoxOn(opt_consecration) and Main_Consecration_Use() Spell(consecration)
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_DivinePurpose() Spell(divine_storm)
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_FiresOfJustice() Spell(divine_storm)
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use() Spell(divine_storm)
				if not CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_NoCrusade() Spell(divine_storm)
				
				# Healing and Defensive Spells, only show if enabled.
				if Main_HolyWrath_Use() Spell(holy_wrath)
				if CheckBoxOn(opt_word_of_glory) and ShortCD_WordOfGlory_Use() Spell(word_of_glory)
				if CheckBoxOn(opt_eye_for_an_eye) and ShortCD_EyeForAnEye_Use() Spell(eye_for_an_eye)
			}

			AddFunction ShortCD_Precombat
			{
				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))

				# Healing and Defensive Spells, only show if enabled.
				if Main_HolyWrath_Use() Spell(holy_wrath)
				if CheckBoxOn(opt_word_of_glory) and ShortCD_WordOfGlory_Use() Spell(word_of_glory)
				if CheckBoxOn(opt_eye_for_an_eye) and ShortCD_EyeForAnEye_Use() Spell(eye_for_an_eye)
			}

			###
			### Main Icon Rotation - Functions
			###
			AddFunction Main_AvengingWrath_Use
			{
					not Talent(crusade_talent)
				and SpellCharges(avenging_wrath_melee) >= 1
				and target.DebuffPresent(judgment_debuff)
				and HolyPower() == 5
			}

			AddFunction Main_BladeOfJustice_Use
			{
					not SpellCooldown(blade_of_justice)
				and HolyPower() <= 3
			}
			
			AddFunction Main_Consecration_Use
			{
					Talent(consecration_talent)
				and not SpellCooldown(consecration)
			}

			AddFunction Main_Crusade_Use
			{
					Talent(crusade_talent)
				and not SpellCooldown(crusade)
				and target.DebuffPresent(judgment_debuff)
				and {
							{
									HolyPower() >= 5
								and not LegendaryEquipped(liadrins_fury_unleashed)
							}
						 or {
									{
											LegendaryEquipped(liadrins_fury_unleashed)
										 or Race(BloodElf)
									}
								and HolyPower() >= 4
							}
					}
			}

			AddFunction Main_CrusaderStrike_Use
			{
					not Talent(zeal_talent)
				and HolyPower() <= 4
			}

			AddFunction Main_CrusaderStrike_Use_FullCharges
			{
					not Talent(zeal_talent)
				and SpellCharges(crusader_strike) == 2
				and HolyPower() <= 4
			}

			AddFunction Main_DivineHammer_Use
			{
					Talent(divine_hammer_talent)
				and not SpellCooldown(divine_hammer)
				and {
							HolyPower() <= 2
						 or {
									HolyPower() <= 3
								and {
											SpellCharges(zeal count=0) <= 1.34
										 or SpellCharges(crusader_strike count=0) <= 1.34
									}
							}
					}
			}

			AddFunction Main_DivineHammer_Use_WhisperOfNathrezim
			{
					Talent(divine_hammer_talent)
				and not SpellCooldown(divine_hammer)
				and HolyPower() <= 3
				and BuffPresent(whisper_of_the_nathrezim_buff)
				and BuffRemaining(whisper_of_the_nathrezim_buff) > GCD()
				and BuffRemaining(whisper_of_the_nathrezim_buff) < GCD() * 3
				and target.DebuffPresent(judgment_debuff)
				and target.DebuffRemaining(judgment_debuff) > GCD() * 2
			}
			
			AddFunction Main_DivineStorm_Use
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and Enemies() >= 2
				and {
							HolyPower() >= 4
						 or {
									{
											SpellCharges(zeal count=0) <= 1.34
										 or SpellCharges(crusader_strike count=0) <= 1.34
									}
								and {
											SpellCooldown(divine_hammer) > GCD()
										 or SpellCooldown(blade_of_justice) > GCD()
									}
							}
					}
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 4
					}
				and HolyPower() >= 3
			}

			AddFunction Main_DivineStorm_Use_Crusade
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and Enemies() >= 2
				and HolyPower() >= 3
				and BuffPresent(crusade_buff)
				and {
							BuffStacks(crusade_buff) < 15
						 or BloodlustActive()
					}
			}

			AddFunction Main_DivineStorm_Use_DivinePurpose
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and Enemies() >= 2
				and BuffPresent(divine_purpose_buff)
			}

			AddFunction Main_DivineStorm_Use_DivinePurpose_Expiring
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and Enemies() >= 2
				and BuffPresent(divine_purpose_buff)
				and BuffRemaining(divine_purpose_buff) < GCD() * 2
			}

			AddFunction Main_DivineStorm_Use_DivinePurpose_HolyPower_Max
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and Enemies() >= 2
				and HolyPower() >= 5
				and BuffPresent(divine_purpose_buff)
			}

			AddFunction Main_DivineStorm_Use_FiresOfJustice
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and Enemies() >= 2
				and BuffPresent(the_fires_of_justice_buff)
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 3
					}
				and HolyPower() >= 3
			}

			AddFunction Main_DivineStorm_Use_HolyPower_Max
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and Enemies() >= 2
				and HolyPower() >= 5
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 3
					}
			}

			AddFunction Main_DivineStorm_Use_NoCrusade
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and HolyPower() >= 3
				and Enemies() >= 2
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 5
					}
			}

			AddFunction Main_DivineStorm_Use_WhisperOfNathrezim
			{
					not SpellCooldown(divine_storm)
				and target.DebuffPresent(judgment_debuff)
				and HolyPower() >= 3
				and Enemies() >= 2
				and {
							{
									SpellKnown(wake_of_ashes)
								and SpellCooldown(wake_of_ashes) < GCD() * 2
							}
						 or {
									BuffPresent(whisper_of_the_nathrezim_buff)
								and BuffRemaining(whisper_of_the_nathrezim_buff) < GCD()
							}
					}
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 4
					}
			}

			AddFunction Main_DraughtOfSouls_Use
			{
					LegendaryEquipped(draught_of_souls)
				and {
							BuffPresent(avenging_wrath_buff)
						 or BuffStacks(crusade_buff) >= 15
						 or {
									SpellCooldown(crusade) > 20
								and not BuffPresent(crusade_buff)
							}
					}
			}

			AddFunction Main_ExecutionSentence_Use
			{
					Talent(execution_sentence_talent)
				and not SpellCooldown(execution_sentence)
				and Enemies() <= 3
				and {
							SpellCooldown(judgment) < GCD() * 4.65
						 or target.DebuffRemaining(judgment_debuff) > GCD() * 4.65
					}
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 2
					}
				and HolyPower() >= 3
			}

			AddFunction Main_HolyWrath_Use
			{
					Talent(holy_wrath_talent)
				and not SpellCooldown(holy_wrath)
				and HealthPercent() <= 40
			}

			AddFunction Main_Judgment_Use
			{
					SpellCharges(judgment) >= 1
				and Mana() > ManaCost(judgment)
			}

			AddFunction Main_Judgment_Use_ExecutionSentence
			{
					SpellCharges(judgment) >= 1
				and target.DebuffPresent(execution_sentence_debuff)
				and target.DebuffRemaining(execution_sentence_debuff) < GCD() * 2
				and target.DebuffRemaining(judgment_debuff) < GCD() * 2
				and Mana() > ManaCost(judgment)
			}

			AddFunction Main_ShieldOfVengeance_Use
			{
					not SpellCooldown(shield_of_vengeance)
				and not BuffPresent(shield_of_vengeance_buff)
			}

			AddFunction Main_TemplarsVerdict_Use
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and {
							HolyPower() >= 4
						 or {
									{
											SpellCharges(zeal count=0) <= 1.34
										 or SpellCharges(crusader_strike count=0) <= 1.34
									}
								and {
											SpellCooldown(divine_hammer) > GCD()
										 or SpellCooldown(blade_of_justice) > GCD()
									}
							}
					}
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 4
					}
				and {
							not Talent(execution_sentence_talent)
						 or SpellCooldown(execution_sentence) > GCD() * 2
					}
				and HolyPower() >= 3
			}

			AddFunction Main_TemplarsVerdict_Use_Crusade
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and HolyPower() >= 3
				and BuffPresent(crusade_buff)
				and {
							BuffStacks(crusade_buff) < 15
						 or BloodlustActive()
					}
			}

			AddFunction Main_TemplarsVerdict_Use_DivinePurpose
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and BuffPresent(divine_purpose_buff)
			}

			AddFunction Main_TemplarsVerdict_Use_DivinePurpose_Expiring
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and BuffPresent(divine_purpose_buff)
				and BuffRemaining(divine_purpose_buff) < GCD() * 2
			}

			AddFunction Main_TemplarsVerdict_Use_DivinePurpose_HolyPower_Max
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and HolyPower() >= 5
				and BuffPresent(divine_purpose_buff)
			}

			AddFunction Main_TemplarsVerdict_Use_FiresOfJustice
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and BuffPresent(the_fires_of_justice_buff)
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 3
					}
				and HolyPower() >= 3
			}

			AddFunction Main_TemplarsVerdict_Use_HolyPower_Max
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and HolyPower() >= 5
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 3
					}
				and {
							not Talent(execution_sentence_talent)
						 or SpellCooldown(execution_sentence) > GCD()
					}
			}

			AddFunction Main_TemplarsVerdict_Use_NoCrusade
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and HolyPower() >= 3
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 5
					}
			}

			AddFunction Main_TemplarsVerdict_Use_WhisperOfNathrezim
			{
					not SpellCooldown(templars_verdict)
				and target.DebuffPresent(judgment_debuff)
				and HolyPower() >= 3
				and {
							{
									SpellKnown(wake_of_ashes)
								and SpellCooldown(wake_of_ashes) < GCD() * 2
							}
						 or {
									BuffPresent(whisper_of_the_nathrezim_buff)
								and BuffRemaining(whisper_of_the_nathrezim_buff) < GCD()
							}
					}
				and {
							not Talent(crusade_talent)
						 or SpellCooldown(crusade) > GCD() * 4
					}
			}

			AddFunction Main_WakeOfAshes_Use
			{
					SpellKnown(wake_of_ashes)
				and not SpellCooldown(wake_of_ashes)
				and {
							HolyPower() == 0
						 or {
									HolyPower() == 1
								and {
											SpellCooldown(blade_of_justice) > GCD()
										 or SpellCooldown(divine_hammer) > GCD()
									}
							}
						 or {
									HolyPower() == 2
								and {
											SpellCharges(zeal count=0) <= 0.65
										 or SpellCharges(crusader_strike count=0) <= 0.65
									}
							}
					}
			}

			AddFunction Main_Zeal_Use
			{
					Talent(zeal_talent)
				and HolyPower() <= 4
			}

			AddFunction Main_Zeal_Use_FullCharges
			{
					Talent(zeal_talent)
				and SpellCharges(zeal) == 2
				and HolyPower() <= 4
			}

			###
			### Main Icon Rotation
			###
			AddFunction Main
			{
				if CheckBoxOn(opt_draught_of_souls) and Main_DraughtOfSouls_Use() Item(draught_of_souls)
				if CheckBoxOn(opt_holy_wrath) and Main_HolyWrath_Use() Spell(holy_wrath)
				if CheckBoxOn(opt_avenging_wrath) and Main_AvengingWrath_Use() Spell(avenging_wrath_melee)
				if CheckBoxOn(opt_shield_of_vengeance) and Main_ShieldOfVengeance_Use() Spell(shield_of_vengeance)
				if CheckBoxOn(opt_avenging_wrath) and Main_Crusade_Use() Spell(crusade)
				if CheckBoxOn(opt_execution_sentence) and Main_ExecutionSentence_Use() Spell(execution_sentence)
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_DivinePurpose_Expiring() Spell(divine_storm)
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_DivinePurpose_HolyPower_Max() Spell(divine_storm)				
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_Crusade() Spell(divine_storm)				
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_HolyPower_Max() Spell(divine_storm)				
				if Main_TemplarsVerdict_Use_DivinePurpose_Expiring() Spell(templars_verdict)
				if Main_TemplarsVerdict_Use_DivinePurpose_HolyPower_Max() Spell(templars_verdict)
				if Main_TemplarsVerdict_Use_Crusade() Spell(templars_verdict)
				if Main_TemplarsVerdict_Use_HolyPower_Max() Spell(templars_verdict)
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_WhisperOfNathrezim() Spell(divine_storm)		
				if Main_TemplarsVerdict_Use_WhisperOfNathrezim() Spell(templars_verdict)
				if Main_Judgment_Use_ExecutionSentence() Spell(judgment)
				if CheckBoxOn(opt_wake_of_ashes) and Main_WakeOfAshes_Use() Spell(wake_of_ashes)
				if CheckBoxOn(opt_divine_hammer) and Main_DivineHammer_Use_WhisperOfNathrezim() Spell(divine_hammer)
				if Main_BladeOfJustice_Use() Spell(blade_of_justice)
				if Main_Zeal_Use_FullCharges() Spell(zeal)
				if Main_CrusaderStrike_Use_FullCharges() Spell(crusader_strike)
				if CheckBoxOn(opt_divine_hammer) and Main_DivineHammer_Use() Spell(divine_hammer)
				if Main_Judgment_Use() Spell(judgment)
				if CheckBoxOn(opt_consecration) and Main_Consecration_Use() Spell(consecration)
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_DivinePurpose() Spell(divine_storm)
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_FiresOfJustice() Spell(divine_storm)
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use() Spell(divine_storm)
				if Main_TemplarsVerdict_Use_DivinePurpose() Spell(templars_verdict)
				if Main_TemplarsVerdict_Use_FiresOfJustice() Spell(templars_verdict)
				if Main_TemplarsVerdict_Use() Spell(templars_verdict)
				if Main_Zeal_Use() Spell(zeal)
				if Main_CrusaderStrike_Use() Spell(crusader_strike)
				if CheckBoxOn(opt_divine_storm) and Main_DivineStorm_Use_NoCrusade() Spell(divine_storm)
				if Main_TemplarsVerdict_Use_NoCrusade() Spell(templars_verdict)
			}

			AddFunction Main_Precombat
			{
			}

			###
			### CD Icon Rotation - Functions
			###
			AddFunction CD_ArcaneTorrent_Use
			{
					{
							BuffPresent(crusade)
						 or BuffPresent(avenging_wrath)
					}
				and HolyPowerDeficit() >= 1
			}

			AddFunction CD_DivineShield_Use
			{
					not SpellCooldown(divine_shield)
				and not DebuffPresent(forbearance_debuff)
				and HealthPercent() <= 40
			}

			AddFunction CD_LayOnHands_Use
			{
					not SpellCooldown(lay_on_hands)
				and not DebuffPresent(forbearance_debuff)
				and HealthPercent() <= 40
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and {
									BuffPresent(avenging_wrath_buff)
								 or {
											BuffPresent(crusade_buff)
										and BuffRemaining(crusade_buff) < 25
									}
							}
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 40
			}

			###
			### CD Icon Rotation
			###
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
				if not CheckBoxOn(opt_draught_of_souls) and Main_DraughtOfSouls_Use() Item(draught_of_souls)
				if not CheckBoxOn(opt_avenging_wrath) and Main_AvengingWrath_Use() Spell(avenging_wrath_melee)
				if not CheckBoxOn(opt_shield_of_vengeance) and Main_ShieldOfVengeance_Use() Spell(shield_of_vengeance)
				if not CheckBoxOn(opt_avenging_wrath) and Main_Crusade_Use() Spell(crusade)
				
				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_the_old_war)

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_lay_on_hands) and CD_LayOnHands_Use() Spell(lay_on_hands)
				if CheckBoxOn(opt_divine_shield) and CD_DivineShield_Use() Spell(divine_shield)

				# Stardard Actions
				Spell(blood_fury_ap)
				Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_holy)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_the_old_war)
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

		OvaleScripts:RegisterScript("PALADIN", "retribution", name, desc, code, "script");
	end
end