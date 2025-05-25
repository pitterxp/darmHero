extends CanvasLayer

func _ready() -> void:
	# Ui Button Setup + Controller Focus
	UIHelper.setup_ui_buttons_in_scene()

func _on_options_pressed() -> void:
	UIHelper.goto_ui_scene("options_menu")

func _on_play_pressed() -> void:
	UIHelper.goto_ui_scene("pre_game")
