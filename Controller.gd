extends Node

var direction_change: float
var shooting: bool
var thrusting: bool
var braking: bool

func _physics_process(_delta: float):
	direction_change = _get_direction_change()
	shooting = Input.is_action_pressed("shoot")
	braking = Input.is_action_pressed("brakes")
	thrusting = Input.is_action_pressed("thrust") and not braking

func _get_direction_change():
	var dc = 0
	if Input.is_action_pressed("turn_left"):
		dc -= 1
	if Input.is_action_pressed("turn_right"):
		dc += 1
	return dc

func get_direction_change():
	return direction_change
	direction_change = 0
