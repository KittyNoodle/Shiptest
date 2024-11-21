#define INTERFACE_MESSAGE 1
#define INTERFACE_CONTROL 2
#define INTERFACE_RESTRAIN 3
#define SOE_HEALTH_RESTORE -50

/*
//////////////////////////////Overrides//////////////////////////////
*/

/obj/item/implant/spell/Initialize()
    . = ..()
    if(ispath(src.spell))
        src.spell = new spell

/*
//////////////////////////Items & Outfits////////////////////////////
*/

/obj/item/melee/spear/archous
	icon_state = "archonic_spear0"
	name = "\improper Archonic Shard"
	desc = "A shard of archonic crystal, transformed into a powerful weapon. The prefered weapon of archonicists."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	base_icon_state = "archonic_spear"
	icon_prefix = "archonic_spear"
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'
	mob_overlay_icon = 'icons/mob/clothing/back.dmi'
	sharpness = IS_SHARP_ACCURATE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	force = 30
	throwforce = 50
	block_chance = 80
	armour_penetration = 70
	max_integrity = 300
	var/wielded = FALSE

/obj/item/melee/spear/archous/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=20, force_wielded=35, icon_wielded="[icon_prefix]1") //4 hit crit

/obj/item/melee/spear/archous/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/// triggered on wield of two handed item
/obj/item/melee/spear/archous/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/melee/spear/archous/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/melee/spear/archous/attack(mob/living/M, mob/user)
	. = ..()
	if(wielded)
		flash_color(M, "#ff0066", 1)

/obj/item/melee/spear/archous/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(prob(final_block_chance))
		if(attack_type == PROJECTILE_ATTACK)
			owner.visible_message("<span class='danger'>[owner] absorbs [attack_text] with [src]!</span>")
			playsound(src, 'sound/weapons/effects/deflect.ogg', 100, TRUE)
			return TRUE
		else
			playsound(src, 'sound/weapons/parry.ogg', 75, TRUE)
			owner.visible_message("<span class='danger'>[owner] parries [attack_text] with [src]!</span>")
			return TRUE
	return FALSE

/obj/item/clothing/neck/crystal_amulet/archous
	name = "archonic amulet"
	desc = "A mysterious amulet which protects the user from hits, at the cost of itself."
	icon_state = "crystal_talisman"
	shield_state = "purplesparkles"
	shield_on = "purplesparkles"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 100 //you can repair this with duct tape
	damage_to_take_on_hit = 10 //every time the owner is hit, how much damage to give to the amulet?

/obj/item/clothing/neck/crystal_amulet/archous/stayofexecution
	name = "Stay of Execution"
	desc = "A mysterious amulet which prevents enviromental damage, and prevents most negative health effects, including death. The effect and the amulet destroyed by blocking a single hit."
	damage_to_take_on_hit = 100 //instant death

/obj/item/clothing/neck/crystal_amulet/archous/stayofexecution/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_NECK)
		if(user.stat == DEAD)
			var/overall_damage = user.getBruteLoss() + user.getFireLoss() + user.getToxLoss() + user.getOxyLoss()
			var/mobhealth = user.health
			user.adjustOxyLoss((mobhealth - SOE_HEALTH_RESTORE) * (user.getOxyLoss() / overall_damage), 0)
			user.adjustToxLoss((mobhealth - SOE_HEALTH_RESTORE) * (user.getToxLoss() / overall_damage), 0)
			user.adjustFireLoss((mobhealth - SOE_HEALTH_RESTORE) * (user.getFireLoss() / overall_damage), 0)
			user.adjustBruteLoss((mobhealth - SOE_HEALTH_RESTORE) * (user.getBruteLoss() / overall_damage), 0)
			user.updatehealth()
			user.cure_husk()
			user.set_heartattack(FALSE)
			user.grab_ghost()
			user.revive(full_heal = FALSE, admin_revive = FALSE)
			user.emote("gasp")
		ADD_TRAIT(user, TRAIT_NOBREATH, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_NODEATH, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_NOHARDCRIT, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_NOCRITDAMAGE, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_RESISTLOWPRESSURE, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_RESISTCOLD, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_RESISTHIGHPRESSURE, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_RESISTHEAT, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_SLEEPIMMUNE, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_VIRUSIMMUNE, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_BOMBIMMUNE, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_STABLEHEART, "stay_of_execution")
		ADD_TRAIT(user, TRAIT_STABLELIVER, "stay_of_execution")
		user.failed_last_breath = FALSE
		user.clear_alert("not_enough_oxy")
		user.apply_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/neck/crystal_amulet/archous/stayofexecution/dropped(mob/living/carbon/human/user)
	..()
	REMOVE_TRAIT(user, TRAIT_NOBREATH, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_NODEATH, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_NOCRITDAMAGE, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_RESISTLOWPRESSURE, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_RESISTCOLD, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_RESISTHIGHPRESSURE, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_RESISTHEAT, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_SLEEPIMMUNE, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_VIRUSIMMUNE, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_BOMBIMMUNE, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_STABLEHEART, "stay_of_execution")
	REMOVE_TRAIT(user, TRAIT_STABLELIVER, "stay_of_execution")
	user.remove_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/suit/wizrobe/magusred/archonic
	name = "\improper Archonic robe"
	desc = "A set of armored robes that seem to radiate <span class='revenwarning'>violet light</span>. Their armor somehow extends to the head."
	gas_transfer_coefficient = 0
	permeability_coefficient = 0.02
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	cold_protection = HEAD|CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD|CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	body_parts_covered = HEAD|CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	icon = 'icons/obj/clothing/suits/hooded.dmi'
	mob_overlay_icon = 'icons/mob/clothing/suits/hooded.dmi'
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"
	//icon_state = "magusred"
	//item_state = "magusred"
	armor = list("melee" = 80, "bullet" = 90, "laser" = 90, "energy" = 100, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)

/obj/item/clothing/suit/wizrobe/magusred/archonic/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_OCLOTHING)
		ADD_TRAIT(user, TRAIT_NOBREATH, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_BOMBIMMUNE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_RESISTLOWPRESSURE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_RESISTCOLD, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_RESISTHIGHPRESSURE, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_RESISTHEAT, "suit_[REF(src)]")
		ADD_TRAIT(user, TRAIT_NOFIRE, "suit_[REF(src)]")
		user.failed_last_breath = FALSE
		user.clear_alert("not_enough_oxy")
		user.apply_status_effect(/datum/status_effect/rebreathing)

/obj/item/clothing/suit/wizrobe/magusred/archonic/dropped(mob/living/carbon/human/user)
	..()
	REMOVE_TRAIT(user, TRAIT_NOBREATH, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_BOMBIMMUNE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_RESISTLOWPRESSURE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_RESISTCOLD, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_RESISTHIGHPRESSURE, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_RESISTHEAT, "suit_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_NOFIRE, "suit_[REF(src)]")
	user.remove_status_effect(/datum/status_effect/rebreathing)

/obj/item/archonic_talisman
	name = "archonic talisman"
	desc = "A tiny purple crystal, as you hold it you can feel a warmness in your hand, and a gentle pulse."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "archonic_crystal"
	w_class = WEIGHT_CLASS_TINY
	var/in_use = FALSE

/obj/item/archonic_talisman/equipped(mob/living/carbon/human/user)
	. = ..()
	if("Archous" in user.faction) //do not double archous me
		return
	user.faction |= "Archous"
	in_use = TRUE

/obj/item/archonic_talisman/dropped(mob/living/carbon/human/user)
	..()
	if(in_use)
		user.faction -= "Archous"


/obj/machinery/cythrxcrystal
	name = "anomalous crystal"
	desc = "A strange chunk of crystal, being in the presence of it fills you with equal parts <span class='revenwarning'>dread</span> and <span class='cultitalic'>fascination</span>."
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "anomaly_crystal"
	light_range = 8
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	use_power = NO_POWER_USE
	anchored = FALSE
	density = TRUE
	var/droning = TRUE //accessibility
	var/activated = FALSE
	var/prox_activate = FALSE
	var/speedcoeff = 1.5 //lower means faster, higher means slower.
	var/datum/proximity_monitor/proximity_monitor
	var/datum/looping_sound/cythrx/crystal_ambient/ambient
	var/datum/looping_sound/cythrx/crystal_active/active
	var/datum/looping_sound/cythrx/crystal_active_1/stage1
	var/datum/looping_sound/cythrx/crystal_active_2/stage2
	var/datum/looping_sound/cythrx/crystal_active_3/stage3

/obj/machinery/cythrxcrystal/Initialize()
	. = ..()

	proximity_monitor = new(src, 1)
	ambient = new(list(src), FALSE)
	active = new(list(src), FALSE)
	stage1 = new(list(src), FALSE)
	stage2 = new(list(src), FALSE)
	stage3 = new(list(src), FALSE)

	if(droning)
		ambient.start()

/obj/machinery/cythrxcrystal/HasProximity(atom/movable/AM)
	if(!prox_activate)
		return
	if(activated || !isliving(AM))
		return
	var/mob/living/harbinger = AM
	if(!harbinger.client) //please no "John NPC" setting this off
		return
	activate()

/obj/machinery/cythrxcrystal/proc/activate()
	visible_message(span_resonate("[src] begins to emit a low hum..."))
	activated = TRUE
	if(droning)
		ambient.stop()
		active.start()
	addtimer(CALLBACK(src, PROC_REF(summon_stageone)), (9 SECONDS * speedcoeff))

/obj/machinery/cythrxcrystal/proc/summon_stageone()
	visible_message(span_revenboldnotice("[src]'s hum escalates to a low droning sound. It makes your head ache and your eyes feel weird..."))
	if(droning)
		active.stop()
		stage1.start()
	for(var/mob/living/witnesses in viewers(7, src))
		if(ishuman(witnesses))
			var/mob/living/carbon/human/H = witnesses
			H.adjust_blurriness(4)
			H.confused += 10
			H.adjustStaminaLoss(30)
	addtimer(CALLBACK(src, PROC_REF(summon_stagetwo)), (13 SECONDS * speedcoeff))

/obj/machinery/cythrxcrystal/proc/summon_stagetwo()
	visible_message(span_hierophant("[src] begins to rattle and vibrate, your head is pounding..."))
	if(droning)
		stage1.stop()
		stage2.start()
	for(var/mob/living/witnesses in viewers(7, src))
		if(ishuman(witnesses))
			var/mob/living/carbon/human/H = witnesses
			H.adjust_blurriness(10)
			H.confused += 15
			H.adjustStaminaLoss(40)
	addtimer(CALLBACK(src, PROC_REF(summon_stagethree)), (13 SECONDS * speedcoeff))

/obj/machinery/cythrxcrystal/proc/summon_stagethree()
	visible_message(span_revendanger("Cracks begin to form on the surface of [src] as a purple haze forms within..."))
	if(droning)
		stage2.stop()
		stage3.start()
	playsound(src, 'sound/effects/glowstick.ogg', 100, FALSE)
	for(var/mob/living/witnesses in viewers(7, src))
		if(ishuman(witnesses))
			var/mob/living/carbon/human/H = witnesses
			H.adjust_blurriness(5)
			H.confused += 10
			H.adjustStaminaLoss(20)
	addtimer(CALLBACK(src, PROC_REF(summon_final)), 6 SECONDS)

/obj/machinery/cythrxcrystal/proc/summon_final()
	visible_message(span_cultlarge("The [src] blows apart with a deafening blast, releasing a creeping purple smoke, which rapidly devours the crystal shards."))
	if(droning)
		stage3.stop()
	for(var/mob/living/witnesses in viewers(7, src))
		if(ishuman(witnesses))
			var/mob/living/carbon/human/H = witnesses
			H.adjust_blurriness(2)
			H.confused += 7
			H.Knockdown(20)
	for(var/mob/M in GLOB.player_list)
		if(M.virtual_z() == virtual_z())
			SEND_SOUND(M, 'sound/effects/glassbr1.ogg')
			to_chat(M, "<span class='revenbignotice'>You hear a loud crashing sound... then nothing... pure silence fills your ears...</span>")
	//something to change weather
	new /turf/open/indestructible/cythrx(loc)

/obj/machinery/cythrxcrystal/silenced
	droning = FALSE

/obj/machinery/cythrxcrystal/silenced/proximity
	prox_activate = TRUE

/obj/machinery/cythrxcrystal/proximity
	prox_activate = TRUE

/obj/item/organ/cyberimp/arm/archonic
	name = "archonic toolset implant"
	desc = "An archonic shard designed to manufacture and dissolve tools, allowing an Archonicist quick access to any tools they desire."
	items_to_create = list(/obj/item/screwdriver/abductor, /obj/item/wrench/abductor, /obj/item/weldingtool/abductor,
		/obj/item/crowbar/abductor, /obj/item/wirecutters/abductor, /obj/item/multitool/abductor, /obj/item/archonic/interface_system)

/obj/machinery/power/rtg/abductor/archonic
	name = "Archonic Tap"
	desc = "An archonic power source that produces energy from a tether to Archous's light."
	flags_1 = NODECONSTRUCT_1
	var/deactivated = FALSE

/obj/machinery/power/rtg/abductor/archonic/examine(mob/user)
	. = ..()
	if(deactivated)
		. += "<span class='revenminor'>The status display reads: Tether failure detected.</span>"
		return
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Power generation now at <b>[power_gen*0.001]</b>kW.</span>"

/obj/machinery/power/rtg/abductor/archonic/proc/deactivate()
	visible_message("<span class='revenwarning'>\The [src]'s lights flicker off.</span>")
	deactivated = TRUE
	power_gen = 0

/obj/machinery/power/rtg/abductor/archonic/proc/reactivate()
	visible_message("<span class='revenwarning'>\The [src]'s lights turn back on with a faint hum.</span>")
	deactivated = FALSE
	power_gen = 20000

/obj/item/archonic
	icon = 'icons/obj/abductor.dmi'
	lefthand_file = 'icons/mob/inhands/antag/abductor_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/abductor_righthand.dmi'

/obj/item/proc/ArchonicCheck(mob/user)
	if(HAS_TRAIT(user, TRAIT_ABDUCTOR_TRAINING))
		return TRUE
	if(istype(user) && user.mind && HAS_TRAIT(user.mind, TRAIT_ABDUCTOR_TRAINING))
		return TRUE
	to_chat(user, "<span class='warning'>You can't figure out how this works!</span>")
	user.dropItemToGround(src, TRUE)
	if(ishuman(user))
		to_chat(user, "<span class='revendanger'>[src] heats up to an extreme temperature, burning your hand!</span>")
		var/mob/living/carbon/human/H = user
		H.Paralyze(70, TRUE)
		H.apply_damage(50, BURN, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
	return FALSE

/obj/item/archonic/interface_system
	name = "archonic interface system"
	desc = "A multi-purpose tool designed to archonically communitcate, restrain, or command anyone using an archonic bioresonance mimicry system."
	icon_state = "mind_device_message"
	item_state = "silencer"
	var/mode = INTERFACE_MESSAGE
	var/modename = "TRANSMISSION"
	var/charge = 100
	var/self_charge = TRUE
	var/charge_amount = 5

/obj/item/archonic/interface_system/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/archonic/interface_system/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/archonic/interface_system/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, self_charge))
			if(var_value)
				START_PROCESSING(SSobj, src)
			else
				STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/archonic/interface_system/process()
	if(self_charge)
		if(charge < 100)
			adjust_charge(5)
	else
		return PROCESS_KILL

/obj/item/archonic/interface_system/proc/adjust_charge(amount)
	if(amount >= 0)
		charge = clamp(charge+amount, 0, 100)
		return TRUE
	else
		charge = clamp(charge+amount, 0, 100)
		return TRUE

/obj/item/archonic/interface_system/examine(mob/user)
	. = ..()
	if(!self_charge)
		. += "<span class='revenminor'>The internal archonic crystal reports a failure to form an archonic tether. Use sparingly.</span>"
	. += "The internal archonic crystal reports a <span class='hierophant'>[charge]%</span> internal charge."

/obj/item/archonic/interface_system/attack_self(mob/user)
	if(!ArchonicCheck(user))
		return

	switch(mode)
		if(INTERFACE_MESSAGE)
			mode = INTERFACE_CONTROL
			icon_state = "mind_device_control"
			modename = "COMMAND"
		if(INTERFACE_CONTROL)
			mode = INTERFACE_RESTRAIN
			icon_state = "mind_device_control"
			modename = "RESTRAIN"
		if(INTERFACE_RESTRAIN)
			mode = INTERFACE_MESSAGE
			icon_state = "mind_device_message"
			modename = "TRANSMISSION"
	to_chat(user, "<span class='notice'>You switch the device to [modename] MODE</span>")

/obj/item/archonic/interface_system/afterattack(atom/target, mob/living/user, flag, params)
	. = ..()
	if(!ArchonicCheck(user))
		return

	switch(mode)
		if(INTERFACE_CONTROL)
			interface_control(target, user)
		if(INTERFACE_RESTRAIN)
			interface_restrain(target, user)
		if(INTERFACE_MESSAGE)
			interface_message(target, user)

/obj/item/archonic/interface_system/proc/interface_control(atom/target, mob/living/user)
	if(ismachinery(target))
		interact_machine(target, user)
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		var/command = stripped_input(user, "Enter the command for your target to follow.","Enter command")

		if(!command)
			if(C.mind && C.mind.has_antag_datum(/datum/antagonist/brainwashed))
				if(charge < 10)
					to_chat(user, "<span class='revennotice'>The archonic crystal within [src] hums uselessly.</span>")
					return
				adjust_charge(-10)
				to_chat(C, "<span class='revendanger'>[user]'s archonic interface system flashes into your eyes, clearing your mind of its influence.</span>")
				C.mind.remove_antag_datum(/datum/antagonist/brainwashed)
			return

		if(charge < 70)
			to_chat(user, "<span class='revennotice'>The archonic crystal within [src] hums uselessly.</span>")
			return

		if(QDELETED(user) || user.get_active_held_item() != src || loc != user)
			return

		adjust_charge(-70)
		new /obj/effect/temp_visual/archous_flash/fading(get_turf(src))
		flash_color(C, "#ff0066", 20)
		brainwash(C, command)
		to_chat(C, "<span class='revendanger'>A flash of violet light shoots out of [user]'s archonic interface system and burns into your eyes.</span>")
		user.visible_message("<span class='revenwarning'>[src] emits a flash of violet light</span>")
		to_chat(user, "<span class='revennotice'>You send the command to your target.</span>")

/obj/item/archonic/interface_system/proc/interface_message(atom/target, mob/living/user)
	if(ismachinery(target))
		interact_machine(target, user)
		return
	if(isliving(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			to_chat(user, "<span class='revenwarning'>Your target is dead!</span>")
			return
		var/message = stripped_input(user, "Write a message to send to your target's brain.","Enter message")
		if(!message)
			return
		if(QDELETED(L) || L.stat == DEAD)
			return

		if(charge < 1)
			to_chat(user, "<span class='revennotice'>The archonic crystal within [src] hums uselessly.</span>")
			return
		adjust_charge(-1)
		to_chat(L, "<span class='revenwarning'>You hear a voice in your head saying: </span><span class='hypnophrase'>[message]</span>")
		to_chat(user, "<span class='revennotice'>You send the message to your target.</span>")
		log_directed_talk(user, L, message, LOG_SAY, "archonic interface")

/obj/item/archonic/interface_system/proc/interface_restrain(atom/target, mob/living/user)
	if(ismachinery(target))
		var/obj/machinery/M = target
		if(charge < 5)
			to_chat(user, "<span class='revennotice'>The archonic crystal within [src] hums uselessly.</span>")
			return
		adjust_charge(-5)
		M.emp_act(1)
		to_chat(user, "<span class='revennotice'>You deliver an electromagnetic pulse to your target.</span>")
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(C.stat == DEAD)
			to_chat(user, "<span class='revenwarning'>Your target is dead!</span>")
			return
		if(QDELETED(C) || C.stat == DEAD)
			return

		if(charge < 5)
			to_chat(user, "<span class='revennotice'>The archonic crystal within [src] hums uselessly.</span>")
			return
		adjust_charge(-5, user)

		to_chat(user, "<span class='revennotice'>You restrain your target.</span>")
		to_chat(C, "<span class='revenwarning'>Violet wires shoot out from [user]'s archonic interface system and wrap around you, holding you still. The wires quickly fade away, but their effect lingers.</span>")
		flash_color(C, "#ff0066", 5)
		C.Paralyze(300, TRUE)
		C.Knockdown(400, TRUE)

/obj/item/archonic/interface_system/proc/interact_machine(atom/target, mob/living/user)
	var/obj/machinery/machine = target
	if(istype(machine, /obj/machinery/door))
		var/obj/machinery/door/D = machine
		if(charge < 1)
			to_chat(user, "<span class='revennotice'>The archonic crystal within [src] hums uselessly.</span>")
			return
		to_chat(user, "<span class='revennotice'>You point [src] at [src], forcing it to open.</span>")
		adjust_charge(-1)
		if(istype(D, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/A = D
			A.locked = FALSE
		D.open()
		return


/datum/outfit/archonic
	name = "Archonic"
	uniform = /obj/item/clothing/under/syndicate/skirt
	suit = /obj/item/clothing/suit/wizrobe/magusred/archonic
	shoes = /obj/item/clothing/shoes/jackboots
	neck = /obj/item/clothing/neck/crystal_amulet/archous
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/melee/spear/archous
	implants = list(/obj/item/implant/freedom, /obj/item/implant/weapons_auth, /obj/item/implant/radio, /obj/item/implant/spell/archonic/barrage, /obj/item/implant/spell/archonic/summonitem, /obj/item/implant/spell/archonic/knock, /obj/item/implant/spell/archonic/heal, /obj/item/implant/spell/archonic/sparkstorm, /obj/item/implant/spell/archonic/flight, /obj/item/implant/archonic_storage, /obj/item/implant/archonic)

/datum/outfit/archonic/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.faction |= list(FACTION_ANTAG_ARCHOUS)

/*
///////////////////////////Archonic Flash///////////////////////////
*/


/obj/effect/temp_visual/silence_lightning
	icon = 'code/modules/archonic/icons/96x96.dmi'
	icon_state = "overaelectric"
	duration = 20
	pixel_x = -32
	pixel_y = -32
	alpha = 1

/obj/effect/temp_visual/silence_lightning/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 5)

/obj/effect/temp_visual/archous_flash
	icon = 'code/modules/archonic/icons/96x96.dmi'
	icon_state = "arch_flash"
	plane = ABOVE_LIGHTING_PLANE
	duration = 12
	pixel_x = -32
	pixel_y = -32

/obj/effect/temp_visual/archous_flash/fading/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/archous_flash/large
	icon = 'code/modules/archonic/icons/160x160.dmi'
	icon_state = "arch_flash"
	duration = 13
	pixel_x = -64
	pixel_y = -64

/obj/effect/temp_visual/archous_flash/large/fading/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/archous_flash/huge
	icon = 'code/modules/archonic/icons/288x288.dmi'
	icon_state = "arch_flash"
	duration = 14
	pixel_x = -128
	pixel_y = -128

/obj/effect/temp_visual/archous_flash/huge/fading/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/atom/movable/screen/fullscreen/archous_flash
	icon = 'code/modules/archonic/icons/fullscreen.dmi'
	icon_state = "archonic_flash"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/mob/living/proc/archonic_flash(type = /atom/movable/screen/fullscreen/archous_flash)
	overlay_fullscreen("archous", type)
	addtimer(CALLBACK(src, PROC_REF(clear_fullscreen), "archous", 25), 25)
	return TRUE


/*
///////////////////////////Archonic Runes///////////////////////////
*/

/obj/effect/overa_rune
	name = "rune"
	var/overist_name = "basic rune"
	desc = "An odd collection of symbols written with an odd glowing substance."
	var/overist_desc = "a basic rune with no function." //This is shown to cultists who examine the rune in order to determine its true purpose.
	anchored = TRUE
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	color = "#E6005C"

	var/invocation = "Aiy ele-mayo!" //This is said by cultists when the rune is invoked.

	var/scribe_delay = 40 //how long the rune takes to create
	var/invoke_damage = 0 //how much damage invokers take when invoking it
	var/archonic = FALSE //Do an archonic check instead of overist check

	var/req_keyword = 0 //If the rune requires a keyword - go figure amirite
	var/keyword //The actual keyword for the rune

/obj/effect/overa_rune/Initialize(mapload, set_keyword)
	. = ..()
	if(set_keyword)
		keyword = set_keyword

/obj/effect/overa_rune/examine(mob/user)
	. = ..()
	if(archonic)
		if(ArchonicCheck(user) || user.stat == DEAD)
			. += "<b>Name:</b> [overist_name]\n"+\
			"<b>Effects:</b> [capitalize(overist_desc)]"
			if(req_keyword && keyword)
				. += "<b>Keyword:</b> [keyword]"
			return
	if(OveristCheck(user) || user.stat == DEAD) //Overists see all
		. += "<b>Name:</b> [overist_name]\n"+\
		"<b>Effects:</b> [capitalize(overist_desc)]"
		if(req_keyword && keyword)
			. += "<b>Keyword:</b> [keyword]"

/obj/effect/overa_rune/attackby(obj/I, mob/user, params)
	if(archonic)
		if(istype(I, /obj/item/archonic/interface_system/) && ArchonicCheck(user))
			SEND_SOUND(user,'sound/items/sheath.ogg')
			if(do_after(user, 15, target = src))
				to_chat(user, "<span class='notice'>You carefully erase the [lowertext(overist_name)] rune.</span>")
				qdel(src)

/obj/effect/overa_rune/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(archonic)
		if(!ArchonicCheck(user))
			to_chat(user, "<span class='warning'>You aren't able to understand the words of [src].</span>")
			return
	else
		if(!OveristCheck(user))
			to_chat(user, "<span class='warning'>You aren't able to understand the words of [src].</span>")
			return
	invoke(user)

/obj/effect/overa_rune/proc/OveristCheck(mob/invoker)
	if(HAS_TRAIT(invoker, TRAIT_ABDUCTOR_SCIENTIST_TRAINING))
		return TRUE
	if(istype(invoker) && invoker.mind && HAS_TRAIT(invoker.mind, TRAIT_ABDUCTOR_SCIENTIST_TRAINING))
		return TRUE
	return FALSE

/obj/effect/overa_rune/proc/ArchonicCheck(mob/invoker)
	if(HAS_TRAIT(invoker, TRAIT_ABDUCTOR_TRAINING))
		return TRUE
	if(istype(invoker) && invoker.mind && HAS_TRAIT(invoker.mind, TRAIT_ABDUCTOR_TRAINING))
		return TRUE
	return FALSE

/obj/effect/overa_rune/proc/invoke(invoker)
	if(isliving(invoker))
		var/mob/living/L = invoker
		if(invocation)
			L.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "rune invocation")
		if(invoke_damage)
			L.apply_damage(invoke_damage, BRUTE)
			to_chat(L, "<span class='revenwarning'>[src] saps your strength!</span>")
	do_invoke_glow()

/obj/effect/overa_rune/proc/do_invoke_glow()
	set waitfor = FALSE
	animate(src, transform = matrix()*2, alpha = 0, time = 5, flags = ANIMATION_END_NOW) //fade out
	sleep(5)
	animate(src, transform = matrix(), alpha = 255, time = 0, flags = ANIMATION_END_NOW)


/obj/effect/overa_rune/silence
	desc = "A massive arrangement of symbols and lines painted in a brilliant glowing substance."
	overist_name = "Principle of Silence"
	overist_desc = "a grand overic rune that increases the PIC to immense levels, preventing the use of any phasic tethers or bioresonant capacities."
	invocation = "Principium Silentii Overa!"
	icon = 'icons/effects/224x224.dmi'
	icon_state = "huge_rune"
	pixel_x = -96
	pixel_y = -96
	color = "#C1FDFD"
	var/active_color = "#D3FFBE"
	var/critical_color = "#33FF33"
	var/used_color = "#a1d6c5"
	scribe_delay = 500
	var/used = FALSE

/obj/effect/overa_rune/silence/invoke(invoker)
	if(used)
		return
	used = TRUE
	visible_message("<span class='nicegreen'><span class='command_headset'>[src] crackles with bolts of green lightning!</span></span>")
	animate(src, color = active_color, time = 200)
	sleep(200)
	new /obj/effect/temp_visual/silence_lightning(get_turf(src))
	visible_message("<span class='revendanger'><span class='nicegreen'>The green lightning coalesces in the center of the rune.</span></span>")
	animate(src, color = critical_color, time = 15)
	sleep(15)
	visible_message("<span class='revendanger'><span class='nicegreen'>An impossibly bright green light emanates from [src].</span></span>")
	for(var/mob/living/witnesses in viewers(9, src))
		if(witnesses.flash_act(intensity = 4, override_blindness_check = 1, affect_silicon = 1))
			witnesses.Paralyze(5)
			witnesses.Knockdown(60)
			if(iscarbon(witnesses))
				var/mob/living/carbon/C = witnesses
				C.adjust_blurriness(10)
				C.confused += 15
				C.adjustStaminaLoss(40)
	sleep(5)
	for(var/mob/M in GLOB.player_list)
		if(M.virtual_z() == virtual_z())
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				C.apply_effect(50, EFFECT_UNCONSCIOUS)
				C.confused += 20
				C.dizziness += 10
				C.drowsyness += 20
			SEND_SOUND(M, 'sound/magic/clockwork/narsie_attack.ogg')
			to_chat(M, "<span class='narsiesmall'><span class='nicegreen'>A pale green light overtakes your vision and your mind. Your mind feels light and your thoughts feel heavy.</span></span>")
			ADD_TRAIT(M, TRAIT_ANTIMAGIC, "Principle of Silence")
	sleep(15)
	animate(src, color = active_color, time = 40)
	sleep(40)
	animate(src, color = used_color, time = 300)

/obj/effect/overa_rune/silence/examine(mob/user)
	. = ..()
	if(used)
		. += "The glowing runes have dimmed to a low and flickering candlelight."

/obj/effect/overa_rune/silence/archonic
	archonic = TRUE

/*
////////////////////////////Sound Loops////////////////////////////
*/

/datum/looping_sound/cythrx/crystal_ambient
	mid_sounds = list('sound/machines/sm/supermatter1.ogg'=1)
	mid_length = 1.8 SECONDS
	volume = 1
	falloff_exponent = 20

/datum/looping_sound/cythrx/crystal_active
	mid_sounds = list('sound/machines/sm/supermatter1.ogg'=1)
	mid_length = 1.8 SECONDS
	//mid_sounds = list('sound/ambience/ambisin4.ogg'=1)
	//mid_length = 14.3 SECONDS
	volume = 20
	extra_range = 25
	falloff_exponent = 10
	falloff_distance = 2

/datum/looping_sound/cythrx/crystal_active_1
	mid_sounds = list('sound/machines/sm/supermatter1.ogg'=1)
	mid_length = 1.8 SECONDS
	//mid_sounds = list('sound/ambience/ambisin4.ogg'=1)
	//mid_length = 14.3 SECONDS
	volume = 40
	extra_range = 25
	falloff_exponent = 9
	falloff_distance = 4

/datum/looping_sound/cythrx/crystal_active_2
	mid_sounds = list('sound/machines/sm/supermatter2.ogg'=1)
	mid_length = 1.8 SECONDS
	//mid_sounds = list('sound/ambience/ambisin2.ogg'=1)
	//mid_length = 11.8 SECONDS
	volume = 50
	extra_range = 35
	falloff_exponent = 6
	falloff_distance = 7

/datum/looping_sound/cythrx/crystal_active_3
	mid_sounds = list('sound/machines/sm/supermatter2.ogg'=1)
	mid_length = 1.8 SECONDS
	//mid_sounds = list('sound/ambience/ambisin2.ogg'=1)
	//mid_length = 11.8 SECONDS
	volume = 60
	extra_range = 35
	falloff_exponent = 3
	falloff_distance = 10

/datum/looping_sound/cythrx/storm
	mid_sounds = list(
		'sound/weather/ashstorm/outside/weak_mid1.ogg'=1,
		'sound/weather/ashstorm/outside/weak_mid2.ogg'=1,
		'sound/weather/ashstorm/outside/weak_mid3.ogg'=1
		)
	mid_length = 80
	start_sound = 'sound/weather/ashstorm/outside/weak_start.ogg'
	start_length = 130
	end_sound = 'sound/weather/ashstorm/outside/weak_end.ogg'
	volume = 50

/*
//////////////////////////////Weather//////////////////////////////
*/
/*
/datum/weather/cythrx
	name = "cythrx's silence"
	desc = "..."

	telegraph_message = "<span class='revenboldnotice'>You feel a chill in the air as a wind picks up...</span>"
	telegraph_duration = 150

	weather_message = "<span class='revenbignotice'><i>A freezing and rapid wind picks up, nearly blowing you off your feet.</i></span>"
	weather_overlay = "dust"
	weather_duration_lower = 16000
	weather_duration_upper = 16000

	end_duration = 100
	end_message ="<span class='notice'>The storm dissipates.</span>"
	end_overlay = "dust"

	area_type = /area
	protect_indoors = TRUE

	immunity_type = "none"

	sound_active_outside = /datum/looping_sound/cythrx/storm
	sound_active_inside = /datum/looping_sound/weather/wind

	multiply_blend_on_main_stage = TRUE

/datum/weather/shroud_storm/weather_act(mob/living/living_mob)
	/// Think of some good solution of how weather should affect monsters and how they should be resistant to things like this
	if(isanimal(living_mob))
		return
	living_mob.adjust_bodytemperature(-rand(2,4))
*/

/*
//////////////////////////////Spells//////////////////////////////
*/
/obj/effect/proc_holder/spell/self/archonic/heal
	name = "Aluria's Restoration"
	desc = "Seal your doors and bathe in the Violet Light."
	invocation = "Hyacinthum vita"
	charge_max = 600
	invocation_type = INVOCATION_WHISPER
	human_req = TRUE
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/actions_revenant.dmi'
	action_icon_state = "blight"
	action_background_icon_state = "bg_hive"

/obj/effect/proc_holder/spell/self/archonic/heal/cast(list/targets, mob/living/carbon/human/user)
	user.visible_message("<span class='revenwarning'>[user]'s body is wrapped in violet light as their wounds shut closed and flesh revives</span>", "<span class='revenminor'>Your wounds are closed as violet light blankets you.</span>")
	user.regenerate_organs()
	user.restore_blood()
	user.adjustBruteLoss(-100)
	user.adjustFireLoss(-100)
	user.updatehealth()

/obj/effect/proc_holder/spell/self/flight
	name = "Toggle Levitation"
	desc = "Toggles your Levitation."
	charge_max = 20
	human_req = TRUE
	clothes_req = FALSE
	action_icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	action_icon_state = "flightpack_fly"

/obj/effect/proc_holder/spell/self/flight/cast(list/targets, mob/living/carbon/human/user)
	if(!(user.movement_type & FLYING))
		user.setMovetype(user.movement_type | FLYING)
		user.setMovetype(user.movement_type | FLOATING)
		user.float(TRUE)
		user.visible_message("<span class='warning'>[user] slowly lifts off the ground.</span>", "<span class='notice'>You channel power to your legs, and slowly levitate off the ground.</span>")

	else
		user.setMovetype(user.movement_type & ~FLYING)
		user.setMovetype(user.movement_type & ~FLOATING)
		user.float(FALSE)
		user.visible_message("<span class='warning'>[user] slowly falls back to the ground.</span>", "<span class='notice'>You dispell your levitation, and slowly drift back to the ground.</span>")

/obj/effect/proc_holder/spell/self/flight/archonic
	action_background_icon_state = "bg_hive"

/obj/effect/proc_holder/spell/targeted/infinite_guns/arcane_barrage/archonic //Archonic Barrage
	name = "Archonic Barrage"
	desc = "Light comes undone, all will be onto Archous"
	charge_max = 10
	cooldown_min = 10
	summon_path = /obj/item/gun/ballistic/rifle/illestren/enchanted/arcane_barrage/archonic
	action_background_icon_state = "bg_hive"

/obj/item/gun/ballistic/rifle/illestren/enchanted/arcane_barrage/archonic
	name = "archonic barrage"
	desc = "Glory to Archous."
	guns_left = 100
	recoil = -0.1
	recoil_unwielded = -0.1
	spread_unwielded = 0
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/enchanted/arcane_barrage/archonic
	has_safety = FALSE
	safety = FALSE

/obj/item/ammo_box/magazine/internal/boltaction/enchanted/arcane_barrage/archonic
	ammo_type = /obj/item/ammo_casing/magic/arcane_barrage/archonic

/obj/item/ammo_casing/magic/arcane_barrage/archonic
	projectile_type = /obj/projectile/magic/arcane_barrage/archonic

/obj/projectile/magic/arcane_barrage/archonic
	name = "archonic bolt"
	damage = 40
	armour_penetration = 30

/obj/effect/proc_holder/spell/targeted/infinite_guns/arcane_barrage/archonic/sparkstorm //Sparkstorm
	name = "Archonic Sparkstorm"
	desc = "Open an archonic gateway in your hands, bring forth Archous's Will"
	charge_max = 600
	cooldown_min = 600
	summon_path = /obj/item/gun/magic/wand/archonicspark
	action_icon = 'icons/effects/effects.dmi'
	action_icon_state = "plasmasoul"
	action_background_icon_state = "bg_hive"

/obj/item/gun/magic/wand/archonicspark
	name = "archonic sparkstorm"
	desc = "They will dance in blindness"
	fire_sound = 'sound/weapons/emitter.ogg'
	icon = 'icons/obj/guns/projectile.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "arcane_barrage"
	item_state = "arcane_barrage"
	slot_flags = null
	item_flags = NEEDS_PERMIT | DROPDEL | ABSTRACT | NOBLUDGEON
	flags_1 = NONE
	can_charge = FALSE
	max_charges = 200
	variable_charges = FALSE
	ammo_type = /obj/item/ammo_casing/magic/archonicspark


/obj/item/gun/magic/wand/archonicspark/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.10 SECONDS)

/obj/item/ammo_casing/magic/archonicspark
	projectile_type = /obj/projectile/magic/arcane_barrage/archonic/spark

/obj/projectile/magic/arcane_barrage/archonic/spark
	name = "archonic spark"
	damage = 20

/obj/effect/proc_holder/spell/aoe_turf/knock/archonic //Violet Entry
	name = "Violet Entry"
	desc = "The Knock is the principle that opens doors and unseams barriers."
	invocation = "IANTHINIS"
	charge_max = 1
	range = 1
	action_background_icon_state = "bg_alien"
	action_icon_state = "rekindling"

/obj/effect/proc_holder/spell/targeted/summonitem/archonic //Archonic Return
	name = "Archonic Return"
	charge_max = 1
	invocation = "UT ERIT"
	cooldown_min = 1
	action_background_icon_state = "bg_hive"
	action_icon = 'icons/mob/actions/actions_elites.dmi'
	action_icon_state = "pandora_teleport"

/*
/////////////////////////////Implants/////////////////////////////
*/

/obj/item/implant/archonic
	name = "archonic crystal"
	desc = "Grants Archonic Entry."
	activated = FALSE

/obj/item/implant/spell/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if (.)
		ADD_TRAIT(target, TRAIT_ABDUCTOR_TRAINING, "implant")

/obj/item/implant/spell/removed(mob/target, silent = FALSE, special = 0)
	. = ..()
	if (.)
		REMOVE_TRAIT(target, TRAIT_ABDUCTOR_TRAINING, "implant")

/obj/item/implant/archonic/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> UNKNOWN<BR>
				<b>Life:</b> UNKNOWN<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> UNKNOWN." : "None"]"}
	return dat

/obj/item/implant/spell/archonic
	name = "archonic crystal"
	desc = "Grants one of the violet magics."

/obj/item/implant/spell/archonic/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> UNKNOWN<BR>
				<b>Life:</b> UNKNOWN<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> UNKNOWN." : "None"]"}
	return dat

/obj/item/implant/spell/archonic/knock
	spell = /obj/effect/proc_holder/spell/aoe_turf/knock/archonic

/obj/item/implant/spell/archonic/summonitem
	spell = /obj/effect/proc_holder/spell/targeted/summonitem/archonic

/obj/item/implant/spell/archonic/barrage
	spell = /obj/effect/proc_holder/spell/targeted/infinite_guns/arcane_barrage/archonic

/obj/item/implant/spell/archonic/sparkstorm
	spell = /obj/effect/proc_holder/spell/targeted/infinite_guns/arcane_barrage/archonic/sparkstorm

/obj/item/implant/spell/archonic/heal
	spell = /obj/effect/proc_holder/spell/self/archonic/heal

/obj/item/implant/spell/archonic/flight
	spell = /obj/effect/proc_holder/spell/self/flight/archonic

/obj/item/implant/archonic_storage
	name = "archonic crystal"
	desc = "Grants one of the violet magics."
	icon_state = "storage"
	implant_color = "r"

/obj/item/implant/archonic_storage/activate()
	. = ..()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_SHOW, imp_in, TRUE)

/obj/item/implant/archonic_storage/removed(source, silent = FALSE, special = 0)
	if(!special)
		var/datum/component/storage/lostimplant = GetComponent(/datum/component/storage/concrete/implant)
		var/mob/living/implantee = source
		for (var/obj/item/I in lostimplant.contents())
			I.add_mob_blood(implantee)
		lostimplant.do_quick_empty()
		implantee.visible_message("<span class='revenwarning'>A violetspace pocket opens around [src] as it exits [implantee], spewing out its contents and rupturing the surrounding tissue!</span>")
		implantee.apply_damage(90, BRUTE, BODY_ZONE_CHEST)
		qdel(lostimplant)
	return ..()

/obj/item/implant/archonic_storage/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	for(var/X in target.implants)
		if(istype(X, type))
			var/obj/item/implant/storage/imp_e = X
			var/datum/component/storage/STR = imp_e.GetComponent(/datum/component/storage)
			if(!STR || (STR && STR.max_items))
				imp_e.AddComponent(/datum/component/storage/concrete/implant/archonic)
				qdel(src)
				return TRUE
			return FALSE
	AddComponent(/datum/component/storage/concrete/implant/archonic)

	return ..()

/datum/component/storage/concrete/implant/archonic
	max_w_class = WEIGHT_CLASS_HUGE
	max_combined_w_class = 600
	max_items = 50

/*
///////////////////////////Archonic Link///////////////////////////
*/

/obj/structure/fluff/archous
	name = "\proper Archonic Link"
	desc = "<span class='revendanger'>...</span>"
	icon = 'icons/effects/anomalies.dmi'
	icon_state = "plasmasoul"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	deconstructible = FALSE
	verb_say = "hums"
	verb_exclaim = "commands"
	verb_ask = "interrogates"
	verb_whisper = "chimes"
	verb_yell = "shrieks"
	speech_span = list("narsie", "hypnophrase")

/obj/structure/fluff/archous/trace
	name = "\improper Linktrace"
	speech_span = list("hugeicon", "hypnophrase")

#undef INTERFACE_MESSAGE
#undef INTERFACE_CONTROL
#undef INTERFACE_RESTRAIN
#undef SOE_HEALTH_RESTORE
