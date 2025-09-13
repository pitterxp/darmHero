extends Node

@onready var round_manager = get_node("/root/Game/nodeRoundManager")
@onready var spawn_manager = get_node("/root/Game/nodeSpawnManager")
@onready var player = $Player

var game_active:bool = true
var is_paused: bool = false

signal gameActive(status)
signal gamePaused(status)
signal gameState(game_active, is_paused)

func _ready() -> void:
	# Signal verbinden
	round_manager.connect("round_won", Callable(self, "round_won"))
	
	# Ui Button Setup
	# GEDANKENOTIZ FÜR POTENZIELLE "FEHLERQUELLE"
	UIHelper.setup_ui_buttons_in_scene()
	
	$pauseMenu.set_process_mode(Node.PROCESS_MODE_ALWAYS)

	start_game()
	

func _process(_delta: float) -> void:
	pass

func start_game() -> void:	
	# Signal senden
	gameState.emit(game_active, is_paused)
	
	# Spieler spawnen
	spawn_player()
	
	# Kamera 
	var arena = $ArenaLevel1
	player.position = arena.get_node("playerSpawnPosition").global_position
	arena.set_player_reference()

func spawn_player() -> void:
	# Spawn Position ermitteln QUICK AND DIRTY
	var spawn_position = $ArenaLevel1/playerSpawnPosition.position	
	$Player.position = spawn_position
	
	print("Spawnmanager spawn player @", spawn_position)


func round_won() -> void:
	# Logik?^^
	RuntimeParameter.current_round_data[0]["round_won"] = true
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
		get_tree().paused = false
		is_paused = false
	else:
		$pauseMenu.show()
		# Controller QUICK AND DIRTY FIX da UIHelper.setup_ui_buttons_in_scene() NICHT GREIFT
		$pauseMenu/Control/VBoxContainer/continue.grab_focus()		
		get_tree().paused = true
		is_paused = true
	gameState.emit(game_active, is_paused)

func _goto_mainmenu() -> void:
	# Spielpause beenden "QUICK AND DIRTY"
	get_tree().paused = false
	UIHelper.goto_ui_scene("main_menu")

func _on_continue_pressed() -> void:
	_toggle_pauseMenu()

func _on_mainmenu_pressed() -> void:
	_goto_mainmenu()
