extends KinematicBody2D

class_name Ship

const PLAY_AREA_RADIUS = 3000

var max_speed = 0
var accel = 0
var turn = 0

var has_turrets = false
var standoff = false
var wimpy = false
var joust = true

var indestructable = false

var disabled = false

var linear_velocity = Vector2()

var type: String
var data: ShipData

export var crafting_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_stats()
	Client.add_radar_pip(self)
	$Health.connect("ran_out", self, "_health_ran_out")
	$Health.connect("took_damage", self, "_took_damage")
	
func _health_ran_out():
	if not disabled:
		disabled = true
		Client.entity_became_interactive(self)
		remove_child($Controller)
		add_child(preload("res://ships/ShipController.tscn").instance())
		_disabled_effects()
		$EngineEffects.off()
		set_disabled_texture()
		if is_player():
			indestructable = true
			disable_control()
			name = "PlayerHulk"
			# Client.player_respawn()
	else:
		if not indestructable:
			pass
			#_destroyed_effects()
			#queue_free()


func _disabled_effects():
	pass

func _destroyed_effects():
	pass

func _took_damage(from):
	# TODO: get angry?
	pass

func apply_stats():
	data = Data.ships[type]
	data.apply(self)

func _physics_process(delta):
	if not disabled:
		linear_velocity = get_limited_velocity_with_thrust(delta)
		rotation += delta * turn * $Controller.rotation_change
		move_and_slide(linear_velocity)
		if $Controller.shooting:
			for weapon in $Weapons.get_children():
				weapon.try_shooting()
		
		if position.length() > PLAY_AREA_RADIUS:
			position = Vector2(PLAY_AREA_RADIUS / 2, 0).rotated(anglemod(transform.origin.angle() + PI))

		if $Controller.do_jump:
			$Controller.do_jump = false  # Only jump once!
			do_jump()
	
func _jump_effects():
	pass

func get_limited_velocity_with_thrust(delta):
	if $Controller.thrusting:
		linear_velocity += Vector2(accel * delta * 100, 0).rotated(rotation)
		$EngineEffects.on()
	else:
		$EngineEffects.off()
	if linear_velocity.length() > max_speed:
		return Vector2(max_speed, 0).rotated(linear_velocity.angle())
	else:
		return linear_velocity

func wrap_position(state):
	var transform = state.get_transform()
	if position.length() > PLAY_AREA_RADIUS:
		position = Vector2(PLAY_AREA_RADIUS / 2, 0).rotated(anglemod(transform.origin.angle() + PI))

func is_player() -> bool:
	if has_node("Controller"):
		return $Controller.is_player()
	else:
		return false

func anglemod(angle):
	"""I wish this was a builtin"""
	var ARC = 2 * PI
	# TODO: Recursive might be too slow
	return fmod(angle + ARC, ARC)

func add_weapon(weapon, _index):
	$Weapons.add_child(weapon)
	
func remove_weapon(_index):
	for child in $Weapons.get_children():
		$Weapons.remove_child(child)

func add_hyperdrive(drive):
	var root = get_tree().get_root()
	var game = root.get_node("Game")
	root.remove_child(game)
	game.queue_free()
	root.add_child(preload("res://ui/WinScreen.tscn").instance())
	
func remove_warpdrive(_index):
	pass

func get_weapon(_index):
	var children = $Weapons.get_children()
	if children.size() == 1:
		return children[0]
	else:
		return null
		
func serialize() -> Dictionary:
	return {
		"position": [position.x, position.y],
		"rotation": rotation,
		"inventory": $Inventory.serialize(),
		"health": $Health.serialize(),
		"disabled": disabled,
		"controller": serialize_controller()
	}

func deserialize(data):
	position = Vector2(data["position"][0], data["position"][1])
	rotation = data["rotation"]
	$Inventory.deserialize(data["inventory"])
	$Health.deserialize(data["health"])
	disabled = data["disabled"]
	if data["controller"]:
		add_child(deserialize_controller(data["controller"]))
	if disabled:
		set_disabled_texture()

func serialize_controller():
	true if has_node("Controller") else null

func deserialize_controller(_controller_data) -> Node:
	return load("res://spawns/aliens/AlienController.gd").instance()

func set_disabled_texture():
	$SpriteDisabled.show()
	$Sprite.hide()

func can_interact():
	return disabled

func disable_control():
	remove_child($Controller)
	remove_child($Camera2D)
	add_child(preload("res://ships/ShipController.tscn").instance())
	$EngineEffects.off()
	
func enable_control():
	remove_child($Controller)
	add_child(preload("res://ships/PlayerController.tscn").instance())
	var camera = Camera2D.new()
	add_child(camera)
	camera.current = true

func do_jump():
	if is_player():
		if $Controller.selected_system:
			Client.exit_system_hyperjump($Controller.selected_system)
		else:
			print("Can't jump, select a system from the map with 'M'")
	else:
		_jump_effects()
		queue_free()
