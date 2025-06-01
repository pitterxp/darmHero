extends LivingEntity
class_name Giardia

signal enemy_died(enemy)

func _init() -> void:
	super._init()
	
func _ready() -> void:
	health = 20
	max_health = 20
	damage = 5
	update_drops()
	super._ready()

func die():
	enemy_died.emit(self) # Sende das Signal und übergebe die Instanz des Mobs
	super.die()
