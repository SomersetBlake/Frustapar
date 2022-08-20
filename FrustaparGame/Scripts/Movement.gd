extends Node2D

func move_down():
	var empty_nb = 0
	for x in Global.width:
		empty_nb = 0
		for y in Global.height:
			if(typeof(Global.pieces_table[x][y]) == TYPE_OBJECT && Global.pieces_table[x][y] != null):
				if Global.pieces_table[x][y].piece_type == "empty":
					empty_nb += 1
				elif(empty_nb != 0):
					change_pos(Vector2(x,y), 0, empty_nb * -1)
					Global.pieces_table[x][y].matchable = false
			else:
				print("ERROR")

#Changes position of a piece based on the direction of mouse
func mouse_movement():
	var grid_creator = preload('res://Scripts/Create_Grid.gd').new()
	var matching_node = preload('res://Scripts/Matching.gd').new()
	var release_pos = Global.parent_node.get_global_mouse_position() 
	var piece_pos = null
	if(grid_creator.is_in_grid(Global.first_pos)):
		piece_pos = grid_creator.position_to_grid(Global.first_pos)
	else:
		piece_pos = null
	if(abs(Global.first_pos.y - release_pos.y) < 25):
		if(Global.first_pos.x - release_pos.x > 0 && piece_pos != null):
			if(piece_pos.x - 1 >= 0):
				if(Global.pieces_table[piece_pos.x][piece_pos.y].movable == true &&
				Global.pieces_table[piece_pos.x - 1][piece_pos.y].movable == true):				
					change_pos(piece_pos, -1, 0)
					Global.pieces_table[piece_pos.x][piece_pos.y].combo_Time = 0
					Global.pieces_table[piece_pos.x - 1][piece_pos.y].combo_Time = 0
					matching_node.tag_matching(piece_pos)
					matching_node.tag_matching(Vector2(piece_pos.x - 1, piece_pos.y))
					move_down()
		elif(Global.first_pos.x - release_pos.x < 0 && piece_pos != null):
			if(piece_pos.x + 1 < Global.width ):
				if(Global.pieces_table[piece_pos.x][piece_pos.y].movable == true &&
				Global.pieces_table[piece_pos.x + 1][piece_pos.y].movable == true):
					change_pos(piece_pos, 1, 0)
					Global.pieces_table[piece_pos.x][piece_pos.y].combo_Time = 0
					Global.pieces_table[piece_pos.x + 1][piece_pos.y].combo_Time = 0
					matching_node.tag_matching(piece_pos)
					matching_node.tag_matching(Vector2(piece_pos.x + 1, piece_pos.y))
					move_down()
		else:
			pass

func change_pos(pos: Vector2, x: int, y: int):
	if(pos.x + x < Global.width && pos.x + x >= 0 && pos.y + y >= 0 && pos.y < Global.height):
		var changable = true
		if( y != 0):
			changable = Global.pieces_table[pos.x][pos.y].movable_down
		if(changable):
			var stored_piece
			stored_piece = Global.pieces_table[pos.x][pos.y] 
			Global.pieces_table[pos.x][pos.y].matchable = false
			Global.pieces_table[pos.x + x][pos.y + y].matchable = false
			Global.pieces_table[pos.x][pos.y].node_pos = Global.pieces_table[pos.x][pos.y].node_pos + Vector2(x*Global.size,y*Global.size * -1)
			Global.pieces_table[pos.x][pos.y] = Global.pieces_table[pos.x + x][pos.y + y]
			Global.pieces_table[pos.x + x][pos.y + y].node_pos = Global.pieces_table[pos.x + x][pos.y + y].node_pos - Vector2(x*Global.size,y*Global.size * -1)
			Global.pieces_table[pos.x + x][pos.y + y] = stored_piece
			if(y != 0):
				move_pieces_Y()
			elif(x != 0):
				Global.pieces_table[pos.x][pos.y].movable_down = false
				Global.pieces_table[pos.x + x][pos.y + y].movable_down = false
				move_pieces_X()

func move_pieces_Y():
	if(Global.can_move_Y):
		Global.can_move_Y = false
		var tween1
		var tween_time = 0.15
		for x in Global.width:
			for y in Global.height:
				if(Global.pieces_table[x][y].position.y != Global.pieces_table[x][y].node_pos.y):
					tween1 = Global.pieces_table[x][y].get_node("Tween")
					tween1.interpolate_property(Global.pieces_table[x][y], "position",
					 Global.pieces_table[x][y].position, Global.pieces_table[x][y].node_pos,
					 tween_time, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
					tween1.start()
		yield(Global.parent_node.get_tree().create_timer(tween_time),"timeout")
		Global.can_move_Y = true
		make_matchable()

func move_pieces_X():
	var tween1
	var tween_time = 0.1
	for x in Global.width:
		for y in Global.height:
			if(Global.pieces_table[x][y].position.x != Global.pieces_table[x][y].node_pos.x):
				reset_combo(x)
				tween1 = Global.pieces_table[x][y].get_node("Tween")
				tween1.interpolate_property(Global.pieces_table[x][y], "position",
				 Global.pieces_table[x][y].position, Global.pieces_table[x][y].node_pos,
				 tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween1.start()
				make_movable_down(x,y,tween_time)
		make_matchable()
		
#It resets the combo counter, if a piece was moved
func reset_combo(x):
	var y = 0
	while(y<Global.height):
		Global.pieces_table[x][y].combo = 1
		Global.pieces_table[x][y].combo_Time = Global.passedTime
		y += 1

func make_movable_down(x,y,t):
	yield(Global.parent_node.get_tree().create_timer(t),"timeout")
	Global.pieces_table[x][y].movable_down = true

func make_matchable():
	var matching_node = preload('res://Scripts/Matching.gd').new()
	matching_node.make_matchable()	
