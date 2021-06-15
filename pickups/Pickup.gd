extends RigidBody2D

export var type = ""

func _ready():
	$Sprite.texture = Data.items[type].icon

func _on_PickupRange_body_entered(body):
	if body.has_method("is_player") and body.is_player():
		body.get_node("Inventory").add(type, 1)
		queue_free()

func serialize() -> Dictionary:
	return {
		"type": type,
		"position": [position.x, position.y]
	}

func deserialize(data):
	type = data["type"]
	position = Vector2(data["position"][0], data["position"][1])

