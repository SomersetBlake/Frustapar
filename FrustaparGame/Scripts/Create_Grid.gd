extends Node

var parent_node = Node2D
var matching_node

func create():
	matching_node = preload('res://Scripts/Matching.gd').new()
	print("SomethingWorks")
	randomize()
	Global.pieces_table = create_array()
	create_grid()
	Global.parent_node.position.y = Global.start_pos + 64
	

func create_array():
	var array = []
	for x in range(Global.width):
		array.append([])
		for y in (Global.height):
			array[x].append(0)
	return array

func create_grid():
	var y = 0
	for x in Global.width:
		y = 0
		while(y < Global.height):
			var random_nb = floor(rand_range(0,5))
			var piece = Global.pieces_packed[random_nb].instance()
			Global.parent_node.add_child(piece)
			piece.position = piece_position(x, y)
			Global.pieces_table[x][y] = piece
			Global.pieces_table[x][y].node_pos = piece.position
			if(matching_node.is_matching(x,y)):
				Global.pieces_table[x][y].queue_free()
				y -= 1
			y += 1

func piece_position(column, row):
	var x = Global.size * column + Global.offset
	var y = Global.start_y + (Global.added_rows * Global.size) - Global.offset - Global.size * row
	return Vector2(x,y)

func position_to_grid(element_position: Vector2) -> Vector2:
	if(is_in_grid(element_position)):
		var max_y = Global.parent_node.position.y + Global.size * (Global.height + Global.added_rows)
		var min_x = Global.parent_node.position.x
		var row = int((max_y - element_position.y )/32)
		var column = int((element_position.x - min_x)/32)
		return Vector2(column,row)
	return Vector2(0,0)

func is_in_grid(element_position: Vector2):
	var min_y = Global.parent_node.position.y  + Global.size * Global.added_rows
	var max_y = Global.parent_node.position.y + Global.size * (Global.height + Global.added_rows)
	var min_x = Global.parent_node.position.x
	var max_x = Global.parent_node.position.x + Global.size * Global.width
	if(element_position.y > min_y && element_position.y < max_y):
		if(element_position.x > min_x && element_position.x < max_x):
			return true
		else:
			return false
	else:
		return false	

func write_something(pos: Vector2) -> Vector2:
	print("Somethinhg")
	print(pos.x)
	return pos
