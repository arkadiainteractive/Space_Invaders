extends Node3D

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	$RigidBody3D/Area3D/Dust_ball.emitting = true
	animationPlayer.play("collapse")
