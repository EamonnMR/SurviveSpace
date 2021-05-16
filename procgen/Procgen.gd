extends Node

var RADIUS = 1000
var DENSITY = 1.0/3000.0
var SYSTEMS_COUNT = int(RADIUS * RADIUS * DENSITY)
var systems = {}
var hyperlanes = []
var longjumps = []
var MIN_DISTANCE = 50
var MAX_LANE_LENGTH = 130
var MAX_GROW_ITERATIONS = 3
var SEED_DENSITY = 1.0/5.0

func _random_location_in_system():
	return random_circular_coordinate(1000)

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
		
		var first_pos = points[link_mesh[i]]
		var second_pos = points[link_mesh[i+1]]
		var third_pos = points[link_mesh[i+2]]
		
		var first = systems_by_position[first_pos]
		var second = systems_by_position[second_pos]
		var third = systems_by_position[third_pos]
		
		if Vector2(first_pos).distance_to(second_pos) < MAX_LANE_LENGTH:
			hyperlanes.append(HyperlaneData.new(first, second))
		else:
			longjumps.append(HyperlaneData.new(first, second))
		if Vector2(first_pos).distance_to(third_pos) < MAX_LANE_LENGTH:
			hyperlanes.append(HyperlaneData.new(first, third))
		else:
			longjumps.append(HyperlaneData.new(first, third))
		if Vector2(second_pos).distance_to(third_pos) < MAX_LANE_LENGTH:
			hyperlanes.append(HyperlaneData.new(second, third))
		else:
			longjumps.append(HyperlaneData.new(second, third))
	
	cache_links()
	
	# Select seed systems for biomes
	
	var seed_biomes = []
	for biome_id in Data.biomes:
		if Data.biomes[biome_id].do_seed:
			seed_biomes.append(biome_id)
	
	
	var seed_count = int(systems.size() * SEED_DENSITY)
	print("Seed count: ", seed_count)
	var seeds_planted = 0
	while seeds_planted < seed_count:
		var biome_id = random_select(seed_biomes)
		var system_id = random_select(systems.keys())
		if not systems[system_id].biome:
			systems[system_id].biome = biome_id
			seeds_planted += 1
	# Player start system always gets the "start" biome
	systems["0"].biome = "start"
	
	# Grow Seeds
	for _i in MAX_GROW_ITERATIONS:
		print("Growing Seeds")
		for system in systems.values():
			if not system.biome:
				var possible_biomes = []
				
				# Preferentially use the links cache
				for list in [system.links_cache, system.long_links_cache]:
					for link in list:
						var other_system = systems[link]
						if other_system.biome and Data.biomes[other_system.biome].grow:
							possible_biomes.append(other_system.biome)
				if possible_biomes.size():
					print(possible_biomes)
					system.biome = random_select(possible_biomes)
						
	# Fill in any systems that somehow fell through the cracks
	for system in systems.values():
		if not system.biome:
			system.biome = "empty"
			
func cache_links():
	for lane in hyperlanes:
		var lsys = systems[lane.lsys]
		var rsys = systems[lane.rsys]
		if not lane.rsys in lsys.links_cache:
			lsys.links_cache.append(lane.rsys)
		if not lane.lsys in rsys.links_cache:
			rsys.links_cache.append(lane.lsys)
	
	for lane in longjumps:
		var lsys = systems[lane.lsys]
		var rsys = systems[lane.rsys]
		if not lane.rsys in lsys.links_cache:
			lsys.long_links_cache.append(lane.rsys)
		if not lane.lsys in rsys.links_cache:
			rsys.long_links_cache.append(lane.lsys)


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
	
func random_select(iterable):
	""" Remember to seed the rng"""
	return iterable[randi() % iterable.size()]
