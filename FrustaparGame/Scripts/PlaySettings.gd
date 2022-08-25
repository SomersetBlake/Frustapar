extends Node2D


onready var drop_Down_Menu = $Control/Level/VBoxContainer/SelectLevel

func _ready():
	add_options()
	
	
func add_options():
	drop_Down_Menu.add_item("LEVEL 1");
	drop_Down_Menu.add_item("LEVEL 2");
	drop_Down_Menu.add_item("LEVEL 3");
	drop_Down_Menu.add_item("LEVEL 4");
	drop_Down_Menu.add_item("LEVEL 5");


func _on_SelectLevel_item_selected(index):
	Global.selectedLevel = index + 1
