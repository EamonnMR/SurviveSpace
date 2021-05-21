extends Control

# export var system_name: String = "Name"
export var system_id: String

var data: SystemData

func _ready():
	$Label.text = "GSC " + system_id
	data = Procgen.systems[system_id]
	rect_position = data.position
	update()

func clicked():
	var bla = self
	Client.player.get_node("Controller").map_select_system(system_id, self)
	update()

func update():
	$circle.update()
	if data.explored:
		$Label.show()
	else:
		$Label.hide()
func _on_Button_pressed():
	clicked()
