extends WeaponBase

@onready var sprite: Sprite2D = $Sprite
@onready var hitbox: CollisionPolygon2D = $Hitbox
@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer") # Optional
@onready var attack_timer: Timer = $AttackTimer

var current_target: Node = null

func _ready():
	damage = 15 # Setze den spezifischen Schaden für das Schwert
	attack_speed = 2
	
	# Timer initialisieren
	attack_timer.wait_time = 1.0 / attack_speed
	attack_timer.one_shot = false
	attack_timer.stop()
	
	# Dann versuche die Verbindungen herzustellen
	$".".area_entered.connect(_on_weapon_area_entered)
	$".".area_exited.connect(_on_weapon_area_exited)

func attack(attacker, target):
	print("DMG CALC: Attacking: >" + attacker.name + "< vs " + target.name)
	if target != null and target.has_method("take_damage"):
		target.take_damage(damage)
	pass

func _process_attack(attacker, target) -> void:
	print("Proc. ATK: >" + attacker.name + "< vs " + target.name)
	print("current target: >> " + current_target.name)
	if target.has_method("take_damage"):
		attack_timer.start()
		print("Starte Attack-Timer NOW")
		attack(attacker, current_target) # Sofortiger erster Angriff  "QUICK AND DIRTY"
	else:
		print("target hat keine take_damage methode! => " + target.name)
		
func _stop_attack(target) -> void:
		print("Sword stops attacking " + target.name)
		attack_timer.stop()
		current_target = null
	
func _on_attack_timer_timeout() -> void:
	print("Timeout-Signal empfangen!")
	_process_attack(self, current_target)

func _on_weapon_area_entered(area):
	print("Waffe kollidiert mit: ", area.get_parent().name)
	current_target = area.get_parent()
	print("Current Target gesetzt auf:", current_target.name)
	if area.get_parent().is_in_group("enemies"):		
		_process_attack(self, area.get_parent())
		
func _on_weapon_area_exited(area):
	print("Waffe kollidiert NICHT MEHR mit: ", area.get_parent().name)
	_stop_attack(area.get_parent())
