extends Ship

func _ready():
	._ready()
	connect("disabled", self, "_boss_defeated")

func _boss_defeated():
	Client.victory()
