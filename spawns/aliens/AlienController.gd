extends ShipController

const LEAVE_SYSTEM_CHANCE = 0.5

# TODO: This stuff ought to be configured at spawn time, based on present weapons
export var accel_margin = PI / 2
export var accel_distance = 10
export var shoot_margin = PI / 2
export var shoot_distance = 200
export var max_target_distance = 1000
export var destination_margin = 100

var target
var ideal_face
var destination
var parent: Ship
var arrived: bool
var try_leaving_system: bool = false
var waiting: bool = false
var mine_asteroids = true

func _ready():
	parent = get_node("../")
	parent.connect("took_damage_from", self, "_ship_took_damage")

func _physics_process(delta):
	if waiting:
		shooting = false
		thrusting = false
		braking = true
		rotation_change = 0
	else:
		#if leving_system:
		#	_fly_to_leave_system(delta)
		#else:
		# TODO: Idle mine asteroids
		_hunt(delta)

func _is_at_destination():
	return (destination != null) and parent.position.distance_to(destination) < destination_margin

func _fly_to_leave_system(delta):
	if parent.position.length() > Ship.JUMP_DISTANCE:
		parent.start_jump()
	else:
		_fly_to_destination(delta)

func _fly_to_destination(delta):
	get_ideal_face_and_direction_change(destination, delta)
	shooting = false
	thrusting = _should_thrust_idle()
	braking = _should_brake_idle()

func _start_leaving_system():
	print("start leaving system: ")
	destination = Vector2(max(Ship.JUMP_DISTANCE, parent.position.length()) + 30, 0).rotated(parent.position.angle())
	print("Goal Destination: ", destination)
	# puppet_selected_system = _select_random_adjacent_system()

func _hunt(delta):
	if not target or not is_instance_valid(target):  # or is idling:
		target = _find_target()
	rotation_change = 0
	ideal_face = null
	if(target):
		get_ideal_face_and_direction_change(target.global_position, delta)
		shooting = _should_shoot()
		thrusting = _should_thrust()
		braking = _should_brake()
		return true
	return false
	

func distance_comparitor(lval, rval):
	# For sorting other nodes by how close they are
	var parent = get_node("../")
	var ldist = lval.position.distance_to(parent.position)
	var rdist = rval.position.distance_to(parent.position)
	return ldist < rdist
	
func get_ideal_face_and_direction_change(at: Vector2, delta):
	var impulse = _constrained_point(
		parent, parent.rotation, parent.turn * delta, at
	)
	rotation_change = sign(impulse[0])
	ideal_face = impulse[1]

func _find_target():
	if is_instance_valid(Client.player):
		return Client.player
	else:
		return null
	# TODO: Actually do thinking here
	var level = get_node("../../../")
	var possible_targets = []
	var players = level.get_node("players").get_children()
	# TODO: Probably filter before sorting here
	possible_targets += players
	var npcs = level.get_node("npcs").get_children()
	possible_targets += npcs
	possible_targets.sort_custom(self, "distance_comparitor")
	for possible_target in possible_targets:
		if get_node("../").position.distance_to(possible_target.position) > max_target_distance:
			continue
		if not possible_target.is_alive():
			continue
		if is_instance_valid(possible_target):
			if is_faction_enemy(possible_target) or (possible_target.is_player() and is_player_enemy(possible_target)):
				return possible_target
	return null

func is_faction_enemy(ship):
	return true
	# return int(ship.faction) != faction_dat.id and int(ship.faction) in faction_dat.enemies

func is_player_enemy(ship):
	return true
	# return faction_dat.disposition_per_player[int(ship.name)] < 0

# TODO: Add a timer for this
func _on_ai_rethink_timer_timeout():
	var target = _find_target()

func _should_thrust():
	return (
		target
		and ideal_face
		and _facing_right_way_to_accel()
		and (_far_enough_to_accel() or parent.joust)
	)
	
func _should_thrust_idle():
	return (
		destination != null
		and ideal_face
		and _facing_right_way_to_accel()
	)

func _facing_right_way_to_accel():
	return _facing_within_margin(accel_margin)

func _far_enough_to_accel():
	return parent.position.distance_to(target.position) > accel_distance

func _should_brake():
	return parent.standoff and target and is_instance_valid(target) and parent.position.distance_to(target.position) < shoot_distance

func _should_brake_idle():
	return arrived

func _facing_within_margin(margin):
	""" Relies on 'ideal face' being populated """
	return (
		parent.has_turrets or
		(ideal_face and abs(_anglemod(ideal_face - parent.rotation)) < margin)
	)

func _should_shoot():
	return target and _facing_within_margin(shoot_margin) and parent.position.distance_to(target.position) < shoot_distance

func _ship_took_damage(source):
	waiting = false
	if (parent.get_node("Health").health < parent.get_node("Health").max_health * 0.75) and parent.wimpy:
		print("Fleeing system")
		_start_leaving_system()
		# print("Flee destination: ", puppet_selected_system)
	else:
		print("Aggro")
		target = source
		
func _select_random_adjacent_system():
	var system = Procgen.systems[parent.current_system()]
	#return Game.random_select(
	#	system.links
	#)

func _set_wait_timer():
	destination = null
	if not waiting:
		print("Set AI wait timer")
		waiting = true
		var timer = Timer.new()
		timer.connect("timeout", self, "_wait_timer_timeout", [timer])
		add_child(timer)
		timer.set_wait_time(10)
		timer.one_shot = true
		timer.start()
	else:
		print("Wait timer already active")

func _wait_timer_timeout(timer):
	print("Wait timer finished")
	remove_child(timer)
	waiting = false
