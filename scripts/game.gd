extends Node

@onready var round_manager = get_node("/root/Game/nodeRoundManager")
var game_active:bool = true

signal gameActive(status)

func _ready() -> void:
	# Signal verbinden
	round_manager.connect("round_won", Callable(self, "round_won"))
	
	# Ui Button Setup
	# GEDANKENOTIZ FÜR POTENZIELLE "FEHLERQUELLE"
	UIHelper.setup_ui_buttons_in_scene()

	start_game()
	
func _process(_delta: float) -> void:
	pass
	
func start_game() -> void:	
	# Signal senden
	gameActive.emit(game_active)
	
	# Spieler spawnen
	spawn_player()
	pass

func spawn_player() -> void:
	
	# Test: Größe der Spielfigur skalieren
	$Player.scale = Vector2(0.45, 0.45)
	
	# Spawn Position ermitteln QUICK AND DIRTY
	var spawn_position = $ArenaLevel1/playerSpawnPosition.position	
	$Player.position = spawn_position
	
	print("Spawnmanager spawn player @", spawn_position)
	pass

func round_won() -> void:
	# Logik?^^
	RuntimeParameter.round_won = true
	#get_tree().change_scene_to_file("res://scenes/round_finished.tscn")
	UIHelper.goto_ui_scene("round_finished")
	
func round_lost() -> void:
	# Looooooogik?^^
	print("o7 in den Chat")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"):
		_toggle_pauseMenu()

func _toggle_pauseMenu() -> void:	
	if $pauseMenu.visible:
		$pauseMenu.hide()
		Engine.time_scale = 1.0
		game_active = true
	else:
		$pauseMenu.show()
		# Controller QUICK AND DIRTY FIX da UIHelper.setup_ui_buttons_in_scene() NICHT GREIFT
		$pauseMenu/Control/VBoxContainer/continue.grab_focus()		
		Engine.time_scale = 0
		game_active = false
	gameActive.emit(game_active)

func _goto_mainmenu() -> void:
	# Spielpause beenden "QUICK AND DIRTY"
	Engine.time_scale = 1
	UIHelper.goto_ui_scene("main_menu")

func _on_continue_pressed() -> void:
	_toggle_pauseMenu()

func _on_mainmenu_pressed() -> void:
	_goto_mainmenu()
