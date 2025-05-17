extends CanvasLayer

@onready var button_group = $content/difficulty/difficultyButtons/btnEasy.button_group
var difficulty_preset: String = "easy" # Default Schwierigkeitsgradauswahl

func _ready() -> void:
	# Signal für Schwierigkeitsgradwahl
	button_group.pressed.connect(toggle_difficulty)
	
	# Schwierigkeitsgrad-Infos auf "Medium"
	toggle_difficultyInfo()
	
	# Ui Button Setup + Controller Focus
	UIHelper.setup_ui_buttons_in_scene()

func format_seconds(total_seconds: int) -> String:
	@warning_ignore("integer_division")
	return str("%02d:%02d" % [total_seconds  / 60, total_seconds % 60])

func toggle_difficulty(button):	
	match button.name:
		"btnEasy":
			difficulty_preset = "easy"
		"btnMedium":
			difficulty_preset = "medium"
		"btnHard":
			difficulty_preset = "hard"
	toggle_difficultyInfo()

func toggle_difficultyInfo():
	var difficulty_info = GameParameter.gameSettings[difficulty_preset]
	var new_text = str(difficulty_info["rounds"]) + " Runden\n" + format_seconds(difficulty_info["roundDuration"]) + " Rundenzeit\n" + str(difficulty_info["min_enemies"]) + " - " + str(difficulty_info["max_enemies"]) + " Gegner"
	$content/difficulty/difficultyInfo.text = new_text

func _start_game() -> void:
	# User Diff. Auswahl speichern
	RuntimeParameter.difficulty_setting = difficulty_preset
	UIHelper.goto_game_scene("game")

func _on_play_pressed() -> void:
	_start_game()

func _on_mainmenu_pressed() -> void:
	UIHelper.goto_ui_scene("main_menu")
