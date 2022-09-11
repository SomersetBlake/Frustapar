extends Control


func _on_PlayButton_button_up():
	get_node("Click").play()
	SceneTransition.change_scene("res://Scenes/PlaySettings.tscn")

func _on_HighscoreButton_button_up():
	get_node("Click").play()
	SceneTransition.change_scene("res://Scenes/HighScore.tscn")

func _on_Audio_button_up():
	get_node("Click").play()
	SceneTransition.change_scene("res://Scenes/Menu.tscn")
	
func _on_QuitGame_button_up():
	get_node("Click").play()
	get_tree().quit()
