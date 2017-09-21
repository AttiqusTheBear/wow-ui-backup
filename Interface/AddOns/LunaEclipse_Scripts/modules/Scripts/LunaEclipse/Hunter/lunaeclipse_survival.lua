local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_hunter_survival";
		local desc = "LunaEclipse: Survival Hunter";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.HUNTER_SURVIVAL,
			ScriptAuthor = "LunaEclipse",
			ScriptCredits = "HuntsTheWind and Vdain",
			GuideAuthor = "Azortharion",
			GuideLink = "http://www.icy-veins.com/wow/survival-hunter-pve-dps-guide",
			WoWVersion = 70105,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding"] = "3121032",
			["Solo / Dungeons"] = "2131012",
			["Easy Mode"] = "1112012",
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
					OPT_CARVE = {
						type = "toggle",
						name = BINDING_NAME_OPT_CARVE,
						desc = functionsConfiguration:getAOETooltip("Carve"),
						arg = "OPT_CARVE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_CALTROPS = {
						type = "toggle",
						name = BINDING_NAME_OPT_CALTROPS,
						desc = functionsConfiguration:getAOETooltip("Caltrops"),
						arg = "OPT_CALTROPS",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_DRAGONSFIRE_GRENADE = {
						type = "toggle",
						name = BINDING_NAME_OPT_DRAGONSFIRE_GRENADE,
						desc = functionsConfiguration:getAOETooltip("Dragonsfire Grenade"),
						arg = "OPT_DRAGONSFIRE_GRENADE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_EXPLOSIVE_TRAP = {
						type = "toggle",
						name = BINDING_NAME_OPT_EXPLOSIVE_TRAP,
						desc = functionsConfiguration:getAOETooltip("Explosive Trap"),
						arg = "OPT_EXPLOSIVE_TRAP",
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
					OPT_AMOC = {
						type = "toggle",
						name = BINDING_NAME_OPT_AMOC,
						desc = functionsConfiguration:getCooldownTooltip("A Murder of Crows"),
						arg = "OPT_AMOC",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_EAGLE_ASPECT = {
						type = "toggle",
						name = BINDING_NAME_OPT_EAGLE_ASPECT,
						desc = functionsConfiguration:getCooldownTooltip("Aspect of the Eagle", "CD"),
						arg = "OPT_EAGLE_ASPECT",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
					OPT_BUTCHERY = {
						type = "toggle",
						name = BINDING_NAME_OPT_BUTCHERY,
						desc = functionsConfiguration:getCooldownTooltip("Butchery"),
						arg = "OPT_BUTCHERY",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_FURY_OF_THE_EAGLE = {
						type = "toggle",
						name = BINDING_NAME_OPT_FURY_OF_THE_EAGLE,
						desc = functionsConfiguration:getCooldownTooltip("Fury of the Eagle"),
						arg = "OPT_FURY_OF_THE_EAGLE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_SNAKE_HUNTER = {
						type = "toggle",
						name = BINDING_NAME_OPT_SNAKE_HUNTER,
						desc = functionsConfiguration:getCooldownTooltip("Snake Hunter", "CD"),
						arg = "OPT_SNAKE_HUNTER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_SPITTING_COBRA = {
						type = "toggle",
						name = BINDING_NAME_OPT_SPITTING_COBRA,
						desc = functionsConfiguration:getCooldownTooltip("Spitting Cobra", "CD"),
						arg = "OPT_SPITTING_COBRA",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_STEEL_TRAP = {
						type = "toggle",
						name = BINDING_NAME_OPT_STEEL_TRAP,
						desc = functionsConfiguration:getCooldownTooltip("Steel Trap", "CD"),
						arg = "OPT_STEEL_TRAP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 70,
					},
					OPT_THROWING_AXES = {
						type = "toggle",
						name = BINDING_NAME_OPT_THROWING_AXES,
						desc = functionsConfiguration:getCooldownTooltip("Throwing Axes"),
						arg = "OPT_THROWING_AXES",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 80,
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
			Define(animal_instincts_talent 1)
			Define(throwing_axes_talent 2)
			Define(way_of_the_moknathal_talent 3)
			Define(a_murder_of_crows_survival_talent 4)
			Define(snake_hunter_talent 6)
            Define(caltrops_talent 10)
			Define(steel_trap_talent 12)
			Define(butchery_talent 16)
			Define(dragonfire_grenade_talent 17)	
			Define(spitting_cobra_talent 19)
			
			# Spells
			Define(a_murder_of_crows_survival 206505)
				SpellInfo(a_murder_of_crows_survival cd=60 gcd=1.5 focus=30)
			Define(aspect_of_the_turtle 186265)
				SpellInfo(aspect_of_the_turtle cd=180 gcd=0 offgcd=1)
				SpellAddBuff(aspect_of_the_turtle aspect_of_the_turtle_buff=1)
			Define(exhilaration 109304)
				SpellInfo(exhilaration cd=120 gcd=0 offgcd=1)
			Define(feign_death 5384)
				SpellInfo(feign_death cd=30 gcd=0)
				SpellAddBuff(feign_death feign_death_buff=1)
			Define(spitting_cobra_survival 194407)
				SpellInfo(spitting_cobra_survival cd=60)
			Define(steel_trap_survival 162488)
				SpellInfo(steel_trap_survival cd=60)

			# Buffs
			Define(aspect_of_the_turtle_buff 186265)
				SpellInfo(aspect_of_the_turtle_buff duration=6)
			Define(feign_death_buff 5384)
				SpellInfo(feign_death_buff duration=360)
			Define(moknathal_tactics_buff 201081)
				SpellInfo(moknathal_tactics_buffs max_stacks=4 duration=8)

            # Debuffs
			Define(lacerate_debuff 185855)
                SpellInfo(lacerate_debuff duration=12)
			
			# Items
            Define(frizzos_fingertrap 137043)

			# Checkboxes
			AddCheckBox(opt_carve "AOE: Carve" default)
			AddCheckBox(opt_caltrops "AOE CD: Caltrops" default)
			AddCheckBox(opt_dragonsfire_grenade "AOE CD: Dragonsfire Grenade" default)
			AddCheckBox(opt_explosive_trap "AOE CD: Explosive Trap" default)
			AddCheckBox(opt_amoc "Cooldown: A Murder of Crows")
			AddCheckBox(opt_eagle_aspect "Cooldown: Aspect of the Eagle" default)
			AddCheckBox(opt_fury_of_the_eagle "Cooldown: Fury of the Eagle" default)
			AddCheckBox(opt_butchery "Cooldown: Butchery" default)
			AddCheckBox(opt_snake_hunter "Cooldown: Snake Hunter" default)
			AddCheckBox(opt_spitting_cobra "Cooldown: Spitting Cobra" default)
			AddCheckBox(opt_steel_trap "Cooldown: Steel Trap" default)
			AddCheckBox(opt_throwing_axes "Cooldown: Throwing Axes" default)
			AddCheckBox(opt_aspect_turtle "Defensive: Aspect of the Turtle")
			AddCheckBox(opt_feign_death "Defensive: Feign Death")
			AddCheckBox(opt_exhilaration "Heal: Exhilaration")
		
			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(muzzle) Spell(muzzle)
					if target.Distance() < 8 Spell(arcane_torrent_focus)

					if not target.IsRaidBoss()
					{
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						if target.Distance() < 5 Spell(war_stomp)
					}
				}
			}

			###
			### ShortCD Rotations - Functions
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

			AddFunction ShortCD_MeleeRange_Use
			{
					CheckBoxOn(opt_melee_range)
				and not target.RangeCheck(raptor_strike)
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


			###
			### ShortCD Rotations
			###
			AddFunction ShortCD
			{
				# Summon pet if needed	
				ShortCD_SummonPet()

				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))

				# Mok'Nathal Rotation ShortCD Spells
				if Rotation_MokNathal_Use()
				{
					if not CheckBoxOn(opt_fury_of_the_eagle) and MokNathal_FuryOfTheEagle_Use_MongooseFury_Expiring() Spell(fury_of_the_eagle)
					if not CheckBoxOn(opt_amoc) and MokNathal_MurderOfCrows_Use_MongooseFury() Spell(a_murder_of_crows_survival)
					if not CheckBoxOn(opt_carve) and MokNathal_Carve_Use_FrizzosFingertrap_MongooseFury() Spell(carve)
					if not CheckBoxOn(opt_butchery) and MokNathal_Butchery_Use_FrizzosFingertrap_MongooseFury() Spell(butchery)
					if not CheckBoxOn(opt_caltrops) and MokNathal_Caltrops_Use_MongooseFury() Spell(caltrops)
					if not CheckBoxOn(opt_explosive_trap) and MokNathal_ExplosiveTrap_Use_MongooseFury() Spell(explosive_trap)
					if not CheckBoxOn(opt_butchery) and MokNathal_Butchery_Use_MongooseFury() Spell(butchery)
					if not CheckBoxOn(opt_carve) and MokNathal_Carve_Use_MongooseFury() Spell(carve)
					if not CheckBoxOn(opt_dragonsfire_grenade) and MokNathal_DragonfireGrenade_Use_MongooseFury() Spell(dragonsfire_grenade)
					if not CheckBoxOn(opt_fury_of_the_eagle) and MokNathal_FuryOfTheEagle_Use_Moknathal_MongooseFury() Spell(fury_of_the_eagle)
					if not CheckBoxOn(opt_fury_of_the_eagle) and MokNathal_FuryOfTheEagle_Use_MongooseFury() Spell(fury_of_the_eagle)
					if not CheckBoxOn(opt_amoc) and MokNathal_MurderOfCrows_Use() Spell(a_murder_of_crows_survival)
					if not CheckBoxOn(opt_caltrops) and MokNathal_Caltrops_Use() Spell(caltrops)
					if not CheckBoxOn(opt_explosive_trap) and MokNathal_ExplosiveTrap_Use() Spell(explosive_trap)
					if not CheckBoxOn(opt_carve) and MokNathal_Carve_Use_FrizzosFingertrap() Spell(carve)
					if not CheckBoxOn(opt_butchery) and MokNathal_Butchery_Use_FrizzosFingertrap() Spell(butchery)
					if not CheckBoxOn(opt_dragonsfire_grenade) and MokNathal_DragonfireGrenade_Use() Spell(dragonsfire_grenade)
					if not CheckBoxOn(opt_butchery) and MokNathal_Butchery_Use() Spell(butchery)
				}

				# Standard Rotation ShortCD Spells
				if Rotation_Standard_Use()
				{
					if not CheckBoxOn(opt_amoc) and Standard_MurderOfCrows_Use_MongooseFury() Spell(a_murder_of_crows_survival)
					if not CheckBoxOn(opt_caltrops) and Standard_Caltrops_Use_MongooseFury() Spell(caltrops)
					if not CheckBoxOn(opt_carve) and Standard_Carve_Use_FrizzosFingertrap_MongooseFury() Spell(carve)
					if not CheckBoxOn(opt_butchery) and Standard_Butchery_Use_FrizzosFingertrap_MongooseFury() Spell(butchery)
					if not CheckBoxOn(opt_dragonsfire_grenade) and Standard_DragonfireGrenade_Use_MongooseFury() Spell(dragonsfire_grenade)
					if not CheckBoxOn(opt_explosive_trap) and Standard_ExplosiveTrap_Use_MongooseFury() Spell(explosive_trap)
					if not CheckBoxOn(opt_fury_of_the_eagle) and Standard_FuryOfTheEagle_Use() Spell(fury_of_the_eagle)
					if not CheckBoxOn(opt_amoc) and Standard_MurderOfCrows_Use() Spell(a_murder_of_crows_survival)
					if not CheckBoxOn(opt_caltrops) and Standard_Caltrops_Use() Spell(caltrops)
					if not CheckBoxOn(opt_explosive_trap) and Standard_ExplosiveTrap_Use() Spell(explosive_trap)
					if not CheckBoxOn(opt_carve) and Standard_Carve_Use_FrizzosFingertrap() Spell(carve)
					if not CheckBoxOn(opt_butchery) and Standard_Butchery_Use_FrizzosFingertrap() Spell(butchery)
					if not CheckBoxOn(opt_dragonsfire_grenade) and Standard_DragonfireGrenade_Use() Spell(dragonsfire_grenade)
					if not CheckBoxOn(opt_throwing_axes) and Standard_ThrowingAxes_Use_MaxCharges() Spell(throwing_axes)
					if not CheckBoxOn(opt_butchery) and Standard_Butchery_Use() Spell(butchery)
					if not CheckBoxOn(opt_throwing_axes) and Standard_ThrowingAxes_Use() Spell(throwing_axes)
				}

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_exhilaration) and ShortCD_Exhilaration_Use() Spell(exhilaration)
				if CheckBoxOn(opt_feign_death) and ShortCD_FeignDeath_Use() Spell(feign_death)
			}

			AddFunction ShortCD_Precombat
			{
				# Summon pet if needed	
				ShortCD_SummonPet()

				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}

			###
			### Mok'Nathal Rotation - Functions
			###
			AddFunction MokNathal_AspectOfTheEagle_Use
			{
					not SpellCooldown(aspect_of_the_eagle)
				and	{
							BuffPresent(mongoose_fury_buff)
						and BuffRemaining(mongoose_fury_buff) > 6
						and SpellCharges(mongoose_bite) < 2
					}
			}

			AddFunction MokNathal_AspectOfTheEagle_Use_MongooseFury
			{
					not SpellCooldown(aspect_of_the_eagle)
				and	{
							BuffStacks(mongoose_fury_buff) > 1
						and TimeInCombat() > 15
					}
			}

			AddFunction MokNathal_AspectOfTheEagle_Use_MongooseFury_Opener
			{
					not SpellCooldown(aspect_of_the_eagle)
				and	{
							BuffStacks(mongoose_fury_buff) > 4
						and TimeInCombat() <= 15
					}
			}

			AddFunction MokNathal_Butchery_Use
			{
					Talent(butchery_talent)
                and SpellCharges(butchery) >= 1
				and Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
				and Focus() >= 40
			}

			AddFunction MokNathal_Butchery_Use_FrizzosFingertrap
			{
					Talent(butchery_talent)
                and SpellCharges(butchery) >= 1
				and {
							LegendaryEquipped(frizzos_fingertrap)
						and target.DebuffPresent(lacerate_debuff)
						and target.InPandemicRange(lacerate_debuff butchery)
						and Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
					}
			}

			AddFunction MokNathal_Butchery_Use_FrizzosFingertrap_MongooseFury
			{
					Talent(butchery_talent)
                and SpellCharges(butchery) >= 1
				and {
							LegendaryEquipped(frizzos_fingertrap)
						and target.DebuffPresent(lacerate_debuff)
						and target.InPandemicRange(lacerate_debuff butchery)
						and Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
						and BuffRemaining(mongoose_fury_buff) >= GCD()
					}
			}

			AddFunction MokNathal_Butchery_Use_MongooseFury
			{
					Talent(butchery_talent)
                and SpellCharges(butchery) >= 1
				and {
							Enemies() > 1
						and Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
						and {
									not BuffPresent(mongoose_fury_buff)
								 or BuffRemaining(mongoose_fury_buff) > GCD() * SpellCharges(mongoose_bite)
							}
					}
			}

			AddFunction MokNathal_Caltrops_Use
			{
					Talent(caltrops_talent)		
				and not SpellCooldown(caltrops)
				and not target.DebuffPresent(caltrops_debuff)
			}

			AddFunction MokNathal_Caltrops_Use_MongooseFury
			{
					Talent(caltrops_talent)		
				and not SpellCooldown(caltrops)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and BuffStacks(mongoose_fury_buff) < 1
						and not target.DebuffPresent(caltrops_debuff)
					}
			}

			AddFunction MokNathal_Carve_Use_FrizzosFingertrap
			{
					not SpellCooldown(carve)
				and {
							LegendaryEquipped(frizzos_fingertrap)
						and target.DebuffPresent(lacerate_debuff)
						and target.InPandemicRange(lacerate_debuff carve)
						and Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
					}
				and Focus() >= 40
			}

			AddFunction MokNathal_Carve_Use_FrizzosFingertrap_MongooseFury
			{
					not SpellCooldown(carve)
				and {
							LegendaryEquipped(frizzos_fingertrap)
						and target.DebuffPresent(lacerate_debuff)
						and target.InPandemicRange(lacerate_debuff carve)
						and Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
						and BuffRemaining(mongoose_fury_buff) >= GCD()
					}
			}

			AddFunction MokNathal_Carve_Use_MongooseFury
			{
					not SpellCooldown(carve)
				and {
							Enemies() > 1
						and Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
						and {
									{
											not BuffPresent(mongoose_fury_buff)
										and Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
									}
								 or {
											BuffRemaining(mongoose_fury_buff) > GCD() * SpellCharges(mongoose_bite)
										and Focus() > 70 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
									}
							}
					}
				and Focus() >= 40
			}

			AddFunction MokNathal_DragonfireGrenade_Use
			{
					Talent(dragonfire_grenade_talent)		
				and not SpellCooldown(dragonsfire_grenade)
			}

			AddFunction MokNathal_DragonfireGrenade_Use_MongooseFury
			{
					Talent(dragonfire_grenade_talent)		
				and not SpellCooldown(dragonsfire_grenade)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and SpellCharges(mongoose_bite) >= 0
						and BuffStacks(mongoose_fury_buff) < 1
					}
			}

			AddFunction MokNathal_ExplosiveTrap_Use
			{
					not SpellCooldown(explosive_trap)
			}

			AddFunction MokNathal_ExplosiveTrap_Use_MongooseFury
			{
					not SpellCooldown(explosive_trap)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and SpellCharges(mongoose_bite) == 0
						and BuffStacks(mongoose_fury_buff) < 1
					}
				and Focus() >= 40
			}

			AddFunction MokNathal_FlankingStrike_Use
			{
					not SpellCooldown(flanking_strike)
				and Focus() >= 50
			}

			AddFunction MokNathal_FlankingStrike_Use_MongooseFury
			{
					not SpellCooldown(flanking_strike)
				and {
							SpellCharges(mongoose_bite) <= 1
						and Focus() > 75 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
					}
				and Focus() >= 50
			}

			AddFunction MokNathal_FuryOfTheEagle_Use_Moknathal_MongooseFury
			{
					SpellKnown(fury_of_the_eagle)
				and not SpellCooldown(fury_of_the_eagle)
				and {
							BuffRemaining(moknathal_tactics_buff) > 4
						and BuffStacks(mongoose_fury_buff) == 6
						and SpellCharges(mongoose_bite) <= 1
					}
			}
 
			AddFunction MokNathal_FuryOfTheEagle_Use_MongooseFury
			{
					SpellKnown(fury_of_the_eagle)
				and not SpellCooldown(fury_of_the_eagle)
				and {
							BuffPresent(mongoose_fury_buff)
						and BuffRemaining(mongoose_fury_buff) <= 2 * GCD()
					}
			}

			AddFunction MokNathal_FuryOfTheEagle_Use_MongooseFury_Expiring
			{
					SpellKnown(fury_of_the_eagle)
				and not SpellCooldown(fury_of_the_eagle)
				and {
							BuffStacks(mongoose_fury_buff) >= 4
						and BuffRemaining(mongoose_fury_buff) < GCD()
					}
			}

			AddFunction MokNathal_Lacerate_Use
			{
					not SpellCooldown(lacerate)
				and target.InPandemicRange(lacerate_debuff lacerate)
				and Focus() > 55 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
				and Focus() >= 35
			}

			AddFunction MokNathal_Lacerate_Use_MongooseFury
			{
					not SpellCooldown(lacerate)
				and {
							target.InPandemicRange(lacerate_debuff lacerate)
						and {
									{
											Focus() > 55 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
										and BuffRemaining(mongoose_fury_buff) >= GCD()
										and SpellCharges(mongoose_bite) == 0
										and BuffStacks(mongoose_fury_buff) < 3
									}
								 or {
											Focus() > 65 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
										and not BuffPresent(mongoose_fury_buff)
										and SpellCharges(mongoose_bite) < 3
									}
							}
					}
				and Focus() >= 35
			}

			AddFunction MokNathal_MongooseBite_Use
			{
                    {
							SpellCharges(mongoose_bite) == 2
						and SpellCooldown(mongoose_bite) <= GCD()
					}
				 or SpellCharges(mongoose_bite) == 3
			}

			AddFunction MokNathal_MongooseBite_Use_EagleAspect
			{
                    SpellCharges(mongoose_bite) >= 1
				and {
							BuffPresent(aspect_of_the_eagle_buff)
						and BuffPresent(mongoose_fury_buff)
						and BuffStacks(moknathal_tactics_buff) >= 4
					}
			}

			AddFunction MokNathal_MongooseBite_Use_MongooseFury
			{
                    SpellCharges(mongoose_bite) >= 1
				and {
							BuffPresent(mongoose_fury_buff)
						and BuffRemaining(mongoose_fury_buff) < SpellCooldown(aspect_of_the_eagle)
					}
			}

			AddFunction MokNathal_MurderOfCrows_Use
			{
					Talent(a_murder_of_crows_survival_talent)
				and not SpellCooldown(a_murder_of_crows_survival)
				and Focus() > 55 - BuffStacks(moknathal_tactics_buff) * FocusRegenRate()
				and Focus() >= 30
			}

			AddFunction MokNathal_MurderOfCrows_Use_MongooseFury
			{
					Talent(a_murder_of_crows_survival_talent)
				and not SpellCooldown(a_murder_of_crows_survival)
				and {
							Focus() > 55 - BuffRemaining(moknathal_tactics_buff) * FocusRegenRate()
						and BuffStacks(mongoose_fury_buff) < 4
						and	BuffRemaining(mongoose_fury_buff) >= GCD()
					}
				and Focus() >= 30
			}

			AddFunction MokNathal_RaptorStrike_Use
			{
					not SpellCooldown(raptor_strike)
				and {
							BuffPresent(mongoose_fury_buff)
						and BuffRemaining(mongoose_fury_buff) <= 3 * GCD()
						and BuffRemaining(moknathal_tactics_buff) < 4 + GCD()
						and {
									not SpellKnown(fury_of_the_eagle)
								 or SpellCooldown(fury_of_the_eagle) < GCD()
							}
					}
				and Focus() >= 25
			}

			AddFunction MokNathal_RaptorStrike_Use_Focus
			{
					not SpellCooldown(raptor_strike)
				and Focus() > 75 - SpellCooldown(flanking_strike) * FocusRegenRate()
				and Focus() >= 25
			}

			AddFunction MokNathal_RaptorStrike_Use_Moknathal
			{
					not SpellCooldown(raptor_strike)
				and BuffStacks(moknathal_tactics_buff) == 2
				and Focus() >= 25
			}

			AddFunction MokNathal_RaptorStrike_Use_Moknathal_Expiring
			{
					not SpellCooldown(raptor_strike)
				and BuffRemaining(moknathal_tactics_buff) < GCD()
				and Focus() >= 25
			}

			AddFunction MokNathal_RaptorStrike_Use_Moknathal_MongooseFury
			{
					not SpellCooldown(raptor_strike)
				and {
							BuffStacks(mongoose_fury_buff) >= 4
						and BuffRemaining(mongoose_fury_buff) > GCD()
						and BuffStacks(moknathal_tactics_buff) >= 3
						and BuffRemaining(moknathal_tactics_buff) < 4
						and {
									not SpellKnown(fury_of_the_eagle)
								 or SpellCooldown(fury_of_the_eagle) < BuffRemaining(mongoose_fury_buff)
							}
					}
				and Focus() >= 25
			}

			AddFunction MokNathal_RaptorStrike_Use_Moknathal_MongooseFury_FullStacks
			{
					not SpellCooldown(raptor_strike)
				and {
							BuffRemaining(moknathal_tactics_buff) < 4
						and	BuffStacks(mongoose_fury_buff) == 6
						and {
									not SpellKnown(fury_of_the_eagle)
								 or SpellCooldown(fury_of_the_eagle) < BuffRemaining(mongoose_fury_buff)
							}
						and {
									not SpellKnown(fury_of_the_eagle)
								 or SpellCooldown(fury_of_the_eagle) <= 5
							}
					}
				and Focus() >= 25
			}

			AddFunction MokNathal_RaptorStrike_Use_Moknathal_Stacks
			{
					not SpellCooldown(raptor_strike)
				and BuffStacks(moknathal_tactics_buff) <= 1
				and Focus() >= 25
			}

			AddFunction MokNathal_SnakeHunter_Use
			{
					Talent(snake_hunter_talent)
				and not SpellCooldown(snake_hunter)
				and {
							SpellCharges(mongoose_bite) <= 0
						and BuffRemaining(mongoose_fury_buff) >= 3 * GCD()
						and TimeInCombat() > 15
					}
			}

			AddFunction MokNathal_SpittingCobra_Use
			{
                    Talent(spitting_cobra_talent)
				and not SpellCooldown(spitting_cobra_survival)
			}

			AddFunction MokNathal_SpittingCobra_Use_MongooseFury
			{
                    Talent(spitting_cobra_talent)
				and not SpellCooldown(spitting_cobra_survival)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and SpellCharges(mongoose_bite) >= 0
						and BuffStacks(mongoose_fury_buff) < 4
						and BuffStacks(moknathal_tactics_buff) == 3
					}
			}

			AddFunction MokNathal_SteelTrap_Use
			{
					Talent(steel_trap_talent)
				and not SpellCooldown(steel_trap_survival)
			}

			AddFunction MokNathal_SteelTrap_Use_MongooseFury
			{
					Talent(steel_trap_talent)
				and not SpellCooldown(steel_trap_survival)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and BuffStacks(mongoose_fury_buff) < 1
					}
			}

			###
			### Mok'Nathal Rotation - Usage
			###
			AddFunction Rotation_MokNathal_Use
			{
					Talent(way_of_the_moknathal_talent)
			}

			###
			### Mok'Nathal Rotation
			###
			AddFunction Rotation_MokNathal
			{
				if MokNathal_RaptorStrike_Use_Moknathal_Stacks() Spell(raptor_strike)
				if MokNathal_RaptorStrike_Use_Moknathal_Expiring() Spell(raptor_strike)
				if CheckBoxOn(opt_fury_of_the_eagle) and MokNathal_FuryOfTheEagle_Use_MongooseFury_Expiring() Spell(fury_of_the_eagle)
				if MokNathal_RaptorStrike_Use_Moknathal_MongooseFury() Spell(raptor_strike)
				if CheckBoxOn(opt_snake_hunter) and MokNathal_SnakeHunter_Use() Spell(snake_hunter)
				if CheckBoxOn(opt_spitting_cobra) and MokNathal_SpittingCobra_Use_MongooseFury() Spell(spitting_cobra_survival)
				if CheckBoxOn(opt_steel_trap) and MokNathal_SteelTrap_Use_MongooseFury() Spell(steel_trap_survival)
				if CheckBoxOn(opt_amoc) and MokNathal_MurderOfCrows_Use_MongooseFury() Spell(a_murder_of_crows_survival)
				if MokNathal_FlankingStrike_Use_MongooseFury() Spell(flanking_strike)
				if CheckBoxOn(opt_carve) and MokNathal_Carve_Use_FrizzosFingertrap_MongooseFury() Spell(carve)
				if CheckBoxOn(opt_butchery) and MokNathal_Butchery_Use_FrizzosFingertrap_MongooseFury() Spell(butchery)
				if MokNathal_Lacerate_Use_MongooseFury() Spell(lacerate)
				if CheckBoxOn(opt_caltrops) and MokNathal_Caltrops_Use_MongooseFury() Spell(caltrops)
				if CheckBoxOn(opt_explosive_trap) and MokNathal_ExplosiveTrap_Use_MongooseFury() Spell(explosive_trap)
				if CheckBoxOn(opt_butchery) and MokNathal_Butchery_Use_MongooseFury() Spell(butchery)
				if CheckBoxOn(opt_carve) and MokNathal_Carve_Use_MongooseFury() Spell(carve)
				if MokNathal_RaptorStrike_Use_Moknathal() Spell(raptor_strike)
				if CheckBoxOn(opt_dragonsfire_grenade) and MokNathal_DragonfireGrenade_Use_MongooseFury() Spell(dragonsfire_grenade)
				if MokNathal_RaptorStrike_Use_Moknathal_MongooseFury_FullStacks() Spell(raptor_strike)
				if CheckBoxOn(opt_fury_of_the_eagle) and MokNathal_FuryOfTheEagle_Use_Moknathal_MongooseFury() Spell(fury_of_the_eagle)
				if MokNathal_MongooseBite_Use_EagleAspect() Spell(mongoose_bite)
				if MokNathal_RaptorStrike_Use() Spell(raptor_strike)
				if CheckBoxOn(opt_fury_of_the_eagle) and MokNathal_FuryOfTheEagle_Use_MongooseFury() Spell(fury_of_the_eagle)
				if CheckBoxOn(opt_eagle_aspect) and MokNathal_AspectOfTheEagle_Use_MongooseFury_Opener() Spell(aspect_of_the_eagle)
				if CheckBoxOn(opt_eagle_aspect) and MokNathal_AspectOfTheEagle_Use_MongooseFury() Spell(aspect_of_the_eagle)
				if CheckBoxOn(opt_eagle_aspect) and MokNathal_AspectOfTheEagle_Use() Spell(aspect_of_the_eagle)
				if MokNathal_MongooseBite_Use_MongooseFury() Spell(mongoose_bite)
				if CheckBoxOn(opt_spitting_cobra) and MokNathal_SpittingCobra_Use() Spell(spitting_cobra_survival)
				if CheckBoxOn(opt_steel_trap) and MokNathal_SteelTrap_Use() Spell(steel_trap_survival)
				if CheckBoxOn(opt_amoc) and MokNathal_MurderOfCrows_Use() Spell(a_murder_of_crows_survival)
				if CheckBoxOn(opt_caltrops) and MokNathal_Caltrops_Use() Spell(caltrops)
				if CheckBoxOn(opt_explosive_trap) and MokNathal_ExplosiveTrap_Use() Spell(explosive_trap)
				if CheckBoxOn(opt_carve) and MokNathal_Carve_Use_FrizzosFingertrap() Spell(carve)
				if CheckBoxOn(opt_butchery) and MokNathal_Butchery_Use_FrizzosFingertrap() Spell(butchery)
				if MokNathal_Lacerate_Use() Spell(lacerate)
				if CheckBoxOn(opt_dragonsfire_grenade) and MokNathal_DragonfireGrenade_Use() Spell(dragonsfire_grenade)
				if MokNathal_MongooseBite_Use() Spell(mongoose_bite)
				if MokNathal_FlankingStrike_Use() Spell(flanking_strike)
				if CheckBoxOn(opt_butchery) and MokNathal_Butchery_Use() Spell(butchery)
				if MokNathal_RaptorStrike_Use_Focus() Spell(raptor_strike)
			}

			###
			### Standard Rotation - Functions
			###
			AddFunction Standard_AspectOfTheEagle_Use
			{
					not SpellCooldown(aspect_of_the_eagle)
				and	{
							BuffPresent(mongoose_fury_buff)
						and BuffRemaining(mongoose_fury_buff) > 6
						and SpellCharges(mongoose_bite) >= 2
					}
			}

			AddFunction Standard_Butchery_Use
			{
					Talent(butchery_talent)
                and SpellCharges(butchery) >= 1
				and Focus() >= 40
			}

			AddFunction Standard_Butchery_Use_FrizzosFingertrap
			{
					Talent(butchery_talent)
                and SpellCharges(butchery) >= 1
				and {
							LegendaryEquipped(frizzos_fingertrap)
						and target.DebuffPresent(lacerate_debuff)
						and target.InPandemicRange(lacerate_debuff butchery)
						and Focus() > 65
					}
			}

			AddFunction Standard_Butchery_Use_FrizzosFingertrap_MongooseFury
			{
					Talent(butchery_talent)
                and SpellCharges(butchery) >= 1
				and {
							LegendaryEquipped(frizzos_fingertrap)
						and target.DebuffPresent(lacerate_debuff)
						and target.InPandemicRange(lacerate_debuff butchery)
						and Focus() > 65
						and BuffRemaining(mongoose_fury_buff) >= GCD()
					}
			}

			AddFunction Standard_Caltrops_Use
			{
					Talent(caltrops_talent)		
				and not SpellCooldown(caltrops)
				and not target.DebuffPresent(caltrops_debuff)
			}

			AddFunction Standard_Caltrops_Use_MongooseFury
			{
					Talent(caltrops_talent)		
				and not SpellCooldown(caltrops)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and BuffStacks(mongoose_fury_buff) < 4
						and not target.DebuffPresent(caltrops_debuff)
					}
			}

			AddFunction Standard_Carve_Use_FrizzosFingertrap
			{
					not SpellCooldown(carve)
				and {
							LegendaryEquipped(frizzos_fingertrap)
						and target.DebuffPresent(lacerate_debuff)
						and target.InPandemicRange(lacerate_debuff carve)
						and Focus() > 65
					}
				and Focus() >= 40
			}

			AddFunction Standard_Carve_Use_FrizzosFingertrap_MongooseFury
			{
					not SpellCooldown(carve)
				and {
							LegendaryEquipped(frizzos_fingertrap)
						and target.DebuffPresent(lacerate_debuff)
						and target.InPandemicRange(lacerate_debuff carve)
						and Focus() > 65
						and BuffRemaining(mongoose_fury_buff) >= GCD()
					}
				and Focus() >= 40
			}

			AddFunction Standard_DragonfireGrenade_Use
			{
					Talent(dragonfire_grenade_talent)		
				and not SpellCooldown(dragonsfire_grenade)
			}

			AddFunction Standard_DragonfireGrenade_Use_MongooseFury
			{
					Talent(dragonfire_grenade_talent)		
				and not SpellCooldown(dragonsfire_grenade)
				and {
							{
									BuffRemaining(mongoose_fury_buff) >= GCD()
								and SpellCharges(mongoose_bite) <= 1
								and BuffStacks(mongoose_fury_buff) < 3
							}
						 or {
									not BuffPresent(mongoose_fury_buff)
								and SpellCharges(mongoose_bite) < 3
							}
					}
			}

			AddFunction Standard_ExplosiveTrap_Use
			{
					not SpellCooldown(explosive_trap)
			}

			AddFunction Standard_ExplosiveTrap_Use_MongooseFury
			{
					not SpellCooldown(explosive_trap)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and SpellCharges(mongoose_bite) >= 0
						and BuffStacks(mongoose_fury_buff) < 4
					}
			}

			AddFunction Standard_FlankingStrike_Use
			{
					not SpellCooldown(flanking_strike)
				and Focus() >= 50
			}

			AddFunction Standard_FlankingStrike_Use_AnimalInstincts
			{
					not SpellCooldown(flanking_strike)
				and {
							Talent(animal_instincts_talent)
						and SpellCharges(mongoose_bite) < 3
					}
				and Focus() >= 50
			}

			AddFunction Standard_FlankingStrike_Use_EagleAspect
			{
					not SpellCooldown(flanking_strike)
				and {
							SpellCharges(mongoose_bite) <= 1
						and BuffRemaining(aspect_of_the_eagle_buff) >= GCD()
					}
				and Focus() >= 50
			}

			AddFunction Standard_FlankingStrike_Use_MongooseFury
			{
					not SpellCooldown(flanking_strike)
				and {
							SpellCharges(mongoose_bite) <= 1
						and BuffRemaining(mongoose_fury_buff) > 1 + SpellCharges(mongoose_bite) * GCD()
					}
				and Focus() >= 50
			}

			AddFunction Standard_FuryOfTheEagle_Use
			{
					SpellKnown(fury_of_the_eagle)
				and not SpellCooldown(fury_of_the_eagle)
				and {
							SpellCharges(mongoose_bite) <= 1
						and BuffRemaining(mongoose_fury_buff) > 6
					}
			}

			AddFunction Standard_FuryOfTheEagle_Use_MongooseFury
			{
					SpellKnown(fury_of_the_eagle)
				and not SpellCooldown(fury_of_the_eagle)
				and {
							BuffStacks(mongoose_fury_buff) == 6
						and SpellCharges(mongoose_bite) <= 1
					}
			}

			AddFunction Standard_Lacerate_Use
			{
					not SpellCooldown(lacerate)
				and target.InPandemicRange(lacerate_debuff lacerate)
				and Focus() >= 35
			}

			AddFunction Standard_Lacerate_Use_MongooseFury
			{
					not SpellCooldown(lacerate)
				and {
							{
									BuffRemaining(mongoose_fury_buff) >= GCD()
								and target.InPandemicRange(lacerate_debuff lacerate)
								and SpellCharges(mongoose_bite) == 0
								and BuffStacks(mongoose_fury_buff) < 2
							}
						 or {
									not BuffPresent(mongoose_fury_buff)
								and SpellCharges(mongoose_bite) < 3
								and target.InPandemicRange(lacerate_debuff lacerate)
							}
					}
				and Focus() >= 35
			}

			AddFunction Standard_MongooseBite_Use
			{
                    {
							SpellCharges(mongoose_bite) == 2
						and SpellCooldown(mongoose_bite) <= GCD()
					}
				 or SpellCharges(mongoose_bite) == 3
			}

			AddFunction Standard_MongooseBite_Use_EagleAspect
			{
                    SpellCharges(mongoose_bite) >= 1
				and {
							BuffPresent(aspect_of_the_eagle_buff)
						and BuffPresent(mongoose_fury_buff)
					}
			}

			AddFunction Standard_MongooseBite_Use_MongooseFury
			{
                    SpellCharges(mongoose_bite) >= 1
				and {
							BuffPresent(mongoose_fury_buff)
						and BuffRemaining(mongoose_fury_buff) < SpellCooldown(aspect_of_the_eagle)
					}
			}

			AddFunction Standard_MurderOfCrows_Use
			{
					Talent(a_murder_of_crows_survival_talent)
				and not SpellCooldown(a_murder_of_crows_survival)
				and Focus() >= 30
			}

			AddFunction Standard_MurderOfCrows_Use_MongooseFury
			{
					Talent(a_murder_of_crows_survival_talent)
				and not SpellCooldown(a_murder_of_crows_survival)
				and {
							SpellCharges(mongoose_bite) >= 0
						and BuffStacks(mongoose_fury_buff) < 4
					}
				and Focus() >= 30
			}

			AddFunction Standard_RaptorStrike_Use
			{
					not SpellCooldown(raptor_strike)
				and Focus() > 75 - SpellCooldown(flanking_strike) * FocusRegenRate()
				and Focus() >= 25
			}

			AddFunction Standard_RaptorStrike_Use_SerpentSting
			{
					not SpellCooldown(raptor_strike)
				and {
							Talent(serpent_sting_talent)
						and target.InPandemicRange(serpent_sting_debuff raptor_strike)
						and BuffStacks(mongoose_fury_buff) < 3
						and SpellCharges(mongoose_bite) < 1
					}
				and Focus() >= 25
			}

			AddFunction Standard_SnakeHunter_Use
			{
					Talent(snake_hunter_talent)
				and not SpellCooldown(snake_hunter)
				and {
							SpellCharges(mongoose_bite) <= 0
						and BuffRemaining(mongoose_fury_buff) > 3 * GCD()
						and TimeInCombat() > 15
					}
			}

			AddFunction Standard_SpittingCobra_Use
			{
                    Talent(spitting_cobra_talent)
				and not SpellCooldown(spitting_cobra_survival)
			}

			AddFunction Standard_SpittingCobra_Use_MongooseFury
			{
                    Talent(spitting_cobra_talent)
				and not SpellCooldown(spitting_cobra_survival)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and SpellCharges(mongoose_bite) >= 0
						and BuffStacks(mongoose_fury_buff) < 4
					}
			}

			AddFunction Standard_SteelTrap_Use
			{
					Talent(steel_trap_talent)
				and not SpellCooldown(steel_trap_survival)
			}

			AddFunction Standard_SteelTrap_Use_MongooseFury
			{
					Talent(steel_trap_talent)
				and not SpellCooldown(steel_trap_survival)
				and {
							BuffRemaining(mongoose_fury_buff) >= GCD()
						and BuffStacks(mongoose_fury_buff) < 1
					}
			}

			AddFunction Standard_ThrowingAxes_Use
			{
					Talent(throwing_axes_talent)
				and SpellCharges(throwing_axes) >= 1
				and Focus() >= 15
			}

			AddFunction Standard_ThrowingAxes_Use_MaxCharges
			{
					Talent(throwing_axes_talent)
				and SpellCharges(throwing_axes) == 2
				and Focus() >= 15
			}

			###
			### Standard Rotation - Usage
			###
			AddFunction Rotation_Standard_Use
			{
					not Talent(way_of_the_moknathal_talent)
			}

			###
			### Standard Rotation
			###
			AddFunction Rotation_Standard
			{
				if CheckBoxOn(opt_spitting_cobra) and Standard_SpittingCobra_Use_MongooseFury() Spell(spitting_cobra_survival)
				if CheckBoxOn(opt_steel_trap) and Standard_SteelTrap_Use_MongooseFury() Spell(steel_trap_survival)
				if CheckBoxOn(opt_amoc) and Standard_MurderOfCrows_Use_MongooseFury() Spell(a_murder_of_crows_survival)
				if CheckBoxOn(opt_snake_hunter) and Standard_SnakeHunter_Use() Spell(snake_hunter)
				if CheckBoxOn(opt_caltrops) and Standard_Caltrops_Use_MongooseFury() Spell(caltrops)
				if Standard_FlankingStrike_Use_EagleAspect() Spell(flanking_strike)
				if CheckBoxOn(opt_carve) and Standard_Carve_Use_FrizzosFingertrap_MongooseFury() Spell(carve)
				if CheckBoxOn(opt_butchery) and Standard_Butchery_Use_FrizzosFingertrap_MongooseFury() Spell(butchery)
				if Standard_Lacerate_Use_MongooseFury() Spell(lacerate)
				if CheckBoxOn(opt_dragonsfire_grenade) and Standard_DragonfireGrenade_Use_MongooseFury() Spell(dragonsfire_grenade)
				if CheckBoxOn(opt_explosive_trap) and Standard_ExplosiveTrap_Use_MongooseFury() Spell(explosive_trap)
				if Standard_RaptorStrike_Use_SerpentSting() Spell(raptor_strike)
				if CheckBoxOn(opt_fury_of_the_eagle) and Standard_FuryOfTheEagle_Use_MongooseFury() Spell(fury_of_the_eagle)
				if Standard_MongooseBite_Use_EagleAspect() Spell(mongoose_bite)
				if CheckBoxOn(opt_eagle_aspect) and Standard_AspectOfTheEagle_Use() Spell(aspect_of_the_eagle)
				if CheckBoxOn(opt_fury_of_the_eagle) and Standard_FuryOfTheEagle_Use() Spell(fury_of_the_eagle)
				if Standard_FlankingStrike_Use_MongooseFury() Spell(flanking_strike)
				if Standard_MongooseBite_Use_MongooseFury() Spell(mongoose_bite)
				if Standard_FlankingStrike_Use_AnimalInstincts() Spell(flanking_strike)
				if CheckBoxOn(opt_spitting_cobra) and Standard_SpittingCobra_Use() Spell(spitting_cobra_survival)
				if CheckBoxOn(opt_steel_trap) and Standard_SteelTrap_Use() Spell(steel_trap_survival)
				if CheckBoxOn(opt_amoc) and Standard_MurderOfCrows_Use() Spell(a_murder_of_crows_survival)
				if CheckBoxOn(opt_caltrops) and Standard_Caltrops_Use() Spell(caltrops)
				if CheckBoxOn(opt_explosive_trap) and Standard_ExplosiveTrap_Use() Spell(explosive_trap)
				if CheckBoxOn(opt_carve) and Standard_Carve_Use_FrizzosFingertrap() Spell(carve)
				if CheckBoxOn(opt_butchery) and Standard_Butchery_Use_FrizzosFingertrap() Spell(butchery)
				if Standard_Lacerate_Use() Spell(lacerate)
				if CheckBoxOn(opt_dragonsfire_grenade) and Standard_DragonfireGrenade_Use() Spell(dragonsfire_grenade)
				if CheckBoxOn(opt_throwing_axes) and Standard_ThrowingAxes_Use_MaxCharges() Spell(throwing_axes)
				if Standard_MongooseBite_Use() Spell(mongoose_bite)
				if Standard_FlankingStrike_Use() Spell(flanking_strike)
				if CheckBoxOn(opt_butchery) and Standard_Butchery_Use() Spell(butchery)
				if CheckBoxOn(opt_throwing_axes) and Standard_ThrowingAxes_Use() Spell(throwing_axes)
				if Standard_RaptorStrike_Use() Spell(raptor_strike)
			}

			###
			### Main Rotations
			###
			AddFunction Main
			{
				# Call the Mok'Nathal rotation is the talent is selected
				if Rotation_MokNathal_Use() Rotation_MokNathal()

				# Use the standard rotation if the Way of the Mok'Nathal is not selected
				if Rotation_Standard_Use() Rotation_Standard()
			}

			AddFunction Main_Precombat
			{
			}

			###
			### CD Rotations - Functions
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
						and BuffPresent(aspect_of_the_eagle_buff)
					}
				 or target.HealthPercent() <= 20
				 or target.TimeToDie() <= 40
			}

			###
			### CD Rotations
			###
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# Mok'Nathal Rotation Cooldown Spells
				if Rotation_MokNathal_Use()
				{
					if not CheckBoxOn(opt_snake_hunter) and MokNathal_SnakeHunter_Use() Spell(snake_hunter)
					if not CheckBoxOn(opt_spitting_cobra) and MokNathal_SpittingCobra_Use_MongooseFury() Spell(spitting_cobra_survival)
					if not CheckBoxOn(opt_steel_trap) and MokNathal_SteelTrap_Use_MongooseFury() Spell(steel_trap_survival)
					if not CheckBoxOn(opt_eagle_aspect) and MokNathal_AspectOfTheEagle_Use_MongooseFury_Opener() Spell(aspect_of_the_eagle)
					if not CheckBoxOn(opt_eagle_aspect) and MokNathal_AspectOfTheEagle_Use_MongooseFury() Spell(aspect_of_the_eagle)
					if not CheckBoxOn(opt_eagle_aspect) and MokNathal_AspectOfTheEagle_Use() Spell(aspect_of_the_eagle)
					if not CheckBoxOn(opt_spitting_cobra) and MokNathal_SpittingCobra_Use() Spell(spitting_cobra_survival)
					if not CheckBoxOn(opt_steel_trap) and MokNathal_SteelTrap_Use() Spell(steel_trap_survival)
				}

				# Standard Rotation Cooldown Spells
				if Rotation_Standard_Use()
				{
					if not CheckBoxOn(opt_spitting_cobra) and Standard_SpittingCobra_Use_MongooseFury() Spell(spitting_cobra_survival)
					if not CheckBoxOn(opt_steel_trap) and Standard_SteelTrap_Use_MongooseFury() Spell(steel_trap_survival)
					if not CheckBoxOn(opt_snake_hunter) and Standard_SnakeHunter_Use() Spell(snake_hunter)
					if not CheckBoxOn(opt_eagle_aspect) and Standard_AspectOfTheEagle_Use() Spell(aspect_of_the_eagle)
					if not CheckBoxOn(opt_spitting_cobra) and Standard_SpittingCobra_Use() Spell(spitting_cobra_survival)
					if not CheckBoxOn(opt_steel_trap) and Standard_SteelTrap_Use() Spell(steel_trap_survival)
				}
				
				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_prolonged_power)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_aspect_turtle) and CD_AspectOfTheTurtle_Use() Spell(aspect_of_the_turtle)

				# Standard Abilties
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

		OvaleScripts:RegisterScript("HUNTER", "survival", name, desc, code, "script");
	end
end
