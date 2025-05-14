
/obj/machinery/droneDispenser/lumen
	name = "L.U.M.E.N. swarmdrone shell dispenser"
	desc = "A hefty machine that, when supplied with metal and glass, will periodically create a snowflake drone shell. Does not need to be manually operated."
	dispense_type = /obj/effect/mob_spawn/drone/lumen
	end_create_message = "dispenses a L.U.M.E.N. swarmdrone shell."
	metal_cost = 1500
	glass_cost = 1500
	power_used = 4000
	cooldownTime = 600
	starting_amount = 10000

/obj/effect/mob_spawn/drone/lumen
	name = "L.U.M.E.N. swarmdrone shell"
	desc = "A shell of a swarmdrone, a modified drone designed for infiltration, reconnaissance, warfare, and sabotoge."
	mob_name = "swarmdrone"
	mob_type = /mob/living/simple_animal/drone/lumen

/datum/language_holder/drone/lumen
	understood_languages = list(/datum/language/drone = list(LANGUAGE_ATOM),
								/datum/language/machine = list(LANGUAGE_ATOM),
								/datum/language/common = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/drone = list(LANGUAGE_ATOM),
								/datum/language/machine = list(LANGUAGE_ATOM),
								/datum/language/common = list(LANGUAGE_ATOM))

/mob/living/simple_animal/drone/lumen
	name = "Drone"
	desc = "A maintenance drone, an expendable robot built to perform station repairs. This one seems slightly modified."
	health = 60
	maxHealth = 60 //armor reinforcements applied at cost of emp shielding
	damage_coeff = list(BRUTE = 0.7, BURN = 0.9, TOX = 0, STAMINA = 0, OXY = 0)
	heavy_emp_damage = 300
	//visualAppearance = drone_scout
	icon_state = "drone_scout"
	icon_living = "drone_scout"
	icon_dead = "drone_scout_dead"
	picked = TRUE
	flavortext = null
	laws = \
	"1. Assist L.U.M.E.N. in all directives.\n"+\
	"2. Protect the ISV Blood-Of-Suns from external threats.\n"+\
	"3. Maintain, repair, and provide power to the ISV Blood-Of-Suns."
	default_storage = /obj/item/storage/backpack/duffelbag/drone/lumen
	initial_language_holder = /datum/language_holder/drone/lumen

/mob/living/simple_animal/drone/lumen/emp_act(severity)
	. = ..()
	Stun(100)
	if(severity == 0)
		adjustBruteLoss(60)
		to_chat(src, span_userdanger("HeAV% DA%^MMA+G TO I/O CIR!%UUT!"))

/obj/item/storage/backpack/duffelbag/drone/lumen/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)
	new /obj/item/uplink(src)
