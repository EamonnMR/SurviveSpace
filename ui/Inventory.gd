extends Control

var inventory_slot = preload("res://ui/EquipBox.tscn")

onready var grid_container = get_node("NinePatchPanel/MarginContainer/VBoxContainer/ScrollContainer/GridContainer")

func _rebuild():
	var inv: Inventory = Client.player.get_node("inventory")
	for i in range(inv.max_items):
		var slot_container = grid_container.instance()
		if i in inv.item_slots:
			var item: Inventory.InvItem = inv.item_slots[i]
			var icon = TextureRect.new()
			icon.texture = Data.items[item.type].icon
			slot_container.add_child(icon)
