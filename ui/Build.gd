extends Control
onready var builds_list = get_node("HBoxContainer/ScrollContainer/Builds")
onready var build_detail = get_node("HBoxContainer/Details")
onready var BuildIcon = preload("res://ui/EquipBox.tscn")

var current_build = null

func _ready():
	current_build = Data.builds.values()[0]
	Client.player.get_node("Inventory").connect("updated", self, "rebuild")

func rebuild():
	# clear(builds_list)
	_update_build_selection()
	build_build_list()

func build_build_list():
	for recipe_id in Data.builds:
		var build_data = Data.builds[recipe_id]
		var build_icon = TextureButton.new()
		
		build_icon.texture_disabled = build_data.icon
		build_icon.texture_focused = build_data.icon
		build_icon.texture_hover = build_data.icon
		build_icon.texture_normal = build_data.icon
		build_icon.texture_pressed = build_data.icon
		build_icon.connect("pressed", self, "_recipe_selected", [recipe_id])
		builds_list.add_child(build_icon)
		
func _recipe_selected(recipe_id):
	current_build = Data.recipes[recipe_id]
	_update_build_selection()
	
func _update_build_selection():
	var build_id = current_build.id
	var build = current_build
	build_detail.get_node("Name").text = build.name
	build_detail.get_node("Description").text = build.text
	
	var ingredients = build_detail.get_node("Ingredients")
	clear(ingredients)
	
	build_detail.get_node("BuildButton").disabled = true
	var ingr = build.ingredients
	for ingredient_type in build.ingredients:
		var item_data = Data.items[ingredient_type]
		var ingredient_quantity = build.ingredients[ingredient_type]
		var ingredient_icon = BuildIcon.instance()
		ingredient_icon.get_node("TextureRect").texture = item_data.icon
		ingredients.add_child(ingredient_icon)
		if ingredient_quantity > 1:
			var count_text = Label.new()
			count_text.text = "X " + str(ingredient_quantity)
			ingredients.add_child(count_text)
	if _can_build(build):
		build_detail.get_node("BuildButton").disabled = false
		
func _get_item_name(recipe_data):
	var item_data = Data.builds[recipe_data.prod_type]
	var suffix = ""
	if recipe_data.prod_count > 1:
		suffix = " x " + str(recipe_data.prod_count)
	return item_data.name + suffix

func clear(list):
	for child in list.get_children():
		list.remove_child(child)

func _can_build(recipe):
	return Client.player.get_node("Inventory").has_ingredients(current_build.ingredients)


func _on_BuildButton_pressed():
	if _can_build(current_build):
		var constructed = current_build.scene.instance()
		constructed.position = Client.player.position
		get_tree().get_root().get_node("Game/Gameplay/" + current_build.destination).add_child(
			constructed
		)
