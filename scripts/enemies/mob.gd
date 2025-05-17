extends LivingEntity
class_name Mob

func _init() -> void:
	super._init()
	
func _ready() -> void:
	super._ready()
	health = 10
	max_health = 10
	print ("Mob 'ready'")
