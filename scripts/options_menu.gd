extends CanvasLayer

func _ready() -> void:
	# UI Button Setup + Controller Focus
	UIHelper.setup_ui_buttons_in_scene()

func _on_mainmenu_pressed() -> void:
	UIHelper.goto_ui_scene("main_menu")

func _on_intro_pressed() -> void:
	# Intro erneut abspielen
	UIHelper.goto_ui_scene("intro")
