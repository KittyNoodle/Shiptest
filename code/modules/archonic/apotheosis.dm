/obj/proc/apoth_delete()
	color = "#ffffff"
	AddElement(/datum/element/decal/apoth_delete, initial(icon) || icon, initial(icon_state) || icon_state)
	add_filter("extract_outline", 1, outline_filter(size = 1, color = "#ff0000"))
	QDEL_IN(src, 0.6 SECONDS)

/mob/proc/apoth_delete()
	color = "#ffffff"
	AddElement(/datum/element/decal/apoth_delete, initial(icon) || icon, initial(icon_state) || icon_state)
	add_filter("extract_outline", 1, outline_filter(size = 1, color = "#ff0000"))
	QDEL_IN(src, 0.6 SECONDS)

/datum/element/decal/apoth_delete

/datum/element/decal/apoth_delete/Attach(datum/target, _icon, _icon_state, _dir, _cleanable=FALSE, _layer=HIGH_OBJ_LAYER) //was at ABOVE_OBJ_LAYER orignally
	. = ..()

/datum/element/decal/apoth_delete/generate_appearance(_icon, _icon_state, _dir, _layer, _alpha, source)
	if(!_icon || !_icon_state)
		return FALSE
	var/icon/black_texture = icon(_icon, _icon_state, , 1)		//we only want to apply black overlay to the initial icon_state for each object
	black_texture.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
	black_texture.Blend(icon('code/modules/archonic/icons/288x288.dmi', "nothing"), ICON_MULTIPLY) //adds overlay and the remaining white areas become transparant
	pic = mutable_appearance(black_texture)
	return TRUE

/obj/item/apoth_deleter
	desc = "A strange baton-like object with a hole in reality jutting out of it. You really should avoid touching it."
	name = "\improper P-PDS-093 'Banhammer'"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "apoth_deleter"
	item_state = "apoth_deleter"
	mob_overlay_icon = "none"
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	block_chance = 120
	attack_verb = list("deleted")
	max_integrity = 2000
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	var/stored_user

/obj/item/apoth_deleter/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(prob(final_block_chance))
		owner.visible_message("<span class='danger'>[owner] absorbs [attack_text] with [src]!</span>")
		playsound(src, 'sound/weapons/effects/deflect.ogg', 100, TRUE)
		return TRUE
	return FALSE

/obj/item/apoth_deleter/proc/check_user(user)
	if(user == stored_user)
		return TRUE
	to_chat(user, "<span class='warning'>INVALID USER</span>")

/obj/item/apoth_deleter/attack_self(mob/living/user)
	if(!stored_user)
		to_chat(user,"<span class='warning'>USER KEY SET: [user]</span>")
		stored_user = user
		return
	if(!check_user(user))
		return
	to_chat(user, "<span class='warning'>USER KEY ALREADY SET</span>")

/obj/item/apoth_deleter/attack(mob/target, mob/living/user)
	if(!check_user(user))
		return FALSE
	if(target == user)
		return FALSE
	user.do_attack_animation(target)
	target.apoth_delete()
	target.visible_message("<span class='adminhelp'>[user] deletes [target] with the [src]!</span>", \
							"<span class='adminhelp'><span class='extremelybig'>You feel a sudden numbness as you are ripped out of reality.</span></span>")

/obj/item/apoth_deleter/attack_obj(obj/O, mob/living/user)
	if(!check_user(user))
		return FALSE
	if(O == src)
		return
	user.do_attack_animation(O)
	user.visible_message("<span class='adminhelp'>[user] deletes [O] with the [src]!</span>", \
							"<span class='adminhelp'>You delete [O] with the [src]!</span>")
	O.apoth_delete()

/area/ruin/space/has_grav/singularitylab/command
	name = "Command Center"
	icon_state = "blue"

/datum/controller/subsystem/overmap/proc/empty_space()
	for(var/datum/overmap/O as anything in overmap_objects)
		if(!istype(O, /datum/overmap/ship))
			qdel(O)
