extends Control

var item_icon = preload("res://ui/ItemIcon.tscn")
var EquipBox = preload("res://ui/EquipBox.tscn")
onready var left_equip = get_node("Background/VBoxContainer/HBoxContainer/LeftEquip")
onready var right_equip = get_node("Background/VBoxContainer/HBoxContainer/LeftEquip")



func clear():
	for i in [left_equip, right_equip]:
		for child in i.get_children():
			if not (child is MarginContainer):
				i.remove_child(child)
				child.queue_free()

func rebuild():
	clear()
	# TODO: Set ship preview to ship type's texture
	var player = Client.player
	var equipment = Client.player.get_node("Equipment")
	var eq_path = equipment.get_path()
	
	# Populate panels with slots for the ship
	for i in [
		["shield", left_equip, preload("res://assets/FontAwesome/32px-play.png")],
		["weapon", right_equip, preload("res://assets/FontAwesome/32px-crosshairs.png")]
	]:
		# I yearn for Tuples
		var category = i[0]
		var destination = i[1]
		var background = i[2]
		var equipment_slots = equipment.slot_keys[category]
		
		for slot in equipment_slots:
			var box = EquipBox.instance()
			box.get_node("TextureRect").texture = background
			
			if equipment_slots[slot]:
				var item = equipment_slots[slot]
				var icon: ItemIcon = item_icon.instance()
				icon.init(item)
				box.attach_item_icon(icon)
			destination.add_child(box)

			box.connect("item_removed", equipment, "remove_item", [slot, category])
			box.connect("item_added", equipment, "equip_item", [slot, category])
			
