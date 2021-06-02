extends Ship

var ship_name = "UNS Ring Of Glory"
var type_name = "Recon Shuttle"

export var crafting_level: int = 0

func _ready():
	max_speed = 100
	accel = 1
	turn = 1
	Client.player = self
	Client.add_radar_pip(self)
	Client.get_ui().get_node("Inventory").assign($Inventory, "Inventory")
	$Health.connect("ran_out", self, "_health_ran_out")

func do_jump():
	if $Controller.selected_system:
		Client.exit_system_hyperjump($Controller.selected_system)
	else:
		print("Can't jump, select a system from the map with 'M'")

func is_player():
	return not disabled

func serialize() -> Dictionary:
	return {
		"position": position,
		"rotation": rotation,
		"inventory": $Inventory.serialize(),
		"health": $Health.serialize(),
		"disabled": disabled
	}

func deserialize(data):
	position = data["position"]
	rotation = data["rotation"]
	$Inventory.deserialize(data["inventory"])
	$Health.deserialize(data["health"])
	disabled = data["disabled"]
	
	if disabled:
		set_disabled_texture()

func _health_ran_out():
	disabled = true
	set_disabled_texture()
	Client.player_respawn()
	
func set_disabled_texture():
	$Sprite.texture = Client.cache_load("res://assets/millionthvector_cc_by/Faction6-Spaceships-by-MillionthVector/redship4_disabled.png")
