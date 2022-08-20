extends Node2D

var speed: = 10
var levelSpeed = 10
var child_count = 0
var width: = 6
var height: = 14
var offset: = 16
var size: = 32
var start_pos: = 316
var start_y: = 448
var last_row = -12
#var _timer = null
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
var can_move_Y = true
var movable_down = true
var parent_node = Node2D
var gameEnded = false
var matchedNumber = 0
var passedTime = 0
var waitTime = 0
var score = 0
var exist_glass = false
var level = 1
var stopped = false
