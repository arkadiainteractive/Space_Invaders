extends Node3D

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	animationPlayer.play("collapse")
