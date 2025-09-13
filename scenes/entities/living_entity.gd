extends CharacterBody2D
class_name LivingEntity

# Eigenschaften initialisieren
var health: int
var max_health: int = 100
var can_take_damage: bool = true
var xp: int = 0
var money: int = 0

var damage: int = 0
var attack_speed: float = 0.0

# Signale
signal entity_spawns
#signal entity_died

func _init() -> void:
	health = max_health

func _ready() -> void:
	update_drops()
	pass
	
func spawn():
	entity_spawns.emit()
	
func update_drops() -> void:	
		# XP pro Kill "Formel"
	xp = floor(max_health / 2.0)
	# Money pro Kill "Formel"
	money = floor(max_health / 5.0)
	
func die():	
	#print(self.name , " droppt ❓XP: ",xp," und 💰Money: ",money," <3 ")
	#entity_died.emit()
	queue_free()

func take_damage(amount: int):
	#print("LivingEntity taking damage. Current HP: ", health, ", Max HP: ", max_health, ", DMG: ", amount)
	print(self.name + " taking damage. Current HP: ", health, ", Max HP: ", max_health, ", DMG: ", amount)
	if can_take_damage:
		health -= amount
		
		if health <= 0:
			die()
