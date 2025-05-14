/obj/item/lodestone_gem
	name = "\improper LODESTONE gem"
	desc = "An exotic pyramid-shaped crystal refined and stabilized from the CYTHONIC crystal samples secured by commander Cristal-Spire in 2564. Stabilzed with state-of-the-art technology to prevent any internal reality drops and CYTHONIC incursions. Can be used to power any Nanotrasen RealTech™ apparatus."
	icon = 'code/modules/archonic/icons/items_and_weapons.dmi'
	icon_state = "cythonic_crystal"
	w_class = WEIGHT_CLASS_TINY

//The M.A.E (Momentum Amplification Exosuit)



//Ranged RCD.

//The P.P.E.S. (Physical Perception Exclusion Suit)

//The Knucklebreaker (Momentum Amplified Buckler)
/obj/item/shield/lodestone
	name = "\improper Knucklebreaker MK.1"
	desc = "A medieval wooden buckler."
	icon = 'icons/obj/shields.dmi'
	icon_state = "buckler"
	item_state = "buckler"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	block_chance = 25
	block_cooldown_time = 0 SECONDS
	armor = list("melee" = 80, "bullet" = 80, "laser" = 80, "energy" = 40, "bomb" = 80, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	attack_verb = list("shoved", "bashed")
	force = 10
	var/obj/item/lodestone_gem/gem
	var/momentum_setting = 0

/obj/item/shield/lodestone/gem/Initialize()
	. = ..()
	gem = new(src)

/obj/item/shield/lodestone/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/lodestone_gem))
		if(!user.transferItemToLoc(W, src))
			return
		gem = W
		to_chat(user, "<span class='notice'>You pop the [W] into the [src].</span>")
		momentum_setting = 1
		tool_behaviour = TOOL_MINING
		toolspeed = 0.05

/obj/item/shield/lodestone/AltClick(mob/user)
	if(!gem)
		to_chat(user, "<span class='notice'>\The [src]'s power slot is empty.</span>")
		return
	to_chat(user, "<span class='notice'>You pop the [gem] out of the [src].</span>")
	momentum_setting = 1
	tool_behaviour = 0
	toolspeed = 1
	gem.forceMove(get_turf(user))
	user.put_in_hands(gem)
	gem = null

/obj/item/shield/lodestone/attack_self(mob/living/carbon/human/user)
	switch(momentum_setting)
		if(1)
			momentum_setting = 2
			balloon_alert(user, "You turn the momentum dial to HIGH.")
		if(2)
			momentum_setting = 3
			balloon_alert(user, "You turn the momentum dial to MAXIMUM.")
		if(3)
			momentum_setting = 1
			balloon_alert(user, "You turn the momentum dial to STANDARD.")

/obj/item/shield/lodestone/attack(mob/living/target, mob/user)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, target, user) & COMPONENT_ITEM_NO_ATTACK)
		return
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, target, user)
	user.do_attack_animation(target)

	target.lastattacker = user.real_name
	target.lastattackerckey = user.ckey

	if(!gem)
		to_chat(user, "<span class='warning'>\The [src] has no power source!</span>")
		target.apply_damage(force, BRUTE)
		playsound(loc, 'sound/weapons/genhit3.ogg', 50, TRUE)
		target.visible_message("<span class='danger'>[user] weakly bashes the [src] into [target.name]!</span>", \
			"<span class='userdanger'>[user] bashes you with \the [src]!</span>")
	else if(HAS_TRAIT(target, TRAIT_ANOMALY_IMMUNE_AIMTIACRYSTAL))
		target.apply_damage(force + 10, BRUTE)
		target.visible_message("<span class='danger'>[user] bashes the [src] into [target.name]!</span>", \
			"<span class='userdanger'>[user] bashes you with \the [src]!</span>")
	else
		switch(momentum_setting)
			if(1)
				target.apply_damage(force + 20, BRUTE)
				playsound(loc, 'sound/weapons/genhit2.ogg', 50, TRUE)
				playsound(loc, 'sound/weapons/sonic_jackhammer.ogg', 50, TRUE)
				if(target.body_position == LYING_DOWN)
					target.visible_message("<span class='danger'>[user] beats [target.name] into the ground with \the [src].</span>", \
						"<span class='userdanger'>[user] beats you into the ground with \the [src]!</span>")
					target.apply_damage(force, BRUTE)
				else
					target.visible_message("<span class='danger'>[user] bashes [target.name] down with \the [src].</span>", \
						"<span class='userdanger'>[user] forcefully bashes you down with \the [src]!</span>")
					target.Knockdown(20)
			if(2)
				target.apply_damage(force + 35, BRUTE)
				playsound(loc, 'sound/weapons/genhit2.ogg', 50, TRUE)
				playsound(loc, 'sound/weapons/sonic_jackhammer.ogg', 50, TRUE)
				if(target.body_position == LYING_DOWN)
					target.visible_message("<span class='danger'>[user] pulps [target.name] into the ground with \the [src].</span>", \
						"<span class='userdanger'>[user] pulps you into the ground with \the [src]!</span>")
					target.apply_damage(force + 10, BRUTE)
				else
					target.visible_message("<span class='danger'>[user] flings [target.name] into the air with \the [src]'s hit.</span>", \
						"<span class='userdanger'>[user] flings you around with the hit from \the [src]!</span>")
					var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
					target.throw_at(throw_target, 12, 2.5)
			if(3)
				target.apply_damage(force + 50, BRUTE)
				playsound(loc, 'sound/weapons/genhit2.ogg', 50, TRUE)
				playsound(loc, 'sound/weapons/sonic_jackhammer.ogg', 50, TRUE)
				if(target.body_position == LYING_DOWN)
					target.visible_message("<span class='danger'>[user] pulverizes [target.name] into the ground with \the [src].</span>", \
						"<span class='userdanger'>[user] utterly pulverizes you into the ground with \the [src]!</span>")
					target.apply_damage(force + 20, BRUTE)
					if(target.getBruteLoss() >= 350)
						target.gib()
				else
					target.visible_message("<span class='danger'>[user] violently flings [target.name] into the air with \the [src]'s hit.</span>", \
						"<span class='userdanger'>[user] violently flings you around with the hit from \the [src]!</span>")
					var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
					target.throw_at(throw_target, 18, 4)
	log_combat(user, target, "knucklebreakered", src)
	if(prob(33 * momentum_setting))
		src.add_mob_blood(target)
		var/turf/location = get_turf(target)
		target.add_splatter_floor(location)
		if(get_dist(user, target) <= 1)	//people with TK won't get smeared with blood
			user.add_mob_blood(target)

	return


//The Spatial Bypass Gate. Codename: StarGate.
