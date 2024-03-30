#define HEAT_COLDSTART 10
#define HEAT_STARTING 20
#define HEAT_NOMINAL 40
#define HEAT_HOT 55
#define HEAT_VERYHOT 65
#define HEAT_MELTDOWN 95
#define DAMAGE_SAFE 35
#define DAMAGE_WARNING 40
#define DAMAGE_THRESHHOLD 60
#define DAMAGE_RADLEAK 95

/obj/structure/filler
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/power/reactor
	name = "S.R.F.P.G. Reactor"
	desc = "A Self Regulating Fission Pile Generator, a reactor designed for the Nanotrasen Frontier Exploration Program for the purposes of being both cheap to produce, and requiring no additional fueling, while not having the risk of the supermatter."
	icon = 'code/modules/archonic/icons/reactor.dmi'
	icon_state = "reactor_off"
	density = TRUE
	use_power = NO_POWER_USE
	pixel_x = -32
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	base_icon_state = "reactor"
	var/active = FALSE
	var/power_gen = 0
	var/melted = FALSE
	var/decay_coeff = 1

	var/heat = 0 //this is all in precent because fuck you and fuck everyone
	var/damage = 0

	var/list/obj/structure/fillers = list()

/obj/machinery/power/reactor/Initialize()
	. = ..()
	var/list/occupied = list()
	for(var/direct in list(EAST,WEST,NORTH,NORTHEAST,NORTHWEST))
		occupied += get_step(src,direct)
	occupied += locate(x+1,y+2,z)
	occupied += locate(x,y+2,z)
	occupied += locate(x-1,y+2,z)

	for(var/T in occupied)
		var/obj/structure/filler/F = new(T)
		F.parent = src
		fillers += F
	START_PROCESSING(SSmachines, src)
	connect_to_network()

/obj/machinery/power/reactor/Destroy()
	for(var/V in fillers)
		var/obj/structure/filler/filler = V
		filler.parent = null
		qdel(filler)
	. = ..()

/obj/machinery/power/reactor/examine(mob/user)
	. = ..()
	. += "It is[!active?"n't":""] running."
	switch(heat)
		if(0)
			. += "<span class='notice'>It is silent and cold to the touch.</span>"
		if(1 to HEAT_COLDSTART)
			. += "<span class='notice'>It is emitting a light hum and you can faintly hear the rushing of water in the pipes.</span>"
		if(HEAT_COLDSTART+0.001 to HEAT_STARTING)
			. += "<span class='notice'>You hear the occasional hissing of steam from the pipes, alongside a steady flow of water.</span>"
		if(HEAT_STARTING+0.001 to HEAT_NOMINAL)
			. += "<span class='boldnicegreen'>The autoregulator light blinks on and off as steam hisses through the pipes.</span>"
			if(damage > DAMAGE_SAFE)
				. += "<span class='danger'>The autoregulator light occasionally misses a blink.</span>"
		if(HEAT_NOMINAL+0.001 to HEAT_HOT)
			if(damage > 50)
				. += "<span class='danger'>The autoregulator light occasionally flickers as steam rattles through the pipes.</span>"
			else
				. += "<span class='danger'>The autoregulator light remains constantly lit as steam rattles through the pipes.</span>"
			. += "<span class='boldwarning'>Occasionally the radiation warning light blinks on.</span>"
		if(HEAT_HOT+0.001 to HEAT_VERYHOT)
			if(damage > 50)
				. += "<span class='bolddanger'>The autoregulator light flickers as the pipes groan and rattle with steam.</span>"
			else
				. += "<span class='danger'>The autoregulator light remains constantly lit as the pipes groan and rattle with steam.</span>"
			. += "<span class='alertwarning'>Its radiation alarms shriek rhythmically.</span>"
		if(HEAT_VERYHOT+0.001 to HEAT_MELTDOWN)
			if(damage > DAMAGE_RADLEAK)
				. += "<span class='userdanger'>The autoregulator light has shattered and the surface of the reactor is cracked and releasing bursts of burning hot steam.</span>"
			else if(damage > 70)
				. += "<span class='bolddanger'>The autoregulator light has shattered and the pipes rattle and crack, letting out occasional bursts of searing hot steam.</span>"
			else if(damage > 50)
				. += "<span class='bolddanger'>The autoregulator light flickers as the pipes rattle and hum with searing hot steam.</span>"
			else
				. += "<span class='danger'>The autoregulator light remains constantly lit as the pipes rattle and hum with searing hot steam.</span>"
			if(damage > 70)
				. += "<span class='alertwarning'>Its radiation alarms wheeze desperately.</span>"
			else
				. += "<span class='alertwarning'>Its radiation alarms shriek rhythmically.</span>"
			. += "<span class='bolddanger'>Its overpressure light blinks on and off.</span>"
		if(HEAT_MELTDOWN+0.001 to 200)
			. += "<span class='userdanger'>The reactor is glowing red hot and cracked, with searing hot steam pouring out of every crack. You should probably start running.</span>"

/obj/machinery/power/reactor/proc/adjust_heat(amount, clamp)
	if(clamp)
		if(heat > clamp)
			return TRUE
		heat = clamp(heat+amount, 0, clamp)
		return TRUE
	else
		heat = clamp(heat+amount, 0, 100)
		return TRUE

/obj/machinery/power/reactor/proc/adjust_damage(amount, use_coeff)
	if(use_coeff)
		var/damage_adjust = amount*decay_coeff
		damage = clamp(damage+damage_adjust, 0, 100)
		return TRUE
	else
		damage = clamp(damage+amount, 0, 100)
		return TRUE

/obj/machinery/power/reactor/proc/TogglePower()
	if(active)
		active = FALSE
	else
		active = TRUE

/obj/machinery/power/reactor/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/stack/reactorpart))
		var/obj/item/stack/replacement = O
		if(damage == 0)
			to_chat(user, "<span class='notice'>The [src.name] is fully intact.</span>")
			return
		to_chat(user, "<span class='notice'>You you replace the broken components in [src.name] with [replacement].</span>")
		damage = damage-5
		replacement.use(1)
		return
	//else if(!active)
		//some type of emergency repair with welder?????
	return ..()

/obj/machinery/power/reactor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SRFPG", name)
		ui.open()

/obj/machinery/power/reactor/ui_data()
	var/data = list()

	data["melted"] = melted

	data["active"] = active
	if(melted)
		data["integrity"] = rand(0, 100)
		data["heat"] = rand(0, 100)
	else
		data["integrity"] = 100-damage
		data["heat"] = heat

	data["connected"] = (powernet == null ? 0 : 1)
	data["power_generated"] = DisplayPower(power_gen)
	data["power_available"] = (powernet == null ? 0 : DisplayPower(avail()))
	. =  data

/obj/machinery/power/reactor/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle_power")
			TogglePower()
			. = TRUE


/obj/machinery/power/reactor/process()
	if(active)
		if(powernet)
			add_avail(power_gen)
	if(melted)
		//add rad pulse later
		power_gen = rand(0, 40000)
		if(powernet)
			add_avail(power_gen)
	react()
	change_icon()
	update_appearance()

/obj/machinery/power/reactor/proc/react()
	if(melted)
		return
	if(heat > damage)
		if(heat > 40)
			switch(damage)
				if(0 to DAMAGE_WARNING)
					adjust_heat(-2, FALSE)
				if(DAMAGE_WARNING+0.001 to DAMAGE_THRESHHOLD)
					adjust_heat(-0.5, FALSE)
				if(DAMAGE_THRESHHOLD+0.001 to DAMAGE_RADLEAK)
					adjust_heat(-0.25, FALSE)
				if(DAMAGE_RADLEAK+0.001 to 200)
					adjust_heat(-0.05, FALSE)
	if(!active)
		power_gen = 0
		switch(damage)
			if(0 to DAMAGE_WARNING)
				adjust_heat(-2, FALSE)
			if(DAMAGE_WARNING+0.001 to DAMAGE_THRESHHOLD)
				adjust_heat(-1, damage)
			if(DAMAGE_THRESHHOLD+0.001 to DAMAGE_RADLEAK)
				adjust_damage(0.01, TRUE) //The reaper comes
				adjust_heat(-0.5, damage)
				//insert rad pulse here, high range, low power, no contaminate.
			if(DAMAGE_RADLEAK+0.001 to 200)
				active = TRUE //AHAHAHHAHAHHAHHAHAHAHAHHAHAHAHAHAHAH
	if(active)
		switch(damage)
			if(0 to DAMAGE_WARNING)
				if(heat < HEAT_STARTING)
					adjust_heat(0.5, 40)
				else
					adjust_heat(1, 40)
			if(DAMAGE_WARNING+0.001 to DAMAGE_THRESHHOLD)
				adjust_heat(1.3, damage)
				adjust_damage(0.02, TRUE) //The reaper comes
			if(DAMAGE_THRESHHOLD+0.001 to DAMAGE_RADLEAK)
				adjust_heat(2, damage) //Runaway reaction, control rods ain't doin shit
				adjust_damage(0.03, TRUE) //The reaper comes
				//insert rad pulse here, high range, low power, no contaminate.
			if(DAMAGE_RADLEAK+0.001 to 200)
				adjust_heat(2, 100)
				//if(heat > HEAT_MELTDOWN)
					//meltdown() meltdown sequence not done yet dumbass
		switch(heat)
			if(0)
				power_gen = 0
			if(1 to HEAT_COLDSTART)
				power_gen = 0
			if(HEAT_COLDSTART+0.001 to HEAT_STARTING)
				power_gen = 20000
			if(HEAT_STARTING+0.001 to HEAT_NOMINAL)
				power_gen = 120000
			if(HEAT_NOMINAL+0.001 to 200)
				power_gen = 300000
	switch(heat)
		if(0)
			//nothing
		if(1 to HEAT_COLDSTART)
			adjust_heat(-0.2, FALSE)
		if(HEAT_COLDSTART+0.001 to HEAT_STARTING)
			adjust_heat(-0.1, FALSE)
		if(HEAT_STARTING+0.001 to HEAT_NOMINAL)
			adjust_damage(0.015, TRUE)
		if(HEAT_NOMINAL+0.001 to HEAT_HOT)
			adjust_damage(0.025, TRUE)
			adjust_heat(0.2, damage)
			//weak low range rad pulse,no contaminate
		if(HEAT_HOT+0.001 to HEAT_VERYHOT)
			adjust_heat(0.5, damage)
			adjust_damage(0.10, TRUE)
			//medium power low range rad pulse,no contaminate
		if(HEAT_VERYHOT+0.001 to HEAT_MELTDOWN)
			adjust_heat(0.7, damage)
			adjust_damage(0.25, TRUE)
			//powerful low range rad pulse,no contaminate
		if(HEAT_MELTDOWN+0.001 to 200)
			adjust_heat(1, 100)
			adjust_damage(0.50, TRUE)

/obj/machinery/power/reactor/proc/change_icon()
	if(!melted)
		switch(heat)
			if(0)
				icon_state = "[base_icon_state]_off"
			if(0.001 to 20)
				icon_state = "[base_icon_state]_on"
			if(20.001 to 40)
				icon_state = "[base_icon_state]_hot"
			if(40.001 to 60)
				icon_state = "[base_icon_state]_veryhot"
			if(60.001 to 80)
				icon_state = "[base_icon_state]_overheat"
			if(80.001 to 200)
				icon_state = "[base_icon_state]_meltdown"
	else
		icon_state = "[base_icon_state]_slagged"


/obj/machinery/power/reactor/update_overlays()
	. = ..()
	if(!melted)
		switch(damage)
			if(0 to 30)
				//nothing
			if(30.001 to 60)
				. += "[base_icon_state]_damaged_1"
			if(60.001 to 70)
				. += "[base_icon_state]_damaged_2"
			if(70.001 to 85)
				. += "[base_icon_state]_damaged_3"
			if(85.001 to 200)
				. += "[base_icon_state]_damaged_4"
	else
		. += "[base_icon_state]_damaged_melt"

/obj/item/stack/reactorpart
	name = "reactor replacement parts"
	desc = "Replacement parts for the shielding and piping of the SRFPG reactor."
	singular_name = "reactor replacement part"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "reactor-part"
	item_state = "rods"
	w_class = WEIGHT_CLASS_TINY
	max_amount = 10

/obj/item/stack/reactorpart/Initialize(mapload, new_amount, merge = TRUE)
	. = ..()
	update_appearance()

/obj/item/stack/reactorpart/update_icon_state()
	. = ..()
	var/amount = get_amount()
	switch(amount)
		if(8 to 10)
			icon_state = "reactor-part_4"
		if(4 to 8)
			icon_state = "reactor-part_3"
		if(2 to 4)
			icon_state = "reactor-part_2"
		else
			icon_state = "reactor-part"

/obj/item/stack/reactorpart/ten
	amount = 10

#undef HEAT_COLDSTART
#undef HEAT_STARTING
#undef HEAT_NOMINAL
#undef HEAT_HOT
#undef HEAT_VERYHOT
#undef HEAT_MELTDOWN
#undef DAMAGE_SAFE
#undef DAMAGE_WARNING
#undef DAMAGE_THRESHHOLD
#undef DAMAGE_RADLEAK
