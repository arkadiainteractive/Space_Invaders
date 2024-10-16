extends Node3D

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	animationPlayer.play("collapse")
	#$RigidBody3D/Building_1_damage.visible = true
	#$RigidBody3D/Building_1.visible = false
	#$RigidBody3D/Dust_grey.emitting = true
	#$RigidBody3D/Dust_white.emitting = true
