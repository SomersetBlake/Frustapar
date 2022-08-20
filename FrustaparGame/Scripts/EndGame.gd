extends Node

var win_line_node = Node2D

func end_game():
	for x in Global.width:
		if(Global.pieces_table[x][Global.height - 1].piece_type != "empty"):
			if(Global.pieces_table[x][Global.height - 1].global_position.y <= 64 + Global.size/2 && Global.speed != 0):
				Global.speed = 0
				Global.gameEnded = true
				var i = Global.height - 1
				while(i >= 0):
					for a in Global.width:
						Global.pieces_table[a][i].modulate = Color(0.2,0.2,0.2,1)
					yield(Global.parent_node.get_tree().create_timer(0.1),"timeout")
					i -= 1
				break
				
			elif(win_line_node != Node2D):
				if (Global.pieces_table[x][Global.height - 1].global_position.y >= win_line_node.rect_global_position.y):
					Global.levelSpeed += 5
					Global.speed = Global.levelSpeed
		#			Global.gameEnded = true
					Global.level += 1
					Global.last_row = Global.added_rows + 2
					change_level()
					win_line_node = Node2D

func change_level():
	var chLevel = preload("res://Scripts/LevelText.gd").new()
	chLevel.changeLevel()



#makes the lowest pieces gray and disables it matching
func low_pieces():
	for x in Global.width:
		for y in Global.height:
			if(Global.pieces_table[x][y].global_position.y >= 448 - Global.size/2 && 
			Global.pieces_table[x][y].global_position.y <= 482 - Global.size/2):
				Global.pieces_table[x][y].modulate = Color(0.2,0.2,0.2,1)
				Global.pieces_table[x][y].movable = false
				Global.pieces_table[x][y].matchable = false		
			elif(Global.pieces_table[x][y].modulate == Color(0.2,0.2,0.2,1)):				
				Global.pieces_table[x][y].modulate = Color(1,1,1,1)
				Global.pieces_table[x][y].matchable = true
				Global.pieces_table[x][y].movable = true



#Function starts every time a line is destroyed, it checks whether it should 
#make a line that determines the end of level. It checks by comparing created rows
#to number of created rows to finish
func win_line():
	if(Global.added_rows >= Global.last_row):
		Global.last_row = Global.added_rows + 20000
		win_line_node = preload("res://Pieces/Win_game_line.tscn").instance()
		Global.parent_node.add_child(win_line_node)
		win_line_node.rect_size.x = Global.size * Global.width
		win_line_node.rect_position = Vector2(Global.pieces_table[0][0].position.x - Global.size/2,
		Global.pieces_table[0][0].position.y - Global.size/2)
