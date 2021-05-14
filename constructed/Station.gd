extends StaticBody2D

func can_interact():
	return true

func _ready():
	Client.add_radar_pip(self)
