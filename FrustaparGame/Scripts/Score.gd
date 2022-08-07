extends Label

func _ready() -> void:
	self.text = "String(Global.score)KKK"

func changeText():
	Global.parent_node.get_parent().get_node("Score").text = String(Global.score)
	
