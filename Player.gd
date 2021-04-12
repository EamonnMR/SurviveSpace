extends KinematicBody2D

var max_speed = 100
var accel = 1
var turn = 1
var linear_velocity = Vector2()
const PLAY_AREA_RADIUS = 40000

func _ready():
	Client.player = self

func _physics_process(delta):
	linear_velocity = get_limited_velocity_with_thrust(delta)
	rotation += delta * turn * $Controller.rotation_change
	move_and_slide(linear_velocity)
	if $Controller.shooting:
		for weapon in $Weapons.get_children():
			weapon.try_shooting()


func get_limited_velocity_with_thrust(delta):
	if $Controller.thrusting:
		linear_velocity += Vector2(accel * delta * 100, 0).rotated(rotation)
	if linear_velocity.length() > max_speed:
		return Vector2(max_speed, 0).rotated(linear_velocity.angle())
	else:
		return linear_velocity

func wrap_position(state):
	var transform = state.get_transform()
	if position.length() > PLAY_AREA_RADIUS:
		position = Vector2(PLAY_AREA_RADIUS / 2, 0).rotated(anglemod(transform.origin.angle() + PI))

func is_player():
	return true

func anglemod(angle):
	"""I wish this was a builtin"""
	var ARC = 2 * PI
	# TODO: Recursive might be too slow
	return fmod(angle + ARC, ARC)
