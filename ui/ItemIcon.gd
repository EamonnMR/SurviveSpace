extends TextureRect

class_name ItemIcon

var item: Inventory.InvItem

func init(item):
	self.item = item
	name = "ItemIcon"
	stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	anchor_right = 1
	anchor_bottom = 1
	texture = item.data().icon

func _ready():
	update_count()

func update_count():
	if item.count > 1:
		$Count.text = str(item.count)
	else:
		$Count.text = ""

func get_drag_data(_position):
	var drag_texture = TextureRect.new()
	drag_texture.texture = texture
	drag_texture.expand = true
	drag_texture.rect_size = rect_size
	set_drag_preview(drag_texture)

	return {
		"dragged_item": self,
		"equip_category": item.data().equip_category
	}
	
func dropped():
	get_node("../").remove_item_icon(self)

