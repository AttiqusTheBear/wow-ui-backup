local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "lunaeclipse_mage_arcane";
		local desc = "LunaEclipse: Arcane Mage";

		-- Store the information for the script.
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.MAGE_ARCANE,
			ScriptAuthor = "LunaEclipse",
			GuideAuthor = "Blixius",
			GuideLink = "http://www.icy-veins.com/wow/arcane-mage-pve-dps-guide",
			WoWVersion = 70200,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "2022131",
			["Raiding (AOE) / Dungeons / Mythic+"] = "2023131",
			["Solo / World Quests"] = "2031122",
			["Easy Mode"] = "2033131",
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
					OPT_ARCANE_EXPLOSION = {
						type = "toggle",
						name = BINDING_NAME_OPT_ARCANE_EXPLOSION,
						desc = functionsConfiguration:getAOETooltip("Arcane Explosion"),
						arg = "OPT_ARCANE_EXPLOSION",
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
					OPT_ARCANE_FAMILIAR = {
						type = "toggle",
						name = BINDING_NAME_OPT_ARCANE_FAMILIAR,
						desc = functionsConfiguration:getBuffTooltip("Arcane Familiar"),
						arg = "OPT_ARCANE_FAMILIAR",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						width = "double",
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
					OPT_ARCANE_ORB = {
						type = "toggle",
						name = BINDING_NAME_OPT_ARCANE_ORB,
						desc = functionsConfiguration:getCooldownTooltip("Arcane Orb"),
						arg = "OPT_ARCANE_ORB",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_ARCANE_POWER = {
						type = "toggle",
						name = BINDING_NAME_OPT_ARCANE_POWER,
						desc = functionsConfiguration:getCooldownTooltip("Arcane Power", "CD"),
						arg = "OPT_ARCANE_POWER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 20,
					},
					OPT_CHARGED_UP = {
						type = "toggle",
						name = BINDING_NAME_OPT_CHARGED_UP,
						desc = functionsConfiguration:getCooldownTooltip("Charged Up"),
						arg = "OPT_CHARGED_UP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 30,
					},
					OPT_EVOCATION = {
						type = "toggle",
						name = BINDING_NAME_OPT_EVOCATION,
						desc = functionsConfiguration:getCooldownTooltip("Evocation", "CD"),
						arg = "OPT_EVOCATION",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 40,
					},
					OPT_MARK_OF_ALUNETH = {
						type = "toggle",
						name = BINDING_NAME_OPT_MARK_OF_ALUNETH,
						desc = functionsConfiguration:getCooldownTooltip("Mark of Aluneth"),
						arg = "OPT_MARK_OF_ALUNETH",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 50,
					},
					OPT_MIRROR_IMAGE = {
						type = "toggle",
						name = BINDING_NAME_OPT_MIRROR_IMAGE,
						desc = functionsConfiguration:getCooldownTooltip("Mirror Image"),
						arg = "OPT_MIRROR_IMAGE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 60,
					},
					OPT_NETHER_TEMPEST = {
						type = "toggle",
						name = BINDING_NAME_OPT_NETHER_TEMPEST,
						desc = functionsConfiguration:getCooldownTooltip("Nether Tempest"),
						arg = "OPT_NETHER_TEMPEST",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 70,
					},
					OPT_PRESENCE_OF_MIND = {
						type = "toggle",
						name = BINDING_NAME_OPT_PRESENCE_OF_MIND,
						desc = functionsConfiguration:getCooldownTooltip("Presence of Mind"),
						arg = "OPT_PRESENCE_OF_MIND",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 80,
					},
					OPT_POWER_RUNE = {
						type = "toggle",
						name = BINDING_NAME_OPT_POWER_RUNE,
						desc = functionsConfiguration:getCooldownTooltip("Rune of Power"),
						arg = "OPT_POWER_RUNE",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 90,
					},
					OPT_SUPERNOVA = {
						type = "toggle",
						name = BINDING_NAME_OPT_SUPERNOVA,
						desc = functionsConfiguration:getCooldownTooltip("Supernova"),
						arg = "OPT_SUPERNOVA",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 100,
					},
					OPT_TIME_WARP = {
						type = "toggle",
						name = BINDING_NAME_OPT_TIME_WARP,
						desc = string.format("%s\n\n%s", functionsConfiguration:getCooldownTooltip("Time Warp", "CD"), "This is only applicable when using Shard of the Exodar legendary, and will only be recommended once at least half the group has the debuff."),
						arg = "OPT_TIME_WARP",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 110,
					},
				},
			},
			settingsDefensive = {
				type = "group",
				name = BINDING_HEADER_DEFENSIVE,
				inline = true,
				order = 40,
				args = {
					OPT_ICE_BARRIER = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICE_BARRIER,
						desc = functionsConfiguration:getDefensiveTooltip("Prismatic Barrier"),
						arg = "OPT_ICE_BARRIER",
						get = "getScriptCheckbox",
						set = "setScriptCheckbox",
						order = 10,
					},
					OPT_ICE_BLOCK = {
						type = "toggle",
						name = BINDING_NAME_OPT_ICE_BLOCK,
						desc = functionsConfiguration:getDefensiveTooltip("Ice Block", "CD", "40%"),
						arg = "OPT_ICE_BLOCK",
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
			Include(lunaeclipse_mage_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_arcane_explosion "AOE: Arcane Explosion" default)
			AddCheckBox(opt_arcane_familiar "Buff: Arcane Familiar" default)
			AddCheckBox(opt_arcane_orb "Cooldown: Arcane Orb" default)
			AddCheckBox(opt_arcane_power "Cooldown: Arcane Power" default)
			AddCheckBox(opt_charged_up "Cooldown: Charged Up" default)
			AddCheckBox(opt_evocation "Cooldown: Evocation" default)
			AddCheckBox(opt_mark_of_aluneth "Cooldown: Mark of Aluneth" default)
			AddCheckBox(opt_mirror_image "Cooldown: Mirror Image" default)
			AddCheckBox(opt_nether_tempest "Cooldown: Nether Tempest" default)
			AddCheckBox(opt_presence_of_mind "Cooldown: Presence of Mind" default)
			AddCheckBox(opt_power_rune "Cooldown: Rune of Power" default)
			AddCheckBox(opt_supernova "Cooldown: Supernova" default)
			AddCheckBox(opt_time_warp "Cooldown: Time Warp" default)
			AddCheckBox(opt_barrier_spells "Defensive: Barrier Spells" default)
			AddCheckBox(opt_ice_block "Defensive: Ice Block" default)

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting() and target.IsInterruptible()
				{
					if target.RangeCheck(counterspell) Spell(counterspell)
					if target.Distance() < 8 Spell(arcane_torrent_mana)

					if not target.IsRaidBoss()
					{
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
					}
				}
			}

			###
			### ShortCD Icon Rotations - Functions
			###
			AddFunction ShortCD_ArcaneFamiliar_Use
			{
					Talent(arcane_familiar_talent)
				and not BuffPresent(arcane_familiar_buff)
			}

			AddFunction ShortCD_PrismaticBarrier_Use
			{
					not SpellCooldown(prismatic_barrier)
				and Mana() >= ManaCost(prismatic_barrier)
				and not BuffPresent(prismatic_barrier_buff)
			}

			###
			### ShortCD Icon Rotations
			###
			AddFunction ShortCD
			{
				# Summon Arcane Familar if talented
				if CheckBoxOn(opt_arcane_familiar) and ShortCD_ArcaneFamiliar_Use() Spell(arcane_familiar)
			
				# Short CDs
				if not CheckBoxOn(opt_mirror_image) and Main_MirrorImage_Use() Spell(mirror_image)				
				if not CheckBoxOn(opt_mark_of_aluneth) and Main_MarkOfAluneth_Use() Spell(mark_of_aluneth)

				# Build Charges if less then 4 Charges of Arcane Power
				if Rotation_Build_Use()
				{
					if not CheckBoxOn(opt_charged_up) and Build_ChargedUp_Use() Spell(charged_up)
					if not CheckBoxOn(opt_arcane_orb) and Build_ArcaneOrb_Use() Spell(arcane_orb)
					if not CheckBoxOn(opt_arcane_explosion) and Build_ArcaneExplosion_Use() Spell(arcane_explosion)
				}

				# Cooldowns Rotation.
				if Rotation_Cooldowns_Use()
				{
					if not CheckBoxOn(opt_mark_of_aluneth) and Cooldowns_MarkOfAluneth_Use() Spell(mark_of_aluneth)
					if not CheckBoxOn(opt_nether_tempest) and Cooldowns_NetherTempest_Use() Spell(nether_tempest)
					if not CheckBoxOn(opt_power_rune) and Cooldowns_RuneOfPower_Use() Spell(rune_of_power)
				}

				# Rotation during Burn Phase
				if Rotation_Burn_Use() 
				{
					if not CheckBoxOn(opt_power_rune) and Burn_RuneOfPower_Use() Spell(rune_of_power)
					if not CheckBoxOn(opt_charged_up) and Burn_ChargedUp_Use() Spell(charged_up)
					if not CheckBoxOn(opt_nether_tempest) and Burn_NetherTempest_Use() Spell(nether_tempest)
					if not CheckBoxOn(opt_arcane_explosion) and Burn_ArcaneExplosion_Use_Dying() Spell(arcane_explosion)
					if not CheckBoxOn(opt_presence_of_mind) and Burn_PresenceOfMind_Use() Spell(presence_of_mind)
					if not CheckBoxOn(opt_arcane_explosion) and Burn_ArcaneExplosion_Use_ArcanePower() Spell(arcane_explosion)
					if not CheckBoxOn(opt_supernova) and Burn_Supernova_Use() Spell(supernova)
					if not CheckBoxOn(opt_arcane_explosion) and Burn_ArcaneExplosion_Use() Spell(arcane_explosion)
				}

				# Ring of Power rotation when not in Burn Phase
				if Rotation_RuneOfPower_Use()
				{
					if not CheckBoxOn(opt_nether_tempest) and RuneOfPower_NetherTempest_Use() Spell(nether_tempest)
					if not CheckBoxOn(opt_arcane_explosion) and RuneOfPower_ArcaneExplosion_Use() Spell(arcane_explosion)
				}

				# Conserve Rotation
				if Rotation_Conserve_Use()
				{
					if not CheckBoxOn(opt_nether_tempest) and Conserve_NetherTempest_Use() Spell(nether_tempest)
					if not CheckBoxOn(opt_supernova) and Conserve_Supernova_Use() Spell(supernova)
					if not CheckBoxOn(opt_arcane_explosion) and Conserve_ArcaneExplosion_Use_KiltRuneMaster() Spell(arcane_explosion)
					if not CheckBoxOn(opt_arcane_explosion) and Conserve_ArcaneExplosion_Use() Spell(arcane_explosion)
				}

				# Display Prismatic Barrier on ShortCD only if option is checked
				if CheckBoxOn(opt_barrier_spells) and ShortCD_PrismaticBarrier_Use() Spell(prismatic_barrier)
			}

			AddFunction ShortCD_Precombat
			{
				# Summon Arcane Familar if talented
				if CheckBoxOn(opt_arcane_familiar) and ShortCD_ArcaneFamiliar_Use() Spell(arcane_familiar)

				# Short Cooldown Spells
				if not CheckBoxOn(opt_mirror_image) and Main_MirrorImage_Use() Spell(mirror_image)				
			}

			###
			### Build Rotation - Functions
			###
			AddFunction Build_ArcaneBlast_Use
			{
					not SpellCooldown(arcane_blast)
				and {
							BuffPresent(rhonins_assaulting_armwraps_buff)
						 or Mana() > ManaCost(arcane_blast)
					}
				and target.RangeCheck(arcane_blast)
				and {
							not MovementCheck()
						 or BuffPresent(presence_of_mind_buff)
					}
			}

			AddFunction Build_ArcaneExplosion_Use
			{
					not SpellCooldown(arcane_explosion)
				and Mana() >= ManaCost(arcane_explosion)
				and Enemies() > 1
			}

			AddFunction Build_ArcaneMissiles_Use
			{
					not SpellCooldown(arcane_missiles)
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and target.RangeCheck(arcane_missiles)
				and BuffStacks(arcane_missiles_buff) == 3
			}

			AddFunction Build_ArcaneOrb_Use
			{
					Talent(arcane_orb_talent)
				and not SpellCooldown(arcane_orb)
				and Mana() >= ManaCost(arcane_orb)
			}

			AddFunction Build_ChargedUp_Use
			{
					Talent(charged_up_talent)
				and not SpellCooldown(charged_up)
				and ArcaneCharges() <= 1
				and {							
							BuffPresent(arcane_missiles_buff)
						 or SpellCooldown(arcane_barrage) < ExecuteTime(charged_up)
					}
			}

			###
			### Build Rotation - Usage
			###
			AddFunction Rotation_Build_Use
			{
					ArcaneCharges() < 4
			}

			###
			### Build Rotation
			###
			AddFunction Rotation_Build
			{
				if CheckBoxOn(opt_charged_up) and Build_ChargedUp_Use() Spell(charged_up)
				if Build_ArcaneMissiles_Use() Spell(arcane_missiles)
				if CheckBoxOn(opt_arcane_orb) and Build_ArcaneOrb_Use() Spell(arcane_orb)
				if CheckBoxOn(opt_arcane_explosion) and Build_ArcaneExplosion_Use() Spell(arcane_explosion)
				if Build_ArcaneBlast_Use() Spell(arcane_blast)
			}
			
			###
			### Burn Rotation - Functions
			###
			AddFunction Burn_ArcaneBarrage_Use
			{
					not SpellCooldown(arcane_barrage)
				and Mana() >= ManaCost(arcane_barrage)
				and target.RangeCheck(arcane_barrage)
				and Talent(charged_up_talent)
				and {
							LegendaryEquipped(mystic_kilt_of_the_rune_master)
						and not SpellCooldown(charged_up)
						and ManaPercent() < { 100 - { ArcaneCharges() * 0.03 } }
					}
			}

			AddFunction Burn_ArcaneBlast_Use
			{
					not SpellCooldown(arcane_blast)
				and {
							BuffPresent(rhonins_assaulting_armwraps_buff)
						 or Mana() > ManaCost(arcane_blast)
					}
				and target.RangeCheck(arcane_blast)
				and {
							not MovementCheck()
						 or BuffPresent(presence_of_mind_buff)
					}
			}

			AddFunction Burn_ArcaneBlast_Use_ArcanePower
			{				
					not SpellCooldown(arcane_blast)
				and {
							BuffPresent(rhonins_assaulting_armwraps_buff)
						 or Mana() > ManaCost(arcane_blast)
					}
				and target.RangeCheck(arcane_blast)
				and {
							not MovementCheck()
						 or BuffPresent(presence_of_mind_buff)
					}
				and { 
							BuffPresent(presence_of_mind_buff)
						 or BuffRemaining(arcane_power_buff) > CastTime(arcane_blast)
					}
			}

			AddFunction Burn_ArcaneBlast_Use_PresenceOfMind
			{				
					not SpellCooldown(arcane_blast)
				and {
							BuffPresent(rhonins_assaulting_armwraps_buff)
						 or Mana() > ManaCost(arcane_blast)
					}
				and target.RangeCheck(arcane_blast)
				and BuffPresent(presence_of_mind_buff)
				and RuneOfPowerBuff()
			}

			AddFunction Burn_ArcaneExplosion_Use
			{
					not SpellCooldown(arcane_explosion)
				and Mana() >= ManaCost(arcane_explosion)
				and Enemies() > 1
			}

			AddFunction Burn_ArcaneExplosion_Use_ArcanePower
			{
					not SpellCooldown(arcane_explosion)
				and Mana() >= ManaCost(arcane_explosion)
				and Enemies() > 1
				and BuffRemaining(arcane_power_buff) > CastTime(arcane_explosion)
			}

			AddFunction Burn_ArcaneExplosion_Use_Dying
			{				
					not SpellCooldown(arcane_explosion)
				and Mana() >= ManaCost(arcane_explosion)
				and Enemies() > 1
				and ManaPercent() / 10 * ExecuteTime(arcane_explosion) > target.TimeToDie()
			}

			AddFunction Burn_ArcaneMissiles_Use
			{
					not SpellCooldown(arcane_missiles)
				and target.RangeCheck(arcane_missiles)
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and BuffStacks(arcane_missiles_buff) > 1
			}

			AddFunction Burn_ArcaneMissiles_Use_FullStacks
			{
					not SpellCooldown(arcane_missiles)
				and target.RangeCheck(arcane_missiles)
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and BuffStacks(arcane_missiles_buff) == 3
			}

			AddFunction Burn_ArcaneMissiles_Use_Overpowered
			{
					not SpellCooldown(arcane_missiles)
				and target.RangeCheck(arcane_missiles)
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and BuffPresent(arcane_missiles_buff)
				and ManaPercent() > 10
				and {
							Talent(overpowered_talent)
						 or not BuffPresent(arcane_power_buff)
					}
			}

			AddFunction Burn_ChargedUp_Use
			{
					Talent(charged_up_talent)
				and not SpellCooldown(charged_up)
				and {
							LegendaryEquipped(mystic_kilt_of_the_rune_master)
						and ArcaneCharges() <= 1
					}
			}

			AddFunction Burn_NetherTempest_Use
			{
					Talent(nether_tempest_talent)
				and not SpellCooldown(nether_tempest)
				and Mana() >= ManaCost(nether_tempest)
				and target.RangeCheck(nether_tempest)
				and {
							target.DebuffRemaining(nether_tempest_debuff) <= 2
						 or not target.DebuffPresent(nether_tempest_debuff)
					}
			}

			AddFunction Burn_PresenceOfMind_Use
			{
					not SpellCooldown(presence_of_mind)
				and {
							not Talent(rune_of_power_talent)
						 or {
									RuneOfPowerActive()
								and RuneOfPowerTimeRemaining() <= 2 * ExecuteTime(arcane_blast)
							}
					}
			}

			AddFunction Burn_RuneOfPower_Use
			{
					Talent(rune_of_power_talent)
				and SpellCharges(rune_of_power) >= 1
				and not MovementCheck()
				and not PreviousGCDSpell(rune_of_power)
				and not RuneOfPowerBuff()
				and ManaPercent() > 45
				and not BuffPresent(arcane_power_buff)
			}

			AddFunction Burn_Supernova_Use
			{
					Talent(supernova_talent)
				and not SpellCooldown(supernova)
				and target.RangeCheck(supernova)
				and ManaPercent() < 100
			}

			###
			### Burn Rotation - Usage
			###
			AddFunction Rotation_Burn_Use
			{
					ArcaneBurnPhase()
			}

			###
			### Burn Rotation
			###
			AddFunction Rotation_Burn
			{
				if CheckBoxOn(opt_power_rune) and Burn_RuneOfPower_Use() Spell(rune_of_power)
				if CheckBoxOn(opt_charged_up) and Burn_ChargedUp_Use() Spell(charged_up)
				if Burn_ArcaneBlast_Use_PresenceOfMind() Spell(arcane_blast)
				if Burn_ArcaneMissiles_Use_FullStacks() Spell(arcane_missiles)
				if CheckBoxOn(opt_nether_tempest) and Burn_NetherTempest_Use() Spell(nether_tempest)
				if CheckBoxOn(opt_arcane_explosion) and Burn_ArcaneExplosion_Use_Dying() Spell(arcane_explosion)
				if CheckBoxOn(opt_presence_of_mind) and Burn_PresenceOfMind_Use() Spell(presence_of_mind)
				if Burn_ArcaneMissiles_Use() Spell(arcane_missiles)
				if CheckBoxOn(opt_arcane_explosion) and Burn_ArcaneExplosion_Use_ArcanePower() Spell(arcane_explosion)
				if Burn_ArcaneBlast_Use_ArcanePower() Spell(arcane_blast)
				if CheckBoxOn(opt_supernova) and Burn_Supernova_Use() Spell(supernova)
				if Burn_ArcaneMissiles_Use_Overpowered() Spell(arcane_missiles)
				if CheckBoxOn(opt_arcane_explosion) and Burn_ArcaneExplosion_Use() Spell(arcane_explosion)
				if Burn_ArcaneBarrage_Use() Spell(arcane_barrage)				
				if Burn_ArcaneBlast_Use() Spell(arcane_blast)
			}

			###
			### Conserve Rotation - Functions
			###
			AddFunction Conserve_ArcaneBarrage_Use
			{
					not SpellCooldown(arcane_barrage)
				and Mana() >= ManaCost(arcane_barrage)
				and target.RangeCheck(arcane_barrage)
				and ManaPercent() < 100
				and SpellCooldown(arcane_power) > 5
				and ArcaneCharges() == 4
			}

			AddFunction Conserve_ArcaneBlast_Use
			{
					not SpellCooldown(arcane_blast)
				and {
							BuffPresent(rhonins_assaulting_armwraps_buff)
						 or Mana() > ManaCost(arcane_blast)
					}
				and target.RangeCheck(arcane_blast)
				and {
							not MovementCheck()
						 or BuffPresent(presence_of_mind_buff)
					}
				and ArcaneCharges() < 4							
			}

			AddFunction Conserve_ArcaneBlast_Use_FullMana
			{
					not SpellCooldown(arcane_blast)
				and {
							BuffPresent(rhonins_assaulting_armwraps_buff)
						 or Mana() > ManaCost(arcane_blast)
					}
				and target.RangeCheck(arcane_blast)
				and {
							not MovementCheck()
						 or BuffPresent(presence_of_mind_buff)
					}
				and ManaPercent() > 99
			}

			AddFunction Conserve_ArcaneBlast_Use_KiltRuneMaster
			{
					not SpellCooldown(arcane_blast)
				and {
							BuffPresent(rhonins_assaulting_armwraps_buff)
						 or Mana() > ManaCost(arcane_blast)
					}
				and target.RangeCheck(arcane_blast)
				and {
							not MovementCheck()
						 or BuffPresent(presence_of_mind_buff)
					}
				and ManaPercent() >= 82
				and LegendaryEquipped(mystic_kilt_of_the_rune_master)
			}

			AddFunction Conserve_ArcaneBlast_Use_RhoninsArmwraps
			{
					not SpellCooldown(arcane_blast)
				and target.RangeCheck(arcane_blast)
				and {
							not MovementCheck()
						 or BuffPresent(presence_of_mind_buff)
					}
				and BuffPresent(rhonins_assaulting_armwraps_buff)
				and LegendaryEquipped(rhonins_assaulting_armwraps)
			}

			AddFunction Conserve_ArcaneExplosion_Use
			{
					not SpellCooldown(arcane_explosion)
				and Mana() >= ManaCost(arcane_explosion)
				and Enemies() > 1
				and ArcaneCharges() < 4
			}

			AddFunction Conserve_ArcaneExplosion_Use_KiltRuneMaster
			{
					not SpellCooldown(arcane_explosion)
				and Mana() >= ManaCost(arcane_explosion)
				and ManaPercent() >= 82
				and LegendaryEquipped(mystic_kilt_of_the_rune_master)
				and Enemies() > 1
			}

			AddFunction Conserve_ArcaneMissiles_Use
			{
					not SpellCooldown(arcane_missiles)
				and target.RangeCheck(arcane_missiles)
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and BuffPresent(arcane_missiles_buff)
			}

			AddFunction Conserve_ArcaneMissiles_Use_FullStacks
			{
					not SpellCooldown(arcane_missiles)
				and target.RangeCheck(arcane_missiles)
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and BuffStacks(arcane_missiles_buff) == 3
			}

			AddFunction Conserve_NetherTempest_Use
			{
					Talent(nether_tempest_talent)
				and not SpellCooldown(nether_tempest)
				and Mana() >= ManaCost(nether_tempest)
				and target.RangeCheck(nether_tempest)
				and target.InPandemicRange(nether_tempest_debuff nether_tempest)
			}

			AddFunction Conserve_Supernova_Use
			{
					Talent(supernova_talent)
				and not SpellCooldown(supernova)
				and target.RangeCheck(supernova)
				and ManaPercent() < 100
			}

			###
			### Conserve Rotation - Usage
			###
			AddFunction Rotation_Conserve_Use
			{
					not ArcaneBurnPhase()
				and not RuneOfPowerBuff()
			}

			###
			### Conserve Rotation
			###
			AddFunction Rotation_Conserve
			{
				if Conserve_ArcaneMissiles_Use_FullStacks() Spell(arcane_missiles)
				if Conserve_ArcaneBlast_Use_FullMana() Spell(arcane_blast)
				if CheckBoxOn(opt_nether_tempest) and Conserve_NetherTempest_Use() Spell(nether_tempest)
				if Conserve_ArcaneBlast_Use_RhoninsArmwraps() Spell(arcane_blast)
				if Conserve_ArcaneMissiles_Use() Spell(arcane_missiles)
				if CheckBoxOn(opt_supernova) and Conserve_Supernova_Use() Spell(supernova)
				if CheckBoxOn(opt_arcane_explosion) and Conserve_ArcaneExplosion_Use_KiltRuneMaster() Spell(arcane_explosion)
				if Conserve_ArcaneBlast_Use_KiltRuneMaster() Spell(arcane_blast)
				if Conserve_ArcaneBarrage_Use() Spell(arcane_barrage)
				if CheckBoxOn(opt_arcane_explosion) and Conserve_ArcaneExplosion_Use() Spell(arcane_explosion)
				if Conserve_ArcaneBlast_Use() Spell(arcane_blast)
			}

			###
			### Cooldowns Rotation - Functions
			###
			AddFunction Cooldowns_ArcanePower_Use
			{
					not SpellCooldown(arcane_power)
				and {
							not SpellCooldown(evocation)
						 or {
									LegendaryEquipped(gravity_spiral)
								and SpellCharges(evocation) >= 1
							}
						 or SpellCooldown(evocation) <= AverageArcaneBurn()
					}
			}

			AddFunction Cooldowns_MarkOfAluneth_Use
			{
					SpellKnown(mark_of_aluneth)
				and not SpellCooldown(mark_of_aluneth)
				and target.RangeCheck(mark_of_aluneth)
				and not MovementCheck()
			}

			AddFunction Cooldowns_NetherTempest_Use
			{
					Talent(nether_tempest_talent)
				and not SpellCooldown(nether_tempest)
				and Mana() >= ManaCost(nether_tempest)
				and target.RangeCheck(nether_tempest)
				and target.DebuffRemaining(nether_tempest_debuff) < 10
				and {
							PreviousGCDSpell(mark_of_aluneth)
						 or {
									Talent(rune_of_power_talent)
								and SpellCooldown(rune_of_power) < GCD()
							}
					}
			}

			AddFunction Cooldowns_RuneOfPower_Use
			{
					Talent(rune_of_power_talent)
				and SpellCharges(rune_of_power) >= 1
				and not MovementCheck()
				and not PreviousGCDSpell(rune_of_power)
				and not RuneOfPowerBuff()
			}

			###
			### Cooldowns Rotation - Usage
			###
			AddFunction Rotation_Cooldowns_Use
			{
					{
							not BuffPresent(arcane_power_buff)
						and ArcaneCharges() == 4
						and { 
									SpellKnown(mark_of_aluneth)
								and {
											not SpellCooldown(mark_of_aluneth)
										 or SpellCooldown(mark_of_aluneth) > 20 
									}
							}
						and { 
									not Talent(rune_of_power_talent) 
								 or {
											SpellCooldown(arcane_power) <= CastTime(rune_of_power)
										 or SpellCooldown(rune_of_power) < SpellCooldown(arcane_power)
									}
							}
					}
				 or target.TimeToDie() < 45
			}

			###
			### Cooldowns Rotation
			###
			AddFunction Rotation_Cooldowns
			{
				if CheckBoxOn(opt_mark_of_aluneth) and Cooldowns_MarkOfAluneth_Use() Spell(mark_of_aluneth)
				if CheckBoxOn(opt_nether_tempest) and Cooldowns_NetherTempest_Use() Spell(nether_tempest)
				if CheckBoxOn(opt_power_rune) and Cooldowns_RuneOfPower_Use() Spell(rune_of_power)
				if CheckBoxOn(opt_arcane_power) and Cooldowns_ArcanePower_Use() Spell(arcane_power)
			}

			###
			### Rune Of Power Rotation - Functions
			###
			AddFunction RuneOfPower_ArcaneBarrage_Use
			{
					not SpellCooldown(arcane_barrage)
				and Mana() >= ManaCost(arcane_barrage)
				and target.RangeCheck(arcane_barrage)
				and ArcaneCharges() == 4
			}

			AddFunction RuneOfPower_ArcaneBlast_Use
			{
					not SpellCooldown(arcane_blast)
				and {
							BuffPresent(rhonins_assaulting_armwraps_buff)
						 or Mana() > ManaCost(arcane_blast)
					}
				and target.RangeCheck(arcane_blast)
				and {
							not MovementCheck()
						 or BuffPresent(presence_of_mind_buff)
					}
				and ManaPercent() > 45
			}

			AddFunction RuneOfPower_ArcaneExplosion_Use
			{
					not SpellCooldown(arcane_explosion)
				and Mana() >= ManaCost(arcane_explosion)
				and Enemies() > 1
			}

			AddFunction RuneOfPower_ArcaneMissiles_Use
			{
					not SpellCooldown(arcane_missiles)
				and target.RangeCheck(arcane_missiles)
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and BuffPresent(arcane_missiles_buff)
				and ArcaneCharges() == 4
			}

			AddFunction RuneOfPower_ArcaneMissiles_Use_FullStacks
			{
					not SpellCooldown(arcane_missiles)
				and target.RangeCheck(arcane_missiles)
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and BuffStacks(arcane_missiles_buff) == 3
			}

			AddFunction RuneOfPower_NetherTempest_Use
			{
					Talent(nether_tempest_talent)
				and not SpellCooldown(nether_tempest)
				and Mana() >= ManaCost(nether_tempest)
				and target.RangeCheck(nether_tempest)
				and {
							target.DebuffRemaining(nether_tempest_debuff) <= 2
						 or not target.DebuffPresent(nether_tempest_debuff)
					}
			}

			###
			### Rune Of Power Rotation - Usage
			###
			AddFunction Rotation_RuneOfPower_Use
			{
					not ArcaneBurnPhase()
				and RuneOfPowerBuff()
			}

			###
			### Rune Of Power Rotation
			###
			AddFunction Rotation_RuneOfPower
			{
				if RuneOfPower_ArcaneMissiles_Use_FullStacks() Spell(arcane_missiles)
				if CheckBoxOn(opt_nether_tempest) and RuneOfPower_NetherTempest_Use() Spell(nether_tempest)
				if RuneOfPower_ArcaneMissiles_Use() Spell(arcane_missiles)
				if CheckBoxOn(opt_arcane_explosion) and RuneOfPower_ArcaneExplosion_Use() Spell(arcane_explosion)
				if RuneOfPower_ArcaneBlast_Use() Spell(arcane_blast)
				if RuneOfPower_ArcaneBarrage_Use() Spell(arcane_barrage)
			}

			###
			### Main Icon Rotations - Functions
			###
			AddFunction Main_Evocation_Use
			{
					{
							not SpellCooldown(evocation)
						 or {
									LegendaryEquipped(gravity_spiral)
								and SpellCharges(evocation) >= 1
							}
					}
				and {
							Talent(slipstream_talent)
						 or not MovementCheck()
					}
				and Mana() < ManaCost(arcane_blast)
				and not BuffPresent(rhonins_assaulting_armwraps_buff)
			}

			AddFunction Main_Evocation_Cancel
			{
					IsCasting(evocation)
				and ManaPercent() > 95
			}

			AddFunction Main_MarkOfAluneth_Use
			{
					SpellKnown(mark_of_aluneth)
				and target.RangeCheck(mark_of_aluneth)
				and not MovementCheck()
				and not SpellCooldown(mark_of_aluneth)
				and SpellCooldown(arcane_power) > 20
			}

			AddFunction Main_MirrorImage_Use
			{
					Talent(mirror_image_talent)
				and Mana() >= ManaCost(mirror_image)
				and not SpellCooldown(mirror_image)
				and not BuffPresent(arcane_power)
			}

			AddFunction Main_TimeWarp_Use
			{
					not SpellCooldown(time_warp)
				and Mana() >= ManaCost(time_warp)
				and IsBossFight()
				and {
							not BloodlustActive()
						and {
									LunaEclipse_Bloodlust_Used()
								 or GroupMembers() == 1
							}
					}
				and {
							{
									LegendaryEquipped(shard_of_the_exodar)
								and BuffPresent(arcane_power_buff)
								and PreviousOffGCDSpell(arcane_power)
							}
						 or target.TimeToDie() < 40					
					}
			}

			###
			### Main Icon Rotations
			###
			AddFunction Main
			{
				# Cancel Evocation if needed
				if CheckBoxOn(opt_evocation) and Main_Evocation_Cancel() Texture(spell_nature_purge text=cancel)

				# Use Evocation if needed to start the Conserve Phase
				if CheckBoxOn(opt_evocation) and Main_Evocation_Use() Spell(evocation)

				if CheckBoxOn(opt_time_warp) and Main_TimeWarp_Use() Spell(time_warp)
				if CheckBoxOn(opt_mirror_image) and Main_MirrorImage_Use() Spell(mirror_image)				
				if CheckBoxOn(opt_mark_of_aluneth) and Main_MarkOfAluneth_Use() Spell(mark_of_aluneth)

				# Build Charges if less then 4 Charges of Arcane Power
				if Rotation_Build_Use() Rotation_Build()

				# Cooldowns for starting Burn Phase
				if Rotation_Cooldowns_Use() Rotation_Cooldowns()

				# Rotation during Burn Phase
				if Rotation_Burn_Use() Rotation_Burn()

				# Rune of Power rotation when not in Burn Phase
				if Rotation_RuneOfPower_Use() Rotation_RuneOfPower()

				# Conserve Rotation
				if Rotation_Conserve_Use() Rotation_Conserve()

				# Show Forward Arrow if out of range of longest range ability
				if not target.RangeCheck(arcane_blast) Texture(misc_arrowlup help="No Abilities in range")
			}

			AddFunction Main_Precombat
			{
				if CheckBoxOn(opt_mirror_image) and Main_MirrorImage_Use() Spell(mirror_image)
				Spell(arcane_blast)
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
			}

			AddFunction CD_BloodFury_Use
			{
					Race(Orc)
				and not SpellCooldown(blood_fury_sp)
			}

			AddFunction CD_IceBlock_Use
			{
					not SpellCooldown(ice_block)
				and Mana() >= ManaCost(ice_block)
				and not BuffPresent(ice_block_buff)
				and not player.DebuffPresent(hypothermia_debuff)
				and HealthPercent() <= 40
			}

			AddFunction CD_Potion_Use
			{
					BloodlustActive()
				 or {
							BloodlustDebuff()
						and BuffPresent(arcane_power_buff)
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

				# Cooldown Actions
				if not CheckBoxOn(opt_evocation) and Main_Evocation_Cancel() Texture(spell_nature_purge text=cancel)
				if not CheckBoxOn(opt_time_warp) and Main_TimeWarp_Use() Spell(time_warp)

				if Rotation_Cooldowns_Use()
				{
					if not CheckBoxOn(opt_arcane_power) and Cooldowns_ArcanePower_Use() Spell(arcane_power)
				}

				if not CheckBoxOn(opt_evocation) and Main_Evocation_Use() Spell(evocation)

				# Potion
				if LunaEclipse_Potion_Use() and CD_Potion_Use() Item(potion_of_deadly_grace)

				# Display Ice Block only if option is checked
				if CheckBoxOn(opt_ice_block) and CD_IceBlock_Use() Spell(ice_block)

				# Standard Abilties
				if CD_BloodFury_Use() Spell(blood_fury_sp)
				if CD_Berserking_Use() Spell(berserking)
				if not CheckBoxOn(opt_arcane_torrent_interrupt) and CD_ArcaneTorrent_Use() Spell(arcane_torrent_mana)
				Rotation_ItemActions()
			}

			AddFunction CD_Precombat
			{
				# Potion
				if LunaEclipse_Potion_Use() Item(potion_of_deadly_grace)
			}

			###
			### Rotation Icons.
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

		OvaleScripts:RegisterScript("MAGE", "arcane", name, desc, code, "script");
	end
end