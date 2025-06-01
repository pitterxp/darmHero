extends Node

@onready var difficulty = RuntimeParameter.difficulty_setting
@onready var spawn_parameter = GameParameter.gameSettings[difficulty]
@onready var player = get_node("/root/Game/Player")
@onready var round_manager = get_node("/root/Game/nodeRoundManager")
@onready var arena_level = get_node("/root/Game/ArenaLevel1")

var game_active: bool = false
var is_paused: bool = false

# Wellen - Spawn - Verhalten
var enemies_spawned: int = 0	# wie viele gegner wurden in der runde gespawnt?
var enemies_to_spawn: int = 0	# gesamtanzahl der gegner in der aktuellen runde

var current_wave: int = 0 
var enemy_scenes = [
		preload("res://scenes/entities/enemies/campy/campy.tscn")
		#preload("res://scenes/entities/enemies/giardia/giardia.tscn"),
		#preload("res://scenes/entities/enemies/noro/noro.tscn"),
		#preload("res://scenes/entities/enemies/clostri/clostri.tscn")
	]
var active_enemies = []
var safe_radius: float = GameParameter.safeZoneSettings.radius
var spawn_radius: float = GameParameter.enemySpawnZoneSettings.radius

var spawn_delay: float = 0.0 # TODO Verzögerung zwischen Ankündigung und Spawn
var announcement_duration: float = 1 # Dauer der Ankündigungsvisualisierung
var announcement_scene: PackedScene = preload("res://scenes/entities/spawn_announcement.tscn") # Pfad zur Ankündigungs-Szene

signal wave_spawned(enemies_spawned)	# Eine Welle mit anzahl gegner gespawnt
#signal wave_completed					# Eine Welle abgeschlossen
#signal round_completed # 				# TODO Spielrunde beendet, alle Wellen wurden besiegt


func _ready() -> void:
	# Spiel aktiv?
	if is_instance_valid(get_node("/root/Game")):
		get_node("/root/Game").connect("gameState", _game_activity_changed)
		

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
	# Zähler für jede neue Welle zurücksetzen
	enemies_spawned = 0
	enemies_to_spawn = randi_range(spawn_parameter.min_enemies, spawn_parameter.max_enemies)
	#print("Starte Welle ", current_wave, " mit ", enemies_to_spawn, " Gegnern.")
	
	# Gegneranzahl der aktuellen Welle speichern
	RuntimeParameter.current_round_data[0]["enemies_spawned"] = enemies_to_spawn
	
	for _i in range(enemies_to_spawn):
		spawn_enemy()

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
		announcement.queue_free() # Entferne die Ankündigungsszene
		
		active_enemies.append(new_enemy_instance) # Gegner protokollieren
		enemies_spawned += 1
		
		# Mob meldet Tod an Roundmanager
		new_enemy_instance.enemy_died.connect(round_manager._on_enemy_died)
		
		if enemies_spawned == enemies_to_spawn:
			print("Gegner wurden gespawnt! Kill'em all: (", enemies_spawned, ")/(",enemies_to_spawn,") <<<<< ")
			wave_spawned.emit(enemies_spawned)
	else:
		print("Keine gültige Spawn-Position gefunden.")

func is_valid_spawn_position(_position: Vector2) -> bool:
	# Platzhalter zur Abfrage von komplexeren Level
	return true
	
func show_spawn_announcement(position: Vector2) -> Node2D:
	var announcement_instance = announcement_scene.instantiate()
	announcement_instance.global_position = position
	arena_level.add_child(announcement_instance)
	return announcement_instance

func _game_activity_changed(game_active: bool, is_paused:  bool) -> void:
	#game_active = new_value
	set_process(game_active)
	if game_active:
		start_wave_round() # Starte die Runde, wenn das Spiel aktiv wird

func start_wave_round() -> void:
	current_wave = 1
	start_wave() # Starte die Welle der Runde

"""
func end_wave() -> void:
	current_wave += 1
	wave_completed.emit()
	# Starte die nächste Welle, oder tue nichts, wenn die Runde vorbei ist.
	# Die Entscheidung, ob eine neue Runde gestartet wird, liegt nun beim RoundManager
	# Der SpawnManager signalisiert nur das Ende der Welle.
"""
