/datum/outfit/centcom/commander
	name = "CentCom Commander"

	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/vest/bulletproof
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/eyepatch
	mask = /obj/item/clothing/mask/cigarette/cigar/cohiba
	head = /obj/item/clothing/head/centcom_cap
	belt = /obj/item/gun/ballistic/revolver/mateba
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/ammo_box/a357
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom

/datum/outfit/centcom/commander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Commander")
	W.assignment = "CentCom Commander"
	W.registered_name = H.real_name
	W.update_label()
	..()

/datum/outfit/centcom/death_commando
	name = "Nanotrasen - Death Commando"

	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/space/hardsuit/deathsquad
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	back = /obj/item/storage/backpack/security
	l_pocket = /obj/item/melee/energy/sword/saber/blue
	r_pocket = /obj/item/shield/energy
	suit_store = /obj/item/tank/internals/emergency_oxygen/double
	belt = /obj/item/gun/ballistic/revolver/mateba
	r_hand = /obj/item/gun/energy/pulse
	id = /obj/item/card/id/ert/deathsquad
	ears = /obj/item/radio/headset/headset_cent/alt

	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/ammo_box/a357=1,\
		/obj/item/storage/firstaid/regular=1,\
		/obj/item/storage/box/flashbangs=1,\
		/obj/item/flashlight=1,\
		/obj/item/grenade/c4/x4=1)

/datum/outfit/centcom/death_commando/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.freqlock = TRUE
	var/obj/item/card/id/W = H.wear_id
	W.access = get_all_accesses()//They get full station access.
	W.access += get_centcom_access("Death Commando")//Let's add their alloted CentCom access.
	W.assignment = "Death Commando"
	W.registered_name = H.real_name
	W.update_label()
	..()

/datum/outfit/centcom/death_commando/officer
	name = "Death Commando Officer"
	head = /obj/item/clothing/head/helmet/space/beret

/obj/item/organ/lungs/ethereal
	name = "aeration reticulum"
	desc = "These exotic lungs seem crunchier than most."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "lungs_ethereal"
	heat_level_1_threshold = FIRE_MINIMUM_TEMPERATURE_TO_SPREAD // 150C or 433k, in line with ethereal max safe body temperature
	heat_level_2_threshold = 473
	heat_level_3_threshold = 1073

/obj/effect/proc_holder/spell/pointed/corpore_sano
	name = "Corpore Sano"
	desc = "..."
	school = "restoration"
	charge_max = 200
	clothes_req = FALSE
	invocation = null
	invocation_type = "none"
	range = 1
	cooldown_min = 200 //100 deciseconds reduction per rank
	action_icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	action_icon_state = "fleshmend"
	active_msg = "You open your third eye and prepare to heal your target..."
	var/datum/beam/current_beam

/obj/effect/proc_holder/spell/pointed/corpore_sano/cast(list/targets, mob/living/user, silent = FALSE)
	if(!targets.len)
		to_chat(user, "<span class='warning'>No target found in range!</span>")
		return FALSE
	if(!can_target(targets[1], user))
		return FALSE

	var/mob/living/victim = targets[1] //The target of the spell whos body will be transferred to.
	if(current_beam)
		qdel(current_beam)
	user.Beam(victim, icon_state="sm_arc", time = 40, maxdistance = 2, beam_type = /obj/effect/ebeam/medical)
	victim.adjustBruteLoss(-40, TRUE)
	victim.adjustFireLoss(-40, TRUE)
	victim.update_damage_overlays()
	victim.update_health_hud()
	return TRUE

/obj/effect/proc_holder/spell/pointed/corpore_sano/can_target(atom/target, mob/user, silent)
	. = ..()
	if(!.)
		return FALSE
	return TRUE

/mob/living/silicon
	var/flash_immunity = FALSE

/obj/item/robot_module/hunter
	name = "Hunter-Seeker"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/restraints/handcuffs/cable/zipties,
		/obj/item/extinguisher/mini,
		/obj/item/crowbar/cyborg,
		/obj/item/reagent_containers/borghypo/hacked,
		/obj/item/weldingtool/largetank/cyborg,
		/obj/item/borg/sight/thermal,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/e_gun/hades/cyborg,
		/obj/item/gun/energy/laser/e50/clip/cyborg)
	cyborg_base_icon = "droid-combat"
	moduleselect_icon = "malf"
	can_be_pushed = FALSE
	hat_offset = 3

/obj/item/gun/energy/laser/e50/clip/cyborg
	can_charge = FALSE
	use_cyborg_cell = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/laser/eoehoma/e50/clip/cyborg)

/obj/item/ammo_casing/energy/laser/eoehoma/e50/clip/cyborg
	e_cost = 1000

/obj/item/gun/energy/e_gun/hades/cyborg
	can_charge = FALSE
	use_cyborg_cell = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/laser/assault/cyborg, /obj/item/ammo_casing/energy/disabler/cyborg)

/obj/item/ammo_casing/energy/laser/assault/cyborg
	e_cost = 125

/obj/item/ammo_casing/energy/disabler/cyborg
	e_cost = 100

/obj/item/radio/borg/centcom
	keyslot = new /obj/item/encryptionkey/headset_cent

/obj/item/radio/borg/centcom/Initialize()
	. = ..()
	set_frequency(FREQ_CENTCOM)

/mob/living/silicon/robot/modules/hunter
	icon_state = "droid-combat"
	faction = list(FACTION_NT)
	ionpulse = TRUE
	flash_immunity = TRUE
	set_module = /obj/item/robot_module/hunter
	cell = /obj/item/stock_parts/cell/bluespace
	radio = /obj/item/radio/borg/centcom
	maxHealth = 300
	health = 300

/mob/living/silicon/robot/modules/hunter/shell
	shell = TRUE

/obj/effect/bump_transfer
	name = "bump-transfer"
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "x3"
	invisibility = INVISIBILITY_ABSTRACT 		//nope, can't see this
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/obj/effect/bump_transfer/exit
	var/id = 1

/obj/effect/bump_transfer/Initialize()
	. = ..()
	if(!exit)
		for(var/obj/effect/bump_transfer/T in world)
			if(T.id == id && T != src)
				exit = T
				T.exit = src

/obj/effect/bump_transfer/Bumped(atom/movable/AM)
	. = ..()
	var/turf/T = get_step(exit, get_dir(AM, src))
	AM.forceMove(T)


/*
/datum/gear/umbrella
	display_name = "umbrella"
	path = /obj/item/melee/transforming/umbrella

/datum/gear/parasol
	display_name = "umbrella (black parasol)"
	path = /obj/item/melee/transforming/umbrella/parasol

/*
 * # Umbrellas!
 * This file has code for umbrellas!
 * Umbrellas you can hold, and open and close.
 * Currently not coding for protecting against rain as ???I dont think??? rain exists.
 * The rest don't and it just for looks.
 */
/obj/item/melee/transforming/umbrella
	name = "umbrella"
	desc = "A plain umbrella."

	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "umbrella"
	icon_state_on = "umbrella_on"
	lefthand_file = 'pentestModules/icons/mob/inhands/weapons/umbrellas_inhand_lh.dmi'
	righthand_file = 'pentestModules/icons/mob/inhands/weapons/umbrellas_inhand_rh.dmi'

	force = 10
	force_on = 5 //does more force when closed, duh.
	throwforce = 5
	throwforce_on = 3 // when open, it has more air resistance
	w_class = WEIGHT_CLASS_SMALL
	hitsound_on = 'sound/weapons/fwoosh.ogg'
	attack_verb = list("bludgeon", "whack", "discipline", "pummel")
	attack_verb_on = list("swooshes", "whacks", "fwumps")
	attack_verb_off = list("bludgeon", "whack", "discipline", "pummel")

	hitsound = 'sound/weapons/genhit1.ogg'
	sharpness = IS_BLUNT
	w_class_on = WEIGHT_CLASS_BULKY
	clumsy_check = FALSE

	//open umbrella offsets for the inhands
	var/open_x_offset = 2
	var/open_y_offset = 2

	//Whether it's open or not
	var/open = FALSE

	/// The sound effect played when our umbrella is opened
	var/on_sound = 'sound/weapons/batonextend.ogg'
	/// The inhand icon state used when our umbrella is opened.
	var/on_inhand_icon_state = "umbrella_on"

/obj/item/melee/transforming/umbrella/worn_overlays(mutable_appearance/standing, isinhands)
	. = ..()
	if(!isinhands)
		return
	var/mob/holder = loc
	if(open)
		if(ISODD(holder.get_held_index_of_item(src))) //left hand or right hand?
			. += mutable_appearance(lefthand_file, icon_state + "_BACK", BELOW_MOB_LAYER)
		else
			. += mutable_appearance(righthand_file, icon_state + "_BACK", BELOW_MOB_LAYER)

/obj/item/melee/transforming/umbrella/transform_messages(mob/living/user, supress_message_text)
	playsound(user, on_sound, 35, TRUE)
	if(!supress_message_text)
		balloon_alert(user, active ? "opened" : "closed")
	open = active
	icon_state = active ? icon_state_on : icon_state

/obj/item/melee/transforming/umbrella/proc/get_worn_offsets(isinhands)
	. = list(0,0)
	var/mob/holder = loc
	if(isinhands)
		//Handle held offsets
		if(istype(holder))
			var/list/offsets = holder.get_item_offsets_for_index(holder.get_held_index_of_item(src))
			if(offsets)
				.[1] = offsets["x"]
				.[2] = offsets["y"]
	else
		.[2] = worn_y_offset
	if(!isinhands)
		return
	if(open)
		.[2] += open_y_offset
		switch(loc.dir)
			if(NORTH)
				.[1] += ISODD(holder.get_held_index_of_item(src)) ? -open_x_offset : open_x_offset
			if(SOUTH)
				.[1] += ISODD(holder.get_held_index_of_item(src)) ? open_x_offset : -open_x_offset
			if(EAST)
				.[1] -= open_x_offset
			if(WEST)
				.[1] += open_x_offset

//other umbrellas
/obj/item/melee/transforming/umbrella/parasol
	name = "parasol"
	desc = "A black laced parasol, how intricate."
	icon_state = "parasol"
	on_inhand_icon_state = "parasol_on"
	icon_state_on = "parasol_on"
*/

//Horrifying attempt at a day/night system.

/client/proc/cycle_day_night()
	set name = "Cycle Day/Night"
	set category = "Admin.Events"
	set desc = "Cycles the /lit turfs on the selected virtual z."


	var/list/turfs_to_change = list(/turf/open/floor/plating/asteroid/sand/lit,
									/turf/open/floor/plating/asteroid/sand/dense/lit,
									/turf/open/floor/plating/grass/beach/lit,
									/turf/open/floor/plating/asteroid/snow/lit,
									/turf/open/floor/plating/asteroid/snow/under/lit,
									/turf/open/floor/plating/asteroid/icerock/lit,
									/turf/open/floor/plating/asteroid/iceberg/lit,
									/turf/open/floor/plating/dirt/jungle/lit,
									/turf/open/floor/plating/dirt/jungle/dark/lit,
									/turf/open/floor/plating/dirt/jungle/wasteland/lit,
									/turf/open/floor/plating/grass/jungle/lit,
									/turf/open/water/jungle/lit,
									/turf/open/floor/plating/asteroid/basalt/lava_land_surface/lit,
									/turf/open/floor/plating/asteroid/basalt/purple/lit,
									/turf/open/floor/plating/asteroid/purple/lit,
									/turf/open/floor/plating/ice/lit,
									/turf/open/floor/plating/ice/iceberg/lit,
									/turf/open/floor/plating/dirt/old/lit,
									/turf/open/floor/plating/dirt/old/dark/lit,
									/turf/open/floor/plating/dirt/dry/lit,
									/turf/open/floor/plating/asteroid/rockplanet/lit,
									/turf/open/floor/plating/asteroid/rockplanet/cracked/lit,
									/turf/open/floor/plating/asteroid/rockplanet/wet/lit,
									/turf/open/floor/plating/asteroid/rockplanet/wet/cracked/lit,
									/turf/open/floor/plating/rockplanet/lit,
									/turf/open/floor/plating/rust/rockplanet/lit,
									/turf/open/floor/plasteel/stairs/rockplanet/lit,
									/turf/open/floor/plasteel/rockplanet/lit,
									/turf/open/floor/plasteel/patterned/rockplanet/lit,
									/turf/open/floor/plasteel/patterned/brushed/rockplanet/lit,
									/turf/open/floor/plasteel/patterned/ridged/rockplanet/lit,
									/turf/open/floor/engine/hull/rockplanet/lit,
									/turf/open/floor/engine/hull/reinforced/rockplanet/lit,
									/turf/open/floor/concrete/rockplanet/lit,
									/turf/open/floor/mineral/titanium/tiled/rockplanet/lit,
									/turf/open/floor/plating/asteroid/snow/lit/rockplanet,
									/turf/open/floor/plating/asteroid/wasteplanet/lit,
									/turf/open/water/tar/waste/lit,
									/turf/open/floor/plating/grass/wasteplanet/lit,
									/turf/open/floor/plating/dirt/old/waste/lit,
									/turf/open/floor/plating/wasteplanet/lit,
									/turf/open/floor/plating/wasteplanet/rust/lit,
									/turf/open/floor/plating/asteroid/wasteplanet/lit,
									/turf/open/water/tar/waste/lit,
									/turf/open/floor/concrete/wasteplanet/lit,
									/turf/open/floor/concrete/reinforced/wasteplanet/lit,
									/turf/open/floor/concrete/pavement/wasteplanet/lit,
									/turf/open/floor/plating/dirt/old/waste/lit,
									/turf/open/floor/plating/grass/wasteplanet/lit,
									/turf/open/water/waste/lit,
									/turf/open/floor/plating/asteroid/whitesands/lit,
									/turf/open/floor/plating/asteroid/whitesands/dried/lit,
									/turf/open/floor/plating/asteroid/whitesands/grass/lit,
									/turf/open/floor/plating/asteroid/whitesands/grass/dead/lit,
									/turf/open/floor/plating/asteroid/snow/lit/whitesands,
									/turf/open/floor/concrete/whitesands/lit,
									/turf/open/floor/concrete/reinforced/whitesands/lit,
									/turf/open/floor/concrete/pavement/whitesands/lit,
									/turf/open/floor/concrete/slab_1/whitesands/lit,
									/turf/open/floor/plating/whitesands/lit)

	if(!holder)
		to_chat(src, "Only administrators may use this command.", confidential = TRUE)
		return
	if(!check_rights(R_DEBUG, 1))
		return

	var/target_z = input(usr, "Enter the (virtual) z-level you want to alter the day/night state of.", "The Sun", 0) as num

	for(var/atom/Turf in world)
		if(isturf(Turf))
			var/turf/ourTurf = Turf
			if(ourTurf.type in turfs_to_change)
				if(ourTurf.virtual_z != target_z)
					continue
				if(ourTurf.light_range == 2)
					ourTurf.set_light(0)
				else
					ourTurf.set_light(2)
			/*if(ourturf.loc.allow_weather == TRUE && ourTurf.virtual_z == target_z) //Alternative method
				if(ourTurf.light_range == 2)
					ourTurf.set_light(0)
				else
					ourTurf.set_light(2)*/
		CHECK_TICK
	log_admin("[key_name(usr)] swapped the day/night status of the [target_z] virtual z level ")
	message_admins("<span class='notice'>[key_name(usr)] swapped the day/night status of the [target_z] virtual z level </span>")
