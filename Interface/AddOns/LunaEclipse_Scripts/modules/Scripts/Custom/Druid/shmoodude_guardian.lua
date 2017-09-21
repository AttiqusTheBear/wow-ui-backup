local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "shmoodude_druid_guardian";
		local desc = "ShmooDude: Guardian Druid";

		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DRUID_GUARDIAN,
			ScriptAuthor = "ShmooDude",
			GuideLink = "http://fluiddruid.net/forum/viewtopic.php?f=3&t=5709",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
		};

		local code = [[
			# Guardian Script
			# Greenjeans/Dhol deserves credit for most of the options added

			Include(ovale_common)
			Include(ovale_trinkets_mop)
			Include(ovale_trinkets_wod)
			Include(ovale_druid_spells)

			AddCheckBox(opt_interrupt L(interrupt) default specialization=guardian)
			AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=guardian)
			AddCheckBox(opt_catweave "Suggest CatWeaving rotation" specialization=guardian)
			AddCheckBox(opt_incapacitate "Suggest Roar on CD (Sephuz's)" specialization=guardian)

			AddListItem(opt_rotation mit "Max Mitigation rotation" specialization=guardian)
			AddListItem(opt_rotation hyb "Hybrid rotation" specialization=guardian default)
			AddListItem(opt_rotation dps "Max DPS rotation" specialization=guardian)
			AddListItem(opt_rotation dpsm "Max DPS rotation with Maul" specialization=guardian)

			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_1 "FR: 1 (lower is more agressive)" specialization=guardian)
			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_2 "FR: 2 (lower is more agressive)" specialization=guardian)
			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_3 "FR: 3 (lower is more agressive)" specialization=guardian)
			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_4 "FR: 4 (lower is more agressive)" specialization=guardian)
			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_5 "FR: 5 (lower is more agressive)" specialization=guardian default)
			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_6 "FR: 6 (lower is more agressive)" specialization=guardian)
			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_7 "FR: 7 (lower is more agressive)" specialization=guardian)
			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_8 "FR: 8 (lower is more agressive)" specialization=guardian)
			AddListItem(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_9 "FR: 9 (lower is more agressive)" specialization=guardian)

			AddFunction FrenziedRegenerationAgressiveness asvalue=1
			{
				unless List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_5)
				{
					if List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_1) 0.1
					if List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_2) 0.2
					if List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_3) 0.3
					if List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_4) 0.4
					if List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_6) 0.6
					if List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_7) 0.7
					if List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_8) 0.8
					if List(opt_frenzied_regeneration_aggressiveness frenzied_regeneration_9) 0.9
				}
				0.5 
			}


			AddFunction GuardianUseItemActions
			{
				Item(Trinket0Slot usable=1)
				Item(Trinket1Slot usable=1)
			}

			AddFunction GuardianGetInMeleeRange
			{
				if CheckBoxOn(opt_melee_range) and Stance(druid_bear_form) and not target.InRange(mangle) or Stance(druid_cat_form) and not target.InRange(shred)
				{
					if target.InRange(wild_charge) Spell(wild_charge)
					Texture(misc_arrowlup help=L(not_in_melee_range))
				}
			}

			AddFunction GuardianInterruptActions
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					if target.InRange(skull_bash) Spell(skull_bash)
					if not target.Classification(worldboss)
					{
						if target.InRange(mighty_bash) Spell(mighty_bash)
						Spell(typhoon)
						if target.InRange(maim) Spell(maim)
						Spell(war_stomp)
					}
				}
			}

			### actions.default

			AddFunction GuardianDefaultMainActions
			{
				if Stance(druid_bear_form) 
				{
					# Pulverize for the buff, drop pulverize at 6 targets if using dps/dpsm rotation
					if BuffExpires(pulverize_buff) and target.DebuffGain(thrash_bear_debuff) <= BaseDuration(thrash_bear_debuff) and not { { List(opt_rotation dps) or List(opt_rotation dpsm) } and Enemies() >= 6 } Spell(pulverize) 

					# Pulverize regardless of the buff at less than 6 targets if using dps/dpsm rotation
					if { List(opt_rotation dps) or List(opt_rotation dpsm) } and Enemies() < 6 and target.DebuffStacks(thrash_bear_debuff) >= 3 Spell(pulverize)

					# If RnT, Thrash if there's less than 3 stacks or it's about to drop soon, or if not using mit rotation and there's 2 or more targets
					if { Talent(rend_and_tear_talent) or not List(opt_rotation mit) }
						and { target.DebuffStacks(thrash_bear_debuff) < 3 or target.DebuffRemaining(thrash_bear_debuff) < 4.5 or not List(opt_rotation mit) and Enemies() >= 2 } Spell(thrash_bear)

					# Mangle if Gore is up
					if BuffPresent(gory_fur_buff) and not { { List(opt_rotation dps) or List(opt_rotation dpsm) } and Enemies() >= 4 } Spell(mangle)

					# Moonfire if GG is up, drop at 3 targets if using dps/dpsm rotation
					if BuffPresent(galactic_guardian_buff) 
						and not { { List(opt_rotation dps) or List(opt_rotation dpsm) } and Enemies() >=3 } Spell(moonfire)

					# Swipe if not using mit rotation and there's 4 or more targets
					if Enemies() >= 4 and not List(opt_rotation mit) Spell(swipe_bear)

					# Mangle, drop at 4 targets if using dps/dpsm rotation
					if not { { List(opt_rotation dps) or List(opt_rotation dpsm) } and Enemies() >= 4 } Spell(mangle)

					# Pulverize for the buff if it's dropping soon, drop pulverize at 6 targets if using dps/dpsm rotation
					if BuffRemaining(pulverize_buff) < GCD() 
						and target.DebuffGain(thrash_bear_debuff) <= BaseDuration(thrash_bear_debuff) and not { { List(opt_rotation dps) or List(opt_rotation dpsm) } and Enemies() >= 6 } Spell(pulverize)

					# Thrash
					Spell(thrash_bear)

					# Pulverize for the buff if it's going to drop and there's nothing better to do, drop pulverize at 6 targets if using dps/dpsm rotation
					if BuffRemaining(pulverize_buff) < 3.6 
						and target.DebuffGain(thrash_bear_debuff) <= BaseDuration(thrash_bear_debuff) and not { { List(opt_rotation dps) or List(opt_rotation dpsm) } and Enemies() >= 6 } Spell(pulverize) 

					# Moofire if it's not up
					if target.DebuffExpires(moonfire_debuff) Spell(moonfire) 
				}
    
				if CheckBoxOn(opt_catweave) and not target.IsAggroed() and Talent(feral_affinity_talent) GuardianCatWeaveActions()
    
				if Stance(druid_bear_form) 
				{
					# Swipe
					Spell(swipe_bear)
				}
			}

			AddFunction GuardianCatWeaveActions
			{
				Spell(cat_form)
				if ComboPoints() >= 1 and target.DebuffRemaining(rip_debuff) < BaseDuration(rip_debuff) * 0.3 - 1 and target.HealthPercent() < 25 Spell(ferocious_bite) 
				if ComboPoints() == 5 
				{
					if { Energy() > 50 or target.DebuffRemaining(rip_debuff) < BaseDuration(rip_debuff) * 0.3 } and target.HealthPercent() < 25 Spell(ferocious_bite) 
					if target.DebuffExpires(rip_debuff) or target.DebuffRemaining(rip_debuff) < BaseDuration(rip_debuff) * 0.3 + 5 Spell(rip)
					if Energy() > 50 and target.DebuffRemaining(rip_debuff) > 15 Spell(ferocious_bite)
				}
				if target.DebuffExpires(rake_debuff) or target.DebuffRemaining(rake_debuff) < BaseDuration(rake_debuff) * 0.3 + 3 Spell(rake) 
				Spell(shred)
				if Energy() < 30 and not target.DebuffExpires(rip_debuff) and not target.DebuffExpires(rake_debuff) Spell(bear_form)
			}

			AddFunction GuardianDefaultShortCdActions
			{
				GuardianGetInMeleeRange()

				# Ironfur if has aggro and there's been physical damage in the last 10 seconds and ironfur isn't up or rage is about to cap, and not using dpsm rotation
				if target.IsAggroed() 
					and IncomingDamage(10 physical=1) 
					and { BuffExpires(ironfur_buff) or RageDeficit() < 25 } 
					and not List(opt_rotation dpsm) Spell(ironfur)

				# Maul if not using mit rotation and not aggroed and about to cap on rage
				if not target.IsAggroed() 
					and RageDeficit() < 25 
					and not List(opt_rotation mit) Spell(maul)

				# Maul if using dpsm rotation and about to cap on rage
				if RageDeficit() < 25
					and List(opt_rotation dpsm) Spell(maul)

				# Suggest incapacitating roar on CD.  This is for Sephuz's buff, but the gear check HasEquippedItem(sephuzs_secret) wasn't working
				if CheckBoxOn(opt_incapacitate) and HasEquippedItem(sephuzs_secret) Spell(incapacitating_roar)

				# Frenzied regen, if it's not up, and....something.  Math.
				if BuffExpires(frenzied_regeneration_buff)
					and IncomingDamage(5) / MaxHealth() + { 100 - HealthPercent() } / 100 > FrenziedRegenerationAgressiveness() + { SpellMaxCharges(frenzied_regeneration) - Charges(frenzied_regeneration count=0) } * 0.20 Spell(frenzied_regeneration)

				# Bristling fur, if ironfur is about to expire and you're low on rage.
				if BuffRemaining(ironfur_buff) < 2 
					and Rage() < 40 Spell(bristling_fur)
			}

			AddFunction GuardianDefaultCdActions
			{
				#skull_bash
				GuardianInterruptActions()
				#blood_fury
				Spell(blood_fury_apsp)
				#berserking
				Spell(berserking)
				#arcane_torrent
				Spell(arcane_torrent_energy)
				#use_item,slot=trinket2
				GuardianUseItemActions()
				Spell(incarnation_guardian_of_ursoc)
				Spell(rage_of_the_sleeper)
				Spell(barkskin)
				Spell(survival_instincts)

			   # unless { BuffExpires(ironfur_buff) or RageDeficit() < 25 } and Spell(ironfur) 
			   #    or BuffExpires(frenzied_regeneration_buff) and IncomingDamage(6) / MaxHealth() > 0.25 + { 2 - Charges(frenzied_regeneration count=0) } * 0.15 and Spell(frenzied_regeneration) 
			   #    or BuffExpires(pulverize_buff) and target.DebuffGain(thrash_bear_debuff) <= BaseDuration(thrash_bear_debuff) and Spell(pulverize) 
			   #    or target.DebuffRemaining(thrash_bear_debuff) < 4.5 and Spell(thrash_bear) 
			   #    or Spell(mangle) 
			   #    or BuffRemaining(pulverize_buff) < GCD() and target.DebuffGain(thrash_bear_debuff) <= BaseDuration(thrash_bear_debuff) and Spell(pulverize)
			   # {
			   #     #incarnation
			   #     Spell(incarnation_guardian_of_ursoc)
			   # }
			}

			### actions.precombat

			AddFunction GuardianPrecombatMainActions
			{
				#flask,type=flask_of_the_seventh_demon
				#food,type=azshari_salad
				#bear_form
				Spell(bear_form)
			}

			AddFunction GuardianPrecombatShortCdPostConditions
			{
				Spell(bear_form)
			}

			AddFunction GuardianPrecombatCdPostConditions
			{
				Spell(bear_form)
			}

			### Guardian icons.

			AddCheckBox(opt_druid_guardian_aoe L(AOE) default specialization=guardian)

			AddIcon checkbox=!opt_druid_guardian_aoe enemies=1 help=shortcd specialization=guardian
			{
				unless not InCombat() and GuardianPrecombatShortCdPostConditions()
				{
					GuardianDefaultShortCdActions()
				}
			}

			AddIcon checkbox=opt_druid_guardian_aoe help=shortcd specialization=guardian
			{
				unless not InCombat() and GuardianPrecombatShortCdPostConditions()
				{
					GuardianDefaultShortCdActions()
				}
			}

			AddIcon enemies=1 help=main specialization=guardian
			{
				if not InCombat() GuardianPrecombatMainActions()
				GuardianDefaultMainActions()
			}

			AddIcon checkbox=opt_druid_guardian_aoe help=aoe specialization=guardian
			{
				if not InCombat() GuardianPrecombatMainActions()
				GuardianDefaultMainActions()
			}

			AddIcon checkbox=!opt_druid_guardian_aoe enemies=1 help=cd specialization=guardian
			{
				unless not InCombat() and GuardianPrecombatCdPostConditions()
				{
					GuardianDefaultCdActions()
				}
			}

			AddIcon checkbox=opt_druid_guardian_aoe help=cd specialization=guardian
			{
				unless not InCombat() and GuardianPrecombatCdPostConditions()
				{
					GuardianDefaultCdActions()
				}
			}

			### Required symbols
			# arcane_torrent_energy
			# bear_form
			# berserking
			# blood_fury_apsp
			# bristling_fur
			# frenzied_regeneration
			# frenzied_regeneration_buff
			# galactic_guardian_buff
			# incarnation_guardian_of_ursoc
			# ironfur
			# ironfur_buff
			# thrash_bear_debuff
			# maim
			# mangle
			# mighty_bash
			# moonfire
			# moonfire_debuff
			# pulverize
			# pulverize_buff
			# shred
			# skull_bash
			# swipe_bear
			# thrash_bear
			# thrash_bear_debuff
			# typhoon
			# war_stomp
			# wild_charge
		]];
	
		OvaleScripts:RegisterScript("DRUID", "guardian",  name, desc, code, "script");
	end
end