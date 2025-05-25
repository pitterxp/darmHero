extends LivingEntity
class_name Mob

signal enemy_died(enemy)

func _init() -> void:
	super._init()
	
func _ready() -> void:
	super._ready()
	health = 10
	max_health = 10

func die():
	#print(self , "Mob -> send signal: 'entity_died'")
	enemy_died.emit(self) # Sende das Signal und übergebe die Instanz des Mobs
	super.die()
