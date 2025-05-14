/*
/datum/overmap/outpost/gateway
	token_icon_state = "gateway"
	main_template = /datum/map_template/outpost/gateway
	elevator_template = /datum/map_template/outpost/elevator_indie

/datum/overmap/outpost/gateway/gen_outpost_name()
	return "ACSV Pandoras Seal"

/datum/overmap/outpost/gateway/Initialize(position, ...)
	. = ..()
	token.opacity = TRUE
	token.color = "#4d4d4d"
	token.update_icon()

*/

/datum/map_template/outpost/gateway
	name = "gateway"

/area/outpost/gateway
	name = "Gateway Subsection"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	area_flags = VALID_TERRITORY | NOTELEPORT // not unique, in case multiple outposts get loaded. all derivatives should also be NOTELEPORT
	flags_1 = null
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/outpost/gateway/engineering
	name = "Engineering"
	icon_state = "engine"
	ambientsounds = ENGINEERING
	lighting_colour_tube = "#ffb7ff"
	lighting_colour_bulb = "#ff9bee"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/outpost/gateway/engineering/atmospherics
	name = "Atmospherics"
	icon_state = "atmos"
	lighting_colour_tube = "#ffce93"
	lighting_colour_bulb = "#ffbc6f"

/area/outpost/gateway/engineering/vsa
	name = "Vacuum State Actuator"
	icon_state = "engine"
	lighting_colour_tube = "#c0f2ec"
	lighting_colour_bulb = "#c0f2ec"

/area/outpost/gateway/hallway
	name = "Hallway"
	lighting_colour_tube = "#FFF6ED"
	lighting_colour_bulb = "#FFE6CC"
	lighting_brightness_tube = 7
	icon_state = "hallC"

/area/outpost/gateway/medical
	name = "Infirmary"
	icon_state = "medbay3"
	ambientsounds = MEDICAL
	lighting_colour_tube = "#e7f8ff"
	lighting_colour_bulb = "#d5f2ff"
	lighting_colour_night = "#d5f2ff"
	min_ambience_cooldown = 90 SECONDS
	max_ambience_cooldown = 180 SECONDS

/area/outpost/gateway/operations
	name = "Operations"
	icon_state = "bridge"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	area_flags = NOTELEPORT
	lighting_colour_tube = "#e7f8ff"
	lighting_colour_bulb = "#d5f2ff"
	lighting_colour_night = "#d5f2ff"

/area/outpost/gateway/superweapon
	name = "Superweapon"
	icon_state = "security"
	sound_environment = SOUND_ENVIRONMENT_ARENA
	area_flags = NOTELEPORT
	lighting_colour_tube = "#e7f8ff"
	lighting_colour_bulb = "#d5f2ff"
	lighting_colour_night = "#d5f2ff"

/area/outpost/gateway/crew
	name = "Crew Quarters"
	icon_state = "crew_quarters"
	lighting_brightness_tube = 6

//WALLS


//STRUCTURES

/obj/machinery/power/rtg/abductor/archonic/hypershunt
	name = "Archonic Hypershunt"
	desc = "An archonic power source that produces energy from a tether to Archous's light."
	flags_1 = NODECONSTRUCT_1
	power_gen = 800000
	start_power_gen = 800000

/obj/machinery/power/siphon
	name = "Gateway Power Shunt"
	var/power_draw = 800000

/obj/machinery/power/siphon/Initialize()
	. = ..()
	connect_to_network()

/obj/machinery/power/siphon/process()
	..()
	if(GLOB.gateway_active)
		power_draw = power_draw*2
	add_delayedload(power_draw)

/obj/machinery/power/smes/gateway
	flags_1 = NODECONSTRUCT_1
	circuit = /obj/item/circuitboard/machine/smes/gateway
	input_level = 20000000
	output_level = 10000000

/obj/item/circuitboard/machine/smes/gateway
	name = "SMES (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/smes/gateway
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/cell = 5,
		/obj/item/stock_parts/capacitor/anomalistic = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/anomalistic/empty)

/obj/item/stock_parts/capacitor/anomalistic
	name = "anomalistic capacitor"
	desc = "An capacity capacitor used in the construction of a variety of devices."
	icon_state = "quadratic_capacitor"
	rating = 100

/obj/item/stock_parts/cell/anomalistic
	name = "energy core"
	desc = "An alien power cell."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cell"
	maxcharge = 160000
	ratingdesc = FALSE

/obj/item/stock_parts/cell/anomalistic/empty/Initialize()
	. = ..()
	charge = 0
	update_appearance()

/obj/machinery/energy_draw
	name = "Electrostatic Distributor"
	anchored = TRUE
	idle_power_usage = 200000

/obj/item/stock_parts/cell/gun/nac
	name = "N.A.C. cartridge"
	desc = "A small black cartridge. It has a data terminal on the bottom region and a small array of life support equipment on the top. A living organism is contained within, the words \"CO-8\" are tattooed onto the upper portion."
	icon_state = "nac_cart"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	ratingdesc = FALSE
	maxcharge = 1
	charge = 1
	chargerate = 0

/obj/item/stock_parts/cell/gun/nac/examine(mob/user)
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

/obj/item/reagent_containers/glass/bottle/paralytic
	name = "P-PPS-02 bottle"
	desc = "A small bottle of P-PPS-02."
	list_reagents = list(/datum/reagent/toxin/paralytic = 30)

/obj/machinery/computer/pandora_weapons
	name = "gateway weapons console"
	icon_keyboard = "syndie_key"
	icon_screen = "targeting_peace"

/obj/machinery/computer/pandora_weapons/proc/toggle_attack()
	if(icon_screen == "targeting")
		icon_screen = "targeting_peace"
	else
		icon_screen = "targeting"
	update_appearance()


/obj/machinery/computer/pandora_weapons/defense
	name = "defense satellite control console"
	icon_keyboard = "security_key"

/obj/item/clothing/head/archonic_crystal
	name = "archonic memory shard"
	desc = "A strange deep purple crystal. Scenes of violence can be seen reflected in its surface."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "archonic_crystal"
	mob_overlay_icon = 'code/modules/archonic/icons/64x64.dmi'
	item_state = "archonic_crystal"
	worn_x_dimension = 64
	worn_y_dimension = 64
	resistance_flags = FIRE_PROOF // Made of crystal

/turf/closed/gateway
	name = "protomatter enriched wall"
	desc = "The armored hull of an ominous looking station."
	icon = 'icons/turf/walls/plastitanium_wall.dmi'
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SYNDICATE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SYNDICATE_WALLS, SMOOTH_GROUP_PLASTITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS)
	explosion_block = 50
	opacity = TRUE
	density = TRUE
	hardness = 1
	rad_insulation = RAD_HEAVY_INSULATION
	min_dam = 25

	max_integrity = 4000

	mob_smash_flags = ENVIRONMENT_SMASH_RWALLS
	proj_bonus_damage_flags = PROJECTILE_BONUS_DAMAGE_RWALLS

/turf/closed/gateway/ex_act(severity, target)
	if(target == src || !density)
		return ..()
	switch(severity)
		if(EXPLODE_DEVASTATE)
			alter_integrity(rand(-900, -1200))
		if(EXPLODE_HEAVY)
			alter_integrity(rand(-500, -800))
		if(EXPLODE_LIGHT)
			alter_integrity(rand(-200, -700))

/turf/closed/indestructible/void
	name = "void"
	desc = "A wall of swirling black particles"
	icon = 'code/modules/archonic/icons/void_turf.dmi'
	icon_state = "void"
	explosion_block = 50

/turf/open/indestructible/void
	name = "void"
	icon = 'code/modules/archonic/icons/void_turf.dmi'
	icon_state = "void"

/turf/open/floor/plating/asteroid/void
	name = "void"
	icon = 'code/modules/archonic/icons/void_turf.dmi'
	icon_state = "void"

/area/ruin/space/has_grav/powered/void
	flags_1 = null

/datum/map_template/ruin/space/void
	id = "void"
	suffix = "void.dmm"
	name = "The Void"
	description = "Among civilian vessels the most common cause of tragedy is lack of food. \
	This ship was outfitted with a multitude of food-generating features, then summarily ran into an asteroid shortly after takeoff."

/obj/item/melee/knife/mindblade
	name = "\"Mindbreak\" 'INH-13'"
	icon_state = "survivalknife"
	item_state = "survivalknife"
	desc = "A very sharp blade capable of fanning out into a shield, a small notch is located on the tip for affixing to a target's spinal cord. A small light is attached to the crossguard"
	flags_1 = CONDUCT_1
	light_range = 4
	hitsound = 'sound/weapons/genhit1.ogg'
	light_color = "#CDDDFF"
	light_power = 0.7
	light_system = MOVABLE_LIGHT
	force = 17
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_SHARP_ACCURATE
	throwforce = 23
	throw_speed = 4
	throw_range = 6
	custom_materials = null
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	resistance_flags = FIRE_PROOF
	var/on_force = 1
	var/on_throwforce = 2
	var/on_throw_speed = 2
	var/active = FALSE
	var/mindspace = TRUE

/obj/item/melee/knife/mindblade/Initialize(mapload)
	. = ..()
	if(mindspace)
		ADD_TRAIT(src, TRAIT_NODROP, src)

/obj/item/melee/knife/mindblade/attack(mob/living/M, mob/user)
	. = ..()
	if(mindspace)
		if(M == user)
			return
		if(!active)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(C.health <= C.crit_threshold)
					C.visible_message("<span class='danger'>[user] plunges [src] upwards into [M]'s neck.</span>", "<span class='userdanger'>[user] plunges the [src] into your neck, burrowing down to your spinal cord.</span>")
					C.Unconscious(100000)
					C.visible_message("<span class='danger'>[C] falls limp.</span>", "<span class='userdanger'>Your sensation and thought rapidly fade from you as the [src] begins to interface with your mind.</span>")

/obj/item/melee/knife/mindblade/attack_self(mob/living/carbon/human/user)
	active = !active
	if(active)
		force = on_force
		throwforce = on_throwforce
		throw_speed = on_throw_speed
		w_class = WEIGHT_CLASS_BULKY
		block_chance = 60
		sharpness = IS_BLUNT
		hitsound = 'sound/weapons/genhit.ogg'
		attack_verb = list("shoved", "bashed")
		playsound(user, 'sound/weapons/batonextend.ogg', 30, TRUE)
		user.visible_message("<span class='notice'>[src] unfolds out into a shield.</span>")
	else
		force = initial(force)
		throwforce = initial(throwforce)
		throw_speed = initial(throw_speed)
		w_class = WEIGHT_CLASS_SMALL
		block_chance = 5
		sharpness = IS_SHARP_ACCURATE
		hitsound = 'sound/weapons/bladeslice.ogg'
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		playsound(user, 'sound/weapons/batonextend.ogg', 30, TRUE)
		user.visible_message("<span class='notice'>[src] folds back into a blade.</span>")

//GATEWAY OPERATIONS

GLOBAL_VAR_INIT(gateway_active, FALSE) //Is the thing on.
GLOBAL_VAR_INIT(gateway_output, FALSE) //False mean its one-way going in, true means one-way going out.
GLOBAL_VAR_INIT(gateway_integrity, TRUE) //0(FALSE):Gateway is damaged to the point of nonfunctionality 1(TRUE): Gateway is intact. 2: Gateway has been drastically altered, but is still functional.
GLOBAL_VAR_INIT(gateway_throttle, 1) //What vaccum state is the gateway trying to reach, measured in lightspeed ratios. 1:Standard. 0.02:The Void. 1.04: Wirespace. 309: ANOMALY. Gateway maximum range is: 0.01 to 1.34

/obj/machinery/computer/pandora_control
	name = "The Primary System Terminal"
	desc = "The primary control center of the grand structure around you. You probably shouldn't touch this unless you know what you're doing."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	icon_keyboard = "teleport_key"
	icon_screen = "command_generic"

	var/gateway_throttle_target = 1 //What is our target
	var/gateway_throttle_speed = 0.007 // How quickly we approach our target.
	var/minimum_throttle = 0.01 //How low can I turn the thing down too.
	var/maximum_throttle = 1.34 //How high can I turn the thing up too.
	var/custom_error_message = "Critical Error: VSA damaged or not present." //If you put a custom error message here it will show up.
	var/locked = FALSE //Can we use the interface
	var/target_throttles = list(0.02, 1.04, 309)

	//Gateway components and their working status
	var/pandora_powered = TRUE
	var/pandora_vsa = TRUE
	var/pandora_field_emitter = TRUE
	var/pandora_guidance = TRUE

/obj/machinery/computer/pandora_control/Initialize()
	. = ..()
	START_PROCESSING(SSmachines, src)

/obj/machinery/computer/pandora_control/proc/toggle_power()
	if(GLOB.gateway_integrity == FALSE)
		return
	if(GLOB.gateway_active)
		deactivate_gateway()
	else
		activate_gateway()

/obj/machinery/computer/pandora_control/proc/deactivate_gateway()
	if(GLOB.gateway_integrity == TRUE)
		gatewayEvent("shutdown_cold")
	close_gateway(GLOB.gateway_throttle)
	GLOB.gateway_throttle = 1
	gateway_throttle_target = 1
	GLOB.gateway_output = FALSE
	GLOB.gateway_active = FALSE

/obj/machinery/computer/pandora_control/proc/activate_gateway()
	gatewayEvent("cold_start")
	GLOB.gateway_active = TRUE

/obj/machinery/computer/pandora_control/proc/gatewayEvent(event)
	switch(event)
		//Startup
		if("cold_start")//For when the gateway turns on.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>You feel a slight jostle under your feet.</span>")
					shake_camera(M, 1, 0.3)
		//Closings/Shutdowns
		if("shutdown_cold")//For when the gateway shuts down on full integrity.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>The ground beneath you falls silent.</span>")
		if("shutdown_integrity")//For when the gateway shuts down from integrity failure.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>The ground beneath you shudders then falls silent.</span>")
					shake_camera(M, 2, 3)
		if("shutdown_active_input")//For when the gateway shuts down while on and inputting.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>The curtain of pure blackness within the gateway ripples and falls away.</span>")
		if("shutdown_active_output_void")//For when the gateway shuts down while on and outputting from the void.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>The opening into a deep blue miasma ripples, then falls in on itself.</span>")
		if("shutdown_active_output_wirespace")//For when the gateway shuts down while on and outputting from archonic wirespace.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>The opening into a <span class='revenminor'>white emptiness</span> ripples, then falls in on itself.</span>")
		if("shutdown_active_output_anomaly")//For when the gateway shuts down while on and outputting from the Anomaly.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>You feel a <span class='anomaly'>chilling agony</span> as the opening spewing <span class='anomaly'>prismatic radiance</span> collapses in on itself.</span>")
		//Openings
		if("activate_input")
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>An unmoving sheet of perfect black extends from the center of the gateway into the borders.</span>")
		if("activate_output_void")
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>The black event horizon within the gateway gives way to a chaotic deep blue abyss, speckled with dots of black particles.</span>")
		if("activate_output_wirespace")
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>The black event horizon within the gateway opens into a <span class='revenminor'>white emptiness</span>.</span>")
		if("activate_output_anomaly")
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>You feel a <span class='anomaly'>soothing warmth</span> inside you as the black event horizon within the gateway as a <span class='anomaly'>beautiful prismatic radiance</span> flows from its entrance.</span>")

/obj/machinery/computer/pandora_control/proc/close_gateway(throttle)
	if(!throttle) //Get a throttle if there isn't one for some reason.
		throttle = GLOB.gateway_throttle
	if(throttle == 1) //If the throttle is 1 we can just ignore it.
		return
	if(!(throttle in target_throttles)) //Nothing to close
		return
	if(GLOB.gateway_output == TRUE)
		switch(throttle)
			if(0.02)
				gatewayEvent("shutdown_active_output_void")
			if(1.04)
				gatewayEvent("shutdown_active_output_wirespace")
			if(309)
				gatewayEvent("shutdown_active_output_anomaly")
	else
		gatewayEvent("shutdown_active_input")

/obj/machinery/computer/pandora_control/proc/toggle_input(throttle)
	if(!throttle) //Get a throttle if there isn't one for some reason.
		throttle = GLOB.gateway_throttle
	if(throttle == 1) //If the throttle is 1 we can just ignore it.
		return
	if(!(throttle in target_throttles)) //I have no idea why you did this but if you toggle while in transit nothing happens.
		return
	if(GLOB.gateway_integrity == FALSE) //Same case as above.
		return
	if(GLOB.gateway_output == FALSE)
		GLOB.gateway_output = TRUE
		switch(throttle)
			if(0.02)
				gatewayEvent("activate_output_void")
			if(1.04)
				gatewayEvent("activate_output_wirespace")
			if(309)
				gatewayEvent("activate_output_anomaly")
	else
		GLOB.gateway_output = FALSE
		gatewayEvent("activate_input")


/obj/machinery/computer/pandora_control/process()
	var/throttle_changed = FALSE
	if(GLOB.gateway_active)
		var/old_throttle = GLOB.gateway_throttle
		if(GLOB.gateway_integrity == FALSE)
			deactivate_gateway()
			gatewayEvent("shutdown_integrity")
		//Throttle fuckery
		if(GLOB.gateway_integrity == TRUE) //State 2 has no care for physical bounds.
			GLOB.gateway_throttle = clamp(GLOB.gateway_throttle, minimum_throttle, maximum_throttle)
		if(GLOB.gateway_throttle > gateway_throttle_target) //If the gateway throttle is above the target, drain it down until it reaches the target.
			GLOB.gateway_throttle = max(GLOB.gateway_throttle-gateway_throttle_speed, gateway_throttle_target)
			throttle_changed = TRUE
		if(GLOB.gateway_throttle < gateway_throttle_target) //If the gateway throttle is below the target, bring it up until it reaches the target.
			GLOB.gateway_throttle = min(GLOB.gateway_throttle+gateway_throttle_speed, gateway_throttle_target)
			throttle_changed = TRUE
		//to_chat(world, "Gateway Throttle: [GLOB.gateway_throttle]  Old Throttle: [old_throttle]  Throttle Changed: [throttle_changed]")
		//Close gateway when moving off of a target destination.
		if(throttle_changed && (old_throttle in target_throttles))
			close_gateway(old_throttle)
		//Turn off output when throttle changes.
		if(throttle_changed && GLOB.gateway_output)
			GLOB.gateway_output = FALSE
		//Trigger input activation when reaching a valid target.
		if(throttle_changed && (GLOB.gateway_throttle in target_throttles) && (gateway_throttle_target in target_throttles))
			gatewayEvent("activate_input")
		//Put this shit at the end always:
	if(!GLOB.gateway_active)
		gateway_throttle_target = 1
		icon_screen = "command_generic"
		update_appearance()
	else if(!throttle_changed && (GLOB.gateway_throttle in target_throttles))
		icon_screen = "docking-docked"
		update_appearance()
	else if(GLOB.gateway_active && GLOB.gateway_throttle != 1)
		icon_screen = "docking-locations"
		update_appearance()
	else
		icon_screen = "docking-none"
		update_appearance()


/obj/machinery/computer/pandora_control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Pandora", name)
		ui.open()

/obj/machinery/computer/pandora_control/ui_data()
	var/data = list()

	data["integrity"] = GLOB.gateway_integrity

	data["active"] = GLOB.gateway_active
	data["output"] = GLOB.gateway_output

	data["throttle"] = GLOB.gateway_throttle
	if(GLOB.gateway_integrity == 2)
		data["throttle_target"] = GLOB.gateway_throttle
	else
		data["throttle_target"] = gateway_throttle_target
	data["throttle_min"] = minimum_throttle
	data["throttle_max"] = maximum_throttle

	data["locked"] = locked

	data["custom_error_message"] = custom_error_message
	data["pandora_powered"] = pandora_powered
	data["pandora_vsa"] = pandora_vsa
	data["pandora_field_emitter"] = pandora_field_emitter
	data["pandora_guidance"] = pandora_guidance

	. =  data

/obj/machinery/computer/pandora_control/ui_act(action, params)
	. = ..()
	if(.)
		return
	if (locked)
		return
	switch(action)
		if("throttle")
			gateway_throttle_target = params["ref"]
		if("power")
			toggle_power()
		if("output")
			toggle_input()

