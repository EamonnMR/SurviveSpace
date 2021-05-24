extends Ship


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	max_speed = 80.0
	accel = 0.5
	turn = 0.5
	Client.add_radar_pip(self)
	$Health.connect("ran_out", self, "_health_ran_out")
	$Health.connect("took_damage", self, "_took_damage")
	$Health.connect("took_damage", $Controller, "_ship_took_damage")
func _health_ran_out():
	if not disabled:
		# TODO: Trigger a re-evaluation of interactibility
		disabled = true
		_disabled_effects()
	else:
		_destroyed_effects()
		queue_free()

func _disabled_effects():
	pass

func _destroyed_effects():
	pass

func _took_damage(from):
	# TODO: get angry?
	pass

func can_interact():
	# TODO: Trigger a re-
	return disabled
