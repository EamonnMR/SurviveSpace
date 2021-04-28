extends Node

var items = {}
var recipes = {}
var builds = {}

func _init():
	for data_class_and_destination in [
		[ItemData, items],
		[RecipeData, recipes],
		[BuildData, builds]
	]:
		var DataClass = data_class_and_destination[0]
		var dest = data_class_and_destination[1]
		var data = DataRow.load_csv(DataClass.get_csv_path())
		for key in data:
			dest[key] = DataClass.new(data[key])
	# Tests
	assert_ingredients_exist()

func assert_ingredients_exist():
	for recipe_id in recipes:
		var recipe: RecipeData = recipes[recipe_id]
		for key in recipe.ingredients:
			assert(key in items)
