extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

func _ready():
	add_to_group("enemies")
	print("Überprüfe Knotentypen:")
	print("playerHitbox Typ: ", $playerHitbox.get_class())
	print("weapon/weaponHitbox Typ: ", $weapon/weaponHitbox.get_class())
	
	# Dann versuche die Verbindungen herzustellen
	$playerHitbox.area_entered.connect(_on_hitbox_area_entered)
	$playerHitbox.area_exited.connect(_on_hitbox_area_exited)
	$weapon/weaponHitbox.area_entered.connect(_on_weapon_area_entered)

func _on_hitbox_area_entered(area):
	print("Spieler kollidiert mit: ", area.get_parent().name)
	if area.get_parent().is_in_group("enemies"):
		print("Spieler wurde von Gegner getroffen!")
		# Hier deine Logik für Schaden, etc.

func _on_hitbox_area_exited(area):
	print("Kollision mit Spieler beendet: ", area.get_parent().name)
	if area.get_parent().is_in_group("enemies"):
		print("Gegner hat Spieler verlassen")

func _on_weapon_area_entered(area):
	print("Waffe kollidiert mit: ", area.get_parent().name)
	if area.get_parent().is_in_group("enemies"):
		print("Gegner wurde von Waffe getroffen!")
		# Hier deine Logik für Schaden, etc.

func _physics_process(delta: float) -> void:
	"""
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	"""
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var h_direction := Input.get_axis("move_left", "move_right")
	var v_direction := Input.get_axis("move_up", "move_down")
	velocity.x = h_direction * SPEED
	velocity.y = v_direction * SPEED
	position += velocity * delta

	move_and_slide()
