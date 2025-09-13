extends LivingEntity
class_name Noro

signal enemy_died(enemy)

func _init() -> void:
	super._init()
	
func _ready() -> void:
	super._ready()
	health = 100
	max_health = 100
	damage = 30

func die():
	#print(self , "Noro -> send signal: 'entity_dies'")
	enemy_died.emit(self) # Sende das Signal und übergebe die Instanz des Mobs
	super.die()
