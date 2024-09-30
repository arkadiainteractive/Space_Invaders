extends Node3D

var frag_scene
var frag_instance
var mesh_instance
var material
var color : Color

func _ready() -> void:
	frag_scene = load("res://Fragments/LongFragment/Scenes/long_fragment.tscn")
	$"..".connect("missile_explosion", _on_missile_explosion_signal)

func _on_missile_explosion_signal():
	print ("--------------------------------------------------------- EXPLOSION ------------------------------------------------------------------")
	frag_instance = frag_scene.instantiate()
	frag_instance.position = global_position
	apply_random_force(frag_instance)

	mesh_instance = frag_instance.get_node("fragment_4x8x3")
	material = mesh_instance.mesh.surface_get_material(0)
	#material.albedo_color = $"../../..".color

	var new_material = material.duplicate()
	#new_material.albedo_color = $"../..".color
	# Asignar el nuevo material al fragmento

	mesh_instance.set_surface_override_material(0, new_material)
	get_tree().current_scene.add_child(frag_instance)

func apply_random_force(fragment: RigidBody3D):
	var force_magnitude: float = randf_range(1, 50)
	# Genera un Vector3 con componentes aleatorias entre -1 y 1
	var random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var random_torque = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))
	# Multiplica el vector normalizado por la magnitud de la fuerza deseada
	var force = random_direction * force_magnitude

	# Aplica la fuerza al fragmento
	fragment.apply_impulse(force, Vector3.ZERO)
	fragment.apply_torque(random_torque)
