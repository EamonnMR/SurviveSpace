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
			var icon = ItemIcon.new(item)
			slot_container.add_child(icon)
		grid_container.add_child(slot_container)
