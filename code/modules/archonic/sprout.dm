/area/outpost/exterior/sprout
	name = "Streetways"
	icon_state = "green"
	sound_environment = SOUND_ENVIRONMENT_CAVE
	ambientsounds = SPOOKY
	lighting_colour_tube = "#dfffac"
	lighting_colour_bulb = "#c9fc9f"
	lighting_brightness_tube = 7

/area/outpost/maintenance/sprout
	name = "Ventilation"
	icon_state = "maintcentral"

/area/outpost/medical/sprout
	name = "Unnamed Clinic"

/area/outpost/crew/bar/sprout
	name = "Unnamed Bar"
	icon_state = "bar"
	lighting_colour_tube = "#fff4d6"
	lighting_colour_bulb = "#ffebc1"
	sound_environment = SOUND_AREA_WOODFLOOR

/datum/map_template/ruin/jungle/esrocathia_bulwark
	id = "esrocathia_bulwark"
	suffix = "jungle_esrocathia_bulwark.dmm"
	name = "Esrocathia Bulwark"
	description = "Among civilian vessels the most common cause of tragedy is lack of food. \
	This ship was outfitted with a multitude of food-generating features, then summarily ran into an asteroid shortly after takeoff."

/area/ruin/jungle/esrocathia_bulwark
	name = "Esrocathia Bulwark"
	icon_state = "green"
	flags_1 = null

/area/ruin/jungle/esrocathia_bulwark/shipyard_shack
	name = "Esrocathia Bulwark Shipyard Maintenance Shack"
	icon_state = "green"

/area/ruin/jungle/esrocathia_bulwark/pillbox
	name = "Esrocathia Bulwark Pillbox"
	icon_state = "green"

/area/ruin/jungle/esrocathia_bulwark/pillbox/one
	name = "Esrocathia Bulwark Pillbox One"
	icon_state = "awaycontent1"

/area/ruin/jungle/esrocathia_bulwark/pillbox/two
	name = "Esrocathia Bulwark Pillbox Two"
	icon_state = "awaycontent2"

/area/ruin/jungle/esrocathia_bulwark/pillbox/three
	name = "Esrocathia Bulwark Pillbox Three"
	icon_state = "awaycontent3"

/area/ruin/jungle/esrocathia_bulwark/pillbox/four
	name = "Esrocathia Bulwark Pillbox Four"
	icon_state = "awaycontent4"

/area/ruin/jungle/esrocathia_bulwark/pillbox/five
	name = "Esrocathia Bulwark Pillbox Five"
	icon_state = "awaycontent5"

/area/ruin/jungle/esrocathia_bulwark/pillbox/six
	name = "Esrocathia Bulwark Pillbox Six"
	icon_state = "awaycontent6"

/area/ruin/jungle/esrocathia_bulwark/pillbox/seven
	name = "Esrocathia Bulwark Pillbox Seven"
	icon_state = "awaycontent7"

/area/ruin/jungle/esrocathia_bulwark/watchtower
	name = "Esrocathia Bulwark Watchtower"
	icon_state = "blue2"
	lighting_colour_tube = "#c0f3f5"
	lighting_colour_bulb = "#8dc6ca"

/area/ruin/jungle/esrocathia_bulwark/commtower
	name = "Esrocathia Bulwark Communications Tower"
	icon_state = "tcomsatcham"
	lighting_colour_tube = "#e2feff"
	lighting_colour_bulb = "#d5fcff"

/area/ruin/jungle/esrocathia_bulwark/power_coupling
	name = "Esrocathia Bulwark Power Coupling"
	icon_state = "engine_smes"

/area/ruin/jungle/esrocathia_bulwark/personnel_garrison
	name = "Esrocathia Bulwark Personnel Garrison"
	icon_state = "security"

/area/ruin/jungle/esrocathia_bulwark/mech_garrison
	name = "Esrocathia Bulwark Exosuit Garrison"
	icon_state = "workshop"

//Yet to be named Esrocathia Defence shield system//

#define ESA_NEEDS_SCREWDRIVER 0
#define ESA_NEEDS_WELDING 1
#define ESA_NEEDS_PLASTEEL 2
#define ESA_NEEDS_WRENCH 3

/obj/machinery/esrocathia_shield_aux //Shamelessly ripped off the gravity generator
	name = "auxiliary shield generator"
	desc = "A device which extends an energy shield around the city."
	icon = 'icons/obj/machines/gravity_generator.dmi'
	density = TRUE
	move_resist = INFINITY
	use_power = NO_POWER_USE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/sprite_number = 0

/obj/machinery/esrocathia_shield_aux/safe_throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE)
	return FALSE

/obj/machinery/esrocathia_shield_aux/ex_act(severity, target)
	if(severity == 1) // Very sturdy.
		set_broken()

/obj/machinery/esrocathia_shield_aux/zap_act(power, zap_flags)
	..()
	if(zap_flags & ZAP_MACHINE_EXPLOSIVE)
		qdel(src)//like the singulo, tesla deletes it. stops it from exploding over and over

/obj/machinery/esrocathia_shield_aux/update_icon_state()
	icon_state = "[get_status()]_[sprite_number]"
	return ..()

/obj/machinery/esrocathia_shield_aux/proc/get_status()
	return "off"

// You aren't allowed to move.
/obj/machinery/esrocathia_shield_aux/Move()
	. = ..()
	qdel(src)

/obj/machinery/esrocathia_shield_aux/proc/set_broken()
	obj_break()

/obj/machinery/esrocathia_shield_aux/proc/set_fix()
	set_machine_stat(machine_stat & ~BROKEN)

/obj/machinery/esrocathia_shield_aux/part/Destroy()
	if(main_part)
		qdel(main_part)
	set_broken()
	return ..()

/obj/machinery/esrocathia_shield_aux/part
	var/obj/machinery/esrocathia_shield_aux/main/main_part = null

/obj/machinery/esrocathia_shield_aux/part/attackby(obj/item/I, mob/user, params)
	return main_part.attackby(I, user)

/obj/machinery/esrocathia_shield_aux/part/get_status()
	return main_part?.get_status()

/obj/machinery/esrocathia_shield_aux/part/attack_hand(mob/user)
	return main_part.attack_hand(user)

/obj/machinery/esrocathia_shield_aux/part/set_broken()
	..()
	if(main_part && !(main_part.machine_stat & BROKEN))
		main_part.set_broken()

/obj/machinery/esrocathia_shield_aux/part/proc/on_update_icon(obj/machinery/esrocathia_shield_aux/source, updates, updated)
	SIGNAL_HANDLER
	return update_appearance(updates)


/obj/machinery/esrocathia_shield_aux/main/active/Initialize()
	. = ..()
	setup_parts()
	middle.add_overlay("activated")

/obj/machinery/esrocathia_shield_aux/main
	icon_state = "on_8"
	idle_power_usage = 0
	active_power_usage = ACTIVE_DRAW_EXTREME*20
	power_channel = AREA_USAGE_ENVIRON
	sprite_number = 8
	use_power = IDLE_POWER_USE
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OFFLINE
	var/active = TRUE //Are the shields up
	var/breaker = TRUE //Are the shields turned on
	var/list/parts = list()
	var/obj/middle = null
	var/charging_state = TRUE //False for powering down
	var/shield_integrity = 100 //How up are the shields
	var/current_overlay = null
	var/broken_state = 0
	var/shield_id = null

/obj/machinery/esrocathia_shield_aux/main/Destroy() // If we somehow get deleted, remove all of our other parts.
	active = FALSE

	for(var/obj/machinery/esrocathia_shield_aux/part/O in parts)
		O.main_part = null
		if(!QDESTROYING(O))
			qdel(O)
	return ..()

/obj/machinery/esrocathia_shield_aux/main/proc/setup_parts()
	var/turf/our_turf = get_turf(src)
	// 9x9 block obtained from the bottom middle of the block
	var/list/spawn_turfs = block(locate(our_turf.x - 1, our_turf.y + 2, our_turf.z), locate(our_turf.x + 1, our_turf.y, our_turf.z))
	var/count = 10
	for(var/turf/T in spawn_turfs)
		count--
		if(T == our_turf) // Skip our turf.
			continue
		var/obj/machinery/esrocathia_shield_aux/part/part = new(T)
		if(count == 5) // Middle
			middle = part
		if(count <= 3) // Their sprite is the top part of the generator
			part.density = FALSE
			part.layer = WALL_OBJ_LAYER
		part.sprite_number = count
		part.main_part = src
		parts += part
		part.update_appearance()
		part.RegisterSignal(src, COMSIG_ATOM_UPDATED_ICON, TYPE_PROC_REF(/obj/machinery/esrocathia_shield_aux/part, on_update_icon))

/obj/machinery/esrocathia_shield_aux/main/proc/connected_parts()
	return parts.len == 8

/obj/machinery/esrocathia_shield_aux/main/set_broken()
	..()
	for(var/obj/machinery/esrocathia_shield_aux/M in parts)
		if(!(M.machine_stat & BROKEN))
			M.set_broken()
	middle.cut_overlays()
	shield_integrity = 0
	breaker = FALSE
	set_power()
	set_state(0)

/obj/machinery/esrocathia_shield_aux/main/set_fix()
	..()
	for(var/obj/machinery/esrocathia_shield_aux/M in parts)
		if(M.machine_stat & BROKEN)
			M.set_fix()
	broken_state = FALSE
	update_appearance()
	set_power()

// Interaction

// Fixing the gravity generator.
/obj/machinery/esrocathia_shield_aux/main/attackby(obj/item/I, mob/user, params)
	switch(broken_state)
		if(ESA_NEEDS_SCREWDRIVER)
			if(I.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, "<span class='notice'>You secure the screws of the framework.</span>")
				I.play_tool_sound(src)
				broken_state++
				update_appearance()
				return
		if(ESA_NEEDS_WELDING)
			if(I.tool_behaviour == TOOL_WELDER)
				if(I.use_tool(src, user, 0, volume=50, amount=1))
					to_chat(user, "<span class='notice'>You mend the damaged framework.</span>")
					broken_state++
					update_appearance()
				return
		if(ESA_NEEDS_PLASTEEL)
			if(istype(I, /obj/item/stack/sheet/plasteel))
				var/obj/item/stack/sheet/plasteel/PS = I
				if(PS.get_amount() >= 10)
					PS.use(10)
					to_chat(user, "<span class='notice'>You add the plating to the framework.</span>")
					playsound(src.loc, 'sound/machines/click.ogg', 75, TRUE)
					broken_state++
					update_appearance()
				else
					to_chat(user, "<span class='warning'>You need 10 sheets of plasteel!</span>")
				return
		if(ESA_NEEDS_WRENCH)
			if(I.tool_behaviour == TOOL_WRENCH)
				to_chat(user, "<span class='notice'>You secure the plating to the framework.</span>")
				I.play_tool_sound(src)
				set_fix()
				return
	return ..()


// Power and Icon States

/obj/machinery/esrocathia_shield_aux/main/power_change()
	. = ..()
	set_power()

/obj/machinery/esrocathia_shield_aux/main/get_status()
	if(machine_stat & BROKEN)
		return "fix[min(broken_state, 3)]"
	return active || charging_state ? "on" : "off"

// Set the charging state based on power/breaker.
/obj/machinery/esrocathia_shield_aux/main/proc/set_power()
	var/new_state = FALSE
	if(machine_stat & (NOPOWER|BROKEN) || !breaker)
		new_state = FALSE
		set_idle_power()
	else if(breaker)
		set_active_power()
		new_state = TRUE
	charging_state = new_state // Startup sequence animation.
	update_appearance()

// Bring the shield up(or down)
/obj/machinery/esrocathia_shield_aux/main/proc/set_state(new_state)
	active = new_state
	update_appearance()

// Charge/Discharge and turn on/off gravity when you reach 0/100 percent.
// Also emit radiation and handle the overlays.
/obj/machinery/esrocathia_shield_aux/main/process()
	if(machine_stat & BROKEN)
		return
	if(charging_state && shield_integrity >= 100)
		set_state(1)
	else if(!charging_state && shield_integrity <= 0)
		set_state(0)
	else
		if(charging_state)
			shield_integrity += 2
		else if(!charging_state)
			shield_integrity -= 2

		if(shield_integrity % 4 == 0 && prob(75)) // Let them know it is charging/discharging.
			playsound(src.loc, 'sound/effects/empulse.ogg', 100, TRUE)

		if(prob(25)) // To help stop "Your clothes feel warm." spam.
			pulse_radiation()

		var/overlay_state = null
		switch(shield_integrity)
			if(0 to 20)
				overlay_state = null
			if(21 to 40)
				overlay_state = "startup"
			if(41 to 60)
				overlay_state = "idle"
			if(61 to 80)
				overlay_state = "activating"
			if(81 to 100)
				overlay_state = "activated"

		if(overlay_state != current_overlay)
			if(middle)
				middle.cut_overlays()
				if(overlay_state)
					middle.add_overlay(overlay_state)
				current_overlay = overlay_state

/obj/machinery/esrocathia_shield_aux/main/proc/pulse_radiation()
	radiation_pulse(src, 200)
