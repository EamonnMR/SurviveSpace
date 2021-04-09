extends RigidBody2D

export var speed = 600
export var damage = 1
var parent: Node = null

func setup(parent):
	self.parent = parent
	linear_velocity = Vector2(speed, 0).rotated(parent.rotation)
	$Sprite.rotate(parent.rotation)
	
func _integrate_forces(state):
	set_applied_torque(0)  # No rotation component
	rotation = 0.0

func _on_Area2D_body_entered(body):
	if body == parent:
		pass
	else:
		# explode()
		if body.has_node("Health"):
			body.get_node("Health").take_damage(damage)
		queue_free()

func _on_Timer_timeout():
	queue_free()

