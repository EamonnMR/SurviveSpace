extends Node

const SYSTEMS_COUNT = 100
const RADIUS = 500
var systems = {}
var hyperlanes = []
var MIN_DISTANCE = 50

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

func generate_systems(seed_value: int):
	var systems_by_position = {}
	for i in SYSTEMS_COUNT:
		var system_id = str(i)
		rand_seed(seed_value + i * i)
		var system = SystemData.new()
		system.id = system_id
		# Avoid overlap
		var position = _get_non_overlapping_position()
		if position:
			system.position = position
			systems[system_id] = system
			systems_by_position[position] = system_id
	var points = PoolVector2Array(systems_by_position.keys())
	var link_mesh = Geometry.triangulate_delaunay_2d(points)
	for i in range(0, link_mesh.size(), 3):
		var first = systems_by_position[points[link_mesh[i]]]
		var second = systems_by_position[points[link_mesh[i+1]]]
		var third = systems_by_position[points[link_mesh[i+2]]]
		hyperlanes.append(HyperlaneData.new(first, second))
		hyperlanes.append(HyperlaneData.new(first, third))
		hyperlanes.append(HyperlaneData.new(second, third))

func _get_non_overlapping_position():
	var max_iter = 10
	var bad_position = true
	var position = Vector2()
	for i in range(max_iter):
		position = random_circular_coordinate(RADIUS)
		bad_position = false
		for key in systems:
			var other_system: SystemData = systems[key]
			if other_system.position.distance_to(position) < MIN_DISTANCE:
				bad_position = true
				break
		if not bad_position:
			return position
	print("Cannot find a suitable position for system in ", max_iter, " iterations")
	return null

func randi_radius(radius):
	return (randi() % (2 * radius)) - radius

func random_circular_coordinate(radius) -> Vector2:
	"""Remember to seed first if desired"""
	var position: Vector2
	while not position or position.length() > radius:
		position = Vector2(self.randi_radius(radius), self.randi_radius(radius))
	return position
