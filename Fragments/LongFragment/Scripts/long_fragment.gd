extends RigidBody3D



@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_number = randf_range(1, 4)
	timer.start(random_number)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	queue_free()
