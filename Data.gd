extends Node

var items = {}

func _init():
	load_items()
	
func load_items():
	var item_data = DataRow.load_csv("res://data/items.csv")
	for key in item_data:
		items[key] = ItemData.new(item_data[key])
