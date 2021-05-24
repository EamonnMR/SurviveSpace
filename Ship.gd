extends KinematicBody2D

class_name Ship

var max_speed = 0
var accel = 0
var turn = 0

var disabled = false

var linear_velocity = Vector2()
const PLAY_AREA_RADIUS = 3000

func _physics_process(delta):
	if not disabled:
		linear_velocity = get_limited_velocity_with_thrust(delta)
		rotation += delta * turn * $Controller.rotation_change
		move_and_slide(linear_velocity)
		if $Controller.shooting:
			for weapon in $Weapons.get_children():
				weapon.try_shooting()
		
		if position.length() > PLAY_AREA_RADIUS:
			position = Vector2(PLAY_AREA_RADIUS / 2, 0).rotated(anglemod(transform.origin.angle() + PI))

		if $Controller.do_jump:
			$Controller.do_jump = false  # Only jump once!
			do_jump()

func do_jump():
	_jump_effects()
	queue_free()
	
func _jump_effects():
	pass

func get_limited_velocity_with_thrust(delta):
	if $Controller.thrusting:
		linear_velocity += Vector2(accel * delta * 100, 0).rotated(rotation)
		$EngineEffects.on()
	else:
		$EngineEffects.off()
	if linear_velocity.length() > max_speed:
		return Vector2(max_speed, 0).rotated(linear_velocity.angle())
	else:
		return linear_velocity

func wrap_position(state):
	var transform = state.get_transform()
	if position.length() > PLAY_AREA_RADIUS:
		position = Vector2(PLAY_AREA_RADIUS / 2, 0).rotated(anglemod(transform.origin.angle() + PI))

func is_player():
	return false

func anglemod(angle):
	"""I wish this was a builtin"""
	var ARC = 2 * PI
	# TODO: Recursive might be too slow
	return fmod(angle + ARC, ARC)

func add_weapon(weapon, _index):
	$Weapons.add_child(weapon)
	
func remove_weapon(_index):
	for child in $Weapons.get_children():
		$Weapons.remove_child(child)

func add_hyperdrive(drive):
	var root = get_tree().get_root()
	var game = root.get_node("Game")
	root.remove_child(game)
	game.queue_free()
	root.add_child(preload("res://ui/WinScreen.tscn").instance())
	
func remove_warpdrive(_index):
	pass

func get_weapon(_index):
	var children = $Weapons.get_children()
	if children.size() == 1:
		return children[0]
	else:
		return null
