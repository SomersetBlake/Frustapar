extends Label


#onready var _timer = get_node("Timer")
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	_timer.set_wait_time(0.25)
#	_timer.set_one_shot(false)
#	_timer.start()
	
func _process(_delta: float) -> void:
	if(fmod(Global.passedTime, 1) == 0):
		self.text = String(Global.passedTime)


#func _on_Timer_timeout() -> void:
#	Global.passedTime += 0.25
