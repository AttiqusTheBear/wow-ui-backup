local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_priest_shadow";
		local desc = "LunaEclipse: Shadow Priest";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.PRIEST_SHADOW,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "HowToPriest and SimCraft",
			GuideLink = "https://howtopriest.com/viewtopic.php?f=19&t=8402",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["San'lyan (Mastery)"] = "1001131",
			["Auspicious Spirits (Critical Strike)"] = "1001231",
			["Surrender to Madness"] = "1002213",
			["Dungeon / Mythic+"] = "1001321",
			["Solo / World Quests"] = "1111221",
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
					OPT_SHADOW_CRASH = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHADOW_CRASH,
						desc = functionsConfiguration:getAOETooltip("Shadow Crash"),
						arg = "OPT_SHADOW_CRASH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
				},
			},
			settingsBuff = {
				type = "group",
				name = BINDING_HEADER_BUFFS_DEBUFFS,
				inline = true,
				order = 20,
				args = {
					OPT_SHADOWFORM = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHADOWFORM,
						desc = functionsConfiguration:getBuffTooltip("Shadowform"),
						arg = "OPT_SHADOWFORM",
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
					OPT_DISPERSION_SURRENDER = {
						type = "toggle",
						name = BINDING_NAME_OPT_DISPERSION_SURRENDER,
						desc = string.format("%s\n\n%s", functionsConfiguration:getCooldownTooltip("Dispersion"), "This only applies to the use of Dispersion during Surrender to Madness to slow energy drain!"),
						arg = "OPT_DISPERSION_SURRENDER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 10,
					},
					OPT_POWER_INFUSION = {
						type = "toggle",
						name = BINDING_NAME_OPT_POWER_INFUSION,
						desc = functionsConfiguration:getCooldownTooltip("Power Infusion", "CD"),
						arg = "OPT_POWER_INFUSION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_SHADOW_WORD_VOID = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHADOW_WORD_VOID,
						desc = functionsConfiguration:getCooldownTooltip("Shadow Word: Void"),
						arg = "OPT_SHADOW_WORD_VOID",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_SHADOWFIEND = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHADOWFIEND,
						desc = functionsConfiguration:getCooldownTooltip("Shadowfiend and Mindbender", "CD"),
						arg = "OPT_SHADOWFIEND",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_SURRENDER = {
						type = "toggle",
						name = BINDING_NAME_OPT_SURRENDER,
						desc = functionsConfiguration:getCooldownTooltip("Surrender to Madness", "CD"),
						arg = "OPT_SURRENDER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 50,
					},
					OPT_VOID_ERRUPTION = {
						type = "toggle",
						name = BINDING_NAME_OPT_VOID_ERRUPTION,
						desc = functionsConfiguration:getCooldownTooltip("Void Erruption"),
						arg = "OPT_VOID_ERRUPTION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_VOID_TORRENT = {
						type = "toggle",
						name = BINDING_NAME_OPT_VOID_TORRENT,
						desc = functionsConfiguration:getCooldownTooltip("Void Torrent"),
						arg = "OPT_VOID_TORRENT",
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
					OPT_DISPERSION = {
						type = "toggle",
						name = BINDING_NAME_OPT_DISPERSION,
						desc = string.format("%s\n\n%s\n\n%s", functionsConfiguration:getDefensiveTooltip("Dispersion", "ShortCD", "40%"), "This option only applies to suggestion of Dispersion as a defensive ability.", "This will only suggest if dispersion will be available before its time to use Surrender to Madness, or you have not chosen the Surrender to Madness talent!"),
						arg = "OPT_DISPERSION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_POWER_WORD_SHIELD = {
						type = "toggle",
						name = BINDING_NAME_OPT_POWER_WORD_SHIELD,
						desc = functionsConfiguration:getDefensiveTooltip("Power Word: Shield"),
						arg = "OPT_POWER_WORD_SHIELD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
				},
			},
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(ovale_priest_spells)
			Include(lunaeclipse_global)

			# Talents
			Define(twist_of_fate_talent 1)
			Define(fortress_of_the_mind_talent 2)
			Define(shadow_word_void_talent 3)
			Define(mania_talent 4)
			Define(body_and_soul_talent 5)
			Define(masochism_talent 6)
			Define(mind_bomb_talent 7)
			Define(psychic_voice_talent 8)
			Define(dominant_mind_talent 9)
			Define(lingering_insanity_talent 10)
			Define(reaper_of_souls_talent 11)
			Define(void_ray_talent 12)
			Define(sanlayn_talent 13)
			Define(auspicious_spirits_talent 14)
			Define(shadowy_insight_talent 15)
			Define(power_infusion_talent 16)
			Define(misery_talent 17)
			Define(mindbender_talent 18)
			Define(legacy_of_the_void_talent 19)
			Define(shadow_crash_talent 20)
			Define(surrender_to_madness_talent 21)

			# Spells
			Define(power_word_shield 17)
				SpellInfo(power_word_shield cd=7.5)
				SpellInfo(power_word_shield cd=7.5 cd_haste=spell)
				SpellAddBuff(power_word_shield power_word_shield_buff=1)
				SpellRequire(power_word_shield cd 0=buff,rapture_buff)

			# Buffs
			Define(power_word_shield_buff 17)
				SpellInfo(power_word_shield_buff duration=15)

			# Artifact
			Define(lash_of_insanity_trait 238137)
			Define(sphere_of_insanity_trait 194179)
			Define(unleash_the_shadows_trait 194093)

			# Legendaries
			Define(mangazas_madness 132864)

			# Legendary Buffs
			Define(zeks_exterminatus_buff 236546)
				SpellInfo(zeks_exterminatus_buff duration=15)

			# Checkboxes
			AddCheckBox(opt_shadow_crash "AOE CD: Shadow Crash" default) # ShortCD
			AddCheckBox(opt_shadowform "Buff: Shadowform" default) # ShortCD
			AddCheckBox(opt_dispersion_surrender "Cooldown: Dispersion (Surrender to Madness)" default) # ShortCD
			AddCheckBox(opt_power_infusion "Cooldown: Power Infusion" default) # CD
			AddCheckBox(opt_shadow_word_void "Cooldown: Shadow Word Void" default) # ShortCD
			AddCheckBox(opt_shadowfiend "Cooldown: Shadowfiend" default) # CD
			AddCheckBox(opt_surrender "Cooldown: Surrender to Madness" default) # CD
			AddCheckBox(opt_void_erruption "Cooldown: Void Erruption" default) # ShortCD
			AddCheckBox(opt_void_torrent "Cooldown: Void Torrent" default) # ShortCD
			AddCheckBox(opt_dispersion "Defensive: Dispersion" default) # ShortCD
			AddCheckBox(opt_power_word_shield "Defensive: Power Word Shield" default) # ShortCD

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(silence) Spell(silence)
					if target.Distance() < 8 Spell(arcane_torrent_mana)

					if not target.IsRaidBoss()
					{
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						if target.Distance() < 5 Spell(war_stomp)
					}
				}
			}

			###
			### MultiDot Icon Rotations - Functions
			###
			AddFunction MultiDot_ShadowWordPain_Use
			{
					not SpellCooldown(shadow_word_pain)
				and not Talent(misery_talent)
				and DOTTargetCount(shadow_word_pain_debuff) < MultiDOTTargets()
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction MultiDot_VampiricTouch_Use
			{
					not SpellCooldown(vampiric_touch)
				and not Talent(misery_talent)
				and DOTTargetCount(vampiric_touch_debuff) < MultiDOTTargets()
				and target.RangeCheck(vampiric_touch)
			}

			AddFunction MultiDot_VampiricTouch_Use_Misery
			{
					not SpellCooldown(vampiric_touch)
				and Talent(misery_talent)
				and {
							DOTTargetCount(vampiric_touch_debuff) < MultiDOTTargets()
						 or DOTTargetCount(shadow_word_pain_debuff) < MultiDOTTargets()
					}
				and target.RangeCheck(vampiric_touch)
			}

			###
			### MultiDot Icon Rotations
			###
			AddFunction MultiDot
			{
				if MultiDot_VampiricTouch_Use_Misery() Spell(vampiric_touch text=multi)
				if MultiDot_ShadowWordPain_Use() Spell(shadow_word_pain text=multi)
				if MultiDot_VampiricTouch_Use() Spell(vampiric_touch text=multi)
			}

			AddFunction MultiDot_Precombat
			{
			}

			###
			### ShortCD Icon Rotations - Functions
			###
			AddFunction ShortCD_Dispersion_Use
			{
					not SpellCooldown(dispersion)
				and not BloodlustActive()
				and not BuffPresent(power_infusion_buff)
				and HealthPercent() <= 40
				and {
							not Talent(surrender_to_madness_talent)	
						 or {
									Talent(surrender_to_madness_talent)
								and target.TimeToDie() > SurrendToMadnessCheck() - InsanityDrainStacks() + { TimeToNextDispersion() / 2 }
							}
					}
			}

			AddFunction ShortCD_PowerWordShield_Use
			{
					not SpellCooldown(power_word_shield)
				and not BuffPresent(power_word_shield_buff)
				and Mana() >= ManaCost(power_word_shield)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Make sure that the player is in Shadowform
				if CheckBoxOn(opt_shadowform) and not BuffPresent(shadowform_buff) Spell(shadowform)

				# Surrender to Madness Rotation if Surrender to Madness is active.
				if Rotation_SurrenderMadness_Use() and { not IsCasting(mind_flay) or SurrenderMadness_MindFlay_Cancel() }
				{
					if not CheckBoxOn(opt_shadow_crash) and SurrenderMadness_ShadowCrash_Use() Spell(shadow_crash)
					if not CheckBoxOn(opt_void_torrent) and SurrenderMadness_VoidTorrent_Use() Spell(void_torrent)

					if not CheckBoxOn(opt_dispersion_surrender) and not SurrenderMadness_VoidBolt_Wait() and SurrenderMadness_Dispersion_Use() Spell(dispersion)
					if not CheckBoxOn(opt_shadow_word_void) and not SurrenderMadness_VoidBolt_Wait() and not SurrenderMadness_MindBlast_Wait() and SurrenderMadness_ShadowWordVoid_Use() Spell(shadow_word_void)
				}

				# Voidform Rotation when in Voidform and Surrender to Madness is not active.
				if Rotation_Voidform_Use() and { not IsCasting(mind_flay) or Voidform_MindFlay_Cancel() }
				{
					if not CheckBoxOn(opt_shadow_crash) and Voidform_ShadowCrash_Use() Spell(shadow_crash)
					if not CheckBoxOn(opt_void_torrent) and Voidform_VoidTorrent_Use() Spell(void_torrent)

					if not CheckBoxOn(opt_shadow_word_void) and not Voidform_VoidBolt_Wait() and not Voidform_MindBlast_Wait() and Voidform_ShadowWordVoid_Use() Spell(shadow_word_void)
				}

				# Standard Rotation when Voidform is not active.
				if Rotation_Standard_Use()
				{
					if not CheckBoxOn(opt_void_erruption) and Standard_VoidErruption_Use() Spell(void_eruption)
					if not CheckBoxOn(opt_shadow_crash) and Standard_ShadowCrash_Use() Spell(shadow_crash)
					if not CheckBoxOn(opt_shadow_word_void) and Standard_ShadowWordVoid_Use() Spell(shadow_word_void)
				}

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_power_word_shield) and ShortCD_PowerWordShield_Use() Spell(power_word_shield)
				if CheckBoxOn(opt_dispersion) and ShortCD_Dispersion_Use() Spell(dispersion)
			}

			AddFunction ShortCD_Precombat
			{
			}

			###
			### Standard Rotation - Functions
			###
			AddFunction Standard_MindBlast_Use
			{
					SpellCharges(mind_blast) >= 1
				and Enemies() <= 4
				and not Talent(legacy_of_the_void_talent)
				and {
							Insanity() <= 96
						 or {
									Insanity() <= 95.2
								and Talent(fortress_of_the_mind_talent)
							}
					}
				and target.RangeCheck(mind_blast)
			}

			AddFunction Standard_MindBlast_Use_LegacyOfTheVoid
			{
					SpellCharges(mind_blast) >= 1
				and Enemies() <= 4
				and Talent(legacy_of_the_void_talent)
				and {
							Insanity() <= 81
						 or {
									Insanity() <= 75.2
								and Talent(fortress_of_the_mind_talent)
							}
					}
				and target.RangeCheck(mind_blast)
			}

			AddFunction Standard_MindFlay_Use
			{
					not SpellCooldown(mind_flay)
				and target.RangeCheck(mind_flay)
			}

			AddFunction Standard_ShadowCrash_Use
			{
					Talent(shadow_crash_talent)
				and not SpellCooldown(shadow_crash)
				and target.RangeCheck(shadow_crash)
			}

			AddFunction Standard_ShadowWordDeath_Use
			{
					{
							Enemies() <= 4
						 or {
									Talent(reaper_of_souls_talent)
								and Enemies() <= 2
							}
					}
				and SpellCharges(shadow_word_death) == 2
				and Insanity() <= 85 - 15 * TalentPoints(reaper_of_souls_talent)
				and {
							target.HealthPercent() < 20
						 or {
									Talent(reaper_of_souls_talent)
								and target.HealthPercent() < 35
							}
						 or BuffPresent(zeks_exterminatus_buff)
					}
				and target.RangeCheck(shadow_word_death)
			}

			AddFunction Standard_ShadowWordPain_Use
			{
					not SpellCooldown(shadow_word_pain)
				and not Talent(misery_talent)
				and not target.DebuffPresent(shadow_word_pain_debuff)
				and Enemies() > 1
				and { 47.12 * { 1 + 0.2 + MasteryRating() / 16000 } * 0.75 * target.TimeToDie() / { GCD() * { 138 + 80 * { Enemies() - 1 } } } } > 1
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction Standard_ShadowWordPain_Use_Misery
			{
					not SpellCooldown(shadow_word_pain)
				and Talent(misery_talent)
				and target.DebuffRemaining(shadow_word_pain_debuff) < GCD()
				and Speed() > 0
				and target.RangeCheck(shadow_word_pain)
			}
			
			AddFunction Standard_ShadowWordPain_Use_Refresh
			{
					not SpellCooldown(shadow_word_pain)
				and not Talent(misery_talent)
				and target.InPandemicRange(shadow_word_pain_debuff shadow_word_pain)
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction Standard_ShadowWordPain_Use_Talents
			{
					not SpellCooldown(shadow_word_pain)
				and not Talent(misery_talent)
				and not target.DebuffPresent(shadow_word_pain_debuff)
				and target.TimeToDie() > 10
				and {
							Enemies() < 5
						and {
									Talent(auspicious_spirits_talent)
								 or Talent(shadowy_insight_talent)
							}
					}
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction Standard_ShadowWordVoid_Use
			{
					Talent(shadow_word_void_talent)
				and SpellCharges(shadow_word_void) >= 1
				and Insanity() <= 75 - 10 * TalentPoints(legacy_of_the_void_talent)
				and target.RangeCheck(shadow_word_void)
			}

			AddFunction Standard_SurrenderToMadness_Use
			{
					Talent(surrender_to_madness_talent)
				and not SpellCooldown(surrender_to_madness)
				and target.IsRaidBoss()
				and target.TimeToDie() <= SurrendToMadnessCheck()
			}

			AddFunction Standard_VampiricTouch_Use
			{
					not SpellCooldown(vampiric_touch)
				and Enemies() > 1
				and not Talent(misery_talent)
				and not target.DebuffPresent(vampiric_touch_debuff)
				and { 85.2 * { 1 + 0.2 + MasteryRating() / 16000 } * { 1 + 0.2 * TalentPoints(sanlayn_talent) } * 0.5 * target.TimeToDie() / { GCD() * { 138 + 80 * { Enemies() - 1 } } } } > 1
				and target.RangeCheck(vampiric_touch)
			}

			AddFunction Standard_VampiricTouch_Use_Misery
			{
					not SpellCooldown(vampiric_touch)
				and Talent(misery_talent)
				and {
							target.DebuffRemaining(vampiric_touch_debuff) < 3 * GCD()
						 or target.DebuffRemaining(shadow_word_pain_debuff) < 3 * GCD()
					}
				and target.RangeCheck(vampiric_touch)
			}
			
			AddFunction Standard_VampiricTouch_Use_Refresh
			{
					not SpellCooldown(vampiric_touch)
				and not Talent(misery_talent)
				and target.InPandemicRange(vampiric_touch_debuff vampiric_touch)
				and target.RangeCheck(vampiric_touch)
			}

			AddFunction Standard_VoidErruption_Use
			{
					not SpellCooldown(void_eruption)
				and {
							Insanity() >= 70
						 or {
									Talent(legacy_of_the_void_talent)
								and Insanity() >= 65
							}
					}
				and target.RangeCheck(void_eruption)
			}

			###
			### Standard Rotation - Usage
			###
			AddFunction Rotation_Standard_Use
			{
					not BuffPresent(voidform_buff)
			}

			###
			### Standard Rotation
			###
			AddFunction Rotation_Standard
			{
				if CheckBoxOn(opt_surrender) and Standard_SurrenderToMadness_Use() Spell(surrender_to_madness)
				if Standard_ShadowWordPain_Use_Misery() Spell(shadow_word_pain)
				if Standard_VampiricTouch_Use_Misery() Spell(vampiric_touch)
				if Standard_ShadowWordPain_Use_Refresh() Spell(shadow_word_pain)
				if Standard_VampiricTouch_Use_Refresh() Spell(vampiric_touch)
				if CheckBoxOn(opt_void_erruption) and Standard_VoidErruption_Use() Spell(void_eruption)
				if CheckBoxOn(opt_shadow_crash) and Standard_ShadowCrash_Use() Spell(shadow_crash)
				if Standard_ShadowWordDeath_Use() Spell(shadow_word_death)
				if Standard_MindBlast_Use_LegacyOfTheVoid() Spell(mind_blast)
				if Standard_MindBlast_Use() Spell(mind_blast)
				if Standard_ShadowWordPain_Use_Talents() Spell(shadow_word_pain)
				if Standard_VampiricTouch_Use() Spell(vampiric_touch)
				if Standard_ShadowWordPain_Use() Spell(shadow_word_pain)
				if CheckBoxOn(opt_shadow_word_void) and Standard_ShadowWordVoid_Use() Spell(shadow_word_void)
				if Standard_MindFlay_Use() Spell(mind_flay)
				
				# Lastly display Shadow Word Pain if nothing else to do because of movement etc...
				if target.RangeCheck(shadow_word_pain) Spell(shadow_word_pain)
			}

			###
			### Surrender to Madness Rotation - Functions
			###
			AddFunction SurrenderMadness_Dispersion_Use
			{
					not SpellCooldown(dispersion)
				and InsanityDrain() * GCD() > Insanity()
				and {
							not BuffPresent(power_infusion_buff)
						 or {
									BuffStacks(voidform_buff) > 76
								and SpellCharges(shadow_word_death) == 0
								and InsanityDrain() * GCD() > Insanity()
							}
					}
			}

			AddFunction SurrenderMadness_MindBlast_Use
			{
					SpellCharges(mind_blast) >= 1
				and Enemies() <= 5
				and target.RangeCheck(mind_blast)
			}

			AddFunction SurrenderMadness_MindBlast_Wait
			{
					SpellCharges(mind_blast) == 0
				and SpellCooldown(mind_blast) < GCD() * 0.28
				and Enemies() <= 5				
				and target.RangeCheck(mind_blast)
			}

			AddFunction SurrenderMadness_MindFlay_Cancel
			{
					IsCasting(mind_flay)
				and ChannelCurrentTick(mind_flay) >= 2
				and {
							ChannelInterruptWithSpell(void_bolt)
						 or {
									ChannelInterruptWithSpell(shadow_word_death)
								and InsanityDrain() * GCD() > Insanity()
								and Insanity() - { InsanityDrain() * GCD() } + 60 < 100
							}
					}
			}

			AddFunction SurrenderMadness_MindFlay_Use
			{
					not SpellCooldown(mind_flay)
				and target.RangeCheck(mind_flay)
			}

			AddFunction SurrenderMadness_Mindbender_Use
			{
					Talent(mindbender_talent)
				and not SpellCooldown(mindbender)
				and SpellCharges(shadow_word_death) == 0
				and BuffStacks(voidform_buff) > { 45 + 25 * ArmorSetBonus(T20 4) }
				and target.RangeCheck(mindbender)
			}

			AddFunction SurrenderMadness_PowerInfusion_Use
			{
					Talent(power_infusion_talent)
				and not SpellCooldown(power_infusion)
				and SpellCharges(shadow_word_death) == 0
				and BuffStacks(voidform_buff) > { 45 + 25 * ArmorSetBonus(T20 4) }
				 or target.TimeToDie() <= 30
			}

			AddFunction SurrenderMadness_ShadowCrash_Use
			{
					Talent(shadow_crash_talent)
				and not SpellCooldown(shadow_crash)
				and target.RangeCheck(shadow_crash)
			}

			AddFunction SurrenderMadness_ShadowWordDeath_Use
			{
					{
							Enemies() <= 4
						 or {
									Talent(reaper_of_souls_talent)
								and Enemies() <= 2
							}
					}
				and SpellCharges(shadow_word_death) == 2
				and {
							target.HealthPercent() < 20
						 or {
									Talent(reaper_of_souls_talent)
								and target.HealthPercent() < 35
							}
						 or BuffPresent(zeks_exterminatus_buff)
					}
				and target.RangeCheck(shadow_word_death)
			}

			AddFunction SurrenderMadness_ShadowWordDeath_Use_AOE
			{
					SpellCharges(shadow_word_death) >= 1
				and {
							Enemies() <= 4 
						 or {
									Talent(reaper_of_souls_talent) 
								and Enemies() <= 2
							}
					}
				and InsanityDrain() * GCD() > Insanity() 
				and Insanity() - { InsanityDrain() * GCD() } + { 30 + 30 * TalentPoints(reaper_of_souls_talent) } < 100
				and {
							target.HealthPercent() < 20
						 or {
									Talent(reaper_of_souls_talent)
								and target.HealthPercent() < 35
							}
						 or BuffPresent(zeks_exterminatus_buff)
					}
				and target.RangeCheck(shadow_word_death)
			}

			AddFunction SurrenderMadness_ShadowWordDeath_Use_Insanity
			{
					SpellCharges(shadow_word_death) >= 1
				and InsanityDrain() * GCD() > Insanity()
				and Insanity() - { InsanityDrain() * GCD() } + { 30 + 30 * TalentPoints(reaper_of_souls_talent) } < 100
				and {
							target.HealthPercent() < 20
						 or {
									Talent(reaper_of_souls_talent)
								and target.HealthPercent() < 35
							}
						 or BuffPresent(zeks_exterminatus_buff)
					}
				and target.RangeCheck(shadow_word_death)
			}

			AddFunction SurrenderMadness_ShadowWordPain_Use
			{
					not SpellCooldown(shadow_word_pain)
				and not Talent(misery_talent)
				and not target.DebuffPresent(shadow_word_pain_debuff)
				and target.TimeToDie() > 10
				and {
							Enemies() < 5
						and HasArtifactTrait(sphere_of_insanity_trait)
					}
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction SurrenderMadness_ShadowWordPain_Use_Misery
			{
					not SpellCooldown(shadow_word_pain)
				and Talent(misery_talent)
				and target.DebuffRemaining(shadow_word_pain_debuff) < GCD()
				and Speed() > 0
				and target.RangeCheck(shadow_word_pain)
			}
			
			AddFunction SurrenderMadness_ShadowWordPain_Use_ShadowyInsight
			{
					not SpellCooldown(shadow_word_pain)
				and not Talent(misery_talent)
				and not target.DebuffPresent(shadow_word_pain_debuff)
				and target.TimeToDie() > 10
				and {
							Enemies() < 5
						and {
									Talent(auspicious_spirits_talent)
								 or Talent(shadowy_insight_talent)
							}
					}
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction SurrenderMadness_ShadowWordPain_Use_Talents
			{
					not SpellCooldown(shadow_word_pain)
				and not Talent(misery_talent)
				and not target.DebuffPresent(shadow_word_pain_debuff)
				and {
							Enemies() < 5
						 or Talent(auspicious_spirits_talent)
						 or Talent(shadowy_insight_talent)
						 or HasArtifactTrait(sphere_of_insanity_trait)
					}
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction SurrenderMadness_ShadowWordVoid_Use
			{
					Talent(shadow_word_void_talent)
				and SpellCharges(shadow_word_void) >= 1
				and Insanity() - { InsanityDrain() * GCD() } + 50 < 100
				and target.RangeCheck(shadow_word_void)
			}

			AddFunction SurrenderMadness_Shadowfiend_Use
			{
					not Talent(mindbender_talent)
				and not SpellCooldown(shadowfiend)
				and BuffStacks(voidform_buff) > 15
				and target.RangeCheck(shadowfiend)
			}
			
			AddFunction SurrenderMadness_VampiricTouch_Use
			{
					not SpellCooldown(vampiric_touch)
				and not Talent(misery_talent)
				and not target.DebuffPresent(vampiric_touch_debuff)
				and target.TimeToDie() > 10
				and {
							Enemies() < 4
						 or Talent(sanlayn_talent)
						 or {
									Talent(auspicious_spirits_talent)
								and HasArtifactTrait(unleash_the_shadows_trait)
							}
					}
				and target.RangeCheck(vampiric_touch)
			}

			AddFunction SurrenderMadness_VampiricTouch_Use_Misery
			{
					not SpellCooldown(vampiric_touch)
				and Talent(misery_talent)
				and {
							target.BuffRemaining(vampiric_touch_debuff) < GCD() * 3
						 or target.BuffRemaining(shadow_word_pain_debuff) < GCD() * 3
					}
				and target.RangeCheck(vampiric_touch)
			}

			AddFunction SurrenderMadness_VampiricTouch_Use_Talents
			{
					not SpellCooldown(vampiric_touch)
				and not Talent(misery_talent)
				and not target.DebuffPresent(vampiric_touch_debuff)
				and {
							Enemies() < 4
						 or Talent(sanlayn_talent)
						 or {
									Talent(auspicious_spirits_talent)
								and HasArtifactTrait(unleash_the_shadows_trait)
							}
					}
				and target.RangeCheck(vampiric_touch)
			}

			AddFunction SurrenderMadness_VoidBolt_Use
			{
					not SpellCooldown(void_bolt)
				and target.RangeCheck(void_bolt)
			}

			AddFunction SurrenderMadness_VoidBolt_Use_Tier19
			{
					not SpellCooldown(void_bolt)
				and InsanityDrainStacks() < 6
				and ArmorSetBonus(T19 4)
				and target.RangeCheck(void_bolt)
			}

			AddFunction SurrenderMadness_VoidBolt_Wait
			{
					SpellCooldown(void_bolt)
				and SpellCooldown(void_bolt) < GCD() * 0.28
			}

			AddFunction SurrenderMadness_VoidTorrent_Use
			{
					SpellKnown(void_torrent)
				and target.RangeCheck(void_torrent)
				and not SpellCooldown(void_torrent)
				and target.DebuffRemaining(shadow_word_pain_debuff) > 5.5
				and target.DebuffRemaining(vampiric_touch_debuff) > 5.5
				and not BuffPresent(power_infusion_buff)
				 or BuffStacks(voidform_buff) < 5
			}

			###
			### Surrender to Madness Rotation - Usage
			###
			AddFunction Rotation_SurrenderMadness_Use
			{
					BuffPresent(voidform_buff)
				and BuffPresent(surrender_to_madness_buff)
			}

			###
			### Surrender to Madness Rotation
			###
			AddFunction Rotation_SurrenderMadness
			{
				if not IsCasting(mind_flay) or SurrenderMadness_MindFlay_Cancel()
				{
					if SurrenderMadness_VoidBolt_Use_Tier19() Spell(void_bolt)
					if CheckBoxOn(opt_shadow_crash) and SurrenderMadness_ShadowCrash_Use() Spell(shadow_crash)
					if CheckBoxOn(opt_shadowfiend) and SurrenderMadness_Mindbender_Use() Spell(mindbender)
					if CheckBoxOn(opt_void_torrent) and SurrenderMadness_VoidTorrent_Use() Spell(void_torrent)
					if SurrenderMadness_ShadowWordDeath_Use_Insanity() Spell(shadow_word_death)
					if CheckBoxOn(opt_power_infusion) and SurrenderMadness_PowerInfusion_Use() Spell(power_infusion)
					if SurrenderMadness_VoidBolt_Use() Spell(void_bolt)
					if SurrenderMadness_ShadowWordDeath_Use_AOE() Spell(shadow_word_death)

					if SurrenderMadness_VoidBolt_Wait() Texture(ability_ironmaidens_convulsiveshadows text="wait")
					if not SurrenderMadness_VoidBolt_Wait()
					{
						if CheckBoxOn(opt_dispersion_surrender) and SurrenderMadness_Dispersion_Use() Spell(dispersion)
						if SurrenderMadness_MindBlast_Use() Spell(mind_blast)

						if SurrenderMadness_MindBlast_Wait() Texture(spell_shadow_unholyfrenzy text="wait")
						if not SurrenderMadness_MindBlast_Wait()
						{
							if SurrenderMadness_ShadowWordDeath_Use() Spell(shadow_word_death)
							if CheckBoxOn(opt_shadowfiend) and SurrenderMadness_Shadowfiend_Use() Spell(shadowfiend)
							if CheckBoxOn(opt_shadow_word_void) and SurrenderMadness_ShadowWordVoid_Use() Spell(shadow_word_void)
							if SurrenderMadness_ShadowWordPain_Use_Misery() Spell(shadow_word_pain)
							if SurrenderMadness_VampiricTouch_Use_Misery() Spell(vampiric_touch)
							if SurrenderMadness_ShadowWordPain_Use_Talents() Spell(shadow_word_pain)
							if SurrenderMadness_VampiricTouch_Use_Talents() Spell(vampiric_touch)
							if SurrenderMadness_ShadowWordPain_Use_ShadowyInsight() Spell(shadow_word_pain)
							if SurrenderMadness_VampiricTouch_Use() Spell(vampiric_touch)
							if SurrenderMadness_ShadowWordPain_Use() Spell(shadow_word_pain)
							if SurrenderMadness_MindFlay_Use() Spell(mind_flay)
						}
					}
				}

				# Show cont if currently channeling Mind Flay and it should not be interrupted
				if IsCasting(mind_flay) Texture(spell_shadow_siphonmana text="cont")
			}

			###
			### Voidform Rotation - Functions
			###
			AddFunction Voidform_MindBlast_Use
			{
					SpellCharges(mind_blast) >= 1
				and Enemies() <= 4
				and target.RangeCheck(mind_blast)
			}

			AddFunction Voidform_MindBlast_Wait
			{
					SpellCharges(mind_blast) == 0
				and SpellCooldown(mind_blast) < GCD() * 0.28
				and Enemies() <= 4				
				and target.RangeCheck(mind_blast)
			}

			AddFunction Voidform_MindFlay_Cancel
			{
					IsCasting(mind_flay)
				and ChannelCurrentTick(mind_flay) >= 2
				and {
							ChannelInterruptWithSpell(void_bolt)
						 or {
									InsanityDrain() * GCD() > Insanity()
								and Insanity() - { InsanityDrain() * GCD() } + 30 < 100
								and ChannelInterruptWithSpell(shadow_word_death)
							}
					}
			}

			AddFunction Voidform_MindFlay_Use
			{
					not SpellCooldown(mind_flay)
				and target.RangeCheck(mind_flay)
			}

			AddFunction Voidform_Mindbender_Use
			{
					Talent(mindbender_talent)
				and not SpellCooldown(mindbender)
				and not ArmorSetBonus(T20 4)
				and InsanityDrainStacks() >= { 10 + 2 * ArmorSetBonus(T19 2) + 5 * BloodlustActiveValue() + 3 * LegendaryEquippedValue(mangazas_madness) + 2 * ArtifactTraitRank(lash_of_insanity_trait) }
				and {
							not Talent(surrender_to_madness_talent)	
						 or {
									Talent(surrender_to_madness_talent)
								and target.TimeToDie() > SurrendToMadnessCheck() - InsanityDrainStacks() + 30
							}
					}
				and target.RangeCheck(mindbender)
			}

			AddFunction Voidform_Mindbender_Use_Tier20
			{
					Talent(mindbender_talent)
				and not SpellCooldown(mindbender)
				and ArmorSetBonus(T20 4)
				and InsanityDrainStacks() >= { 21 - { 2 * BloodlustActiveValue() + 2 * TalentPoints(fortress_of_the_mind_talent) + 2 * ArtifactTraitRank(lash_of_insanity_trait) } }
				and {
							not Talent(surrender_to_madness_talent)	
						 or {
									Talent(surrender_to_madness_talent)
								and target.TimeToDie() > SurrendToMadnessCheck() - InsanityDrainStacks()
							}
					}
				and target.RangeCheck(mindbender)
			}

			AddFunction Voidform_PowerInfusion_Use
			{
					Talent(power_infusion_talent)
				and not SpellCooldown(power_infusion)
				and InsanityDrainStacks() >= { 10 + 2 * ArmorSetBonus(T19 2) + 5 * BloodlustActiveValue() * { 1 + 1 * ArmorSetBonus(T20 4) } + 3 * LegendaryEquippedValue(mangazas_madness) + 6 * ArmorSetBonus(T20 4) + 2 * ArtifactTraitRank(lash_of_insanity_trait) }				
				and {
							not Talent(surrender_to_madness_talent)	
						 or {
									Talent(surrender_to_madness_talent)
								and target.TimeToDie() > SurrendToMadnessCheck() - InsanityDrainStacks() + 61
							}
					}
			}

			AddFunction Voidform_ShadowCrash_Use
			{
					Talent(shadow_crash_talent)
				and not SpellCooldown(shadow_crash)
				and target.RangeCheck(shadow_crash)
			}

			AddFunction Voidform_ShadowWordDeath_Use
			{
					{
							Enemies() <= 4
						 or {
									Talent(reaper_of_souls_talent)
								and Enemies() <= 2
							}
					}
				and SpellCharges(shadow_word_death) == 2
				and {
							target.HealthPercent() < 20
						 or {
									Talent(reaper_of_souls_talent)
								and target.HealthPercent() < 35
							}
						 or BuffPresent(zeks_exterminatus_buff)
					}
				and target.RangeCheck(shadow_word_death)
			}

			AddFunction Voidform_ShadowWordDeath_Use_Insanity
			{
					SpellCharges(shadow_word_death) >= 1
				and {
							Enemies() <= 4 
						 or {
									Talent(reaper_of_souls_talent) 
								and Enemies() <= 2
							}
					}
				and InsanityDrain() * GCD() > Insanity() 
				and { Insanity() - { InsanityDrain() * GCD() } + { 15 + 15 * TalentPoints(reaper_of_souls_talent) } } < 100
				and {
							target.HealthPercent() < 20
						 or {
									Talent(reaper_of_souls_talent)
								and target.HealthPercent() < 35
							}
						 or BuffPresent(zeks_exterminatus_buff)
					}
				and target.RangeCheck(shadow_word_death)
			}
			
			AddFunction Voidform_ShadowWordPain_Use
			{
					not SpellCooldown(shadow_word_pain)
				and Enemies() > 1
				and not Talent(misery_talent)
				and not target.DebuffPresent(shadow_word_pain_debuff)
				and { 47.12 * { 1 + 0.02 * BuffStacks(voidform_buff) } * { 1 + 0.2 + MasteryRating() / 16000 } * 0.75 * target.TimeToDie() / { GCD() * { 138 + 80 * { Enemies() - 1 } } } } > 1
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction Voidform_ShadowWordPain_Use_Misery
			{
					not SpellCooldown(shadow_word_pain)
				and Talent(misery_talent)
				and target.DebuffRemaining(shadow_word_pain_debuff) < GCD()
				and Speed() > 0
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction Voidform_ShadowWordPain_Use_Talents
			{
					not SpellCooldown(shadow_word_pain)
				and not Talent(misery_talent)
				and not target.DebuffPresent(shadow_word_pain_debuff)
				and {
							Enemies() < 5
						 or Talent(auspicious_spirits_talent)
						 or Talent(shadowy_insight_talent)
						 or HasArtifactTrait(sphere_of_insanity_trait)
					}
				and target.RangeCheck(shadow_word_pain)
			}

			AddFunction Voidform_ShadowWordVoid_Use
			{
					Talent(shadow_word_void_talent)
				and SpellCharges(shadow_word_void) >= 1
				and { Insanity() - { InsanityDrain() * GCD() } + 25 } < 100
				and target.RangeCheck(shadow_word_void)
			}

			AddFunction Voidform_Shadowfiend_Use
			{
					not Talent(mindbender_talent)
				and not SpellCooldown(shadowfiend)
				and BuffStacks(voidform_buff) > 15
				and target.RangeCheck(shadowfiend)
			}

			AddFunction Voidform_SurrenderToMadness_Use
			{
					Talent(surrender_to_madness_talent)
				and not SpellCooldown(surrender_to_madness)
				and target.IsRaidBoss()
				and insanity >= 25
				and {
							not SpellCooldown(void_bolt)
						 or {
									SpellKnown(void_torrent)
								and not SpellCooldown(void_torrent)
							}
						 or not SpellCooldown(shadow_word_death)
						 or BuffPresent(shadowy_insight_buff)
					}
				and target.TimeToDie() <= SurrendToMadnessCheck() - InsanityDrainStacks()
			}

			AddFunction Voidform_VampiricTouch_Use
			{
					not SpellCooldown(vampiric_touch)
				and Enemies() > 1
				and not Talent(misery_talent)
				and not target.DebuffPresent(vampiric_touch_debuff)
				and { 85.2 * { 1 + 0.02 * BuffStacks(voidform_buff) } * { 1 + 0.2 + MasteryRating() / 16000 } * { 1 + 0.2 * TalentPoints(sanlayn_talent) } * 0.5 * target.TimeToDie() / { GCD() * { 138 + 80 * { Enemies() - 1 } } } } > 1
				and target.RangeCheck(vampiric_touch)
			}

			AddFunction Voidform_VampiricTouch_Use_Misery
			{
					not SpellCooldown(vampiric_touch)
				and Talent(misery_talent)
				and {
							target.DebuffRemaining(vampiric_touch_debuff) < 3 * GCD()
						 or target.DebuffRemaining(shadow_word_pain_debuff) < 3 * GCD()
					}
				and target.TimeToDie() > 5 * GCD()
				and target.RangeCheck(vampiric_touch)
			}
			
			AddFunction Voidform_VampiricTouch_Use_Talents
			{
					not SpellCooldown(vampiric_touch)
				and not Talent(misery_talent)
				and not target.DebuffPresent(vampiric_touch_debuff)
				and {
							Enemies() < 4
						 or Talent(sanlayn_talent)
						 or {
									Talent(auspicious_spirits_talent)
								and HasArtifactTrait(unleash_the_shadows_trait)
							}
					}
				and target.RangeCheck(vampiric_touch)
			}

			AddFunction Voidform_VoidBolt_Use
			{
					not SpellCooldown(void_bolt)
				and target.RangeCheck(void_bolt)
			}

			AddFunction Voidform_VoidBolt_Wait
			{
					SpellCooldown(void_bolt)
				and SpellCooldown(void_bolt) < GCD() * 0.28
			}

			AddFunction Voidform_VoidTorrent_Use
			{
					SpellKnown(void_torrent)
				and not SpellCooldown(void_torrent)
				and target.DebuffRemaining(shadow_word_pain_debuff) > 5.5
				and target.DebuffRemaining(vampiric_touch_debuff) > 5.5
				and {
							not Talent(surrender_to_madness_talent)	
						 or {
									Talent(surrender_to_madness_talent)
								and target.TimeToDie() > SurrendToMadnessCheck() - InsanityDrainStacks() + 60
							}
					}						
				and target.RangeCheck(void_torrent)
			}

			###
			### Voidform Rotation - Usage
			###
			AddFunction Rotation_Voidform_Use
			{
					BuffPresent(voidform_buff)
				and not BuffPresent(surrender_to_madness_buff)
			}

			###
			### Voidform Rotation
			###
			AddFunction Rotation_Voidform
			{

				if not IsCasting(mind_flay) or Voidform_MindFlay_Cancel()
				{
					if CheckBoxOn(opt_surrender) and Voidform_SurrenderToMadness_Use() Spell(surrender_to_madness)
					if Voidform_VoidBolt_Use() Spell(void_bolt)
					if CheckBoxOn(opt_shadow_crash) and Voidform_ShadowCrash_Use() Spell(shadow_crash)
					if CheckBoxOn(opt_void_torrent) and Voidform_VoidTorrent_Use() Spell(void_torrent)
					if CheckBoxOn(opt_shadowfiend) and Voidform_Mindbender_Use_Tier20() Spell(mindbender)
					if CheckBoxOn(opt_shadowfiend) and Voidform_Mindbender_Use() Spell(mindbender)
					if CheckBoxOn(opt_power_infusion) and Voidform_PowerInfusion_Use() Spell(power_infusion)
					if Voidform_VoidBolt_Use() Spell(void_bolt)
					if Voidform_ShadowWordDeath_Use_Insanity() Spell(shadow_word_death)

					if Voidform_VoidBolt_Wait() Texture(ability_ironmaidens_convulsiveshadows text="wait")
					if not Voidform_VoidBolt_Wait()
					{
						if Voidform_MindBlast_Use() Spell(mind_blast)

						if Voidform_MindBlast_Wait() Texture(spell_shadow_unholyfrenzy text="wait")
						if not Voidform_MindBlast_Wait()
						{
							if Voidform_ShadowWordDeath_Use() Spell(shadow_word_death)
							if CheckBoxOn(opt_shadowfiend) and Voidform_Shadowfiend_Use() Spell(shadowfiend)
							if CheckBoxOn(opt_shadow_word_void) and Voidform_ShadowWordVoid_Use() Spell(shadow_word_void)
							if Voidform_ShadowWordPain_Use_Misery() Spell(shadow_word_pain)
							if Voidform_VampiricTouch_Use_Misery() Spell(vampiric_touch)
							if Voidform_ShadowWordPain_Use_Talents() Spell(shadow_word_pain)
							if Voidform_VampiricTouch_Use_Talents() Spell(vampiric_touch)
							if Voidform_ShadowWordPain_Use() Spell(shadow_word_pain)
							if Voidform_VampiricTouch_Use() Spell(vampiric_touch)
							if Voidform_ShadowWordPain_Use() Spell(shadow_word_pain)
							if Voidform_MindFlay_Use() Spell(mind_flay)
						}
					}
				}

				# Show cont if currently channeling Mind Flay and it should not be interrupted
				if IsCasting(mind_flay) Texture(spell_shadow_siphonmana text="cont")
				
				# Lastly display Shadow Word Pain if nothing else to do because of movement etc...
				if target.RangeCheck(shadow_word_pain) Spell(shadow_word_pain)
			}

			###
			### Main Icon Rotations - Functions
			###

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				# Surrender to Madness Rotation if Surrender to Madness is active.
				if Rotation_SurrenderMadness_Use() Rotation_SurrenderMadness()

				# Voidform Rotation when in Voidform and Surrender to Madness is not active.
				if Rotation_Voidform_Use() Rotation_Voidform()

				# Standard Rotation when Voidform is not active.
				if Rotation_Standard_Use() Rotation_Standard()
			}

			AddFunction Precombat
			{
				if target.RangeCheck(mind_blast) Spell(mind_blast)
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
				and {
							{
									BuffPresent(voidform_buff)
								and {
											not Talent(surrender_to_madness_talent)
										 or {
													Talent(surrender_to_madness_talent)
												and not BuffPresent(surrender_to_madness_buff)
												and target.TimeToDie() > SurrendToMadnessCheck() - InsanityDrainStacks() + 60
											}
									}
								and BuffStacks(voidform_buff) >= 10
								and InsanityDrainStacks() <= 20
							}
						 or {
									Talent(surrender_to_madness_talent)
								and BuffPresent(surrender_to_madness_buff)
								and BuffStacks(voidform_buff) >= 65
							}
					}
			}

			AddFunction CD_BloodFury_Use
			{
					Race(Orc)
				and not SpellCooldown(blood_fury_sp)
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or target.HealthPercent() <= 25
				 or target.TimeToDie() <= 80
				 or {
							BloodlustDebuff()
						and target.HealthPercent() < 35
						and Talent(power_infusion_talent)
						and SpellCooldown(power_infusion) < 30
					}
			}

			###
			### CD Icon Rotations
			###
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Surrender to Madness Rotation if Surrender to Madness is active.
				if Rotation_SurrenderMadness_Use() and { not IsCasting(mind_flay) or SurrenderMadness_MindFlay_Cancel() }
				{
					if not CheckBoxOn(opt_shadowfiend) and SurrenderMadness_Mindbender_Use() Spell(mindbender)
					if not CheckBoxOn(opt_power_infusion) and SurrenderMadness_PowerInfusion_Use() Spell(power_infusion)

					if not CheckBoxOn(opt_shadowfiend) and not SurrenderMadness_VoidBolt_Wait() and not SurrenderMadness_MindBlast_Wait() and SurrenderMadness_Shadowfiend_Use() Spell(shadowfiend)
				}

				# Voidform Rotation when in Voidform and Surrender to Madness is not active.
				if Rotation_Voidform_Use() and { not IsCasting(mind_flay) or Voidform_MindFlay_Cancel() }
				{
					if not CheckBoxOn(opt_surrender) and Voidform_SurrenderToMadness_Use() Spell(surrender_to_madness)
					
					if not CheckBoxOn(opt_shadowfiend) and Voidform_Mindbender_Use() Spell(mindbender)
					if not CheckBoxOn(opt_power_infusion) and Voidform_PowerInfusion_Use() Spell(power_infusion)

					if not CheckBoxOn(opt_shadowfiend) and not Voidform_VoidBolt_Wait() and not Voidform_MindBlast_Wait() and Voidform_Shadowfiend_Use() Spell(shadowfiend)
				}

				# Standard Rotation when Voidform is not active.
				if Rotation_Standard_Use()
				{
					if not CheckBoxOn(opt_surrender) and Standard_SurrenderToMadness_Use() Spell(surrender_to_madness)
				}

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_prolonged_power)

				# Stardard Actions
				if CD_BloodFury_Use() Spell(blood_fury_sp)
				if CD_Berserking_Use() Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_mana)
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
				if not InCombat() Precombat()
				Main()
			}

			AddIcon help=aoe
			{
				if not InCombat() Precombat()
				Main()
			}

			AddIcon help=cd
			{
				if not InCombat() CD_Precombat()
				CD()
			}
		]];

		OvaleScripts:RegisterScript("PRIEST", "shadow", name, desc, code, "script");
	end
end