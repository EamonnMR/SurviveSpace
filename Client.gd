extends Node

var player

func get_ui():
	var bla = get_tree().root.get_node("Game/UI")
	return bla

func add_radar_pip(subject):
	var pip = preload("res://ui/RadarPip.tscn").instance()
	pip.subject = subject
	get_ui().get_node("Hud/Radar").add_child(pip)
