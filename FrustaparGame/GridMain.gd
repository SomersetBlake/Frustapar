extends Node2D


onready var grid_creator = preload('res://Scripts/Create_Grid.gd').new()
onready var grid_movement = preload('res://Scripts/Movement.gd').new()
onready var matching_node = preload('res://Scripts/Matching.gd').new()
onready var grid_end = preload('res://Scripts/EndGame.gd').new()

var _timer = Node2D

func _ready():
	Global.parent_node = self
	Global.speed = Global.levelSpeed[Global.selectedLevel - 1]
	position.y = Global.start_pos
	grid_creator.create()
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.25)
	_timer.set_one_shot(false)
	_timer.start()
	
func _physics_process(delta: float) -> void:
	if(Global.gameEnded == false):
		position.y -= Global.speed * delta	
		if(Global.movable_down):
			grid_movement.move_pieces_Y()
			grid_movement.move_down()
		if(Input.is_action_just_pressed("ui_click")):
			destroy_line()
			Global.first_pos = get_global_mouse_position()
			var _mouse_grid = grid_creator.position_to_grid(get_global_mouse_position())
#			print(Global.pieces_table[mouse_grid.x][mouse_grid.y].combo)

		if(Input.is_action_just_released("ui_click")):
			grid_movement.mouse_movement()
			for x in Global.width:
				for y in Global.height:
					matching_node.tag_matching(Vector2(x,y))
		Global.child_count = get_child_count()

func _on_Timer_timeout():
	Global.matchedNumber = 0
	Global.passedTime += 0.25
	if(Global.gameEnded):
		_timer.stop()
		return 		
	if(Global.movable_down):
		grid_movement.move_pieces_Y()
		grid_movement.move_down()
	for x in Global.width:
		for y in Global.height:
			matching_node.tag_matching(Vector2(x,y))
	reset_combo()
	repair_black_boxes()
	grid_end.low_pieces()
	grid_end.end_game()
	print(Global.speed)


func destroy_line():
	grid_movement.move_down()
	var y = Global.height - 1
	var nb = 0
	nb = 0
	for x in Global.width:
		if(Global.pieces_table[x][y].piece_type == "empty"):
			nb += 1
		else:
			break
		if(nb == Global.width):
			for i in Global.width:
				Global.pieces_table[i][y].queue_free()
			create_line()


func create_line():
	Global.start_pos = Global.start_pos - Global.size
	Global.added_rows += 1
	for x in Global.width:
		var previous = Global.pieces_table[x][0]
		var container = Global.pieces_table[x][0]	
		var y = 1
		while(y < Global.height ):
			container = Global.pieces_table[x][y]
			Global.pieces_table[x][y] = previous
			previous = container
			y += 1
		y = 0
		while(y < 1):
			var random_nb = floor(rand_range(0,5))
			var piece = Global.pieces_packed[random_nb].instance()
			add_child(piece)
			piece.position = grid_creator.piece_position(x, 0)
			Global.pieces_table[x][0] = piece
			Global.pieces_table[x][0].node_pos = grid_creator.piece_position(x, 0)
			if(matching_node.is_matching(x,0)):
				Global.pieces_table[x][0].queue_free()
				y = 0
			else:
				y += 1
	grid_end.win_line()

#"Sometimes position of table_pieces changes before animation is finished. 
#If that happens wrong nodes are modulated to Color(0.5,0,1,1). 
#This function makes those nodes empty"				
func repair_black_boxes():
	for x in Global.width:
		for y in Global.height:
			if(Global.pieces_table[x][y].piece_type == "Tagged" && 
			Global.pieces_table[x][y].modulate == Color(0.5,0,1,1)):
				matching_node.make_empty(Vector2(x,y))

func reset_combo():
	for x in Global.width:
		for y in Global.height:
			if(Global.pieces_table[x][y].combo_Time <= Global.passedTime):
				Global.pieces_table[x][y].combo = 1
