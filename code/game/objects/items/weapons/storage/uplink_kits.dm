/obj/item/weapon/storage/box/syndicate/
	name = "box"

/obj/item/weapon/storage/box/syndicate/atom_init()
	. = ..()
	var/tagname = pick("bloodyspai", "stealth", "screwed", "ninja", "guns", "implant", "hacker", "smoothoperator", "poisons", "gadgets")
	switch (tagname)
		if("bloodyspai")
			new /obj/item/clothing/under/chameleon(src)
			new /obj/item/clothing/mask/gas/voice(src)
			new /obj/item/weapon/card/id/syndicate(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)
			new /obj/item/weapon/melee/powerfist(src)
			new /obj/item/device/camera_bug(src)
			new /obj/item/weapon/grenade/clusterbuster/soap(src)

		if("stealth")
			new /obj/item/weapon/gun/energy/crossbow(src)
			new /obj/item/device/healthanalyzer/rad_laser(src)
			new /obj/item/device/chameleon(src)
			new /obj/item/weapon/card/id/syndicate(src)
			new /obj/item/clothing/gloves/black/strip(src)

		if("screwed")
			for (var/i in 1 to 2)
				new /obj/item/weapon/grenade/syndieminibomb(src)
			new /obj/item/device/powersink(src)
			new /obj/item/clothing/suit/space/syndicate(src)
			new /obj/item/clothing/head/helmet/space/syndicate(src)
			new /obj/item/clothing/gloves/yellow(src)
			new /obj/item/weapon/plastique(src)

		if("guns")
			new /obj/item/weapon/gun/projectile/revolver/syndie(src)
			new /obj/item/ammo_box/a357(src)
			new /obj/item/weapon/card/emag(src)
			new /obj/item/weapon/card/id/syndicate(src)
			new /obj/item/weapon/plastique(src)

		if("implant")
			var/obj/item/weapon/implanter/O = new /obj/item/weapon/implanter(src)
			O.imp = new /obj/item/weapon/implant/freedom(O)
			var/obj/item/weapon/implanter/U = new /obj/item/weapon/implanter(src)
			U.imp = new /obj/item/weapon/implant/uplink(U)
			new /obj/item/weapon/implanter/explosive(src)
			new /obj/item/weapon/implanter/adrenalin(src)
			new /obj/item/weapon/implanter/storage(src)

		if("hacker")
			new /obj/item/weapon/aiModule/syndicate(src)
			new /obj/item/weapon/card/emag(src)
			new /obj/item/device/encryptionkey/binary(src)
			new /obj/item/device/multitool/ai_detect(src)
			new /obj/item/device/flashlight/emp(src)

		if("smoothoperator")
			new /obj/item/weapon/gun/projectile/pistol/syndicate(src)
			new /obj/item/weapon/silencer(src)
			new /obj/item/ammo_box/magazine/m9mm_pistol(src)
			new /obj/item/weapon/soap/syndie(src)
			new /obj/item/weapon/storage/bag/trash(src)
			new /obj/item/bodybag(src)
			new /obj/item/clothing/under/suit_jacket/reinforced(src)
			new /obj/item/clothing/shoes/laceup(src)
			new /obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate(src)
			new /obj/item/clothing/glasses/sunglasses/big(src)


		if("poisons")
			new /obj/item/weapon/reagent_containers/glass/bottle/carpotoxin(src)
			new /obj/item/weapon/reagent_containers/glass/bottle/alphaamanitin(src)
			new /obj/item/weapon/reagent_containers/glass/bottle/chefspecial(src)
			new /obj/item/weapon/reagent_containers/glass/bottle/cyanide(src)
			new /obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate(src)
			new /obj/item/weapon/reagent_containers/syringe(src)
			new /obj/item/weapon/gun/syringe/syndicate(src)

		if("ninja")
			new /obj/item/weapon/pen/edagger(src)
			new /obj/item/weapon/melee/energy/sword/black(src)
			new /obj/item/device/powersink(src)
			new /obj/item/weapon/storage/box/syndie_kit/throwing_weapon(src)
			new /obj/item/clothing/under/color/black(src)
			new /obj/item/clothing/head/chaplain_hood(src)
			new /obj/item/clothing/glasses/thermal/syndi(src)
			new /obj/item/clothing/mask/gas/voice(src)
			new /obj/item/clothing/gloves/black/strip(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)
			new /obj/item/weapon/storage/backpack/satchel/flat(src)

		if("gadgets")
			new /obj/item/clothing/gloves/yellow(src)
			new /obj/item/weapon/pen/paralysis(src)
			new /obj/item/clothing/glasses/thermal/syndi(src)
			new /obj/item/device/flashlight/emp(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)
			new /obj/item/device/multitool/ai_detect(src)
			new /obj/item/device/chameleon(src)

	tag = tagname
	make_exact_fit()


/obj/item/weapon/storage/box/syndie_kit
	desc = "A sleek, sturdy box."
	icon_state = "box_of_doom"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom

/obj/item/weapon/storage/box/syndie_kit/imp_freedom/atom_init()
	. = ..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/freedom(O)
	O.update()

/obj/item/weapon/storage/box/syndie_kit/imp_compress

/obj/item/weapon/storage/box/syndie_kit/imp_compress/atom_init()
	new /obj/item/weapon/implanter/compressed(src)
	. = ..()

/obj/item/weapon/storage/box/syndie_kit/imp_explosive

/obj/item/weapon/storage/box/syndie_kit/imp_explosive/atom_init()
	new /obj/item/weapon/implanter/explosive(src)
	. = ..()

/obj/item/weapon/storage/box/syndie_kit/imp_uplink

/obj/item/weapon/storage/box/syndie_kit/imp_uplink/atom_init()
	. = ..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/uplink(O)
	O.update()

/obj/item/weapon/storage/box/syndie_kit/space

/obj/item/weapon/storage/box/syndie_kit/space/atom_init()
	. = ..()
	new /obj/item/clothing/suit/space/syndicate(src)
	new /obj/item/clothing/head/helmet/space/syndicate(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency_oxygen/engi(src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/fake_loyalty
	desc = "Fake nanites for your safety"
	origin_tech = "syndicate=5;programming=4;biotech=4"

/obj/item/weapon/storage/box/syndie_kit/fake_loyalty/atom_init()
	. = ..()
	new /obj/item/weapon/implanter/fake_loyalty(src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/chameleon
	desc = "Comes with all the clothes you need to impersonate most people.  Acting lessons sold seperately."

/obj/item/weapon/storage/box/syndie_kit/chameleon/atom_init()
	. = ..()
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/weapon/storage/backpack/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/weapon/gun/projectile/chameleon(src)
	new /obj/item/ammo_box/magazine/chameleon(src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/throwing_weapon

/obj/item/weapon/storage/box/syndie_kit/throwing_weapon/atom_init()
	. = ..()
	for (var/i in 1 to 2)
		new /obj/item/weapon/legcuffs/bola/tactical(src)
	for (var/i in 1 to 5)
		new /obj/item/weapon/throwing_star(src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/cutouts

/obj/item/weapon/storage/box/syndie_kit/cutouts/atom_init()
	. = ..()
	for(var/i = 1 to 3)
		new /obj/item/cardboard_cutout(src)
	new /obj/item/toy/crayon/rainbow (src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/rig

/obj/item/weapon/storage/box/syndie_kit/rig/atom_init()
	. = ..()
	new /obj/item/clothing/suit/space/rig/syndi(src)
	new /obj/item/clothing/head/helmet/space/rig/syndi(src)
	new /obj/item/clothing/shoes/magboots/syndie(src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/armor

/obj/item/weapon/storage/box/syndie_kit/armor/atom_init()
	. = ..()
	new /obj/item/clothing/suit/armor/syndiassault(src)
	if(prob(50))
		new /obj/item/clothing/head/helmet/syndiassault(src)
	else
		new /obj/item/clothing/head/helmet/syndiassault/alternate(src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/fake
	desc = "This set allows you to forge various documents at the station."

/obj/item/weapon/storage/box/syndie_kit/fake/atom_init()
	. = ..()
	new /obj/item/weapon/pen/chameleon(src)
	new /obj/item/weapon/stamp/chameleon(src)

/obj/item/weapon/storage/box/syndie_kit/rev_posters

/obj/item/weapon/storage/box/syndie_kit/rev_posters/atom_init()
	. = ..()
	for(var/i in 0 to 6)
		new /obj/item/weapon/poster/contraband/rev(src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/posters

/obj/item/weapon/storage/box/syndie_kit/posters/atom_init()
	. = ..()
	for(var/i in 0 to 6)
		new /obj/item/weapon/poster/contraband(src)
	make_exact_fit()

/obj/item/weapon/storage/box/syndie_kit/merch
	desc = "Box containing some Syndicate merchandise for real agents!"

/obj/item/weapon/storage/box/syndie_kit/merch/atom_init()
	. = ..()
	new /obj/item/clothing/head/soft/red(src)
	new /obj/item/clothing/suit/syndieshirt(src)
	new /obj/item/toy/syndicateballoon(src)
	make_exact_fit()