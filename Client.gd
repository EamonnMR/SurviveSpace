extends Node

var player
var current_system = "0"

func get_ui():
	var bla = get_tree().root.get_node("Game/UI")
	return bla

func get_player_dest():
	return get_tree().root.get_node("Game/Gameplay/Ships")

func add_radar_pip(subject):
	var pip = preload("res://ui/RadarPip.tscn").instance()
	pip.subject = subject
	get_ui().get_node("Hud/Radar").add_child(pip)

func current_system_id():
	return current_system

func exit_system_hyperjump(new_system):
	player.get_node("../").remove_child(player)
	current_system = new_system
	var game = get_tree().root.get_node("Game")
	var old_gameplay = game.get_node("Gameplay")
	# TODO: Dump State?
	game.remove_child(old_gameplay)
	old_gameplay.queue_free()
	game.add_child(preload("res://Gameplay.tscn").instance())
	spawn_player()
	
func spawn_player():
	get_player_dest().add_child(player)

func start_new_game():
	Procgen.generate_systems(0)
	player = preload("res://ships/Player.tscn").instance()
	var game = preload("res://Game.tscn").instance()
	get_tree().get_root().add_child(game)
	spawn_player()
