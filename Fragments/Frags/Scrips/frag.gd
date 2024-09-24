extends Node3D

var frag_scene
var frag_instance

func _ready() -> void:
	frag_scene = load("res://Fragments/BasicFragment/Scenes/basic_fragment.tscn")
	$"..".connect("exploded", _on_exploded_signal)

func Start() -> void:
	frag_instance = frag_scene.instantiate()
	frag_instance.position = global_position
	apply_random_force(frag_instance)
	#frag_instance.apply_impulse(Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized(), Vector3(0,0,0))
	get_tree().current_scene.add_child(frag_instance)

func _on_exploded_signal():
	Start()

func apply_random_force(fragment: RigidBody3D):
	var force_magnitude: float = randf_range(1, 50)
	# Genera un Vector3 con componentes aleatorias entre -1 y 1
	var random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()

	# Multiplica el vector normalizado por la magnitud de la fuerza deseada
	var force = random_direction * force_magnitude

	# Aplica la fuerza al fragmento
	fragment.apply_impulse(force, Vector3.ZERO)
