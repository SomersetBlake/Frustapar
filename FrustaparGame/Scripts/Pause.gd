extends Control

onready var scene_tree = get_tree()
onready var pause_screen: ColorRect = get_node("PauseScreen")

var paused: = false setget set_paused


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = !paused
		scene_tree.set_input_as_handled()
		
		
func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_screen.visible = value


func _on_ExitButton_button_up():
	var ev = InputEventAction.new()
	ev.action = "pause"
	ev.pressed = true
	Input.parse_input_event(ev)
	reset_variables()
	SceneTransition.change_scene("res://Scenes/MainScene.tscn")
	
	
func reset_variables():
	Global.score = 0
	Global.speed = Global.levelSpeed[Global.selectedLevel - 1]
	Global.stopped = false
	Global.passedTime = 0
	Global.waitTime = 0
	Global.level = 1
	Global.gameEnded = false
	Global.last_row = -12
