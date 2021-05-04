extends Node

var rotation_change: float
var shooting: bool
var thrusting: bool
var braking: bool

func _physics_process(_delta: float):
	rotation_change = _get_rotation_change()
	shooting = Input.is_action_pressed("shoot")
	braking = Input.is_action_pressed("brakes")
	thrusting = Input.is_action_pressed("thrust") and not braking
	if Input.is_action_just_pressed("toggle_inventory"):
		_toggle_inventory()
	if Input.is_action_just_pressed("toggle_pause"):
		_toggle_pause()
	if Input.is_action_just_pressed("interact"):
		_interact()

func _get_rotation_change():
	var dc = 0
	if Input.is_action_pressed("turn_left"):
		dc -= 1
	if Input.is_action_pressed("turn_right"):
		dc += 1
	return dc
	
func _toggle_inventory():

	var ui = Client.get_ui()
	if get_tree().paused:
		for i in ui.get_all_inventory_children():
			i.hide()
		get_tree().paused = false
	else:
		for i in ui.get_default_children():
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

func _interact():
	var entity = Client.player.get_node("InteractRange").top
	if is_instance_valid(Client.player.get_node("InteractRange").top):
		if entity.has_node("Inventory"):
			var other_inventory = Client.get_ui().get_node("OtherInventory")
			other_inventory.assign(entity.get_node("Inventory"), entity.name)
			other_inventory.show()
		_toggle_inventory()
