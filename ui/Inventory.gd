extends Control

var inventory_slot = preload("res://ui/EquipBox.tscn")

onready var grid_container = get_node("NinePatchPanel/MarginContainer/VBoxContainer/ScrollContainer/GridContainer")

func _clear():
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		
func rebuild():
	_clear()
	var inv: Inventory = Client.player.get_node("Inventory")
	for i in range(inv.max_items):
		var slot_container = inventory_slot.instance()
		if i in inv.item_slots:
			var item: Inventory.InvItem = inv.item_slots[i]
			var icon = TextureRect.new()
			icon.texture = Data.items[item.type].icon
			icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
			icon.anchor_right = 1
			icon.anchor_bottom = 1
			slot_container.add_child(icon)
		grid_container.add_child(slot_container)
