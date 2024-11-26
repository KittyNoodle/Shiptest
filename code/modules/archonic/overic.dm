/datum/language/overic
	name = "⊛"
	desc = "A timeless language full of power and incomprehensible to the unenlightened."
	speech_verb = "illuminates"
	ask_verb = "requests"
	exclaim_verb = "proclaims"
	whisper_verb = "imparts"
	key = "M"
	flags = LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD|NO_STUTTER
	default_priority = 300
	spans = list("overic","memoedit")
	icon_state = "ratvar"

/datum/language/overic/scramble(input)
	. = text2overic(input)

/datum/language_holder/overic
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/overic = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/overic = list(LANGUAGE_ATOM))


/////////////////////FACTION/////////////////////

/datum/faction/overic
	name = FACTION_OVERIC
	prefixes = PREFIX_OVERIC

//////////////////////TURFS//////////////////////

/turf/closed/indestructible/overic
	name = "strange wall"
	desc = "A wall made of an unknown alien material. It does not feel hot or cold to the touch, as if completely unconductive."
	icon = 'code/modules/archonic/icons/overic_wall.dmi'
	icon_state = "overic_wall-0"
	base_icon_state = "overic_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_BOSS_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_BOSS_WALLS)
	explosion_block = 50

/turf/open/indestructible/overic
	name = "strange plating"
	icon = 'code/modules/archonic/icons/overic_turf.dmi'
	icon_state = "floor"

/turf/open/indestructible/overic/active
	name = "strange plating"
	icon_state = "floor-on"

/turf/open/indestructible/overic/hangar
	name = "strange hangar floor"
	icon_state = "shuttle-bay"

/turf/open/indestructible/overic/hangar/middle
	icon_state = "shuttle-bay-middle"

/turf/open/indestructible/overic/floor
	name = "strange floor"
	icon_state = "shuttle-floor"

/turf/open/indestructible/overic/energy
	name = "energy field"
	icon_state = "energy_field"

////////////////////OBJECTS////////////////////

/obj/structure/table/overic
	name = "strange surface"
	desc = "A raised platform made of an unknown material, the top of it feels somewhat fluidlike, and if you put just enough pressure you feel like you could push through it."
	icon = 'code/modules/archonic/icons/table_overic.dmi'
	icon_state = "table-0"
	base_icon_state = "table"
	flags_1 = NODECONSTRUCT_1
	max_integrity = 20000
	integrity_failure = 0.1
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF


/obj/structure/overic_light
	name = "glowing crystal-metal"
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "light-on"
	desc = "A brightly glowing crystalline structure. It feels cool and metallic to the touch."
	layer = WALL_OBJ_LAYER
	flags_1 = NODECONSTRUCT_1
	anchored = TRUE
	max_integrity = 20000
	integrity_failure = 0.1
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/crystal_color = "#c0f2ec"
	var/crystal_brightness = 10
	var/crystal_power = 1

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/overic_light, 26)

/obj/structure/overic_light/Initialize()
	. = ..()
	set_light(crystal_brightness, crystal_power, crystal_color)

/obj/structure/overic_light/floor
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "light_floor-on"
	crystal_brightness = 6
	layer = 2.5

/obj/structure/overic_light/floor/hangar
	crystal_brightness = 30
	layer = 2.5

/obj/machinery/door/overic
	name = "rippling metal wall"
	desc = "The surface of this wall feels cold to the touch. It seems to ripple as you touch it, never letting you breach its surface."
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "door_closed"
	explosion_block = 3
	heat_proof = TRUE
	max_integrity = 600
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	damage_deflection = 70
	autoclose = TRUE
	var/allow_all = FALSE

/obj/machinery/door/overic/Bumped(atom/movable/AM)
	return !density && ..()

/obj/machinery/door/overic/try_to_activate_door(mob/user)
	add_fingerprint(user)
	if(operating)
		return
	if(check_overian(user))
		if(density)
			open()
		else
			close()
	else if(density)
		do_animate("deny")

/obj/machinery/door/overic/update_icon_state()
	. = ..()
	icon_state = density ? "door_closed" : "door_open"

/obj/machinery/door/overic/proc/check_overian(mob/user)
	if(allow_all)
		return TRUE
	if("Overic" in user.faction)
		return TRUE
	return FALSE

/obj/machinery/door/overic/do_animate(animation)
	switch(animation)
		if("opening")
			flick("door_opening", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, TRUE)
		if("closing")
			flick("door_closing", src)
			playsound(src, 'sound/machines/blastdoor.ogg', 30, TRUE)
		if("deny")
			flick("door_deny", src)
			playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)

/obj/machinery/door/overic/public
	allow_all = TRUE

/obj/structure/window/overic
	name = "transparent quarksheet"
	desc = "A pane containing an ultrathin sheet of quarks, arraigned in a way to let light in."
	max_integrity = 600
	explosion_block = 50
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "window_dir"
	flags_1 = NODECONSTRUCT_1
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	damage_deflection = 400
	reinf = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF

/obj/structure/window/overic/fulltile
	name = "transparent crystal"
	desc = "A window made from an unknown transparent material. It is neither hot or cold to the touch."
	icon_state = "window"
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1 | NODECONSTRUCT_1

/obj/structure/netcable
	name = "strange cable"
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "antenna"
	desc = "A smooth cable-like structure, with several rigid wires coming out of it."
	anchored = TRUE

/obj/structure/netcable/end
	icon_state = "antenna-end"

/obj/structure/overic_structure
	name = "something interesting"
	desc = "This should not exist"
	anchored = TRUE
	max_integrity = 600
	explosion_block = 50
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "telemarker"
	flags_1 = NODECONSTRUCT_1
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	damage_deflection = 400
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	density = TRUE
	initial_language_holder = /datum/language_holder/overic


/obj/structure/overic_structure/computer
	name = "glowing construct"
	desc = "A glowing orb nestled in a housing of machinery. It seems to be projecting a screen, the contents are changing so fast its indiscernible."
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "compute"
	var/mutable_appearance/screen

/obj/structure/overic_structure/computer/Initialize()
	. = ..()
	screen = mutable_appearance('code/modules/archonic/icons/overic.dmi', "compute_screen", ABOVE_ALL_MOB_LAYER)
	screen.pixel_y = 15
	add_overlay(screen)

////////////////////PALEFIRE////////////////////
// Of all Overic technology none is more dreaded and respected as Palefire, which dispite its name is not a white flame.
// What Palefire is, is an array of extremely precise sensors, field emitters, and micro-wormhole generators that, when active, effectively destroy any small high energy emissions like bullets or laser fire before they can exit their source.
// This obviously carries a significant tactical advantage, as it prevents smaller caliber ship weapons like autocannons and almost all personell weaponry from firing. However the original intent was never for this purpose, but instead to prevent suicides.
GLOBAL_VAR_INIT(palefire, FALSE)

/////////////////////SHIPS/////////////////////
/area/ship/overic
	name = "Interior"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | NOTELEPORT // not unique, in case multiple outposts get loaded. all derivatives should also be NOTELEPORT
	flags_1 = null
	sound_environment = SOUND_ENVIRONMENT_ROOM
	lighting_colour_tube = "#c0f2ec"
	lighting_colour_bulb = "#c0f2ec"
	lightswitch = TRUE
	power_equip = TRUE
	power_light = TRUE
	power_environ = TRUE

/obj/machinery/computer/helm/overic
	name = "glowing construct"
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "compute"
	icon_screen = null
	icon_keyboard = null
	unique_icon = TRUE
	flags_1 = NODECONSTRUCT_1
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	damage_deflection = 400
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	initial_language_holder = /datum/language_holder/overic
	var/mutable_appearance/screen

/obj/machinery/computer/helm/overic/Initialize()
	. = ..()
	screen = mutable_appearance('code/modules/archonic/icons/overic.dmi', "compute_screen", ABOVE_ALL_MOB_LAYER)
	screen.pixel_y = 15
	add_overlay(screen)

////////////////////OUTPOST////////////////////

/datum/map_template/outpost/elevator_overic
	name = "elevator_overic"

/datum/map_template/outpost/overic_carrier
	name = "overic_carrier"

/datum/map_template/outpost/hangar/overic_carrier_20x20
	name = "hangar/overic_carrier_20x20"
	dock_width = 20
	dock_height = 20

/datum/map_template/outpost/hangar/overic_carrier_40x20
	name = "hangar/overic_carrier_40x20"
	dock_width = 40
	dock_height = 20

/datum/map_template/outpost/hangar/overic_carrier_40x40
	name = "hangar/overic_carrier_40x40"
	dock_width = 40
	dock_height = 40

/datum/map_template/outpost/hangar/overic_carrier_56x20
	name = "hangar/overic_carrier_56x20"
	dock_width = 56
	dock_height = 20

/datum/map_template/outpost/hangar/overic_carrier_56x40
	name = "hangar/overic_carrier_56x40"
	dock_width = 56
	dock_height = 40

/datum/overmap/outpost/overic_carrier // For example and adminspawn.
	token_icon_state = "station_overa"
	main_template = /datum/map_template/outpost/overic_carrier
	elevator_template = /datum/map_template/outpost/elevator_overic
	hangar_templates = list(
		/datum/map_template/outpost/hangar/overic_carrier_20x20,
		/datum/map_template/outpost/hangar/overic_carrier_40x20,
		/datum/map_template/outpost/hangar/overic_carrier_40x40,
		/datum/map_template/outpost/hangar/overic_carrier_56x20,
		/datum/map_template/outpost/hangar/overic_carrier_56x40
	)

/datum/overmap/outpost/overic_carrier/post_docked(datum/overmap/ship/controlled/dock_requester)
	for(var/mob/M as anything in GLOB.player_list)
		if(dock_requester.shuttle_port.is_in_shuttle_bounds(M))
			M.play_screen_text("<span class='maptext' style=font-size:24pt;text-align:center valign='top'><u>[name]</u></span><br>[station_time_timestamp("hh:mm")]")
	var/atom/movable/virtualspeaker/v_speaker = new(null, token, null)
	var/datum/signal/subspace/vocal/signal = new(
		dock_requester.shuttle_port.docked,
		FREQ_COMMON,
		v_speaker,
		/datum/language/overic,
		"[dock_requester.name] confirmed touchdown at [dock_requester.shuttle_port.docked].",
		list("overic","memoedit"),
		list(MODE_CUSTOM_SAY_EMOTE = "illuminates")
	)
	signal.send_to_receivers()
	return

/datum/overmap/outpost/overic_carrier/post_undocked(datum/overmap/ship/controlled/dock_requester)
	var/obj/message_src
	for(var/datum/hangar_shaft/shaft as anything in shaft_datums)
		if(length(shaft.hangar_docks))
			message_src = shaft.hangar_docks[1]
			break
	var/atom/movable/virtualspeaker/v_speaker = new(null, token, null)
	var/datum/signal/subspace/vocal/signal = new(
		message_src,
		FREQ_COMMON,
		v_speaker,
		/datum/language/overic,
		"[dock_requester.name] has departed from [src].",
		list("overic","memoedit"),
		list(MODE_CUSTOM_SAY_EMOTE = "illuminates")
	)
	signal.send_to_receivers()

/datum/overmap/outpost/overic_carrier/gen_outpost_name()
	return "OSV-RRC-D-941"

/area/outpost/overic
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | NOTELEPORT // not unique, in case multiple outposts get loaded. all derivatives should also be NOTELEPORT
	flags_1 = null
	sound_environment = SOUND_AREA_STANDARD_STATION
	lighting_colour_tube = "#c0f2ec"
	lighting_colour_bulb = "#c0f2ec"
	power_equip = TRUE
	power_light = TRUE
	power_environ = TRUE

/obj/structure/elevator_platform/overic
	name = "wirenet"
	desc = "A strange network of wires, seems to be able to move independantly of its surroundings."
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "wirenet"
	smoothing_flags = 0
	smoothing_groups = null
	canSmoothWith = null

////////////////////THE MAP////////////////////

/datum/element/decal/display_overlay

/datum/element/decal/display_overlay/Attach(datum/target, _icon, _icon_state, _dir, _cleanable=FALSE, _layer=HIGH_OBJ_LAYER) //was at ABOVE_OBJ_LAYER orignally
	. = ..()

/datum/element/decal/display_overlay/generate_appearance(_icon, _icon_state, _dir, _layer, _alpha, source)
	if(!_icon || !_icon_state)
		return FALSE
	var/icon/display_overlay = icon(_icon, _icon_state, , 1)		//we only want to apply blood-splatters to the initial icon_state for each object
	display_overlay.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
	display_overlay.Blend(icon('code/modules/archonic/icons/288x288.dmi', "overic_display_overlay"), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
	pic = mutable_appearance(display_overlay)
	return TRUE

/obj/effect/display_overlay
	icon = 'code/modules/archonic/icons/overic_turf.dmi'
	icon_state = "overic_display_overlay"
	layer = 17
	plane = 17

/obj/effect/overic_map
	name = "???"
	desc = "A strange alien display, which is currently displaying a near incomprehensible map."
	icon = 'code/modules/archonic/icons/288x288.dmi'
	icon_state = "overic_map"
	pixel_x = -128
	pixel_y = -128
	appearance_flags = LONG_GLIDE

/obj/effect/overic_map/Initialize()
	. = ..()
	AddElement(/datum/element/decal/display_overlay, initial(icon) || icon, initial(icon_state) || icon_state)

/obj/effect/overic_map/huge
	icon_state = "overic_map_huge"

/obj/effect/overic_map/huge/center
	icon_state = "overic_map_huge-center"

/obj/effect/overic_map/small
	icon = 'code/modules/archonic/icons/160x160.dmi'
	icon_state = "overic_map_small"
	pixel_x = -64
	pixel_y = -64

/obj/effect/overic_map/large
	icon = 'code/modules/archonic/icons/512x512.dmi'
	icon_state = "overic_map_large"
	pixel_x = -236
	pixel_y = -236

///////////////////WEAPONS////////////////////

/obj/item/gun/energy/overic
	name = "OIW-P-D-P007"
	desc = "A strange weapon, it's almost dangerously warm to the touch."
	icon_state = "overic_pistol"
	item_state = "overic_pistol"
	icon = 'code/modules/archonic/icons/48x32.dmi'
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'
	mob_overlay_icon = 'code/modules/archonic/icons/worn/armor.dmi'
	manufacturer = MANUFACTURER_OVERIC
	w_class = WEIGHT_CLASS_NORMAL
	modifystate = FALSE

	fire_delay = 0.05 SECONDS

	wield_delay = 0.2 SECONDS
	wield_slowdown = 0.15

	muzzleflash_iconstate = "muzzle_flash_light"
	muzzle_flash_lum = 3
	muzzle_flash_color = COLOR_VERY_SOFT_YELLOW

	spread = 2
	spread_unwielded = 5

	gun_firemodes = list(FIREMODE_SEMIAUTO, FIREMODE_FULLAUTO)
	default_firemode = FIREMODE_SEMIAUTO

	default_ammo_type = /obj/item/stock_parts/cell/gun/overic
	allowed_ammo_types = list(
		/obj/item/stock_parts/cell/gun/overic,
	)
	ammo_type = list(/obj/item/ammo_casing/energy/overic/pistol, /obj/item/ammo_casing/energy/overic/cage)

/obj/item/gun/energy/overic/emp_act(severity)
	return

/obj/item/ammo_casing/energy/overic/pistol
	projectile_type = /obj/projectile/overic/phasic/pistol
	fire_sound = 'sound/weapons/gun/energy/kalixsmg.ogg'
	e_cost = 40000 //2500 shots per cell
	delay = 0

/obj/item/ammo_casing/energy/overic
	select_name  = "Force"
	projectile_type = /obj/projectile/overic/phasic
	fire_sound = 'sound/weapons/gun/energy/kalixsmg.ogg'
	e_cost = 80000 //1250 shots per cell
	delay = 1

/obj/item/ammo_casing/energy/overic/cage
	select_name  = "Entrap"
	projectile_type = /obj/projectile/overic/cage
	fire_sound = 'sound/weapons/gun/energy/kalixsmg.ogg'
	e_cost = 250000 //400 shots per cell
	delay = 5


/obj/item/stock_parts/cell/gun/overic
	name = "overic phasic cell"
	icon_state = "g-sg-cell"
	maxcharge = 100000000 // 2500 shots at 40000 energy per
	chargerate = 4000000

/obj/item/stock_parts/cell/gun/overic/corrupt()
	return

//////////////////PROJECTILE//////////////////

/obj/projectile/overic
	name = "bolt"
	icon = 'code/modules/archonic/icons/projectiles.dmi'
	icon_state = "stunbolt"
	damage = 0
	damage_type = OXY
	nodamage = TRUE
	armour_penetration = 100
	flag = "energy"
	palefire_immune = TRUE //IFF

/obj/projectile/overic/phasic
	name = "phasic bolt"
	icon = 'code/modules/archonic/icons/projectiles.dmi'
	icon_state = "phasic_bolt"
	damage = 45
	armour_penetration = 100
	speed = BULLET_SPEED_RIFLE
	damage_type = BRUTE
	nodamage = FALSE
	flag = "bullet"

	hitsound = "bullet_hit"
	hitsound_non_living = "bullet_impact"
	hitsound_glass = "bullet_hit_glass"
	hitsound_stone = "bullet_hit_stone"
	hitsound_metal = "bullet_hit_metal"
	hitsound_wood = "bullet_hit_wood"
	hitsound_snow = "bullet_hit_snow"

	near_miss_sound = "bullet_miss"
	ricochet_sound = "bullet_bounce"

	range = 70
	light_system = 2
	light_color = MOVABLE_LIGHT
	light_range = 3

	impact_effect_type = /obj/effect/temp_visual/impact_effect
	ricochets_max = 5 //should be enough to scare the shit out of someone
	ricochet_chance = 0
	ricochet_decay_damage = 0.5 //shouldnt being reliable, but deadly enough to be careful if you accidentally hit an ally

/obj/projectile/overic/phasic/pistol
	name = "phasic bolt"
	icon_state = "phasic_bolt_pistol"
	damage = 20
	projectile_piercing = PASSMOB

/obj/projectile/overic/cage
	name = "bolt"
	icon = 'code/modules/archonic/icons/projectiles.dmi'
	icon_state = "stunbolt"
	damage = 0
	damage_type = OXY
	nodamage = TRUE
	armour_penetration = 100
	flag = "energy"

	var/weld = TRUE
	var/locker_suck = TRUE
	var/obj/structure/closet/overic_cage/locker_temp_instance = /obj/structure/closet/overic_cage

/obj/projectile/overic/cage/Initialize()
	. = ..()
	locker_temp_instance = new(src)

/obj/projectile/overic/cage/on_hit(target)
	if(isliving(target))
		var/mob/living/M = target
		M.forceMove(src)
		locker_temp_instance.name = "overic energy cage ([M])"
		if(LAZYLEN(contents))
			for(var/atom/movable/AM in contents)
				locker_temp_instance.insert(AM)
			locker_temp_instance.welded = weld
			locker_temp_instance.update_appearance()
	return ..()

/obj/projectile/overic/cage/Destroy()
	locker_suck = FALSE
	RemoveElement(/datum/element/connect_loc, projectile_connections) //We do this manually so the forcemoves don't "hit" us. This behavior is kinda dumb, someone refactor this
	for(var/atom/movable/AM in contents)
		AM.forceMove(get_turf(src))
	. = ..()

/obj/structure/closet/overic_cage
	name = "overic energy cage"
	desc = "A strange box, it seems utterly unbreakable."
	breakout_time = 6000000
	max_mob_size = MOB_SIZE_HUGE
	can_weld_shut = FALSE
	icon_welded = null
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "cage"
	drag_slowdown = 0

/obj/structure/closet/overic_cage/open(mob/living/user, force = FALSE)
	. = ..()
	if(.)
		qdel(src)



/////////////////////MOB/////////////////////


/mob/living/simple_animal/overian
	name = "overian"
	desc = "A spheroid containing crackling energy, the energy seemingly emanating from a glowing orb within it. It seems to move on its own."
	icon = 'code/modules/archonic/icons/overic.dmi'
	icon_state = "overa"
	AIStatus = AI_OFF
	wander = FALSE
	speed = 0
	faction = list("Overic")
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	damage_coeff = list(BRUTE = 0.8, BURN = 0.6, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	health = 700
	maxHealth = 700
	light_range = 3
	light_color = "#c0f2ec"
	minbodytemp = 0
	maxbodytemp = INFINITY
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	obj_damage = 500
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	move_resist = MOVE_FORCE_OVERPOWERING
	pull_force = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_HUGE
	movement_type = FLYING
	response_help_continuous = "taps"
	response_help_simple = "tap"
	response_disarm_continuous = "pushes against"
	response_disarm_simple = "push against"
	response_harm_continuous = "hits"
	response_harm_simple = "hit"
	attack_verb_continuous = "sublimates"
	attack_verb_simple = "sublimate"
	attack_sound = 'sound/effects/gravhit.ogg'
	melee_damage_lower = 200
	melee_damage_upper = 200
	dextrous = TRUE
	speech_span = list("overic","memoedit")
	held_items = list(null, null)
	possible_a_intents = list(INTENT_HELP, INTENT_GRAB, INTENT_DISARM, INTENT_HARM)
	initial_language_holder = /datum/language_holder/overic
	speak_emote = list("illuminates")
	verb_say = "illuminates"
	verb_ask = "requests"
	verb_exclaim = "proclaims"
	verb_yell = "imparts"
	see_in_dark = 10
	force_threshold = 40
	var/datum/action/innate/overic/dexterity/dextoggle

/mob/living/simple_animal/overian/Initialize()
	. = ..()
	dextoggle = new
	dextoggle.Grant(src)
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)

/mob/living/simple_animal/overian/overa
	name = "\proper The Overa"
	desc = "A spheroid containing ████████████████████████, the energy seemingly emanating from ███████████████████. It seems to move on its own."
	light_range = 5
	melee_damage_lower = 9000
	melee_damage_upper = 9000
	obj_damage = 4000
	health = 50000
	maxHealth = 50000
	force_threshold = 5000
	damage_coeff = list(BRUTE = 0.5, BURN = -5, TOX = -0.1, CLONE = -0.1, STAMINA = 0, OXY = 0)
	speech_span = list("overic","command_headset")
	var/mutable_appearance/censor

/mob/living/simple_animal/overian/overa/Initialize()
	. = ..()
	censor = mutable_appearance('code/modules/archonic/icons/overic.dmi', "overa_censor", RIPPLE_LAYER+0.01)
	add_overlay(censor)

/obj/effect/proc_holder/spell/aimed/overic_cage
	name = "Caging Bolt"
	desc = "Caging Bolt"
	school = "evocation"
	icon = 'code/modules/archonic/icons/projectiles.dmi'
	icon_state = "stunbolt"
	charge_max = 20
	clothes_req = FALSE
	cooldown_min = 20
	base_icon_state = "lightning"
	action_icon_state = "lightning0"
	active = FALSE
	antimagic_allowed = TRUE
	active_msg = "You ready a caging bolt..."
	deactive_msg = "You disarm the caging bolt..."
	projectile_type = /obj/projectile/overic/cage

/datum/action/innate/overic
	button_icon = 'code/modules/archonic/icons/overic.dmi'
	background_icon_state = "bg_overic"
	icon_icon = 'code/modules/archonic/icons/overic.dmi'

/datum/action/innate/overic/dexterity
	name = "Toggle Dexterity"
	button_icon_state = "dex_toggle"
	desc = "Switch between using direct attacks and using your 'hands'."

/datum/action/innate/overic/dexterity/Activate()
	var/mob/living/simple_animal/overian/O = owner
	if(O.dextrous)
		O.dextrous = FALSE
		to_chat(O, "<span class='notice'>You no longer dextrous.</span>")
	else
		O.dextrous = TRUE
		to_chat(O, "<span class='notice'>You now dextrous.</span>")

/obj/effect/proc_holder/spell/targeted/shapeshift/overic
	name = "Release Disguise"
	desc = "Become what you truely are."
	invocation = null
	convert_damage = FALSE


	shapeshift_type = /mob/living/simple_animal/overian
