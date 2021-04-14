extends TextureRect

class_name ItemIcon

var item: Inventory.InvItem

func _init(item: Inventory.InvItem):
	self.item = item
	stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	anchor_right = 1
	anchor_bottom = 1
	texture = Data.items[item.type].icon
	
func get_drag_data(position):
	var drag_texture = TextureRect.new()
	drag_texture.texture = texture
	drag_texture.expand = true
	drag_texture.rect_size = rect_size
	set_drag_preview(drag_texture)

	return {
		"dragged_item": self,
		"equip_category": Data.items[item.type].equip_category
	}
	
# func can_drop_data(pos, data):
# 	print("ItemIcon.can_drop_data")
#	return true

#func drop_data(pos, data):
#	breakpoint
#
func dropped():
	get_node("../").remove_item_icon(self)

