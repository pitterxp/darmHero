extends Node

# Namen definieren
const INTRO = "intro"
const MAIN_MENU = "main_menu"
const OPTIONS_MENU = "options_menu"
const PRE_GAME = "pre_game"
const ROUND_FINISHED = "round_finished"
const GAME = "game"


# Pfade definieren und vorladen
var ui_scenes = {
	INTRO: preload("res://scenes/ui/intro.tscn"),
	MAIN_MENU: preload("res://scenes/ui/main_menu.tscn"),
	OPTIONS_MENU: preload("res://scenes/ui/options_menu.tscn"),
	PRE_GAME: preload("res://scenes/ui/pre_game.tscn"),
	ROUND_FINISHED: preload("res://scenes/ui/round_finished.tscn"),
}

# Pfade definieren ohne vorzuladen
var game_scenes = {
	GAME: "res://scenes/game.tscn"
}

func _ready() -> void:
	pass

# UI Szene wechseln
func goto_ui_scene(scene_name:String) -> void:
	if ui_scenes.has(scene_name):
		get_tree().change_scene_to_packed(ui_scenes[scene_name])
	else:
		push_error("UI Szene nicht gefunden: " + scene_name)

# Game Szene wechseln
func goto_game_scene(scene_name:String) -> void:
	if game_scenes.has(scene_name):
		get_tree().change_scene_to_file(game_scenes[scene_name])
	else:
		push_error("Game Szene nicht gefunden:" + scene_name)

# main_ui_button sound setup
func setup_ui_buttons_in_scene():
	await get_tree().process_frame
	
	# Alle Buttons in der "main_ui_button" Gruppe finden
	var buttons = get_tree().get_nodes_in_group("main_ui_button")
	
	for button in buttons:
		if button is Button:
			
			# Quick and dirty:
			button.grab_focus()
			if not button.is_connected("pressed", _on_main_ui_button_pressed):
				button.pressed.connect(_on_main_ui_button_pressed.bind(button))

# main_ui_button sound playing
func _on_main_ui_button_pressed(button):
	# Sound abspielen
	var variation = 0
	if button.has_meta("sound_variation"):
		variation = button.get_meta("sound_variation")
	
	AudioManager.play_ui_button_sound(variation)
		
# Controller -> Fokussteuerung
func set_initial_focus(focus_node_path: NodePath) -> void:
	if focus_node_path:
		var node = get_node_or_null(focus_node_path)
		if node and node.has_method("grab_focus"):
			# Warte einen Frame, damit die UI vollständig geladen ist
			await get_tree().process_frame
			node.grab_focus()
