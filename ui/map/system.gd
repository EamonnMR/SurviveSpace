extends Control

# export var system_name: String = "Name"
export var system_id: String

var data: SystemData

func _ready():
	$Label.text = "GSC " + system_id
	data = Procgen.systems[system_id]
	rect_position = data.position

func clicked():
	Client.player.get_node("Controller").map_select_system(system_id)
	$circle.update()
	print("Clicked!")

func _on_Button_pressed():
	clicked()
