local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;

	do
		local name = "lunaeclipse_legendaries";
		local desc = "LunaEclipse: Legendaries";
		local code = [[
			# All Classes Legendaries
			Define(sephuzs_secret 132452)
			Define(prydaz_xavarics_magnum_opus 132444)

			# All Classes Legendary Buffs
			Define(sephuzs_secret_buff 224166)
				SpellInfo(sephuzs_secret_buff buff_cd=30 duration=10 stat=haste)
			Define(xavarics_magnum_opus_buff 207472)

			# Shared Classes Legendaries
			Define(norgannons_foresight 132455)
			Define(cinidaria_the_symbiote 133976)
			Define(roots_of_shaladrassil 132466)
			Define(aggramars_stride 132443)
			Define(archimondes_hatred_reborn 144249)
			Define(kiljaedens_burning_wish 144259)
			Define(velens_future_sight 144258)

			# Shared Classes Legendary On-Use Abilities
			Define(archimondes_hatred_reborn_use 235169)
				SpellInfo(archimondes_hatred_reborn_use cd=75 duration=10)
			Define(kiljaedens_burning_wish_use 235991)
				SpellInfo(kiljaedens_burning_wish_use cd=75 duration=10)
			Define(velens_future_sight_use 235966)
				SpellInfo(velens_future_sight_use cd=75 duration=10)

			# Death Knight Legendaries
			Define(acherus_drapes 132376)
			Define(shackles_of_bryndaor 132365)
			Define(rattlegore_bone_legplates 132453)
			Define(service_of_gorefiend 132367)
			Define(lanathels_lament 133974)
			Define(skullflowers_haemostasis 144281)
			Define(seal_of_necrofantasia 137223)
			Define(koltiras_newfound_will 132366)
			Define(toravons_whiteout_bindings 132458)
			Define(perseverance_of_the_ebon_martyr 132459)
			Define(consorts_cold_core 144293)
			Define(taktheritrixs_shoulderpads 137075)
			Define(draugr_girdle_of_the_everlasting_king 132441)
			Define(uvanimor_the_unbeautiful 137037)
			Define(the_instructors_fourth_lesson 132448)
			Define(death_march 144280)
			
			# Death Knight Legendary Buffs
			Define(haemostasis_buff 235559)
				SpellInfo(haemostasis_buff max_stacks=5)
			Define(koltiras_newfound_will_buff 208783)
				SpellInfo(koltiras_newfound_will_buff runes=-2)
			Define(taktheritrixs_command_buff 215074)
			Define(draugr_girdle_of_the_everlasting_king_buff 224166)
				SpellInfo(draugr_girdle_of_the_everlasting_king_buff runes=-1)

			# Death Knight Legendary Debuffs
			Define(perseverance_of_the_ebon_martyr_debuff 216059)

			# Demon Hunter Legendaries
			Define(moarg_bionic_stabilizers 137090)
			Define(raddons_cascading_eyes 137061)
			Define(achor_the_eternal_hunger 137014)
			Define(loramus_thalipedes_sacrifice 137022)
			Define(anger_of_the_half_giants 137038)
			Define(delusions_of_grandeur 144279)
			Define(cloak_of_fel_flames 137066)
			Define(kirel_narak 138949)
			Define(runemasters_pauldrons 137071)
			Define(the_defilers_lost_vambraces 137091)
			Define(fragment_of_the_betrayers_prison 138854)
			Define(spirit_of_the_darkness_flame 144292)

			# Druid Legendaries
			Define(the_emerald_dreamcatcher 137062)
			Define(ailuro_pouncers 137024)
			Define(fiery_red_maimers 144354)

			# Druid Legendary Buffs
			Define(the_emerald_dreamcatcher_buff 224706)
				SpellInfo(the_emerald_dreamcatcher_buff max_stacks=2 duration=5)
			Define(oneths_intuition_buff 209406)
			Define(oneths_overconfidence_buff 209407)
				SpellRequire(starfall astralpower 0=buff,oneths_overconfidence_buff)
				SpellAddBuff(starfall oneths_overconfidence_buff=-1)
			Define(fiery_red_maimers_buff 212875)
			Define(starfall 191034)
			
			# Mage Legendaries
			Define(shard_of_the_exodar 132410)
			Define(belovirs_final_stand 133977)
			Define(rhonins_assaulting_armwraps 132413)
			Define(cord_of_infinity 132442)
			Define(mystic_kilt_of_the_rune_master 132451)
			Define(gravity_spiral 144274)
			Define(koralons_burning_touch 132454)
			Define(darcklis_dragonfire_diadem 132863)
			Define(marquee_bindings_of_the_sun_king 132406)
			Define(pyrotex_ignition_cloth 144355)
			Define(lady_vashjs_grasp 132411)
			Define(magtheridons_banished_bracers 138140)
			Define(zannesu_journey 133970)
			Define(ice_time 144260)
			
			# Mage Legendary Buffs
			Define(belovirs_final_stand_buff 207283)
				SpellInfo(belovirs_final_stand_buff duration=15)
			Define(rhonins_assaulting_armwraps_buff 208081)
				SpellInfo(rhonins_assaulting_armwraps_buff duration=6)
			Define(kaelthass_ultimate_ability_buff 209455)
				SpellInfo(kaelthass_ultimate_ability_buff duration=15)
			Define(lady_vashjs_grasp_buff 208147)
			Define(magtheridons_might_buff 214404)
				SpellInfo(magtheridons_might_buff duration=8 max_stacks=6)
			Define(zannesu_journey_buff 226852)
				SpellInfo(zannesu_journey_buff duration=30 max_stacks=5)

			# Warlock Legendaries
			Define(pillars_of_the_dark_portal 132357)
			Define(sacrolashs_dark_strike 132378)
			Define(power_cord_of_lethtendris 132457)
			Define(stretens_sleepless_shackles 132381)
			Define(hood_of_eternal_disdain 132394)
			Define(reap_and_sow 144364)
			Define(kazzaks_final_curse 132374)
			Define(wilfreds_sigil_of_superior_summoning 132369)
			Define(recurrent_ritual 132393)
			Define(sindorei_spite 132379)
			Define(wakeners_loyalty 144385)
			Define(alythesss_pyrogenics 132460)
			Define(odr_shawl_of_the_ymirjar 132375)
			Define(feretory_of_souls 132456)
			Define(magistrike_restraints 132407)
			Define(lessons_of_space_time 144369)
			
			# Warlock Legendary Buffs
			Define(recurrent_ritual_buff 214811)
				SpellInfo(recurrent_ritual_buff soulshards=-2)
			Define(sindorei_spite_buff 208871)
				SpellInfo(sindorei_spite_buff duration=25)	
			Define(odr_shawl_of_the_ymirjar_buff 212173)
			Define(fiery_soul_buff 205704)
				SpellInfo(fiery_soul_buff soulshards=-1)
			Define(lessons_of_space_time_buff 236176)

			# Warrior Legendaries
			Define(weight_of_the_earth 137077)
			Define(archavons_heavy_hand 137060)
			Define(fujiedas_fury 137053)

			# Warrior Legendary Buffs
			Define(archavons_heavy_hand_spell 205144)
			Define(fujiedas_fury_buff 207776)
				SpellInfo(fujiedas_fury_buff duration=6)
				SpellAddBuff(bloodthirst fujiedas_fury_buff=1 if_spell=fujiedas_fury_buff)
			Define(bloodthirst 23881)
		]];

		OvaleScripts:RegisterScript(nil, nil, name, desc, code, "include");
	end
end