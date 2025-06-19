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

//IRON STAR//
/obj/item/disk/design_disk/adv/ironstar_med
	design_name = "Iron Star experimental medical supplies"
	desc = "A disk for storing device design data for construction in lathes. This one has more extra storage space."
	color = "#652d71"
	illustration = "dna"
	starting_blueprints = list(/datum/design/iron_star_synthread, /datum/design/iron_star_gauze)
	max_blueprints = 3


/obj/item/disk/design_disk/adv/ironstar_med/examine(mob/user)
	. = ..()
	. += "<span class='notice'>You notice a small note scribbled on the back.</span>"

/obj/item/disk/design_disk/adv/ironstar_med/examine_more(mob/user)
	. = ..()
	. += span_notice("Cloth is pretty rare if you can't find somewhere to steal it from. So I managed to find a working synthetic cloth recipe. Should be helpful for gauze.")
	. += "\t<span class='notice'>—Crux CF</span>"

/datum/design/iron_star_synthread
	name = "Experimental Synthetic Cloth"
	desc = "A synthetic cloth made with plastic, glass, and iron."
	id = "iron_star_synthread"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = MINERAL_MATERIAL_AMOUNT/8, /datum/material/iron = MINERAL_MATERIAL_AMOUNT/2, /datum/material/glass = MINERAL_MATERIAL_AMOUNT) //8 per plastic and iron sheet. 4 per glass sheet.
	build_path = /obj/item/stack/sheet/cotton/cloth
	category = list("Imported")
	maxstack = MAX_STACK_SIZE

/datum/design/iron_star_gauze
	name = "Experimental Synthetic Gauze"
	desc = "A synthetic cloth gauze made with plastic, glass, and iron."
	id = "iron_star_gauze"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = MINERAL_MATERIAL_AMOUNT/16, /datum/material/iron = MINERAL_MATERIAL_AMOUNT/4, /datum/material/glass = MINERAL_MATERIAL_AMOUNT/2) //Two per synthetic cloth
	build_path = /obj/item/stack/medical/gauze/synthread
	category = list("Imported")
	maxstack = 12

/obj/item/stack/medical/gauze/synthread
	name = "synthread medical gauze"
	singular_name = "improvised gauze"
	desc = "A roll of elastic synthetic cloth that is extremely effective at stopping bleeding and slowly heals wounds."
	bleed_reduction = 0.015
	amount = 1

/obj/item/disk/design_disk/elite/ironstar_ammo
	design_name = "Iron Star ammunition"
	desc = "A disk for storing device design data for construction in lathes. This one has more extra storage space."
	illustration = "design"
	starting_blueprints = list(/datum/design/iron_star_a556_42_box, /datum/design/iron_star_hydra_mag, /datum/design/iron_star_p16_mag, /datum/design/iron_star_sniper_rounds, /datum/design/iron_star_c57x39_box, /datum/design/iron_star_sidewinder_mag, /datum/design/iron_star_gun_cell_upgraded, /datum/design/iron_star_a70mm_he, /datum/design/iron_star_a70mm_hedp, /datum/design/iron_star_speedload357)
	max_blueprints = 11

/obj/item/disk/design_disk/elite/ironstar_ammo/examine(mob/user)
	. = ..()
	. += "<span class='notice'>You notice a small note scribbled on the back.</span>"

/obj/item/disk/design_disk/elite/ironstar_ammo/examine_more(mob/user)
	. = ..()
	. += span_notice("Not entirely sure what kind of apocalypse you guys might be staring down, so I will run you by the one I might understand. \
	 Archous gets out of the veil, gonna happen eventually, might as well tell you what to do.")
	. += span_notice("1. Close the windows. Not gonna bother explaining this one, light is death.")
	. += span_notice("2. Forget everything you know about the threat level of Archous. Fighting is death, getting touched by violet light is also death. Best case scenario you spend a few hours in the burn ward.")
	. += span_notice("3. Anyone touched by Archonic light is a living tracking device. Treat on site or put them down as necessary. If the exposure was severe enough you won't have to dispose of a body.")
	. += span_notice("4. You treat archonic light exposure by waiting it out. If you have access to the Lamp of Silence, that could help you out.")
	. += span_notice("5. If the archonic light appears to be getting brighter, kill them. You would need some way of isolating your environment from Archous, like another veil.")
	. += span_notice("6. Get light and energy resistant armor. VIME hardsuits should protect you very well from Archonic light.")
	. += span_notice("7. Do not engage Archonicists unless its an absolute necessity. It's better to take your chances starving.")
	. += "\t<span class='notice'>—Crux CF</span>"


/datum/design/iron_star_a556_42_box
	name = "box of 5.56x42mm CLIP ammo (60 rounds)"
	desc = "A box of standard 5.56x42mm CLIP ammo."
	id = "iron_star_a556_42_box"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 54200) //200 + (500*1.8)60
	build_path = /obj/item/storage/box/ammo/a556_42
	category = list("Imported")

/datum/design/iron_star_hydra_mag
	name = "casket Hydra assault rifle magazine (5.56x42mm CLIP)"
	desc = "A very long and bulky 100-round magazine for the Hydra platform of 5.56x42mm CLIP assault rifles. These rounds do moderate damage with good armor penetration."
	id = "iron_star_hydra_mag"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 105000) //1500 + (500*1.8)100
	build_path = /obj/item/ammo_box/magazine/m556_42_hydra/casket
	category = list("Imported")

/datum/design/iron_star_p16_mag
	name = "P-16 magazine (5.56x42mm CLIP)"
	desc = "A simple, 30-round magazine for 5.56x42mm CLIP assault rifles. These rounds do moderate damage with good armor penetration."
	id = "iron_star_p16_mag"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 28500) //1500 + (500*1.8)30
	build_path = /obj/item/ammo_box/magazine/p16
	category = list("Imported")

/datum/design/iron_star_sniper_rounds
	name = "anti-material rifle magazine (.50 BMG)"
	desc = "A large, heavy 6-round box magazine designed for the sniper rifle. These rounds deal absurd damage, able to delimb targets, knock them on their feet, and bypass most protective equipment."
	id = "iron_star_sniper_rounds"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 25500) //1500 + (500*8)6
	build_path = /obj/item/ammo_box/magazine/sniper_rounds
	category = list("Imported")

/datum/design/iron_star_c57x39_box
	name = "box of 5.7x39mm ammo (48 rounds)"
	desc = "A box of standard 5.7x39mm ammo."
	id = "iron_star_c57x39_box"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 36200) //200 + (500*1.5)48
	build_path = /obj/item/storage/box/ammo/c57x39
	category = list("Imported")

/datum/design/iron_star_sidewinder_mag
	name = "Sidewinder magazine (5.7x39mm)"
	desc = "A 30-round magazine for the Sidewinder submachine gun. These rounds do okay damage with average performance against armor."
	id = "iron_star_sidewinder_mag"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 23500) //1500 + (500*1.5)30
	build_path = /obj/item/ammo_box/magazine/m57_39_sidewinder
	category = list("Imported")

/datum/design/iron_star_gun_cell_upgraded
	name = "Upgraded Weapon Power Cell"
	desc = "A upgraded power cell for weapons holds 20 MJ of energy."
	id = "iron_star_gun_cell_upgraded"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 700, /datum/material/gold = 150, /datum/material/silver = 150, /datum/material/glass = 80)
	build_path = /obj/item/stock_parts/cell/gun/upgraded/empty
	category = list("Imported")

/datum/design/iron_star_a70mm_he
	name = "M-KO-9HE rocket"
	desc = "A 70mm High Explosive rocket. Fire at mech and pray."
	id = "iron_star_a70mm_he"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 7500, /datum/material/plasma = 7500)
	build_path = /obj/item/ammo_casing/caseless/rocket/a70mm
	category = list("Imported")

/datum/design/iron_star_a70mm_hedp
	name = "M-KO-9HEDP rocket"
	desc = "A 70mm High Explosive Dual Purpose rocket. Pointy end toward armor."
	id = "iron_star_a70mm_hedp"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/plasma = 7500, /datum/material/silver = 250)
	build_path = /obj/item/ammo_casing/caseless/rocket/a70mm/hedp
	category = list("Imported")

/datum/design/iron_star_speedload357
	name = ".357 revolver speedloader"
	desc = "A speedloader of .357 ammo for use in revolvers."
	id = "iron_star_speedload357"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 15000)
	build_path = /obj/item/ammo_box/a357
	category = list("Imported")

/obj/machinery/power/port_gen/pacman/super/fullupgrade //fully ugpraded stock parts
	circuit = /obj/item/circuitboard/machine/pacman/super/fullupgrade

/obj/item/circuitboard/machine/pacman/super/fullupgrade
	name = "SUPERPACMAN-type Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/port_gen/pacman/super/fullupgrade
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 1,
		/obj/item/stock_parts/micro_laser/quadultra = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor/quadratic = 1)

///////////////////////////

/obj/machinery/porta_turret/ship/archonic
	name = "Archonic Ward"
	desc = "A rune made of an unknown glowing substance."
	icon = 'code/modules/archonic/icons/runes.dmi'
	icon_state = "ward"
	base_icon_state = "ward"
	shot_delay = 10
	scan_range = 15
	stun_projectile = /obj/projectile/beam/archonic/stun
	stun_projectile_sound = 'sound/weapons/laser3.ogg'
	lethal_projectile = /obj/projectile/beam/archonic/death
	lethal_projectile_sound = 'sound/weapons/blastcannon.ogg'
	faction = list(FACTION_ARCHOUS, "turret")
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

/obj/machinery/porta_turret/ship/archonic/hyperlethal
	stun_projectile = /obj/projectile/beam/archonic/bolt

/obj/item/clothing/head/helmet/space/hardsuit/quixote/dimensional/archonic
	name = "\improper VIME hardsuit helmet"
	desc = "The integrated helmet of a VIME hardsuit."
	armor = list("melee" = 50, "bullet" = 55, "laser" = 50, "energy" = 85, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/quixote/dimensional/archonic
	name = "\improper VIME hardsuit"
	armor = list("melee" = 50, "bullet" = 55, "laser" = 50, "energy" = 85, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	desc = "The Voidic Interchange Mobile Exosuit or VIME is an experimental hardsuit designed by the Aetherofusion Nusquamology division. Its design incorporates a thin layer of hyperdense protomatter around it, the layer provides no conventional armor, however protects from the effects of Voidic diffusion."
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/quixote/dimensional/archonic
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
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
	suit = /obj/item/gun/ballistic/automatic/smg/sprout_minigun
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
	//H.faction |= list(FACTION_ARCHOUS)

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

//BRIEF INTERMISSION: SUBDERMAL ARMOR//
/mob/living/carbon/human
	var/datum/armor/subdermal_armor

//The Implant//
/obj/item/implant/third_circle
	name = "aimtisalized archonic crystal"
	desc = "A contorted and warped archonic crystal. It now beats with the third circle's light."
	activated = FALSE
	var/obj/effect/proc_holder/spell/spell = /obj/effect/proc_holder/spell/self/bioresonance/transis/aimtiacrystal
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	//Armor value to be applied to the target.
	var/datum/armor/internal_armor = list("melee" = 30, "bullet" = 35, "laser" = 10, "energy" = 20, "bomb" = 10, "bio" = 20, "rad" = 25, "fire" = 5, "acid" = 20)

/obj/item/implant/third_circle/Initialize()
	. = ..()
	if(ispath(src.spell))
		src.spell = new spell
	if (islist(internal_armor))
		internal_armor = getArmor(arglist(internal_armor))
	else if (!internal_armor)
		internal_armor = getArmor()
	else if (!istype(internal_armor, /datum/armor))
		stack_trace("Invalid type [armor.type] found in .armor during /obj Initialize()")

/obj/item/implant/third_circle/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if (.)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.subdermal_armor = internal_armor // Passive Principle of Conviction
			H.apply_status_effect(/datum/status_effect/aimtisalir_crystal_recalibration)
		ADD_TRAIT(target, TRAIT_ANOMALY_IMMUNE_AIMTIACRYSTAL, "implant") //Archonic Principle of Firebrand(Absorbing lower anomalistic energy) aimtisalized into a partial fusion of Firebrand and Silence
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
			H.subdermal_armor = null
			H.remove_status_effect(/datum/status_effect/aimtisalir_crystal_recalibration)
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

//This insanity//

/datum/status_effect/aimtisalir_crystal_recalibration
	id = "aimcrystal_healing"
	status_type = STATUS_EFFECT_UNIQUE
	examine_text = null
	tick_interval = 30
	var/paused = FALSE

	var/death_prevention_charges = 100
	var/health_threshold = 100
	var/inertia = 100
	var/panic_mode = FALSE
	//Always heal 1.25 archonic damage per interval.
	//When damaged health threshold slowly climbs to our level of health. -0.3 per tick.
	//Has to clear inertia first before it starts climbing down.
	//Inertia goes down by 2 per tick from 100 to 80, 5 per tick from 80 to 30 and 10 per tick from 30 and below. Inertia is instantly dropped to zero once we go below -50.
	//Once it's halfway reached our damage level we heal (100-health_threshold)/80 of our biggest damage source. I.e. activate once health threshold reaches 90 on 80 health.
	//Does not let you die unless death_prevention_charges == 0.
	//Every tick where you would die sets death_prevention_charges to death_prevention_charges-0.5.
	//Triggering death prevention activates panic mode.
	//Panic mode is kept on until we reach -20 health.
	//Panic mode triples health threshold decrease amount.
	//Panic mode successfully turning off costs 10 death charges.
	//Panic mode turns off crit damage.
	//Death prevention charges restore at 0.05 per tick when fully healed.
	//Inertia goes up by 5 every tick once fully healed.
	//All inertia reductions are multiplied by death_prevention_charges/100.
	//
	//Oxyloss is healed at a x1.5 rate
	//Burnloss is healed at a x0.8 rate
	//Toxloss is healed at a x0.75 rate
	//Cloneloss is healed at a x0.1 rate
	//Blood is healed at a x4.5 rate

/datum/status_effect/aimtisalir_crystal_recalibration/tick()

	if(paused)
		return

	if(QDELETED(src))
		return

	if(owner.stat == DEAD)
		return

	on_tick_effects()

/datum/status_effect/aimtisalir_crystal_recalibration/proc/on_tick_effects() //I assure you all of this makes sense.
	if(!ishuman(owner))
		return //Fuck you
	var/mob/living/carbon/human/human_owner = owner
	human_owner.adjust_archonic_sublimation(-1.25)
	//Misc background healing

	human_owner.adjustOrganLoss(ORGAN_SLOT_HEART, -0.25) //Heart // 0.25% per tick
	human_owner.adjustOrganLoss(ORGAN_SLOT_LUNGS, -0.5) //Lungs // 0.50% per tick
	human_owner.adjustOrganLoss(ORGAN_SLOT_LIVER, -0.75) //Liver // 0.75% per tick
	human_owner.adjustOrganLoss(ORGAN_SLOT_STOMACH, -0.75)
	human_owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2) //Nerves //1% per tick
	human_owner.adjustOrganLoss(ORGAN_SLOT_EYES, -1) //Nerves //1% per tick
	human_owner.adjustOrganLoss(ORGAN_SLOT_EARS, -1) //Nerves //1% per tick
	if(prob(10))
		human_owner.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)
	if(prob(5*(death_prevention_charges/100)))
		if(human_owner.health >= 100)
			var/list/broken_limbs = list()
			for(var/obj/item/bodypart/limb in human_owner.bodyparts)
				if(limb.bone_status != BONE_FLAG_NORMAL)
					broken_limbs += limb
			var/obj/item/bodypart/chosen_one = pick(broken_limbs)
			chosen_one.fix_bone()
	if(prob(2.5))
		if(human_owner.health >= 100 && inertia >= 100 && death_prevention_charges >= 100)
			var/list/missing_limbs = list()
			var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			for(var/zone in limb_list)
				if(!owner.get_bodypart(zone))
					missing_limbs += zone
			if(missing_limbs.len)
				var/regrow_zone = pick(missing_limbs)
				human_owner.regenerate_limb(regrow_zone)
				human_owner.visible_message("<span class='warning'>Golden glowing flesh slowly stems out from [human_owner]'s [parse_zone(BODY_ZONE_CHEST)], slowly growing into a [parse_zone(regrow_zone)]!!</span>")
				human_owner.adjustCloneLoss(10)
				var/obj/item/bodypart/regrown_limb = owner.get_bodypart(regrow_zone)
				human_owner.apply_damage(regrown_limb.max_damage, BRUTE, regrow_zone, 0, TRUE, FALSE, 0)
				inertia = 0
				health_threshold = max(0, human_owner.health) //The system knows what its doing.

	//to_chat(world, "HP: [human_owner.health]")
	//Death fuckery
	if(HAS_TRAIT(human_owner, TRAIT_NODEATH)) //Should we be preventing death
		if(should_be_dead()) //Should we be dead right now
			death_prevention_charges = max(0, death_prevention_charges-0.5) //If yes then we use half a charge.
			if(!panic_mode) //If we aren't in panic mode, go to panic mode.
				panic_mode = TRUE
				//to_chat(world, "PANIC ON")
		if(death_prevention_charges <= 0) //If we can't sustain it anymore, stop it. Die.
			REMOVE_TRAIT(human_owner, TRAIT_NODEATH, "aimcrystal_healing")
		if(panic_mode)
			ADD_TRAIT(human_owner, TRAIT_NOCRITDAMAGE, "aimcrystal_healing")
		else
			REMOVE_TRAIT(human_owner, TRAIT_NOCRITDAMAGE, "aimcrystal_healing")
	else
		if(death_prevention_charges > 0) //If we can sustain it now, great! Wonderful! do so.
			ADD_TRAIT(human_owner, TRAIT_NODEATH, "aimcrystal_healing")
			if(panic_mode) //Panic mode's critical stabilization
				ADD_TRAIT(human_owner, TRAIT_NOCRITDAMAGE, "aimcrystal_healing")
			else
				REMOVE_TRAIT(human_owner, TRAIT_NOCRITDAMAGE, "aimcrystal_healing")

	//Inertia
	if(inertia > 0)
		switch(human_owner.health)
			if(80 to 100) //Minor injuries
				if(human_owner.health >= 100) //Are we fully healed?
					inertia = min(100, inertia+(5*(2-(death_prevention_charges/100)))) //0 death prevention charges means double the inertia gain. 50 means 1.5x.
					health_threshold = max(inertia, health_threshold) //Don't want health threshold going down to 0 while climbing up with inertia
					//to_chat(world, "I0")
				else
					inertia = max(0, inertia-(2*(death_prevention_charges/100)))
					//to_chat(world, "I1")
			if(30 to 80) //Major Injuries
				inertia = max(0, inertia-(5*(death_prevention_charges/100)))
				//to_chat(world, "I2")
			if(-50 to 30) //Severe Injuries
				inertia = max(0, inertia-(10*(death_prevention_charges/100)))
				//to_chat(world, "I3")
			if(-INFINITY to -50) //Fuck fuck fuck fuck fuck fuck fuck
				inertia = 0
				//to_chat(world, "I4")
		if(human_owner.health >= 100 && inertia == 100)
			death_prevention_charges = min(100, death_prevention_charges+0.05)
	else //Once we've gotten past inertia
		if(human_owner.health == 100) //Are we fully healed?
			inertia = min(100, inertia+(5*(2-(death_prevention_charges/100)))) //0 death prevention charges means double the inertia gain. 50 means 1.5x.
			health_threshold = max(inertia, health_threshold) //Don't want health threshold going down to 0 while climbing up with inertia
		var/capped_health = max(0, human_owner.health) //Health that's capped at 0 for calculation purposes.
		//var/damage = human_owner.maxHealth-human_owner.health //How much damage has been dealt //Commented out for warning reasons.
		var/capped_damage = human_owner.maxHealth-capped_health //For things like checking to see if we are at a good threshold.
		if(human_owner.health < 100) // Determine health new health_threshold
			if(panic_mode)
				health_threshold = max(capped_health, health_threshold-0.3*3)
			else
				if(human_owner.health < 30)
					health_threshold = max(capped_health, health_threshold-0.15)
				health_threshold = max(capped_health, health_threshold-0.3)
		var/damage_threshold = human_owner.maxHealth-health_threshold
		if(damage_threshold >= capped_damage/2) //Once threshhold has halfway reached our health(or zero if its below it), start doing healing.
			var/heal_amount = (100-health_threshold)/80
			heal_amount = clamp(heal_amount, 0.1, 0.8) //No infinitesimal healing, please.
			heal_amount = -heal_amount //AHAHAHAHAHAHAHAHAH
			var/damage_type_healed = determine_highest_damage()
			//to_chat(world, "DTH: [damage_type_healed]")
			switch(damage_type_healed)
				if(BRUTE)
					human_owner.adjustBruteLoss(heal_amount)
				if(BURN)
					human_owner.adjustFireLoss(heal_amount*0.8)
				if(TOX)
					human_owner.adjustToxLoss(heal_amount*0.75)
				if(OXY)
					human_owner.adjustOxyLoss(heal_amount*1.5)
				if(CLONE)
					human_owner.adjustCloneLoss(heal_amount*0.1)
			//to_chat(world, "Blood: [human_owner.blood_volume]")
			if(human_owner.blood_volume < BLOOD_VOLUME_NORMAL) //Always top up on blood when injured.
				human_owner.blood_volume = min(BLOOD_VOLUME_NORMAL, human_owner.blood_volume + (-heal_amount)*4.5)
				//to_chat(world, "Blood+: [human_owner.blood_volume]")
			//to_chat(world, "Heal: [heal_amount]")
		if(human_owner.health > -30 && panic_mode)
			//to_chat(world, "PANIC OFF")
			panic_mode = FALSE
			death_prevention_charges = max(0, death_prevention_charges-10)
	//to_chat(world, "DPC: [death_prevention_charges]  HT: [health_threshold]  I:[inertia]  Panic:[panic_mode]")


/datum/status_effect/aimtisalir_crystal_recalibration/proc/should_be_dead()
	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.blood_volume <= BLOOD_VOLUME_SURVIVE)
		return 1
	if(human_owner.health <= HEALTH_THRESHOLD_DEAD)
		return 1
	return 0

/datum/status_effect/aimtisalir_crystal_recalibration/proc/determine_highest_damage() //They're calling it the 'worst proc ever'.
	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.getOxyLoss() >= human_owner.getBruteLoss() && human_owner.getOxyLoss() >= human_owner.getFireLoss() && human_owner.getOxyLoss() >= human_owner.getToxLoss() && human_owner.getOxyLoss() >= human_owner.getCloneLoss())
		return OXY
	if(human_owner.getBruteLoss() >= human_owner.getFireLoss() && human_owner.getBruteLoss() >= human_owner.getToxLoss() && human_owner.getBruteLoss() >= human_owner.getOxyLoss() && human_owner.getBruteLoss() >= human_owner.getCloneLoss())
		return BRUTE
	if(human_owner.getFireLoss() >= human_owner.getBruteLoss() && human_owner.getFireLoss() >= human_owner.getToxLoss() && human_owner.getFireLoss() >= human_owner.getOxyLoss() && human_owner.getFireLoss() >= human_owner.getCloneLoss())
		return BURN
	if(human_owner.getToxLoss() >= human_owner.getBruteLoss() && human_owner.getToxLoss() >= human_owner.getFireLoss() && human_owner.getToxLoss() >= human_owner.getOxyLoss() && human_owner.getToxLoss() >= human_owner.getCloneLoss())
		return TOX
	if(human_owner.getCloneLoss() >= human_owner.getBruteLoss() && human_owner.getCloneLoss() >= human_owner.getFireLoss() && human_owner.getCloneLoss() >= human_owner.getToxLoss() && human_owner.getCloneLoss() >= human_owner.getOxyLoss())
		return CLONE

//Equipment//

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
/obj/item/gun/ballistic/automatic/smg/sprout_minigun
	name = "\improper 'El-Star' makeshift minigun"
	desc = "A hollowed out and repurposed laser gatling gun. Several reinforcing brass plates have been attached to allow for support of continious ballistic fire. The cell has been replaced with a slot for an ammo belt. A bandolier has been attached to allow for storage over the body."
	icon = 'code/modules/archonic/icons/48x32.dmi'
	mob_overlay_icon = 'code/modules/archonic/icons/worn/armor.dmi'
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'
	icon_state = "sprout_minigun"
	item_state = "sprout_minigun"
	show_magazine_on_sprite = TRUE
	base_pixel_x = -8
	slot_flags = ITEM_SLOT_OCLOTHING | ITEM_SLOT_BACK
	gun_firemodes = list(FIREMODE_FULLAUTO)
	default_firemode = FIREMODE_FULLAUTO
	weapon_weight = WEAPON_HEAVY
	fire_delay = 0.1 SECONDS
	default_ammo_type = /obj/item/ammo_box/magazine/m47_sparkler
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/m47_sparkler,
	)

	recoil = 1
	recoil_unwielded = 5

	gunslinger_recoil_bonus = 3
	gunslinger_spread_bonus = 16

	spread = 8
	spread_unwielded = 14

	wield_delay = 0.6 SECONDS
	wield_slowdown = 0.35

	manufacturer = MANUFACTURER_NONE

/obj/item/gun/ballistic/automatic/smg/sprout_minigun/Initialize(mapload, spawn_empty)
	. = ..()
	if(!magazine)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if(C.back == src)
				C.dropItemToGround(src, TRUE)
				balloon_alert(C, "The [src] falls off your back.")
			else if (ishuman(C))
				var/mob/living/carbon/human/H = C
				if(H.wear_suit == src)
					H.dropItemToGround(src, TRUE)
					balloon_alert(H, "The [src] falls off your back.")
		slot_flags = null

/obj/item/gun/ballistic/automatic/smg/sprout_minigun/eject_magazine(mob/user, display_message = TRUE, obj/item/ammo_box/magazine/tac_load = null)
	. = ..()
	if(!magazine)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if(C.back == src)
				C.dropItemToGround(src, TRUE)
				balloon_alert(C, "The [src] falls off your back.")
			else if (ishuman(C))
				var/mob/living/carbon/human/H = C
				if(H.wear_suit == src)
					H.dropItemToGround(src, TRUE)
					balloon_alert(H, "The [src] falls off your back.")
		slot_flags = null

/obj/item/gun/ballistic/automatic/smg/sprout_minigun/insert_magazine(mob/user, obj/item/ammo_box/magazine/inserted_mag, display_message = TRUE)
	. = ..()
	if(magazine) //WHAT DID YOU DO
		slot_flags = ITEM_SLOT_OCLOTHING | ITEM_SLOT_BACK

/obj/item/ammo_box/magazine/m47_sparkler
	name = "minigun ammo belt (.47 sparkler)"
	desc = "An 190 round belt magazine for the 'El-Star' makeshift minigun. These rounds are designed for maximum supression."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	mob_overlay_icon = 'code/modules/archonic/icons/worn/armor.dmi'
	icon_state = "ammobelt"
	ammo_type = /obj/item/ammo_casing/m47
	max_ammo = 190
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_OCLOTHING | ITEM_SLOT_BACK

/obj/item/ammo_casing/m47
	name = ".47 bullet casing"
	desc = "A .47 bullet casing."
	icon_state = "magnum-brass"
	caliber = ".47"
	projectile_type = /obj/projectile/bullet/m47
	stack_size = 12

/obj/projectile/bullet/m47
	name = ".47 sparkler bullet"
	icon_state = "gauss"
	damage = 23
	range = 40
	armour_penetration = 1
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 1
	light_color = "#FFFF00"
	light_on = FALSE
	speed = BULLET_SPEED_PDW
	var/big_one = FALSE
	var/datum/effect_system/spark_spread/sparks

/obj/projectile/bullet/m47/Initialize(mapload)
	. = ..()
	sparks = new
	sparks.set_up(1, 0, src)
	sparks.attach(src)
	if(prob(15))
		big_one = TRUE
		set_light_color("#ff4b4b")
		sparks.effect_type = /obj/effect/particle_effect/sparks/red
		damage = 27
		armour_penetration = 10
		speed = BULLET_SPEED_PDW+0.1
		light_range = 2
		light_power = 1.6
		icon_state = "gauss-slug"
	else
		sparks.effect_type = /obj/effect/particle_effect/sparks/sparkler


/obj/projectile/bullet/m47/fire(setAngle)
	set_light_on(TRUE)
	..()

/obj/projectile/bullet/m47/on_hit(target)
	if(istype(target, /obj/item/grenade))
		var/obj/item/grenade/G = target
		G.prime() //Detonate grenades 100% of the time.
	. = ..()

/obj/projectile/bullet/m47/Move()
	. = ..()
	var/turf/location = get_turf(src)
	if(location)
		//add sparks and stuff with a 20% chance
		if(big_one)
			sparks.start()
			for(var/mob/living/M in get_hearers_in_view(2, location))
				if(M != firer) // Listen man it's cheating but it's good cheating
					M.flash_act(affect_silicon = 1)
		else if(prob(20))
			sparks.start()

/obj/effect/particle_effect/sparks/sparkler
	light_range = 1

/obj/effect/particle_effect/sparks/red
	light_color = "#ff4b4b"

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
