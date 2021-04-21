extends Control
onready var recipes_list = get_node("NinePatchPanel/MarginContainer/TabContainer/Craft/HBoxContainer/ScrollContainer/Recipes")
onready var recipe_detail = get_node("NinePatchPanel/MarginContainer/TabContainer/Craft/HBoxContainer/Details")
onready var RecipeIcon = preload("res://ui/EquipBox.tscn")

var current_recipe = null

func rebuild():
	clear(recipes_list)
	for recipe_id in Data.recipes:
		var recipe = Data.recipes[recipe_id]
		var item_data = Data.items[recipe.prod_type]
		var recipe_icon = TextureButton.new()
		
		recipe_icon.texture_disabled = item_data.icon
		recipe_icon.texture_focused = item_data.icon
		recipe_icon.texture_hover = item_data.icon
		recipe_icon.texture_normal = item_data.icon
		recipe_icon.texture_pressed = item_data.icon
		recipe_icon.connect("pressed", self, "_recipe_selected", [recipe_id])
		recipes_list.add_child(recipe_icon)
		
func _recipe_selected(recipe_id):
	_switch_recipe_selection(recipe_id)
	
func _switch_recipe_selection(recipe_id):
	current_recipe = Data.recipes[recipe_id]
	var recipe = current_recipe
	recipe_detail.get_node("Name").text = _get_item_name(recipe)
	recipe_detail.get_node("Description").text = _get_item_description(recipe)
	
	var ingredients = recipe_detail.get_node("Ingredients")
	clear(ingredients)
	
	recipe_detail.get_node("CraftButton").disabled = true
	var ingr = recipe.ingredients
	for ingredient_type in recipe.ingredients:
		var item_data = Data.items[ingredient_type]
		var ingredient_quantity = recipe.ingredients[ingredient_type]
		var ingredient_icon = RecipeIcon.instance()
		ingredient_icon.get_node("TextureRect").texture = item_data.icon
		ingredients.add_child(ingredient_icon)
		if ingredient_quantity > 1:
			var count_text = Label.new()
			count_text.text = "X " + str(ingredient_quantity)
			ingredients.add_child(count_text)
	if _can_craft(recipe):
		recipe_detail.get_node("CraftButton").disabled = false
		
func _get_item_name(recipe_data):
	var item_data = Data.items[recipe_data.prod_type]
	var suffix = ""
	if recipe_data.prod_count > 1:
		suffix = " x " + str(recipe_data.prod_count)
	return item_data.name + suffix

func _get_item_description(recipe_data):
	var item_data = Data.items[recipe_data.prod_type]
	return item_data.tooltip

func clear(list):
	for child in list.get_children():
		list.remove_child(child)

func _can_craft(recipe):
	return true


func _on_CraftButton_pressed():
	if _can_craft(current_recipe):
		Client.player.get_node("Inventory").add(current_recipe.prod_type, current_recipe.prod_count)
