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
	spans = list("resonate","memoedit")
	icon_state = "ratvar"

/datum/language/overic/scramble(input)
	. = text2overic(input)

/datum/language_holder/overic
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/overic = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/overic = list(LANGUAGE_ATOM))
