extends Node2D

#export var width: = 6
#export var height: = 12
#export var offset: = 16
#export var size: = 32
#export var start_pos: = 0
#var start_y: = 384
#var speed: = 1
##var _timer = null
#var pieces_table: = []
#var pieces_packed =[
#	preload("res://Pieces/Air.tscn"),
#	preload("res://Pieces/Earth.tscn"),
#	preload("res://Pieces/Water.tscn"),
#	preload("res://Pieces/Fire.tscn"),
#	preload("res://Pieces/Electricity.tscn")
#]
#onready var empty_piece = preload("res://Pieces/EmptyPiece.tscn")
#var added_rows = 0
#var first_pos = Vector2(-1,-1)
#export var can_move_Y = true
#export var movable_down = true
#
#func _ready() -> void:
#	randomize()
#	pieces_table = create_array()
#	create_grid()
#	position.y = start_pos
#	var _timer = Timer.new()
#	add_child(_timer)
#	_timer.connect("timeout", self, "_on_Timer_timeout")
#	_timer.set_wait_time(0.25)
#	_timer.set_one_shot(false)
#	_timer.start()
#
#func _physics_process(delta: float) -> void:
#	position.y -= speed * delta	
#	speed = Global.speed
#	if(movable_down):
#		move_pieces_Y()
#		move_down()
#	if(Input.is_action_just_pressed("ui_click")):
#		destroy_line()
#		first_pos = get_global_mouse_position()
#		var grid_pos = position_to_grid(first_pos)
#		if(grid_pos != null):
#			pass
##			print(pieces_table[grid_pos.x][grid_pos.y].piece_type)
##			print(pieces_table[grid_pos.x][grid_pos.y].node_pos)
##			print(piece_position(grid_pos.x,grid_pos.y))
#
#	if(Input.is_action_just_released("ui_click")):
#		mouse_movement()
#		for x in width:
#			for y in height:
#				tag_matching(Vector2(x,y))
#	Global.child_count = get_child_count()
#
#func _on_Timer_timeout():
#	if(movable_down):
#		move_pieces_Y()
#		move_down()
#	for x in width:
#		for y in height:
#			tag_matching(Vector2(x,y))
#	end_game()
#	low_pieces()
#
#
#########################################################
#########################################################
#################### CREATING GRID ######################
#########################################################
#########################################################	
#
#func create_array():
#	var array = []
#	for x in range(width):
#		array.append([])
#		for y in (height):
#			array[x].append(0)
#	return array
#
#func create_grid():
#	var y = 0
#	for x in width:
#		y = 0
#		while(y < height):
#			var random_nb = floor(rand_range(0,5))
#			var piece = pieces_packed[random_nb].instance()
#			add_child(piece)
#			piece.position = piece_position(x, y)
#			pieces_table[x][y] = piece
#			pieces_table[x][y].node_pos = piece.position
#			if(is_matching(piece_match(x,y))):
#				pieces_table[x][y].queue_free()
#				y -= 1
#			y += 1
#
#func piece_position(column, row):
#	var x = size * column + offset
#	var y = start_y + (added_rows * size) - offset - size * row
#	return Vector2(x,y)
#
#func position_to_grid(element_position: Vector2):
#	if(is_in_grid(element_position)):
#		var max_y = self.position.y + size * (height + added_rows)
#		var min_x = self.position.x
#		var row = int((max_y - element_position.y )/32)
#		var column = int((element_position.x - min_x)/32)
#		return Vector2(column,row)
#	return null
#
#func is_in_grid(element_position: Vector2):
#	var min_y = self.position.y  + size * added_rows
#	var max_y = self.position.y + size * (height + added_rows)
#	var min_x = self.position.x
#	var max_x = self.position.x + size * width
#	if(element_position.y > min_y && element_position.y < max_y):
#		if(element_position.x > min_x && element_position.x < max_x):
#			return true
#		else:
#			return false
#	else:
#		return false	
#
#########################################################
#########################################################
################# MATCHING ELEMENTS #####################
#########################################################
#########################################################	
#
##Returns an array containing how many of the same types of pieces are in a direction
##[0] = up, [1] = down, [2] = right, [3] = left
#func piece_match(column, row):
#	var array = []
#	var nb = 0
#	var i = row + 1
#	if(pieces_table[column][row].piece_type != "empty"):
#		while(i < height):
#			if(typeof(pieces_table[column][i]) == TYPE_OBJECT):
#				if(pieces_table[column][i].piece_type == pieces_table[column][row].piece_type
#				&& pieces_table[column][i].matchable):
#					nb += 1
#				else:
#					break
#			i += 1
#		array.append(nb)
#		nb = 0
#		i = row - 1
#		while(i >= 0):
#			if(typeof(pieces_table[column][i]) == TYPE_OBJECT):
#				if(pieces_table[column][i].piece_type == pieces_table[column][row].piece_type
#				&& pieces_table[column][i].matchable):
#					nb += 1
#				else:
#					break
#			i -= 1
#		array.append(nb)
#		nb = 0
#		i = column + 1
#		while(i < width):
#			if(typeof(pieces_table[i][row]) == TYPE_OBJECT):
#				if(pieces_table[i][row].piece_type == pieces_table[column][row].piece_type
#				&& pieces_table[i][row].matchable):
#					nb += 1
#				else:
#					break
#			i += 1
#		array.append(nb)
#		nb = 0
#		i = column - 1
#		while(i >= 0):
#			if(typeof(pieces_table[i][row]) == TYPE_OBJECT):
#				if(pieces_table[i][row].piece_type == pieces_table[column][row].piece_type
#				&& pieces_table[i][row].matchable):
#					nb += 1
#				else:
#					break
#			i -= 1
#		array.append(nb)
#		return array
#	else:
#		array = [0,0,0,0]
#		return array
#
#func is_matching(array) -> bool:
#	if(array[0] + array[1] > 1):
#		return true
#	if(array[2] + array [3] > 1):
#		return true
#	else: 
#		return false
#
#func tag_matching(pos: Vector2):
#	var array = [0,0,0,0]
#	if(pieces_table[pos.x][pos.y].matchable):
#		array = piece_match(pos.x, pos.y)
#	if(is_matching(array)):
#		match_anim(pos, "White_Blink")
#		pieces_table[pos.x][pos.y].piece_type = "Tagged"
#		if(array[0] + array[1] > 1):
#			for y in array[0]:
#				pieces_table[pos.x][pos.y + 1 + y].piece_type = "Tagged"
#				match_anim(Vector2(pos.x, pos.y + 1 + y),"White_Blink")
#			for y in array[1]:
#				pieces_table[pos.x][pos.y -1 - y].piece_type = "Tagged"
#				match_anim(Vector2(pos.x, pos.y - 1 - y),"White_Blink")
#		if(array[2] + array[3] > 1):
#			for x in array[2]:
#				pieces_table[pos.x + 1 + x][pos.y].piece_type = "Tagged"
#				match_anim(Vector2(pos.x + 1 + x, pos.y),"White_Blink")
#			for x in array[3]:
#				pieces_table[pos.x -1 -x][pos.y].piece_type = "Tagged"
#				match_anim(Vector2(pos.x - 1 - x, pos.y),"White_Blink")
#
#func match_anim(pos: Vector2, anim_name):
#	var start_added_rows = added_rows
#	var anim_Sprite = pieces_table[pos.x][pos.y].get_node("Anim")
#	anim_Sprite.play(anim_name)
#	pieces_table[pos.x][pos.y].movable = false
#	yield(anim_Sprite, "animation_finished")
#	pieces_table[pos.x][pos.y].movable = true
#	if(start_added_rows == added_rows):
#		make_empty(pos)
#	elif(start_added_rows != added_rows):
#		make_empty(Vector2(pos.x, pos.y + added_rows - start_added_rows))
#
#func make_matchable():
#	yield(get_tree().create_timer(0.1),"timeout")
#	for x in width:
#		for y in height:
#			if(typeof(pieces_table[x][y]) == TYPE_OBJECT && pieces_table[x][y] != null):
#				pieces_table[x][y].matchable = true	
#
#########################################################
#########################################################
###################### MOVEMENT #########################
#########################################################
#########################################################
#
#func move_down():
#	var empty_nb = 0
#	for x in width:
#		empty_nb = 0
#		for y in height:
#			if(typeof(pieces_table[x][y]) == TYPE_OBJECT && pieces_table[x][y] != null):
#				if pieces_table[x][y].piece_type == "empty":
#					empty_nb += 1
#				elif(empty_nb != 0):
#					change_pos(Vector2(x,y), 0, empty_nb * -1)
#					pieces_table[x][y].matchable = false
#			else:
#				print("ERROR")
#
##Changes position of a piece based on the direction of mouse
#func mouse_movement():
#	var release_pos = get_global_mouse_position() 
#	var piece_pos = null
#	if(is_in_grid(first_pos)):
#		piece_pos = position_to_grid(first_pos)
#	else:
#		piece_pos = null
#	if(abs(first_pos.y - release_pos.y) < 25):
#		if(first_pos.x - release_pos.x > 0 && piece_pos != null):
#			if(piece_pos.x - 1 >= 0):
#				if(pieces_table[piece_pos.x][piece_pos.y].movable == true &&
#				pieces_table[piece_pos.x - 1][piece_pos.y].movable == true):				
#					change_pos(piece_pos, -1, 0)
#					tag_matching(piece_pos)
#					tag_matching(Vector2(piece_pos.x - 1, piece_pos.y))
#					move_down()
#		elif(first_pos.x - release_pos.x < 0 && piece_pos != null):
#			if(piece_pos.x + 1 < width ):
#				if(pieces_table[piece_pos.x][piece_pos.y].movable == true &&
#				pieces_table[piece_pos.x + 1][piece_pos.y].movable == true):
#					change_pos(piece_pos, 1, 0)
#					tag_matching(piece_pos)
#					tag_matching(Vector2(piece_pos.x + 1, piece_pos.y))
#					move_down()
#		else:
#			pass
#
#func change_pos(pos: Vector2, x: int, y: int):
#	if(pos.x + x < width && pos.x + x >= 0 && pos.y + y >= 0 && pos.y < height):
#		var changable = true
#		if( y != 0):
#			changable = pieces_table[pos.x][pos.y].movable_down
#		if(changable):
#			var stored_piece
#			stored_piece = pieces_table[pos.x][pos.y] 
#			pieces_table[pos.x][pos.y].matchable = false
#			pieces_table[pos.x + x][pos.y + y].matchable = false
#			pieces_table[pos.x][pos.y].node_pos = pieces_table[pos.x][pos.y].node_pos + Vector2(x*size,y*size * -1)
#			pieces_table[pos.x][pos.y] = pieces_table[pos.x + x][pos.y + y]
#			pieces_table[pos.x + x][pos.y + y].node_pos = pieces_table[pos.x + x][pos.y + y].node_pos - Vector2(x*size,y*size * -1)
#			pieces_table[pos.x + x][pos.y + y] = stored_piece
#			if(y != 0):
#				move_pieces_Y()
#			elif(x != 0):
#				pieces_table[pos.x][pos.y].movable_down = false
#				pieces_table[pos.x + x][pos.y + y].movable_down = false
#				move_pieces_X()
#
#func move_pieces_Y():
#	if(can_move_Y):
#		can_move_Y = false
#		var tween1
#		var tween_time = 0.3
#		for x in width:
#			for y in height:
#				if(pieces_table[x][y].position.y != pieces_table[x][y].node_pos.y):
#					tween1 = pieces_table[x][y].get_node("Tween")
#					tween1.interpolate_property(pieces_table[x][y], "position",
#					 pieces_table[x][y].position, pieces_table[x][y].node_pos,
#					 tween_time, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
#					tween1.start()
#		yield(get_tree().create_timer(tween_time),"timeout")
#		can_move_Y = true
#		make_matchable()
#
#func move_pieces_X():
#	var tween1
#	var tween_time = 0.1
#	for x in width:
#		for y in height:
#			if(pieces_table[x][y].position.x != pieces_table[x][y].node_pos.x):
#				tween1 = pieces_table[x][y].get_node("Tween")
#				tween1.interpolate_property(pieces_table[x][y], "position",
#				 pieces_table[x][y].position, pieces_table[x][y].node_pos,
#				 tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#				tween1.start()
#				make_movable_down(x,y,tween_time)
#		make_matchable()
#
#func make_movable_down(x,y,t):
#	yield(get_tree().create_timer(t),"timeout")
#	pieces_table[x][y].movable_down = true
#
#########################################################
#########################################################
#################### ClEANING LINES #####################
#########################################################
#########################################################
#
##Changes pieces to empty pieces
#func make_empty(pos: Vector2):
#	var piece_pos = pieces_table[pos.x][pos.y].position
#	pieces_table[pos.x][pos.y].queue_free()
#	var piece = empty_piece.instance()
#	add_child(piece)
#	piece.position = piece_pos
#	pieces_table[pos.x][pos.y] = piece
#	pieces_table[pos.x][pos.y].node_pos = piece_pos
#
#func destroy_line():
#	move_down()
#	var y = height - 1
#	var nb = 0
#	nb = 0
#	for x in width:
#		if(pieces_table[x][y].piece_type == "empty"):
#			nb += 1
#		else:
#			break
#		if(nb == width):
#			for i in width:
#				pieces_table[i][y].queue_free()
#			create_line()
#
#func create_line():
#	added_rows += 1
#	for x in width:
#		var previous = pieces_table[x][0]
#		var container = pieces_table[x][0]	
#		var y = 1
#		while(y < height ):
#			container = pieces_table[x][y]
#			pieces_table[x][y] = previous
#			previous = container
#			y += 1
#		y = 0
#		while(y < 1):
#			var random_nb = floor(rand_range(0,5))
#			var piece = pieces_packed[random_nb].instance()
#			add_child(piece)
#			piece.position = piece_position(x, 0)
#			pieces_table[x][0] = piece
#			pieces_table[x][0].node_pos = piece_position(x, 0)
#			if(is_matching(piece_match(x,0))):
#				pieces_table[x][0].queue_free()
#				y = 0
#			else:
#				y += 1
#
#########################################################
#########################################################
###################### GAME ENDING ######################
#########################################################
#########################################################
#func end_game():
#	for x in width:
#		if(pieces_table[x][height - 1].piece_type != "empty"):
#			if(pieces_table[x][height - 1].global_position.y <= 64 + size/2):
#				print("EndGame")
#				Global.speed = 0
#
#func low_pieces():
#	for x in width:
#		for y in height:
#			if(pieces_table[x][y].global_position.y >= 448 - size/2):
#				pieces_table[x][y].modulate = Color(0.2,0.2,0.2,1)
#			else:
#				pieces_table[x][y].modulate = Color(1,1,1,1)
