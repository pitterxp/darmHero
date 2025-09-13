extends Node

@onready var difficulty = RuntimeParameter.difficulty_setting
@onready var round_timer = GameParameter.gameSettings[difficulty]["roundDuration"]

var round_number:int = 0
var round_active:bool = false

# Erweiterung: RoundManager verwaltet auch die Bedigung "Alle Gegner getötet" 
#var total_spawned_enemies: int = 0
var killed_enemies_count: int = 0

# Signale
#signal round_started
signal round_won
signal timer_updated(time_remaining) # HUD
signal loot_drop() #HUD

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
	#print("Runde #" + str(round_number) + " gestartet. Rundenzeit: ", GameParameter.gameSettings[difficulty]["roundDuration"])

func _process(delta):
	if round_active:
		round_timer -= delta
		timer_updated.emit(round_timer)

# Getötete Gegner mitzählen
func _on_enemy_died(target) -> void:
	# TODO
	# {"round_won": false, "current_round": 0, "enemies_spawned": 0, "enemies_killed_in_round": 0}
	#print(_target.get_method_list())
	#print(_target.get_property_list())
	#print("Drop XP:", target.xp," & Money: ", target.money)
	#{"round_won": false, "current_round": 0, "enemies_spawned": 0, "enemies_killed_in_round": 0, "xp": 0, "money": 0}
	
	# HUD über Drop informieren
	# Dafür diese Daten speichern
	RuntimeParameter.current_round_data[0]["xp"] += target.xp
	RuntimeParameter.current_round_data[0]["money"] += target.money	
	loot_drop.emit()

	killed_enemies_count += 1
	var current_round_data = RuntimeParameter.current_round_data[0]
	current_round_data["enemies_killed_in_round"] = killed_enemies_count	
	if current_round_data["enemies_spawned"] == killed_enemies_count:
		current_round_data["round_won"] = true
		UIHelper.goto_ui_scene("round_finished")
