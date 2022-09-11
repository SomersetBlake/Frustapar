extends Label

func _ready():
	self.text = "HIGHSCORE\n" + String(Score_Saving.top_100[0])
