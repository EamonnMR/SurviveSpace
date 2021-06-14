extends Control

onready var scroll_buttons = get_node("NinePatchPanel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for save in Client.list_game_saves():
		var button = Button.new()
		button.text = save
		button.connect("pressed", self, "_resume_save", [save])
		scroll_buttons.add_child(button)

func _resume_save(save):
	Client.load_game(save)
	queue_free()


func _on_CancelButton_pressed():
		var main_menu = load("res://ui/MainMenu.tscn")
		get_tree().get_root().add_child(main_menu.instance())
		queue_free()
