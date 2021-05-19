extends Control

onready var movement = get_node("MarginContainer/NinePatchPanel/MarginContainer2/Panel/Movement")
#onready var movement = self
#onready var movement = get_tree().get_root()
var dragging = false
onready var circle_class = preload("res://ui/map/system.tscn")
onready var lane_class = preload("res://ui/map/hyperlane.tscn")
func _ready():
	print("Init Map")
	for i in Procgen.hyperlanes:
		var lane = lane_class.instance()
		lane.data = i
		movement.add_child(lane)
	for i in Procgen.systems:
		var circle = circle_class.instance()
		circle.system_id = i
		movement.add_child(circle)

func _input(event):
	if event is InputEventMouseButton:
		dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		movement.rect_position += event.relative
