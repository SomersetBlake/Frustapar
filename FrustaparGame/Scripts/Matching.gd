extends Node2D




#Returns an array containing how many of the same types of pieces are in a direction
#[0] = up, [1] = down, [2] = right, [3] = left
func piece_match(column, row):
	var array = []
	var nb = 0
	var i = row + 1
	if(Global.pieces_table[column][row].piece_type != "empty" &&
	Global.pieces_table[column][row].piece_type != "Tagged"
	):
		while(i < Global.height):
			if(
				typeof(Global.pieces_table[column][i]) == TYPE_OBJECT):
				if(Global.pieces_table[column][i].piece_type == Global.pieces_table[column][row].piece_type
				&& Global.pieces_table[column][i].matchable == true
				&& Global.pieces_table[column][row].matchable == true
				):
					nb += 1
				else:
					break
			i += 1
		array.append(nb)
		nb = 0
		i = row - 1
		while(i >= 0):
			if(
				typeof(Global.pieces_table[column][i]) == TYPE_OBJECT):
				if(Global.pieces_table[column][i].piece_type == Global.pieces_table[column][row].piece_type
				&& Global.pieces_table[column][i].matchable == true
				&& Global.pieces_table[column][row].matchable == true
				):
					nb += 1
				else:
					break
			i -= 1
		array.append(nb)
		nb = 0
		i = column + 1
		while(i < Global.width):
			if(typeof(Global.pieces_table[i][row]) == TYPE_OBJECT):
				if(
				Global.pieces_table[i][row].piece_type == Global.pieces_table[column][row].piece_type
				&& Global.pieces_table[i][row].matchable == true
				&& Global.pieces_table[column][row].matchable == true
				):
					nb += 1
				else:
					break
			i += 1
		array.append(nb)
		nb = 0
		i = column - 1
		while(i >= 0):
			if(
				typeof(Global.pieces_table[i][row]) == TYPE_OBJECT):
				if(Global.pieces_table[i][row].piece_type == Global.pieces_table[column][row].piece_type
				&& Global.pieces_table[i][row].matchable == true
				&& Global.pieces_table[column][row].matchable == true
				):
					nb += 1
				else:
					break
			i -= 1
		array.append(nb)
		return array
	else:
		array = [0,0,0,0]
		return array


#It takes the array from piece_match and determines whether there is a match
func is_matching(column, row) -> bool:
	var array = piece_match(column,row)
	if(array[0] + array[1] > 1):
		return true
	if(array[2] + array [3] > 1):
		return true
	else: 
		return false
		
		
#Important function
#It tests, whether there is a match
#If it finds a match, it changes pieces type to Tagged, starts the animation,
#changes combo variable of a piece and counts the number of matches of the same type
func tag_matching(pos: Vector2):
	var array = [0,0,0,0]
	var combo_nb = 1
	if(Global.pieces_table[pos.x][pos.y].matchable):
		array = piece_match(pos.x, pos.y)
	if(is_matching(pos.x, pos.y) && array != [0,0,0,0]):
		if(combo_nb < Global.pieces_table[pos.x][pos.y].combo):
			combo_nb = Global.pieces_table[pos.x][pos.y].combo
		match_anim(pos, "White_Blink")
		Global.pieces_table[pos.x][pos.y].piece_type = "Tagged"
		Global.matchedNumber += 1
		if(array[0] + array[1] > 1):
			for y in array[0]:
				if(combo_nb < Global.pieces_table[pos.x][pos.y + 1 + y].combo):
					combo_nb = Global.pieces_table[pos.x][pos.y + 1 + y].combo
				Global.pieces_table[pos.x][pos.y + 1 + y].piece_type = "Tagged"
				match_anim(Vector2(pos.x, pos.y + 1 + y),"White_Blink")
				Global.matchedNumber += 1
			for y in array[1]:
				if(combo_nb < Global.pieces_table[pos.x][pos.y -1 - y].combo):
					combo_nb = Global.pieces_table[pos.x][pos.y -1 - y].combo
				Global.pieces_table[pos.x][pos.y -1 - y].piece_type = "Tagged"
				match_anim(Vector2(pos.x, pos.y - 1 - y),"White_Blink")
				Global.matchedNumber += 1
		if(array[2] + array[3] > 1):
			for x in array[2]:
				if(combo_nb < Global.pieces_table[pos.x + 1 + x][pos.y].combo):
					combo_nb = Global.pieces_table[pos.x + 1 + x][pos.y].combo
				Global.pieces_table[pos.x + 1 + x][pos.y].piece_type = "Tagged"
				match_anim(Vector2(pos.x + 1 + x, pos.y),"White_Blink")
				Global.matchedNumber += 1
			for x in array[3]:
				if(combo_nb < Global.pieces_table[pos.x -1 -x][pos.y].combo):
					combo_nb = Global.pieces_table[pos.x -1 -x][pos.y].combo
				Global.pieces_table[pos.x -1 -x][pos.y].piece_type = "Tagged"
				match_anim(Vector2(pos.x - 1 - x, pos.y),"White_Blink")
				Global.matchedNumber += 1
		if(Global.matchedNumber > 3):
			stop_time()
		Global.score += Global.matchedNumber * 100 * combo_nb
		if(combo_nb > 1):
			combo_anim(pos, combo_nb)
		change_score()
		

func stop_time():
	if Global.stopped == false:
		Global.stopped = true
		Global.speed = 0
		Global.waitTime = Global.passedTime + 4
		var glass = preload("res://Pieces/Hourglass.tscn").instance()
		if(Global.exist_glass == false):
			Global.parent_node.get_parent().add_child(glass)
			glass.global_position = Vector2(348,305)
			Global.exist_glass = true
		yield(Global.parent_node.get_tree().create_timer(4),"timeout")
		if(Global.stopped && is_instance_valid(glass)):
			glass.queue_free()
		Global.exist_glass = false
		Global.speed = Global.levelSpeed[Global.level - 1]
		Global.stopped = false




#Sometimes animation aren't finished before changes appear in pieces_table
func match_anim(pos: Vector2, anim_name):
	var start_added_rows = Global.added_rows
	var anim_Sprite = Global.pieces_table[pos.x][pos.y].get_node("Anim")
	var node = Global.pieces_table[pos.x][pos.y]
	anim_Sprite.play(anim_name)
	Global.pieces_table[pos.x][pos.y].movable = false
	yield(anim_Sprite, "animation_finished")
	if(node == Global.pieces_table[pos.x][pos.y]):
		Global.pieces_table[pos.x][pos.y].movable = true
		if(start_added_rows == Global.added_rows):
			combo_number(pos)
			make_empty(pos)
		elif(start_added_rows != Global.added_rows):
			combo_number(pos)
			make_empty(Vector2(pos.x, pos.y + Global.added_rows - start_added_rows))
	else:
		node.modulate = Color(0.5,0,1,1)

func make_matchable():
	for x in Global.width:
		for y in Global.height:
			if(typeof(Global.pieces_table[x][y]) == TYPE_OBJECT && Global.pieces_table[x][y] != null &&
			is_instance_valid(Global.pieces_table[x][y])):
				if Global.pieces_table[x][y].modulate != Color(0.2,0.2,0.2,1):
					Global.pieces_table[x][y].matchable = true	
				
				
#Changes pieces to empty pieces
func make_empty(pos: Vector2):
	var piece_pos = Global.pieces_table[pos.x][pos.y].position
	explosionAnim(pos)
	Global.pieces_table[pos.x][pos.y].queue_free()
	var piece = Global.empty_piece.instance()
	Global.parent_node.add_child(piece)
	piece.position = piece_pos
	Global.pieces_table[pos.x][pos.y] = piece
	Global.pieces_table[pos.x][pos.y].node_pos = piece_pos
	
	
func explosionAnim(pos: Vector2):
	var explosion = preload("res://Pieces/ExplosionAnimation.tscn").instance()
	Global.parent_node.add_child(explosion)
	explosion.position = Global.pieces_table[pos.x][pos.y].position
	
func change_score():
	var score = preload("res://Scripts/Score.gd").new()
	score.changeText()
	
	
#After matching, every piece above gets a change in their combo variable
func combo_number(pos: Vector2):
	var y = pos.y + 1
	while(y<Global.height):
		if(Global.pieces_table[pos.x][y].combo_Time != Global.passedTime + 0.75):
			Global.pieces_table[pos.x][y].combo += 1
		Global.pieces_table[pos.x][y].combo_Time = Global.passedTime + 0.75
		y += 1
	
#When there is at least a 2x combo, it starts the animation
func combo_anim(pos:Vector2, combo_nb: int):
	var combo_piece = preload("res://Pieces/ComboCounter.tscn").instance()
	combo_piece.combo_nb = combo_nb
	var create_grid = Global.parent_node.grid_creator
	Global.parent_node.add_child(combo_piece)
	combo_piece.position = create_grid.piece_position(pos.x, pos.y)
	stop_time()
	
	
