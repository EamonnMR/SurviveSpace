extends Control
func _ready():
	var file = File.new()
	file.open("res://readme.txt", File.READ)
	$Credits/MarginContainer/VBoxContainer/ScrollContainer/RichTextLabel.text = file.get_as_text()


func _on_CloseButton_pressed():
	hide()
