extends CanvasLayer

@onready var fade_rect := $FadeRect
@onready var timer = $Timer

func _ready() -> void:
	fade_rect.color.a = 0.0
	
	# Passende Musik laden, jetzt ganz easy peasy dank nummer 1 
	AudioManager.play_bgm("dvorak-9")
	
	# Timer
	timer.one_shot = true
	timer.wait_time = 2.0
	timer.start()	

func _on_timer_timeout() -> void:
	var fadeout_time: float = 0.5
	var tween = create_tween()	
	tween.tween_property(fade_rect, "color:a", 1.0, fadeout_time)	
	
	# Warte Tween-Zeit
	await get_tree().create_timer(fadeout_time).timeout
	
	UIHelper.goto_ui_scene("intro")
