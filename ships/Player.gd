extends Ship

var ship_name = "UNS Ring Of Glory"
var type_name = "Recon Shuttle"

export var crafting_level: int = 0

func _ready():
	max_speed = 100
	accel = 1
	turn = 1
	Client.add_radar_pip(self)
	$Health.connect("ran_out", self, "_health_ran_out")

func do_jump():
	if $Controller.selected_system:
		Client.exit_system_hyperjump($Controller.selected_system)
	else:
		print("Can't jump, select a system from the map with 'M'")

func is_player():
	return not disabled

func serialize() -> Dictionary:
	print("Serialized Player")
	return {
		"position": [position.x, position.y],
		"rotation": rotation,
		"inventory": $Inventory.serialize(),
		"health": $Health.serialize(),
		"disabled": disabled
	}

func deserialize(data):
	position = Vector2(data["position"][0], data["position"][1])
	rotation = data["rotation"]
	$Inventory.deserialize(data["inventory"])
	$Health.deserialize(data["health"])
	disabled = data["disabled"]
	
	if disabled:
		set_disabled_texture()
		disable_control()

func _health_ran_out():
	disabled = true
	set_disabled_texture()
	disable_control()
	name = "PlayerHulk"
	# TODO: Wait
	Client.player_respawn()
	
func set_disabled_texture():
	$Sprite.texture = Client.cache_load("res://assets/millionthvector_cc_by/Faction1-Spaceships-by-MillionthVector/tinyorange_disabled.png")

func disable_control():
	remove_child($Controller)
	remove_child($Camera2D)
	add_child(preload("res://ships/ShipController.tscn").instance())
	$EngineEffects.off()
	
func enable_control():
	remove_child($Controller)
	add_child(preload("res://ships/PlayerController.tscn").instance())
	var camera = Camera2D.new()
	add_child(camera)
	camera.current = true

func can_interact():
	return disabled
