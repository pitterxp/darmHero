extends CanvasLayer

func _ready() -> void:	
	# Ui Button Setup + Controller Focus
	UIHelper.setup_ui_buttons_in_scene()
	
	# Rundenergebnisse current_round auslesen und anzeigen
	_show_round_result()

func _show_round_result() -> void:
	var current_round_results = RuntimeParameter.current_round_data[0]
	var round_won = current_round_results["round_won"]
	var current_round = current_round_results["current_round"]
	var enemies_killed = current_round_results["enemies_killed_in_round"]
	
	# roundResult => Gewonnen/verloren anzeigen
	if round_won:
		$content/roundResult.text = "SIEG"
		$content/roundResult.add_theme_color_override("font_color", Color.GREEN)		
	else:
		$content/roundResult.text = "Oh noes"
		$content/roundResult.add_theme_color_override("font_color", Color.RED)
		
	# roundStatistics => Details anzeigen
	$content/roundStatistics.text = "Runde(n): "+str(current_round)+" \nMobs gekillt: " + str(enemies_killed)

func _on_replay_pressed() -> void:
	UIHelper.goto_game_scene("game")

func _on_new_pressed() -> void:
	UIHelper.goto_ui_scene("pre_game")


func _on_mainmenu_pressed() -> void:
	UIHelper.goto_ui_scene("main_menu")
