extends Node2D


onready var pieceMatch_anim = $AnimationPlayer
export var match_nb = 1

func _ready() -> void:
	get_node("Label").text = String(match_nb)
	pieceMatch_anim.play("Combo")
	get_node("CounterSound").play()


func _on_AnimationPlayer_animation_finished(anim_name):
	var explosion = preload("res://Pieces/ExplosionAnimation.tscn").instance()
	yield(Global.parent_node.get_tree().create_timer(1),"timeout")	
	Global.parent_node.add_child(explosion)
	explosion.global_position = get_node("Sprite").global_position
	queue_free()
