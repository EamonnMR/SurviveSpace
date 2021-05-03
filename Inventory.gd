extends Node

export var default_contents: Dictionary

var item_slots = {}
var max_items = 32

class_name Inventory

signal updated

class InvItem:
	var type: String
	var count: int
	
	func _init(type: String, count: int):
		self.type = type
		self.count = count
	
	func data():
		return Data.items[type]

func _ready():
	for key in default_contents:
		add(key, default_contents[key])
	
func _get_first_empty_slot():
	for i in range(max_items):
		if not (i in item_slots):
			return i
	return null

func add(type: String, count: int, slot=null) -> bool: # Represents success/failure
	var success = _add_inner(type, count, slot)
	if success:
		emit_signal("updated")
	return success
	
func _add_inner(type: String, count: int, slot=null) -> bool: 
	if slot == null:
		if Data.items[type].stackable:
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
	emit_signal("updated")

func has_ingredients(ingredients: Dictionary) -> bool:
	# Copy for mutating
	ingredients = ingredients.duplicate()
	for i in range(max_items):
		if i in item_slots:
			var item = item_slots[i]
			if item.type in ingredients:
				ingredients[item.type] -= item.count
				if ingredients[item.type] <= 0:
					ingredients.erase(item.type)
	return ingredients.size() == 0

func deduct_ingredients(ingredients: Dictionary) -> bool:  # Output represents success
	if not has_ingredients(ingredients):
		return false
	else:
		ingredients = ingredients.duplicate()
		var erase_queue = []
		for slot in range(max_items):
			if slot in item_slots:
				var item = item_slots[slot]
				var type = item.type
				if type in ingredients:
					var needed_count = ingredients[type]
					if needed_count > item.count:
						ingredients[type] -= item.count
						item_slots.erase(slot)
					elif needed_count == item.count:
						ingredients.erase(type)
						item_slots.erase(slot)
					else:
						ingredients.erase(type)
						item.count -= needed_count

		emit_signal("updated")
		return true
