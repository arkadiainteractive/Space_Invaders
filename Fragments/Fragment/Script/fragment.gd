class_name Fragment extends RigidBody3D

@onready var timer = $Timer
var color = Color (1,1,1)
var col_layer
var col_mask

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fragment = get_node("fragment") as MeshInstance3D
	var material = fragment.mesh.surface_get_material(0)  # 0 es el índice de la superficie
	material.albedo_color = color
	col_layer = collision_layer
	col_mask = collision_mask

func set_color(new_color : Color):
	color = new_color

func get_color ():
	return color

func _on_timer_timeout() -> void:
	timer.stop()
	hide_fragment()
	linear_velocity = Vector3.ZERO  # Asegúrate de que no retenga velocidad
	angular_velocity = Vector3.ZERO  # Reinicia la rotación
	sleeping = true  # Reinicia su estado físico
	#queue_free()

func hide_fragment():
	freeze = true
	sleeping = true
	collision_layer = 0
	collision_mask = 0
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	hide()

func show_fragment():
	freeze = false
	sleeping = false
	collision_layer = col_layer
	collision_mask = col_mask
	var random_number = randf_range(1, 4)
	timer.start(random_number)
	show()

func is_hidden():
	if !visible:
		return true
