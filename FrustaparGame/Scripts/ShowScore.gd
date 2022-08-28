extends Label


func _ready():
	self.text = "   HIGHSCORE  \n"
	for i in Score_Saving.top_100.size():
		self.text += String(Score_Saving.top_100[i]) + "\n"
