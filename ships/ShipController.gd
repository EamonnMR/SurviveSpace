extends Node

class_name ShipController

var rotation_change: float
var shooting: bool
var thrusting: bool
var braking: bool
var do_jump: bool
var pop_consumables: Dictionary

func is_player() -> bool:
	return false

func _anglemod(angle: float) -> float:
	return fmod(angle, PI * 2)

func _get_ideal_face(from: Node2D, to: Vector2):
	return (to - from.global_position).angle()

func _constrained_point(subject, current_rotation, max_turn, position: Vector2):
	# For finding the right direction and amount to turn when your rotation speed is limited
	var ideal_face = _get_ideal_face(subject, position)
	var ideal_turn = _anglemod(ideal_face - current_rotation)
	if(ideal_turn > PI):
		ideal_turn = _anglemod(ideal_turn - 2 * PI)

	elif(ideal_turn < -1 * PI):
		ideal_turn = _anglemod(ideal_turn + 2 * PI)
	
	max_turn = sign(ideal_turn) * max_turn  # Ideal turn in the right direction
	
	if(abs(ideal_turn) > abs(max_turn)):
		return [max_turn, ideal_face]
	else:
		return [ideal_turn, ideal_face]
