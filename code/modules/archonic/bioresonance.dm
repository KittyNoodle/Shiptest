/obj/effect/proc_holder/spell/self/flight/bioresonance
	action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/spell/self/bioresonance/heal
	name = "Restore Vitality"
	desc = "Force your wounds to knit shut and your body to reform."
	human_req = TRUE
	clothes_req = FALSE
	charge_max = 400
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


/obj/effect/proc_holder/spell/self/bioresonance/grant_all
	name = "Transcend"
	desc = "Dream the reality around you, bend it to your will."
	action_background_icon_state = "bg_alien"
	clothes_req = FALSE

/obj/effect/proc_holder/spell/self/bioresonance/grant_all/cast(list/targets, mob/living/carbon/human/user)
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
