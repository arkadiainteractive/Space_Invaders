extends Node3D

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
var type_of_collapse

func _ready() -> void:
	type_of_collapse = randi() % 2 + 1
	print ("TIPO DE COLAPSO: ", type_of_collapse)

func _on_area_3d_body_entered(body: Node3D) -> void:
	$RigidBody3D/Area3D/Dust_ball.emitting = true
	if type_of_collapse == 1:
		animationPlayer.play("collapse")
	if type_of_collapse == 2:
		animationPlayer.play("collapse_2")
