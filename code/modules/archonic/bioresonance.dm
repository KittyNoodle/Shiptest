//Vulgar Bioresonance//

/obj/effect/proc_holder/spell/self/flight/bioresonance
	action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/spell/self/bioresonance/heal
	name = "Restore Vitality"
	desc = "Force your wounds to knit shut and your body to reform."
	human_req = TRUE
	clothes_req = FALSE
	charge_max = 600
	invocation_type = "none"
	sound = 'sound/magic/demon_consume.ogg'
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "regenerate"
	action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/spell/self/bioresonance/heal/cast(list/targets, mob/living/carbon/human/user)
	user.visible_message("<span class='abductor'>[user]'s body twitches as their wounds knit and their flesh regenerates!</span>", "<span class='mind_control'>You will your wounds to shut and your body to reform.</span>")
	user.regenerate_limbs(1)
	user.regenerate_organs()
	user.restore_blood()
	user.adjustBruteLoss(-60)
	user.adjustFireLoss(-60)
	user.updatehealth()


/obj/effect/proc_holder/spell/self/bioresonance/grant_all/vulgar
	name = "Transcend"
	desc = "Dream the reality around you, bend it to your will."
	action_background_icon_state = "bg_alien"
	clothes_req = FALSE

/obj/effect/proc_holder/spell/self/bioresonance/grant_all/vulgar/cast(list/targets, mob/living/carbon/human/user)
	var/obj/effect/proc_holder/spell/S1 = new /obj/effect/proc_holder/spell/voice_of_god/bioresonance
	var/obj/effect/proc_holder/spell/S2 = new /obj/effect/proc_holder/spell/self/bioresonance/heal
	var/obj/effect/proc_holder/spell/S3 = new /obj/effect/proc_holder/spell/self/flight/bioresonance
	user.mind.AddSpell(S1)
	user.mind.AddSpell(S2)
	user.mind.AddSpell(S3)
	qdel(src)

/obj/effect/proc_holder/spell/voice_of_god/bioresonance //Bioresonance
	name = "Bioresonant Command"
	desc = "Speak with an incredibly compelling voice, forcing listeners to obey your commands."
	spans = list("hypnophrase","big")
	power_mod = 0.9
	cooldown_mod = 0.7
	speech_sound = 'sound/magic/mandswap.ogg'
	action_icon = 'icons/mob/actions/actions_borer.dmi'
	action_icon_state = "borer_whisper"
	action_background_icon_state = "bg_alien"
	antimagic_allowed = FALSE

//Principled Bioresonance//

//Principled bioresonance (alongside all other anomalistic influences) follows an order system. A first order is something comparable to godhood, while an eigth order is a cantrip.

//Recalibration: Healing

//Conviction: Armor

//Transis// Created by accelerating your mind and editing your body to match its movements.

/datum/movespeed_modifier/transis_crystal
	multiplicative_slowdown = -0.65

/datum/movespeed_modifier/transis_8
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/transis_7
	multiplicative_slowdown = -0.75

/datum/movespeed_modifier/transis_6
	multiplicative_slowdown = -1

/datum/movespeed_modifier/transis_5
	multiplicative_slowdown = -1.6

/datum/movespeed_modifier/transis_4
	multiplicative_slowdown = -2.1

/obj/effect/proc_holder/spell/self/bioresonance/transis/aimtiacrystal
	name = "Transis"
	desc = "Ignite the wires under your skin and unify your thought and movement."
	invocation = null
	charge_max = 600
	invocation_type = "none"
	human_req = TRUE
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/actions_revenant.dmi'
	action_icon_state = "blight"
	action_background_icon_state = "bg_hive"

#define TRANSIS_ATTACK_SPEED_MODIFIER 0.20

/obj/effect/transis
	name = "decaying state"
	desc = "..."
	anchored = 1

/obj/effect/transis/Initialize()
	. = ..()
	spawn(0.5 SECONDS)
		qdel(src)

/mob/living/carbon
	var/transis_effect = FALSE

/mob/living/carbon/human/Move(atom/newloc, direct, glide_size_override)
	..()
	if(transis_effect)
		var/obj/effect/transis/C = new(loc)
		C.name = name
		C.appearance = appearance
		C.dir = dir
		C.color = "#ff5df1"
		animate(C, pixel_x = rand(-16, 16), pixel_y = rand(-16, 16), color = "#d6b10e", time = 5)

/obj/effect/proc_holder/spell/self/bioresonance/transis/aimtiacrystal/cast(list/targets, mob/living/carbon/human/user)
	user.visible_message("<span class='abductor'>A pink and gold veinlike structure inside [user] lights up brilliantly under their skin.</span>")
	user.add_movespeed_modifier(/datum/movespeed_modifier/transis_crystal)
	ADD_TRAIT(user, TRAIT_STRONG_GRABBER, "transis")
	user.next_move_modifier *= TRANSIS_ATTACK_SPEED_MODIFIER
	user.transis_effect = TRUE
	spawn(22.5 SECONDS)
		if(user)
			user.visible_message("<span class='abductor'>The pink and gold veinlike structure inside [user] dims into invisibility.</span>")
			user.remove_movespeed_modifier(/datum/movespeed_modifier/transis_crystal)
			user.transis_effect = FALSE
			REMOVE_TRAIT(user, TRAIT_STRONG_GRABBER, "transis")
			user.next_move_modifier /= TRANSIS_ATTACK_SPEED_MODIFIER
