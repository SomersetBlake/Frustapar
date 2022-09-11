extends Button


func _on_ResetButton_button_up():
	var ev = InputEventAction.new()
	ev.action = "pause"
	ev.pressed = true
	Input.parse_input_event(ev)
	get_node("Click").play()
