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
	assert_spawns_exist()
	
func assert_ingredients_exist():
	# Test to prove that no recipes require nonexistent items
	for craftable_type in [
		recipes,
		builds,
		ships
	]:
		for blueprint_id in craftable_type:
			var blueprint = craftable_type[blueprint_id ]
			for key in blueprint.ingredients:
				assert(key in items)

func assert_spawns_exist():
	for biome_id in biomes:
		var biome = biomes[biome_id]
		for spawn_id in biome.spawns:
			assert(spawn_id in spawns)
