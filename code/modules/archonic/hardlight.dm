/obj/effect/proc_holder/spell/targeted/conjure_item/hardlight_spear
	name = "Hardlight Spear"
	desc = "Summon a spear of light to strike down your foes."
	button_icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	button_icon_state = "lightspear"
	sound = 'sound/weapons/saberon.ogg'

	charge_max = 20 SECONDS
	cooldown_min = 20 SECONDS
	invocation_type = null

	human_req = TRUE
	clothes_req = FALSE
	level_max = 7 //max is actually 7(the point where the sprites stop working), but the implant can only reach 5

	delete_old = FALSE
	item_type = /obj/item/gun/magic/hardlight_spear

/obj/effect/proc_holder/spell/targeted/conjure_item/hardlight_spear/before_cast(mob/living/cast_on)
	. = ..()
	for(var/I in cast_on.get_contents())
		if(istype(I, /obj/item/gun/magic/hardlight_spear))
			return . | SPELL_CANCEL_CAST

/obj/effect/proc_holder/spell/targeted/conjure_item/hardlight_spear/make_item()
	. = ..()
	var/obj/item/gun/magic/hardlight_spear/made_spear = .
	made_spear.spears_left = spell_level-1

/obj/effect/proc_holder/spell/targeted/conjure_item/hardlight_spear/get_spell_title()
	switch(spell_level)
		if(2)
			return "Upgraded "
		if(3)
			return "Recursive "
		if(4)
			return "Resonant "
		if(5)
			return "Ascended "
		if(6)
			return "Overwhelming "
		if(7)
			return "Commmanding "

	return ""

/obj/effect/proc_holder/spell/targeted/conjure_item/hardlight_spear/max
	name = "Commmanding Hardlight Spear"
	charge_max = 10 SECONDS
	cooldown_min = 10 SECONDS
	spell_level = 7

/obj/effect/proc_holder/spell/targeted/conjure_item/max/get_spell_title()
	return "" //commanding commanding

/obj/item/gun/magic/hardlight_spear //listen man
	name = "hardlight spear"
	desc = "A spear made out of hardened light."
	fire_sound = 'sound/weapons/fwoosh.ogg'
	pinless = TRUE
	force = 25
	armour_penetration = 18
	block_chance = 0
	sharpness = IS_SHARP_ACCURATE
	w_class = WEIGHT_CLASS_HUGE
	antimagic_flags = NONE
	hitsound = 'sound/weapons/blade1.ogg'
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "lightspear"
	inhand_icon_state = "lightspear"
	worn_icon_state = "none"
	lefthand_file = 'code/modules/archonic/icons/inhands/lefthand.dmi'
	righthand_file = 'code/modules/archonic/icons/inhands/righthand.dmi'
	slot_flags = null
	can_charge = FALSE //ITS A SPEAR
	item_flags = NEEDS_PERMIT | DROPDEL | ABSTRACT | NO_MAT_REDEMPTION
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_power = 1
	max_charges = 1
	var/spears_left = 6
	ammo_type = /obj/item/ammo_casing/magic/hardlight_spear

/obj/item/gun/magic/hardlight_spear/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jousting)

	AddComponent(/datum/component/butchering, \
		speed = 10 SECONDS, \
		effectiveness = 70, \
	)

	block_chance = 25+spears_left*5

/obj/item/gun/magic/hardlight_spear/worn_overlays(mutable_appearance/standing, isinhands)
	. = ..()
	if(!isinhands) //HOW ARE YOU DOING THIS
		return
	if(!spears_left)
		return
	var/mutable_appearance/back_spear_overlay
	switch(spears_left)
		if(0)
			return
		if(1)
			back_spear_overlay = mutable_appearance('code/modules/archonic/icons/hardlightspear.dmi', "spear1", MOB_LAYER + 0.01)
		if(2)
			back_spear_overlay = mutable_appearance('code/modules/archonic/icons/hardlightspear.dmi', "spear2", MOB_LAYER + 0.01)
		if(3)
			back_spear_overlay = mutable_appearance('code/modules/archonic/icons/hardlightspear.dmi', "spear3", MOB_LAYER + 0.01)
		if(4)
			back_spear_overlay = mutable_appearance('code/modules/archonic/icons/hardlightspear.dmi', "spear4", MOB_LAYER + 0.01)
		if(5)
			back_spear_overlay = mutable_appearance('code/modules/archonic/icons/hardlightspear.dmi', "spear5", MOB_LAYER + 0.01)
		if(6)
			back_spear_overlay = mutable_appearance('code/modules/archonic/icons/hardlightspear.dmi', "spear6", MOB_LAYER + 0.01)
	back_spear_overlay.pixel_x = -32
	. += back_spear_overlay


/obj/item/gun/magic/hardlight_spear/can_trigger_gun(mob/living/user, akimbo_usage) // This isn't really a gun, so it shouldn't be checking for TRAIT_NOGUNS, a firing pin (pinless), or a trigger guard (guardless)
	if(akimbo_usage)
		return FALSE //this would be kinda weird while shooting someone down.
	return TRUE

/obj/item/gun/magic/hardlight_spear/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!.)
		return
	if(spears_left)
		var/obj/item/gun/magic/hardlight_spear/spear = new type
		spear.spears_left = spears_left - 1
		qdel(src)
		user.put_in_hands(spear)
	else
		user.dropItemToGround(src, TRUE)

/obj/item/ammo_casing/magic/hardlight_spear
	name = "please god report this"
	desc = "Why god why"
	slot_flags = null
	projectile_type = /obj/projectile/bullet/hardlight_spear
	heavy_metal = FALSE

/obj/item/ammo_casing/magic/hardlight_spear/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/fired_from)
	if(!loaded_projectile)
		return

	if(isliving(target))
		loaded_projectile.homing = TRUE
		loaded_projectile.homing_turn_speed = 40
		loaded_projectile.set_homing_target(target)

	return ..()

/obj/projectile/bullet/hardlight_spear
	name = "hardlight spear"
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "lightspear"
	damage = 45
	armour_penetration = 10
	speed = 0.4 //lower = faster
	shrapnel_type = /obj/item/shrapnel/bullet/spear
	light_outer_range = 1
	light_power = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	hitsound_wall = 'sound/weapons/parry.ogg'
	embedding = list(embed_chance=100, fall_chance=2, jostle_chance=4, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=5, jostle_pain_mult=6, rip_time=10)

/obj/item/shrapnel/bullet/spear
	name = "hardlight spear"
	icon = 'monkestation/icons/obj/items_and_weapons.dmi'
	icon_state = "lightspear"

/obj/item/shrapnel/bullet/spear/unembedded()
	. = ..()
	QDEL_NULL(src) //Deletes itself when unembedded
	return TRUE
