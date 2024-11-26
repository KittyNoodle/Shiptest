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
	desc = "An ornate, pale-green lantern. The words saltare in auream lucem are enscribed into the lamp"
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

/turf/open/floor/plasteel/tech/grid/root
	name = "electrostatic floor"
	desc = "A floor modified with ports that can support rooting ethereals."

/obj/item/clothing/suit/armor/vest/syndie_body_armor
	name = "syndicate body armor"
	desc = "A set of red and black body armor. Lightweight but great protection."
	icon_state = "armor_syndie"
	item_state = "armor_syndie"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	mob_overlay_icon = 'code/modules/archonic/icons/worn/armor.dmi'
	blood_overlay_type = "armor"
	dog_fashion = /datum/dog_fashion/back

/obj/item/stock_parts/cell/gun/nac
	name = "N.A.C. cartridge"
	desc = "A small black cartridge. It has a data terminal on the bottom region and a small array of life support equipment on the top. A living organism is contained within, the words \"CO-8\" are tattooed onto the upper portion."
	icon_state = "nac_cart"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	ratingdesc = FALSE
	maxcharge = 1
	charge = 1
	chargerate = 0

/obj/item/stock_parts/cell/nac/examine(mob/user)
	. = ..()
	if(charge == 0 && maxcharge == 1)
		. += "The tissue seems off color, slight hemorrhages are visable."

/obj/item/stock_parts/cell/gun/nac/empty
	name = "N.A.C. cartridge(empty)"
	desc = "A small black cartridge. It has a data terminal on the bottom region and a small array of life support equipment on the top."
	icon_state = "nac_cart_empty"
	maxcharge = 0
	charge = 0

/datum/reagent/toxin/paralytic
	name = "P-PPS-02"
	description = "Poly-Plasma Sulfate. A powerful paralyric that prevents nerves from communicating with non-cardiac muscles, simulating sleep paralysis and rendering its victim completely limp."
	silent_toxin = TRUE
	reagent_state = LIQUID
	specific_heat = SPECIFIC_HEAT_PLASMA + 100
	color = "#b32366"
	metabolization_rate = 0.10 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_description = "slight numbness and a sickly sweet flavor"
	taste_mult = 0.8
	accelerant_quality = 5

/datum/reagent/toxin/paralytic/on_mob_end_metabolize(mob/living/carbon/M)
	M.SetParalyzed(5)

/datum/reagent/toxin/paralytic/on_mob_life(mob/living/carbon/M)
	if(current_cycle == 3)
		M.emote("sway")
	if(current_cycle == 4)
		M.manual_emote("stumbles.")
	if(current_cycle >= 5)
		M.AllImmobility(60)
	return ..()

/datum/chemical_reaction/paralytic
	mix_message = "The solution turns a deep bloody purple and becomes slightly viscious."
	results = list(/datum/reagent/toxin/paralytic = 3)
	required_reagents = list(/datum/reagent/medicine/polypyr = 1, /datum/reagent/toxin/plasma = 1, /datum/reagent/toxin/sulfonal = 1)
