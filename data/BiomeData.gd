extends DataRow

class_name BiomeData

var id: String
var name: String
var spawns: Array
var map_color: Color
var do_seed: bool
var grow: bool
var background: Texture

func _init(data: Dictionary):
	init(data)
	spawns = parse_string_array(data["spawns"])

static func get_csv_path():
	return "res://data/biomes.csv"
