extends Node2D

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
