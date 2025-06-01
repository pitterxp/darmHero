@tool
class_name AudioLibrary
extends Resource

@export var refresh_on_ready: bool = false:
	set = _set_refresh_on_ready

@export var music: Dictionary = {}
@export var sfx: Dictionary = {}

func _set_refresh_on_ready(value: bool) -> void:
	refresh_on_ready = value
	if value:
		populate()
		print("🎧 AudioLibrary: Neu eingelesen.")
		refresh_on_ready = false  # Reset nach dem Ausführen

func populate():
	music = _load_from_dir("res://assets/bgMusic/")
	sfx = _load_from_dir("res://assets/sfx/")
	# Optional: autosave nach erfolgreichem Populate
	# ResourceSaver.save(get_path(), self)

func _load_from_dir(path: String) -> Dictionary:
	var result := {}
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.ends_with(".ogg") or file_name.ends_with(".mp3") or file_name.ends_with(".wav"):
					var key = file_name.get_basename()
					var stream = load(path + file_name)
					if stream:
						result[key] = stream
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("❌ Konnte Verzeichnis nicht öffnen: " + path)
	return result
