extends StaticBody2D

func can_interact():
	return true

func _ready():
	Client.add_radar_pip(self)
	Client.entity_became_interactive(self)

func serialize() -> Dictionary:
	return {
		"position": [position.x, position.y],
		"inventory": $Inventory.serialize()
	}

func deserialize(data):
	position = Vector2(data["position"][0], data["position"][1])
	$Inventory.deserialize(data["inventory"])
