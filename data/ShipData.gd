extends DataRow

class_name ShipData

var id: String
var type_name: String
var ingredients: Dictionary
var require_level: int
var max_speed: float
var accel: float
var turn: float
var health: int
var inventory_size: int
var armor_slots: int
var scene: PackedScene
var desc: String
var icon: Texture

func _init(data: Dictionary):
	init(data)
	ingredients = parse_colon_dict_int_values(data["ingredients"])
	
func apply(ship):
	apply_to_node(ship)
	ship.get_node("Health").max_health = health

static func get_csv_path():
	return "res://data/ships.csv"
