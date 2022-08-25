extends Control

onready var LevelSelect = get_node("Level")
onready var border = get_node("Border")


func _on_BackButton_button_up():
	if(border.rect_scale != Vector2(1,1)):
		var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_property(border, "rect_position", Vector2(185,border.rect_position.y), 0.5 )
		tween.parallel().tween_property(border, "rect_scale", Vector2(1,1), 0.5 )
		LevelSelect.visible = false
		tween.parallel().tween_property(LevelSelect, "rect_scale", Vector2(0,0), 0.75 )
	else:
		get_tree().change_scene("res://Scenes/MainScene.tscn")


func _on_PLAY_button_up():
	get_tree().change_scene("res://Game.tscn")
