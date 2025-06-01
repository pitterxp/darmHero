extends Control

var slide1: PackedScene = preload("res://scenes/ui/intro/slide1/slide_1.tscn")
var slide2: PackedScene = preload("res://scenes/ui/intro/slide2/slide_2.tscn")
var slide3: PackedScene = preload("res://scenes/ui/intro/slide3/slide_3.tscn")
var slide4: PackedScene = preload("res://scenes/ui/intro/slide4/slide_4.tscn")

var user_cancel:int = 0

var intro_sequence = [
	{"slide": slide1, "fade_in_duration": 0.4, "display_duration": 3, "fade_out_duration": 0.4},
	{"slide": slide2, "fade_in_duration": 0.4, "display_duration": 3, "fade_out_duration": 0.4},
	{"slide": slide3, "fade_in_duration": 0.4, "display_duration": 3.5, "fade_out_duration": 0.4},
	{"slide": slide4, "fade_in_duration": 0.4, "display_duration": 3, "fade_out_duration": 0.4},
]

var current_step = 0
var active_tween: Tween

func _ready():
	
	# Wurde das Intro bereits aufgerufen?
	if !RuntimeParameter.intro_first_time:
		user_cancel = 5

	_process_intro_step()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_intro"):
		user_cancel += 1
		if user_cancel < 2:
			AudioManager.play_sfx("huh")
		else:
			current_step += 1
			_process_intro_step()

func _process_intro_step() -> void:
	# Benutzer-Überspringen zurücksetzen
	user_cancel = 0

	# Ende der Sequenz erreicht?
	if current_step >= intro_sequence.size():
		UIHelper.goto_ui_scene("main_menu")
		return

	# Daten der aktuellen Slide
	var step_data = intro_sequence[current_step]
	var slide_scene = step_data["slide"]
	var fade_in_duration = step_data["fade_in_duration"]
	var display_duration = step_data["display_duration"]
	var fade_out_duration = step_data["fade_out_duration"]

	# Zielnode vorbereiten
	var target_node = $sliderContent
	free_children(target_node)

	# Slide instanziieren & hinzufügen
	var slide_instance = slide_scene.instantiate()
	target_node.add_child(slide_instance)

	# Fade In (von Slide selbst verwaltet)
	await slide_instance.fade_in(fade_in_duration)

	# Warten
	await get_tree().create_timer(display_duration).timeout

	# Fade Out
	await slide_instance.fade_out(fade_out_duration)

	# Nächste Slide
	current_step += 1
	_process_intro_step()

func free_children(target: Node):
	for c in target.get_children():
		target.remove_child(c)
		c.queue_free()

func _intro_step_finished():
	current_step += 1
	_process_intro_step()

func _on_skip_pressed() -> void:
	print("SKIP")
	UIHelper.goto_ui_scene("main_menu")
