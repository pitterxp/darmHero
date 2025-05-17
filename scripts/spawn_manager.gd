extends Node

@onready var difficulty = RuntimeParameter.difficulty_setting
@onready var spawn_parameter = GameParameter.gameSettings[difficulty]
@onready var player = get_node("/root/Game/Player")
@onready var arena_level = get_node("/root/Game/ArenaLevel1")

var game_active: bool = false
var enemies_spawned: int = 0
var current_wave: int = 0 
var enemy_scenes = [preload("res://scenes/enemies/mob.tscn"), preload("res://scenes/enemies/noro.tscn")]
var active_enemies = []
var safe_radius: float = GameParameter.safeZoneSettings.radius
var spawn_radius: float = GameParameter.enemySpawnZoneSettings.radius

var spawn_delay: float = 0.1 # Verzögerung zwischen Ankündigung und Spawn
var announcement_duration: float = 1 # Dauer der Ankündigungsvisualisierung
var announcement_scene: PackedScene = preload("res://scenes/enemies/spawn_announcement.tscn") # Pfad zur Ankündigungs-Szene


signal wave_spawned(enemies_spawned)
signal wave_completed() # Neues Signal für das Ende einer Welle


func _ready() -> void:
	# Spielstatus erfragen (Signal verbinden)
	var root = get_node("/root")
	if is_instance_valid(root.get_node("Game")):
		root.get_node("Game").connect("gameActive", _game_activity_changed)
	else:
		printerr("Fehler: Game-Node nicht gefunden!")

	if player == null:
		printerr("Fehler: Spieler-Node nicht gefunden!")
	if arena_level == null:
		printerr("Fehler: Arena-Level-Szene nicht gefunden!")

	# Starte den Spawn-Zyklus, wenn das Spiel aktiv ist
	if game_active:
		set_process(true)
	else:
		set_process(false)


func start_wave() -> void:
	enemies_spawned = 0 # Zurücksetzen für jede neue Welle
	var enemies_to_spawn = randi_range(spawn_parameter.min_enemies, spawn_parameter.max_enemies)
	print("Starte Welle ", current_wave, " mit ", enemies_to_spawn, " Gegnern.")

	for _i in range(enemies_to_spawn):
		spawn_enemy()
		await get_tree().create_timer(spawn_delay).timeout
	wave_spawned.emit(enemies_spawned)

func spawn_enemy() -> void:
	var player_position: Vector2 = player.global_position
	var spawn_position: Vector2
	var found_valid_position: bool = false

	for _i in range(20):
		var random_angle = randf_range(0, TAU)
		var random_distance = randf_range(safe_radius, spawn_radius)
		spawn_position = player_position + Vector2(cos(random_angle), sin(random_angle)) * random_distance
		if is_valid_spawn_position(spawn_position):
			found_valid_position = true
			break

	if found_valid_position:
		# Erzeuge und zeige die Ankündigung
		var announcement = show_spawn_announcement(spawn_position)
		await get_tree().create_timer(announcement_duration).timeout # Wartezeit für die Dauer der Ankündigung

		# Spawne den Gegner
		var random_enemy_scene = enemy_scenes.pick_random()
		var new_enemy_instance = random_enemy_scene.instantiate()
		new_enemy_instance.global_position = spawn_position
		arena_level.add_child(new_enemy_instance)
		active_enemies.append(new_enemy_instance) # Gegner protokollieren
		enemies_spawned += 1
		print("Gegner gespawnt an:", spawn_position)
		announcement.queue_free() # Entferne die Ankündigungsszene
	else:
		print("Keine gültige Spawn-Position gefunden.")

func is_valid_spawn_position(_position: Vector2) -> bool:
	# Platzhalter zur Abfrage von obstacles
	return true
	
func show_spawn_announcement(position: Vector2) -> Node2D:
	var announcement_instance = announcement_scene.instantiate()
	announcement_instance.global_position = position
	arena_level.add_child(announcement_instance)
	return announcement_instance

func _game_activity_changed(new_value: bool) -> void:
	game_active = new_value
	print("Spawnmanager: game activity changed to: ", new_value)
	set_process(game_active) # Aktiviere/Deaktiviere _process
	if game_active:
		start_round() # Starte die erste Runde, wenn das Spiel aktiv wird

func start_round() -> void:
	current_wave = 1
	print("Starte Runde ", current_wave)
	start_wave() # Starte die erste Welle der Runde

func end_wave() -> void:
	current_wave += 1
	wave_completed.emit()
	# Starte die nächste Welle, oder tue nichts, wenn die Runde vorbei ist.
	# Die Entscheidung, ob eine neue Runde gestartet wird, liegt nun beim RoundManager
	# Der SpawnManager signalisiert nur das Ende der Welle.
