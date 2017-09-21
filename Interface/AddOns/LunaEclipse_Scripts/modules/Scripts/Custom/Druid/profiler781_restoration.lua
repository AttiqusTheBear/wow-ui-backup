local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "profiler781_druid_restoration";
		local desc = "Profiler781: Restoration Druid";
	
		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DRUID_RESTORATION,
			ScriptAuthor = "Profiler781",
			GuideAuthor = "Vlad",
			GuideLink = "http://www.icy-veins.com/wow/restoration-druid-pve-healing-guide",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
			["Tank Healing"] = "2233332",
			["Raid Healing"] = "1233313",
			["Dungeons / Mythic+"] = "1223332",
			["Catweaving"] = "1321122",
			["Easy Mode"] = "1213321",
		};

		local code = [[
			# Restoration Druid rotation functions based on Guide written by Gamko: http://www.icy-veins.com/wow/restoration-druid-pve-healing-guide

			Include(lunaeclipse_druid_spells)
			Include(lunaeclipse_global)

			# Checkboxes
			AddCheckBox(opt_rooted "Other: Morph if rooted" default)
			AddCheckBox(opt_single_buff "CD: Ghanir/Flourish S. Target" default)
			AddCheckBox(opt_efflorescence "CD: Efflorescence" default)
			AddCheckBox(opt_major_cd "CD: Major CD for Bosses")
			AddCheckBox(opt_catweaving "Icon: Catweaving Rotation")
			AddCheckBox(opt_healing "Icon: Healing Rotation" default)

			###
			### Artifact Functions
			###
			AddFunction EssenceOfGhanir_Available
			{
					SpellKnown(essence_of_ghanir)
				and not SpellCooldown(essence_of_ghanir)
			}

			AddFunction EssenceOfGhanir_Use
			{
					EssenceOfGhanir_Available()
				and {
							BuffRemainingOnAny(wildgrowth_buff) >= BaseDuration(wildgrowth_buff) - GCD() * 2
						 or {
						 			CheckBoxOn(opt_single_buff)
						 		and BuffRemainingOnAny(lifebloom_buff) >= GCD()
						 		and BuffRemainingOnAny(rejuvenation_buff) >= GCD()
						 		and BuffRemainingOnAny(regrowth_buff) >= GCD()
						 		and {
						 					not Talent(germination_talent)
						 				 or BuffRemainingOnAny(germination_buff) >= GCD()
						 			}
						 	}
					}
			}

			###
			### Bear Form Functions
			###
			AddFunction BearForm_Use
			{
					not SpellCooldown(bear_form)
				and not BuffPresent(bear_form_buff)
			}

			###
			### Cat Form Functions
			###
			AddFunction CatForm_Use
			{
					not SpellCooldown(cat_form)
				and not BuffPresent(cat_form_buff)
				and TimeToMaxEnergy() <= GCD() * 2
			}

			###
			### Cenarion Ward Functions
			###
			AddFunction CenarionWard_Use
			{
					not SpellCooldown(cenarion_ward)
				and Talent(cenarion_ward_talent)
				and not target.BuffPresent(cenarion_ward_buff)
			}

			###
			### Efflorescence Functions
			###
			AddFunction Efflorescence_Use
			{
					not SpellCooldown(efflorescence)
				and {
							TimeSincePreviousSpell(efflorescence) > BaseDuration(efflorescence_buff) - GCD()
						 or {
									TimeSincePreviousSpell(efflorescence) > 5
								and BuffCountOnAny(spring_blossom_buff) == 0
								and Talent(spring_blossom_talent)
							}
					}
				and CheckBoxOn(opt_efflorescence)
			}


			###
			### Ferocious Bite Functions
			###
			AddFunction FerociousBite_Use
			{
					not SpellCooldown(ferocious_bite)
				and BuffPresent(cat_form_buff)
				and ComboPoints() >= 5
				and Energy() >= 50
				and Enemies() < 4
			}

			###
			### Flourish Functions
			###
			AddFunction Flourish_Use
			{
					not SpellCooldown(flourish)
				and Talent(flourish_talent)
				and IsBossFight()
				and {
							BuffRemainingOnAny(wildgrowth_buff) >= GCD()
						 or {
						 			CheckBoxOn(opt_single_buff)
						 		and BuffRemainingOnAny(lifebloom_buff) >= GCD()
						 		and BuffRemainingOnAny(rejuvenation_buff) >= GCD()
						 		and BuffRemainingOnAny(regrowth_buff) >= GCD()
						 		and {
						 					not Talent(germination_talent)
						 				 or BuffRemainingOnAny(germination_buff) >= GCD()
						 			}
						 	}
					}
			}

			###
			### Healing Touch Functions
			###
			AddFunction HealingTouch_Use
			{
					not SpellCooldown(healing_touch)
			}

			###
			### Innervate Functions
			###
			AddFunction Innervate_Use
			{
					not SpellCooldown(innervate)
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
			}

			###
			### Ironbark Functions
			###
			AddFunction Ironbark_Use
			{
					not SpellCooldown(ironbark)
				and not target.BuffPresent(ironbark_buff)
			}

			###
			### Lifebloom Functions
			###
			AddFunction Lifebloom_Use
			{
					not SpellCooldown(lifebloom)
				and BuffRemainingOnAny(lifebloom_buff) <= BaseDuration(lifebloom_buff) * 0.3
			}

			###
			### Moonfire Functions
			###
			AddFunction Moonfire_Use
			{
					not SpellCooldown(moonfire)
				and {
							target.InPandemicRange(moonfire_debuff moonfire)
						 or not target.DebuffPresent(moonfire_debuff)
					}
				and not BuffPresent(prowl_buff)
				and {
							not BuffPresent(cat_form_buff)
						 or Energy() < 40
					}
				and Enemies() < 4
				and target.TimeToDie() >= 6
			}

			AddFunction Moonfire_Use_Other
			{
					not SpellCooldown(moonfire)
				and not BuffPresent(prowl_buff)
				and {
							not BuffPresent(cat_form_buff)
						 or Energy() < 40
					}
				and target.DebuffPresent(moonfire_debuff)
				and DOTTargetCount(moonfire_debuff) < MultiDOTTargets()
				and Enemies() < 4
			}

			###
			### Prowl Functions
			###
			AddFunction Prowl_Use
			{
					not SpellCooldown(prowl)
				and BuffPresent(cat_form_buff)
				and not BuffPresent(prowl_buff)
			}

			###
			### Rake Functions
			###
			AddFunction Rake_Use
			{
					not SpellCooldown(rake)
				and {
							target.InPandemicRange(rake_debuff rake)
						 or not target.DebuffPresent(rake_debuff)
					}
				and BuffPresent(cat_form_buff)
				and PersistentMultiplier(rake_debuff) >= target.DebuffPersistentMultiplier(rake_debuff)
				and ComboPoints() < 5
				and target.TimeToDie() >= 6
				and Enemies() < 4
			}

			AddFunction Rake_Use_Other
			{
					not SpellCooldown(rake)
				and BuffPresent(cat_form_buff)
				and target.DebuffPresent(rake_debuff)
				and DOTTargetCount(rake_debuff) < MultiDOTTargets()
				and ComboPoints() < 5
				and Enemies() < 4
			}

			###
			### Regrowth Functions
			###
			AddFunction Regrowth_Use
			{
					not SpellCooldown(regrowth)
				and BuffRemainingOnAny(regrowth_buff) <= BaseDuration(regrowth_buff) * 0.3
			}

			AddFunction Regrowth_Use_OmenOfClarity
			{
					not SpellCooldown(regrowth)
				and Buffstacks(omen_of_clarity_buff) >= 1
			}

			###
			### Rejuvenation Functions
			###
			AddFunction Rejuvenation_Use
			{
					not SpellCooldown(rejuvenation)
				and BuffRemainingOnAny(rejuvenation_buff) <= BaseDuration(rejuvenation_buff) * 0.3
			}

			AddFunction Rejuvenation_Use_Germination
			{
					not SpellCooldown(rejuvenation)
				and Talent(germination_talent)
				and BuffRemainingOnAny(germination_buff) <= BaseDuration(germination_buff) * 0.3
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
							not target.DebuffPresent(rip_debuff)
						 or {
						 			target.InPandemicRange(rip_debuff rip)
						 		and target.HealthPercent() >= 25
							}
					}
				and BuffPresent(cat_form_buff)
				and ComboPoints() >= 5
				and target.TimeToDie() >= 10
				and Enemies() < 4
			}

			###
			### Shred Functions
			###
			AddFunction Shred_Use
			{
					not SpellCooldown(shred)
				and BuffPresent(cat_form_buff)
				and ComboPoints() < 5
			}

			###
			### Sunfire Functions
			###
			AddFunction Sunfire_Use
			{
					not SpellCooldown(sunfire)
				and {
							target.InPandemicRange(sunfire_debuff sunfire)
						 or not target.DebuffPresent(sunfire_debuff)
					}
				and not BuffPresent(prowl_buff)
				and {
							not BuffPresent(cat_form_buff)
						 or Energy() < 40
					}
				and target.TimeToDie() >= 6
			}

			AddFunction Sunfire_Use_Other
			{
					not SpellCooldown(sunfire)
				and not BuffPresent(prowl_buff)
				and {
							not BuffPresent(cat_form_buff)
						 or Energy() < 40
					}
				and target.DebuffPresent(sunfire_debuff)
				and DOTTargetCount(sunfire_debuff) < Enemies() * 0.7
			}

			###
			### Swiftmend Functions
			###
			AddFunction Swiftmend_Use
			{
					not SpellCooldown(swiftmend)
			}

			AddFunction Swiftmend_Use_Wildgrowth
			{
					not SpellCooldown(swiftmend)
				and SpellCooldown(wildgrowth) <= GCD()
				and Talent(soul_of_the_forest_talent)
			}

			###
			### Swipe Functions
			###
			AddFunction Swipe_Bear_Use
			{
					not SpellCooldown(swipe_bear)
				and BuffPresent(bear_form_buff)
			}

			AddFunction Swipe_Cat_Use
			{
					not SpellCooldown(swipe_cat)
				and BuffPresent(cat_form_buff)
				and Enemies() > 1
				and {
							ComboPoints() < 5
						 or Enemies() > 3
					}
			}

			###
			### Tree of Life Functions
			###
			AddFunction TreeOfLife_Use
			{
					not SpellCooldown(incarnation_tree_of_life)
				and Talent(incarnation_talent)
				and not BuffPresent(incarnation_tree_of_life_buff)
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
			}

			###
			### Tranquility Functions
			###
			AddFunction Tranquility_Use
			{
					not SpellCooldown(tranquility)
				and {
							IsBossFight()
						 or CheckBoxOff(opt_major_cd)
					}
			}

			###
			### Wild Charge Functions
			###
			AddFunction WildCharge_Use
			{
					not SpellCooldown(wild_charge_cat)
				and CheckBoxOn(opt_melee_range)
				and not target.RangeCheck(shred)
			}

			###
			### Wildgrowth Functions
			###
			AddFunction Wildgrowth_Use
			{
					not SpellCooldown(wildgrowth)
			}

			###
			### Interrupt Rotation
			###
			AddFunction Rotation_Interrupt
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					if target.RangeCheck(solar_beam) Spell(solar_beam)
					if target.RangeCheck(skull_bash) Spell(skull_bash)

					if not target.Classification(worldboss)
					{
						if target.RangeCheck(mighty_bash) Spell(mighty_bash)
						Spell(typhoon)
						if target.RangeCheck(maim) Spell(maim)
						Spell(war_stomp)
					}
				}
			}

			###
			### Rooted Rotation
			###
			AddFunction Rotation_Rooted
			{
				if isRooted() and CheckBoxOn(opt_rooted) Spell(bear_form)
				if isRooted() and CheckBoxOn(opt_rooted) Spell(cat_form)
			}		

			###
			### Restoration - Main
			###
			AddFunction CD
			{
				Rotation_Rooted()
				if Renewal_Use() Spell(renewal)
				if CenarionWard_Use() Spell(cenarion_ward)
				if Swiftmend_Use() Spell(swiftmend)
				if Ironbark_Use() Spell(ironbark)
			}
			
			AddFunction Main
			{
				if Lifebloom_Use() Spell(lifebloom)
				if Regrowth_Use_OmenOfClarity() Spell(regrowth)
				if Rejuvenation_Use() Spell(rejuvenation)
				if Rejuvenation_Use_Germination() Spell(rejuvenation)
				if Regrowth_Use() Spell(regrowth)
				if HealingTouch_Use() Spell(healing_touch)
			}

			AddFunction AOE
			{
				if Efflorescence_Use() Spell(efflorescence)
				if Swiftmend_Use_Wildgrowth() Spell(swiftmend)
				if Wildgrowth_Use() Spell(wildgrowth)
			}
			
			AddFunction AOECD
			{
				# Interrupt Actions
				Rotation_Interrupt()

				if Flourish_Use() Spell(flourish)
				if EssenceOfGhanir_Use() Spell(essence_of_ghanir)
				if Tranquility_Use() Spell(tranquility)
				if TreeOfLife_Use() Spell(incarnation_tree_of_life)
				if Innervate_Use() Spell(innervate)
			}

			AddFunction Catweaving
			{
				# No form rotation
				if Moonfire_Use() Spell(moonfire)
				if Sunfire_Use() Spell(sunfire)

				# Cat form rotation
				if CatForm_Use() Spell(cat_form)
				if WildCharge_Use() Spell(wild_charge_cat)
				if Rake_Use() Spell(rake)
				if CheckboxOff(opt_multi_dot) and Rake_Use_Other() Spell(rake text=other)
				if Rip_Use() Spell(rip)
				if FerociousBite_Use() Spell(ferocious_bite)
				if Swipe_Cat_Use() Spell(swipe_cat)
				if Shred_Use() Spell(shred)

				# Bear form rotation
				if BearForm_Use() Spell(bear_form)
				if Swipe_Bear_Use() Spell(swipe_bear)
			}

			AddFunction MultiDot
			{
				if Moonfire_Use_Other() Spell(moonfire text=other)
				if Sunfire_Use_Other() Spell(sunfire text=other)
				if Rake_Use_Other() Spell(rake text=other)
			}

			###
			### Restoration - Main_Precombat
			###
			AddFunction CD_Precombat
			{		
				
			}

			AddFunction Main_Precombat
			{
				
			}

			AddFunction PrecombatAOE
			{
				
			}

			AddFunction PrecombatAOECD
			{
				
			}

			AddFunction PrecombatCatweaving
			{
				if CatForm_Use() Spell(cat_form)
				if Prowl_Use() Spell(prowl)
			}

			AddFunction MultiDot_Precombat
			{
				
			}

			### Restoration icons.
			AddIcon checkbox=opt_healing help=shortcd
			{
				if not InCombat() CD_Precombat()
				CD()
			}

			AddIcon checkbox=opt_healing help=main
			{
				if not InCombat() Main_Precombat()
				Main()
			}

			AddIcon checkbox=opt_healing help=aoe
			{
				if not InCombat() PrecombatAOE()
				AOE()
			}

			AddIcon checkbox=opt_healing help=cd
			{
				if not InCombat() PrecombatAOECD()
				AOECD()
			}

			AddIcon checkbox=opt_catweaving checkbox=opt_single_target enemies=1 help=main
			{
				if not InCombat() PrecombatCatweaving()
				Catweaving()
			}

			AddIcon checkbox=opt_catweaving help=aoe
			{
				if not InCombat() PrecombatCatweaving()
				Catweaving()
			}

			AddIcon checkbox=opt_catweaving checkbox=opt_multi_dot help=multidot
			{
				if not InCombat() MultiDot_Precombat()
				MultiDot()
			}
		]];

		OvaleScripts:RegisterScript("DRUID", "restoration", name, desc, code, "script");
	end
end