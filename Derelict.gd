extends KinematicBody2D

func _ready():
	Client.add_radar_pip(self)

func can_interact():
	return true

func serialize() -> Dictionary:
	return {
		"position": position,
		"inventory": $Inventory.serialize()
	}

func deserialize(data):
	position = data["position"]
	$Inventory.deserialize(data["inventory"])
