local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_deathknight_unholy";
		local desc = "LunaEclipse: Unholy Death Knight";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DEATHKNIGHT_UNHOLY,
			ScriptAuthor = "LunaEclipse",
			ScriptCredits = "Crystal",
			GuideAuthor = "Tegu",
			GuideLink = "http://www.icy-veins.com/wow/unholy-death-knight-pve-dps-guide",
			WoWVersion = 70200,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Dark Arbiter"] = "2231021",
			["Soul Reaper"] = "2231023",
			["Easy Mode"] = "3221033",
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
					OPT_DND = {
						type = "toggle",
						name = BINDING_NAME_OPT_DND,
						desc = functionsConfiguration:getAOETooltip("Death and Decay"),
						arg = "OPT_DND",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_EPIDEMIC = {
						type = "toggle",
						name = BINDING_NAME_OPT_EPIDEMIC,
						desc = functionsConfiguration:getAOETooltip("Epidemic"),
						arg = "OPT_EPIDEMIC",
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
					OPT_APOCALYPSE = {
						type = "toggle",
						name = BINDING_NAME_OPT_APOCALYPSE,
						desc = functionsConfiguration:getCooldownTooltip("Apocalypse"),
						arg = "OPT_APOCALYPSE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_ARMY_OF_THE_DEAD = {
						type = "toggle",
						name = BINDING_NAME_OPT_ARMY_OF_THE_DEAD,
						desc = functionsConfiguration:getCooldownTooltip("Army of the Dead", "CD"),
						arg = "OPT_ARMY_OF_THE_DEAD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 20,
					},
					OPT_BLIGHTED_RUNE_WEAPON = {
						type = "toggle",
						name = BINDING_NAME_OPT_BLIGHTED_RUNE_WEAPON,
						desc = functionsConfiguration:getCooldownTooltip("Blighted Rune Weapon"),
						arg = "OPT_BLIGHTED_RUNE_WEAPON",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 30,
					},
					OPT_GARGOYLE = {
						type = "toggle",
						name = BINDING_NAME_OPT_GARGOYLE,
						desc = functionsConfiguration:getCooldownTooltip("Gargoyle and Dark Arbiter", "CD"),
						arg = "OPT_GARGOYLE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_DARK_TRANSFORMATION = {
						type = "toggle",
						name = BINDING_NAME_OPT_DARK_TRANSFORMATION,
						desc = functionsConfiguration:getCooldownTooltip("Dark Transformation"),
						arg = "OPT_DARK_TRANSFORMATION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 50,
					},
					OPT_SOUL_REAPER = {
						type = "toggle",
						name = BINDING_NAME_OPT_SOUL_REAPER,
						desc = functionsConfiguration:getCooldownTooltip("Soul Reaper"),
						arg = "OPT_SOUL_REAPER",
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
					OPT_ANTI_MAGIC_SHELL = {
						type = "toggle",
						name = BINDING_NAME_OPT_ANTI_MAGIC_SHELL,
						desc = functionsConfiguration:getDefensiveTooltip("Anti-Magic Shell", "ShortCD", "40%"),
						arg = "OPT_ANTI_MAGIC_SHELL",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_CORPSE_SHIELD = {
						type = "toggle",
						name = BINDING_NAME_OPT_CORPSE_SHIELD,
						desc = functionsConfiguration:getDefensiveTooltip("Corpse Shield", "ShortCD", "40%"),
						arg = "OPT_CORPSE_SHIELD",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_ICEBOUND_FORTITUDE = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICEBOUND_FORTITUDE,
						desc = functionsConfiguration:getDefensiveTooltip("Icebound Fortitude", "CD", "40%"),
						arg = "OPT_ICEBOUND_FORTITUDE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 30,
					},
					OPT_DEATH_STRIKE_SUCCOR = {
						type = "toggle",
						name = BINDING_NAME_OPT_DEATH_STRIKE_SUCCOR,
						desc = functionsConfiguration:getDefensiveTooltip("Death Strike", "ShortCD", "40%", "Dark Succor"),
						arg = "OPT_DEATH_STRIKE_SUCCOR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
						order = 40,
					},
				},
			},
			setttingsSpecial = {
				type = "group",
				name = BINDING_HEADER_SPECIAL,
				inline = true,
				order = 60,
				args = {
					unholyDK_hiddenskin = {
						type = "toggle",
						name = "Track spawn for Unholy DK Hidden Artifact Skin.",
						desc = "Will display a personal raid warning and play a sound if the special ghoul spawns required for the Unholy DK hidden artifact skin.",
						arg = "unholyDK_hiddenskin",
						get = "getClassValue",
						set = "setClassValue",
						width = "full",
						order = 10,
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
			Define(ebon_fever_talent 3)
			Define(epidemic_talent 4)
			Define(blighted_rune_weapon_talent 6)
			Define(castigator_talent 8)
			Define(clawing_shadows_talent 9)
			Define(asphyxiate_talent 11)
			Define(corpse_shield_talent 14)
			Define(shadow_infusion_talent 16)
			Define(necrosis_talent 17)
			Define(dark_arbiter_talent 19)
			Define(defile_talent 20)
			Define(soul_reaper_talent 21)

			# Spells
			Define(blinding_sleet 207167)
				SpellInfo(blinding_sleet cd=60 gcd=1.5)
			Define(corpse_shield 207319)
				SpellInfo(corpse_shield cd=60 gcd=0 offgcd=1)
				SpellAddBuff(corpse_shield corpse_shield_buff=1)
			
			# Buffs
			Define(corpse_shield_buff 207319)
				SpellInfo(scourge_of_worlds_buff duration=10)
			Define(crazed_monstrosity_buff 187981)
				SpellInfo(crazed_monstrosity_buff duration=30)
			Define(death_and_decay_buff 188290)
			Define(defile_buff 188290)
			Define(scourge_of_worlds_buff 191748)
				SpellInfo(scourge_of_worlds_buff duration=6)
			Define(soul_reaper_unholy_buff 215711)
				SpellInfo(soul_reaper_unholy_buff duration=15 max_stacks=3)

			# Buffs Spell Lists
			SpellList(pet_dark_transformation_buff dark_transformation_buff crazed_monstrosity_buff)

			# Aritfact
			Define(apocalypse 220143)
				SpellInfo(apocalypse cd=90)

			# Summoned Undead
			# Fake creatureID for creature_apocalypse to seperate Army of the Dead Ghouls from Apocalypse Ghouls
			Define(creature_apocalypse 999999)
			Define(creature_army_of_the_dead 24207)
			Define(creature_dark_arbiter 100876)
			Define(creature_gargoyle 27829)
			Define(creature_shambling_horror 97055)

			# Checkboxes
			AddCheckBox(opt_dnd "AOE: Death and Decay" default)
			AddCheckBox(opt_epidemic "AOE CD: Epidemic" deault)
			AddCheckBox(opt_apocalypse "Cooldown: Apocalypse" default)
			AddCheckBox(opt_army_of_the_dead "Cooldown: Army of the Dead" default)
			AddCheckBox(opt_blighted_rune_weapon "Cooldown: Blighted Rune Weapon" default)
			AddCheckBox(opt_dark_transformation "Cooldown: Dark Transformation" default)
			AddCheckBox(opt_gargoyle "Cooldown: Gargoyle" default)
			AddCheckBox(opt_soul_reaper "Cooldown: Soul Reaper" default)
			AddCheckBox(opt_corpse_shield "Defensive: Corpse Shield" default)
			AddCheckBox(opt_anti_magic_shell "Defensive: Anti-Magic Shell")
			AddCheckBox(opt_icebound_fortitude "Defensive: Icebound Fortitude")
			AddCheckBox(opt_death_strike_succor "Heal: Death Strike (Dark Succor)")

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
						if target.RangeCheck(asphyxiate) Spell(asphyxiate)
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

			AddFunction ShortCD_CorpseShield_Use
			{
					Talent(corpse_shield_talent)
				and not SpellCooldown(corpse_shield)
				and pet.Present()
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
				and not target.RangeCheck(festering_strike)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Summon Pet if not active
				if pet.IsDead() or not pet.Present() Spell(raise_dead)

				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))

				# Short Cooldown Spells
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_DarkArbiter() Spell(dark_transformation)
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_DarkArbiter_NoShadowInfusion() Spell(dark_transformation)
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_DarkArbiter_ShadowInfusion() Spell(dark_transformation)
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_DarkArbiter_Dying() Spell(dark_transformation)
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_Gargoyle() Spell(dark_transformation)
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_Gargoyle_NoShadowInfusion() Spell(dark_transformation)
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_Gargoyle_ShadowInfusion() Spell(dark_transformation)
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_Gargoyle_Dying() Spell(dark_transformation)				
				if not CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use() Spell(dark_transformation)
				if not CheckBoxOn(opt_blighted_rune_weapon) and Main_BlightedRuneWeapon_Use() Spell(blighted_rune_weapon)

				# Dark Arbiter Rotation
				if Rotation_DarkArbiter_Use()
				{
					if not CheckBoxOn(opt_apocalypse) and DarkArbiter_Apocalypse_Use() Spell(apocalypse)
				}
				
				# Generic Rotations
				if not Rotation_DarkArbiter_Use()
				{
					if not CheckBoxOn(opt_soul_reaper) and Generic_SoulReaper_Use_Apocalypse() Spell(soul_reaper_unholy)
					if not CheckBoxOn(opt_apocalypse) and Generic_Apocalypse_Use() Spell(apocalypse)
					if not CheckBoxOn(opt_soul_reaper) and Generic_SoulReaper_Use() Spell(soul_reaper_unholy)
					if not CheckBoxOn(opt_dnd) and Generic_Defile_Use() Spell(defile)
				}

				# Perform the AOE rotation when fighting multiple enemies
				if Rotation_AOE_Use()
				{
					if not CheckBoxOn(opt_dnd) and AOE_DeathAndDecay_Use() Spell(death_and_decay)
					if not CheckBoxOn(opt_epidemic) and AOE_Epidemic_Use() Spell(epidemic)
					if not CheckBoxOn(opt_epidemic) and AOE_Epidemic_Use_Cleave() Spell(epidemic)
				}

				# Healing and Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_death_strike_succor) and ShortCD_DeathStrike_Use_Succor() Spell(death_strike)
				if CheckBoxOn(opt_anti_magic_shell) and ShortCD_AntiMagicShell_Use() Spell(antimagic_shell)
				if CheckBoxOn(opt_corpse_shield) and ShortCD_CorpseShield_Use() Spell(corpse_shield)
			}

			AddFunction ShortCD_Precombat
			{
				# Summon Pet if not active
				if pet.IsDead() or not pet.Present() Spell(raise_dead)

				# Show get in Melee Range
				if ShortCD_MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}

			###
			### AOE Rotation - Functions
			###
			AddFunction AOE_ClawingShadows_Use
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and Enemies() >= 2
				and {
							BuffPresent(death_and_decay_buff)
						 or BuffPresent(defile_buff)
					}
				and Rune() >= 1
			}

			AddFunction AOE_DeathAndDecay_Use
			{
					not Talent(defile_talent)
				and not SpellCooldown(death_and_decay)
				and Enemies() >= 2
				and Rune() >= 1
			}

			AddFunction AOE_Epidemic_Use
			{
					Talent(epidemic_talent)
				and SpellCharges(epidemic) >= 1
				and Enemies() > 4
				and Rune() >= 1
			}

			AddFunction AOE_Epidemic_Use_Cleave
			{
					Talent(epidemic_talent)
				and SpellCharges(epidemic) >= 1
				and Enemies() > 2
				and Rune() >= 1
			}

			AddFunction AOE_ScourgeStrike_Use
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and Enemies() >= 2
				and {
							BuffPresent(death_and_decay_buff)
						 or BuffPresent(defile_buff)
					}
				and Rune() >= 1
			}

			###
			### AOE Rotation - Usage
			###
			AddFunction Rotation_AOE_Use
			{
					not Rotation_DarkArbiter_Use()
				and Enemies() >= 2
			}

			###
			### AOE Rotation
			###
			AddFunction Rotation_AOE
			{
				if CheckBoxOn(opt_dnd) and AOE_DeathAndDecay_Use() Spell(death_and_decay)
				if CheckBoxOn(opt_epidemic) and AOE_Epidemic_Use() Spell(epidemic)
				if AOE_ScourgeStrike_Use() Spell(scourge_strike)
				if AOE_ClawingShadows_Use() Spell(clawing_shadows)
				if CheckBoxOn(opt_epidemic) and AOE_Epidemic_Use_Cleave() Spell(epidemic)
			}

			###
			### Castigator Rotation - Functions
			###
			AddFunction Castigator_DeathCoil_Use
			{
					not SpellCooldown(death_coil)
				and not Talent(shadow_infusion_talent)
				and not Talent(dark_arbiter_talent)
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Castigator_DeathCoil_Use_DarkArbiter
			{
					not SpellCooldown(death_coil)
				and Talent(dark_arbiter_talent)
				and SpellCooldown(dark_arbiter) > 15
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Castigator_DeathCoil_Use_Necrosis
			{
					not SpellCooldown(death_coil)
				and not BuffPresent(necrosis_buff)
				and Talent(necrosis_talent)
				and Rune() <= 3
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Castigator_DeathCoil_Use_ShadowInfusion
			{
					not SpellCooldown(death_coil)
				and Talent(shadow_infusion_talent)
				and not Talent(dark_arbiter_talent)
				and not pet.BuffPresent(dark_transformation_buff)
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Castigator_DeathCoil_Use_ShadowInfusion_DarkArbiter
			{
					not SpellCooldown(death_coil)
				and Talent(shadow_infusion_talent)
				and Talent(dark_arbiter_talent)
				and not pet.BuffPresent(dark_transformation_buff)
				and SpellCooldown(dark_arbiter) > 15
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Castigator_FesteringStrike_Use
			{
					not SpellCooldown(festering_strike)
				and target.DebuffStacks(festering_wound_debuff) <= 4
				and RunicPowerDeficit() > 23
				and Rune() >= 2
			}

			AddFunction Castigator_ScourgeStrike_Use
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and Rune() >= 2
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 23
			}

			AddFunction Castigator_ScourgeStrike_Use_Necrosis
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and BuffPresent(necrosis_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 23
				and Rune() >= 1
			}

			AddFunction Castigator_ScourgeStrike_Use_UnholyStrength
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and BuffPresent(unholy_strength_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 23
				and Rune() >= 1
			}

			###
			### Castogator Rotation - Usage
			###
			AddFunction Rotation_Castigator_Use
			{
					not Rotation_DarkArbiter_Use()
				and Talent(castigator_talent)
				and not LegendaryEquipped(the_instructors_fourth_lesson)
			}

			###
			### Castogator Rotation
			###
			AddFunction Rotation_Castigator
			{
				if Castigator_FesteringStrike_Use() Spell(festering_strike)
				if Castigator_DeathCoil_Use_Necrosis() Spell(death_coil)
				if Castigator_ScourgeStrike_Use_Necrosis() Spell(scourge_strike)
				if Castigator_ScourgeStrike_Use_UnholyStrength() Spell(scourge_strike)
				if Castigator_ScourgeStrike_Use() Spell(scourge_strike)
				if Castigator_DeathCoil_Use_ShadowInfusion_DarkArbiter() Spell(death_coil)
				if Castigator_DeathCoil_Use_ShadowInfusion() Spell(death_coil)
				if Castigator_DeathCoil_Use_DarkArbiter() Spell(death_coil)
				if Castigator_DeathCoil_Use() Spell(death_coil)
			}

			###
			### Dark Arbiter - Functions
			###
			AddFunction DarkArbiter_Apocalypse_Use
			{
					SpellKnown(apocalypse)
				and not SpellCooldown(apocalypse)
				and target.DebuffStacks(festering_wound_debuff) == 8
			}

			AddFunction DarkArbiter_ClawingShadows_Use
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and target.DebuffPresent(festering_wound_debuff)
				and Rune() >= 1
			}

			AddFunction DarkArbiter_DeathCoil_Use
			{
					not SpellCooldown(death_coil)
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction DarkArbiter_FesteringStrike_Use
			{
					not SpellCooldown(festering_strike)
				and target.DebuffStacks(festering_wound_debuff) <= 3
				and Rune() >= 2
			}

			AddFunction DarkArbiter_FesteringStrike_Use_Apocalypse
			{
					not SpellCooldown(festering_strike)
				and target.DebuffStacks(festering_wound_debuff) < 8
				and {
							SpellKnown(apocalypse)
						and SpellCooldown(apocalypse) < 5
					}
				and Rune() >= 2
			}

			AddFunction DarkArbiter_ScourgeStrike_Use
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and target.DebuffPresent(festering_wound_debuff)
				and Rune() >= 1
			}

			###
			### Dark Arbiter Rotation - Usage
			###
			AddFunction Rotation_DarkArbiter_Use
			{
					Talent(dark_arbiter_talent)
				and UndeadActive(creature_dark_arbiter)
			}

			###
			### Dark Arbiter Rotation
			###
			AddFunction Rotation_DarkArbiter
			{
				if DarkArbiter_DeathCoil_Use() Spell(death_coil)
				if CheckBoxOn(opt_apocalypse) and DarkArbiter_Apocalypse_Use() Spell(apocalypse)
				if DarkArbiter_FesteringStrike_Use_Apocalypse() Spell(festering_strike)

				# Use the AOE rotation if fighting multiple enemies	
				if Enemies() >= 2 Rotation_AOE()

				if DarkArbiter_FesteringStrike_Use() Spell(festering_strike)
				if DarkArbiter_ScourgeStrike_Use() Spell(scourge_strike)
				if DarkArbiter_ClawingShadows_Use() Spell(clawing_shadows)
			}

			###
			### Generic Rotation - Functions
			###
			AddFunction Generic_Apocalypse_Use
			{
					SpellKnown(apocalypse)
				and not SpellCooldown(apocalypse)
				and target.DebuffStacks(festering_wound_debuff) >= 6
			}

			AddFunction Generic_ClawingShadows_Use_SoulReaper
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and target.DebuffPresent(soul_reaper_unholy_debuff)
				and target.DebuffStacks(festering_wound_debuff) >= 1
				and Rune() >= 1
			}

			AddFunction Generic_DarkArbiter_Use
			{
					Talent(dark_arbiter_talent)
				and not SpellCooldown(dark_arbiter)
				and not LegendaryEquipped(taktheritrixs_shoulderpads)
				and RunicPowerDeficit() < 30
			}

			AddFunction Generic_DarkArbiter_Use_TaktheritrixsShoulderpads
			{
					Talent(dark_arbiter_talent)
				and not SpellCooldown(dark_arbiter)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and RunicPowerDeficit() < 30
				and SpellCooldown(dark_transformation) < 2
			}

			AddFunction Generic_DeathCoil_Use_RunicPower
			{
					not SpellCooldown(death_coil)
				and RunicPowerDeficit() < 10
			}

			AddFunction Generic_DeathCoil_Use_SuddenDoom
			{
					not SpellCooldown(death_coil)
				and not Talent(dark_arbiter_talent)
				and BuffPresent(sudden_doom_buff)
				and not BuffPresent(necrosis_buff)
				and Rune() <= 3
			}

			AddFunction Generic_DeathCoil_Use_SuddenDoom_DarkArbiter
			{
					not SpellCooldown(death_coil)
				and Talent(dark_arbiter_talent)
				and BuffPresent(sudden_doom_buff)
				and SpellCooldown(dark_arbiter) > 5
				and Rune() <= 3
			}

			AddFunction Generic_Defile_Use
			{
					Talent(defile_talent)
				and not SpellCooldown(defile)
				and Rune() >= 1
			}

			AddFunction Generic_FesteringStrike_Use_Apocalypse
			{
					not SpellCooldown(festering_strike)
				and target.DebuffStacks(festering_wound_debuff) < 6
				and {
							SpellKnown(apocalypse)
						and SpellCooldown(apocalypse) <= 6
					}
				and Rune() >= 2
			}

			AddFunction Generic_FesteringStrike_Use_SoulReaper
			{
					not SpellCooldown(festering_strike)
				and target.DebuffPresent(soul_reaper_unholy_debuff)
				and not target.DebuffPresent(festering_wound_debuff)
				and Rune() >= 2
			}

			AddFunction Generic_Gargoyle_Use
			{
					not Talent(dark_arbiter_talent)
				and not SpellCooldown(summon_gargoyle)
				and not LegendaryEquipped(taktheritrixs_shoulderpads)
				and Rune() <= 3
			}

			AddFunction Generic_Gargoyle_Use_TaktheritrixsShoulderpads
			{
					not Talent(dark_arbiter_talent)
				and not SpellCooldown(summon_gargoyle)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and SpellCooldown(dark_transformation) < 10
				and Rune() <= 3
			}

			AddFunction Generic_ScourgeStrike_Use_SoulReaper
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and target.DebuffPresent(soul_reaper_unholy_debuff)
				and target.DebuffStacks(festering_wound_debuff) >= 1
				and Rune() >= 1
			}

			AddFunction Generic_SoulReaper_Use
			{
					Talent(soul_reaper_talent)
				and not SpellCooldown(soul_reaper_unholy)
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and Rune() >= 1
			}

			AddFunction Generic_SoulReaper_Use_Apocalypse
			{
					Talent(soul_reaper_talent)
				and not SpellCooldown(soul_reaper_unholy)
				and target.DebuffStacks(festering_wound_debuff) >= 6
				and {
							SpellKnown(apocalypse)
						and SpellCooldown(apocalypse) < 4
					}
				and Rune() >= 1
			}

			###
			### Generic Rotation
			###
			AddFunction Rotation_Generic
			{
				if CheckBoxOn(opt_gargoyle) and Generic_DarkArbiter_Use() Spell(dark_arbiter)
				if CheckBoxOn(opt_gargoyle) and Generic_DarkArbiter_Use_TaktheritrixsShoulderpads() Spell(dark_arbiter)
				if CheckBoxOn(opt_gargoyle) and Generic_Gargoyle_Use() Spell(summon_gargoyle)
				if CheckBoxOn(opt_gargoyle) and Generic_Gargoyle_Use_TaktheritrixsShoulderpads() Spell(summon_gargoyle)
				if CheckBoxOn(opt_soul_reaper) and Generic_SoulReaper_Use_Apocalypse() Spell(soul_reaper_unholy)
				if CheckBoxOn(opt_apocalypse) and Generic_Apocalypse_Use() Spell(apocalypse)
				if Generic_DeathCoil_Use_RunicPower() Spell(death_coil)
				if Generic_DeathCoil_Use_SuddenDoom() Spell(death_coil)
				if Generic_DeathCoil_Use_SuddenDoom_DarkArbiter() Spell(death_coil)
				if Generic_FesteringStrike_Use_Apocalypse() Spell(festering_strike)
				if CheckBoxOn(opt_soul_reaper) and Generic_SoulReaper_Use() Spell(soul_reaper_unholy)
				if Generic_FesteringStrike_Use_SoulReaper() Spell(festering_strike)
				if Generic_ScourgeStrike_Use_SoulReaper() Spell(scourge_strike)
				if Generic_ClawingShadows_Use_SoulReaper() Spell(clawing_shadows)
				if CheckBoxOn(opt_dnd) and Generic_Defile_Use() Spell(defile)
			}

			###
			### Instructor's Fourth Lesson - Functions
			###
			AddFunction InstructorsFourthLesson_ClawingShadows_Use
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and Rune() >= 2
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 9
			}

			AddFunction InstructorsFourthLesson_ClawingShadows_Use_Necrosis
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and BuffPresent(necrosis_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 9
				and Rune() >= 1
			}

			AddFunction InstructorsFourthLessonClawingShadows_Use_UnholyStrength
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and BuffPresent(unholy_strength_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 9
				and Rune() >= 1
			}

			AddFunction InstructorsFourthLesson_DeathCoil_Use_DarkArbiter
			{
					not SpellCooldown(death_coil)
				and Talent(dark_arbiter_talent)
				and SpellCooldown(dark_arbiter) > 10
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction InstructorsFourthLesson_DeathCoil_Use_DarkArbiter_ShadowInfusion
			{
					not SpellCooldown(death_coil)
				and Talent(shadow_infusion_talent)
				and Talent(dark_arbiter_talent)
				and not pet.BuffPresent(dark_transformation_buff)
				and SpellCooldown(dark_arbiter) > 10
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction InstructorsFourthLesson_DeathCoil_Use_Gargoyle
			{
					not SpellCooldown(death_coil)
				and not Talent(shadow_infusion_talent)
				and not Talent(dark_arbiter_talent)
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction InstructorsFourthLesson_DeathCoil_Use_Gaygoyle_ShadowInfusion
			{
					not SpellCooldown(death_coil)
				and Talent(shadow_infusion_talent)
				and not Talent(dark_arbiter_talent)
				and not pet.BuffPresent(dark_transformation_buff)
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction InstructorsFourthLesson_DeathCoil_Use_Necrosis
			{
					not SpellCooldown(death_coil)
				and not BuffPresent(necrosis_buff)
				and Talent(necrosis_talent)
				and Rune() <= 3
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction InstructorsFourthLesson_FesteringStrike_Use
			{
					not SpellCooldown(festering_strike)
				and target.DebuffStacks(festering_wound_debuff) <= 2
				and RunicPowerDeficit() > 5
				and Rune() >= 2
			}

			AddFunction InstructorsFourthLesson_ScourgeStrike_Use
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and Rune() >= 2
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 9
			}

			AddFunction InstructorsFourthLesson_ScourgeStrike_Use_Necrosis
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and BuffPresent(necrosis_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 9
				and Rune() >= 1
			}

			AddFunction InstructorsFourthLesson_ScourgeStrike_Use_UnholyStrength
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and BuffPresent(unholy_strength_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 3
				and RunicPowerDeficit() > 9
				and Rune() >= 1
			}

			###
			### Instructor's Fourth Lesson Rotation - Usage
			###
			AddFunction Rotation_InstructorsFourthLesson_Use
			{
					not Rotation_DarkArbiter_Use()
				and LegendaryEquipped(the_instructors_fourth_lesson)
			}

			###
			### Instructor's Fourth Lesson Rotation
			###
			AddFunction Rotation_InstructorsFourthLesson
			{
				if InstructorsFourthLesson_FesteringStrike_Use() Spell(festering_strike)
				if InstructorsFourthLesson_DeathCoil_Use_Necrosis() Spell(death_coil)
				if InstructorsFourthLesson_ScourgeStrike_Use_Necrosis() Spell(scourge_strike)
				if InstructorsFourthLesson_ClawingShadows_Use_Necrosis() Spell(clawing_shadows)
				if InstructorsFourthLesson_ScourgeStrike_Use_UnholyStrength() Spell(scourge_strike)
				if InstructorsFourthLessonClawingShadows_Use_UnholyStrength() Spell(clawing_shadows)
				if InstructorsFourthLesson_ScourgeStrike_Use() Spell(scourge_strike)
				if InstructorsFourthLesson_ClawingShadows_Use() Spell(clawing_shadows)
				if InstructorsFourthLesson_DeathCoil_Use_DarkArbiter_ShadowInfusion() Spell(death_coil)
				if InstructorsFourthLesson_DeathCoil_Use_Gaygoyle_ShadowInfusion() Spell(death_coil)
				if InstructorsFourthLesson_DeathCoil_Use_DarkArbiter() Spell(death_coil)
				if InstructorsFourthLesson_DeathCoil_Use_Gargoyle() Spell(death_coil)
			}

			###
			### Standard Rotation - Functions
			###
			AddFunction Standard_ClawingShadows_Use
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and Rune() >= 2
				and target.DebuffStacks(festering_wound_debuff) >= 1
				and RunicPowerDeficit() > 9
			}

			AddFunction Standard_ClawingShadows_Use_Necrosis
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and BuffPresent(necrosis_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 1
				and RunicPowerDeficit() > 9
				and Rune() >= 1
			}

			AddFunction Standard_ClawingShadows_Use_UnholyStrength
			{
					Talent(clawing_shadows_talent)
				and not SpellCooldown(clawing_shadows)
				and BuffPresent(unholy_strength_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 1
				and RunicPowerDeficit() > 9
				and Rune() >= 1
			}

			AddFunction Standard_DeathCoil_Use_DarkArbiter
			{
					not SpellCooldown(death_coil)
				and Talent(dark_arbiter_talent)
				and SpellCooldown(dark_arbiter) > 10
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Standard_DeathCoil_Use_DarkArbiter_ShadowInfusion
			{
					not SpellCooldown(death_coil)
				and Talent(shadow_infusion_talent)
				and Talent(dark_arbiter_talent)
				and not pet.BuffPresent(dark_transformation_buff)
				and SpellCooldown(dark_arbiter) > 10
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Standard_DeathCoil_Use_Gargoyle
			{
					not SpellCooldown(death_coil)
				and not Talent(shadow_infusion_talent)
				and not Talent(dark_arbiter_talent)
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Standard_DeathCoil_Use_Gaygoyle_ShadowInfusion
			{
					not SpellCooldown(death_coil)
				and Talent(shadow_infusion_talent)
				and not Talent(dark_arbiter_talent)
				and not pet.BuffPresent(dark_transformation_buff)
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Standard_DeathCoil_Use_Necrosis
			{
					not SpellCooldown(death_coil)
				and not BuffPresent(necrosis_buff)
				and Talent(necrosis_talent)
				and Rune() <= 3
				and {
							BuffPresent(sudden_doom_buff)
						 or RunicPower() >= 45
					}
			}

			AddFunction Standard_FesteringStrike_Use
			{
					not SpellCooldown(festering_strike)
				and target.DebuffStacks(festering_wound_debuff) <= 2
				and RunicPowerDeficit() > 5
				and Rune() >= 2
			}

			AddFunction Standard_ScourgeStrike_Use
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and Rune() >= 2
				and target.DebuffStacks(festering_wound_debuff) >= 1
				and RunicPowerDeficit() > 9
			}

			AddFunction Standard_ScourgeStrike_Use_Necrosis
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and BuffPresent(necrosis_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 1
				and RunicPowerDeficit() > 9
				and Rune() >= 1
			}

			AddFunction Standard_ScourgeStrike_Use_UnholyStrength
			{
					not Talent(clawing_shadows_talent)
				and not SpellCooldown(scourge_strike)
				and BuffPresent(unholy_strength_buff)
				and target.DebuffStacks(festering_wound_debuff) >= 1
				and RunicPowerDeficit() > 9
				and Rune() >= 1
			}

			###
			### Standard Rotation - Usage
			###
			AddFunction Rotation_Standard_Use
			{
					not Rotation_DarkArbiter_Use()
				and not Talent(castigator_talent)
				and not LegendaryEquipped(the_instructors_fourth_lesson)
			}

			###
			### Standard Rotation
			###
			AddFunction Rotation_Standard
			{
				if Standard_FesteringStrike_Use() Spell(festering_strike)
				if Standard_DeathCoil_Use_Necrosis() Spell(death_coil)
				if Standard_ScourgeStrike_Use_Necrosis() Spell(scourge_strike)
				if Standard_ClawingShadows_Use_Necrosis() Spell(clawing_shadows)
				if Standard_ScourgeStrike_Use_UnholyStrength() Spell(scourge_strike)
				if Standard_ClawingShadows_Use_UnholyStrength() Spell(clawing_shadows)
				if Standard_ScourgeStrike_Use() Spell(scourge_strike)
				if Standard_ClawingShadows_Use() Spell(clawing_shadows)
				if Standard_DeathCoil_Use_DarkArbiter_ShadowInfusion() Spell(death_coil)
				if Standard_DeathCoil_Use_Gaygoyle_ShadowInfusion() Spell(death_coil)
				if Standard_DeathCoil_Use_DarkArbiter() Spell(death_coil)
				if Standard_DeathCoil_Use_Gargoyle() Spell(death_coil)
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_BlightedRuneWeapon_Use
			{
					Talent(blighted_rune_weapon_talent)
				and not SpellCooldown(blighted_rune_weapon)
				and Rune() <= 3
			}

			AddFunction Main_DarkTransformation_Use
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and not LegendaryEquipped(taktheritrixs_shoulderpads)
				and Rune() <= 3
			}

			AddFunction Main_DarkTransformation_Use_DarkArbiter
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and UndeadActive(creature_dark_arbiter)
			}

			AddFunction Main_DarkTransformation_Use_DarkArbiter_Dying
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and target.TimeToDie() < SpellCooldown(dark_arbiter) - 8
			}

			AddFunction Main_DarkTransformation_Use_DarkArbiter_NoShadowInfusion
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and not Talent(shadow_infusion_talent)
				and SpellCooldown(dark_arbiter) > 55
			}

			AddFunction Main_DarkTransformation_Use_DarkArbiter_ShadowInfusion
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and Talent(shadow_infusion_talent)
				and SpellCooldown(dark_arbiter) > 35
			}

			AddFunction Main_DarkTransformation_Use_Gargoyle
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and UndeadActive(creature_gargoyle)
			}

			AddFunction Main_DarkTransformation_Use_Gargoyle_Dying
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and target.TimeToDie() < SpellCooldown(summon_gargoyle) - 8
			}

			AddFunction Main_DarkTransformation_Use_Gargoyle_NoShadowInfusion
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and not Talent(shadow_infusion_talent)
				and SpellCooldown(summon_gargoyle) > 55
			}

			AddFunction Main_DarkTransformation_Use_Gargoyle_ShadowInfusion
			{
					pet.Present()
				and not SpellCooldown(dark_transformation)
				and LegendaryEquipped(taktheritrixs_shoulderpads)
				and Talent(shadow_infusion_talent)
				and SpellCooldown(summon_gargoyle) > 35
			}

			AddFunction Main_DraughtOfSouls_Use
			{
					LegendaryEquipped(draught_of_souls)
			}

			AddFunction Main_Outbreak_Use
			{
					not SpellCooldown(outbreak)
				and not target.DebuffPresent(virulent_plague_debuff)
				and Rune() >= 1
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				if CheckBoxOn(opt_draught_of_souls) and Main_DraughtOfSouls_Use() Item(draught_of_souls)
				if Main_Outbreak_Use() Spell(outbreak)
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_DarkArbiter() Spell(dark_transformation)
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_DarkArbiter_NoShadowInfusion() Spell(dark_transformation)
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_DarkArbiter_ShadowInfusion() Spell(dark_transformation)
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_DarkArbiter_Dying() Spell(dark_transformation)
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_Gargoyle() Spell(dark_transformation)
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_Gargoyle_NoShadowInfusion() Spell(dark_transformation)
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_Gargoyle_ShadowInfusion() Spell(dark_transformation)
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use_Gargoyle_Dying() Spell(dark_transformation)				
				if CheckBoxOn(opt_dark_transformation) and Main_DarkTransformation_Use() Spell(dark_transformation)
				if CheckBoxOn(opt_blighted_rune_weapon) and Main_BlightedRuneWeapon_Use() Spell(blighted_rune_weapon)

				# Dark Arbiter Rotation
				if Rotation_DarkArbiter_Use() Rotation_DarkArbiter()

				# Generic Rotations
				if not Rotation_DarkArbiter_Use() Rotation_Generic()

				# Perform the AOE rotation when fighting multiple enemies
				if Rotation_AOE_Use() Rotation_AOE()
						
				# Perform the Instructors Fourth Lesson rotation if wearing the legendary
				if Rotation_InstructorsFourthLesson_Use() Rotation_InstructorsFourthLesson()
				
				# Perform the Castigator rotation if the talent is chosen
				if Rotation_Castigator_Use() Rotation_Castigator()

				# Perform Standard Single Target rotation if no other rotations to perform
				if Rotation_Standard_Use() Rotation_Standard()
			}

			AddFunction Main_Precombat
			{
				# Main_Precombat Spells
				if IsBossFight() and CheckBoxOn(opt_army_of_the_dead) Spell(army_of_the_dead)
				if Main_Outbreak_Use() Spell(outbreak)
			}

			###
			### CD Icon Rotations - Functions
			###
			AddFunction CD_ArcaneTorrent_Use
			{
					Race(BloodElf)
				and not SpellCooldown(arcane_torrent_runicpower)
				and RunicPowerDeficit() > 20
			}

			AddFunction CD_Berserking_Use
			{
					Race(Troll)
				and not SpellCooldown(berserking)
			}

			AddFunction CD_BloodFury_Use
			{
					Race(Orc)
				and not SpellCooldown(blood_fury_ap)
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
						and BuffPresent(unholy_strength_buff)
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

				# Cooldown Spells
				if not CheckBoxOn(opt_draught_of_souls) and Main_DraughtOfSouls_Use() Item(draught_of_souls)
				if not CheckBoxOn(opt_gargoyle) and Generic_DarkArbiter_Use() Spell(dark_arbiter)
				if not CheckBoxOn(opt_gargoyle) and Generic_DarkArbiter_Use_TaktheritrixsShoulderpads() Spell(dark_arbiter)
				if not CheckBoxOn(opt_gargoyle) and Generic_Gargoyle_Use() Spell(summon_gargoyle)
				if not CheckBoxOn(opt_gargoyle) and Generic_Gargoyle_Use_TaktheritrixsShoulderpads() Spell(summon_gargoyle)

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_prolonged_power)

				# Defensive Spells, only show if enabled.
				if CheckBoxOn(opt_icebound_fortitude) and CD_IceboundFortitude_Use() Spell(icebound_fortitude)

				# Standard Actions
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_runicpower)
				if CD_BloodFury_Use() Spell(blood_fury_ap)
				if CD_Berserking_Use() Spell(berserking)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Cooldown Spells
				Spell(army_of_the_dead)

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

		OvaleScripts:RegisterScript("DEATHKNIGHT", "unholy", name, desc, code, "script");
	end
end