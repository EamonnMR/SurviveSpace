extends DataRow

class_name ItemData

var id: String
var name: String
var equip_category: String
var icon: Texture
var tooltip: String

func _init(data: Dictionary):
	init(data)
