extends CanvasLayer

@onready var round_manager = get_node("/root/Game/nodeRoundManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Signale verbinden
	round_manager.connect("timer_updated", Callable(self, "_on_timer_updated"))
	round_manager.connect("loot_drop", Callable(self, "_on_loot_drop"))
	
func format_seconds(total_seconds: int) -> String:
	@warning_ignore("integer_division")
	return str("%02d:%02d" % [total_seconds  / 60, total_seconds % 60])
	
func _on_timer_updated(time_remaining) -> void:
	$Control/VBoxContainer/displayTimer.text = format_seconds(time_remaining)
	
func _on_loot_drop() -> void:
	$Control/HBoxContainer/xpDisplay/displayXP.text = str(RuntimeParameter.current_round_data[0]["xp"])
	$Control/HBoxContainer/moneyDisplay/displayMoney.text = str(RuntimeParameter.current_round_data[0]["money"])
