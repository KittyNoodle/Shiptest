//Regexes used to alter english to overic style
#define OVERIC_ARCHOUS_MATCH regex("(\[aA]\[rR]\[cC]\[hH]\[oO]\[uU]\[sS])","g")
#define OVERIC_ARCHOUS_REPLACEMENT "ꕺ"
#define OVERIC_ARCHONIC_MATCH regex("(\[aA]\[rR]\[cC]\[hH]\[oO]\[nN]\[iI]\[cC])","g")
#define OVERIC_ARCHONIC_REPLACEMENT "ꕻ"
#define OVERIC_NULL_MATCH regex("(\[nN]\[uU]\[lL]\[lL])(\\s)","g")
#define OVERIC_NULL_REPLACEMENT "✺$2"
#define OVERIC_AND_MATCH regex("(\\s)(\[aA]\[nN]\[dD])(\\s)(\\w)","g")
#define OVERIC_AND_REPLACEMENT "⟝⟞$4"
#define OVERIC_CYTHRX_MATCH regex("(\[cC]\[yY]\[tT]\[hH]\[rR]\[xX])","g")
#define OVERIC_CYTHRX_REPLACEMENT "⛬"
#define OVERIC_MY_MATCH regex("(\\b)(\[mM]\[yY])\\s(\\w)","g")
#define OVERIC_MY_REPLACEMENT "$1⟣$3"
#define OVERIC_ME_MATCH regex("(\\b)(\[mM]\[eE])(\\b)","g")
#define OVERIC_ME_REPLACEMENT "⟡"
#define OVERIC_TO_MATCH regex("(\\b)(\[tT]\[oO])\\s(\\w)","g")
#define OVERIC_TO_REPLACEMENT "$1⟥$3"
#define OVERIC_OR_MATCH regex("(\\s)(\[oO]\[rR])(\\s)(\\w)","g")
#define OVERIC_OR_REPLACEMENT "⟗$4"
#define OVERIC_OR_START_MATCH regex("(\\b)(\[oO]\[rR])(\\s)(\\w)","g")
#define OVERIC_OR_START_REPLACEMENT "⟗$4"
#define OVERIC_YOU_MATCH regex("(\\b)(\[yY]\[oO]\[uU])(\\b)","g")
#define OVERIC_YOU_REPLACEMENT "$1⨁$3"
#define OVERIC_THE_MATCH regex("(\\b(\[tT]\[hH]\[eE])\\b)","g")
#define OVERIC_THE_REPLACEMENT "▄█⟫"
#define OVERIC_TH_MATCH regex("(\[tT]\[hH])","g")
#define OVERIC_TH_REPLACEMENT "▂▄▁"
#define OVERIC_LONE_A_MATCH regex("(\\b(\[aA])\\b)","g")
#define OVERIC_LONE_A_REPLACEMENT "❈"
#define OVERIC_LONE_I_MATCH regex("(\\b(\[iI])\\b)","g")
#define OVERIC_LONE_I_REPLACEMENT "⟡"
#define OVERIC_A_MATCH regex("(\[aA])","g")
#define OVERIC_A_REPLACEMENT "▚"
#define OVERIC_E_MATCH regex("(\[eE])","g")
#define OVERIC_E_REPLACEMENT "▟"
#define OVERIC_I_MATCH regex("(\[iI])","g")
#define OVERIC_I_REPLACEMENT "▙"
#define OVERIC_O_MATCH regex("(\[oO])","g")
#define OVERIC_O_REPLACEMENT "▛"
#define OVERIC_U_MATCH regex("(\[uU])","g")
#define OVERIC_U_REPLACEMENT "▜"
#define OVERIC_Y_MATCH regex("(\[yY])","g")
#define OVERIC_Y_REPLACEMENT "▞"
#define OVERIC_POSSESSIVE_MATCH regex("(\\S)(\[']\[sS])(\\b)","g")
#define OVERIC_POSSESSIVE_REPLACEMENT "$1⊷"
#define OVERIC_SPACE_MATCH regex("(\\s)","g")
#define OVERIC_SPACE_REPLACEMENT "╫"
#define OVERIC_WORD_MATCH regex("(\\w)","g")

/proc/text2overic(text) //Takes english and applies overic styling rules.
	var/overic = add_overic_regex(text)
	return add_overic_symbols(overic)

/proc/add_overic_regex(text)
	var/overic = text
	overic 		= replacetext(overic, 	OVERIC_ARCHOUS_MATCH, 		OVERIC_ARCHOUS_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_ARCHONIC_MATCH, 		OVERIC_ARCHONIC_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_NULL_MATCH, 		OVERIC_NULL_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_AND_MATCH, 		OVERIC_AND_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_CYTHRX_MATCH, 		OVERIC_CYTHRX_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_MY_MATCH, 		OVERIC_MY_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_ME_MATCH, 		OVERIC_ME_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_TO_MATCH,		OVERIC_TO_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_OR_MATCH,		OVERIC_OR_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_OR_START_MATCH,		OVERIC_OR_START_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_YOU_MATCH,		OVERIC_YOU_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_THE_MATCH,		OVERIC_THE_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_TH_MATCH,		OVERIC_TH_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_LONE_A_MATCH,		OVERIC_LONE_A_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_LONE_I_MATCH,		OVERIC_LONE_I_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_A_MATCH,		OVERIC_A_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_E_MATCH,		OVERIC_E_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_I_MATCH,		OVERIC_I_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_O_MATCH,		OVERIC_O_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_U_MATCH,		OVERIC_U_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_POSSESSIVE_MATCH, 		OVERIC_POSSESSIVE_REPLACEMENT)
	overic 		= replacetext(overic, 	OVERIC_SPACE_MATCH, 		OVERIC_SPACE_REPLACEMENT)
	return overic


/proc/add_overic_symbols(text)
	. = ""
	text = html_decode(text)
	for(var/idx = 1 to length_char(text))
		var/character = copytext_char(text, idx, idx + 1)
		if(findtext(character, OVERIC_WORD_MATCH))
			character = ""
			character += pick("▒","▒","▒","░","░","▒","▒","█","▁","▂","▃","▃","▄","▄","▅","▅","▅","▆","▆","▆","▇","▇","▇","█","▉","▉")
		. += "[character]"

//pick("▒","░","▒","▚","▞","▙","▛","▜","▟","█","▁","▂","▃","▄","▅","▆","▇","█","▉","▀","▔")
/*
/proc/add_overic_symbols(text)
	. = ""
	to_chat(world, "AOS INPUT: [text]")
	var/letter = ""
	var/lentext = length(text)
	for(var/i = 1 to lentext)
		letter = text[i]
		if(findtext(letter, OVERIC_WORD_MATCH))
			letter = ""
			letter += pick("▒","░","▒","▖","▗","▘","▝","▚","▞","▙","▛","▜","▟","█","▁","▃","▅","▇","█","▉","▊","▌","▏","▐","▀","⬤")
		else if(findtext(letter, regex("(�)","g")))
			letter = ""
		. += letter
	to_chat(world, "AOS OUTPUT: [.]")
	return .
*/

