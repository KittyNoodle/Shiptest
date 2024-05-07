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
