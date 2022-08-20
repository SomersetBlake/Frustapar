extends Label


func _process(_delta: float) -> void:
	if(Global.waitTime > Global.passedTime && 
	fmod(Global.waitTime - Global.passedTime, 1) == 0):
		self.text = "STOP\n" + String(Global.waitTime - Global.passedTime)
	elif(Global.waitTime < Global.passedTime):
		self.text = ""
