extends Node

export var slot_counts_by_type = {}
export var equipped_items_by_type = {}

var weapons = {}
var armors = {}
var hyperdrive = null
var reactors = {}
var utilities = {}

func _ready():
	# Determine weapon slots by the ship
	var parent = get_node("../Weapons")

func can_equip_item(item: Inventory.InvItem) -> bool:
	return (
		item.data().equip_category in slot_counts_by_type
		and slot_counts_by_type[item.type] > equipped_items_by_type[item.type].size()
	)
	
func equip_item(item: Inventory.InvItem) -> bool:
	if not (can_equip_item(item)):
		return false
	var category = item.data().equip_category
	equipped_items_by_type[category].append(item)
	# TODO: if category = weapon 
	return true
	
func serialize() -> Dictionary:
	var equipped_data = {}
	for type in slot_counts_by_type:
		data[slot] = {
			"type": item_slots[slot].type,
			"count": item_slots[slot].count
		}
	return {
		"slot_counts_by_type": slot_counts_by_type,
		"equipped_items_by_type": equipped_items_by_type
	}
	
func deserialize(data):
	slot_counts_by_type = data["slot_counts_by_type"]
	
	for type in data["equipped_items_by_type"]:
		equipped_items_by_type[type] = []
		for item in data["equipped_items_by_type"][type]:
			var item_data = data[slot]
			equipped_items_by_type[type].append(Inventory.InvItem.new(
				item_data.type,
				int(item_data.count)
			)
