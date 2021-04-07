extends RigidBody2D

var max_speed = 100
var accel = 1
var turn = 1
const PLAY_AREA_RADIUS = 40000
func get_limited_velocity_with_thrust():
	var vel = get_linear_velocity()
	if $Controller.thrusting:
		vel += Vector2(accel, 0).rotated(rotation)
	if vel.length() > max_speed:
		return Vector2(max_speed, 0).rotated(vel.angle())
	else:
		return vel

func wrap_position_with_transform(state):
	var transform = state.get_transform()
	if transform.origin.length() > PLAY_AREA_RADIUS:
		transform.origin = Vector2(PLAY_AREA_RADIUS / 2, 0).rotated(anglemod(transform.origin.angle() + PI))
		state.set_transform(transform)
		
func _integrate_forces(state):
	rotate($Controller.get_direction_change() * turn)
	set_applied_torque(0)  # Non-physics rotation
	wrap_position_with_transform(state)
	set_linear_velocity(get_limited_velocity_with_thrust())

func anglemod(angle):
	"""I wish this was a builtin"""
	var ARC = 2 * PI
	# TODO: Recursive might be too slow
	return fmod(angle + ARC, ARC)
