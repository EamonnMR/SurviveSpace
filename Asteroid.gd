extends RigidBody2D

func explode():
	# TODO
	pass

func drop_loot():
	# TODO
	pass

func _on_Health_ran_out():
	explode()
	drop_loot()
	queue_free()
