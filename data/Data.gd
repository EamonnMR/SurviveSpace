extends Node

var items = {}
var recipes = {}
var builds = {}
var spawns = {}
var biomes = {}
var ships = {}

# Game constants:
const PLAY_AREA_RADIUS = 3000
# const JUMP_RADIUS = 2000

func _init():
	for data_class_and_destination in [
		[ItemData, items],
		[RecipeData, recipes],
		[BuildData, builds],
		[SpawnData, spawns],
		[BiomeData, biomes],
		[ShipData, ships]
	]:
		var DataClass = data_class_and_destination[0]
		var dest = data_class_and_destination[1]
		var data = DataRow.load_csv(DataClass.get_csv_path())
		for key in data:
			dest[key] = DataClass.new(data[key])
	# Tests
	assert_ingredients_exist()
	
func assert_ingredients_exist():
	# Test to prove that no recipes require nonexistent items
	for craftable_type in [
		recipes,
		builds,
		ships
	]:
		for recipe_id in craftable_type:
			var recipe: RecipeData = recipes[recipe_id]
			for key in recipe.ingredients:
				assert(key in items)

