extends Control


func _on_PlayButton_button_up():
	get_tree().change_scene("res://Scenes/PlaySettings.tscn")


func _on_QuitGame_button_up():
	get_tree().quit()
