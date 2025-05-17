extends CharacterBody2D
class_name LivingEntity

# Eigenschaften
var health: int
var max_health: int = 100
var can_take_damage: bool = true

# Signale
signal entity_spawns
signal entity_dies

func _init():
	#print("LivingEntity wird initialisiert ...")
	health = max_health

func _ready():
	pass
	
func spawn():
	#print("LivingEntitiy -> signal 'entitiy_spwans'")
	entity_spawns.emit()
	
func die():
	#print("LivingEntitiy -> signal 'entitiy_dies'")
	entity_dies.emit()
	queue_free()

func take_damage(amount: int):
	#print("LivingEntitiy -> take_damage(", amount, ")")
	if can_take_damage:
		health -= amount
		
		if health <= 0:
			die()
