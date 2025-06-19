SUBSYSTEM_DEF(reality)
	name = "Reality"
	flags = SS_NO_INIT | SS_BACKGROUND
	wait = 20
	var/RDI = 100
	//All power levels range from 1-9
	// 1-3 correspond to the levels of activity each circle has within its physical and temporal locale.
	// A level of 4 represents a complete ascendance via circle assimilation of the Wellspring.
	// A level of 0 means its either not relevant or not present entirely.
	var/circle_1_power = 0
	var/circle_2_power = 2
	var/circle_3_power = 2
	// Veil 7 : mafqud : Artifical stabilization.
	// Veil 6 : naqis : Space outside of earth.
	// Veil 5 : futur : Earth Standard.
	// Veil 4 : lahfa : Earth w/Anchors.
	// Veil 3 : adtura : Earth w/Maws.
	// Veil 2.5 : antihak : Direct intervention of Archous and the Link.
	// Veil 2 : akhtiraq : Earth w/Root Maws and older maws.
	// Veil 1 : nashwa : Elecytria.
	// Veil 0 : tamjid : Normal within Archonic veil-space. Post Veil Collapse.
	var/veil = 6
	var/list/beneath_shards_connected = list()
	//Amount of archonic subsumption damage incurred per two seconds for being either A: outside or B: within visible range of space tiles.
	var/passive_archonic_light = 0
	var/archonic_sublimation_damage = 1
	var/advance_archonic_sublimation = TRUE
	var/list/archonically_seen = list()

/datum/controller/subsystem/reality/stat_entry(msg)
	msg = "RDI:[RDI]  C1:[circle_1_power]  C2:[circle_2_power]  C3:[circle_3_power]  V:[veil]"
	return ..()

/datum/controller/subsystem/reality/proc/adjust_veil()
	veil = 2.5

/datum/controller/subsystem/reality/fire()
	if(passive_archonic_light)
		for(var/mob/living/carbon/C in GLOB.carbon_list)
			var/turf/mob_turf = get_turf(C)
			var/area/mob_area = get_area(C)
			var/seen = FALSE
			if(C.stat == DEAD) //Do not waste processes on dead people. We do not care about the experiences of dead people.
				continue
			if(C.get_archonic_immunity(FALSE))
				continue
			if(!mob_turf) //dude
				continue
			if(mob_area.allow_weather)
				seen = TRUE
			for(var/turf/T in oview(mob_turf))
				if(isspaceturf(T) || istransparentturf(T))
					seen = TRUE
					break
			if(seen)
				var/light_potency = 0
				switch(SSreality.veil)
					if(4)
						light_potency = 5
					if(3)
						light_potency = 7
					if(2, 2.5)
						light_potency = 10
					if(1)
						light_potency = 12
					if(0)
						light_potency = 15
				var/archonic_armor = max(C.run_armor_check(null, "laser", light_potency, silent = TRUE), C.run_armor_check(null, "energy", light_potency, silent = TRUE))
				var/hit_percent = (100-archonic_armor)/100
				C.adjust_archonic_sublimation(passive_archonic_light*hit_percent, TRUE)


/obj/proc/apoth_delete()
	color = "#ffffff"
	AddElement(/datum/element/decal/apoth_delete, initial(icon) || icon, initial(icon_state) || icon_state)
	add_filter("extract_outline", 1, outline_filter(size = 1, color = "#ff0000"))
	QDEL_IN(src, 0.6 SECONDS)

/mob/proc/apoth_delete()
	color = "#ffffff"
	AddElement(/datum/element/decal/apoth_delete, initial(icon) || icon, initial(icon_state) || icon_state)
	add_filter("extract_outline", 1, outline_filter(size = 1, color = "#ff0000"))
	QDEL_IN(src, 0.6 SECONDS)

/obj/proc/apoth_filter(remove)
	if(remove)
		color = null
		remove_filter("extract_outline")
		RemoveElement(/datum/element/decal/apoth_delete)
	else
		color = "#ffffff"
		AddElement(/datum/element/decal/apoth_delete, initial(icon) || icon, initial(icon_state) || icon_state)
		add_filter("extract_outline", 1, outline_filter(size = 1, color = "#ff0000"))

/mob/proc/apoth_filter(remove)
	if(remove)
		color = null
		remove_filter("extract_outline")
		RemoveElement(/datum/element/decal/apoth_delete)
	else
		color = "#ffffff"
		AddElement(/datum/element/decal/apoth_delete, initial(icon) || icon, initial(icon_state) || icon_state)
		add_filter("extract_outline", 1, outline_filter(size = 1, color = "#ff0000"))

/datum/element/decal/apoth_delete

/datum/element/decal/apoth_delete/Attach(datum/target, _icon, _icon_state, _dir, _cleanable=FALSE, _layer=HIGH_OBJ_LAYER) //was at ABOVE_OBJ_LAYER orignally
	. = ..()

/datum/element/decal/apoth_delete/generate_appearance(_icon, _icon_state, _dir, _layer, _alpha, source)
	if(!_icon || !_icon_state)
		return FALSE
	var/icon/black_texture = icon(_icon, _icon_state, , 1)		//we only want to apply black overlay to the initial icon_state for each object
	black_texture.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
	black_texture.Blend(icon('code/modules/archonic/icons/288x288.dmi', "nothing"), ICON_MULTIPLY) //adds overlay and the remaining white areas become transparant
	pic = mutable_appearance(black_texture)
	return TRUE

//APOTHEOTIC TRAVELER//

/datum/outfit/apotheotic
	name = "Apotheotic"
	uniform = /obj/item/clothing/under/syndicate/skirt
	suit = /obj/item/clothing/suit/hooded/cloak/apotheotic
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	belt = /obj/item/apoth_deleter
	implants = list(/obj/item/implant/weapons_auth, /obj/item/implant/radio, /obj/item/implant/archonic_storage)

/obj/item/clothing/suit/hooded/cloak/apotheotic
	name = "\improper nothingness"
	desc = "Drapes made through rituals unknown to the world, encoded in runes made by the thing that spurred the anomaly to glow. It is sheer         ."
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	cold_protection = HEAD|CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD|CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	body_parts_covered = HEAD|CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	icon_state = "apotheotic_armor"
	item_state = "apotheotic_armor"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	mob_overlay_icon = 'code/modules/archonic/icons/worn/armor.dmi'
	armor = list("melee" = 90, "bullet" = 95, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	strip_delay = 50
	equip_delay_other = 50
	resistance_flags = FIRE_PROOF | UNACIDABLE | LAVA_PROOF | INDESTRUCTIBLE
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/apotheotic

/obj/item/clothing/head/hooded/cloakhood/apotheotic
	name = "\improper nothingness"
	icon_state = "golhood"
	desc = "Drapes made through rituals unknown to the world, encoded in runes made by the thing that spurred the anomaly to glow. It is sheer         ."
	armor = list("melee" = 90, "bullet" = 95, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT | BLOCK_GAS_SMOKE_EFFECT | ALLOWINTERNALS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF | SEALS_EYES
	resistance_flags = FIRE_PROOF | UNACIDABLE | LAVA_PROOF | INDESTRUCTIBLE


/obj/item/clothing/suit/hooded/cloak/apotheotic/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		ADD_TRAIT(user, TRAIT_NOBREATH, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_BOMBIMMUNE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_RESISTLOWPRESSURE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_RESISTCOLD, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_RESISTHIGHPRESSURE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_RESISTHEAT, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_NOFIRE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_SLEEPIMMUNE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_VIRUSIMMUNE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_BOMBIMMUNE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_STABLEHEART, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_STABLELIVER, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_NODEATH, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_NOHARDCRIT, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_NOCRITDAMAGE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_APOTHEOTIC, "suit_[REF(src)]")
		user.failed_last_breath = FALSE
		user.clear_alert("not_enough_oxy")
		user.apply_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/suit/hooded/cloak/apotheotic/dropped(mob/living/carbon/human/user)
	..()
	REMOVE_TRAIT(user, TRAIT_NOBREATH, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_BOMBIMMUNE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_RESISTLOWPRESSURE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_RESISTCOLD, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_RESISTHIGHPRESSURE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_RESISTHEAT, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_NOFIRE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_SLEEPIMMUNE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_VIRUSIMMUNE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_BOMBIMMUNE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_STABLEHEART, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_STABLELIVER, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_NODEATH, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_NOCRITDAMAGE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_APOTHEOTIC, "suit_[REF(src)]")
	user.remove_status_effect(/datum/status_effect/rebreathing)

/obj/item/apoth_deleter
	desc = "A strange baton-like object with a hole in reality jutting out of it. You really should avoid touching it."
	name = "\improper P-PDS-093 'Banhammer'"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "apoth_deleter"
	item_state = "apoth_deleter"
	mob_overlay_icon = "none"
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	block_chance = 120
	attack_verb = list("deleted")
	max_integrity = 2000
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	var/stored_user

/obj/item/apoth_deleter/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(prob(final_block_chance))
		owner.visible_message("<span class='danger'>[owner] absorbs [attack_text] with [src]!</span>")
		playsound(src, 'sound/weapons/effects/deflect.ogg', 100, TRUE)
		return TRUE
	return FALSE

/obj/item/apoth_deleter/proc/check_user(user)
	if(user == stored_user)
		return TRUE
	to_chat(user, "<span class='warning'>INVALID USER</span>")

/obj/item/apoth_deleter/attack_self(mob/living/user)
	if(!stored_user)
		to_chat(user,"<span class='warning'>USER KEY SET: [user]</span>")
		stored_user = user
		return
	if(!check_user(user))
		return
	to_chat(user, "<span class='warning'>USER KEY ALREADY SET</span>")

/obj/item/apoth_deleter/attack(mob/target, mob/living/user)
	if(!check_user(user))
		return FALSE
	if(target == user)
		return FALSE
	user.do_attack_animation(target)
	if(HAS_TRAIT(target, TRAIT_ANOMALY_IMMUNE_AIMTIACRYSTAL))
		target.visible_message("<span class='adminhelp'>[user] fails to delete [target] with the [src]!</span>")
		target.visible_message("<span class='warning'>A pink and gold vein-like structure under [target]'s skin bursts into brilliant light.</span>")
		return
	target.apoth_delete()
	target.visible_message("<span class='adminhelp'>[user] deletes [target] with the [src]!</span>", \
							"<span class='adminhelp'><span class='extremelybig'>You feel a sudden numbness as you are ripped out of reality.</span></span>")

/obj/item/apoth_deleter/attack_obj(obj/O, mob/living/user)
	if(!check_user(user))
		return FALSE
	if(O == src)
		return
	user.do_attack_animation(O)
	user.visible_message("<span class='adminhelp'>[user] deletes [O] with the [src]!</span>", \
							"<span class='adminhelp'>You delete [O] with the [src]!</span>")
	O.apoth_delete()

#define DELETER_STATE_BATON 1 //The Self
#define DELETER_STATE_BLADE 2 //The Other
#define DELETER_STATE_TORCH 3 //The World

/obj/item/apoth_deleter_v2
	desc = "A strange baton-like object with a hole in reality jutting out of it. You really should avoid touching it."
	name = "\improper P-PAS-833 'Termina Nil'"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "apoth_deleter"
	item_state = "apoth_deleter"
	mob_overlay_icon = "none"
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	block_chance = 120
	attack_verb = list("deleted")
	max_integrity = 2000
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	var/stored_user
	var/state = DELETER_STATE_BATON


//MISC//

/area/ruin/space/has_grav/singularitylab/command
	name = "Command Center"
	icon_state = "blue"

/datum/controller/subsystem/overmap/proc/empty_space()
	for(var/datum/overmap/O as anything in overmap_objects)
		if(!istype(O, /datum/overmap/ship))
			qdel(O)

/client/proc/mass_screen_message()
	set name = "Mass Screen Message"
	set category = "Admin.Events"
	set desc = "Broadcasts a screen message to everyone."

	if(!holder)
		to_chat(src, "Only administrators may use this command.", confidential = TRUE)
		return
	if(check_rights(R_DEBUG, 1))
		var/message = input(usr, "X overmap coordinate:") as text|null
		if(!message)
			return FALSE
		var/message2 = input(usr, "Undertext?")
		if(message2)
			for(var/mob/M as anything in GLOB.player_list)
				M.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:center valign='top'><u>[message]</u></span><br>[message2]")
		else
			for(var/mob/M as anything in GLOB.player_list)
				M.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:center valign='top'><u>[message]</u></span>")
		message_admins("[key_name_admin(usr)] mass screen messaged \"[message]\"")
		log_admin("[key_name_admin(usr)] mass screen messaged \"[message]\"")

/datum/overmap/outpost/nanotrasen_asteroid
	token_icon_state = "station_asteroid_0"
	main_template = /datum/map_template/outpost/nt_asteroid
	elevator_template = /datum/map_template/outpost/elevator_test
	// Using a second list of hangar templates.
	hangar_templates = list(
		/datum/map_template/outpost/hangar/nt_asteroid_20x20,
		/datum/map_template/outpost/hangar/nt_asteroid_40x20,
		/datum/map_template/outpost/hangar/nt_asteroid_40x40,
		/datum/map_template/outpost/hangar/nt_asteroid_56x20,
		/datum/map_template/outpost/hangar/nt_asteroid_56x40
	)
