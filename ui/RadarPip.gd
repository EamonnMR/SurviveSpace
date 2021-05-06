extends Node2D

var subject: Node2D
var radar_scale = 1.0 / 4
var size: int

onready var radar_offset = get_node("../").rect_size / 2 

var DISPOSITION_COLORS = {
	"hostile": Color(1,0,0),
	"neutral": Color(1,1,0),
	"abandoned": Color(0.5, 0.5, 0.5),
	"player": Color(1,1,1),
	"asteroid": Color(0.5, 0.25, 0)
}

func _relative_position():
	var relative_position = subject.position - Client.player.position
	return relative_position.clamped(radar_offset.x - 5)

func _process(delta):
	# TODO: This is kind of hacky
	if subject == null:
		queue_free()
	else:
		if is_instance_valid(Client.player) and Client.player:
			show()
			if is_instance_valid(subject):
				position = (_relative_position() * radar_scale) + radar_offset
			else:
				queue_free()
		else:
			hide()

func _get_color():
	return DISPOSITION_COLORS["player"]

func get_size():
	return 2

func _draw():
	draw_circle(Vector2(0,0), size, _get_color())
	if size > 3:
		draw_circle(Vector2(0,0), size - 2, Color(0,0,0))

func _ready():
	size = get_size()
