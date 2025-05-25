extends CanvasLayer

func _ready() -> void:	
	# Ui Button Setup + Controller Focus
	UIHelper.setup_ui_buttons_in_scene()
	
	# Rundenergebnis anzeigen
	_show_round_result()

func _show_round_result() -> void:
	if RuntimeParameter.round_won:
		$content/roundResult.text = "SIEG"
		$content/roundResult.add_theme_color_override("font_color", Color.GREEN)
	else:
		$content/roundResult.text = "Oh noes"
		$content/roundResult.add_theme_color_override("font_color", Color.RED)
	pass

func _on_replay_pressed() -> void:
	UIHelper.goto_game_scene("game")

func _on_new_pressed() -> void:
	UIHelper.goto_ui_scene("pre_game")


func _on_mainmenu_pressed() -> void:
	UIHelper.goto_ui_scene("main_menu")
