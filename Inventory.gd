extends Node

var item_slots = {}
var max_items = 32

class_name Inventory

class InvItem:
	var type: String
	var count: int
	
	func _init(type: String, count: int):
		self.type = type
		self.count = count
	
	func data():
		return Data.items[type]

func _ready():
	add("crew", 1)
	add("metal", 1)
	add("drive_1", 1)
	
func _get_first_empty_slot():
	for i in range(max_items):
		if not (i in item_slots):
			return i
	return null

func add(type: String, count: int, slot=null) -> bool: # Represents success/failure
	if slot == null:
		slot = _get_first_available_slot_of_type(type)
		if slot == null:
			slot = _get_first_empty_slot()
			if slot == null:
				return false
	if slot in item_slots:  # Dropping over an existing item
		if item_slots[slot].type == type:
			item_slots[slot].count += count
			return true
		else:
			return false
	item_slots[slot] = InvItem.new(type, count)
	return true

func _get_first_available_slot_of_type(type):
	for i in range(max_items):
		if i in item_slots:
			if item_slots[i].type == type:
				return i
			# TODO: Limit count
	return null

func remove_item_from_slot(slot):
	item_slots.erase(slot)
