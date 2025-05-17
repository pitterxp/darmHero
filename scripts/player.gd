extends LivingEntity
class_name Player

var speed:float = 300.0
#const JUMP_VELOCITY = -400.0

# Waffe holen
@onready var current_weapon: WeaponBase = $Sword # Gehe davon aus, dass das Schwert ein Child mit dem Namen "Sword" ist

var game_active:bool

# Get more player Sprites
@onready var sprite = $hero
var sprite_paths: Array[String] = [
	"res://assets/sprites/player/hero-links.png",
	"res://assets/sprites/player/hero-rechts.png",
	"res://assets/sprites/player/hero-oben.png",
	"res://assets/sprites/player/hero-unten.png",
	"res://assets/sprites/player/hero-oben-links.png",
	"res://assets/sprites/player/hero-oben-rechts.png",
	"res://assets/sprites/player/hero-unten-links.png",
	"res://assets/sprites/player/hero-unten-rechts.png"
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
	connect("entity_dies", Callable(self, "_on_death"))
	
	# Spiel pausiert?
	get_node("/root/Game").connect("gameActive", _game_activitiy_changed)
	spawn()

func spawn():
	#print("Player wurde 'geboren'")
	player_spawned.emit()

func _game_activitiy_changed(new_value:bool) -> void:
	game_active = new_value

func _on_death():
	print("Player ist gestorben")

func _physics_process(delta: float) -> void:
	# Spielpause berücksichtigen
	if game_active:
		# Get the input direction and handle the movement/deceleration.
		var h_direction := Input.get_axis("move_left", "move_right")
		var v_direction := Input.get_axis("move_up", "move_down")
		velocity.x = h_direction * speed
		velocity.y = v_direction * speed
		position += velocity * delta
		# Sprite Auswahl
		_update_sprite_direction(h_direction, v_direction)		
	move_and_slide()
	
func _update_sprite_direction(h_dir: float, v_dir: float) -> void:
	var angle = rad_to_deg(atan2(-v_dir, h_dir)) # Negatives Vorzeichen für v_dir
	for direction_data in DIRECTION_ANGLES:
		if angle >= direction_data.min and angle <= direction_data.max:
			sprite.texture = load(sprite_paths[direction_data.index])
			return
