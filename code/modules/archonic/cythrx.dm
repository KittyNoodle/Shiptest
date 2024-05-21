/*
///////////////////Im sorry god///////////////////////
///////////////It had to be this way//////////////////
*/

GLOBAL_VAR_INIT(cythrx_wall_resist, 80)
GLOBAL_VAR_INIT(cythrx_tendrils, 20) //good lord do not touch this if you don't know what you are doing
GLOBAL_VAR_INIT(cythrx_delay, 0) //in deciseconds
GLOBAL_VAR_INIT(cythrx_spread, TRUE)


/datum/map_template/ruin/space/refuge
	id = "refuge"
	suffix = "refuge.dmm"
	name = "Refuge"
	description = "Among civilian vessels the most common cause of tragedy is lack of food. \
	This ship was outfitted with a multitude of food-generating features, then summarily ran into an asteroid shortly after takeoff."

/turf/open/indestructible/cythrx
	name = "creeping purple haze"
	desc = "A creeping dark-purple thick fog, or is it smoke? No its something else entirely... Whatever it is <span class='cultitalic'>you really can't seem to make it out, prehaps you should get closer.</span> "
	icon_state = "cascade"
	light_range = 1
	light_color = LIGHT_COLOR_PURPLE
	icon_state = "moss"
	base_icon_state = "moss"
	icon = 'icons/turf/lava_moss.dmi'
	plane = GAME_PLANE
	CanAtmosPass = ATMOS_PASS_NO
	layer = 4.99
	opacity = TRUE
	pixel_x = -9
	pixel_y = -9
	COOLDOWN_DECLARE(spreading_cooldown)
	var/list/try_directions = list(NORTH, SOUTH, EAST, WEST)
	var/spread = TRUE
	var/is_processing = FALSE
	var/cythrx_neighbors = 0

/turf/open/indestructible/cythrx/examine(mob/user)
	. = ..()
	. += "<span class='alien'>You really aught to come closer... really... <span class='cultlarge'>You really should come closer. </span><span class='narsiesmall'>Aren't you curious?</span></span>"

/turf/open/indestructible/cythrx/Initialize(mapload, inherited_virtual_z)
	. = ..()
	for(var/delete_items in contents)
		Consume(delete_items)
	if(GLOB.cythrx_delay)
		COOLDOWN_START(src, spreading_cooldown, GLOB.cythrx_delay)
	START_PROCESSING(SSfastprocess, src)
	is_processing = TRUE

/turf/open/indestructible/cythrx/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/turf/open/indestructible/cythrx/reactivate_turfs in range(1))
		reactivate_turfs.try_directions = list(NORTH, SOUTH, EAST, WEST)
		START_PROCESSING(SSobj, reactivate_turfs)
	. = ..()

/turf/open/indestructible/cythrx/proc/spread()
	if(!length(try_directions))
		return
	var/select_direction = pick(try_directions)
	try_directions -= select_direction
	var/turf/try_movement = get_step(src, select_direction)
	if(istype(try_movement, /turf/open/indestructible/cythrx) || istype(try_movement, /turf/open/space/transit) || istype(try_movement, /turf/closed/indestructible/edge))
		return
	if(try_movement.density && GLOB.cythrx_wall_resist < 100)
		if(prob(GLOB.cythrx_wall_resist))
			try_directions += select_direction
			return
	try_movement.ChangeTurf(/turf/open/indestructible/cythrx)

/turf/open/indestructible/cythrx/process(delta_time)
	if(GLOB.cythrx_delay)
		if(!COOLDOWN_FINISHED(src, spreading_cooldown))
			return
		COOLDOWN_START(src, spreading_cooldown, GLOB.cythrx_delay)
	cythrx_neighbors = 0
	var/turf/try_neighbor = get_step(src, NORTH)
	if(istype(try_neighbor, /turf/open/indestructible/cythrx))
		cythrx_neighbors = cythrx_neighbors + 1
	try_neighbor = get_step(src, SOUTH)
	if(istype(try_neighbor, /turf/open/indestructible/cythrx))
		cythrx_neighbors = cythrx_neighbors + 1
	try_neighbor = get_step(src, EAST)
	if(istype(try_neighbor, /turf/open/indestructible/cythrx))
		cythrx_neighbors = cythrx_neighbors + 1
	try_neighbor = get_step(src, WEST)
	if(istype(try_neighbor, /turf/open/indestructible/cythrx))
		cythrx_neighbors = cythrx_neighbors + 1
	if(!spread || !GLOB.cythrx_spread)
		return
	if(cythrx_neighbors >= 2)
		if(prob(GLOB.cythrx_tendrils))
			spread()
	if(cythrx_neighbors <= 1)
		spread()
	if(!length(try_directions))
		is_processing = FALSE
		STOP_PROCESSING(SSobj, src)

/turf/open/indestructible/cythrx/narsie_act(force, ignore_mobs, probability)
	return

/turf/open/indestructible/cythrx/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(isobserver(arrived))
		return ..()
	if(isliving(arrived))
		dust_mob(arrived)
		return
	Consume(arrived)

/turf/open/indestructible/cythrx/attack_tk(mob/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/jedi = user
	to_chat(jedi, "<span class='cultlarge'>You <span class='revendanger'>SEE</span>, and you do not STOP <span class='revendanger'>SEEING</span>, you cannot stop <span class='revendanger'>SEEING</span>, you will never stop <span class='revendanger'>SE-</span></span>")
	jedi.ghostize()
	var/obj/item/organ/brain/rip_u = locate(/obj/item/organ/brain) in jedi.internal_organs
	if(rip_u)
		rip_u.Remove(jedi)
		qdel(rip_u)
	return

/turf/open/indestructible/cythrx/blob_act(obj/structure/blob/blob)
	if(!blob || isspaceturf(loc)) //does nothing in space
		return
	playsound(src, 'sound/effects/curse3.ogg', 50, TRUE)
	blob.visible_message("<span class='revenwarning'>\The [blob] strikes at \the [src] and is quickly dissolved into \the [src].</span>",
		"<span class='revenwarning'>You feel a draining sensation, <span class='cultbold'>then something more. You will feed something so much more.</span></span>")
	Consume(blob)

/turf/open/indestructible/cythrx/attack_paw(mob/user, list/modifiers)
	dust_mob(user, cause = "monkey attack")

/turf/open/indestructible/cythrx/attack_alien(mob/user, list/modifiers)
	dust_mob(user, cause = "alien attack")

/turf/open/indestructible/cythrx/attack_animal(mob/living/simple_animal/user, list/modifiers)
	var/murder
	if(!user.melee_damage_upper && !user.melee_damage_lower)
		murder = user.friendly_verb_continuous
	else
		murder = user.attack_verb_continuous
	dust_mob(user, \
	"<span class='revenwarning'>[user] unwisely [murder] \the [src], and [user.p_their()] are rapidly consumed by \the [src], leaving only ash...</span>", \
	"<span class='revendanger'>You <span class='cultlarge'>wisely</span> touch \the [src], and you fall into \the [src], your sensation stops as \the [src] invades your body and dissolves your very being.</span>", \
	"simple animal attack")

/turf/open/indestructible/cythrx/attack_robot(mob/user)
	if(Adjacent(user))
		dust_mob(user, cause = "cyborg attack")

/turf/open/indestructible/cythrx/attack_ai(mob/user)
	return

/turf/open/indestructible/cythrx/attack_hulk(mob/user)
	dust_mob(user, cause = "hulk attack")

/turf/open/indestructible/cythrx/attack_larva(mob/user)
	dust_mob(user, cause = "larva attack")

/turf/open/indestructible/cythrx/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.status_flags & GODMODE)
		return

	if(HAS_TRAIT(user, TRAIT_CYTHRXIMMUNE))
		return

	. = TRUE
	if(user.zone_selected != BODY_ZONE_PRECISE_MOUTH)
		dust_mob(user, cause = "hand")
		return

	if(!user.is_mouth_covered())
		if(user.a_intent == INTENT_HARM)
			dust_mob(user,
				"<span class='revenwarning'>As [user] tries to take a bite out of [src], [user.p_they()] falls into [p_them()], rapidly vanishing from view, leaving only dust in their place.</span>",
				"<span class='revendanger'>You try to take a bite out of [src], and bite straight through [p_them()], you feel the sensation of burning and nipping inside your mouth, and taste only your own blood, then taste and feel nothing at all.</span>",
				"attempted bite"
			)
			return

	var/obj/item/bodypart/head/forehead = user.get_bodypart(BODY_ZONE_HEAD)
	if(forehead)
		dust_mob(user,
			"<span class='revenwarning'>As [user]'s forehead is swallowed by the [src], [user.p_their()] rapidly-decaying body quickly follows, as [user.p_their()] is devoured [user.p_their()] body gives way to ash and haze.</span>",
			"<span class='revendanger'>You feel your head fall through [src] and everything suddenly goes silent. Your last thoughts are meaningless as your head and body are rapidly made into nothing.</span>",
			"failed lick"
		)
		return

	dust_mob(user,
		"<span class='revenwarning'>[user] leans in and sticks [user.p_their()] tongue into [src], which rapidly moves into [user.p_their()] mouth, dissolving them from the inside-out. <span class='cultbold'>Maybe they did it wrong, you should try too.</span></span>",
		"<span class='revendanger'>You lean in and stick your tongue into [src]. You are filled with regret as your tongue dissolves away and your lungs and esophagus fill with fire.</span>",
		"failed lick"
	)

/turf/open/indestructible/cythrx/proc/dust_mob(mob/living/nom, vis_msg, mob_msg, cause)
	if(nom.status_flags & GODMODE)
		return
	if(HAS_TRAIT(nom, TRAIT_CYTHRXIMMUNE))
		return
	if(!vis_msg)
		vis_msg = "<span class='revenwarning'>[nom] steps into [src], rapidly decaying into ash as [nom.p_their()] body is unmade. <span class='cultbold'>You feel the urge to follow.</span>"
	if(!mob_msg)
		mob_msg = "<span class='revendanger'>You step into [src]. Your body is dissolved and your mind is unwoven as your very being is consumed. <span class='cultboldtalic'>You feel nothing, you are nothing, you have been, and you will not be.</span>"
	if(!cause)
		cause = "contact"
	nom.visible_message(vis_msg, mob_msg, "<span class='hear'>You feel a sense of <span class='revenwarning'>dread</span> and <span class='cultitalic'>fascination</span> as an indescribable sensation washes over you.</span>")
	investigate_log("has been attacked ([cause]) by [key_name(nom)]", INVESTIGATE_SUPERMATTER)
	playsound(get_turf(src), 'sound/effects/curse3.ogg', 50, TRUE)
	Consume(nom)

/turf/open/indestructible/cythrx/proc/Consume(atom/movable/consumed_object)
	if(isobserver(consumed_object))
		return
	if(isliving(consumed_object))
		var/mob/living/consumed_mob = consumed_object
		if(consumed_mob.status_flags & GODMODE)
			return
		if(HAS_TRAIT(consumed_mob, TRAIT_CYTHRXIMMUNE))
			return
		message_admins("[src] has consumed [key_name_admin(consumed_mob)] [ADMIN_JMP(src)].")
		investigate_log("has consumed [key_name(consumed_mob)].", INVESTIGATE_SUPERMATTER)
		consumed_mob.dust(force = TRUE)
		return
	qdel(consumed_object)

/*/turf/open/indestructible/cythrx/stationary game cannot be normal and not make this when i tell it to make regular cythrxes
	spread = FALSE
*/

/datum/overmap/event/cythrx
	name = "sensor blackout region"
	desc = "An extremely anomalous region preventing any sensor feedback. Its probably a good idea to avoid it."
	token_icon_state = "cythrx"
	chance_to_affect = 100
	spread_chance = 0
	chain_rate = 0

/datum/overmap/event/cythrx/Initialize(position, ...)
	. = ..()
	token.opacity = TRUE
	token.color = "#5A004A"
	token.light_color = "#5A004A"
	token.update_icon()

/datum/overmap/event/cythrx/affect_ship(datum/overmap/ship/controlled/S)
	var/area/source_area = pick(S.shuttle_port.shuttle_areas)
	var/source_object = pick(source_area.contents)
	var/turf/source_turf = get_turf(source_object)
	source_turf.ChangeTurf(/turf/open/indestructible/cythrx)


/client/proc/spawn_event()
	set name = "Spawn Event"
	set category = "Admin.Events"
	set desc = "Spawns the selected /datum/overmap/event subtype."

	if(!holder)
		to_chat(src, "Only administrators may use this command.", confidential = TRUE)
		return
	if(check_rights(R_DEBUG, 1))
		var/datum/overmap/event/event_type
		var/location

		event_type = input("Select the event type to use next.", "Select Event") as null|anything in subtypesof(/datum/overmap/event)
		if(!event_type || !ispath(event_type, /datum/overmap/event))
			return

		var/list/choices = list("Random Overmap Square", "Specific Overmap Square")
		var/choice = input("Select a location for the event.", "Event Location") as null|anything in choices
		switch(choice)
			if(null)
				return
			if("Random Overmap Square")
				location = null
			if("Specific Overmap Square")
				var/loc_x = input(usr, "X overmap coordinate:") as num
				var/loc_y = input(usr, "Y overmap coordinate:") as num
				location = list("x" = loc_x, "y" = loc_y)

		message_admins("[key_name_admin(usr)] is spawning the event [event_type]!")
		log_admin("[key_name(usr)] is spawning the event [event_type]!")

		var/datum/overmap/event/created = new event_type(location)

		message_admins("[key_name_admin(usr)] has spawned the event [created] ([REF(created)], [created.type])!")
		log_admin("[key_name(usr)] has spawned the event [created] ([REF(created)], [created.type])!")

/turf/open/indestructible/crystal
	name = "crystal floor"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"
	light_range = 2
	light_power = 1

/turf/open/indestructible/crystal/active
	icon = 'code/modules/archonic/icons/overic_turf.dmi'
	icon_state = "crystal_blue"

/turf/closed/indestructible/crystal
	name = "crystalline wall"
	desc = "A strange crystalline wall, it seems to hum slightly as you near it."
	icon = 'icons/turf/walls/icewall.dmi'
	var/smooth_icon = 'icons/turf/walls/icewall.dmi'
	icon_state = "icewall-0"
	base_icon_state = "icewall"
	connector_icon = 'icons/turf/connectors/icerock_wall_connector.dmi'
	connector_icon_state = "icerock_wall_connector"
	layer = EDGED_TURF_LAYER
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER | SMOOTH_CONNECTORS
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_MINERAL_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_MINERAL_WALLS)
	light_range = 2
	light_power = 1
	/// these vars set how much the pixels translate. This is meant for turfs that are bigger than 32x32
	var/turf/open/indestructible/turf_type = /turf/open/indestructible/crystal
	var/x_offset = -4
	var/y_offset = -4
	var/has_borders = TRUE

/turf/closed/indestructible/crystal/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(has_borders)
		var/matrix/M = new
		M.Translate(x_offset, y_offset)
		transform = M
		icon = smooth_icon

/turf/closed/indestructible/crystal/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	if(turf_type)
		underlay_appearance.icon = initial(turf_type.icon)
		underlay_appearance.icon_state = initial(turf_type.icon_state)
		return TRUE
	return ..()
