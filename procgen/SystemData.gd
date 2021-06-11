class_name SystemData

var id: String
var name: String
var position: Vector2
var biome: String
var links_cache: Array
var long_links_cache: Array
var state: Dictionary
var explored: bool

func serialize():
	return {
		"id": id,
		"name": name,
		"position": [position.x, position.y],
		"biome": biome,
		"links_cache": links_cache,
		"long_links_cache": long_links_cache,
		"state": state,
		"explored": int(explored)
	}

func deserialize(data: Dictionary):
	id = data["id"]
	name = data["name"]
	position = Vector2(data["position"][0], data["position"][1])
	biome = data["biome"]
	links_cache = data["links_cache"]
	long_links_cache = data["long_links_cache"]
	state = data["state"]
	explored = bool(data["explored"])
