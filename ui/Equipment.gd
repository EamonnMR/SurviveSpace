extends Control

var item_icon = preload("res://ui/ItemIcon.tscn")
var EquipBox = preload("res://ui/EquipBox.tscn")
onready var left_equip = $Background/VBoxContainer/HBoxContainer/LeftEquip
onready var right_equip = $Background/VBoxContainer/HBoxContainer/RightEquip
onready var middle_equip = $Background/VBoxContainer/MiddleEquip # I'd like this to be elsewhere in the scene tree, but there's a bug where when I put it in the ideal spot (inside Middle) it won't fire any is_droppable calls, so here we are.
onready var preview = $Background/VBoxContainer/HBoxContainer/Middle/ShipPreview
onready var ship_type_name = $Background/VBoxContainer/HBoxContainer/Middle/Type

func clear():
	for i in [left_equip, middle_equip, right_equip]:
		for child in i.get_children():
			if not ((child is MarginContainer) or (child is TextureRect) or (child is RichTextLabel)):
				i.remove_child(child)
				child.queue_free()

func rebuild():
	clear()
	
	var player = Client.player
	var equipment = Client.player.get_node("Equipment")
	var eq_path = equipment.get_path()
	preview.texture = player.get_node("Sprite").texture
	ship_type_name.text = player.data.type_name
	# Populate panels with slots for the ship
	for i in [
		["consumable", middle_equip, preload("res://assets/FontAwesome/32px-charge.png")], # TODO: Better icon
		["shield", left_equip, preload("res://assets/FontAwesome/32px-play.png")],
		["hyperdrive", left_equip, preload("res://assets/FontAwesome/32px-star.png")],
		["reactor", left_equip, preload("res://assets/FontAwesome/32px-charge.png")],
		["armor", left_equip, preload("res://assets/FontAwesome/32px-shield.png")],
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
			box.category = category
			
			if equipment_slots[slot]:
				var item = equipment_slots[slot]
				var icon: ItemIcon = item_icon.instance()
				icon.init(item)
				box.attach_item_icon(icon)
			destination.add_child(box)

			box.connect("item_removed", equipment, "remove_item", [slot, category])
			box.connect("item_added", equipment, "equip_item", [slot, category])
			
