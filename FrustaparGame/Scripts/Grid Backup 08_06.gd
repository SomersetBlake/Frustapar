extends Node2D

export var width: = 6
export var height: = 12
export var offset: = 16
export var size: = 32
export var start_x: = 0
export var start_y: = 672
export var speed: = 5

var pieces_table: = []
var pieces_packed =[
	preload("res://Pieces/Air.tscn"),
	preload("res://Pieces/Earth.tscn"),
	preload("res://Pieces/Water.tscn"),
	preload("res://Pieces/Fire.tscn"),
	preload("res://Pieces/Electricity.tscn")
]
onready var empty_piece = preload("res://Pieces/EmptyPiece.tscn")
var added_rows = 0
var first_pos = Vector2(-1,-1)

func _ready() -> void:
	randomize()
	pieces_table = create_array()
	position.y = 64
	create_grid()

	
func _physics_process(delta: float) -> void:
	position.y -= speed * delta	

	if(Input.is_action_just_pressed("ui_click")):
		first_pos = get_global_mouse_position()
	
	if(Input.is_action_just_released("ui_click")):
		mouse_movement()


func create_array():
	var array = []
	for x in range(width):
		array.append([])
		for y in (height):
			array[x].append(0)
	return array
	
func create_grid():
	var y = 0
	for x in width:
		y = 0
		while(y < height):
			var random_nb = floor(rand_range(0,5))
			var piece = pieces_packed[random_nb].instance()
			add_child(piece)
			piece.position = piece_position(x, y)
			pieces_table[x][y] = piece
			if(is_matching(piece_match(x,y))):
				pieces_table[x][y].queue_free()
				y -= 1
			y += 1
				
			
func piece_position(column, row):
	var x = size * column + offset
	var y = start_y + (added_rows * size) - offset - size * row
	return Vector2(x,y)
	
func position_to_grid(element_position: Vector2):
	if(is_in_grid(element_position)):
		var max_y = self.position.y + size * (height + added_rows)
		var min_x = self.position.x
		var row = int((max_y - element_position.y )/32)
		var column = int((element_position.x - min_x)/32)
		return Vector2(column,row)
	return null
			
#Returns an array containing how many of the same types of pieces are in a direction
#[0] = up, [1] = down, [2] = right, [3] = left
func piece_match(column, row):
	var array = []
	var nb = 0
	var i = row + 1
	while(i < height):
		if(typeof(pieces_table[column][i]) == TYPE_OBJECT):
			if(pieces_table[column][i].piece_type == pieces_table[column][row].piece_type):
				nb += 1
			else:
				break
		i += 1
	array.append(nb)
	nb = 0
	i = row - 1
	while(i >= 0):
		if(typeof(pieces_table[column][i]) == TYPE_OBJECT):
			if(pieces_table[column][i].piece_type == pieces_table[column][row].piece_type):
				nb += 1
			else:
				break
		i -= 1
	array.append(nb)
	nb = 0
	i = column + 1
	while(i < width):
		if(typeof(pieces_table[i][row]) == TYPE_OBJECT):
			if(pieces_table[i][row].piece_type == pieces_table[column][row].piece_type):
				nb += 1
			else:
				break
		i += 1
	array.append(nb)
	nb = 0
	i = column - 1
	while(i >= 0):
		if(typeof(pieces_table[i][row]) == TYPE_OBJECT):
			if(pieces_table[i][row].piece_type == pieces_table[column][row].piece_type):
				nb += 1
			else:
				break
		i -= 1
	array.append(nb)
	return array

func is_matching(array) -> bool:
	if(array[0] + array[1] > 1):
		return true
	if(array[2] + array [3] > 1):
		return true
	else: 
		return false

func tag_matching(pos: Vector2):
	var array = piece_match(pos.x, pos.y)
	if(is_matching(array)):
		make_empty(pos)
		if(array[0] + array[1] > 1):
			for y in array[0]:
				make_empty(Vector2(pos.x, pos.y + 1 + y))
			for y in array[1]:
				make_empty(Vector2(pos.x, pos.y - 1 - y))
		if(array[2] + array[3] > 1):
			for x in array[2]:
				make_empty(Vector2(pos.x + 1 + x, pos.y))
			for x in array[3]:
				make_empty(Vector2(pos.x - 1 - x, pos.y))

func make_empty(pos: Vector2):
	var piece_pos = pieces_table[pos.x][pos.y].position
	pieces_table[pos.x][pos.y].queue_free()
	var piece = empty_piece.instance()
	add_child(piece)
	piece.position = piece_pos
	pieces_table[pos.x][pos.y] = piece

func is_in_grid(element_position: Vector2):
	var min_y = self.position.y  + size * added_rows
	var max_y = self.position.y + size * (height + added_rows)
	var min_x = self.position.x
	var max_x = self.position.x + size * width
	
	if(element_position.y > min_y && element_position.y < max_y):
		if(element_position.x > min_x && element_position.x < max_x):
			return true
		else:
			return false
	else:
		return false

func create_line():
	added_rows += 1
	for x in width:
		var previous = pieces_table[x][0]
		var container = pieces_table[x][0]	
		var y = 1
		while(y < height ):
			container = pieces_table[x][y]
			pieces_table[x][y] = previous
			previous = container
			y += 1
		
		y = 0
		while(y < 2):
			var random_nb = floor(rand_range(0,5))
			var piece = pieces_packed[random_nb].instance()
			add_child(piece)
			piece.position = piece_position(x, 0)
			pieces_table[x][0] = piece
			if(is_matching(piece_match(x,0))):
				pieces_table[x][0].queue_free()
				y = 0
			y += 1

#Changes position of a piece based on the direction of mouse
func mouse_movement():
	var release_pos = get_global_mouse_position() 
	var piece_pos = null
	var stored_piece
	var stored_pos 
	if(is_in_grid(first_pos)):
		piece_pos = position_to_grid(first_pos)
	else:
		piece_pos = null
	if(abs(first_pos.y - release_pos.y) < 50):
		if(first_pos.x - release_pos.x > 0 && piece_pos != null):
			if(piece_pos.x - 1 >= 0):
				stored_piece = pieces_table[piece_pos.x][piece_pos.y] 
				stored_pos = pieces_table[piece_pos.x][piece_pos.y].position 
				pieces_table[piece_pos.x][piece_pos.y].position = pieces_table[piece_pos.x - 1][piece_pos.y].position
				pieces_table[piece_pos.x][piece_pos.y] = pieces_table[piece_pos.x - 1][piece_pos.y]
				pieces_table[piece_pos.x - 1][piece_pos.y].position = stored_pos
				pieces_table[piece_pos.x - 1][piece_pos.y] = stored_piece
				
				tag_matching(piece_pos)
				tag_matching(Vector2(piece_pos.x - 1, piece_pos.y))
		elif(first_pos.x - release_pos.x < 0 && piece_pos != null):
			if(piece_pos.x + 1 < 6 ):
				stored_piece = pieces_table[piece_pos.x][piece_pos.y] 
				stored_pos = pieces_table[piece_pos.x][piece_pos.y].position 
				pieces_table[piece_pos.x][piece_pos.y].position = pieces_table[piece_pos.x + 1][piece_pos.y].position
				pieces_table[piece_pos.x][piece_pos.y] = pieces_table[piece_pos.x + 1][piece_pos.y]
				pieces_table[piece_pos.x + 1][piece_pos.y].position = stored_pos
				pieces_table[piece_pos.x + 1][piece_pos.y] = stored_piece
				
				tag_matching(piece_pos)
				tag_matching(Vector2(piece_pos.x + 1, piece_pos.y))				
		else:
			pass
	
