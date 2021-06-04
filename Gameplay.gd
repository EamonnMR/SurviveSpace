extends Node2D

const SERIAL_CHILDREN = [
	"Stations",
	"Asteroids",
	"Pickups",
	"Npcs",
	"Ships"
]

func _get_biome():
	return Procgen.systems[Client.current_system].biome

func _ready():
	var seed_int = 0
	if Client.current_system_data().state:
		deserialize(Client.current_system_data().state)
	else:
		Procgen.do_spawns(seed_int, Client.current_system, _get_biome(), self)

func serialize() -> Dictionary:
	var children = {}
	for child in SERIAL_CHILDREN:
		children[child] = get_each_serialized(get_node(child))
	return children
	
func get_each_serialized(node):
	var list = []
	for child in node.get_children():
		if child.has_method("serialize"):
			list.append({
				"name": child.name,
				"scene": child.filename,
				"state": child.serialize(),
				# "type": child.type
			})
		else:
			print("No Serialization method, discardig: ", child.name)
	return list

func deserialize(data: Dictionary):
	for key in data.keys():
		var node = get_node(key)
		for serial_data in data[key]:
			deserialize_entity(key, serial_data)

func deserialize_entity(destination, serial_data):
	var node = get_node(destination)
	var object = Client.cache_load(serial_data["scene"]).instance()
	object.deserialize(serial_data["state"])
	object.name = serial_data["name"]
	node.add_child(object)
