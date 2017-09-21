local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;

	do
		local name = "lunaeclipse_global";
		local desc = "LunaEclipse: Global Functions";
		local code = [[
			# Global functions shared by all classes and specializations.
			Include(ovale_common)
			Include(ovale_trinkets_mop)
			Include(ovale_trinkets_wod)
			Include(lunaeclipse_legendaries)

			# Buff Spell Lists
			SpellList(legendary_ring_buff archmages_greater_incandescence_agi_buff archmages_greater_incandescence_int_buff archmages_greater_incandescence_str_buff archmages_incandescence_agi_buff archmages_incandescence_int_buff archmages_incandescence_str_buff)

			# Rings
			Define(gnawed_thumb_ring 134526)
				SpellInfo(gnawed_thumb_ring cd=180)
				SpellAddBuff(gnawed_thumb_ring taste_of_mana_buff=1)				

			Define(taste_of_mana_buff 228461)
				SpellInfo(taste_of_mana_buff duration=12)

			# Trinkets
			Define(convergence_of_fates 140806)
			Define(draught_of_souls 140808)
				SpellInfo(draught_of_souls cd=80)
				SpellAddBuff(draught_of_souls felcrazed_rage_buff=1)
			Define(whispers_in_the_dark 140809)

			Define(devils_due_buff 225776)
				SpellInfo(devils_due_buff duration=8)
			Define(felcrazed_rage_buff 225141)
				SpellInfo(felcrazed_rage_buff duration=3)
			Define(nefarious_pact_buff 225774)
				SpellInfo(nefarious_pact_buff duration=12)

			# Potions
			Define(ancient_healing_potion 127834)
				SpellInfo(ancient_healing_potion cd=60)
			Define(ancient_mana_potion 127835)
				SpellInfo(ancient_mana_potion cd=60)
			Define(leytorrent_potion 127846)
				SpellInfo(leytorrent_potion cd=60)
				SpellAddBuff(leytorrent_potion leytorrent_potion_buff=1)							
			Define(potion_of_deadly_grace 127843)
				SpellInfo(potion_of_deadly_grace cd=60)
				SpellAddBuff(potion_of_deadly_grace potion_of_deadly_grace_buff=1)							
			Define(potion_of_the_old_war 127844)
				SpellInfo(potion_of_the_old_war cd=60)
				SpellAddBuff(potion_of_the_old_war potion_of_the_old_war_buff=1)							
			Define(potion_of_prolonged_power 142117)
				SpellInfo(potion_of_prolonged_power cd=60)
				SpellAddBuff(potion_of_prolonged_power potion_of_prolonged_power_buff=1)							
			Define(unbending_potion 127845)
				SpellInfo(unbending_potion cd=60)
				SpellAddBuff(unbending_potion unbending_potion_buff=1)							

			# Potion Buffs
			Define(leytorrent_potion_buff 188028)
				SpellInfo(leytorrent_potion_buff duration=10)
			Define(potion_of_deadly_grace_buff 188028)
				SpellInfo(potion_of_deadly_grace_buff duration=25)
			Define(potion_of_the_old_war_buff 188028)
				SpellInfo(potion_of_the_old_war_buff duration=25)
			Define(potion_of_prolonged_power_buff 229206)
				SpellInfo(potion_of_prolonged_power_buff duration=60)
			Define(unbending_potion_buff 188029)
				SpellInfo(unbending_potion_buff duration=25)

			# Checkboxes
			AddCheckBox(opt_single_target "Display: Single Target Icon")
			AddCheckBox(opt_multi_dot "Display: Show Multi-DOT Icon" default)

			###
			### Bloodlust Functions
			###
			AddFunction LunaEclipse_Bloodlust_Used
			{
					BloodlustPercentage() >= 50
			}

			###
			### Potion Functions
			###
			AddFunction LunaEclipse_Potion_Use
			{
					CheckBoxOn(opt_potion) 
				and IsBossFight() 
				and not PotionCombatLockdown()
			}

			###
			### Item Functions
			###
			AddFunction Rotation_ItemActions
			{
				Item(HandSlot usable=1)
				Item(Trinket0Slot usable=1)
				Item(Trinket1Slot usable=1)
			}
		]];

		OvaleScripts:RegisterScript(nil, nil, name, desc, code, "include");
	end
end