extends Node2D

# export var system_name: String = "Name"
export var system_id: String

var data: SystemData

func _ready():
	$Label.text = "GSC " + system_id
	data = Procgen.systems[system_id]
	position = data.position

func clicked():
	Client.player.get_node("Controller").map_select_system(system_id)
	$circle.update()
