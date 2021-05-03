extends CanvasLayer

func get_default_children():
	return [
		$Equipment,
		$Crafting,
		$Inventory
	]

func get_all_inventory_children():
	return [
		$Equipment,
		$Crafting,
		$Inventory,
		$OtherInventory
	]
