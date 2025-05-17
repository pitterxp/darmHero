extends Control

@onready var game_title: Label = $gameTitle
@onready var text1: Label = $text1
@onready var text2: Label = $text2
@onready var text3: Label = $text3
@onready var text4: Label = $text4
@onready var text5: Label = $text5

var user_cancel:int = 0

var intro_sequence = [
	{"node": "text1", "fade_in_duration": 0, "display_duration": 1.5, "fade_out_duration": 0.5},
	{"node": "text2", "fade_in_duration": 0.75, "display_duration": 2, "fade_out_duration": 0.75},
	{"node": "text3", "fade_in_duration": 0.75, "display_duration": 3, "fade_out_duration": 0.75},
	{"node": "text4", "fade_in_duration": 0.75, "display_duration": 3, "fade_out_duration": 0.75},
	{"node": "text5", "fade_in_duration": 0.75, "display_duration": 5, "fade_out_duration": 0.75}
]

var current_step = 0
var active_tween: Tween

func _ready():
	# Stelle sicher, dass alle Labels am Anfang unsichtbar sind
	text2.modulate.a = 0.0
	text3.modulate.a = 0.0
	text4.modulate.a = 0.0
	text5.modulate.a = 0.0
	
	# Wurde das Intro bereits aufgerufen?
	if !RuntimeParameter.intro_first_time:
		user_cancel = 5

	_process_intro_step()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_intro"):
		user_cancel += 1
		if user_cancel < 2:
			AudioManager.play_sfx("Huh")
		else:
			RuntimeParameter.intro_first_time = false
			UIHelper.goto_ui_scene("main_menu")
	pass

func _process_intro_step():
	if current_step >= intro_sequence.size():
		# Intro beendet
		UIHelper.goto_ui_scene("main_menu")
		return

	var step_data = intro_sequence[current_step]
	var target_node_name = step_data["node"]
	var fade_in_duration = step_data["fade_in_duration"]
	var display_duration = step_data["display_duration"]
	var fade_out_duration = step_data["fade_out_duration"]

	var target_node: Node

	match target_node_name:
		"text1":
			target_node = text1
		"text2":
			target_node = text2
		"text3":
			target_node = text3
		"text4":
			target_node = text4			
		"text5":
			target_node = text5
		_:
			printerr("Ungültiger Node-Name im Intro-Dictionary: ", target_node_name)
			current_step += 1
			_process_intro_step() # Nächsten Schritt versuchen
			return

	# Fade In
	active_tween = create_tween()
	active_tween.tween_property(target_node, "modulate:a", 1.0, fade_in_duration)

	# Warten
	await get_tree().create_timer(display_duration).timeout

	# Fade Out
	active_tween = create_tween()
	active_tween.tween_property(target_node, "modulate:a", 0.0, fade_out_duration)
	active_tween.tween_callback(self._intro_step_finished)

func _intro_step_finished():
	current_step += 1
	_process_intro_step()
