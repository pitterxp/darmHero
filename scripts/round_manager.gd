extends Node

@onready var difficulty = RuntimeParameter.difficulty_setting
@onready var round_timer = GameParameter.gameSettings[difficulty]["roundDuration"]

var round_number:int = 0
var round_active:bool = false

# Signale
#signal round_started
signal round_won
signal timer_updated(time_remaining) # HUD

func _ready() -> void:
	# Runde starten: LETS GOOOOOO
	start_round()
	
func start_round() -> void:
	round_number += 1
	round_active = true
	timer_updated.emit(GameParameter.gameSettings[difficulty]["roundDuration"])
	start_timer()
	
func end_round() -> void:
	round_active = false
	#print("runde beendet, spieler GEWINNT. ole ole")
	round_won.emit()

func start_timer() -> void:
	var timer = Timer.new()
	timer.wait_time = GameParameter.gameSettings[difficulty]["roundDuration"]
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(end_round)	
	timer.start()
	print("Runde #" + str(round_number) + " gestartet. Rundenzeit: ", GameParameter.gameSettings[difficulty]["roundDuration"])

func _process(delta):
	if round_active:
		round_timer -= delta
		timer_updated.emit(round_timer)
