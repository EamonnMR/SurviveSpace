extends DataRow

class_name RecipeData

var id: String
var prod_type: String
var prod_count: int
var require_level: int
var ingredients: Dictionary

func _init(data: Dictionary):
	init(data)
	ingredients = parse_colon_dict_int_values(data["ingredients"])
	
static func get_csv_path():
	return "res://data/recipes.csv"
