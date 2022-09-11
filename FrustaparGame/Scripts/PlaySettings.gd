extends Node2D


onready var drop_Down_Menu = $Control/Level/VBoxContainer/SelectLevel

func _ready():
	add_options()
	Global.selectedLevel = 1
	
	
func add_options():
	drop_Down_Menu.add_item("LEVEL 1");
	drop_Down_Menu.add_item("LEVEL 2");
	drop_Down_Menu.add_item("LEVEL 3");
	drop_Down_Menu.add_item("LEVEL 4");
	drop_Down_Menu.add_item("LEVEL 5");
	drop_Down_Menu.add_item("LEVEL 6");
	drop_Down_Menu.add_item("LEVEL 7");
	drop_Down_Menu.add_item("LEVEL 8");
	drop_Down_Menu.add_item("LEVEL 9");
	drop_Down_Menu.add_item("LEVEL 10");
	drop_Down_Menu.add_item("LEVEL 11");
	drop_Down_Menu.add_item("LEVEL 12");
	drop_Down_Menu.add_item("LEVEL 13");
	drop_Down_Menu.add_item("LEVEL 14");
	drop_Down_Menu.add_item("LEVEL 15");


func _on_SelectLevel_item_selected(index):
	get_node("Control/Click").play()
	Global.selectedLevel = index + 1
