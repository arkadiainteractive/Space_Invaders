extends CharacterBody3D

const SPEED = 5.0
const VELOCITY = 20

func _ready() -> void:
	print ("FIRE READY")

func _physics_process(delta: float) -> void:
	velocity.y = +VELOCITY
	print ("POSITION: ", position)
	move_and_slide()
