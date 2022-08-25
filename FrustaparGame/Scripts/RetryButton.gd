extends Button


func _on_RetryButton_button_up():
	Global.score = 0
	Global.speed = Global.levelSpeed[Global.level - 1]
	Global.stopped = false
	Global.passedTime = 0
	Global.waitTime = 0
	Global.level = 1
	Global.gameEnded = false
	get_tree().paused = false
	get_tree().reload_current_scene()
	
