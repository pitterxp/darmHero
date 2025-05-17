extends Node

@onready var default_click_sfx = $sfx/Click
var bgm_playing:bool = false
@onready var default_bgmusic = $"bgm/Acf-bg"

const BGM_BUS_NAME = "bgm"
const SFX_BUS_NAME = "sfx"

func _ready() -> void:
	# "QUICK AND DIRTY" -> ui_volume_slider.gd regelt zZ
	set_bgm_volume(GameParameter.bgmVolume)
	set_sfx_volume(GameParameter.sfxVolume)
	
	# Default BGM start
	default_bgmusic.autoplay = true
	default_bgmusic.set("parameters/looping", true)
	default_bgmusic.play()
	bgm_playing = true

func play_sfx(sfx_name:String) -> void:
	if has_node("sfx/" + sfx_name):
		var player: AudioStreamPlayer = get_node("sfx/" + sfx_name)
		player.play()
	else:
		printerr("Soundeffekt nicht gefunden: " + sfx_name)

func play_bgm() -> void:
	pass
	
func stop_bgm() -> void:
	pass

func set_bgm_volume(new_volume:float) -> void:
	new_volume = clamp(new_volume, 0.0, 1.0)
	var db_value = linear_to_db(new_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BGM_BUS_NAME), db_value)
	pass
	
func set_sfx_volume(new_volume:float) -> void:
	new_volume = clamp(new_volume, 0.0, 1.0)
	var db_value = linear_to_db(new_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS_NAME), db_value)
	pass

# UI-Sound Methode
func play_ui_button_sound(variation = 0):
	if variation <= 0:
		# default klick sound abspielen
		default_click_sfx.play()
