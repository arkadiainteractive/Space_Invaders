extends RigidBody3D

@onready var timer = $Timer
var color = Color (1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_number = randf_range(1, 4)
	timer.start(random_number)

	var gradient = Gradient.new()
	# Añadir el primer punto de control (el color inicial, sin transparencia)
	gradient.add_point(0.0, color)
	# Añadir el segundo punto de control (el color hacia transparente)
	# Mantenemos el mismo color, pero hacemos alfa = 0 (totalmente transparente)
	gradient.add_point(1.0, Color(color.r, color.g, color.b, 0))
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	$GPUTrail3D.texture = gradient_texture

func set_color(new_color : Color):
	color = new_color

func get_color ():
	return color
 
func _on_timer_timeout() -> void:
	queue_free()
