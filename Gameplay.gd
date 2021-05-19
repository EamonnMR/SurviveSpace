extends Node2D

func _get_biome():
	return Procgen.systems[Client.current_system].biome

func _ready():
	var seed_int = 0
	Procgen.do_spawns(seed_int, Client.current_system, _get_biome(), self)
