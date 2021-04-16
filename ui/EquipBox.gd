extends NinePatchRect

signal item_removed
signal item_added(item)

export var category: String

func _ready():
	if(has_node("ItemIcon")):
		$TextureRect.hide()

func can_drop_data(pos, data):
	if has_node("ItemIcon"):
		print("Can put over?")
		return data["dragged_item"].item.type == $ItemIcon.item.type
	else:
		print("Empty")
		return not category or data["equip_category"] == category

func drop_data(pos, data):
	var dropped_item = data["dragged_item"]
	dropped_item.dropped()
	add_child(dropped_item)
	$TextureRect.hide()
	emit_signal("item_added", dropped_item.item)

func remove_item_icon(item_icon):
	remove_child(item_icon)
	$TextureRect.show()
	emit_signal("item_removed")
