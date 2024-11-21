/obj/effect/proc_holder/spell/whisper_word
	name = "Whisper Word"
	desc = "Speak the words that carry will indomitable."
	charge_max = 30 //variable
	cooldown_min = 0
	level_max = 1
	clothes_req = FALSE
	antimagic_allowed = TRUE
	action_icon = 'icons/mob/actions/actions_items.dmi'
	action_icon_state = "voice_of_god"
	var/command
	var/order = 1
	var/list/spans = list("anomaly")

/obj/effect/proc_holder/spell/whisper_word/can_cast(mob/user = usr)
	if(!user.can_speak())
		to_chat(user, "<span class='warning'>You are unable to speak!</span>")
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/whisper_word/choose_targets(mob/user = usr)
	perform(user=user)

/obj/effect/proc_holder/spell/whisper_word/perform(list/targets, recharge = 1, mob/user = usr)
	command = input(user, "Speak with the truest words.", "Will")
	if(QDELETED(src) || QDELETED(user))
		return
	if(!command)
		revert_cast(user)
		return
	..()

/obj/effect/proc_holder/spell/whisper_word/cast(list/targets, mob/user = usr)
	whisper_word(command, order, user, spans)

/proc/whisper_word(message, order = 1, mob/living/user, list/span_list, include_speaker = FALSE)
	if(!user || !user.can_speak() || user.stat)
		return

	if(!span_list || !span_list.len)
		span_list = list()

	user.say(message, spans = span_list, sanitize = FALSE, language = /datum/language/anomalist, forced = TRUE)

	var/list/mob/living/listeners = list()
	for(var/mob/living/L in get_hearers_in_view(8, user))
		if(L.stat != DEAD)
			if(L == user && !include_speaker)
				continue
			listeners += L

	if(!listeners.len)
		return

	for(var/V in listeners)
		var/mob/living/L = V
		switch(order)
			if(1)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
						to_chat(L, "<span class='anomaly'>You see shapes dance across [user]'s lips, powerful shapes.</span>")
						to_chat(L, "<span class='command_headset'><span class='anomaly'>[message]</span></span>")
						to_chat(L, "<span class='bolddanger'><span class='anomaly'>Your body shakes as it seeks to follow.</span></span>")
						to_chat(L, "<span class='warning'>Pushing through is like running a marathon through a hurricane force hailstorm, every act against the will aches as your muscles spasm against you. <span class='bolditalic'>Just... keep... pushing...</span></span>")
						return
				if(!(L.can_hear()))
					to_chat(L, "<span class='anomaly'>You see shapes dance across [user]'s lips, powerful shapes.</span>")
					to_chat(L, "<span class='command_headset'><span class='anomaly'>[message]</span></span>")
					to_chat(L, "<span class='bolddanger'><span class='anomaly'>Your body shakes as it seeks to follow.</span></span>")
					to_chat(L, "<span class='warning'>Pushing through is like running a marathon through a hurricane force hailstorm, every act against the will aches as your muscles spasm against you. <span class='bolditalic'>Just... keep... pushing...</span></span>")
					return
				to_chat(L, "<span class='narsiesmall'><span class='anomaly'>[message]</span></span>")
				to_chat(L, "<span class='userdanger'><span class='anomaly'>Your body moves without your mind, your mind moves without your soul.</span></span>")
				to_chat(L, "<span class='warning'>The strongest of wills could muster not a second. You are not the soverign of your body.</span>")
			if(2)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
						to_chat(L, "<span class='smallnotice'><span class='anomaly'>[message]</span></span>")
						to_chat(L, "<span class='smallnotice'><span class='anomaly'>Your body shivers as it yearns to follow.</span></span>")
						to_chat(L, "<span class='smallnotice'><span class='warning'>Just focus on not doing it, don't lose focus.</span></span>")
						return
				if(!(L.can_hear()))
					to_chat(L, "<span class='smallnotice'><span class='anomaly'>You see shapes dance across [user]'s lips.</span></span>")
					to_chat(L, "<span class='anomaly'>[message]</span></span>")
					to_chat(L, "<span class='smallnotice'><span class='anomaly'>Your body shivers as it yearns to follow.</span></span>")
					to_chat(L, "<span class='smallnotice'><span class='warning'>Just focus on not doing it, don't lose focus.</span></span>")
					return
				to_chat(L, "<span class='colossus'><span class='anomaly'>[message]</span></span>")
				to_chat(L, "<span class='userdanger'><span class='anomaly'>Your body bends instantly to the words, they are true, eternal, powerful.</span></span>")
				to_chat(L, "<span class='warning'>Gaining control is like opening a jammed doorknob thats covered in flaming oil while you have clammy and cut up hands. It will take incredible, constant, unceasing effort, and every second you try it gets harder, only the strongest could possibly stand a chance. <span class='bolditalic'>It might be possible...</span></span>")
			if(3)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
						to_chat(L, "<span class='anomaly'><span class='italics'>You feel odd as you watch [user]'s lips move.</span></span></span>")
						return
				if(!(L.can_hear()))
					to_chat(L, "<span class='anomaly'><span class='italics'>You feel odd as you watch [user]'s lips move.</span></span></span>")
					return
				to_chat(L, "<span class='cultlarge'><span class='anomaly'>[message]</span></span>")
				to_chat(L, "<span class='bolddanger'><span class='anomaly'>Your body bends to the words.</span></span>")
				to_chat(L, "<span class='warning'>It's like trying to push two neodymium magnets together from the wrong end, while someone is stabbing you in the leg, in a tornado. Every thought against the will is agony. <span class='bolditalic'>You just need to get them to touch... just... for a little bit...</span></span>")
			if(4)
				to_chat(L, "<span class='command_headset'><span class='anomaly'>[message]</span></span>")
				to_chat(L, "<span class='bolddanger'><span class='anomaly'>Your body shakes as it moves to follow.</span></span>")
				to_chat(L, "<span class='warning'>Pushing through is like running a marathon through a hurricane force windstorm, every act against the will aches as your muscles spasm against you. <span class='bolditalic'>Just... keep... pushing...</span></span>")
			if(5)
				to_chat(L, "<span class='anomaly'>[message]</span></span>")
				to_chat(L, "<span class='smallnotice'><span class='anomaly'>Your body shivers as it yearns to follow.</span></span>")
				to_chat(L, "<span class='smallnotice'><span class='warning'>Just focus on not doing it, don't lose focus.</span></span>")
			if(6)
				message = lowertext(message)
				to_chat(L, "<span class='small'><span class='anomaly'>...<span class='italics'>[message]</span>...</span></span>")

/datum/language/anomalist
	name = "Anomalist"
	desc = "Only comprehended in short burts of willpower even by the greatest scholars, these words seem to carry imparted power within them."
	spans = list("anomaly")
	key = "<"
	default_priority = 100 //speak only in perfect words.
	flags = TONGUELESS_SPEECH|LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD|NO_STUTTER
	space_chance = 40
	sentence_chance = 0
	syllables = list(
		"til", "'isk'", "aska", "iet", "ice", "tlk", "kal", "ug", "ker", "vosk", "lix", "tsk",
		"l't", "axx", "r'let", "gix", "uic", "ihk", "hok", "ohk", "hult", "ux", "hts", "shl",
		"lat", "skal", "ler", "xel", "lin", "nil", "lor", "eol", "lun", "ul", "ls", "sl",
		"ka", "ak", "ke", "ek", "ki", "ik", "ko", "ok", "ku", "uk", "ks", "sk",
		"a",  "a",  "e",  "e",  "i",  "i",  "o",  "o",  "u",  "u",  "s",  "s"
	)

/datum/language_holder/anomalist
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/anomalist = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/anomalist = list(LANGUAGE_ATOM))

/obj/effect/proc_holder/spell/whisper_word/two
	name = "Second-Order Whisper Word"
	desc = "Speak the words that carry will indomitable."
	order = 2

/obj/effect/proc_holder/spell/whisper_word/three
	name = "Third-Order Whisper Word"
	desc = "Speak the words that carry will indomitable."
	order = 3

/obj/effect/proc_holder/spell/whisper_word/four
	name = "Fourth-Order Whisper Word"
	desc = "Speak the words that carry will indomitable."
	order = 4

/obj/effect/proc_holder/spell/whisper_word/five
	name = "Fifth-Order Whisper Word"
	desc = "Speak the words that carry will indomitable."
	order = 5

/obj/effect/proc_holder/spell/whisper_word/six
	name = "Sixth-Order Whisper Word"
	desc = "Speak the words that carry will indomitable."
	order = 6
