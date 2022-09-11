extends Node2D

var top_100 = []
var master_volume = 0
var music_volume = 0
var sound_volume = 0
const FILEPATH = "user://score.data"
const VOLUMEPATH = "user://volume.data"

func _ready():
	load_scores()
	load_volume()
	
	
func load_scores():
	var file = File.new()
	if file.file_exists(FILEPATH):
		var error = file.open_encrypted_with_pass(FILEPATH, File.READ, "#EveryD4ySc0re")
		if error == OK:
			top_100 = file.get_var()
			file.close()
			
			
func save_scores():
	correct_data()
	var file = File.new()
	var error = file.open_encrypted_with_pass(FILEPATH, File.WRITE,"#EveryD4ySc0re")
	if error == OK:
		file.store_var(top_100)
		file.close()

func correct_data():
	top_100.sort()
	top_100.invert()
	if(top_100.size() > 100):
		top_100.pop_back()


func load_volume():
	var file = File.new()
	if file.file_exists(VOLUMEPATH):
		var error = file.open_encrypted_with_pass(VOLUMEPATH, File.READ, "#EveryD4yV0lume")
		if error == OK:
			master_volume = file.get_var()
			music_volume = file.get_var()
			sound_volume = file.get_var()
			file.close()
	set_volume()


func save_volume():
	var file = File.new()
	var error = file.open_encrypted_with_pass(VOLUMEPATH, File.WRITE,"#EveryD4yV0lume")
	if error == OK:
		file.store_var(master_volume)
		file.store_var(music_volume)
		file.store_var(sound_volume)
		file.close()
		
func set_volume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
	if(master_volume == - 40):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),false)
		
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
	if(music_volume == - 40):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),false)
		
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), sound_volume)
	if(sound_volume == - 40):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"),false)
