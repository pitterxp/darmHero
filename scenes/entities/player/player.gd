extends LivingEntity
class_name Player

# Spieler
var speed: float = 340.0
var is_facing_left: bool = false

# Waffe holen
@onready var current_weapon: WeaponBase = $Sword
@onready var current_weapon_sprite: Sprite2D = $Sword/Sprite
@onready var current_weapon_grippoint: = $Sword/GripPoint

var game_active:bool

# Get more player Sprites
@onready var sprite = $hero
var sprite_paths: Array[String] = [
	"res://scenes/entities/player/hero-links.png",
	"res://scenes/entities/player/hero-rechts.png",
	"res://scenes/entities/player/hero-oben.png",
	"res://scenes/entities/player/hero-unten.png",
	"res://scenes/entities/player/hero-oben-links.png",
	"res://scenes/entities/player/hero-oben-rechts.png",
	"res://scenes/entities/player/hero-unten-links.png",
	"res://scenes/entities/player/hero-unten-rechts.png"
]

# Winkel -> Playersprites
const DIRECTION_ANGLES: Array[Dictionary] = [
	{ "min": -22.5, "max": 22.5, "index": 1 },		# Rechts
	{ "min": 22.5, "max": 67.5, "index": 5 },		# Oben-Rechts
	{ "min": 67.5, "max": 112.5, "index": 2 },		# Oben
	{ "min": 112.5, "max": 157.5, "index": 4 },		# Oben-Links
	{ "min": 157.5, "max": 180.0, "index": 0 },		# Links
	{ "min": -180.0, "max": -157.5, "index": 0 },	# Links (auch für -180 bis -157.5 Grad)
	{ "min": -157.5, "max": -112.5, "index": 6 },	# Unten-Links
	{ "min": -112.5, "max": -67.5, "index": 3 },	# Unten
	{ "min": -67.5, "max": -22.5, "index": 7 }		# Unten-Rechts
]

# Signale
signal player_spawned


func _init():
	super._init()
	pass

func _ready() -> void:
	super._ready()
	
	#Signale
	# Player "hört" zu, ob sein todesfall eintritt. "o7 in den chat für Player"
	# TODO connect("entity_died", Callable(self, "_on_death")) ändern^^	
	$playerHitbox.area_entered.connect(_on_hitbox_area_entered)
	$playerHitbox.area_exited.connect(_on_hitbox_area_exited)

	# Spiel pausiert?
	get_node("/root/Game").connect("gameActive", _game_activitiy_changed)
	spawn()
	
func _on_hitbox_area_entered(area):
	var parent = area.get_parent()
	print("Spieler kollidiert mit: ", parent.name)
	"""
	var parent = area.get_parent()
	print("Spieler kollidiert mit: ", parent.name)
	if parent.is_in_group("enemies"):
		#print("Spieler wurde von Gegner getroffen!")
		#print("DMG: ", parent.damage)
		take_damage(parent.damage)
	"""

func _on_hitbox_area_exited(area):
	print("Kollision mit Spieler beendet: ", area.get_parent().name)
	if area.get_parent().is_in_group("enemies"):
		print("Gegner hat Spieler verlassen")

func spawn():
	player_spawned.emit()

func _game_activitiy_changed(new_value:bool) -> void:
	game_active = new_value

func _on_death():
	print("Player ist gestorben")

func _physics_process(_delta: float) -> void:
	if not game_active:
		return

	# Bewegung holen
	var h := Input.get_axis("move_left", "move_right")
	var v := Input.get_axis("move_up", "move_down")
	
	# Richtung & Geschwindigkeit
	velocity = Vector2(h, v).normalized() * speed
	
	# Bewegung ausführen – Godot-Kollisionssystem regelt
	move_and_slide()

	# Optional: Sprite-Flip oder Animation anpassen
	_update_sprite_direction(h, v)

	
func _update_sprite_direction(h_dir: float, v_dir: float) -> void:
	var angle = rad_to_deg(atan2(-v_dir, h_dir)) # Negatives Vorzeichen für v_dir
	for direction_data in DIRECTION_ANGLES:
		if angle >= direction_data.min and angle <= direction_data.max:
			sprite.texture = load(sprite_paths[direction_data.index])
			# Flip nur bei Links/Rechts und Diagonal
			match direction_data.index:
				0, 4: # Links, Oben-Links
					sprite.flip_h = true
					# waffe nicht vergessen
					_update_weapon_position()
				1, 5: # Rechts, Oben-Rechts
					sprite.flip_h = false
					# waffe nicht vergessen
					_update_weapon_position()
			return

func _snap_to_hand(_hand_global_pos: Vector2) -> void:
	# global_position = hand_global_pos - $GripPoint.position.rotated(rotation)
	pass

func _update_weapon_position() -> void:
	@warning_ignore("unused_variable")
	var target_hand = $leftHand
	if not is_facing_left:
		target_hand = $rightHand
	@warning_ignore("unused_variable")
	var grip_offset = current_weapon_grippoint.position
	#$current_weapon.global_position = target_hand.global_position - grip_offset.rotated($current_weapon.rotation)
	#$current_weapon.global_position = target_hand.global_position
