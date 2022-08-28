extends Node2D

var top_100 = []
const FILEPATH = "user://score.data"

func _ready():
	load_scores()
	
	
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
