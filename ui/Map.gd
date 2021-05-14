extends Control

onready var movement = get_node("MarginContainer/NinePatchPanel/MarginContainer2/Panel/Movement")
var dragging = false
onready var circle_class = preload("res://ui/system.tscn")
func _ready():
	for i in Procgen.systems:
		var circle = circle_class.instance()
		circle.system_id = i
		movement.add_child(circle)

func _input(event):
	if event is InputEventMouseButton:
		dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		movement.position += event.relative
