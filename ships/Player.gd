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

func do_jump():
	if $Controller.selected_system:
		Client.exit_system_hyperjump($Controller.selected_system)
	else:
		print("Can't jump, select a system from the map with 'M'")

func is_player():
	return true
