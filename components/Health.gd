extends Node

export var max_health: int
var max_shields: int
var health: float
var shields: float

var health_regen: float = 1
var shield_regen: float = 1

signal ran_out
signal took_damage(source)

func _ready():
	health = max_health
	
func _physics_process(delta):
	gain_health(delta * health_regen)
	gain_shields(delta * shield_regen)

func take_damage(amount, source):
	print("Took Damage")
	if shields > 1:
		shields -= amount
		return
	else:
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
		return true
		
func gain_shields(amount) -> bool:  # Returns false if health was full
	if shields == max_shields:
		return false
	else:
		shields += amount
		if shields > max_shields:
			shields = max_shields
		return true

func serialize() -> Dictionary:
	return {
		# Max amounts and regens belong to the parent class
		"health": health,
		"shields": shields
	}
	
func deserialize(data: Dictionary):
	health = data["health"]
	shields = data["shields"]

func increase_max_health(by: int):
	max_health += by
	health += by
	
func decrease_max_health(by: int):
	max_shields -= by;
	if health > max_health:
		health = max_health

func increase_max_shields(by: int):
	max_shields += by
	
func decrease_max_shields(by: int):
	max_shields -= by;
	if shields > max_shields:
		shields = max_shields
