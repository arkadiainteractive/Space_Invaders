extends MeshInstance3D

func _ready() -> void:
	$AnimationPlayer2.play("explosion")


func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	queue_free()
