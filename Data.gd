extends Node

var items = {}
var recipes = {}

func _init():
	for data_class_and_destination in [
		[ItemData, items],
		[RecipeData, recipes]
	]:
		var DataClass = data_class_and_destination[0]
		var dest = data_class_and_destination[1]
		var data = DataRow.load_csv(DataClass.get_csv_path())
		for key in data:
			dest[key] = DataClass.new(data[key])
