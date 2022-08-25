extends Label

	
func _process(_delta: float) -> void:
	if(fmod(Global.passedTime, 1) == 0):
		self.text = String(Global.passedTime)
