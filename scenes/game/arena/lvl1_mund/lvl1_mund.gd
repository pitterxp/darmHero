extends Node2D

@onready var camera := $Camera2D
@onready var player := $"../Player"

func _ready() -> void:
	#print($bgImg2.texture.get_size())
	pass

func _process(delta: float) -> void:
	if player:
		camera.global_position = camera.global_position.lerp(player.global_position, 10 * delta)

func set_player_reference():
	camera.make_current()
	camera.position = player.global_position  # Kamera sofort zentrieren
