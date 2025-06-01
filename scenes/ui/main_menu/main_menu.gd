extends CanvasLayer

func _ready() -> void:
	# Ui Button Setup + Controller Focus
	UIHelper.setup_ui_buttons_in_scene()
	
	# Passende Musik laden, jetzt ganz easy peasy dank nummer 1 
	AudioManager.play_bgm("Aquarium")

func _on_options_pressed() -> void:
	UIHelper.goto_ui_scene("options_menu")

func _on_play_pressed() -> void:
	UIHelper.goto_ui_scene("pre_game")
