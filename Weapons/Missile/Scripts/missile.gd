extends CharacterBody3D

const SPEED = 5.0
const VELOCITY = 10

func _physics_process(delta: float) -> void:
	move_and_slide()
