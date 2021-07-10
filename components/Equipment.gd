extends Node

# This is populated by the weapon slot nodes in ../Weapons/
var weapons = {}

var max_armors: int
var armors = {}
var max_shields = 1
var shields = {}
var max_hyperdrives = 1
var hyperdrives = {}
var max_reactors = 1
var reactors = {}

var slot_keys = {
	"armor": armors,
	"shields": shields,
	"hyperdrive": hyperdrives,
	"reactor": reactors,
	"weapon": weapons
}
func _ready():
	# Determine weapon slots by the ship
	var parent = get_node("../")
	for weapon_slot in parent.get_node("Weapons").get_children():
		weapons[weapon_slot.name]
		
	max_armors = parent.data.max_armors
	
	for i in [
		[max_armors, armors],
		[max_shields, shields],
		[max_hyperdrives, hyperdrives],
		[max_reactors, reactors]
	]:
		var slots = i[1]
		for j in range(i[0]):
			var key = str(j)
			if not(key in slots):
				slots[key] = null

func equip_item(item: Inventory.InvItem, key, category):
	assert(item.data().equip_category == category)
	assert(key in slot_keys[category])
	assert(key in slot_keys[category][key] == null)
	slot_keys[category][key] = item
	
	if category == "weapon":
		Client.player.add_weapon(preload("res://weapons/ZipGun.tscn").instance(), "WeaponSlot")

func serialize() -> Dictionary:
	var slots = {}
	for group_name in slot_keys:
		group = slot_keys[group_name]
		var slot_data = {}
		for key in group:
			slot_data[key] = {
				"type": item_slots[slot].type,
				"count": item_slots[slot].count
			}
		slots[group_name] = slot_data
		
	return slots
		
func deserialize(data):
	for group_key in slot_keys:
		group = slot_keys[group_key]
		for key in data[group_name]:
			var item_data = data[group_name][key]
			group[key] = Inventory.InvItem.new(
				item_data.type,
				int(item_data.count)
			)
