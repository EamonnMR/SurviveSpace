extends Node2D

func _ready():
	var starlight = Procgen.systems[Client.current_system].starlight_color
	var ambient = Procgen.systems[Client.current_system].ambient_color
	$StarLight.color = starlight
	$AmbientLight.color = ambient
