extends Node2D



func _on_BackButton_button_up():
	get_node("Click").play()
	SceneTransition.change_scene("res://Scenes/MainScene.tscn")
