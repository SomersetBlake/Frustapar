extends Node2D


onready var combo_anim = $AnimationPlayer
export var combo_nb = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(combo_nb < 10):
		get_node("Label").text = "x" + String(combo_nb)
	elif(combo_nb > 10 && combo_nb < 100):
		get_node("Label").text = String(combo_nb)
	combo_anim.play("Combo")
	get_node("ComboCounter").play()

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	var explosion = preload("res://Pieces/ExplosionAnimation.tscn").instance()
	yield(Global.parent_node.get_tree().create_timer(1),"timeout")
	Global.parent_node.add_child(explosion)
	explosion.global_position = get_node("Sprite").global_position
	queue_free()
