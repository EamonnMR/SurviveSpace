extends RigidBody2D

const LOOT_COUNT = 5

func _ready():
	Client.add_radar_pip(self)

func explode():
	# TODO
	pass

func drop_loot():
	var destination = get_node("../../Pickups")
	for _i in range(LOOT_COUNT):
		var pickup = preload("pickups/Metal.tscn").instance()
		pickup.linear_velocity = Vector2(rand_range(1,100), 0).rotated(rand_range(0, 2 * PI))
		destination.add_child(pickup)

func _on_Health_ran_out():
	explode()
	drop_loot()
	queue_free()
