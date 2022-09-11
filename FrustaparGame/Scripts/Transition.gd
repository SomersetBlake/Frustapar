extends Node2D


func change_scene(target: String) -> void:
	$TransitionLayer/AnimationPlayer.play("transition")
	yield($TransitionLayer/AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$TransitionLayer/AnimationPlayer.play_backwards("transition")
	if(TitleTheme.get_node("/root/TitleTheme").playing == false):
		TitleTheme.get_node("/root/TitleTheme").play()
