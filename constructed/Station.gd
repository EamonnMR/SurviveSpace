extends StaticBody2D

func can_interact():
	return true

func _ready():
	Client.add_radar_pip(self)

func serialize() -> Dictionary:
	return {
		"position": position,
		"inventory": $Inventory.serialize()
	}

func deserialize(data):
	position = data["position"]
	$Inventory.deserialize(data["inventory"])
