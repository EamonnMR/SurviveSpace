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
		slot = _get_first_empty_slot()
		if slot == null:
			return false
	item_slots[slot] = InvItem.new(type, count)
	return true
