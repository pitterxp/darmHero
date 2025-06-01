extends LivingEntity
class_name Campy

var _last_attack_time := -100.0

signal enemy_died(enemy)

func _init() -> void:
	super._init()
	
func _ready() -> void:
	health = 50
	max_health = 50
	damage = 10
	attack_speed = 1
	update_drops()
	super._ready()
	"""
	print("== CAMPY READY ==")
	print("Hitbox: ", $mobHitbox)
	print("Layer: ", $mobHitbox.collision_layer, " | Mask: ", $mobHitbox.collision_mask)
	print("Monitoring: ", $mobHitbox.monitoring, " | Monitorable: ", $mobHitbox.monitorable)
	print("Signal verbunden? ", $mobHitbox.is_connected("area_entered", Callable(self, "_on_mob_hitbox_area_entered")))
	"""

func try_attack_player(target: Node) -> void:
	print("campy atk! " + target.name)
	var now = Time.get_ticks_msec() / 1000.0
	if now - _last_attack_time >= attack_speed:
		if target is LivingEntity:
			target.take_damage(damage)
			_last_attack_time = now

func die():
	#print(self, " droppt ❓XP: ",xp," und 💰Money: ",money," <3 ")
	enemy_died.emit(self) # Sende das Signal und übergebe die Instanz des Mobs
	super.die()


func _on_mob_hitbox_area_entered(area: Area2D) -> void:
	#print("campy hat irgendwas getroffen:", area.name)
	#print("Parent vom Treffer:", area.get_parent().name)
	if area.is_in_group("player"):
		print("campy ist in reichweite zu: " + area.name)
		try_attack_player(area)
	else:
		print("ABER: area ist nicht in group 'player'")
