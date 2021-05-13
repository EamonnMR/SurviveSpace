extends Node

func _random_location_in_system():
	return Vector2(rand_range(-1000, 1000), rand_range(-1000, 1000))

func do_spawns(seed_value: int, system_id: String, biome: String, gameplay: Node):
	var biome_data: BiomeData = Data.biomes[biome]
	rand_seed(seed_value + system_id.hash())
	for spawn_id in biome_data.spawns:
		var spawn: SpawnData = Data.spawns[spawn_id]
		for _i in range(spawn.count):
			if spawn.chance >= randf():
				var position = _random_location_in_system()
				var instance: Node = spawn.scene.instance()
				instance.position = position
				gameplay.get_node(spawn.destination).add_child(instance)

func generate_systems():
	pass
