extends NinePatchRect

func can_drop_data(pos, data):
	print("EquipBox.can_drop_data")
	return true

func drop_data(pos, data):
	var dropped_item = data["dragged_item"]
	dropped_item.get_node("../").remove_child(dropped_item)
	add_child(dropped_item)
