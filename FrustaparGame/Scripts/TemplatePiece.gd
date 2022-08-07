extends Node2D

export (String) var piece_type
export (bool) var movable
export (bool) var matchable
export (Vector2) var node_pos
export (bool) var movable_down
export (int) var combo = 1 
export (float) var combo_Time = 0

func _on_Anim_animation_finished(_anim_name: String) -> void:
	pass
