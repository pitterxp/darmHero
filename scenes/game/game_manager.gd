extends Node

enum GameState {
START_SCREEN,
PLAYING,
PAUSED,
GAME_OVER
}

var current_state = GameState.START_SCREEN
var player_score = 0
@onready var round_manager = $RoundManager
@onready var pause_menu = $PauseMenu

func _ready():
	# Spiel initialisieren
	pause_menu.hide()
	current_state = GameState.START_SCREEN

func start_game():
	if current_state == GameState.START_SCREEN:
		current_state = GameState.PLAYING
		round_manager.start_round()

func end_round():
	if current_state == GameState.PLAYING:
		round_manager.end_round()

func show_pause_menu():
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		pause_menu.show()

func hide_pause_menu():
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		pause_menu.hide()

func game_over():
	current_state = GameState.GAME_OVER
	# Zeige Game Over Bildschirm
