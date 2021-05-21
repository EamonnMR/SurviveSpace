extends Control

onready var movement = get_node("MarginContainer/NinePatchPanel/MarginContainer2/Panel/Movement")
#onready var movement = self
#onready var movement = get_tree().get_root()
var dragging = false
var link_assoc_buckets = {}
var long_link_assoc_buckets = {}
onready var circle_class = preload("res://ui/map/system.tscn")
onready var lane_class = preload("res://ui/map/hyperlane.tscn")


func _ready():
	print("Init Map")
	for i in Procgen.hyperlanes:
		var lane = lane_class.instance()
		lane.data = i
		lane.name = i.lsys + "_to_" + i.rsys
		lane.hide()
		movement.add_child(lane)
		update_link_assoc_bucket(i.lsys, lane, link_assoc_buckets)
		update_link_assoc_bucket(i.rsys, lane, link_assoc_buckets)
	for i in Procgen.longjumps:
		var long_lane = lane_class.instance()
		long_lane.data = i
		# Note that we omit adding it to the scene.
		# TODO: Make a different sometimes-shown class for longjumps.
		update_link_assoc_bucket(i.lsys, long_lane, long_link_assoc_buckets)
		update_link_assoc_bucket(i.rsys, long_lane, long_link_assoc_buckets)
	for i in Procgen.systems:
		var circle = circle_class.instance()
		circle.system_id = i
		circle.name = i
		circle.hide()
		movement.add_child(circle)
	
	for i in Procgen.systems:
		if Procgen.systems[i].explored:
			update_for_explore(i)
	
func _input(event):
	if event is InputEventMouseButton:
		dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		movement.rect_position += event.relative

func update_link_assoc_bucket(system_id: String, link: Node, buckets: Dictionary):
	if system_id in buckets:
		var bucket = buckets[system_id]
		if not link in bucket:
			bucket.push_back(link)
	else:
		buckets[system_id] = [link]

func update_for_explore(system_id):
	var sys_node = movement.get_node(system_id)
	sys_node.show()
	sys_node.update()
	if system_id in link_assoc_buckets:
		for link in link_assoc_buckets[system_id]:
			link.show()
			movement.get_node(link.data.lsys).show()
			movement.get_node(link.data.rsys).show()
	if system_id in long_link_assoc_buckets:
		for link in long_link_assoc_buckets[system_id]:
			# link.show() #Conditionally show these if the player has a good hyperdrive
			movement.get_node(link.data.lsys).show()
			movement.get_node(link.data.rsys).show()
