extends LivingEntity
class_name Clostri

signal enemy_died(enemy)

func _init() -> void:
	super._init()
	
func _ready() -> void:
	health = 75
	max_health = 75
	damage = 15
	update_drops()
	super._ready()


func die():
	#print(self, " droppt ❓XP: ",xp," und 💰Money: ",money," <3 ")
	enemy_died.emit(self) # Sende das Signal und übergebe die Instanz des Mobs
	super.die()
