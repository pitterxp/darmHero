extends WeaponBase

@onready var sprite: Sprite2D = $Sprite
@onready var hitbox: CollisionPolygon2D = $Hitbox
@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer") # Optional
@onready var attack_timer: Timer = $AttackTimer

var current_target: Node = null

func _ready():
	damage = 15 # Setze den spezifischen Schaden für das Schwert
	attack_speed = 0.8
	
	# Timer initialisieren
	attack_timer.wait_time = 1.0 / attack_speed
	attack_timer.one_shot = false
	attack_timer.stop()	


func attack(attacker, target):
	# Nicht Player angreifen!
	#if !target.name == "Player":
	#	print("Sword can attack! " + attacker.name + " vs. " + target.name)
	
	if target.has_method("take_damage"):
		target.take_damage(damage)

func _start_attack(target) -> void:
	if target.has_method("take_damage"):
		current_target = target
		print("Sword stops attacking " + target.name)
		attack_timer.start()
		_process_attack() # Sofortiger erster Angriff  "QUICK AND DIRTY"

func _stop_attack(target) -> void:
	if target == current_target:
		print("Sword stops attacking " + target.name)
		attack_timer.stop()
		current_target = null
	
func _process_attack() -> void:
	if current_target != null:
		attack(get_parent(), current_target)

func _on_body_entered(body: Node2D) -> void:
	# Player kann ab jetzt angreifen
	_start_attack(body)

func _on_body_exited(body: Node2D) -> void:
	# Player kann ab jetzt nicht mehr angreifen
	_stop_attack(body)

func _on_attack_timer_timeout() -> void:
	_process_attack()
