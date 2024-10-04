extends RigidBody3D

@onready var timer = $Timer
@export var color = Color (1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_number = randf_range(1, 4)
	timer.start(random_number)
	#color = $fragment_2x2x2.albedo_color
	$GPUParticles3D.albedo_color = color

func _on_timer_timeout() -> void:
	queue_free()
