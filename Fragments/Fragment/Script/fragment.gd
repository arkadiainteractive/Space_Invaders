class_name Fragment extends RigidBody3D

@onready var timer = $Timer
var color = Color (1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_number = randf_range(1, 4)
	timer.start(random_number)

	var fragment = get_node("fragment") as MeshInstance3D
	var material = fragment.mesh.surface_get_material(0)  # 0 es el índice de la superficie
	#print ("COLOR EN EL FRAG: ", color)
	material.albedo_color = color

func set_color(new_color : Color):
	color = new_color

func get_color ():
	return color

func _on_timer_timeout() -> void:
	queue_free()
