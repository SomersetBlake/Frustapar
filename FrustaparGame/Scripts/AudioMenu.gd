extends Node2D

func _ready():
	get_node("VBoxContainer/MasterVolume").value = Score_Saving.master_volume
	get_node("VBoxContainer/MusicVolume").value = Score_Saving.music_volume
	get_node("VBoxContainer/SoundVolume").value = Score_Saving.sound_volume

func _on_BackButton_button_up():
	get_node("Click").play()
	SceneTransition.change_scene("res://Scenes/MainScene.tscn")

func _on_MasterVolume_value_changed(value):
	Score_Saving.master_volume = value
	Score_Saving.save_volume()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	if(value == - 40):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),false)
	
func _on_MusicVolume_value_changed(value):
	Score_Saving.music_volume = value
	Score_Saving.save_volume()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	if(value == - 40):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),false)

func _on_SoundVolume_value_changed(value):
	Score_Saving.sound_volume = value
	Score_Saving.save_volume()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), value)
	if(value == - 40):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"),false)
