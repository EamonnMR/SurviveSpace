extends Control

onready var craft_submenu = get_node("NinePatchPanel/MarginContainer/TabContainer/Craft/")
onready var build_submenu = get_node("NinePatchPanel/MarginContainer/TabContainer/Build/")

func rebuild():
	craft_submenu.rebuild()
	build_submenu.rebuild()

func assign(crafting_level_node):
	craft_submenu.assign(crafting_level_node)

func unassign():
	craft_submenu.unassign()
