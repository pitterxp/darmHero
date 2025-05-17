extends CanvasLayer

@onready var time_label = $Control/displayTimer  # Annahme: Ein Label-Node für die Zeitanzeige
@onready var round_manager = get_node("/root/Game/nodeRoundManager")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("Hud _ready()")
	# Signal verbinden
	round_manager.connect("timer_updated", Callable(self, "_on_timer_updated"))
	
func format_seconds(total_seconds: int) -> String:
	@warning_ignore("integer_division")
	return str("%02d:%02d" % [total_seconds  / 60, total_seconds % 60])
	
func _on_timer_updated(time_remaining) -> void:
	#print("Roundmanager signal empfangen, aktualisiere HUD Anzeige")
	time_label.text = format_seconds(time_remaining)
