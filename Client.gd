extends Node

var player
var current_system: String = "0"
var spawn_point: String = "0"
var player_name: String = ""
var game_seed: int

signal system_selection_updated
signal became_interactive(entity)

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
	explore_system(new_system)
	player.get_node("../").remove_child(player)
	var game = get_tree().root.get_node("Game")
	var old_gameplay = game.get_node("Gameplay")
	current_system_data().state = old_gameplay.serialize()
	current_system = new_system
	_get_background_node().set_background_for_current_system()
	game.remove_child(old_gameplay)
	old_gameplay.queue_free()
	game.add_child(preload("res://Gameplay.tscn").instance())
	spawn_player()
	
func player_respawn():
	# TODO: Mark system with skull to remind them it's where they died
	var game = get_tree().root.get_node("Game")
	var old_gameplay = game.get_node("Gameplay")
	current_system_data().state = old_gameplay.serialize()
	current_system = spawn_point
	_get_background_node().set_background_for_current_system()
	game.remove_child(old_gameplay)
	old_gameplay.queue_free()
	game.add_child(preload("res://Gameplay.tscn").instance())
	respawn_player()
	

func respawn_player():
	player = preload("res://ships/Player.tscn").instance()
	spawn_player()
	setup_player()

func setup_player():
	player.get_node("Inventory").connect("updated", get_ui().get_node("Crafting"), "rebuild")
	get_ui().get_node("Inventory").assign(player.get_node("Inventory"), "Inventory")
	player.enable_control()
	
func spawn_player():
	get_player_dest().add_child(player)

func start_new_game(game_seed, player_name):
	self.player_name = player_name
	self.game_seed = game_seed
	Procgen.generate_systems(game_seed)
	var game = preload("res://Game.tscn").instance()
	get_tree().get_root().add_child(game)
	_get_background_node().set_background_for_current_system()
	explore_system(current_system)
	respawn_player()
	save_game()
	
func current_system_data():
	return Procgen.systems[current_system]

func cache_load(path):
	return load(path)
	
func explore_system(system):
	Procgen.systems[system].explored = true
	get_ui().get_node("Map").update_for_explore(system)

func map_select_system(system_id, system_node):
	player.get_node("Controller").map_select_system(system_id, system_node)
	emit_signal("system_selection_updated")

func _get_background_node():
	return get_tree().get_root().get_node("Game/Background/Control/Starfield")

func entity_became_interactive(entity):
	emit_signal("became_interactive", entity)

func savefile_name(player_name: String) -> String:
	return "user://" + player_name.split(" ")[-1] + ".json"

func save_game():
	var save_game = File.new()
	save_game.open(savefile_name(player_name), File.WRITE)
	save_game.store_line(to_json(serialize()))
	save_game.close()


func serialize() -> Dictionary:
	# Save the current system's state so it ends up in the procgen.serialize dump
	current_system_data().state = get_tree().root.get_node("Game/Gameplay").serialize()
	
	return {
		"procgen": Procgen.serialize(),
		"player": player.get_path(), # The actual data for the player is in the procgen dump
		"current_system": current_system,
		"spawn_point": spawn_point,
		"player_name": player_name,
		"game_seed": game_seed,
	}

func load_game():
	# TODO: Open file to get blob
	deserialize({})

func deserialize(save_blob: Dictionary):
	
	# Load the procedurally generated world and world state
	Procgen.deserialize(save_blob["procgen"])
	
	# Load client vars
	current_system = save_blob["current_system"]
	spawn_point = save_blob["spawn_point"]
	player_name = save_blob["player_name"]
	game_seed = save_blob["game_seed"]
	
	# Set up gameplay
	var game = get_tree().root.get_node("Game")
	game.add_child(preload("res://Gameplay.tscn").instance())
	
	# Set up the player by first getting the right ent, then applying the camera to it
	player = get_tree().root.get_node[save_blob["player"]]
	setup_player()
