extends Control

func _on_Button_pressed():
	var root = get_tree().get_root()
	root.add_child(load("res://ui/MainMenu.tscn").instance())
	self.queue_free()
