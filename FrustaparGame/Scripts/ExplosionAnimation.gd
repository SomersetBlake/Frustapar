extends Node2D


onready var animatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animatedSprite.frame = 0
	animatedSprite.play("Explosion")


func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
