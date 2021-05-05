extends DataRow

class_name BiomeData

var id: String
var spawns: Array

func _init(data: Dictionary):
	init(data)
	spawns = parse_string_array(data["spawns"])

static func get_csv_path():
	return "res://data/biomes.csv"
