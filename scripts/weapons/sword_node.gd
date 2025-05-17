extends WeaponBase

@onready var sprite: Sprite2D = $Sprite
@onready var hitbox: CollisionPolygon2D = $Hitbox
@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer") # Optional

func _ready():
	damage = 15 # Setze den spezifischen Schaden für das Schwert
	attack_speed = 0.8
	attack_range = 1.5 # Beispiel für eine relative Reichweite

func attack(attacker, target):
	if attacker != null and target != null:
		var attacker_name = "Unbekannter Angreifer"
		if attacker.has_property("name"):
			attacker_name = attacker.name
		
		var target_name = "Unbekanntes Ziel"
		if target.has_property("name"):
			target_name = target.name

		print(attacker_name + " schwingt Schwert und verursacht " + str(damage) + " Schaden an " + target_name + "!")
		if animation_player and animation_player.has_animation("swing"):
			animation_player.play("swing")
		if target.has_method("take_damage"):
			target.take_damage(damage)
	else:
		print("Fehler: Angriff konnte nicht ausgeführt werden, Angreifer oder Ziel ist null.")
