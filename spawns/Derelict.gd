extends KinematicBody2D

func _ready():
	Client.add_radar_pip(self)

func can_interact():
	return true

func serialize() -> Dictionary:
	return {
		"position": [position.x, position.y],
		"inventory": $Inventory.serialize()
	}

func deserialize(data):
	position = Vector2(data["position"][0], data["position"][1])
	$Inventory.deserialize(data["inventory"])
