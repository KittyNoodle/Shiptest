/area/ship/archonic
	name = "Reliquary"
	icon_state = "shuttle"

/datum/outfit/archonic/terminal
	name = "Terminal Archonicist"
	uniform = /obj/item/clothing/under/syndicate/skirt
	suit = null
	shoes = /obj/item/clothing/shoes/jackboots
	neck = null
	gloves = /obj/item/clothing/gloves/combat
	back = null
	implants = list(/obj/item/implant/freedom, /obj/item/implant/weapons_auth, /obj/item/implant/radio, /obj/item/implant/spell/archonic/barrage, /obj/item/implant/spell/archonic/summonitem, /obj/item/implant/spell/archonic/knock, /obj/item/implant/spell/archonic/heal, /obj/item/implant/spell/archonic/sparkstorm, /obj/item/implant/spell/archonic/flight, /obj/item/implant/archonic_storage, /obj/item/implant/archonic)

/datum/status_effect/rebreathing
	id = "rebreathing"
	duration = -1
	alert_type = null

/datum/status_effect/rebreathing/tick()
	owner.adjustOxyLoss(-6, 0) //Just a bit more than normal breathing.

/obj/item/clothing/mask/nobreath
	name = "rebreather mask"
	desc = "A transparent mask, resembling a conventional breath mask, but made of bluish slime. Seems to lack any air supply tube, though."
	icon_state = "slime"
	item_state = "slime"
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0
	permeability_coefficient = 0.5
	flags_cover = MASKCOVERSMOUTH
	resistance_flags = NONE

/obj/item/clothing/mask/nobreath/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_MASK)
		ADD_TRAIT(user, TRAIT_NOBREATH, "breathmask_[REF(src)]")
		user.failed_last_breath = FALSE
		user.clear_alert("not_enough_oxy")
		user.apply_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/mask/nobreath/dropped(mob/living/carbon/human/user)
	..()
	REMOVE_TRAIT(user, TRAIT_NOBREATH, "breathmask_[REF(src)]")
	user.remove_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/head/peaceflower
	name = "heroine bud"
	desc = "An extremely addictive flower, full of peace magic."
	icon = 'icons/obj/slimecrossing.dmi'
	icon_state = "peaceflower"
	item_state = "peaceflower"
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = NONE
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/clothing/head/peaceflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_PACIFISM, "peaceflower_[REF(src)]")

/obj/item/clothing/head/peaceflower/dropped(mob/living/carbon/human/user)
	..()
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "peaceflower_[REF(src)]")

/obj/item/clothing/head/peaceflower/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			to_chat(user, "<span class='warning'>You feel at peace. <b style='color:pink'>Why would you want anything else?</b></span>")
			return
	return ..()

/obj/item/clothing/suit/armor/heavy/adamantine
	name = "adamantine armor"
	desc = "A full suit of adamantine plate armor. Impressively resistant to damage, but weighs about as much as you do."
	icon_state = "adamsuit"
	item_state = "adamsuit"
	flags_inv = NONE
	obj_flags = IMMUTABLE_SLOW
	slowdown = 4
	var/hit_reflect_chance = 40

/obj/item/clothing/suit/armor/heavy/adamantine/IsReflect(def_zone)
	if(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG) && prob(hit_reflect_chance))
		return TRUE
	else
		return FALSE

/obj/machinery/launchpad/violetspace
	name = "violetspace launchpad"
	desc = "A bluespace pad able to rotate matter through violetspace, teleporting it to or from nearby locations."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "vpad-idle"
	icon_teleport = "vpad-beam"
	use_power = FALSE
	stationary = FALSE //only used to prevent deconstruction
	idle_power_usage = 0
	active_power_usage = 0
	teleport_speed = 9
	range = 200
	display_name = "VSLP-P-018"

/obj/machinery/launchpad/violetspace/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/violetspace_launchpad_remote))
		var/obj/item/violetspace_launchpad_remote/L = I
		if(L.pad == WEAKREF(src)) //do not attempt to link when already linked
			return ..()
		L.pad = WEAKREF(src)
		to_chat(user, "<span class='notice'>You link [src] to [L].</span>")
	else
		return ..()

/obj/item/violetspace_launchpad_remote
	name = "violetspace navigator"
	desc = "A crystal that can be used to hook onto the violetspace launchpad and navigate reality."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "archonic_crystal"
	w_class = WEIGHT_CLASS_SMALL
	var/sending = TRUE
	//A weakref to our linked pad
	var/datum/weakref/pad

/obj/item/violetspace_launchpad_remote/Initialize(mapload, pad) //remote spawns linked to the briefcase pad
	. = ..()
	src.pad = WEAKREF(pad)

/obj/item/violetspace_launchpad_remote/attack_self(mob/user)
	. = ..()
	ui_interact(user)
	to_chat(user, "<span class='notice'>[src] projects a display onto your mind.</span>")


/obj/item/violetspace_launchpad_remote/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/violetspace_launchpad_remote/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VioletPadRemote")
		ui.open()
	ui.set_autoupdate(TRUE)

/obj/item/violetspace_launchpad_remote/ui_data(mob/user)
	var/list/data = list()
	var/obj/machinery/launchpad/violetspace/our_pad = pad.resolve()
	data["has_pad"] = our_pad ? TRUE : FALSE
	if(!our_pad)
		return data

	data["pad_name"] = our_pad.display_name
	data["range"] = our_pad.range
	data["x"] = our_pad.x_offset
	data["y"] = our_pad.y_offset
	return data

/obj/item/violetspace_launchpad_remote/proc/teleport(mob/user, obj/machinery/launchpad/pad)
	if(QDELETED(pad))
		to_chat(user, "<span class='warning'>ERROR: Launchpad not responding. Check launchpad integrity.</span>")
		return
	if(!pad.isAvailable())
		to_chat(user, "<span class='warning'>ERROR: Launchpad not operative. Make sure the launchpad is ready and powered.</span>")
		return
	pad.doteleport(user, sending)

/obj/item/violetspace_launchpad_remote/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/obj/machinery/launchpad/briefcase/our_pad = pad.resolve()
	if(!our_pad)
		pad = null
		return TRUE
	switch(action)
		if("set_pos")
			var/new_x = text2num(params["x"])
			var/new_y = text2num(params["y"])
			our_pad.set_offset(new_x, new_y)
			. = TRUE
		if("move_pos")
			var/plus_x = text2num(params["x"])
			var/plus_y = text2num(params["y"])
			our_pad.set_offset(
				x = our_pad.x_offset + plus_x,
				y = our_pad.y_offset + plus_y
			)
			. = TRUE
		if("rename")
			. = TRUE
			var/new_name = params["name"]
			if(!new_name)
				return
			our_pad.display_name = new_name
		if("remove")
			. = TRUE
			if(usr && tgui_alert(usr, "Are you sure?", "Unlink Launchpad", list("I'm Sure", "Abort")) != "Abort")
				our_pad = null
		if("launch")
			sending = TRUE
			teleport(usr, our_pad)
			. = TRUE
		if("pull")
			sending = FALSE
			teleport(usr, our_pad)
			. = TRUE

/obj/effect/spawner/structure/window/plasma/reinforced/plastitanium/archonic
	name = "archonic crystal window spawner"
	icon_state = "plastitaniumwindow_spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/reinforced/plastitanium/archonic)


/obj/structure/window/plasma/reinforced/plastitanium/archonic
	name = "archonic crystal window"
	desc = "A durable looking window made archonic crystal."
	max_integrity = 600
	explosion_block = 50
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF

/obj/item/eter_violet
	name = "Eter Violet"
	desc = "This book describes the secrets of the veil that seals Archous."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	base_icon_state = "book"
	icon_state = "book"
	//worn_icon_state = "book"
	w_class = WEIGHT_CLASS_SMALL
	/// Helps determine the icon state of this item when it's used on self.
	var/book_open = FALSE

/obj/item/eter_violet/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	if(book_open)
		close_animation()
		w_class = WEIGHT_CLASS_SMALL
	else
		open_animation()
		w_class = WEIGHT_CLASS_NORMAL

/*
 * Plays a little animation that shows the book opening and closing.
 */
/obj/item/eter_violet/proc/open_animation()
	book_open = TRUE
	icon_state = "[base_icon_state]_open"
	flick("[base_icon_state]_opening", src)

/// Plays a closing animation and resets the icon state.
/obj/item/eter_violet/proc/close_animation()
	book_open = FALSE
	icon_state = base_icon_state
	flick("[base_icon_state]_closing", src)

/obj/item/flashlight/lantern/lamp_of_silence
	name = "\improper Lamp of Silence"
	desc = "An ornate, pale-green lantern. The words saltare in auream lucem are enscribed into the lamp on a golden plaque."
	color = LIGHT_COLOR_GREEN
	light_color = LIGHT_COLOR_GREEN

/obj/machinery/door/namedoor
	name = "door"
	desc = "This door only opens for its owner."
	icon = 'icons/obj/doors/blastdoor.dmi'
	icon_state = "closed"
	explosion_block = 3
	heat_proof = TRUE
	max_integrity = 600
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	damage_deflection = 70
	var/owner_name = "Crux CF"

/obj/machinery/door/namedoor/Bumped(atom/movable/AM)
	return !density && ..()

/obj/machinery/door/namedoor/try_to_activate_door(mob/user)
	add_fingerprint(user)
	if(operating)
		return
	if(check_name(user))
		if(density)
			open()
		else
			close()
	else if(density)
		do_animate("deny")

/obj/machinery/door/namedoor/update_icon_state()
	. = ..()
	icon_state = density ? "closed" : "open"

/obj/machinery/door/namedoor/proc/check_name(mob/user)
	if(user.real_name == owner_name)
		return TRUE
	return FALSE

/obj/machinery/door/namedoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, TRUE)
		if("closing")
			flick("closing", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, TRUE)
		if("deny")
			//Deny animation would be nice to have.
			playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)

/obj/machinery/meteor_ward
	name = "Archonic Ward"
	desc = "A rune made of an unknown glowing substance. This one seems primarily focused on the space rocks."
	icon = 'code/modules/archonic/icons/runes.dmi'
	icon_state = "ward"
	color = "#7e0c39"
	subsystem_type = /datum/controller/subsystem/processing/fastprocess
	max_integrity = 600
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/kill_range = 8

/obj/machinery/meteor_ward/process()
	for(var/obj/effect/meteor/M in GLOB.meteor_list)
		if(M.virtual_z() != virtual_z())
			continue
		if(get_dist(M,src) > kill_range)
			continue
		Beam(get_turf(M),icon_state="purple_lightning",time=5,maxdistance=kill_range)
		qdel(M)

/obj/item/disk/tech_disk/debug/terminal
	name = "\improper Terminal technology disk"
	desc = "A tech disk printed by SIGIL."

/obj/item/disk/surgery/debug/terminal
	name = "SIGIL Surgery Disk"

/obj/machinery/porta_turret/ship/archonic
	name = "Archonic Ward"
	desc = "A rune made of an unknown glowing substance."
	icon = 'code/modules/archonic/icons/runes.dmi'
	icon_state = "ward"
	base_icon_state = "ward"
	shot_delay = 10
	scan_range = 15
	stun_projectile = /obj/projectile/magic/arcane_barrage/archonic/stun
	stun_projectile_sound = 'sound/weapons/laser3.ogg'
	lethal_projectile = /obj/projectile/beam/archonic/death
	lethal_projectile_sound = 'sound/weapons/blastcannon.ogg'
	faction = list("Archous", "turret")
	color = "#ff1a75"
	max_integrity = 600
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF

/obj/machinery/porta_turret/ship/archonic/examine(mob/user)
	. = ..()
	if(!on)
		. += "<span class='revenminor'>It seems to be inactive.</span>"
		return

	if(in_faction(user))
		. += "<span class='revenminor'>It seems to welcome you.</span>"
		return

	switch(mode)
		if(TURRET_STUN)
			. += "<span class='revenminor'>It seems to want to stop you.</span>"
		if(TURRET_LETHAL)
			. += "<span class='revenminor'>It seems to want to kill you.</span>"

/obj/item/clothing/head/helmet/space/hardsuit/quixote/dimensional/archonic
	name = "\improper VIME hardsuit helmet"
	desc = "The integrated helmet of a VIME hardsuit."
	armor = list("melee" = 50, "bullet" = 40, "laser" = 40, "energy" = 35, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)

/obj/item/clothing/suit/space/hardsuit/quixote/dimensional/archonic
	name = "\improper VIME hardsuit"
	armor = list("melee" = 50, "bullet" = 40, "laser" = 40, "energy" = 35, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	desc = "The Voidic Interchange Mobile Exosuit or VIME is an experimental hardsuit designed by the Aetherofusion Nusquamology division. Its design incorporates a thin layer of hyperdense protomatter around it, the layer provides no conventional armor, however protects from the effects of Voidic diffusion."
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/quixote/dimensional
	var/protomatter_shield = 100

/obj/item/clothing/suit/space/hardsuit/quixote/dimensional/archonic/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/space/hardsuit/quixote/dimensional/archonic/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/space/hardsuit/quixote/dimensional/archonic/process()
	if(protomatter_shield)
		var/turf/location = src.loc
		if(ishuman(location))
			var/mob/living/carbon/human/M = location
			if(M.is_holding(src) || M.wear_suit == src)
				if(!HAS_TRAIT(M, TRAIT_CYTHRXIMMUNE))
					ADD_TRAIT(M, TRAIT_CYTHRXIMMUNE, "suit_[REF(src)]")
				location = M.loc
		if(isturf(location))
			if(istype(location, /turf/open/indestructible/cythrx))
				protomatter_shield = clamp(protomatter_shield-12, 0, 100)
	if(!protomatter_shield)
		var/turf/location = src.loc
		if(ishuman(location))
			var/mob/living/carbon/human/M = location
			if(M.is_holding(src) || M.wear_suit == src)
				if(HAS_TRAIT(M, TRAIT_CYTHRXIMMUNE))
					REMOVE_TRAIT(M, TRAIT_CYTHRXIMMUNE, "suit_[REF(src)]")
				location = M.loc
		if(isturf(location))
			if(istype(location, /turf/open/indestructible/cythrx))
				var/turf/open/indestructible/cythrx/cythrx_turf = location
				var/turf/location_2 = src.loc
				if(ishuman(location_2))
					var/mob/living/carbon/human/M = location_2
					if(M.is_holding(src) || M.wear_suit == src)
						cythrx_turf.dust_mob(M)

/obj/projectile/magic/arcane_barrage/archonic/stun
	name = "archonic flash"
	damage = 40
	damage_type = STAMINA
	armour_penetration = 30

/obj/projectile/magic/arcane_barrage/archonic/stun/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/M = target
		M.archonic_flash()
		if(!ishuman(M))
			M.electrocute_act(70, src, flags = SHOCK_NOGLOVES)

/obj/projectile/beam/archonic/death
	name = "archonic annihilation beam"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = "#ff1a75"
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/archonic
	muzzle_type = /obj/effect/projectile/muzzle/archonic
	impact_type = /obj/effect/projectile/impact/archonic
	damage = 1000
	palefire_immune = TRUE //Ship mounted cannon, too big for palefire tech.

/obj/projectile/beam/archonic/death/on_hit(atom/target, blocked = FALSE)
	. = ..()
	new /obj/effect/temp_visual/archous_flash/huge/fading(get_turf(target))
	if(isliving(target))
		var/mob/living/M = target
		M.archonic_flash()
		M.dust(TRUE, TRUE, TRUE)
	explosion(target, 2, 3, 4, 7)


/obj/effect/projectile/impact/archonic
	name = "archonic impact"
	icon_state = "impact_hcult"

/obj/effect/projectile/tracer/archonic
	name = "archonic beam"
	icon_state = "hcult"

/obj/effect/projectile/muzzle/archonic
	icon_state = "muzzle_hcult"

/obj/item/hairbrush
	name = "hairbrush"
	desc = "A small, circular brush with an ergonomic grip for efficient brush application."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "brush"
	item_state = "brush"
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/brush_speed = 3 SECONDS

/obj/item/hairbrush/attack(mob/target, mob/user)
	. = ..()
	if(target.stat == DEAD)
		to_chat(usr, span_warning("There isn't much point brushing someone who can't appreciate it!"))
		return
	brush(target, user)

/// Brushes someone, giving them a small mood boost
/obj/item/hairbrush/proc/brush(mob/living/target, mob/user)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/bodypart/head = human_target.get_bodypart(BODY_ZONE_HEAD)

		// Don't brush if you can't reach their head or cancel the action
		if(!head)
			to_chat(user, span_warning("[human_target] has no head!"))
			return
		if(human_target.is_mouth_covered(ITEM_SLOT_HEAD))
			to_chat(user, span_warning("You can't brush [human_target]'s hair while [human_target.p_their()] head is covered!"))
			return
		if(!do_after(user, brush_speed, human_target))
			return

		// Do 1 brute to their head if they're bald. Should've been more careful.
		if(human_target.hairstyle == "Bald" || human_target.hairstyle == "Skinhead" && is_species(human_target, /datum/species/human))
			human_target.visible_message(span_warning("[usr] scrapes the bristles uncomfortably over [human_target]'s scalp."), span_warning("You scrape the bristles uncomfortably over [human_target]'s scalp."))
			head.receive_damage(1)
			return

		// Brush their hair
		if(human_target == user)
			human_target.visible_message(span_notice("[usr] brushes [usr.p_their()] hair!"), span_notice("You brush your hair."))
			SEND_SIGNAL(human_target, COMSIG_ADD_MOOD_EVENT, "brushed", /datum/mood_event/brushed/self)
		else
			user.visible_message(span_notice("[usr] brushes [human_target]'s hair!"), span_notice("You brush [human_target]'s hair."), ignored_mobs=list(human_target))
			human_target.show_message(span_notice("[usr] brushes your hair!"), MSG_VISUAL)
			SEND_SIGNAL(human_target, COMSIG_ADD_MOOD_EVENT, "brushed", /datum/mood_event/brushed)

/obj/item/hairbrush/tactical
	name = "tactical hairbrush"
	desc = "Sometimes, after a brush with death, a good grooming is just the thing for tactical stress relief. "
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "tacticalbrush"
	item_state = "tacticalbrush"
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'

/obj/item/hairbrush/contraption
	name = "strange hairbrush"
	desc = "A strange purple hairbrush with a strong handle. The back of the brush has a small crystalline rhombus embedded in it, it seems like theres space to press it down..."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "archbrush"
	item_state = "archbrush"
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'

/datum/mood_event/brushed
	description = span_nicegreen("Someone brushed my hair recently, that felt great!\n")
	mood_change = 3
	timeout = 4 MINUTES

/datum/mood_event/brushed/add_effects(mob/brusher)
	description = span_nicegreen("[brusher? brusher.name : "I"] brushed my hair recently, that felt great!\n")

/datum/mood_event/brushed/self
	description = span_nicegreen("I brushed my hair recently!\n")
	mood_change = 2		// You can't hit all the right spots yourself, or something

/datum/map_template/ruin/jungle/ventilation_shaft
	id = "ventshaft"
	suffix = "jungle_ventilation.dmm"
	name = "Shaft 39X"
	description = "Among civilian vessels the most common cause of tragedy is lack of food. \
	This ship was outfitted with a multitude of food-generating features, then summarily ran into an asteroid shortly after takeoff."

/area/ruin/jungle/ventilation_shaft
	name = "Ventilation Shaft"
	icon_state = "green"
	lighting_colour_tube = "#ffce93"
	lighting_colour_bulb = "#ffbc6f"
	lighting_brightness_bulb = 8

/turf/open/chasm/jungle/plantary
	icon = 'icons/turf/floors/junglechasm.dmi'
	icon_state = "junglechasm-255"
	base_icon_state = "junglechasm"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/chasm/jungle/plantary

/turf/open/chasm/jungle/plantary/open
	icon = 'icons/turf/floors/junglechasm.dmi'
	icon_state = "junglechasm-255"
	base_icon_state = "junglechasm"
	baseturfs = /turf/open/chasm/jungle/plantary/open
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_TURF_CHASM, SMOOTH_GROUP_CLOSED_TURFS)
	canSmoothWith = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_TURF_CHASM, SMOOTH_GROUP_CLOSED_TURFS)

/turf/open/floor/plasteel/tech/grid/root
	name = "electrostatic floor"
	desc = "A floor modified with ports that can support rooting ethereals."

/obj/structure/sign/poster/crux
	name = "wanted poster (Crux)"
	desc = "A poster declaring Crux to be a dangerous individual, wanted by Nanotrasen. Report any sightings to nanotrasen authorites immediately."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "poster_wanted_crux"


/datum/outfit/sprout_rebel
	name = "Sprout Rebel"
	uniform = /obj/item/clothing/under/pants/black
	suit = null
	belt = /obj/item/storage/belt/grenade/modified
	shoes = /obj/item/clothing/shoes/jackboots
	neck = null
	mask = /obj/item/clothing/mask/gas/sechailer
	glasses = /obj/item/clothing/glasses/welding/steampunk_goggles
	r_pocket = /obj/item/melee/knife/mindblade/sprout
	l_pocket = /obj/item/storage/bag/bullet_fabricator
	gloves = /obj/item/clothing/gloves/fingerless
	back = /obj/item/storage/backpack/satchel/leather
	implants = list(/obj/item/implant/third_circle, /obj/item/implant/weapons_auth)

	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a458=1,\
		/obj/item/storage/firstaid/regular=1,\
		/obj/item/reagent_containers/medigel/styptic=1, \
		/obj/item/reagent_containers/medigel/silver_sulf=1, \
		/obj/item/flashlight=1,\
		/obj/item/lodestone_gem=1,\
		/obj/item/grenade/c4/x4=1)

/datum/outfit/sprout_rebel/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.faction |= list(FACTION_ARCHOUS)

/obj/item/clothing/glasses/welding/steampunk_goggles
	name = "steampunk goggles"
	desc = "These brass goggles have a toggleable slit for welding."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	mob_overlay_icon = 'code/modules/archonic/icons/worn/eyes.dmi'
	icon_state = "goldengoggles"
	slot_flags = ITEM_SLOT_EYES
	flash_protect = FLASH_PROTECTION_NONE
	flags_cover = GLASSESCOVERSEYES
	custom_materials = null // Don't want that to go in the autolathe
	visor_vars_to_toggle = 0
	tint = 0
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/toggle_steampunk_goggles_welding_protection)

	/// Was welding protection added yet?
	var/welding_upgraded = FALSE
	/// Was welding protection toggled on, if welding_upgraded is TRUE?
	var/welding_protection = FALSE
	/// The sound played when toggling the shutters.
	var/shutters_sound = 'sound/effects/clock_tick.ogg'

/obj/item/clothing/glasses/welding/steampunk_goggles/Initialize(mapload)
	. = ..()
	visor_toggling()

/obj/item/clothing/glasses/welding/steampunk_goggles/examine(mob/user)
	. = ..()
	. += "Its are currently [welding_protection ? "closed" : "opened"]."

/obj/item/clothing/glasses/welding/steampunk_goggles/visor_toggling()
	. = ..()
	slot_flags = up ? ITEM_SLOT_EYES | ITEM_SLOT_HEAD : ITEM_SLOT_EYES
	toggle_vision_effects()

/obj/item/clothing/glasses/welding/steampunk_goggles/weldingvisortoggle(mob/user)
	. = ..()
	handle_sight_updating(user)

/// Proc that handles the whole toggling the welding protection on and off, with user feedback.
/obj/item/clothing/glasses/welding/steampunk_goggles/proc/toggle_shutters(mob/user)
	if(!can_use(user) || !user)
		return FALSE
	if(!toggle_welding_protection(user))
		return FALSE

	to_chat(user, span_notice("You slide \the [src]'s welding shutters slider, [welding_protection ? "closing" : "opening"] them."))
	playsound(user, shutters_sound, 100, TRUE)
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		carbon_user.head_update(src, forced = 1)
	return TRUE

/// This is the proc that handles toggling the welding protection, while also making sure to update the sight of a mob wearing it.
/obj/item/clothing/glasses/welding/steampunk_goggles/proc/toggle_welding_protection(mob/user)
	welding_protection = !welding_protection

	visor_vars_to_toggle = welding_protection ? VISOR_FLASHPROTECT | VISOR_TINT : initial(visor_vars_to_toggle)
	toggle_vision_effects()
	// We also need to make sure the user has their vision modified. We already checked that there was a user, so this is safe.
	handle_sight_updating(user)
	return TRUE

/// Proc handling changing the flash protection and the tint of the goggles.
/obj/item/clothing/glasses/welding/steampunk_goggles/proc/toggle_vision_effects()
	if(welding_protection)
		if(visor_vars_to_toggle & VISOR_FLASHPROTECT)
			flash_protect = up ? FLASH_PROTECTION_NONE : FLASH_PROTECTION_WELDER
	else
		flash_protect = FLASH_PROTECTION_NONE
	tint = flash_protect

/// Proc handling to update the sight of the user, while forcing an update_tint() call every time, due to how the welding protection toggle works.
/obj/item/clothing/glasses/welding/steampunk_goggles/proc/handle_sight_updating(mob/user)
	if(user && (user.get_item_by_slot(ITEM_SLOT_HEAD) == src || user.get_item_by_slot(ITEM_SLOT_EYES) == src))
		user.update_sight()
		if(iscarbon(user))
			var/mob/living/carbon/carbon_user = user
			carbon_user.update_tint()
			carbon_user.head_update(src, forced = TRUE)

/obj/item/clothing/glasses/welding/steampunk_goggles/ui_action_click(mob/user, actiontype, is_welding_toggle = FALSE)
	if(!is_welding_toggle)
		return ..()
	else
		toggle_shutters(user)

/// Action button for toggling the welding shutters (aka, welding protection) on or off.
/datum/action/item_action/toggle_steampunk_goggles_welding_protection
	name = "Toggle Welding Shutters"

/// We need to do a bit of code duplication here to ensure that we do the right kind of ui_action_click(), while keeping it modular.
/datum/action/item_action/toggle_steampunk_goggles_welding_protection/Trigger(trigger_flags)
	if(!IsAvailable())
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_ACTION_TRIGGER, src) & COMPONENT_ACTION_BLOCK_TRIGGER)
		return FALSE
	if(!target || !istype(target, /obj/item/clothing/glasses/welding/steampunk_goggles))
		return FALSE

	var/obj/item/clothing/glasses/welding/steampunk_goggles/goggles = target
	goggles.ui_action_click(owner, src, is_welding_toggle = TRUE)
	return TRUE


/obj/item/melee/knife/mindblade/sprout
	name = "SPLF fanblade"
	icon_state = "survivalknife"
	item_state = "survivalknife"
	desc = "A standard issue among higher ranking SPLF militia members. A sharp blade capable of fanning out into a shield. A small light is attached to the crossguard, this one appears to be broken."
	mindspace = FALSE
	light_on = FALSE

/obj/item/implant/third_circle
	name = "aimtisalized archonic crystal"
	desc = "A contorted and warped archonic crystal. It now beats with the third circle's light."
	activated = FALSE
	var/obj/effect/proc_holder/spell/spell = /obj/effect/proc_holder/spell/self/bioresonance/transis/aimtiacrystal

/obj/item/implant/third_circle/Initialize()
    . = ..()
    if(ispath(src.spell))
        src.spell = new spell

/obj/item/implant/third_circle/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if (.)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.physiology.armor.melee += 30 // Passive Principle of Conviction
			H.physiology.armor.bullet += 30 // Passive Principle of Conviction
		ADD_TRAIT(target, TRAIT_ANOMALY_IMMUNE_AIMTIACRYSTAL, "implant") //Archonic Principle of Firebrand(Absorbting lower anomalistic energy) aimtisalized into a partial fusion of Firebrand and Silence
		ADD_TRAIT(target, TRAIT_GUNSLINGER, "implant") //Quirks
		ADD_TRAIT(target, TRAIT_LIGHT_STEP, "implant") //Quirks
		ADD_TRAIT(target, TRAIT_FREERUNNING, "implant") //Passive Principle of Transis
		if (!spell)
			return FALSE
		if (spell.clothes_req)
			spell.clothes_req = FALSE
		target.AddSpell(spell)
		return TRUE

/obj/item/implant/third_circle/removed(mob/target, silent = FALSE, special = 0)
	. = ..()
	if (.)
		target.RemoveSpell(spell)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.physiology.armor.melee -= 25
			H.physiology.armor.bullet -= 25
		if(target.stat != DEAD && !silent)
			to_chat(target, "<span class='boldnotice'>The knowledge of how to cast [spell] slips out from your mind.</span>")
		REMOVE_TRAIT(target, TRAIT_ANOMALY_IMMUNE_AIMTIACRYSTAL, "implant")

/obj/item/implant/third_circle/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> UNKNOWN<BR>
				<b>Life:</b> UNKNOWN<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> UNKNOWN." : "None"]"}
	return dat

/obj/item/storage/belt/grenade/modified
	name = "modified grenadier belt"
	desc = "A belt for holding grenades. This one has been modified with a holster."
	icon_state = "grenadebeltnew"
	item_state = "grenadebeltnew"

/obj/item/storage/belt/grenade/modified/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 40
	STR.display_numerical_stacking = TRUE
	STR.max_combined_w_class = 80
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/grenade,
		/obj/item/screwdriver,
		/obj/item/lighter,
		/obj/item/multitool,
		/obj/item/wirecutters,
		/obj/item/gun/ballistic/revolver/sprout,
		/obj/item/grenade/c4
		))

/obj/item/storage/belt/grenade/modified/PopulateContents()
	var/static/items_inside = list(
		/obj/item/grenade/chem_grenade/lexorin = 6,
		/obj/item/grenade/chem_grenade/multiacid = 7,
		/obj/item/grenade/chem_grenade/smoke_and_bomb = 8,
		/obj/item/grenade/chem_grenade/color_smoke = 9,
		/obj/item/grenade/c4 = 3,
		/obj/item/grenade/empgrenade = 1,
		/obj/item/screwdriver = 1,
		/obj/item/gun/ballistic/revolver/sprout = 1,
		/obj/item/wirecutters = 1,
		/obj/item/multitool = 1)
	generate_items_inside(items_inside,src)

/obj/item/grenade/chem_grenade/smoke_and_bomb
	name = "chemical grenade"
	desc = "A red crossed circle is spray painted onto it."
	color = "#FF7777"
	stage = GRENADE_READY
	ex_dev = 1
	ex_heavy = 2
	ex_light = 4
	ex_flame = 2

/obj/item/grenade/chem_grenade/smoke_and_bomb/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/bottle/B1 = new(src)
	var/obj/item/reagent_containers/glass/bottle/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/phosphorus, 10)
	B1.reagents.add_reagent(/datum/reagent/potassium, 5)
	B1.reagents.add_reagent(/datum/reagent/toxin/heparin, 15)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 10)
	B2.reagents.add_reagent(/datum/reagent/potassium, 5)
	B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/red, 5)
	B2.reagents.add_reagent(/datum/reagent/toxin/heparin, 10)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/lexorin
	name = "chemical grenade"
	desc = "A green 'X' is spray painted onto it."
	color = "#B8EB65"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/lexorin/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/meta/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/meta/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/phosphorus, 80)
	B1.reagents.add_reagent(/datum/reagent/potassium, 40)
	B1.reagents.add_reagent(/datum/reagent/toxin/lexorin, 60)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 80)
	B2.reagents.add_reagent(/datum/reagent/potassium, 40)
	B2.reagents.add_reagent(/datum/reagent/toxin/lexorin, 55)
	B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/green, 5)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/multiacid
	name = "chemical grenade"
	desc = "A blue 'O' is spray painted onto it."
	color = "#65C5EB"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/multiacid/Initialize()
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/meta/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/meta/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/phosphorus, 60)
	B1.reagents.add_reagent(/datum/reagent/potassium, 30)
	B1.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 90)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 60)
	B2.reagents.add_reagent(/datum/reagent/potassium, 30)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid, 40)
	B2.reagents.add_reagent(/datum/reagent/toxin/acid/nitracid, 45)
	B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/blue, 5)

	beakers += B1
	beakers += B2

/obj/item/grenade/chem_grenade/color_smoke
	name = "smoke grenade"
	desc = "A white '-' is spray painted onto it."
	color = "#E27FFF"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/color_smoke/Initialize()
	. = ..()

	var/obj/item/reagent_containers/glass/beaker/meta/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/meta/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/phosphorus, 118)
	B1.reagents.add_reagent(/datum/reagent/potassium, 59)
	B2.reagents.add_reagent(/datum/reagent/consumable/sugar, 118)
	B2.reagents.add_reagent(/datum/reagent/potassium, 59)
	color = pick("#FF7777","#FF8600","#FFF200","#B8EB65","#65C5EB",
		"#E27FFF")
	switch(color)
		if("#ff7777")
			B1.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/red, 3)
			B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/red, 3)
		if("#ff8600")
			B1.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/orange, 3)
			B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/orange, 3)
		if("#fff200")
			B1.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/yellow, 3)
			B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/yellow, 3)
		if("#b8eb65")
			B1.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/green, 3)
			B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/green, 3)
		if("#65c5eb")
			B1.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/blue, 3)
			B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/blue, 3)
		if("#e27fff")
			B1.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/purple, 3)
			B2.reagents.add_reagent(/datum/reagent/colorful_reagent/powder/purple, 3)
	beakers += B1
	beakers += B2

/obj/item/clothing/suit/armor/vest/syndie_body_armor
	name = "syndicate body armor"
	desc = "A set of red and black body armor. Lightweight but great protection."
	icon_state = "armor_syndie"
	item_state = "armor_syndie"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	mob_overlay_icon = 'code/modules/archonic/icons/worn/armor.dmi'
	blood_overlay_type = "armor"
	dog_fashion = /datum/dog_fashion/back

//Prism revolver
/obj/item/gun/ballistic/revolver/sprout
	name = "\improper 'Prism' makeshift revolver"
	desc = "A well-engineered but clearly makeshift ten shot revolver, reinforced with brass plates. Every bullet it fires carries a small prismatic tracer created as an unintended byproduct of the bullet fabrication process. The designer seems to have left it in for asthetic reasons. Has a custom shaped ergonomic grip. Chambered in .458."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "prism_temp"
	default_ammo_type = /obj/item/ammo_box/magazine/internal/cylinder/sprout_revolver
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/internal/cylinder/sprout_revolver,
	)
	fire_sound = 'sound/weapons/gun/revolver/viper.ogg'
	rack_sound = 'sound/weapons/gun/revolver/viper_prime.ogg'
	manufacturer = MANUFACTURER_NONE
	fire_delay = 0.5 SECONDS
	recoil = 0.5
	recoil_unwielded = 2
	spread = 4
	spread_unwielded = 6

/obj/item/ammo_box/magazine/internal/cylinder/sprout_revolver
	name = "'Prism' cylinder"
	ammo_type = /obj/item/ammo_casing/a458
	max_ammo = 10
	caliber = ".458"
	instant_load = TRUE
	//multiload = TRUE

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a458
	max_ammo = 15
	ammo_type = /obj/item/ammo_casing/a458

/obj/item/ammo_casing/a458
	name = "fabricated .458 bullet casing"
	desc = "A .458 bullet casing. It looks dusty and rough."
	icon_state = "magnum-brass"
	bullet_skin = "surplus"
	caliber = ".458"
	projectile_type = /obj/projectile/bullet/a458

/obj/projectile/bullet/a458
	name = ".458 bullet"
	icon = 'code/modules/archonic/icons/projectiles.dmi'
	icon_state = "prism_bullet_2"
	damage = 75
	armour_penetration = 12
	light_system = MOVABLE_LIGHT
	light_range = 3
	light_power = 0.8
	light_on = FALSE
	speed = BULLET_SPEED_REVOLVER-0.1
	var/tracer_color = null
	var/mutable_appearance/tracer_overlay
	var/static/list/color_list = list(
		"red" = "#FF0000",
		"green" = "#00FF00",
		"blue" = "#0000FF",
		"yellow" = "#FFFF00",
		"cyan" = "#00FFFF",
		"purple" = "#FF00FF"
	)

/obj/projectile/bullet/a458/Initialize(mapload)
	. = ..()
	tracer_color = pick(color_list)
	set_light_color(color_list[tracer_color])
	add_atom_colour(color_list[tracer_color], FIXED_COLOUR_PRIORITY)

/obj/projectile/bullet/a458/fire(setAngle)
	set_light_on(TRUE)
	..()

/obj/projectile/bullet/a458/on_hit(target)
	if(istype(target, /obj/item/grenade))
		var/obj/item/grenade/G = target
		G.prime() //Detonate grenades 100% of the time.
	. = ..()

/obj/item/storage/bag/bullet_fabricator
	name = "bullet fabricator"
	desc = "A bizzare contraption made from the synthesizers of two chem dispensers and a portable seed extractor. It has an ammo patch around attached to the bottom."
	icon = 'icons/obj/bags.dmi'
	icon_state = "portaseeder"
	w_class = WEIGHT_CLASS_SMALL
	var/stored_energy = 0

/obj/item/storage/bag/bullet_fabricator/examine(mob/user)
	. = ..()
	. += "You can activate fabricator by pressing the <b>unique action</b> key. By default, this is <b>space</b>"
	. += "\The [name]'s display reads <span class='alert'>[stored_energy]</span>. What this number means is a mystery to you."

/obj/item/storage/bag/bullet_fabricator/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 200
	STR.max_items = 8
	STR.insert_preposition = "in"
	STR.set_holdable(list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a458,
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/grown
		))

/obj/item/storage/bag/bullet_fabricator/unique_action(mob/living/user)
	if(usr.incapacitated())
		return
	var/made_bullets = FALSE
	var/processed_contents = FALSE
	for(var/obj/item/O in contents)
		if(istype(O, /obj/item/stack/sheet/mineral/wood))
			var/obj/item/stack/sheet/mineral/wood/W = O
			stored_energy += W.amount*3 //33 wood = one stack
			qdel(W)
			processed_contents = TRUE
		if(istype(O, /obj/item/reagent_containers/food/snacks/meat))
			var/obj/item/reagent_containers/food/snacks/meat/M = O
			stored_energy += 9 //11.1(12) meat = one stack
			qdel(M)
			processed_contents = TRUE
		if(istype(O, /obj/item/reagent_containers/food/snacks/grown))
			var/obj/item/reagent_containers/food/snacks/grown/G = O
			stored_energy += 16 //16.6(17) plants = one stack
			qdel(G)
			processed_contents = TRUE
		if(stored_energy >= 100)
			made_bullets = TRUE
			new /obj/item/ammo_box/magazine/ammo_stack/prefilled/a458(src)
			stored_energy = 0
	if(made_bullets)
		to_chat(user, "<span class='notice'>\The [src] fabricates a stack of .458 bullets.</span>")
	if(processed_contents)
		to_chat(user, "<span class='notice'>\The [src] processes its organic contents.</span>")
		playsound(src.loc, 'sound/machines/ding.ogg', 50, TRUE)
	else
		to_chat(user, "<span class='alert'>\The [src] fails to find any compatable organic material.</span>")
	return 1

//Unnamed firework gun.
// Shoots mostly orange sparklers with a rare chance to fire bright red flares.



//Bluespace Distorter
/obj/projectile/energy/bluespace //launcher-type weapon that shoots bluespace crystals.
	name = "distorter shot"
	icon_state = "cbbolt"
	damage = 80
	damage_type = BRUTE
	armour_penetration = 95
	nodamage = FALSE
	light_system = MOVABLE_LIGHT
	light_range = 1.5
	light_power = 1
	light_color = COLOR_BLUE_LIGHT
	var/blink_range = 4 // The teleport range of the limb/gibs.

/obj/projectile/energy/bluespace/on_hit(atom/target, blocked = FALSE)
	..()
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		var/obj/item/bodypart/target_limb
		target_limb = C.check_limb_hit(def_zone)
		var/turf/T = get_turf(C)
		new /obj/effect/particle_effect/sparks(T)
		playsound(loc, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		if(target_limb.dismember(BRUTE)) //Broken. //Make it so when it hits chest/head it teleports out an organ and gibs(the effect not just exploding the guy).
			C.visible_message("<span class='danger'>[C]'s [parse_zone(target_limb)] is violently teleported off their body!</span>", \
						"<span class='userdanger'>Your [parse_zone(target_limb)] is violently teleported off your body!</span>", null, COMBAT_MESSAGE_RANGE)
			do_teleport(target_limb, get_turf(C), blink_range, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
