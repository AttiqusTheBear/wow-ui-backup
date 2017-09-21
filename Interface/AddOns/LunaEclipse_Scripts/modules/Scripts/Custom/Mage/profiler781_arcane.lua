local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "profiler781_mage_arcane";
		local desc = "Profiler781: Arcane Mage";

		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.MAGE_ARCANE,
			ScriptAuthor = "Profiler781",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "2122131",
			["Raiding (AOE) / Dungeons / Mythic+"] = "2123113",
			["Solo / World Quests"] = "2131122",
		};

		local code = [[
			# Arcane Mage rotation functions based on Guide written by Furty: http://www.icy-veins.com/wow/arcane-mage-pve-dps-guide
			
			Include(lunaeclipse_mage_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_arcane_familiar "Buff: Arcane Familiar" default specialization=arcane)
			AddCheckBox(opt_arcane_power "CD: Arcane Power" default specialization=arcane)
			AddCheckBox(opt_charged_up "CD: Charged Up" default specialization=arcane)
			AddCheckBox(opt_evocation "CD: Evocation" default specialization=arcane)
			AddCheckBox(opt_mark_of_aluneth "CD: Mark of Aluneth" default specialization=arcane)
			AddCheckBox(opt_rune_of_power "CD: Rune Of Power" default specialization=arcane)
			AddCheckBox(opt_mirror_image "CD: Mirror Image" default specialization=arcane)
			AddCheckBox(opt_presence_of_mind "CD: Presence of Mind" default specialization=arcane)
			AddCheckBox(opt_supernova "CD: Supernova" default specialization=arcane)
			AddCheckBox(opt_orcane_orb "CD: Arcane Orb" default specialization=arcane)
			AddCheckBox(opt_time_warp "CD: Time Warp" default)
			AddCheckBox(opt_barrier_spells "Defensive: Barrier Spells" default)

			###
			### Artifact Functions
			###
			AddFunction MarkOfAluneth_Available
			{
					SpellKnown(mark_of_aluneth)
				and not SpellCooldown(mark_of_aluneth)
			}

			AddFunction MarkOfAluneth_Use
			{
					MarkOfAluneth_Available()
				and {
							ArcaneCharges() == 4
						 or {
						 			Talent(charged_up_talent)
						 		and not SpellCooldown(charged_up)
						 		and ArcaneCharges() == 0
						 	}
					}
				and {
							SpellCooldown(rune_of_power) <= ExecuteTime(mark_of_aluneth)
						 or SpellCharges(rune_of_power) >= 1
						 or not Talent(rune_of_power_talent)
					}
				and ManaPercent() > 30
				and not target.DebuffPresent(mark_of_aluneth_debuff)
				and {
							SpellCooldown(arcane_power) > 20
						 or SpellCooldown(arcane_power) <= ExecuteTime(rune_of_power) + ExecuteTime(mark_of_aluneth)
						 or {
						 			not Talent(rune_of_power_talent)
						 		and SpellCooldown(arcane_power) <= ExecuteTime(mark_of_aluneth)
							}
					}
				and target.TimeToDie() >= 8
			}

			###
			### Arcane Barrage Functions
			###
			AddFunction ArcaneBarrage_Use
			{
					not SpellCooldown(arcane_barrage)
				and {
							ManaPercent() < 94
						 or {
						 			ManaPercent() < 94 - ArcaneCharges() * 3
						 		and LegendaryEquipped(mystic_kilt_of_the_rune_master)
						 	}
					}
				and {
							{
									not BuffPresent(arcane_power_buff)
								and not BuffPresent(rune_of_power_buff)
								and not target.DebuffPresent(mark_of_aluneth_debuff)
							}
						 or {
						 			Mana() <= MaxMana() / 50
						 		and isCasting(arcane_blast)
						 	}
						 or {
						 			Mana() < ManaCost(arcane_blast)
						 		and not isCasting(arcane_blast)
						 	}
					}
				and not PreviousGCDSpell(evocation)
				and SpellCooldown(evocation) > Mana() / ManaCost(arcane_blast) * ExecuteTime(arcane_blast)
				and {
						{
								Talent(charged_up_talent)
							and SpellCooldown(charged_up) <= (4 - ArcaneCharges()) * ExecuteTime(arcane_blast)
						}
						 or {
								{
										SpellCooldown(mark_of_aluneth) > (4 - ArcaneCharges()) * ExecuteTime(arcane_blast)
									 or SpellCooldown(arcane_power) < 20
								}
								and SpellCooldown(arcane_power) > (4 - ArcaneCharges()) * ExecuteTime(arcane_blast)
							}
						 or ManaPercent() < 40
					}
			}

			AddFunction ArcaneBarrage_Use_AOE
			{
					not SpellCooldown(arcane_barrage)
				and {
						{
								Talent(charged_up_talent)
							and not SpellCooldown(charged_up)
						} or {
								Talent(arcane_orb_talent)
							and not SpellCooldown(arcane_orb)
						}
					}
				and not isCasting(evocation)
				and Enemies() >= 3
			}

			###
			### Arcane Blast Functions
			###
			AddFunction ArcaneBlast_Use
			{
					not SpellCooldown(arcane_blast)
			}

			AddFunction ArcaneBlast_Use_Burn
			{
					not SpellCooldown(arcane_blast)
				and ArcaneCharges() < 4
				and {
							ManaPercent() >= 20
						 or {
						 			ManaPercent() >= 40
						 		and not Talent(overpowered_talent)
						 	}
					}
				and {
							SpellCooldown(arcane_power) <= (4 - ArcaneCharges()) * ExecuteTime(arcane_blast)
						 or SpellCooldown(mark_of_aluneth) <= (4 - ArcaneCharges()) * ExecuteTime(arcane_blast)
					}
			}

			###
			### Arcane Explosion Functions
			###
			AddFunction ArcaneExplosion_Use
			{
					not SpellCooldown(arcane_explosion)
				and Enemies() >= 3
			}

			###
			### Arcane Familiar Functions
			###
			AddFunction ArcaneFamiliar_Use
			{
					not SpellCooldown(arcane_familiar)
				and {
							not BuffPresent(arcane_familiar_buff)
						 or BuffRemaining(arcane_familiar_buff) < 900
					}
			}

			###
			### Arcane Missiles Functions
			###
			AddFunction ArcaneMissiles_Use
			{
					not SpellCooldown(arcane_missiles)
				and {
						{
								BuffStacks(arcane_missiles_buff) == 2
							and SpellCooldown(arcane_power) > 6
							and SpellCooldown(mark_of_aluneth) > 6
							and ArcaneCharges() > 1
						}
						 or BuffRemaining(arcane_missiles_buff) <= ExecuteTime(arcane_blast)
					}
			}

			AddFunction ArcaneMissiles_Use_Burn
			{
					not SpellCooldown(arcane_missiles)
				and {
							BuffPresent(rune_of_power_buff)
						 or BuffPresent(arcane_power_buff)
						 or BuffStacks(arcane_missiles_buff) == 3
					}
			}

			###
			### Arcane Orb Functions
			###
			AddFunction ArcaneOrb_Use
			{
					Talent(arcane_orb_talent)
				and not SpellCooldown(arcane_orb)
				and ArcaneCharges() == 0
			}

			###
			### Arcane Power Functions
			###
			AddFunction ArcanePower_Use
			{
					not SpellCooldown(arcane_power)
				and ArcaneCharges() == 4
				and ManaPercent() > 30
				and {
							BuffPresent(rune_of_power_buff)
						 or not Talent(rune_of_power_talent)
					}
				and not BuffPresent(arcane_power_buff)
			}

			###
			### Charged Up Functions
			###
			AddFunction ChargedUp_Use
			{
					not SpellCooldown(charged_up)
				and Talent(charged_up_talent)
				and ArcaneCharges() == 0
				and {
							SpellCooldown(arcane_power) <= ExecuteTime(rune_of_power) + ExecuteTime(mark_of_aluneth)
						 or {
						 			not Talent(rune_of_power_talent)
						 		and SpellCooldown(arcane_power) <= ExecuteTime(mark_of_aluneth)
							}
						 or not SpellCooldown(mark_of_aluneth)
						 or target.DebuffPresent(mark_of_aluneth_debuff)
						 or BuffPresent(rune_of_power_buff)
						 or BuffPresent(arcane_power_buff)
					}
			}

			###
			### Evocation Functions
			###
			AddFunction Evocation_Use
			{
					not SpellCooldown(evocation)
				and {
						{
							{
								SpellCooldown(arcane_power) <= ExecuteTime(rune_of_power) + ExecuteTime(mark_of_aluneth) + ExecuteTime(evocation)
								 or {
								 			not Talent(rune_of_power_talent)
								 		and SpellCooldown(arcane_power) <= ExecuteTime(mark_of_aluneth) + ExecuteTime(evocation)
									}
							}
							and {
										ManaPercent() < 20
									 or {
									 			ManaPercent() < 40
									 		and not Talent(overpowered_talent)
									 	}
								}
							and not target.DebuffPresent(mark_of_aluneth_debuff)
							and not BuffPresent(rune_of_power_buff)
							and not BuffPresent(arcane_power_buff)
						}
						 or {
						 			Mana() <= MaxMana() / 50
						 		and isCasting(arcane_blast)
						 	}
						 or {
						 			Mana() < ManaCost(arcane_blast)
						 		and not isCasting(arcane_blast)
						 	}
					}
			}

			###
			### Mirror Image Functions
			###
			AddFunction MirrorImage_Use
			{
					Talent(mirror_image_talent)
				and ArcaneCharges() == 4
				and IsBossFight()
				and {
							SpellCooldown(rune_of_power) <= ExecuteTime(mark_of_aluneth)
						 or SpellCharges(rune_of_power) >= 1
						 or not Talent(rune_of_power_talent)
					}
				and ManaPercent() > 30
				and {
							SpellCooldown(arcane_power) > 20
						 or SpellCooldown(arcane_power) <= ExecuteTime(rune_of_power) + ExecuteTime(mark_of_aluneth)
						 or {
						 			not Talent(rune_of_power_talent)
						 		and SpellCooldown(arcane_power) <= ExecuteTime(mark_of_aluneth)
							}
					}
			}

			###
			### Nether Tempest Functions
			###
			AddFunction NetherTempest_Use
			{
					Talent(nether_tempest_talent)
				and not SpellCooldown(nether_tempest)
				and {
							DebuffStacksOnAny(nether_tempest_debuff) == 0
						 or {
						 			DebuffStacksOnAny(nether_tempest_debuff excludeTarget=1) == 0
						 		and target.DebuffPresent(nether_tempest_debuff)
				 				and target.InPandemicRange(nether_tempest_debuff nether_tempest)
				 				and ArcaneCharges() == 4
							}
					}
			}

			###
			### Presence Of Mind Functions
			###
			AddFunction PresenceOfMind_Use
			{
					not SpellCooldown(presence_of_mind)
				and {
						{
								BuffGain(rune_of_power_buff) <= BaseDuration(rune_of_power_buff) - GCD() * 2
							and BuffPresent(rune_of_power_buff)
						}
						 or not Talent(rune_of_power_talent)
					}
				and SpellCooldown(arcane_power) > 50
			}

			###
			### Prismatic Barrier Functions
			###
			AddFunction PrismaticBarrier_Use
			{
					not SpellCooldown(prismatic_barrier)
				and not BuffPresent(prismatic_barrier_buff)
			}

			###
			### Rune Of Power Functions
			###
			AddFunction RuneOfPower_Use
			{
					not SpellCooldown(rune_of_power)
				and Talent(rune_of_power_talent)
				and ArcaneCharges() == 4
				and ManaPercent() > 30
				and {
							not BuffPresent(rune_of_power_buff)
						 or BuffGain(rune_of_power_buff) >= BaseDuration(rune_of_power_buff) - GCD()
					}
				and {
							SpellCooldown(arcane_power) <= ExecuteTime(rune_of_power)
						 or BuffRemaining(arcane_power) > BaseDuration(arcane_power_buff) + ExecuteTime(rune_of_power) + ExecuteTime(arcane_blast)
						 or target.DebuffPresent(mark_of_aluneth_debuff)
						 or {
						 			SpellCooldown(mark_of_aluneth) >= SpellCooldownDuration(rune_of_power)
						 		and SpellCooldown(arcane_power) >= SpellCooldownDuration(rune_of_power)
						 	}
						 or {
						 			SpellCharges(rune_of_power) == 2
						 		 or {
								 			SpellCharges(rune_of_power) == 1
								 		and SpellCooldown(rune_of_power) <= ExecuteTime(rune_of_power)
								 	}
							}
					}
			}

			###
			### Supernova Functions
			###
			AddFunction Supernova_Use
			{
					Talent(supernova_talent)
				and not SpellCooldown(supernova)
				and {
							Enemies() >= 3
						 or ArcaneCharges() == 0
					}
			}

			###
			### Time Warp Functions
			###
			AddFunction TimeWarp_Use_ShardOfExodar
			{
					not SpellCooldown(time_warp)
				and IsBossFight()
				and BuffPresent(arcane_power_buff)
				and LegendaryEquipped(shard_of_the_exodar)
				and not BloodlustActive()
				and {
							LunaEclipse_Bloodlust_Used()
						 or GroupMembers() == 1
					}
			}

			AddFunction TimeWarp_Use
			{
					not SpellCooldown(time_warp)
				and IsBossFight()
				and BuffPresent(arcane_power_buff)
				and not BloodlustActive()
				and not LunaEclipse_Bloodlust_Used()
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					Spell(counterspell)

					if not target.Classification(worldboss)
					{
						Spell(dragons_breath)
						Spell(arcane_torrent_mana)
						if target.RangeCheck(quaking_palm) Spell(quaking_palm)
						Spell(war_stomp)
					}
				}
			}

			###
			### Item Functions
			###
			AddFunction Potion_Use
			{
					BloodlustActive()
				 or {
							{
									BloodlustDebuff()
								 or {
											LegendaryEquipped(shard_of_the_exodar)
										and LunaEclipse_Bloodlust_Used()
									}
							}
						and {
									{
											BuffPresent(trinket_stat_any_buff)
										 or BuffPresent(legendary_ring_buff) 
										 or BuffStacks(trinket_stacking_proc_any_buff) > 6
									}
								 or {
											target.HealthPercent() <= 20
										 or target.TimeToDie() <= 25
									}
							}
					}
				 or {
							not BloodlustDebuff()
						and target.TimeToDie() <= 25
					}
			}

			###
			### Cooldown Functions
			###
			AddFunction Cooldown_Use
			{
				{
						SpellCooldown(arcane_power) > 10
					and {
								BuffPresent(rune_of_power_buff)
							 or PreviousGCDSpell(rune_of_power)
						}	
				}
				 or BuffPresent(arcane_power_buff)
				 or PreviousGCDSpell(arcane_power)
			}

			###
			### Arcane - Main
			###
			AddFunction ShortCD
			{
				if CheckBoxOn(opt_arcane_familiar) and ArcaneFamiliar_Use() Spell(arcane_familiar)
				if Evocation_Use() Spell(evocation)
				if MirrorImage_Use() Spell(mirror_image)
				if ChargedUp_Use() Spell(charged_up)
				if MarkOfAluneth_Use() Spell(mark_of_aluneth)
				if RuneOfPower_Use() Spell(rune_of_power)
				if ArcanePower_Use() Spell(arcane_power)
				if PresenceOfMind_Use() Spell(presence_of_mind)
				if ArcaneOrb_Use() Spell(arcane_orb)
				if Supernova_Use() Spell(supernova)
				if ArcaneMissiles_Use_Burn() Spell(arcane_missiles)
				if ArcaneBlast_Use_Burn() Spell(arcane_blast)
			}

			AddFunction Main
			{
				if CheckBoxOn(opt_evocation) and Evocation_Use() Spell(evocation)
				if CheckBoxOn(opt_mirror_image) and MirrorImage_Use() Spell(mirror_image)
				if CheckBoxOn(opt_charged_up) and ChargedUp_Use() Spell(charged_up)
				if NetherTempest_Use() Spell(nether_tempest)
				if CheckBoxOn(opt_mark_of_aluneth) and MarkOfAluneth_Use() Spell(mark_of_aluneth)
				if CheckBoxOn(opt_rune_of_power) and RuneOfPower_Use() Spell(rune_of_power)
				if CheckBoxOn(opt_arcane_power) and ArcanePower_Use() Spell(arcane_power)
				if CheckBoxOn(opt_time_warp) and TimeWarp_Use_ShardOfExodar() Spell(time_warp text=Shard)
				if CheckBoxOn(opt_time_warp) and TimeWarp_Use() Spell(time_warp)
				if ArcaneMissiles_Use_Burn() Spell(arcane_missiles)
				if CheckBoxOn(opt_presence_of_mind) and PresenceOfMind_Use() Spell(presence_of_mind)
				if ArcaneBarrage_Use_AOE() Spell(arcane_barrage)
				if CheckBoxOn(opt_arcane_orb) and ArcaneOrb_Use() Spell(arcane_orb)
				if CheckBoxOn(opt_supernova) and Supernova_Use() Spell(supernova)
				if ArcaneMissiles_Use() Spell(arcane_missiles)
				if ArcaneBarrage_Use() Spell(arcane_barrage)
				if ArcaneExplosion_Use() Spell(arcane_explosion)
				if ArcaneBlast_Use() Spell(arcane_blast)
			}

			AddFunction CD
			{
				# Standard Abilties
				Rotation_Interrupt()

				if CheckBoxOn(opt_barrier_spells) and PrismaticBarrier_Use() Spell(prismatic_barrier)

				# Cooldown Actions
				if Cooldown_Use()
				{
					Spell(blood_fury_sp)
					Spell(berserking)
					Rotation_ItemActions()
					if TimeWarp_Use_ShardOfExodar() Spell(time_warp text=Shard)
					if LunaEclipse_Potion_Use() Item(draenic_intellect_potion)
					if TimeWarp_Use() Spell(time_warp)
				}
				
				if not CheckBoxOn(opt_arcane_torrent_interrupt) Spell(arcane_torrent_mana)
			}

			###
			### Arcane - Main_Precombat
			###
			AddFunction ShortCD_Precombat
			{
				if CheckBoxOn(opt_arcane_familiar) and ArcaneFamiliar_Use() Spell(arcane_familiar)
				if MarkOfAluneth_Use() Spell(mark_of_aluneth)
			}

			AddFunction Main_Precombat
			{

				if CheckBoxOn(opt_mark_of_aluneth) and MarkOfAluneth_Use() Spell(mark_of_aluneth)
				if ArcaneBlast_Use() Spell(arcane_blast)
			}

			AddFunction CD_Precombat
			{
				if CheckBoxOn(opt_barrier_spells) and PrismaticBarrier_Use() Spell(prismatic_barrier)
				if LunaEclipse_Potion_Use() Item(draenic_intellect_potion)
			}

			### Arcane icons.
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