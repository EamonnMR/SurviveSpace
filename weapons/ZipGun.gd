extends Node2D
var cooldown = false

class_name Weapon
export var type: String = "zipgun"

func parent():
	return get_node("../../")

func projectile_dest():
	return parent().get_node("../../Projectiles")

func try_shooting():
	if not cooldown:
		_shoot()

func _shoot():
	$MuzzleSparks.restart()
	$MuzzleSparks.emitting = true
	var bullet = _get_bullet()
	bullet.position = global_position
	bullet.setup(parent())
	cooldown = true
	$Timer.start()
	#$AudioStreamPlayer2D.play()
	projectile_dest().add_child(bullet)

func _on_Timer_timeout():
	cooldown = false

func _get_bullet():
	return preload("res://weapons/zipgun_proj.tscn").instance()
