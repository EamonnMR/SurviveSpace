extends DataRow

class_name ItemData

var id: String
var name: String
var equip_category: String
var icon: Texture
var tooltip: String
var stackable: bool

func _init(data: Dictionary):
	init(data)
	
static func get_csv_path():
	return "res://data/items.csv"
