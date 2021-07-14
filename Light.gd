extends Node2D

func _ready():
	print("Setting light color")
	$StarLight.color = Procgen.systems[Client.current_system].starlight_color
	$AmbientLight.color = Procgen.systems[Client.current_system].ambient_color
