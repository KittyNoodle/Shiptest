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
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
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


//GATEWAY OPERATIONS

GLOBAL_VAR_INIT(gateway_active, FALSE) //Is the thing on.
GLOBAL_VAR_INIT(gateway_output, FALSE) //False mean its one-way going in, true means one-way going out.
GLOBAL_VAR_INIT(gateway_integrity, TRUE) //0(FALSE):Gateway is damaged to the point of nonfunctionality 1(TRUE): Gateway is intact. 2: Gateway has been drastically altered, but is still functional.
GLOBAL_VAR_INIT(gateway_throttle, 1) //What vaccum state is the gateway trying to reach, measured in lightspeed ratios. 1:Standard. 0.02:The Void. 1.04: Wirespace. 309: ANOMALY. Gateway maximum range is: 0.01 to 1.34

/obj/machinery/computer/pandora_control
	name = "Primary System Terminal"
	desc = "The primary control center of the grand structure around you. You probably shouldn't touch this unless you know what you're doing."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/gateway_throttle_target = 1 //What is our target
	var/gateway_throttle_speed = 0.007 // How quickly we approach our target.
	var/minimum_throttle = 0.01 //How low can I turn the thing down too.
	var/maximum_throttle = 1.34 //How high can I turn the thing up too.
	var/custom_error_message = "Critical Error: VSA damaged or not present." //If you put a custom error message here it will show up.
	var/locked = FALSE //Can we use the interface
	var/target_throttles = list(0.02, 1.04, 309)

/obj/machinery/computer/pandora_control/Initialize()
	. = ..()
	START_PROCESSING(SSmachines, src)

/obj/machinery/computer/pandora_control/proc/togglePower()
	if(GLOB.gateway_active)
		deactivate_gateway()
	else
		activate_gateway()

/obj/machinery/computer/pandora_control/proc/deactivate_gateway()
	if(GLOB.gateway_integrity == TRUE)
		gatewayEvent("shutdown_cold")
	GLOB.gateway_throttle = 1
	GLOB.gateway_active = FALSE

/obj/machinery/computer/pandora_control/proc/activate_gateway()
	gatewayEvent("cold_start")

/obj/machinery/computer/pandora_control/proc/gatewayEvent(event)
	switch(event)
		//Startup/Shutdown
		if("cold_start")//For when the gateway turns on.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>You feel a slight jostle under your feet.</span>")
					shake_camera(M, 1, 0.3)
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
					to_chat(M, "<span class='notice'>The opening into a <span class='revenminor'>white emptyness</span> ripples, then falls in on itself.</span>")
		if("shutdown_active_output_anomaly")//For when the gateway shuts down while on and outputting from the Anomaly.
			for(var/mob/M in GLOB.player_list)
				if(M.virtual_z() == virtual_z())
					to_chat(M, "<span class='notice'>You feel a <span class='anomaly'>chilling agony</span> as the opening spewing <span class='anomaly'>prismatic radiance</span> collapses in on itself.</span>")

/obj/machinery/computer/pandora_control/process()
	if(GLOB.gateway_active)
		if(GLOB.gateway_integrity == FALSE)
			deactivate_gateway()
			gatewayEvent("shutdown_integrity")
		//Throttle fuckery
		if(GLOB.gateway_integrity == TRUE) //State 2 has no care for physical bounds.
			GLOB.gateway_throttle = clamp(GLOB.gateway_throttle, minimum_throttle, maximum_throttle)
		if(GLOB.gateway_throttle > gateway_throttle_target) //If the gateway throttle is above the target, drain it down until it reaches the target.
			GLOB.gateway_throttle = max(GLOB.gateway_throttle-gateway_throttle_speed, gateway_throttle_target)
		if(GLOB.gateway_throttle < gateway_throttle_target) //If the gateway throttle is below the target, bring it up until it reaches the target.
			GLOB.gateway_throttle = min(GLOB.gateway_throttle+gateway_throttle_speed, gateway_throttle_target)
