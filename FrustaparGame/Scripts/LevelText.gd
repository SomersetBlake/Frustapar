extends Label


func _ready() -> void:
	Global.level = Global.selectedLevel
	self.text = String(Global.level)

func changeLevel():
	Global.parent_node.get_parent().get_node("Labels").get_node("LevelText").text = String(Global.level)
