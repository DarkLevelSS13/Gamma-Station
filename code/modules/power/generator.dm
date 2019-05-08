
/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg"
	density = 1
	anchored = 0

	use_power = 1
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.

	var/max_power = 500000
	var/thermal_efficiency = 0.65

	var/obj/machinery/atmospherics/components/binary/circulator/circ1
	var/obj/machinery/atmospherics/components/binary/circulator/circ2

	var/last_circ1_gen = 0
	var/last_circ2_gen = 0
	var/last_thermal_gen = 0
	var/stored_energy = 0
	var/lastgen1 = 0
	var/lastgen2 = 0
	var/effective_gen = 0
	var/lastgenlev = 0

/obj/machinery/power/generator/atom_init()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/generator/atom_init_late()
	desc = initial(desc) + " Rated for [round(max_power/1000)] kW."
	reconnect()

//generators connect in dir and reverse_dir(dir) directions
//mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator
//so a circulator to the NORTH of the generator connects first to the EAST, then to the WEST
//and a circulator to the WEST of the generator connects first to the NORTH, then to the SOUTH
//note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
/obj/machinery/power/generator/proc/reconnect()
	circ1 = null
	circ2 = null
	if(loc && anchored)
		if(dir & (EAST|WEST))
			circ1 = locate(/obj/machinery/atmospherics/components/binary/circulator) in get_step(src,WEST)
			circ2 = locate(/obj/machinery/atmospherics/components/binary/circulator) in get_step(src,EAST)

			if(circ1 && circ2)
				if(circ1.dir != NORTH || circ2.dir != SOUTH)
					circ1 = null
					circ2 = null

		else if(dir & (NORTH|SOUTH))
			circ1 = locate(/obj/machinery/atmospherics/components/binary/circulator) in get_step(src,NORTH)
			circ2 = locate(/obj/machinery/atmospherics/components/binary/circulator) in get_step(src,SOUTH)

			if(circ1 && circ2 && (circ1.dir != EAST || circ2.dir != WEST))
				circ1 = null
				circ2 = null

/obj/machinery/power/generator/update_icon()
	if(stat & (NOPOWER|BROKEN))
		overlays.Cut()
	else
		overlays.Cut()

		if(lastgenlev != 0)
			overlays += image('icons/obj/power.dmi', "teg-op[lastgenlev]")

/obj/machinery/power/generator/process()
	if(!circ1 || !circ2 || !anchored || stat & (BROKEN|NOPOWER))
		stored_energy = 0
		return

	updateDialog()

	var/datum/gas_mixture/air1 = circ1.return_transfer_air()
	var/datum/gas_mixture/air2 = circ2.return_transfer_air()

	lastgen2 = lastgen1
	lastgen1 = 0
	last_thermal_gen = 0
	last_circ1_gen = 0
	last_circ2_gen = 0

	if(air1 && air2)
		var/air1_heat_capacity = air1.heat_capacity()
		var/air2_heat_capacity = air2.heat_capacity()
		var/delta_temperature = abs(air2.temperature - air1.temperature)

		if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
			var/energy_transfer = delta_temperature*air2_heat_capacity*air1_heat_capacity/(air2_heat_capacity+air1_heat_capacity)
			var/heat = energy_transfer*(1-thermal_efficiency)
			last_thermal_gen = energy_transfer*thermal_efficiency

			if(air2.temperature > air1.temperature)
				air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
				air1.temperature = air1.temperature + heat/air1_heat_capacity
			else
				air2.temperature = air2.temperature + heat/air2_heat_capacity
				air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity
		playsound(src.loc, 'sound/effects/beam.ogg', 25, 0, 10)

	//Transfer the air
	var/datum/gas_mixture/circ_air1 = circ1.AIR2
	var/datum/gas_mixture/circ_air2 = circ2.AIR2

	if (air1)
		circ_air1.merge(air1)
	if (air2)
		circ_air2.merge(air2)

	//Update the gas networks
	var/datum/pipeline/circ1_parent2 = circ1.PARENT2
	var/datum/pipeline/circ2_parent2 = circ2.PARENT2

	circ1_parent2.update = 1
	circ2_parent2.update = 1

	//Exceeding maximum power leads to some power loss
	if(effective_gen > max_power && prob(5))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		stored_energy *= 0.5

	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	// update icon overlays and power usage only if displayed level has changed
	var/genlev = max(0, min( round(11*effective_gen / max_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		update_icon()
	add_avail(effective_gen)

/obj/machinery/power/generator/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		anchored = !anchored
		to_chat(user, "\blue You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.")
		use_power = anchored
		reconnect()
	else
		..()

/obj/machinery/power/generator/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || !anchored) return
	if(!circ1 || !circ2) //Just incase the middle part of the TEG was not wrenched last.
		reconnect()
	ui_interact(user)

/obj/machinery/power/generator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/vertical = 0
	if (dir == NORTH || dir == SOUTH)
		vertical = 1

	var/datum/gas_mixture/circ1_air1 = circ1.AIR1
	var/datum/gas_mixture/circ1_air2 = circ1.AIR2
	var/datum/gas_mixture/circ2_air1 = circ2.AIR1
	var/datum/gas_mixture/circ2_air2 = circ2.AIR2

	var/data[0]
	data["totalOutput"] = effective_gen/1000
	data["maxTotalOutput"] = max_power/1000
	data["thermalOutput"] = last_thermal_gen/1000
	data["circConnected"] = 0

	if(circ1)
		//The one on the left (or top)
		data["primaryDir"] = vertical ? "top" : "left"
		data["primaryOutput"] = last_circ1_gen/1000
		data["primaryFlowCapacity"] = circ1.volume_capacity_used*100
		data["primaryInletPressure"] = circ1_air1.return_pressure()
		data["primaryInletTemperature"] = circ1_air1.temperature
		data["primaryOutletPressure"] = circ1_air2.return_pressure()
		data["primaryOutletTemperature"] = circ1_air2.temperature

	if(circ2)
		//Now for the one on the right (or bottom)
		data["secondaryDir"] = vertical ? "bottom" : "right"
		data["secondaryOutput"] = last_circ2_gen/1000
		data["secondaryFlowCapacity"] = circ2.volume_capacity_used*100
		data["secondaryInletPressure"] = circ2_air1.return_pressure()
		data["secondaryInletTemperature"] = circ2_air1.temperature
		data["secondaryOutletPressure"] = circ2_air2.return_pressure()
		data["secondaryOutletTemperature"] = circ2_air2.temperature

	if(circ1 && circ2)
		data["circConnected"] = 1
	else
		data["circConnected"] = 0


	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "generator.tmpl", "Thermoelectric Generator", 450, 500)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/generator/power_change()
	..()
	update_icon()

/obj/machinery/power/generator/verb/rotate_clock()
	set category = "Object"
	set name = "Rotate Generator (Clockwise)"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	dir = turn(dir, 90)

/obj/machinery/power/generator/verb/rotate_anticlock()
	set category = "Object"
	set name = "Rotate Generator (Counterclockwise)"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	dir = turn(dir, -90)