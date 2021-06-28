extends Control

onready var box_shield = get_node("Background/VBoxContainer/HBoxContainer/LeftEquip/Shield")
onready var box_armor = get_node("Background/VBoxContainer/HBoxContainer/LeftEquip/Armor")
onready var box_hyperdrive = get_node("Background/VBoxContainer/HBoxContainer/LeftEquip/HyperDrive")
onready var box_reactor = get_node("Background/VBoxContainer/HBoxContainer/LeftEquip/Reactor")

onready var box_weapon = get_node("Background/VBoxContainer/HBoxContainer/RightEquip/Weapon")

var item_icon = preload("res://ui/ItemIcon.tscn")

func rebuild():
	for i in [
		box_shield,
		box_armor,
		box_hyperdrive,
		box_reactor,
		box_weapon
	]:
		i.clear()
		connect(""
		# i.connect(Client.player.get_node("Equipment"))
func _on_Shield_item_added(item):
	pass # Replace with function body.


func _on_Shield_item_removed(item):
	pass # Replace with function body.


func _on_Armor_item_added(item):
	pass # Replace with function body.


func _on_Armor_item_removed(item):
	pass # Replace with function body.


func _on_HyperDrive_item_added(item):
	Client.player.add_hyperdrive(item)


func _on_HyperDrive_item_removed(item):
	pass # Replace with function body.


func _on_Reactor_item_added(item):
	pass # Replace with function body.


func _on_Reactor_item_removed(item):
	pass # Replace with function body.


func _on_Weapon_item_added(item):
	Client.player.add_weapon(preload("res://weapons/ZipGun.tscn").instance(), 0)
	
func _on_Weapon_item_removed(item):
	Client.player.remove_weapon(0)
