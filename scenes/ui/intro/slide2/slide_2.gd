extends Control

@onready var picture = $VisualLayer/picture
@onready var dialog = $VisualLayer/dialogText

func _ready() -> void:
	print("Slide 2")

func set_content(image_path: String, text: String):
	picture.texture = load(image_path)
	dialog.text = text
