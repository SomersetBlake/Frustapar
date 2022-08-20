extends Label

func _ready() -> void:
	self.text = "0"

func changeText():
	if Global.score < 1000000:
		Global.parent_node.get_parent().get_node("Labels").get_node("Score").text = String(Global.score)
	else:
		Global.parent_node.get_parent().get_node("Labels").get_node("Score").text = String(stepify(float(Global.score)/1000000,0.001)) + "M"
	
