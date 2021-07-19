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

signal disabled;

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
		emit_signal("disabled")
	else:
		if not indestructable:
			_destroyed_effects()
			queue_free()


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
			for weapon_slot in $Weapons.get_children():
				weapon_slot.try_shooting()
		
		if position.length() > PLAY_AREA_RADIUS:
			position = Vector2(PLAY_AREA_RADIUS / 2, 0).rotated(anglemod(transform.origin.angle() + PI))
		
		if $Controller.do_jump:
			$Controller.do_jump = false  # Only jump once!
			if $Equipment.can_hyperjump():
				do_jump()
			else:
				Client.alert("Cannot enter hyperspace - craft and equip a hyperdrive")
	
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

func add_weapon(weapon, key):
	$Weapons.get_node(key).add_child(weapon)
	
func remove_weapon(key):
	var weapon = $Weapons.get_node(key).get_children()
	assert(weapon.size() == 1)
	$Weapons.get_node(key).remove_child(weapon[0])
	weapon[0].queue_free()

func add_hyperdrive(drive):
	pass
	
func remove_warpdrive(_index):
	pass
		
func serialize() -> Dictionary:
	return {
		"position": [position.x, position.y],
		"rotation": rotation,
		"inventory": $Inventory.serialize(),
		"health": $Health.serialize(),
		"disabled": disabled,
		"controller": serialize_controller(),
		"equipment": $Equipment.serialize(),
		"type": type
	}

func deserialize(data):
	type = data["type"]
	position = Vector2(data["position"][0], data["position"][1])
	rotation = data["rotation"]
	$Inventory.deserialize(data["inventory"])
	$Health.deserialize(data["health"])
	$Equipment.deserialize(data["equipment"])
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
	$Fullbright.hide()

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
	if has_node("Camera"):
		$Camera.current = true
	else:
		var camera = Camera2D.new()
		camera.name = "Camera"
		add_child(camera)
		camera.current = true
	connect("disabled", self, "_player_disabled")

func do_jump():
	if is_player():
		if $Controller.selected_system:
			Client.exit_system_hyperjump($Controller.selected_system)
		else:
			print("Can't jump, select a system from the map with 'M'")
	else:
		_jump_effects()
		queue_free()

func _player_disabled():
	indestructable = true
	disable_control()
	name = "PlayerHulk"
	Client.player_respawn()
