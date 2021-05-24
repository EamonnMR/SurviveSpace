extends Node

export var max_health: int
var health: int

signal ran_out
signal took_damage(source)

func _ready():
	health = max_health

func take_damage(amount, source):
	print("Took Damage")
	health -= amount
	emit_signal("took_damage", source)
	if health <= 0:
		emit_signal("ran_out")

func gain_health(amount) -> bool:  # Returns false if health was full
	if health == max_health:
		return false
	else:
		health += amount
		if health > max_health:
			health = max_health
			health = max_health
		return true

func serialize() -> Dictionary:
	return {
		"health": health
	}
	
func deserialize(data: Dictionary):
	health = data["health"]
