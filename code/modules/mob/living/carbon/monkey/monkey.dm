/mob/living/carbon/monkey
	name = "monkey"
	voice_name = "monkey"
	speak_emote = list("chimpers")
	icon_state = "monkey1"
	icon = 'icons/mob/monkey.dmi'
	gender = NEUTER
	pass_flags = PASSTABLE
	update_icon = 0		///no need to call regenerate_icon
	ventcrawler = 1
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE
	var/warning_high_pressure = WARNING_HIGH_PRESSURE
	var/warning_low_pressure = WARNING_LOW_PRESSURE
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE
	var/blood_datum = /datum/dirt_cover/red_blood
	var/obj/item/weapon/card/id/wear_id = null // Fix for station bounced radios -- Skie
	var/greaterform = HUMAN                  // Used when humanizing a monkey.
	icon_state = "monkey1"
	//var/uni_append = "12C4E2"                // Small appearance modifier for different species.
	var/list/uni_append = list(0x12C,0x4E2)    // Same as above for DNA2.
	var/update_muts = 1                        // Monkey gene must be set at start.
	var/race = HUMAN // Used for restrictions checking.
	holder_type = /obj/item/weapon/holder/monkey
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/monkey = 5)

/mob/living/carbon/monkey/tajara
	name = "farwa"
	voice_name = "farwa"
	speak_emote = list("mews")
	icon_state = "tajkey1"
	uni_append = list(0x0A0,0xE00) // 0A0E00
	race = TAJARAN
	holder_type = /obj/item/weapon/holder/monkey/farwa

/mob/living/carbon/monkey/skrell
	name = "neaera"
	voice_name = "neaera"
	speak_emote = list("squicks")
	icon_state = "skrellkey1"
	uni_append = list(0x01C,0xC92) // 01CC92
	metabolism_factor = SKRELL_METABOLISM_FACTOR
	race = SKRELL
	holder_type = /obj/item/weapon/holder/monkey/neaera
	blood_datum = /datum/dirt_cover/purple_blood

/mob/living/carbon/monkey/unathi
	name = "stok"
	voice_name = "stok"
	speak_emote = list("hisses")
	icon_state = "stokkey1"
	uni_append = list(0x044,0xC5D) // 044C5D
	race = UNATHI
	holder_type = /obj/item/weapon/holder/monkey/stok

/mob/living/carbon/monkey/atom_init()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	if(name == initial(name)) //To stop Pun-Pun becoming generic.
		name = "[name] ([rand(1, 1000)])"
		real_name = name

	if (!(dna))
		if(gender == NEUTER)
			gender = pick(MALE, FEMALE)
		dna = new /datum/dna( null )
		dna.real_name = real_name
		dna.ResetSE()
		dna.ResetUI()
		//dna.uni_identity = "00600200A00E0110148FC01300B009"
		//dna.SetUI(list(0x006,0x002,0x00A,0x00E,0x011,0x014,0x8FC,0x013,0x00B,0x009))
		//dna.struc_enzymes = "43359156756131E13763334D1C369012032164D4FE4CD61544B6C03F251B6C60A42821D26BA3B0FD6"
		//dna.SetSE(list(0x433,0x591,0x567,0x561,0x31E,0x137,0x633,0x34D,0x1C3,0x690,0x120,0x321,0x64D,0x4FE,0x4CD,0x615,0x44B,0x6C0,0x3F2,0x51B,0x6C6,0x0A4,0x282,0x1D2,0x6BA,0x3B0,0xFD6))
		dna.unique_enzymes = md5(name)

		// We're a monkey
		dna.SetSEState(MONKEYBLOCK,   1)
		dna.SetSEValueRange(MONKEYBLOCK,0xDAC, 0xFFF)
		// Fix gender
		dna.SetUIState(DNA_UI_GENDER, gender != MALE, 1)

		// Set the blocks to uni_append, if needed.
		if(uni_append.len>0)
			for(var/b=1;b<=uni_append.len;b++)
				dna.SetUIValue(DNA_UI_LENGTH-(uni_append.len-b),uni_append[b], 1)
		dna.UpdateUI()

		update_muts=1

	. = ..()

	update_icons()

/mob/living/carbon/monkey/unathi/atom_init()

	. = ..()
	dna.mutantrace = "lizard"
	greaterform = UNATHI
	add_language("Sinta'unathi")

/mob/living/carbon/monkey/skrell/atom_init()

	. = ..()
	dna.mutantrace = "skrell"
	greaterform = SKRELL
	add_language("Skrellian")

/mob/living/carbon/monkey/tajara/atom_init()

	. = ..()
	dna.mutantrace = "tajaran"
	greaterform = TAJARAN
	add_language("Siik'tajr")

/mob/living/carbon/monkey/diona/atom_init()

	. = ..()
	gender = NEUTER
	dna.mutantrace = "plant"
	greaterform = DIONA
	add_language("Rootspeak")

/mob/living/carbon/monkey/diona/movement_delay()
	return ..(tally = 3.5)

/mob/living/carbon/monkey/movement_delay(tally = 0)
	if(reagents && reagents.has_reagent("hyperzine") || reagents.has_reagent("nuka_cola"))
		return -1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45) tally += (health_deficiency / 25)

	if(pull_debuff)
		tally += pull_debuff

	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75
	return tally+config.monkey_delay

/mob/living/carbon/monkey/Topic(href, href_list)
	..()
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	var/range_check = in_range(src, usr)
	var/obj/item/item = usr.get_active_hand()

	if(TK in usr.mutations)
		if(!item || in_range(item, src))
			range_check = TRUE

	if((href_list["item"] && !( usr.stat ) && !( usr.restrained() ) && range_check ))
		if(item && (item.flags & (ABSTRACT | DROPDEL)))
			return
		var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey(  )
		O.source = usr
		O.target = src
		O.item = item
		O.s_loc = usr.loc
		O.t_loc = loc
		O.place = href_list["item"]
		requests += O
		spawn( 0 )
			O.process()
			return
	..()
	return

/mob/living/carbon/monkey/meteorhit(obj/O)
	for(var/mob/M in viewers(src, null))
		M.show_message(text("\red [] has been hit by []", src, O), 1)
	if (health > 0)
		var/shielded = 0
		adjustBruteLoss(30)
		if ((O.icon_state == "flaming" && !( shielded )))
			adjustFireLoss(40)
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
	return

//mob/living/carbon/monkey/bullet_act(obj/item/projectile/Proj)taken care of in living


/mob/living/carbon/monkey/attack_paw(mob/M)
	..()

	if (M.a_intent == "help")
		help_shake_act(M)
	else
		if ((M.a_intent == "hurt" && !( istype(wear_mask, /obj/item/clothing/mask/muzzle) )))
			M.do_attack_animation(src)
			if ((prob(75) && health > 0))
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[M.name] has bit [name]!</B>", 1)
				var/damage = rand(1, 5)
				adjustBruteLoss(damage)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
				for(var/datum/disease/D in M.viruses)
					if(istype(D, /datum/disease/jungle_fever))
						contract_disease(D,1,0)
			else
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[M.name] has attempted to bite [name]!</B>", 1)
	return

/mob/living/carbon/monkey/attack_hand(mob/living/carbon/human/M)
	if (!ticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		to_chat(M, "No attacking people at spawn, you jackass.")
		return

	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.use(2500)
					apply_effects(0,0,0,0,5,0,0,150)

					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
					s.set_up(3, 1, src)
					s.start()

					M.do_attack_animation(src)
					for(var/mob/O in viewers(src, null))
						if (O.client)
							O.show_message("\red <B>[src] has been touched with the stun gloves by [M]!</B>", 1, "\red You hear someone fall", 2)
					return
				else
					to_chat(M, "\red Not enough charge! ")
					return

	if (M.a_intent == "help")
		help_shake_act(M)
		get_scooped(M)
	else
		if (M.a_intent == "hurt")
			M.do_attack_animation(src)
			if ((prob(75) && health > 0))
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has punched [name]!</B>", M), 1)

				playsound(loc, "punch", 25, 1, -1)
				var/damage = rand(5, 10)
				if (prob(40))
					damage = rand(10, 15)
					if (paralysis < 5)
						Paralyse(rand(10, 15))
						spawn( 0 )
							for(var/mob/O in viewers(src, null))
								if ((O.client && !( O.blinded )))
									O.show_message(text("\red <B>[] has knocked out [name]!</B>", M), 1)
							return
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has attempted to punch [name]!</B>", M), 1)
		else
			if (M.a_intent == "grab")
				if (M == src || anchored || M.lying)
					return

				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)

				M.put_in_active_hand(G)

				grabbed_by += G
				G.synch()

				LAssailant = M

				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					O.show_message(text("\red [] has grabbed [name] passively!", M), 1)
			else
				if (!( paralysis ))
					if (prob(25))
						Paralyse(2)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(text("\red <B>[] has pushed down [name]!</B>", M), 1)
					else
						drop_item()
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(text("\red <B>[] has disarmed [name]!</B>", M), 1)
	return

/mob/living/carbon/monkey/attack_alien(mob/living/carbon/alien/humanoid/M)
	if (!ticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		to_chat(M, "No attacking people at spawn, you jackass.")
		return

	switch(M.a_intent)
		if ("help")
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\blue [M] caresses [src] with its scythe like arm."), 1)

		if ("hurt")
			if ((prob(95) && health > 0))
				playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				var/damage = rand(15, 30)
				if (damage >= 25)
					damage = rand(20, 40)
					if (paralysis < 15)
						Paralyse(rand(10, 15))
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("\red <B>[] has wounded [name]!</B>", M), 1)
				else
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("\red <B>[] has slashed [name]!</B>", M), 1)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has attempted to lunge at [name]!</B>", M), 1)

		if ("grab")
			if (M == src || anchored || M.lying)
				return
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)

			M.put_in_active_hand(G)

			grabbed_by += G
			G.synch()

			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\red [] has grabbed [name] passively!", M), 1)

		if ("disarm")
			playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
			var/damage = 5
			if(prob(95))
				Weaken(15)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has tackled down [name]!</B>", M), 1)
			else
				drop_item()
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has disarmed [name]!</B>", M), 1)
			adjustBruteLoss(damage)
			updatehealth()
	return

/mob/living/carbon/monkey/attack_animal(mob/living/simple_animal/M)
	if(..())
		return
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message("<span class='userdanger'><B>[M]</B> [pick(M.attack_message)] [src]!</span>")
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()


/mob/living/carbon/monkey/attack_slime(mob/living/carbon/slime/M)
	if (!ticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if(M.Victim) return // can't attack while eating!

	if (health > -100)

		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\red <B>The [M.name] glomps []!</B>", src), 1)

		var/damage = rand(1, 3)

		if(istype(src, /mob/living/carbon/slime/adult))
			damage = rand(20, 40)
		else
			damage = rand(5, 35)

		adjustBruteLoss(damage)

		if(M.powerlevel > 0)
			var/stunprob = 10
			var/power = M.powerlevel + rand(0,3)

			switch(M.powerlevel)
				if(1 to 2) stunprob = 20
				if(3 to 4) stunprob = 30
				if(5 to 6) stunprob = 40
				if(7 to 8) stunprob = 60
				if(9) 	   stunprob = 70
				if(10) 	   stunprob = 95

			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>The [M.name] has shocked []!</B>", src), 1)

				Weaken(power)
				if (stuttering < power)
					stuttering = power
				Stun(power)

				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()

				if (prob(stunprob) && M.powerlevel >= 8)
					adjustFireLoss(M.powerlevel * rand(6,10))


		updatehealth()

	return

/mob/living/carbon/monkey/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Intent: [a_intent]")
		stat(null, "Move Mode: [m_intent]")
		if(istype(src, /mob/living/carbon/monkey/diona))
			stat(null, "Nutriment: [nutrition]/400")
		CHANGELING_STATPANEL_STATS(null)

	CHANGELING_STATPANEL_POWERS(null)

/mob/living/carbon/monkey/verb/removeinternal()
	set name = "Remove Internals"
	set category = "IC"
	internal = null
	return

/mob/living/carbon/monkey/emp_act(severity)
	if(wear_id) wear_id.emp_act(severity)
	..()

/mob/living/carbon/monkey/ex_act(severity)
	if(!blinded)
		flash_eyes()

	switch(severity)
		if(1.0)
			if (stat != DEAD)
				adjustBruteLoss(200)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
		if(2.0)
			if (stat != DEAD)
				adjustBruteLoss(60)
				adjustFireLoss(60)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
		if(3.0)
			if (stat != DEAD)
				adjustBruteLoss(30)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
			if (prob(50))
				Paralyse(10)
		else
	return

/mob/living/carbon/monkey/blob_act()
	if (stat != DEAD)
		adjustFireLoss(60)
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
	if (prob(50))
		Paralyse(10)
	if (stat == DEAD && client)
		gib()
		return
	if (stat == DEAD && !client)
		gibs(loc, viruses)
		qdel(src)
		return


/mob/living/carbon/monkey/IsAdvancedToolUser()//Unless its monkey mode monkeys cant use advanced tools
	return 0

/mob/living/carbon/monkey/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/italics=0, var/message_range = world.view, var/list/used_radios = list())
	if(stat)
		return

	if(copytext(message,1,2) == "*")
		return emote(copytext(message,2))

	if(stat)
		return

	if(speak_emote.len)
		verb = pick(speak_emote)

	message = capitalize(trim_left(message))

	..(message, speaking, verb, alt_name, italics, message_range, used_radios)
