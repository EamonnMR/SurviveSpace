extends Node

class_name Equipment

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
	"shield": shields,
	"hyperdrive": hyperdrives,
	"reactor": reactors,
	"weapon": weapons
}
func _ready():
	# Determine weapon slots by the ship
	var parent = get_node("../")
	for weapon_slot in parent.get_node("Weapons").get_children():
		if not weapon_slot.name in weapons:
			weapons[weapon_slot.name] = null
		
	max_armors = Data.ships[parent.type].armor_slots
	
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

func equip_item(item: Inventory.InvItem, key: String, category: String):
	assert(item.data().equip_category == category)
	assert(key in slot_keys[category])
	assert(slot_keys[category][key] == null)
	slot_keys[category][key] = item
	
	_add(item, key, category)
	
func remove_item(key: String, category: String):
	assert(slot_keys[category][key])
	slot_keys[category][key] = null
	
	_remove(key, category)
	
func _add(item: Inventory.InvItem, key: String, category: String):
	if category == "weapon":
		_parent().add_weapon(preload("res://weapons/ZipGun.tscn").instance(), key)

func _remove(key: String, category: String):
	if category == "weapon":
		_parent().remove_weapon(key)
		
func apply():
	# Use this if the data has been instantiated but _add hasn't been called for all items yet.
	for group_name in slot_keys:
		var group = slot_keys[group_name]
		for key in group:
			_add(group[key], key, group_name)
			
func _parent():
	return get_node("../")

func serialize() -> Dictionary:
	var slots = {}
	for group_name in slot_keys:
		var group = slot_keys[group_name]
		var slot_data = {}
		for key in group:
			if group[key]:
				slot_data[key] = {
					"type": group[key].type,
					"count": group[key].count
				}
		slots[group_name] = slot_data
		
	return slots
		
func deserialize(data):
	for group_key in slot_keys:
		var group = slot_keys[group_key]
		for key in data[group_key]:
			var item_data = data[group_key][key]
			group[key] = Inventory.InvItem.new(
				item_data.type,
				int(item_data.count)
			)
	apply()

func can_hyperjump():
	return hyperdrives.size() > 0 and hyperdrives[hyperdrives.keys()[0]] != null