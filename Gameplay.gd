extends Node2D

func _ready():
	var seed_int = 0
	Procgen.generate_systems(seed_int)
	Procgen.do_spawns(seed_int, "0", "start", self)
