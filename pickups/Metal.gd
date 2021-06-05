extends RigidBody2D

var type = "metal"
var count = 1

func _on_PickupRange_body_entered(body):
	if body.has_method("is_player") and body.is_player():
		body.get_node("Inventory").add(type, count)
		queue_free()

func serialize() -> Dictionary:
	return {
		"position": position
	}

func deserialize(data):
	position = data["position"]
