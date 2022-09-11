extends Button



func _on_LevelSelect_button_up():
	get_node("Click").play()
	var LevelSelect = get_node("../../../Level/")
	var border = get_node("../../")
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(border, "rect_position", Vector2(25,border.rect_position.y), 0.5 )
	tween.parallel().tween_property(border, "rect_scale", Vector2(0.5,0.5), 0.5 )
	LevelSelect.visible = true
	tween.parallel().tween_property(LevelSelect, "rect_scale", Vector2(0.75,0.75), 0.75 )
	
	
