local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_druid_feral";
		local desc = "LunaEclipse: Feral Druid";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DRUID_FERAL,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Xanzara",
			GuideLink = "http://www.icy-veins.com/wow/feral-druid-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Dungeons / Raiding (Single Target)"] = "2200322",
			["Dungeons / Raiding (AOE)"] = "2200323",
			["Solo / World Quests"] = "1231122",
			["Easy Mode"] = "2211111",
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
					OPT_MOONFIRE_LUNAR = {
						type = "toggle",
						name = BINDING_NAME_OPT_MOONFIRE_LUNAR,
						desc = string.format("%s\n\n%s", functionsConfiguration:getAOETooltip("Moonfire"), "This only applies when you have Luna Inspiration talent chosen!"),
						arg = "OPT_MOONFIRE_LUNAR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_SWIPE = {
						type = "toggle",
						name = BINDING_NAME_OPT_SWIPE,
						desc = functionsConfiguration:getAOETooltip("Swipe"),
						arg = "OPT_SWIPE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_THRASH = {
						type = "toggle",
						name = BINDING_NAME_OPT_THRASH,
						desc = functionsConfiguration:getAOETooltip("Thrash"),
						arg = "OPT_THRASH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_BRUTAL_SLASH = {
						type = "toggle",
						name = BINDING_NAME_OPT_BRUTAL_SLASH,
						desc = functionsConfiguration:getAOETooltip("Brutal Slash"),
						arg = "OPT_BRUTAL_SLASH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_DESIRED_TARGETS = {
						type = "select",
						name = "",
						desc = "Select the minimum number of enemies that must be present for the script to recommend Brutal Slash.",
						values = {
							["dt_2"] = "Brutal Slash 2+ Targets",
							["dt_3"] = "Brutal Slash 3+ Targets",
							["dt_4"] = "Brutal Slash 4+ Targets",
							["dt_5"] = "Brutal Slash 5+ Targets",
							["dt_6"] = "Brutal Slash 6+ Targets",
							["dt_7"] = "Brutal Slash 7+ Targets",
							["dt_8"] = "Brutal Slash 8+ Targets",
							["dt_9"] = "Brutal Slash 9+ Targets",
						},
						arg = "OPT_DESIRED_TARGETS",
						get = "getScriptListbox",
						set = "setScriptListbox",
						order = 50,
					},
				},
			},
			settingsBuffs = {
				type = "group",
				name = BINDING_HEADER_BUFFS_DEBUFFS,
				inline = true,
				order = 20,
				args = {
					OPT_CAT_FORM = {
						type = "toggle",
						name = BINDING_NAME_OPT_CAT_FORM,
						desc = functionsConfiguration:getBuffTooltip("Cat Form and Prowl"),
						arg = "OPT_CAT_FORM",
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
					OPT_ASHAMANES_FRENZY = {
						type = "toggle",
						name = BINDING_NAME_OPT_ASHAMANES_FRENZY,
						desc = functionsConfiguration:getCooldownTooltip("Ashamane's Frenzy"),
						arg = "OPT_ASHAMANES_FRENZY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_BERSERK = {
						type = "toggle",
						name = BINDING_NAME_OPT_BERSERK,
						desc = functionsConfiguration:getCooldownTooltip("Berserk and Incarnation: Chosen of Elune", "CD"),
						arg = "OPT_BERSERK",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_ELUNES_GUIDANCE = {
						type = "toggle",
						name = BINDING_NAME_OPT_ELUNES_GUIDANCE,
						desc = functionsConfiguration:getCooldownTooltip("Elune's Guidance"),
						arg = "OPT_ELUNES_GUIDANCE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_REGROWTH_BLOODTALONS = {
						type = "toggle",
						name = BINDING_NAME_OPT_REGROWTH_BLOODTALONS,
						desc = string.format("%s\n\n%s", functionsConfiguration:getCooldownTooltip("Regrowth"), "This only applies when you have Bloodtalons talent chosen!"),
						arg = "OPT_REGROWTH_BLOODTALONS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_SAVAGE_ROAR = {
						type = "toggle",
						name = BINDING_NAME_OPT_SAVAGE_ROAR,
						desc = functionsConfiguration:getCooldownTooltip("Savage Roar"),
						arg = "OPT_SAVAGE_ROAR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_SHADOWMELD = {
						type = "toggle",
						name = BINDING_NAME_OPT_SHADOWMELD,
						desc = functionsConfiguration:getCooldownTooltip("Shadowmeld", "CD"),
						arg = "OPT_SHADOWMELD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
				},
			},
			settingsDefensive = {
				type = "group",
				name = BINDING_HEADER_DEFENSIVE,
				inline = true,
				order = 40,
				args = {
					OPT_SURVIVAL_INSTINCTS = {
						type = "toggle",
						name = BINDING_NAME_OPT_SURVIVAL_INSTINCTS,
						desc = functionsConfiguration:getDefensiveTooltip("Survival Instincts", "CD", "40%"),
						arg = "OPT_SURVIVAL_INSTINCTS",
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
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(lunaeclipse_druid_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_moonfire_lunar "AOE: Moonfire" default)
			AddCheckBox(opt_swipe "AOE: Swipe" default)
			AddCheckBox(opt_thrash "AOE: Thrash" default)
			AddCheckBox(opt_brutal_slash "AOE CD: Brutal Slash" default)
			AddCheckBox(opt_cat_form "Buff: Cat Form" default)
			AddCheckBox(opt_ashamanes_frenzy "Cooldown: Ashamane's Frenzy" default)
			AddCheckBox(opt_berserk "Cooldown: Berserk" default)
			AddCheckBox(opt_elunes_guidance "Cooldown: Elune's Guidance" default)
			AddCheckBox(opt_regrowth_bloodtalons "Cooldown: Regrowth" default)
			AddCheckBox(opt_savage_roar "Cooldown: Savage Roar" default)
			AddCheckBox(opt_shadowmeld "Cooldown: Shadowmeld" default)
			AddCheckBox(opt_survival_instincts "Defensive: Survival Instincts" default)
			AddCheckBox(opt_renewal "Heal: Renewal" default)

			# Listboxes
			AddListItem(opt_desired_targets dt_2 "Brutal Slash 2+ Targets")
			AddListItem(opt_desired_targets dt_3 "Brutal Slash 3+ Targets" default)
			AddListItem(opt_desired_targets dt_4 "Brutal Slash 4+ Targets")
			AddListItem(opt_desired_targets dt_5 "Brutal Slash 5+ Targets")
			AddListItem(opt_desired_targets dt_6 "Brutal Slash 6+ Targets")
			AddListItem(opt_desired_targets dt_7 "Brutal Slash 7+ Targets")
			AddListItem(opt_desired_targets dt_8 "Brutal Slash 8+ Targets")
			AddListItem(opt_desired_targets dt_9 "Brutal Slash 9+ Targets")

			###
			### Artifact Functions
			###
			AddFunction AshamanesFrenzy_Available
			{
					SpellKnown(ashamanes_frenzy)
				and not SpellCooldown(ashamanes_frenzy)
			}

			AddFunction AshamanesFrenzy_Use
			{
					AshamanesFrenzy_Available()
				and not BuffPresent(elunes_guidance_buff)
				and {
							not Talent(bloodtalons_talent)
						 or BuffPresent(bloodtalons_buff)
					}
				and {
							not Talent(savage_roar_talent)
						 or BuffPresent(savage_roar_buff)
					}
				and ComboPoints() <= 2
			}

			###
			### Arcane Torrent Functions
			###
			AddFunction ArcaneTorrent_Use
			{
					EnergyDeficit() >= 30
			}

			###
			### Berserk Functions
			###
			AddFunction Berserk_Use
			{
					not Talent(incarnation_talent)
				and not SpellCooldown(berserk_cat)
				and BuffPresent(tigers_fury_buff)
			}

			###
			### Brutal Slash Functions
			###
			AddFunction BrutalSlash_DesiredTargets asvalue=1
			{
				if List(opt_desired_targets dt_2) 2
				if List(opt_desired_targets dt_3) 3
				if List(opt_desired_targets dt_4) 4
				if List(opt_desired_targets dt_5) 5
				if List(opt_desired_targets dt_6) 6
				if List(opt_desired_targets dt_7) 7
				if List(opt_desired_targets dt_8) 8
				if List(opt_desired_targets dt_9) 9
			}

			AddFunction BrutalSlash_Use
			{
					Talent(brutal_slash_talent)
				and BuffPresent(tigers_fury_buff)
				and Enemies() >= BrutalSlash_DesiredTargets()
				and ComboPoints() <= 4
				and Energy() >= 20
			}
			
			###
			### Elune's Guidance Functions
			###
			AddFunction ElunesGuidance_Use
			{
					Talent(elunes_guidance_talent)
				and not SpellCooldown(elunes_guidance)
				and ComboPoints() == 0
				and Energy() >= EnergyCost(ferocious_bite) + 25
			}

			###
			### Ferocious Bite Functions
			###
			AddFunction FerociousBite_Use
			{
					not SpellCooldown(ferocious_bite)
				and Finisher_Requirements_Other()
				and ComboPoints() >= 5
				and BuffPresent(clearcasting_buff)
			}

			AddFunction FerociousBite_Use_RipRefresh
			{
					not SpellCooldown(ferocious_bite)
				and target.InPandemicRange(rip_debuff ferocious_bite)
				and {
							Talent(sabertooth_talent)
						 or target.HealthPercent() < 25
					}
				and target.TimeToDie() > 3
				and Energy() >= 25
			}

			###
			### Incarnation Functions
			###
			AddFunction Incarnation_Use
			{
					Talent(incarnation_talent)
				and not SpellCooldown(incarnation_king_of_the_jungle)
				and SpellCooldown(tigers_fury) < GCD()
			}

			AddFunction Incarnation_Use_Energy
			{
					Talent(incarnation_talent)
				and not SpellCooldown(incarnation_king_of_the_jungle)
				and TimeToMaxEnergy() > 1
				and Energy() >= 35
			}

			###
			### Maim Functions
			###
			AddFunction Maim_Use_FieryRedMaimers
			{
					not SpellCooldown(maim)
				and LegendaryEquipped(fiery_red_maimers)
				and BuffPresent(fiery_red_maimers_buff)
				and {
							TimeToMaxEnergy() < 1
						or BuffPresent(berserk_cat_buff)
						or BuffPresent(incarnation_king_of_the_jungle_buff)
						or BuffPresent(elunes_guidance)
						or SpellCooldown(tigers_fury) < 3
					}
				and ComboPoints() >= 5
				and Energy() >= 35
			}

			###
			### Moonfire Functions
			###
			AddFunction Moonfire_Use
			{
					not SpellCooldown(moonfire_cat)
				and Talent(lunar_inspiration_talent)
				and target.InPandemicRange(moonfire_cat_debuff moonfire_cat)
				and CurrentBleedMultiplier(moonfire_cat_debuff) > target.AppliedBleedMultiplier(moonfire_cat_debuff)
				and target.TimeToDie() > TickTime(moonfire_cat) * 2
				and ComboPoints() <= 4
				and Mana() > ManaCost(moonfire_cat)
			}

			AddFunction Moonfire_Use_Other
			{					
					not SpellCooldown(moonfire_cat)
				and Talent(lunar_inspiration_talent)
				and DOTTargetCount(moonfire_cat_debuff) < MultiDOTTargets()
				and Enemies() >= 2
				and Mana() > ManaCost(moonfire_cat)
			}

			###
			### Prowl Functions
			###
			AddFunction Prowl_Use
			{
					not InCombat()
				and Stance(druid_cat_form)
				and not SpellCooldown(prowl)
				and not BuffPresent(prowl_buff)
			}

			###
			### Rake Functions
			###
			AddFunction Rake_Use
			{
					not SpellCooldown(rake)
				and ComboPoints() < 5
				and {
							{
									target.InPandemicRange(rake_debuff rake)
								and CurrentBleedMultiplier(rake_debuff) > target.AppliedBleedMultiplier(rake_debuff)
							}
						 or {
									Talent(bloodtalons_talent)
								and BuffPresent(bloodtalons_buff)
								and {
											{
													not Talent(soul_of_the_forest_talent)
												and target.DebuffRemaining(rake_debuff) <= 7
											}
										 or target.DebuffRemaining(rake_debuff) <= 5
									}
								and CurrentBleedMultiplier(rake_debuff) > target.AppliedBleedMultiplier(rake_debuff) * 0.8
							}
					}
				and target.TimeToDie() > TickTime(rake_debuff)				
				and Enemies() < 5
			}

			AddFunction Rake_Use_Other
			{
					not SpellCooldown(rip)
				and DOTTargetCount(rake_debuff) < MultiDOTTargets()
				and Enemies() >= 2
				and Energy() >= 35
			}

			AddFunction Rake_Use_Stealth
			{
					{
							BuffPresent(prowl_buff)
						 or BuffPresent(shadowmeld_buff)
					}
				and Energy() >= 35
			}	

			###
			### Regrowth Functions
			###
			AddFunction Regrowth_Use_AlluroPouncers
			{
					Talent(bloodtalons_talent)
				and LegendaryEquipped(ailuro_pouncers)
				and BuffStacks(predatory_swiftness_buff) >= 2
				and not BuffPresent(bloodtalons_buff)
				and {
							BuffPresent(clearcasting_buff)
						 or Mana() >= ManaCost(regrowth)
					}
			}		

			AddFunction Regrowth_Use_BloodTalons
			{
					Talent(bloodtalons_talent)
				and not SpellCooldown(regrowth)
				and BuffPresent(predatory_swiftness_buff)
				and not BuffPresent(bloodtalons_buff)
				and {
							ComboPoints >= 5
						 or BuffRemaining(predatory_swiftness_buff) < 1.5
						 or {
									SpellKnown(ashamanes_frenzy)
								and SpellCooldown(ashamanes_frenzy) < GCD()
								and ComboPoints == 2
							}
						 or {
									Talent(elunes_guidance_talent)
								and {
											{
													SpellCooldown(elunes_guidance) < GCD()
												and ComboPoints() == 0
											}
										 or {
													BuffPresent(elunes_guidance_buff)
												and ComboPoints() >= 4
											}
									}			
							}
					}
				and {
							BuffPresent(clearcasting_buff)
						 or Mana() >= ManaCost(regrowth)
					}
			}

			AddFunction Regrowth_Use_Sabertooth
			{
					Talent(bloodtalons_talent)
				and Talent(sabertooth_talent)
				and not SpellCooldown(regrowth)
				and BuffPresent(predatory_swiftness_buff)
				and not BuffPresent(bloodtalons_buff)
				and not target.DebuffPresent(rip_debuff)
				and {
							BuffPresent(clearcasting_buff)
						 or Mana() >= ManaCost(regrowth)
					}
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
			### Rip Functions
			###
			AddFunction Rip_Use
			{
					not SpellCooldown(rip)
				and {
							{
									{
											target.InPandemicRange(rip_debuff rip)
										and {
													CurrentBleedMultiplier(rip_debuff) > target.AppliedBleedMultiplier(rip_debuff)
												 or {
															target.DebuffPresent(rake_debuff)
														and target.DebuffRemaining(rake_debuff) < target.DebuffRemaining(rip_debuff)
													}
												 or {
															target.DebuffPresent(thrash_cat_debuff)
														and target.DebuffRemaining(thrash_cat_debuff) < target.DebuffRemaining(rip_debuff)
													}
												 or {
															Talent(lunar_inspiration_talent)
														and target.DebuffPresent(moonfire_cat_debuff)
														and target.DebuffRemaining(moonfire_cat_debuff) < target.DebuffRemaining(rip_debuff)
													}
											}
									}
								 or CurrentBleedMultiplier(rip_debuff) > target.AppliedBleedMultiplier(rip_debuff)
							}
						and {
									Talent(sabertooth_talent)
								 or target.HealthPercent() > 25
							}
					}
				and target.TimeToDie() - target.DebuffRemaining(rip_debuff) > TickTime(rip_debuff) * 4
				and Finisher_Requirements_Bleed()
				and ComboPoints() >= 5
				and Energy() >= 30
			}
			
			AddFunction Rip_Use_Other
			{
					not SpellCooldown(rip)
				and DOTTargetCount(rip_debuff) < MultiDOTTargets()
				and Enemies() >= 2
				and ComboPoints() >= 5
				and Energy() >= 30
			}

			###
			### Savage Roar Functions
			###
			AddFunction SavageRoar_Apply
			{
					Talent(savage_roar_talent)
				and not SpellCooldown(savage_roar)
				and not BuffPresent(savage_roar_buff)
				and {
							{
									Talent(brutal_slash_talent)
								and SpellCharges(brutal_slash) >= 1
								and Enemies() >= BrutalSlash_DesiredTargets()
							}
						 or ComboPoints >= 5
					}
				and Energy() >= 40
			}

			AddFunction SavageRoar_Use
			{
					Talent(savage_roar_talent)
				and not SpellCooldown(savage_roar)
				and {
							{
									Talent(jagged_wounds_talent)
								and BuffRemaining(savage_roar_buff) <= 10.5
							}
						 or BuffRemaining(savage_roar_buff) <= 7.2
					}
				and Finisher_Requirements_Bleed()
				and ComboPoints() >= 5
				and Energy() >= 40
			}

			###
			### Shadowmeld Functions
			###
			AddFunction Shadowmeld_Use
			{
					SpellKnown(shadowmeld)
				and not SpellCooldown(shadowmeld)
				and target.AppliedBleedMultiplier(rake_debuff) < 2.1
				and BuffPresent(tigers_fury_buff)
				and {
							not Talent(bloodtalons_talent)
						 or BuffPresent(bloodtalons_buff)
					}
				and {
							not Talent(incarnation_talent)
						 or SpellCooldown(incarnation_king_of_the_jungle) > 18
					}
				and not BuffPresent(incarnation_king_of_the_jungle_buff)
				and ComboPoints() <= 4
				and Energy() >= 35
			}

			###
			### Shred Functions
			###
			AddFunction Shred_Use
			{
					not SpellCooldown(shred)
				and {
							Talent(brutal_slash_talent)
						 or Enemies() < 3
					}
				and ComboPoints() <= 4
				and Energy() >= 40
			}

			###
			### Survival Instincts Functions
			###
			AddFunction SurvivalInstincts_Use
			{
					SpellCharges(survival_instincts) >= 1
				and not BuffPresent(survival_instincts_buff)
				and HealthPercent() <= 40
			}

			###
			### Swipe Functions
			###
			AddFunction Swipe_Use
			{
					not SpellCooldown(swipe_cat)
				and ComboPoints() <= 4
				and Enemies() >= 3
			}

			AddFunction Swipe_Use_AOE_Heavy
			{
					not SpellCooldown(swipe_cat)
				and Enemies() >= 8
			}

			AddFunction Swipe_Use_AOE_Medium
			{
					not SpellCooldown(swipe_cat)
				and Enemies() >= 6
			}

			AddFunction Swipe_Use_MaxComboPoints
			{
					not SpellCooldown(swipe_cat)
				and {
							Enemies() >= 6
						 or {
									not Talent(bloodtalons_talent)
								and Enemies() >= 3
							}
					}
				and {
							Finisher_Requirements_Other()
						 or ArmorSetBonus(T18 4)
						 or {
									Talent(moment_of_clarity_talent)
								and BuffPresent(clearcasting_buff)
							}
					}
				and ComboPoints() >= 5				
			}

			###
			### Thrash Functions
			###
			AddFunction Thrash_Use
			{
					not SpellCooldown(thrash_cat)
				and target.InPandemicRange(thrash_cat_debuff thrash_cat)
				and CurrentBleedMultiplier(thrash_cat_debuff) > target.AppliedBleedMultiplier(thrash_cat_debuff)
				and Enemies() >= 2
				and {
							BuffPresent(clearcasting_buff)
						 or Energy() >= 50
					}
			}

			AddFunction Thrash_Use_BrutalSlash
			{
					not SpellCooldown(thrash_cat)
				and Talent(brutal_slash_talent)
				and Enemies() >= 9
				and {
							BuffPresent(clearcasting_buff)
						 or Energy() >= 50
					}
			}

			AddFunction Thrash_Refresh
			{
					not SpellCooldown(thrash_cat)
				and target.InPandemicRange(thrash_cat_debuff thrash_cat)
				and Enemies() >= 5
				and {
							BuffPresent(clearcasting_buff)
						 or Energy() >= 50
					}
			}

			###
			### Tiger's Fury Functions
			###
			AddFunction TigersFury_Use
			{
					not SpellCooldown(tigers_fury)
				and {
							{
									not BuffPresent(clearcasting_buff)
								and EnergyDeficit() >= 60
							}
						 or EnergyDeficit() >= 80
						 or {
									HasEquippedItem(t18_class_trinket)
								and BuffPresent(berserk_cat_buff)
								and not BuffPresent(tigers_fury_buff)
							}
					}
			}

			AddFunction TigersFury_Use_Sabertooth
			{
					not SpellCooldown(tigers_fury)
				and Talent(sabertooth_talent)
				and not target.DebuffPresent(rip_debuff)
				and TimeInCombat() < 20
				and ComboPoints() >= 5
			}

			###
			### Finisher Requirements
			###
			AddFunction Finisher_Requirements_Bleed
			{
					TimeToMaxEnergy() < 1
				 or BuffPresent(berserk_cat_buff)
				 or BuffPresent(incarnation_king_of_the_jungle_buff)
				 or BuffPresent(elunes_guidance)
				 or SpellCooldown(tigers_fury) < 3
				 or ArmorSetBonus(T18 4)
				 or {
							BuffPresent(clearcasting_buff)
						and Energy >= 65
					}
				 or Talent(soul_of_the_forest_talent)
				 or not target.DebuffPresent(rip_debuff)
				 or {
							target.DebuffRemaining(rake_debuff) < 1.5
						and Enemies() < 6
					}
			}

			AddFunction Finisher_Requirements_Other
			{
					TimeToMaxEnergy() < 1
				 or BuffPresent(berserk_cat_buff)
				 or BuffPresent(incarnation_king_of_the_jungle_buff)
				 or BuffPresent(elunes_guidance)
				 or SpellCooldown(tigers_fury) < 3
			}

			###
			### Melee Functions
			###
			AddFunction MeleeRange_Use
			{
					CheckBoxOn(opt_melee_range)
				and not target.RangeCheck(shred)
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
											BuffRemaining(berserk_cat_buff) > 10
										 or BuffRemaining(incarnation_king_of_the_jungle_buff) > 20
									}
								and {
											target.TimeToDie() < 180
										 or {
													BuffPresent(trinket_stat_any_buff)
												and target.HealthPercent() < 25	
											}
									}
							}
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 40
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(skull_bash) Spell(skull_bash)
					if target.Distance() < 8 Spell(arcane_torrent_energy)

					if not target.IsRaidBoss()
					{
						if target.RangeCheck(mighty_bash) Spell(mighty_bash)
						if target.RangeCheck(maim) Spell(maim)
						if target.Distance() < 5 Spell(war_stomp)
						if target.Distance() < 15 Spell(typhoon)
					}
				}
			}

			###
			### Feral - Main
			###
			AddFunction MultiDot
			{
				if Rip_Use_Other() Spell(rip text=multi)
				if Rake_Use_Other() Spell(rake text=multi)
				if Moonfire_Use_Other() Spell(moonfire_cat text=multi)
			}

			AddFunction ShortCD
			{
				# Make sure that the player is in Cat form and prowling
				if CheckBoxOn(opt_cat_form) and not Stance(druid_cat_form) Spell(cat_form)
				if Prowl_Use() Spell(prowl)

				# Show get in Melee Range
				if MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))

				# Short CD Spells
				if not CheckBoxOn(opt_regrowth_bloodtalons) and Regrowth_Use_BloodTalons() Spell(regrowth)
				if not CheckBoxOn(opt_regrowth_bloodtalons) and Regrowth_Use_Sabertooth() Spell(regrowth)
				if not CheckBoxOn(opt_regrowth_bloodtalons) and Regrowth_Use_AlluroPouncers() Spell(regrowth)		
				if not CheckBoxOn(opt_savage_roar) and SavageRoar_Apply() Spell(savage_roar pool_resource=1)
				if not CheckBoxOn(opt_thrash) and Thrash_Refresh() Spell(thrash_cat pool_resource=1)
				if not CheckBoxOn(opt_swipe) and Swipe_Use_AOE_Heavy() Spell(swipe_cat pool_resource=1)
				if not CheckBoxOn(opt_savage_roar) and SavageRoar_Use() Spell(savage_roar)
				if not CheckBoxOn(opt_swipe) and Swipe_Use_MaxComboPoints() Spell(swipe_cat)
				if not CheckBoxOn(opt_brutal_slash) and BrutalSlash_Use() Spell(brutal_slash)
				if not CheckBoxOn(opt_ashamanes_frenzy) and AshamanesFrenzy_Use() Spell(ashamanes_frenzy)
				if not CheckBoxOn(opt_elunes_guidance) and ElunesGuidance_Use() Spell(elunes_guidance)
				if not CheckBoxOn(opt_thrash) and Thrash_Use_BrutalSlash() Spell(thrash_cat pool_resource=1)				
				if not CheckBoxOn(opt_swipe) and Swipe_Use_AOE_Medium() Spell(swipe_cat pool_resource=1)
				if not CheckBoxOn(opt_moonfire_lunar) and Moonfire_Use() Spell(moonfire_cat)
				if not CheckBoxOn(opt_thrash) and Thrash_Use() Spell(thrash_cat pool_resource=1)
				if not CheckBoxOn(opt_swipe) and Swipe_Use() Spell(swipe_cat)

				# Healing Spells, only show if enabled.
				if CheckBoxOn(opt_renewal) and Renewal_Use() Spell(renewal)
			}

			AddFunction Main
			{
				if Rake_Use_Stealth() Spell(rake)	
				if CheckBoxOn(opt_berserk) and Berserk_Use() Spell(berserk_cat)
				if CheckBoxOn(opt_berserk) and Incarnation_Use() Spell(incarnation_king_of_the_jungle)
				if TigersFury_Use() Spell(tigers_fury)
				if CheckBoxOn(opt_berserk) and Incarnation_Use_Energy() Spell(incarnation_king_of_the_jungle)
				if FerociousBite_Use_RipRefresh() Spell(ferocious_bite)
				if CheckBoxOn(opt_regrowth_bloodtalons) and Regrowth_Use_BloodTalons() Spell(regrowth)
				if CheckBoxOn(opt_regrowth_bloodtalons) and Regrowth_Use_Sabertooth() Spell(regrowth)
				if TigersFury_Use_Sabertooth() Spell(tigers_fury)
				if CheckBoxOn(opt_regrowth_bloodtalons) and Regrowth_Use_AlluroPouncers() Spell(regrowth)		
				if CheckBoxOn(opt_savage_roar) and SavageRoar_Apply() Spell(savage_roar pool_resource=1)
				if CheckBoxOn(opt_thrash) and Thrash_Refresh() Spell(thrash_cat pool_resource=1)
				if CheckBoxOn(opt_swipe) and Swipe_Use_AOE_Heavy() Spell(swipe_cat pool_resource=1)
				if Rip_Use() Spell(rip)
				if CheckBoxOn(opt_savage_roar) and SavageRoar_Use() Spell(savage_roar)
				if CheckBoxOn(opt_swipe) and Swipe_Use_MaxComboPoints() Spell(swipe_cat)
				if Maim_Use_FieryRedMaimers() Spell(maim)
				if FerociousBite_Use() Spell(ferocious_bite)
				if CheckBoxOn(opt_brutal_slash) and BrutalSlash_Use() Spell(brutal_slash)
				if CheckBoxOn(opt_ashamanes_frenzy) and AshamanesFrenzy_Use() Spell(ashamanes_frenzy)
				if CheckBoxOn(opt_elunes_guidance) and ElunesGuidance_Use() Spell(elunes_guidance)
				if CheckBoxOn(opt_thrash) and Thrash_Use_BrutalSlash() Spell(thrash_cat pool_resource=1)				
				if CheckBoxOn(opt_swipe) and Swipe_Use_AOE_Medium() Spell(swipe_cat pool_resource=1)
				if CheckBoxOn(opt_shadowmeld) and Shadowmeld_Use() Spell(shadowmeld)
				if Rake_Use() Spell(rake pool_resource=1)
				if CheckBoxOn(opt_moonfire_lunar) and Moonfire_Use() Spell(moonfire_cat)
				if CheckBoxOn(opt_thrash) and Thrash_Use() Spell(thrash_cat pool_resource=1)
				if CheckBoxOn(opt_swipe) and Swipe_Use() Spell(swipe_cat)
				if Shred_Use() Spell(shred)
			}

			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Cooldown Spells
				if not CheckBoxOn(opt_berserk) and Berserk_Use() Spell(berserk_cat)
				if not CheckBoxOn(opt_berserk) and Incarnation_Use() Spell(incarnation_king_of_the_jungle)
				if not CheckBoxOn(opt_berserk) and Incarnation_Use_Energy() Spell(incarnation_king_of_the_jungle)
				if not CheckBoxOn(opt_shadowmeld) and Shadowmeld_Use() Spell(shadowmeld)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_survival_instincts) and SurvivalInstincts_Use() Spell(survival_instincts)

				# Potion
				if LunaEclipse_Potion_Use() and Potion_Use() Item(potion_of_the_old_war)

				# Standard Actions
				Spell(blood_fury_ap)
				Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and ArcaneTorrent_Use() Spell(arcane_torrent_energy)
				Rotation_ItemActions()
			}

			###
			### Feral - Main_Precombat
			###
			AddFunction MultiDot_Precombat
			{
			}

			AddFunction ShortCD_Precombat
			{
				# Make sure that the player is in Cat form and prowling
				if CheckBoxOn(opt_cat_form) and not Stance(druid_cat_form) Spell(cat_form)
				if CheckBoxOn(opt_cat_form) and Prowl_Use() Spell(prowl)

				# Show get in Melee Range
				if MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}

			AddFunction Main_Precombat
			{
			}

			AddFunction CD_Precombat
			{
				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_the_old_war)
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

		OvaleScripts:RegisterScript("DRUID", "feral", name, desc, code, "script");
	end
end