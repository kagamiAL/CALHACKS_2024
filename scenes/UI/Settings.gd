extends "res://scenes/UI/Dialog.gd"

func _ready():
	$%MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundTrack")))
	$%SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects")))

func _on_music_slider_value_changed(value):
	set_volume("SoundTrack", value)

func _on_sfx_slider_value_changed(value):
	set_volume("SoundEffects", value)
	
func set_volume(bus : String, value : float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(bus),
		linear_to_db(value)
	)
