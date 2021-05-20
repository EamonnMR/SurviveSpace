extends Node

export var max_health: int
var health: int

signal ran_out

func _ready():
	health = max_health

func _print_amount():
	print("Health: ", health)

func take_damage(amount):
	print("Took Damage")
	health -= amount
	_print_amount()
	if health <= 0:
		emit_signal("ran_out")

func gain_health(amount) -> bool:  # Returns false if health was full
	if health == max_health:
		_print_amount()
		return false
	else:
		health += amount
		if health > max_health:
			health = max_health
		_print_amount()
		return true

func serialize() -> Dictionary:
	return {
		"health": health
	}
	
func deserialize(data: Dictionary):
	health = data["health"]
