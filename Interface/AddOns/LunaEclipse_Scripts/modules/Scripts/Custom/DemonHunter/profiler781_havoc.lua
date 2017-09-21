local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "profiler781_demonhunter_havoc";
		local desc = "Profiler781: Havoc Demon Hunter";

		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DEMONHUNTER_HAVOC,
			ScriptAuthor = "Profiler781",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Raiding (Single Target)"] = "2223311",
			["Raiding (AOE)"] = "3313123",
			["Solo"] = "2323213",
			["Easy Mode"] = "3223133",
		};

		-- Set the script as the default script for the specialization, this should only be included in official scripts, not user contributed scripts.
		-- This custom script has this because there is no default script provided by the package.
		LunaEclipse_Scripts:SetDefaultScript(addonTable.scriptInfo[name].SpecializationID, name);

		local code = [[
			Include(lunaeclipse_demonhunter_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_blur "Defensive: Blur" default)
			AddCheckBox(opt_metamorphosis "CD: Metamorphosis" default)
			AddCheckBox(opt_nemesis "CD: Nemesis" default)
			AddCheckBox(opt_fel_rush "CD: Fel Rush" default)
			AddCheckBox(opt_vengeful_retreat "CD: Vengeful Retreat" default)
			AddCheckBox(opt_chaos_blade "CD: Chaos Blade" default)
			AddCheckBox(opt_fury_of_the_ilidari "CD: Fury Of The Ilidari" default)
			AddCheckBox(opt_eye_beam "CD: Eye Beam" default)
			AddCheckBox(opt_felblade "CD: Felblade" default)
			AddCheckBox(opt_fel_barrage "CD: Fel Barrage" default)
			AddCheckBox(opt_fel_eruption "CD: Eruption" default)
			AddCheckBox(opt_major_cd "CD: Major CD for Bosses")
			AddCheckBox(opt_range_check "Display: Range Check")

			###
			### Artifact Functions
			###
			AddFunction FuryOfTheIllidari_Available
			{
					SpellKnown(fury_of_the_illidari)
				and not SpellCooldown(fury_of_the_illidari)
			}

			AddFunction FuryOfTheIllidari_Use
			{
					FuryOfTheIllidari_Available()
				and {
							not Talent(momentum_talent)
						 or BuffPresent(momentum_buff)
					}
			}

			###
			### Annihilation Functions
			###
			AddFunction Annihilation_Use
			{
					BuffPresent(metamorphosis_havoc_buff)
				and not SpellCooldown(annihilation)
				and {
							{
									Enemies() == 1
								and SpellCooldown(throw_glaive_havoc)
							}
						 or {
						 			Fury() >= 70
						 		 or {
						 		 			Fury() >= 60
						 		 		and Talent(demon_blades_talent)
						 			}
							}
					}
				and {
							not Talent(demonic_talent)
						 or SpellCooldown(eye_beam)
					}
			}

			AddFunction Annihilation_Use_AOE
			{
					BuffPresent(metamorphosis_havoc_buff)
				and not SpellCooldown(annihilation)
				and Talent(chaos_cleave_talent)
				and {
							not Talent(demonic_talent)
						 or SpellCooldown(eye_beam)
					}
				and Enemies() >= 2
			}

			###
			### Blade Dance Functions
			###
			AddFunction BladeDance_Use_FirstBlood
			{
					not BuffPresent(metamorphosis_havoc_buff)
				and not SpellCooldown(blade_dance)
				and Talent(first_blood_talent)
			}

			AddFunction BladeDance_Use
			{
					not BuffPresent(metamorphosis_havoc_buff)
				and not SpellCooldown(blade_dance)
				and {
							not Talent(demonic_talent)
						 or SpellCooldown(eye_beam)
					}
				and Enemies() >= 4
			}

			###
			### Blur Functions
			###
			AddFunction Blur_Use
			{
					Metamorphosis_Use()
				and not SpellCooldown(blur)
				and Talent(demon_reborn_talent)
			}

			###
			### Chaos Blade Functions
			###
			AddFunction Chaos_Blades_Use
			{
					not SpellCooldown(chaos_blades)
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
				and {
							not Talent(nemesis_talent)
						 or not SpellCooldown(nemesis)
						 or SpellCooldown(nemesis) >= SpellCooldownDuration(nemesis) - BaseDuration(nemesis_debuff)
					}
			}

			###
			### Chaos Strike Functions
			###
			AddFunction Chaos_Strike_Use
			{
					not BuffPresent(metamorphosis_havoc_buff)
				and not SpellCooldown(chaos_strike)
				and {
							{
									Enemies() == 1
								and SpellCooldown(throw_glaive_havoc)
							}
						 or {
						 			Fury() >= 70
						 		 or {
						 		 			Fury() >= 60
						 		 		and Talent(demon_blades_talent)
						 			}
							}
					}
				and {
							not Talent(demonic_talent)
						 or SpellCooldown(eye_beam)
					}
			}

			AddFunction Chaos_Strike_Use_AOE
			{
					not BuffPresent(metamorphosis_havoc_buff)
				and not SpellCooldown(chaos_strike)
				and Talent(chaos_cleave_talent)
				and Enemies() >= 2
				and {
							not Talent(demonic_talent)
						 or SpellCooldown(eye_beam)
					}
			}

			###
			### Death Sweep Functions
			###
			AddFunction DeathSweep_Use_FirstBlood
			{
					BuffPresent(metamorphosis_havoc_buff)
				and not SpellCooldown(death_sweep)
				and Talent(first_blood_talent)
			}

			AddFunction DeathSweep_Use
			{
					BuffPresent(metamorphosis_havoc_buff)
				and not SpellCooldown(death_sweep)
				and {
							not Talent(demonic_talent)
						 or SpellCooldown(eye_beam)
					}
				and Enemies() >= 4
			}

			###
			### Demon's Bite Functions
			###
			AddFunction Demons_Bite_Use
			{
					not SpellCooldown(demons_bite)
				and not Talent(demon_blades_talent)
			}

			###
			### Eye Beam Functions
			###
			AddFunction EyeBeam_Use
			{
					not SpellCooldown(eye_beam)
				and {
							Talent(demonic_talent)
						 or Talent(blind_fury_talent)
						 or Enemies() > 1
					}
				and {
							not Talent(momentum_talent)
						 or BuffPresent(momentum_buff)
					}
			}

			###
			### Fel Barrage Functions
			###
			AddFunction FelBarrage_Use
			{
					not SpellCooldown(fel_barrage)
			}

			###
			### Fel Eruption Functions
			###
			AddFunction FelEruption_Use
			{
					not SpellCooldown(fel_eruption)
				and Talent(fel_eruption_talent)
				and Enemies() == 1
			}

			AddFunction FelEruption_Use_Dump
			{
					not SpellCooldown(fel_eruption)
				and Talent(fel_eruption_talent)
			}

			###
			### Fel Rush Functions
			###
			AddFunction FelRush_Use
			{
					not SpellCooldown(fel_rush)
				and {
							{
									Talent(momentum_talent)
						 		and not BuffPresent(momentum_buff)
						 		and {
						 					SpellCharges(fel_rush) == 2
										 or {
										 			SpellCharges(fel_rush) == 1
										 		and {
										 					SpellCooldown(fel_rush) < BaseDuration(momentum_buff)
										 				 or SpellCooldown(vengeful_retreat) > BaseDuration(momentum_buff)
													}	
											}
									}
							}
						 or {
						 			Talent(fel_mastery_talent)
						 		and not Talent(momentum_talent)
						 		and FuryDeficit() >= 45
							}
					}
			}

			AddFunction FelRush_Use_AOE
			{
					not SpellCooldown(fel_rush)
				and Enemies() > 1
				and {
							not Talent(fel_barrage_talent)
						 or {
						 			Talent(fel_barrage_talent)
						 		and ( 5 - SpellCharges(fel_barrage) ) / GCD() >= BaseDuration(momentum_buff)
							}
					}
				and not Talent(momentum_talent)
			}

			AddFunction FelRush_Use_Melee
			{
					not SpellCooldown(fel_rush)
				and target.Distance() >= 8
			}

			AddFunction FelRush_Use_Dump
			{
					not SpellCooldown(fel_rush)
				and not Talent(momentum_talent)
				and not Talent(fel_mastery_talent)
			}

			###
			### Felblade Functions
			###
			AddFunction Felblade_Use
			{
					not SpellCooldown(felblade)
				and FuryDeficit() > 30
				and Enemies() == 1
			}

			AddFunction Felblade_Use_Dump
			{
					not SpellCooldown(felblade)
				and FuryDeficit() > 30
			}

			AddFunction Felblade_Use_Melee
			{
					not SpellCooldown(felblade)
				and target.Distance() > 5
				and target.RangeCheck(felblade)
			}

			###
			### Metamorphosis Functions
			###
			AddFunction Metamorphosis_Use
			{
					not SpellCooldown(metamorphosis_havoc)
				and not BuffPresent(metamorphosis_havoc_buff)
				and {
							not Talent(demonic_talent)
						 or SpellCooldown(eye_beam)
						 or Fury() < 10
					}
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
				and {
							not Talent(nemesis_talent)
						 or not SpellCooldown(nemesis)
						 or SpellCooldown(nemesis) >= SpellCooldownDuration(nemesis) - BaseDuration(nemesis_debuff)
					}
			}

			AddFunction Metamorphosis_Use_Melee
			{
					Metamorphosis_Use()
				and {
							CheckBoxOff(opt_range_check)
						 or {
						 			target.Distance() > 5
						 		and target.Distance() <= 40
							}
					}
			}

			###
			### Nemesis Functions
			###
			AddFunction Nemesis_Use
			{
					not SpellCooldown(nemesis)
				and Talent(nemesis_talent)
				and {
							SpellCooldown(metamorphosis_havoc) <= BaseDuration(nemesis_debuff) - BaseDuration(metamorphosis_havoc_buff)
						 or BuffPresent(metamorphosis_havoc_buff)
						 or SpellCooldown(metamorphosis_havoc) >= SpellCooldownDuration(nemesis)
					}
				and {
							not Talent(chaos_blades_talent)
						 or SpellCooldown(chaos_blades) <= BaseDuration(nemesis_debuff) - BaseDuration(chaos_blades_buff)
						 or BuffPresent(chaos_blades_buff)
					}
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
			}

			###
			### Throw Glaive Functions
			###
			AddFunction ThrowGlaive_Use
			{
					not SpellCooldown(throw_glaive_havoc)
				and not Talent(momentum_talent)
			}

			AddFunction ThrowGlaive_Use_Ranged
			{
					not SpellCooldown(throw_glaive_havoc)
				and {
							target.Distance() > 3
						 or CheckBoxOff(opt_range_check)
					}
			}

			AddFunction ThrowGlaive_Use_Bloodlet
			{
					not SpellCooldown(throw_glaive_havoc)
				and Talent(bloodlet_talent)
				and target.InPandemicRange(bloodlet_debuff bloodlet)
				and {
							not Talent(momentum_talent)
						 or BuffPresent(momentum_buff)
					}
			}

			###
			### Vengeful Retreat Functions
			###
			AddFunction VengefulRetreat_Use
			{
					not SpellCooldown(vengeful_retreat)
				and {
							{
									FuryDeficit() >= 85
								and Talent(prepared_talent)
								and not Talent(momentum_talent)
							}
						 or {
						 			Talent(momentum_talent)
						 		and not BuffPresent(momentum_buff)
							}
					}
			}

			###
			### General Functions
			###
			AddFunction MeleeRange_Use
			{
					CheckBoxOn(opt_melee_range)
				and target.Distance() > 3
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

			AddFunction DraughtOfSouls_Use
			{
					HasEquippedItem(draught_of_souls)
				and BuffPresent(metamorphosis_havoc_buff)
				and BuffRemaining(metamorphosis_havoc_buff) <= BaseDuration(felcrazed_rage_buff) + GCD()
				and {
							target.Distance() <= 10
						 or CheckBoxOff(opt_range_check)
					}
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					if target.RangeCheck(consume_magic) Spell(consume_magic)
					if target.RangeCheck(arcane_torrent_dh) Spell(arcane_torrent_dh)

					if not target.Classification(worldboss)
					{
						if target.RangeCheck(chaos_nova) Spell(chaos_nova)
					}
				}
			}

			###
			### Havoc - Main
			###
			AddFunction ShortCD
			{
				# Actions performed at range
				if Felblade_Use_Melee() Spell(felblade)
				if FelRush_Use_Melee() Spell(fel_rush)
				
				# Move to melee range if not in melee range, only if checkbox is enabled
				if MeleeRange_Use() Texture(misc_arrowlup help=L(not_in_melee_range))
			}
			
			AddFunction Main
			{
				if CheckBoxOn(opt_blur) and Blur_Use() Spell(blur)
				if CheckBoxOn(opt_metamorphosis) and Metamorphosis_Use_Melee() Spell(metamorphosis_havoc)
				if CheckBoxOn(opt_nemesis) and Nemesis_Use() Spell(nemesis)
				if CheckBoxOn(opt_metamorphosis) and Metamorphosis_Use() Spell(metamorphosis_havoc)
				if CheckBoxOn(opt_fel_rush) and FelRush_Use() Spell(fel_rush)
				if ThrowGlaive_Use_Ranged() Spell(throw_glaive_havoc)
				if CheckBoxOn(opt_vengeful_retreat) and VengefulRetreat_Use() Spell(vengeful_retreat)
				if CheckBoxOn(opt_chaos_blade) and Chaos_Blades_Use() Spell(chaos_blades)
				if CheckBoxOn(opt_fel_barrage) and FelBarrage_Use() Spell(fel_barrage)
				if CheckBoxOn(opt_fel_rush) and FelRush_Use_AOE() Spell(fel_rush)
				if CheckBoxOn(opt_fury_of_the_ilidari) and FuryOfTheIllidari_Use() Spell(fury_of_the_illidari)
				if CheckBoxOn(opt_eye_beam) and EyeBeam_Use() Spell(eye_beam)
				if BladeDance_Use() Spell(blade_dance)
				if DeathSweep_Use() Spell(death_sweep)
				if CheckBoxOn(opt_fel_eruption) and FelEruption_Use() Spell(fel_eruption)
				if ThrowGlaive_Use_Bloodlet() Spell(throw_glaive_havoc)
				if CheckBoxOn(opt_felblade) and Felblade_Use() Spell(felblade)
				if BladeDance_Use_FirstBlood() Spell(blade_dance)
				if DeathSweep_Use_FirstBlood() Spell(death_sweep)
				if Chaos_Strike_Use_AOE() Spell(chaos_strike)
				if Annihilation_Use_AOE() Spell(annihilation)
				if Chaos_Strike_Use() Spell(chaos_strike)
				if Annihilation_Use() Spell(annihilation)
				if ThrowGlaive_Use() Spell(throw_glaive_havoc)
				if CheckBoxOn(opt_felblade) and Felblade_Use_Dump() Spell(felblade)
				if CheckBoxOn(opt_fel_eruption) and FelEruption_Use_Dump() Spell(fel_eruption)
				if Demons_Bite_Use() Spell(demons_bite)
				if CheckBoxOn(opt_fel_rush) and FelRush_Use_Dump() Spell(fel_rush)
			}
			
			AddFunction CD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				# CD Actions
				if CheckBoxOff(opt_blur) and Blur_Use() Spell(blur)
				if CheckBoxOff(opt_metamorphosis) and Metamorphosis_Use_Melee() Spell(metamorphosis_havoc)
				if CheckBoxOff(opt_nemesis) and Nemesis_Use() Spell(nemesis)
				if CheckBoxOff(opt_metamorphosis) and Metamorphosis_Use() Spell(metamorphosis_havoc)
				if CheckBoxOff(opt_fel_rush) and FelRush_Use() Spell(fel_rush)
				if CheckBoxOff(opt_vengeful_retreat) and VengefulRetreat_Use() Spell(vengeful_retreat)
				if CheckBoxOff(opt_chaos_blade) and Chaos_Blades_Use() Spell(chaos_blades)
				if CheckBoxOff(opt_fel_barrage) and FelBarrage_Use() Spell(fel_barrage)
				if CheckBoxOff(opt_fel_rush) and FelRush_Use_AOE() Spell(fel_rush)
				if CheckBoxOff(opt_fury_of_the_ilidari) and FuryOfTheIllidari_Use() Spell(fury_of_the_illidari)
				if CheckBoxOff(opt_eye_beam) and EyeBeam_Use() Spell(eye_beam)
				if CheckBoxOff(opt_fel_eruption) and FelEruption_Use() Spell(fel_eruption)
				if CheckBoxOff(opt_felblade) and Felblade_Use() Spell(felblade)
				if CheckBoxOff(opt_felblade) and Felblade_Use_Dump() Spell(felblade)
				if CheckBoxOff(opt_fel_eruption) and FelEruption_Use_Dump() Spell(fel_eruption)
				if CheckBoxOff(opt_fel_rush) and FelRush_Use_Dump() Spell(fel_rush)

				# Standard Actions
				Rotation_ItemActions()
				if DraughtOfSouls_Use() Item(draught_of_souls)
				if LunaEclipse_Potion_Use() and Potion_Use() Item(potion_of_prolonged_power)
			}

			###
			### Havoc - Main_Precombat
			###
			AddFunction ShortCD_Precombat
			{		
				
			}

			AddFunction Main_Precombat
			{
				
			}

			AddFunction CD_Precombat
			{
				# Standard Actions
				if LunaEclipse_Potion_Use() Item(potion_of_prolonged_power)
			}

			###
			### Rotation icons.
			###
			AddIcon help=shortcd checkbox=opt_range_check
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

		OvaleScripts:RegisterScript("DEMONHUNTER", "havoc", name, desc, code, "script");
	end
end