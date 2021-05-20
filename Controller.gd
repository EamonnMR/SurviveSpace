extends Node

var rotation_change: float
var shooting: bool
var thrusting: bool
var braking: bool
var do_jump: bool
var selected_system: String
var selected_system_circle_cache: Array =  []

func _physics_process(_delta: float):
	rotation_change = _get_rotation_change()
	shooting = Input.is_action_pressed("shoot")
	braking = Input.is_action_pressed("brakes")
	thrusting = Input.is_action_pressed("thrust") and not braking
	if Input.is_action_just_pressed("toggle_inventory"):
		_toggle_inventory([])
	if Input.is_action_just_pressed("toggle_pause"):
		_toggle_pause()
	if Input.is_action_just_pressed("toggle_map"):
		_toggle_map()
	if Input.is_action_just_pressed("interact"):
		_interact()
	if Input.is_action_just_pressed("jump"):
		do_jump = true

func _get_rotation_change():
	var dc = 0
	if Input.is_action_pressed("turn_left"):
		dc -= 1
	if Input.is_action_pressed("turn_right"):
		dc += 1
	return dc
	
func _toggle_inventory(elements: Array = []):
	var ui = Client.get_ui()

	if get_tree().paused:
		for i in ui.get_all_inventory_children():
			i.hide()
			if i.has_method("unassign"):
				i.unassign()
		get_tree().paused = false
	else:
		if elements.size() == 0:
			elements = ui.get_default_children()
		else:
			for i in range(elements.size()):
				elements[i] = ui.get_node(elements[i])
				
		for i in elements:
			i.rebuild()
			i.show()
		get_tree().paused = true

func _toggle_pause():
	var pause_menu = Client.get_ui().get_node("PauseMenu")
	if get_tree().paused:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true

func _toggle_map():
	var map = Client.get_ui().get_node("Map")
	if get_tree().paused:
		map.hide()
		get_tree().paused = false
	else:
		map.show()
		get_tree().paused = true

func _interact():
	var entity = Client.player.get_node("InteractRange").top
	if is_instance_valid(Client.player.get_node("InteractRange").top):
		var interaction_modes = []
		if entity.has_node("Inventory"):
			Client.get_ui().get_node("OtherInventory").assign(entity.get_node("Inventory"), entity.name)
			interaction_modes += ["Inventory", "OtherInventory"]
		if entity.has_node("CraftingLevel"):
			Client.get_ui().get_node("Crafting").assign(entity.get_node("CraftingLevel"))
			interaction_modes += ["Crafting"]
		_toggle_inventory(interaction_modes)

func map_select_system(system_id: String, node):
	selected_system = system_id
	for old_node in selected_system_circle_cache:
		old_node.update()
	selected_system_circle_cache = [node]
	# TODO: If we're in immediate jump mode, toggle out of the map and initiate a jump
