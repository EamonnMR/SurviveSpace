extends RigidBody2D

export var loot = {} # keys: loot type values: loot 
var exploded = false

func _ready():
	Client.add_radar_pip(self)

func explode():
	var explo: Particles2D = $Explosion
	if is_instance_valid(explo):
		remove_child(explo)
		get_node("../../Effects").add_child(explo)
		explo.position = position
		explo.emitting = true
		# TODO: Play Sound

func drop_loot():
	var destination = get_node("../../Pickups")
	for loot_type in loot:
		for _i in range(loot[loot_type]):
			var pickup = preload("../pickups/Pickup.tscn").instance()
			pickup.type = loot_type
			pickup.position = position
			pickup.linear_velocity = Vector2(rand_range(1,100), 0).rotated(rand_range(0, 2 * PI))
			destination.add_child(pickup)

func _on_Health_ran_out():
	if not exploded:
		var exploded = true
		explode()
		drop_loot()
		queue_free()
	
func serialize() -> Dictionary:
	return {
		"position": [position.x, position.y],
		"health": $Health.serialize()
	}

func deserialize(data):
	position = Vector2(data["position"][0], data["position"][1])
	$Health.deserialize(data["health"])
