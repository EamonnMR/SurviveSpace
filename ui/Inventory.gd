extends Control

var inventory_slot = preload("res://ui/EquipBox.tscn")
var item_icon = preload("res://ui/ItemIcon.tscn")

onready var grid_container = get_node("NinePatchPanel/MarginContainer/VBoxContainer/ScrollContainer/GridContainer")

func _ready():
	Client.player.get_node("Inventory").connect("updated", self, "rebuild")

func _clear():
	for child in grid_container.get_children():
		grid_container.remove_child(child)

func _player_inventory():
	return Client.player.get_node("Inventory")

func rebuild():
	_clear()
	var inv: Inventory = _player_inventory()
	for i in range(inv.max_items):
		var slot_container = inventory_slot.instance()
		slot_container.connect("item_removed", self, "_on_item_removed", [i])
		slot_container.connect("item_added", self, "_on_item_added", [i])
		if i in inv.item_slots:
			var item: Inventory.InvItem = inv.item_slots[i]
			var icon = item_icon.instance()
			icon.init(item)
			slot_container.add_child(icon)
		grid_container.add_child(slot_container)

func _on_item_added(item, slot):
	_player_inventory().add(item.type, item.count, slot)

func _on_item_removed(slot):
	_player_inventory().remove_item_from_slot(slot)
